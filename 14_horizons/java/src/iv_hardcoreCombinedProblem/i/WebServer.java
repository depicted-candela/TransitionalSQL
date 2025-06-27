package iv_hardcoreCombinedProblem.i;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.file.Files;
import java.nio.file.Paths;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

/**
 * A lightweight web server that provides a frontend for the order fulfillment system.
 * This class now respects the Single Responsibility Principle by delegating all
 * business logic to the OrderService.
 */
public class WebServer {

    private static final OrderService orderService = new OrderService();

    public static void main(String[] args) throws IOException {
        int port = HorizonsConfig.WEB_SERVER_PORT;
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/", new RootHandler());
        server.createContext("/api/orders", new OrdersHandler());
        server.createContext("/api/process-order", new ProcessOrderHandler());
        server.setExecutor(null);
        System.out.println("Frontend service started on http://localhost:" + port);
        server.start();
    }

    private static void sendResponse(HttpExchange t, int statusCode, String contentType, String response) throws IOException {
        t.getResponseHeaders().set("Content-Type", contentType);
        byte[] responseBytes = response.getBytes("UTF-8");
        t.sendResponseHeaders(statusCode, responseBytes.length);
        try (OutputStream os = t.getResponseBody()) {
            os.write(responseBytes);
        }
    }

    static class RootHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            try {
                String content = new String(Files.readAllBytes(Paths.get("index.html")));
                sendResponse(t, 200, "text/html", content);
            } catch (IOException e) {
                String error = "<h1>500 Internal Error</h1><p>Could not load index.html.</p>";
                sendResponse(t, 500, "text/html", error);
            }
        }
    }

    static class OrdersHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            try {
                String jsonResponse = orderService.getOrdersAsJson();
                sendResponse(t, 200, "application/json", jsonResponse);
            } catch (Exception e) {
                sendResponse(t, 500, "application/json", "{\"error\":\"Database error fetching orders\"}");
            }
        }
    }

    static class ProcessOrderHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            if (!"POST".equals(t.getRequestMethod())) {
                sendResponse(t, 405, "text/plain", "Method Not Allowed");
                return;
            }
            try (var reader = new BufferedReader(new InputStreamReader(t.getRequestBody()))) {
                String requestBody = reader.readLine();
                int orderId = Integer.parseInt(requestBody.replaceAll("[^0-9]", ""));
                
                System.out.println("Received API request to process Order ID: " + orderId);
                orderService.processOrder(orderId);
                
                String jsonResponse = "{\"message\":\"Successfully triggered processing for Order ID " + orderId + "\"}";
                sendResponse(t, 200, "application/json", jsonResponse);
            } catch (Exception e) {
                String errorResponse = "{\"error\":\"Failed to process order: " + e.getMessage() + "\"}";
                sendResponse(t, 500, "application/json", errorResponse);
            }
        }
    }
}