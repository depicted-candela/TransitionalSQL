// src/iv_hardcoreCombinedProblem/i/Reserver.java
package iv_hardcoreCombinedProblem.i;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.ObjectMessage;
import javax.jms.Session;
import javax.jms.Topic;
import javax.jms.TopicConnection;
import javax.jms.TopicConnectionFactory;
import javax.jms.TopicSession;
import oracle.jdbc.OraclePreparedStatement;
import oracle.jms.AQjmsFactory;
import oracle.jms.AQjmsSession;
import oracle.ucp.admin.UniversalConnectionPoolManager;
import oracle.ucp.admin.UniversalConnectionPoolManagerImpl;
import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;

public class Reserver {

    private final PoolDataSource pds;
    private final TopicConnectionFactory tcf;
    // Use ConcurrentHashMap for thread-safe, high-performance batching without explicit synchronization blocks.
    private final Map<Integer, List<PartRequest>> pendingOrderBatches = new ConcurrentHashMap<>();
    private final Map<Integer, Long> lastMessageTime = new ConcurrentHashMap<>();
    private volatile boolean running = true;
    private final ScheduledExecutorService scheduler;
    private final ExecutorService processingExecutor;
    private final DateTimeFormatter logTimestampFormatter = 
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").withZone(ZoneId.of("UTC"));

    private enum LogLevel { INFO, WARN, ERROR }
    
    // (Logging methods remain unchanged)
    private void log(LogLevel level, String message) { System.out.printf("%s [%-5s] %s%n", logTimestampFormatter.format(Instant.now()), level, message); }
    private void log(LogLevel level, String message, Throwable t) {
        synchronized(System.err) {
            var sw = new StringWriter();
            var pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            System.err.printf("%s [%-5s] %s%n--- Stack Trace ---%n%s--- End Stack Trace ---%n", logTimestampFormatter.format(Instant.now()), level, message + ": " + t.getMessage(), sw.toString());
        }
    }
    
    public Reserver() throws SQLException, JMSException {
        log(LogLevel.INFO, "Service initializing...");
        pds = PoolDataSourceFactory.getPoolDataSource();
        pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
        pds.setURL(HorizonsConfig.DB_URL);
        pds.setUser(HorizonsConfig.DB_USER);
        pds.setPassword(HorizonsConfig.DB_PASSWORD);
        pds.setInitialPoolSize(5);
        pds.setMinPoolSize(5);
        pds.setMaxPoolSize(20);
        pds.setConnectionPoolName(HorizonsConfig.UCP_POOL_NAME);
        
        this.tcf = AQjmsFactory.getTopicConnectionFactory(pds);
        this.scheduler = Executors.newSingleThreadScheduledExecutor();
        this.processingExecutor = Executors.newFixedThreadPool(5);
        
        cleanupSubscription();
        log(LogLevel.INFO, "Initialization complete.");
    }
    
