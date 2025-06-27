// Updated PartRequest.java
package ii_hardcoreCombinedProblem.i;

import java.io.Serializable;

public class PartRequest implements Serializable {
    private static final long serialVersionUID = 2L; // Version updated

    private int orderId; // <-- ADDED
    private int partId;
    private int quantity;

    public PartRequest() {}

    public PartRequest(int orderId, int partId, int quantity) {
        this.orderId = orderId;
        this.partId = partId;
        this.quantity = quantity;
    }

    // --- Getters and Setters for all fields ---
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getPartId() { return partId; }
    public void setPartId(int partId) { this.partId = partId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}