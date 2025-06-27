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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1";
    private static final String DB_USER = "horizons";
    private static final String DB_PASSWORD = "YourPassword";
    private static final String QUEUE_NAME = "HORIZONS.PARTREQUESTTOPIC";
    private static final long BATCH_TIMEOUT_MS = 1500;
    private static final String SUBSCRIPTION_NAME = "PartReservationService";
    private static final String CLIENT_ID = "PartReservationClient";
    private static final String UCP_POOL_NAME = "ReserverConnectionPool";

    private final PoolDataSource pds;
    private final TopicConnectionFactory tcf;
    private final Map<Integer, List<PartRequest>> pendingOrderBatches = new HashMap<>();
    private final Map<Integer, Long> lastMessageTime = new HashMap<>();
    private volatile boolean running = true;
    private final ScheduledExecutorService scheduler;
    private final ExecutorService processingExecutor;
    private final DateTimeFormatter logTimestampFormatter = 
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").withZone(ZoneId.of("UTC"));

    private enum LogLevel { INFO, WARN, ERROR }
    
    private void log(LogLevel level, String message) {
        System.out.printf("%s [%-5s] %s%n", 
            logTimestampFormatter.format(Instant.now()), 
            level, 
            message);
    }
    
    private void log(LogLevel level, String message, Throwable t) {
        synchronized(System.err) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            System.err.printf("%s [%-5s] %s%n--- Stack Trace ---%n%s--- End Stack Trace ---%n", 
                logTimestampFormatter.format(Instant.now()), 
                level, 
                message + ": " + t.getMessage(), 
                sw.toString());
        }
    }
    
    public Reserver() throws SQLException, JMSException {
        log(LogLevel.INFO, "Service initializing...");
        log(LogLevel.INFO, "Configuring Universal Connection Pool...");
        pds = PoolDataSourceFactory.getPoolDataSource();
        pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
        pds.setURL(DB_URL);
        pds.setUser(DB_USER);
        pds.setPassword(DB_PASSWORD);
        pds.setInitialPoolSize(5);
        pds.setMinPoolSize(5);
        pds.setMaxPoolSize(20);
        pds.setConnectionPoolName(UCP_POOL_NAME);
        
        log(LogLevel.INFO, "Configuring AQ JMS Connection Factory...");
        this.tcf = AQjmsFactory.getTopicConnectionFactory(pds);

        this.scheduler = Executors.newSingleThreadScheduledExecutor();
        this.processingExecutor = Executors.newFixedThreadPool(5);
        
        cleanupSubscription();
        log(LogLevel.INFO, "Initialization complete.");
    }
    
    private void cleanupSubscription() throws JMSException {
        log(LogLevel.INFO, "Attempting to clean up previous durable subscription: " + SUBSCRIPTION_NAME);
        try (var connection = tcf.createTopicConnection()) {
            connection.setClientID(CLIENT_ID);
            connection.start();
            try (var session = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE)) {
                // THE FIX: Cast to AQjmsSession and use the Oracle-specific API overload.
                var aqSession = (AQjmsSession) session;
                Topic topic = aqSession.createTopic(QUEUE_NAME);
                
                log(LogLevel.INFO, "Re-attaching to subscription to close it...");
                // Use the overload that accepts the payload factory, just like in the main loop.
                MessageConsumer consumerToClose = aqSession.createDurableSubscriber(
                    topic, 
                    SUBSCRIPTION_NAME,
                    null,
                    false,
                    PartRequest.getORADataFactory()
                );
                
                consumerToClose.close();
                log(LogLevel.INFO, "Consumer closed.");

                // Now that the consumer is properly created and closed, unsubscribe will work.
                session.unsubscribe(SUBSCRIPTION_NAME);
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
        scheduler.scheduleAtFixedRate(this::processTimedOutBatches, BATCH_TIMEOUT_MS, BATCH_TIMEOUT_MS, TimeUnit.MILLISECONDS);
        log(LogLevel.INFO, "Service started. Listening for messages on " + QUEUE_NAME);
        try (var connection = tcf.createTopicConnection()) {
            connection.setClientID(CLIENT_ID);
            connection.start(); 

            try (var session = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE)) {
                var aqSession = (AQjmsSession) session;
                Topic topic = aqSession.createTopic(QUEUE_NAME);
                MessageConsumer consumer = aqSession.createDurableSubscriber(
                    topic, 
                    SUBSCRIPTION_NAME, 
                    null,
                    false,
                    PartRequest.getORADataFactory()
                );
                
                log(LogLevel.INFO, "Durable subscriber created successfully. Waiting for messages...");
                while (running) {
                    Message message = consumer.receive(1000); 
                    if (message instanceof ObjectMessage) {
                        try {
                            PartRequest req = (PartRequest) ((ObjectMessage) message).getObject();
                            
                            synchronized(pendingOrderBatches) {
                               if (!pendingOrderBatches.containsKey(req.getOrderId())) {
                                   log(LogLevel.INFO, "New reservation workflow started for Order ID: " + req.getOrderId());
                               }
                               log(LogLevel.INFO, String.format("  -> Queued Part ID: %-4d (Quantity: %d) for Order ID: %d", req.getPartId(), req.getQuantity(), req.getOrderId()));
                               pendingOrderBatches.computeIfAbsent(req.getOrderId(), k -> new ArrayList<>()).add(req);
                               lastMessageTime.put(req.getOrderId(), System.currentTimeMillis());
                            }
                        } catch (JMSException e) {
                            if (running) log(LogLevel.ERROR, "Error deserializing message", e);
                        }
                    }
                }
                log(LogLevel.INFO, "Listener loop has exited.");
            }
        } catch (JMSException e) {
            if(running) {
                log(LogLevel.ERROR, "A fatal error occurred in the listener. Shutting down.", e);
            }
        } finally {
            shutdown();
        }
    }

    private void processTimedOutBatches() {
        if (!running) return;
        long currentTime = System.currentTimeMillis();
        var ordersToProcess = new ArrayList<Integer>();
        
        synchronized(pendingOrderBatches) {
            lastMessageTime.forEach((orderId, time) -> {
                if (currentTime - time > BATCH_TIMEOUT_MS) {
                    ordersToProcess.add(orderId);
                }
            });
            
            for (var orderId : ordersToProcess) {
                var batch = pendingOrderBatches.remove(orderId);
                lastMessageTime.remove(orderId);
                processingExecutor.submit(() -> processBatchWithPipelining(orderId, batch));
            }
        }
    }
    
    public void shutdown() {
        if (!running) return;
        
        log(LogLevel.INFO, "\nShutdown signal received. Shutting down gracefully...");
        this.running = false;

        log(LogLevel.INFO, "Shutting down scheduler...");
        scheduler.shutdown();

        log(LogLevel.INFO, "Processing final outstanding batches...");
        synchronized(pendingOrderBatches) {
            for(var orderId : pendingOrderBatches.keySet()) {
                List<PartRequest> batch = pendingOrderBatches.get(orderId);
                log(LogLevel.INFO, "Submitting final batch for Order ID: " + orderId);
                processingExecutor.submit(() -> processBatchWithPipelining(orderId, batch));
            }
            pendingOrderBatches.clear();
        }

        log(LogLevel.INFO, "Awaiting termination of processing thread pool...");
        processingExecutor.shutdown();
        try {
            if (!processingExecutor.awaitTermination(60, TimeUnit.SECONDS)) {
                log(LogLevel.WARN, "Processing pool did not terminate in 60 seconds. Forcing shutdown...");
                processingExecutor.shutdownNow();
            }
        } catch (InterruptedException ie) {
            processingExecutor.shutdownNow();
            Thread.currentThread().interrupt();
        }

        log(LogLevel.INFO, "Stopping database connection pool: " + UCP_POOL_NAME);
        try {
            UniversalConnectionPoolManager mgr = UniversalConnectionPoolManagerImpl.getUniversalConnectionPoolManager();
            mgr.stopConnectionPool(UCP_POOL_NAME);
            log(LogLevel.INFO, "Database connection pool stopped successfully.");
        } catch (Exception e) {
            log(LogLevel.ERROR, "Error stopping connection pool", e);
        }

        log(LogLevel.INFO, "Shutdown complete.");
    }
    
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
            final Reserver service = new Reserver();
            Runtime.getRuntime().addShutdownHook(new Thread(service::shutdown));
            service.startListening();
        } catch (Exception e) { 
            System.err.println("CRITICAL: Failed to initialize the reservation service.");
            e.printStackTrace();
        }
    }
}