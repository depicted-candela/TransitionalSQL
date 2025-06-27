// src/iv_hardcoreCombinedProblem/i/WebServer.java
package iv_hardcoreCombinedProblem.i;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

/**
 * A lightweight web server that provides a frontend for the order fulfillment system.
 * It serves the main HTML page and exposes API endpoints to:
 * 1. Fetch existing customer orders.
 * 2. Trigger the processing of a specific order.
 */
public class WebServer {

    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1";
    private static final String DB_USER = "HORIZONS";
    private static final String DB_PASSWORD = "YourPassword";

    public static void main(String[] args) throws IOException {
        int port = 9090;
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);

        // Endpoint to serve the main HTML file
        server.createContext("/", new RootHandler());
        
        // API endpoint to get a list of orders from the database
        server.createContext("/api/orders", new OrdersHandler());

        // API endpoint to trigger the processing of a specific order
        server.createContext("/api/process-order", new ProcessOrderHandler());

        server.setExecutor(null); // creates a default executor
        System.out.println("Frontend service started on http://localhost:" + port);
        System.out.println("Open your web browser to interact with the system.");
        server.start();
    }

    // Serves the index.html file
    static class RootHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            String response = "File not found.";
            int statusCode = 404;
            try {
                // Assumes index.html is in the same directory where the server is run
                response = new String(Files.readAllBytes(Paths.get("index.html")));
                statusCode = 200;
            } catch (IOException e) {
                 System.err.println("Error reading index.html: " + e.getMessage());
                 response = "<h1>500 Internal Server Error</h1><p>Could not load index.html. Ensure the file exists in the `java` directory.</p>";
                 statusCode = 500;
            }
            t.getResponseHeaders().set("Content-Type", "text/html");
            t.sendResponseHeaders(statusCode, response.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }

    // Fetches and returns a list of orders as JSON
    static class OrdersHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            StringBuilder jsonBuilder = new StringBuilder("[");
            String sql = "SELECT orderId, customerName, orderStatus FROM horizons.customerOrders ORDER BY orderId";
            
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {

                boolean first = true;
                while (rs.next()) {
                    if (!first) {
                        jsonBuilder.append(",");
                    }
                    jsonBuilder.append("{")
                        .append("\"orderId\":").append(rs.getInt("orderId")).append(",")
                        .append("\"customerName\":\"").append(rs.getString("customerName")).append("\",")
                        .append("\"orderStatus\":\"").append(rs.getString("orderStatus")).append("\"")
                        .append("}");
                    first = false;
                }
            } catch (SQLException e) {
                e.printStackTrace();
                String errorResponse = "{\"error\":\"Database error fetching orders\"}";
                t.getResponseHeaders().set("Content-Type", "application/json");
                t.sendResponseHeaders(500, errorResponse.getBytes().length);
                OutputStream os = t.getResponseBody();
                os.write(errorResponse.getBytes());
                os.close();
                return;
            }

            jsonBuilder.append("]");
            String response = jsonBuilder.toString();
            t.getResponseHeaders().set("Content-Type", "application/json");
            t.sendResponseHeaders(200, response.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }

    // Handles the request to process an order
    static class ProcessOrderHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            if (!"POST".equals(t.getRequestMethod())) {
                t.sendResponseHeaders(405, -1); // Method Not Allowed
                return;
            }
            
            // Read the request body to get the order ID
            String requestBody = new BufferedReader(new InputStreamReader(t.getRequestBody())).readLine();
            int orderId = -1;
            String responseMessage = "";
            int statusCode = 500;

            try {
                // Simple JSON parsing for {"orderId": N}
                orderId = Integer.parseInt(requestBody.replaceAll("[^0-9]", ""));
                
                System.out.println("Received request to process Order ID: " + orderId);
                // Use the existing OrderProcessorClient logic
                OrderProcessorClient client = new OrderProcessorClient();
                client.processOrder(orderId);
                
                responseMessage = "{\"message\":\"Successfully triggered processing for Order ID " + orderId + "\"}";
                statusCode = 200;

            } catch (NumberFormatException e) {
                e.printStackTrace();
                responseMessage = "{\"error\":\"Failed to process order " + orderId + ". " + e.getMessage() + "\"}";
                statusCode = 500;
            }
            
            t.getResponseHeaders().set("Content-Type", "application/json");
            t.sendResponseHeaders(statusCode, responseMessage.getBytes().length);
            OutputStream os = t.getResponseBody();
            os.write(responseMessage.getBytes());
            os.close();
        }
    }
}