    private void cleanupSubscription() throws JMSException {
        log(LogLevel.INFO, "Attempting to clean up previous durable subscription: " + HorizonsConfig.SUBSCRIPTION_NAME);
        try (var connection = tcf.createTopicConnection()) {
            connection.setClientID(HorizonsConfig.CLIENT_ID);
            connection.start();
            try (var session = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE)) {
                var aqSession = (AQjmsSession) session;
                Topic topic = aqSession.createTopic(HorizonsConfig.QUEUE_NAME);
                MessageConsumer consumerToClose = aqSession.createDurableSubscriber(topic, HorizonsConfig.SUBSCRIPTION_NAME, null, false, PartRequest.getORADataFactory());
                consumerToClose.close();
                session.unsubscribe(HorizonsConfig.SUBSCRIPTION_NAME);
                log(LogLevel.INFO, "Successfully unsubscribed from previous session.");
            }
        } catch (JMSException e) {
            if (e.getMessage() != null && e.getMessage().contains("JMS-232")) {
                 log(LogLevel.INFO, "Subscription did not previously exist (normal for a first run).");
            } else {
                 log(LogLevel.WARN, "Could not clean up subscription, which may be okay on first run.", e);
            }
        }
    }
    
    public void startListening() throws SQLException {
        scheduler.scheduleAtFixedRate(this::processTimedOutBatches, HorizonsConfig.BATCH_TIMEOUT_MS, HorizonsConfig.BATCH_TIMEOUT_MS, TimeUnit.MILLISECONDS);
        log(LogLevel.INFO, "Service started. Listening for messages on " + HorizonsConfig.QUEUE_NAME);
        try (var connection = tcf.createTopicConnection()) {
            connection.setClientID(HorizonsConfig.CLIENT_ID);
            connection.start(); 
            try (var session = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE)) {
                var aqSession = (AQjmsSession) session;
                Topic topic = aqSession.createTopic(HorizonsConfig.QUEUE_NAME);
                MessageConsumer consumer = aqSession.createDurableSubscriber(topic, HorizonsConfig.SUBSCRIPTION_NAME, null, false, PartRequest.getORADataFactory());
                
                log(LogLevel.INFO, "Durable subscriber created successfully. Waiting for messages...");
                while (running) {
                    Message message = consumer.receive(1000); 
                    if (message instanceof ObjectMessage) {
                        try {
                            PartRequest req = (PartRequest) ((ObjectMessage) message).getObject();
                            
                            // Using computeIfAbsent is an atomic, thread-safe way to initialize the list.
                            List<PartRequest> batch = pendingOrderBatches.computeIfAbsent(req.getOrderId(), k -> {
                                log(LogLevel.INFO, "New reservation workflow started for Order ID: " + k);
                                return new ArrayList<>(); // The list itself isn't thread-safe, so we synchronize on it below
                            });
                            
                            // Synchronize on the specific batch list for this order to safely add to it.
                            synchronized(batch) {
                                batch.add(req);
                            }
                            lastMessageTime.put(req.getOrderId(), System.currentTimeMillis());
                            log(LogLevel.INFO, String.format("  -> Queued Part ID: %-4d (Quantity: %d) for Order ID: %d", req.getPartId(), req.getQuantity(), req.getOrderId()));

                        } catch (JMSException e) {
                            if (running) log(LogLevel.ERROR, "Error deserializing message", e);
                        }
                    }
                }
                log(LogLevel.INFO, "Listener loop has exited.");
            }
        } catch (JMSException e) {
            if(running) log(LogLevel.ERROR, "A fatal error occurred in the listener. Shutting down.", e);
        } finally {
            shutdown();
        }
    }

    private void processTimedOutBatches() {
        if (!running) return;
        long currentTime = System.currentTimeMillis();
        // Iterate over a snapshot of keys to avoid ConcurrentModificationException
        for (Integer orderId : lastMessageTime.keySet()) {
            if (currentTime - lastMessageTime.get(orderId) > HorizonsConfig.BATCH_TIMEOUT_MS) {
                // remove() is thread-safe on ConcurrentHashMap
                List<PartRequest> batch = pendingOrderBatches.remove(orderId);
                lastMessageTime.remove(orderId);
                if (batch != null) {
                    processingExecutor.submit(() -> processBatchWithPipelining(orderId, batch));
                }
            }
        }
    }
    
    public void shutdown() {
        if (!running) return;
        log(LogLevel.INFO, "\nShutdown signal received. Shutting down gracefully...");
        this.running = false;
        scheduler.shutdown();
        log(LogLevel.INFO, "Scheduler shut down.");

        log(LogLevel.INFO, "Processing final outstanding batches...");
        pendingOrderBatches.forEach((orderId, batch) -> {
            log(LogLevel.INFO, "Submitting final batch for Order ID: " + orderId);
            processingExecutor.submit(() -> processBatchWithPipelining(orderId, batch));
        });

        log(LogLevel.INFO, "Awaiting termination of processing thread pool...");
        processingExecutor.shutdown();
        try {
            if (!processingExecutor.awaitTermination(60, TimeUnit.SECONDS)) {
                log(LogLevel.WARN, "Processing pool did not terminate in 60 seconds. Forcing shutdown...");
                processingExecutor.shutdownNow();
            }
        } catch (InterruptedException e) {
            processingExecutor.shutdownNow();
            Thread.currentThread().interrupt();
        }

        log(LogLevel.INFO, "Stopping database connection pool: " + HorizonsConfig.UCP_POOL_NAME);
        try {
            UniversalConnectionPoolManager mgr = UniversalConnectionPoolManagerImpl.getUniversalConnectionPoolManager();
            mgr.stopConnectionPool(HorizonsConfig.UCP_POOL_NAME);
            log(LogLevel.INFO, "Database connection pool stopped successfully.");
        } catch (Exception e) {
            log(LogLevel.ERROR, "Error stopping connection pool", e);
        }
        log(LogLevel.INFO, "Shutdown complete.");
    }
    
    // (processBatchWithPipelining and main methods are unchanged, but use config and logging)
    public void processBatchWithPipelining(int orderId, List<PartRequest> batch) {
        log(LogLevel.INFO, "Starting DB transaction for Order ID " + orderId + " with " + batch.size() + " part(s).");
        try (var conn = pds.getConnection()) {
            conn.setAutoCommit(false);
            String sql = "UPDATE horizons.inventory SET onHandQuantity = onHandQuantity - ?, reservedQuantity = reservedQuantity + ? WHERE partId = ?";
            try (var opstmt = conn.prepareStatement(sql).unwrap(OraclePreparedStatement.class)) {
                for (var req : batch) {
                    opstmt.setInt(1, req.getQuantity());
                    opstmt.setInt(2, req.getQuantity());
                    opstmt.setInt(3, req.getPartId());
                    opstmt.executeUpdateAsyncOracle(); 
                }
                log(LogLevel.INFO, "All " + batch.size() + " updates for Order ID " + orderId + " pipelined. Committing transaction.");
                conn.commit();
                log(LogLevel.INFO, "SUCCESS: Transaction committed for Order ID " + orderId + ".");
            } catch (SQLException e) {
                log(LogLevel.ERROR, "FAILURE: SQL error during batch for Order ID " + orderId + ". Rolling back.", e);
                conn.rollback();
            }
        } catch (SQLException e) {
            log(LogLevel.ERROR, "FAILURE: Could not get DB connection for Order ID " + orderId, e);
        }
    }

    public static void main(String[] args) {
        try {
            final var service = new Reserver();
            Runtime.getRuntime().addShutdownHook(new Thread(service::shutdown));
            service.startListening();
        } catch (Exception e) { 
            System.err.println("CRITICAL: Failed to initialize the reservation service.");
            e.printStackTrace();
        }
    }
}