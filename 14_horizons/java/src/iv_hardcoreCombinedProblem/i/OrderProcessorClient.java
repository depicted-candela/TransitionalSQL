package iv_hardcoreCombinedProblem.i;

/**
 * A command-line client to simulate placing a new order.
 * This is a simple application entry point that uses the centralized OrderService.
 */
public class OrderProcessorClient {

    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: java iv_hardcoreCombinedProblem.i.OrderProcessorClient <orderId>");
            System.exit(1);
        }

        try {
            int orderId = Integer.parseInt(args[0]);
            OrderService orderService = new OrderService();
            
            System.out.println("Submitting request to process Order ID: " + orderId);
            orderService.processOrder(orderId);
            System.out.println("Request submitted successfully. The Reserver service will now process the messages.");

        } catch (NumberFormatException e) {
            System.err.println("Error: The provided orderId '" + args[0] + "' is not a valid integer.");
        } catch (Exception e) {
            System.err.println("An error occurred while processing the order:");
            e.printStackTrace();
        }
    }
}