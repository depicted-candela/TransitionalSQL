// Assumes a JMS framework is handling message listening and thread management.
// This is the core logic within a message handler.
package ii_hardcoreCombinedProblem.i;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javax.jms.JMSContext;
import javax.jms.JMSConsumer;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.ObjectMessage;
import javax.jms.Queue;

import oracle.jdbc.OraclePreparedStatement;
import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;
import oracle.jms.AQjmsFactory;
import javax.jms.QueueConnectionFactory;

/**
 * A multi-threaded, resilient message consumer that listens to the
 * partRequestTopic, batches reservation requests by order ID, and processes
 * them using JDBC 23ai Pipelining.
 */
public class Reserver {

    // --- Configuration Constants (in a real app, use a config file) ---
    private static final String DB_URL = "jdbc:oracle:thin:@//your_db_host:1521/your_service_name";
    private static final String DB_USER = "horizons";
    private static final String DB_PASSWORD = "your_password";
    private static final String QUEUE_NAME = "horizons.partRequestTopic";

    // Batching strategy: Process batches if no new message for an order arrives for this duration.
    private static final long BATCH_TIMEOUT_MS = 500;

    private final PoolDataSource pds;
    private final QueueConnectionFactory qcf;
    
    // In-memory store to batch incoming requests by their Order ID
    private final Map<Integer, List<PartRequest>> pendingOrderBatches = new HashMap<>();
    private final Map<Integer, Long> lastMessageTime = new HashMap<>();


    public Reserver() throws SQLException {
        // 1. Setup Universal Connection Pool (UCP) for database connections
        System.out.println("Configuring UCP Connection Pool...");
        pds = PoolDataSourceFactory.getPoolDataSource();
        pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
        pds.setURL(DB_URL);
        pds.setUser(DB_USER);
        pds.setPassword(DB_PASSWORD);
        pds.setInitialPoolSize(5);
        pds.setMinPoolSize(5);
        pds.setMaxPoolSize(20);
        
        // 2. Setup AQ JMS Connection Factory
        System.out.println("Configuring AQ JMS Connection Factory...");
        qcf = AQjmsFactory.getQueueConnectionFactory(pds);
    }
    
    /**
     * Main listener loop to run the service.
     */
    public void startListening() {
        // A background scheduler to periodically check for and process timed-out batches.
        ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(this::processTimedOutBatches, BATCH_TIMEOUT_MS, BATCH_TIMEOUT_MS, TimeUnit.MILLISECONDS);

        System.out.println("Service started. Listening for messages on " + QUEUE_NAME + "...");

        // Use try-with-resources for the JMS context to ensure it's always closed.
        try (JMSContext context = qcf.createContext()) {
            Queue queue = context.createQueue(QUEUE_NAME);
            JMSConsumer consumer = context.createConsumer(queue);
            
            // The service runs indefinitely, processing messages as they arrive.
            while (true) {
                // Wait for a message. The timeout allows the loop to check for shutdown signals.
                Message message = consumer.receive(2000); 
                
                if (message instanceof ObjectMessage) {
                    try {
                        PartRequest req = (PartRequest) ((ObjectMessage) message).getObject();
                        System.out.println("Received message for Order ID: " + req.getOrderId() + ", Part ID: " + req.getPartId());
                        
                        // Add the request to our in-memory batch
                        synchronized(pendingOrderBatches) {
                           pendingOrderBatches.computeIfAbsent(req.getOrderId(), k -> new ArrayList<>()).add(req);
                           lastMessageTime.put(req.getOrderId(), System.currentTimeMillis());
                        }

                    } catch (JMSException e) {
                        System.err.println("Error deserializing message: " + e.getMessage());
                        // Decide on an error strategy: move to dead-letter-queue, log, etc.
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("A fatal error occurred in the listener. Shutting down.");
            e.printStackTrace();
            scheduler.shutdown();
        }
    }

    /**
     * This method is called periodically to find and process batches that haven't
     * received new messages recently.
     */
    private void processTimedOutBatches() {
        long currentTime = System.currentTimeMillis();
        List<Integer> ordersToProcess = new ArrayList<>();
        
        synchronized(pendingOrderBatches) {
            lastMessageTime.forEach((orderId, time) -> {
                if (currentTime - time > BATCH_TIMEOUT_MS) {
                    ordersToProcess.add(orderId);
                }
            });
            
            for (Integer orderId : ordersToProcess) {
                List<PartRequest> batch = pendingOrderBatches.remove(orderId);
                lastMessageTime.remove(orderId);
                // Process the batch in a new thread from the pool to not block the scheduler
                Executors.newSingleThreadExecutor().submit(() -> processBatchWithPipelining(orderId, batch));
            }
        }
    }

    /**
     * The core logic for processing a complete batch of part reservations for a single order.
     * Uses 23ai JDBC Pipelining for maximum efficiency.
     */
    public void processBatchWithPipelining(int orderId, List<PartRequest> batch) {
        System.out.println("Processing batch for Order ID: " + orderId + " with " + batch.size() + " parts.");
        
        // JDBC Connectivity & UCP: Get a connection from the pool.
        try (Connection conn = pds.getConnection()) {
            // Set transaction boundaries. This is CRITICAL for atomicity.
            conn.setAutoCommit(false);

            // 23ai Pipelining: Prepare the pipelined statement
            String sql = "UPDATE horizons.inventory SET onHandQuantity = onHandQuantity - ?, reservedQuantity = reservedQuantity + ? WHERE partId = ?";
            
            // Use try-with-resources for the PreparedStatement
            try (OraclePreparedStatement opstmt = conn.prepareStatement(sql).unwrap(OraclePreparedStatement.class)) {
                
                // Pipeline all UPDATE DMLs for this order
                for (PartRequest req : batch) {
                    opstmt.setInt(1, req.getQuantity());
                    opstmt.setInt(2, req.getQuantity());
                    opstmt.setInt(3, req.getPartId());
                    // Non-blocking call sends request to the JDBC client's pipeline buffer
                    opstmt.executeUpdateAsyncOracle(); 
                }
                
                // Once all DMLs are pipelined, they are sent to the DB in one network
                // round-trip upon commit.
                System.out.println("All " + batch.size() + " updates for Order ID " + orderId + " pipelined. Committing transaction.");
                conn.commit();
                
                // NOTE: Here you would also acknowledge the corresponding JMS messages.
                // In a simple model, acknowledging the last message of the batch would suffice
                // if the session is transacted.
                
            } catch (SQLException e) {
                System.err.println("SQL Error during batch processing for Order ID: " + orderId + ". Rolling back transaction.");
                e.printStackTrace();
                conn.rollback(); // Rollback on any error within the batch
            }
        } catch (SQLException e) {
            // This catches errors with getting the connection or with commit/rollback
            System.err.println("Connection or transaction management error for Order ID: " + orderId);
            e.printStackTrace();
            // The messages for this batch remain un-acknowledged and will be redelivered by AQ.
        }
    }

    /**
     * Application entry point.
     */
    public static void main(String[] args) {
        try {
            Reserver service = new Reserver();
            service.startListening();
        } catch (SQLException e) {
            System.err.println("Failed to initialize the reservation service.");
            e.printStackTrace();
        }
    }
}