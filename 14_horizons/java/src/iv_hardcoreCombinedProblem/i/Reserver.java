// src/iv_hardcoreCombinedProblem/i/Reserver.java
package iv_hardcoreCombinedProblem.i;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;

public class Reserver {

    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1";
    private static final String DB_USER = "horizons";
    private static final String DB_PASSWORD = "YourPassword";
    private static final String QUEUE_NAME = "HORIZONS.PARTREQUESTTOPIC";
    private static final long BATCH_TIMEOUT_MS = 500;
    private static final String SUBSCRIPTION_NAME = "PartReservationService";
    private static final String CLIENT_ID = "PartReservationClient";

    private final PoolDataSource pds;
    private final TopicConnectionFactory tcf;
    private final Map<Integer, List<PartRequest>> pendingOrderBatches = new HashMap<>();
    private final Map<Integer, Long> lastMessageTime = new HashMap<>();

    public Reserver() throws SQLException, JMSException {
        System.out.println("Configuring UCP Connection Pool...");
        pds = PoolDataSourceFactory.getPoolDataSource();
        pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
        pds.setURL(DB_URL);
        pds.setUser(DB_USER);
        pds.setPassword(DB_PASSWORD);
        pds.setInitialPoolSize(5);
        pds.setMinPoolSize(5);
        pds.setMaxPoolSize(20);
        
        System.out.println("Configuring AQ JMS Connection Factory...");
        this.tcf = AQjmsFactory.getTopicConnectionFactory(pds);
        
        cleanupSubscription();
    }
    
    private void cleanupSubscription() throws JMSException {
        System.out.println("Attempting to clean up previous durable subscription: " + SUBSCRIPTION_NAME);
        try (var connection = tcf.createTopicConnection()) {
            connection.setClientID(CLIENT_ID);
            connection.start();
            try (var session = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE)) {
                Topic topic = session.createTopic(QUEUE_NAME);
                System.out.println("Re-attaching to subscription to close it...");
                MessageConsumer consumerToClose = session.createDurableSubscriber(topic, SUBSCRIPTION_NAME);
                consumerToClose.close();
                System.out.println("Consumer closed.");
                session.unsubscribe(SUBSCRIPTION_NAME);
                System.out.println("Successfully unsubscribed from previous session.");
            }
        } catch (JMSException e) {
            if (e.getMessage() != null && e.getMessage().contains("JMS-232")) {
                 System.out.println("Subscription did not previously exist, which is normal.");
            } else {
                System.err.println("Warning: Could not clean up subscription. This may be okay on first run.");
            }
        }
    }
    
    public void startListening() throws SQLException {
        var scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(this::processTimedOutBatches, BATCH_TIMEOUT_MS, BATCH_TIMEOUT_MS, TimeUnit.MILLISECONDS);

        System.out.println("Service started. Listening for messages on " + QUEUE_NAME + "...");

        try (var connection = tcf.createTopicConnection()) {
            connection.setClientID(CLIENT_ID);
            connection.start(); 

            try (var session = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE)) {
                var aqSession = (AQjmsSession) session;
                Topic topic = aqSession.createTopic(QUEUE_NAME);

                // =======================================================================
                // FINAL FIX: Pass an INSTANCE of the ORADataFactory.
                // =======================================================================
                MessageConsumer consumer = aqSession.createDurableSubscriber(
                    topic, 
                    SUBSCRIPTION_NAME, 
                    null,
                    false,
                    PartRequest.getORADataFactory() // Pass the factory instance
                );
                
                System.out.println("Durable subscriber created successfully. Waiting for messages...");
                while (true) {
                    Message message = consumer.receive(2000); 
                    
                    if (message instanceof ObjectMessage) {
                        try {
                            PartRequest req = (PartRequest) ((ObjectMessage) message).getObject();
                            System.out.println("Received message for Order ID: " + req.getOrderId() + ", Part ID: " + req.getPartId());
                            
                            synchronized(pendingOrderBatches) {
                               pendingOrderBatches.computeIfAbsent(req.getOrderId(), k -> new ArrayList<>()).add(req);
                               lastMessageTime.put(req.getOrderId(), System.currentTimeMillis());
                            }
                        } catch (JMSException e) {
                            System.err.println("Error deserializing message: " + e.getMessage());
                        }
                    } else if (message != null) {
                        System.err.println("Received a message that was not an ObjectMessage: " + message.getClass().getName());
                    }
                }
            }
        } catch (JMSException e) {
            System.err.println("A fatal error occurred in the listener. Shutting down.");
            e.printStackTrace();
            scheduler.shutdown();
        }
    }

    private void processTimedOutBatches() {
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
                Executors.newSingleThreadExecutor().submit(() -> processBatchWithPipelining(orderId, batch));
            }
        }
    }

    public void processBatchWithPipelining(int orderId, List<PartRequest> batch) {
        System.out.println("Processing batch for Order ID: " + orderId + " with " + batch.size() + " parts.");
        
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
                
                System.out.println("All " + batch.size() + " updates for Order ID " + orderId + " pipelined. Committing transaction.");
                conn.commit();
                
            } catch (SQLException e) {
                System.err.println("SQL Error during batch processing for Order ID: " + orderId + ". Rolling back transaction.");
                e.printStackTrace();
                conn.rollback();
            }
        } catch (SQLException e) {
            System.err.println("Connection or transaction management error for Order ID: " + orderId);
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        try {
            var service = new Reserver();
            service.startListening();
        } catch (SQLException | JMSException e) { 
            System.err.println("Failed to initialize the reservation service.");
            e.printStackTrace();
        }
    }
}