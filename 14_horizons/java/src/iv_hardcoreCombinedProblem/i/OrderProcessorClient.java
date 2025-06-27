// src/iv_hardcoreCombinedProblem/i/OrderProcessorClient.java
package iv_hardcoreCombinedProblem.i;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * A simple command-line client to simulate placing a new order.
 * This client connects to the database and invokes the PL/SQL procedure
 * that parses an order and enqueues part reservation messages.
 */
public class OrderProcessorClient {

    // --- Database Configuration (should match your Reserver config) ---
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1";
    private static final String DB_USER = "horizons";
    private static final String DB_PASSWORD = "YourPassword";

    /**
     * Calls the order fulfillment procedure for a given order ID.
     * @param orderId The ID of the order to process.
     */
    public void processOrder(int orderId) {
        String plsqlCall = "{call horizons.orderFulfillment.processNewOrder(?)}";
        
        // Use try-with-resources to ensure resources are always closed.
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             CallableStatement cstmt = conn.prepareCall(plsqlCall)) {

            // CRITICAL: We must control the transaction manually to ensure the
            // messages are committed to the queue.
            conn.setAutoCommit(false);

            System.out.println("Connecting to the database and preparing to call procedure for Order ID: " + orderId);

            // Set the input parameter for the procedure
            cstmt.setInt(1, orderId);

            // Execute the PL/SQL procedure
            cstmt.execute();
            System.out.println("Successfully executed orderFulfillment.processNewOrder.");

            // CRITICAL: Commit the transaction. This makes the enqueued messages
            // visible to other database sessions, including our Reserver service.
            conn.commit();
            System.out.println("Transaction committed. Messages are now on the topic and available for consumption.");

        } catch (SQLException e) {
            System.err.println("Database error occurred while processing order " + orderId);
            e.printStackTrace();
        }
    }

    /**
     * Main entry point. Expects one argument: the order ID.
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: java iv_hardcoreCombinedProblem.i.OrderProcessorClient <orderId>");
            System.err.println("Example: java iv_hardcoreCombinedProblem.i.OrderProcessorClient 1");
            System.exit(1);
        }

        try {
            int orderId = Integer.parseInt(args[0]);
            OrderProcessorClient client = new OrderProcessorClient();
            client.processOrder(orderId);
        } catch (NumberFormatException e) {
            System.err.println("Error: The provided orderId '" + args[0] + "' is not a valid integer.");
            System.exit(1);
        }
    }
}