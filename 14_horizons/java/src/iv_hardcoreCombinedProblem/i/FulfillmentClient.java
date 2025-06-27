package iv_hardcoreCombinedProblem.i;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

/**
 * A unified client for the Horizons Fulfillment System.
 * This class serves as the single entry point for all user-facing actions.
 * It can be run in two modes:
 *  - SERVER MODE (default): Starts a web server with an intuitive UI.
 *  - CLIENT MODE: Acts as a command-line tool to process a single order.
 */
public class FulfillmentClient {

    /**
     * The core business logic for triggering an order. This is now centralized.
     * @param orderId The ID of the order to process.
     * @throws SQLException if a database error occurs.
     */
    public void processOrder(int orderId) throws SQLException {
        String plsqlCall = "{call HORIZONS.ORDERFULFILLMENT.PROCESSNEWORDER(?)}";
        System.out.println("Connecting to database to trigger processing for Order ID: " + orderId);

        try (Connection conn = DriverManager.getConnection(HorizonsConfig.DB_URL, HorizonsConfig.DB_USER, HorizonsConfig.DB_PASSWORD);
             CallableStatement cstmt = conn.prepareCall(plsqlCall)) {

            conn.setAutoCommit(false);
            cstmt.setInt(1, orderId);
            cstmt.execute();
            conn.commit();
            System.out.println("Successfully executed and committed. Messages are now enqueued for the Reserver service.");
        }
    }

    /**
     * Starts the lightweight web server to provide a user interface.
     */
    public void startWebServer() throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(HorizonsConfig.WEB_SERVER_PORT), 0);
        server.createContext("/", new RootHandler());
        server.createContext("/api/orders", new OrdersHandler());
        server.createContext("/api/process-order", new ProcessOrderHandler());
        server.setExecutor(null);
        server.start();
        System.out.println("Frontend service started on http://localhost:" + HorizonsConfig.WEB_SERVER_PORT);
        System.out.println("Use Ctrl+C to stop the web server.");
    }

    // --- Main Entry Point ---
    public static void main(String[] args) {
        if (args.length > 0) {
            // CLIENT MODE
            if (args.length != 1) {
                System.err.println("CLIENT MODE USAGE: java ... FulfillmentClient <orderId>");
                System.exit(1);
            }
            try {
                int orderId = Integer.parseInt(args[0]);
                FulfillmentClient client = new FulfillmentClient();
                client.processOrder(orderId);
            } catch (NumberFormatException e) {
                System.err.println("Error: The provided orderId '" + args[0] + "' is not a valid integer.");
            } catch (SQLException e) {
                System.err.println("Database error occurred while processing order:");
                e.printStackTrace();
            }
        } else {
            // SERVER MODE (default)
            try {
                FulfillmentClient server = new FulfillmentClient();
                server.startWebServer();
            } catch (IOException e) {
                System.err.println("Could not start web server:");
                e.printStackTrace();
            }
        }
    }

    // --- HTTP Handlers for the Web Server ---
    static class RootHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            try {
                byte[] responseBytes = Files.readAllBytes(Paths.get("index.html"));
                t.getResponseHeaders().set("Content-Type", "text/html");
                t.sendResponseHeaders(200, responseBytes.length);
                try (OutputStream os = t.getResponseBody()) {
                    os.write(responseBytes);
                }
            } catch (IOException e) {
                String error = "<h1>500 Internal Error</h1><p>Could not find index.html. Ensure it is in the `java` directory.</p>";
                t.sendResponseHeaders(500, error.length());
                try (OutputStream os = t.getResponseBody()) {
                    os.write(error.getBytes());
                }
            }
        }
    }

    static class OrdersHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            String sql = "SELECT orderId, customerName, orderStatus FROM horizons.customerOrders ORDER BY orderId";
            String jsonResponse;
            try (Connection conn = DriverManager.getConnection(HorizonsConfig.DB_URL, HorizonsConfig.DB_USER, HorizonsConfig.DB_PASSWORD);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {

                StringBuilder jsonBuilder = new StringBuilder("[");
                while (rs.next()) {
                    if (jsonBuilder.length() > 1) jsonBuilder.append(",");
                    jsonBuilder.append(String.format(
                        "{\"orderId\":%d,\"customerName\":\"%s\",\"orderStatus\":\"%s\"}",
                        rs.getInt("orderId"), rs.getString("customerName"), rs.getString("orderStatus")
                    ));
                }
                jsonBuilder.append("]");
                jsonResponse = jsonBuilder.toString();
                t.getResponseHeaders().set("Content-Type", "application/json");
                t.sendResponseHeaders(200, jsonResponse.getBytes().length);
            } catch (SQLException e) {
                e.printStackTrace();
                jsonResponse = "{\"error\":\"Database error fetching orders\"}";
                t.getResponseHeaders().set("Content-Type", "application/json");
                t.sendResponseHeaders(500, jsonResponse.getBytes().length);
            }
            try (OutputStream os = t.getResponseBody()) {
                os.write(jsonResponse.getBytes());
            }
        }
    }

    static class ProcessOrderHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            if (!"POST".equals(t.getRequestMethod())) {
                t.sendResponseHeaders(405, -1); // Method Not Allowed
                return;
            }
            String responseMessage;
            int statusCode;
            try {
                int orderId = Integer.parseInt(new String(t.getRequestBody().readAllBytes()).replaceAll("[^0-9]", ""));
                new FulfillmentClient().processOrder(orderId);
                responseMessage = "{\"message\":\"Successfully triggered processing for Order ID " + orderId + "\"}";
                statusCode = 200;
            } catch (Exception e) {
                e.printStackTrace();
                responseMessage = "{\"error\":\"Failed to process order. See server console for details.\"}";
                statusCode = 500;
            }
            t.getResponseHeaders().set("Content-Type", "application/json");
            t.sendResponseHeaders(statusCode, responseMessage.getBytes().length);
            try (OutputStream os = t.getResponseBody()) {
                os.write(responseMessage.getBytes());
            }
        }
    }
}