// Final Corrected PartRequest.java
package iv_hardcoreCombinedProblem.i;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.math.BigDecimal; // Import for handling NUMBER types from Oracle

// Import the required Oracle-specific interfaces
import oracle.sql.Datum;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;

// Implement ORAData for mapping and ORADataFactory to provide an instance of itself.
public class PartRequest implements Serializable, ORAData, ORADataFactory {
    private static final long serialVersionUID = 4L; // Version updated

    public static final String SQL_TYPE_NAME = "HORIZONS.PARTREQUESTTYPE";
    
    // The factory instance is often cached for performance.
    private static final PartRequest _factory = new PartRequest();

    private int orderId;
    private int partId;
    private int quantity;

    public PartRequest() {}

    public PartRequest(int orderId, int partId, int quantity) {
        this.orderId = orderId;
        this.partId = partId;
        this.quantity = quantity;
    }
    
    // --- ORADataFactory Implementation ---

    /**
     * This static method is what the Oracle driver looks for.
     * @return A factory instance that can create PartRequest objects.
     */
    public static ORADataFactory getORADataFactory() {
        return _factory;
    }
    
    /**
     * Creates a PartRequest object from a database Datum.
     * @param d The raw Datum from the database (a STRUCT).
     * @param sqlType The SQL type code (not used for object types).
     * @return A new PartRequest object.
     */
    @Override
    public ORAData create(Datum d, int sqlType) throws SQLException {
        if (d == null) return null;
        return new PartRequest(d);
    }

    // --- ORAData Implementation ---
    
    /**
     * Constructor used by the factory to create an instance from a STRUCT.
     * @param d The raw Datum from the database.
     */
    public PartRequest(Datum d) throws SQLException {
        STRUCT s = (STRUCT) d;
        Object[] attrs = s.getAttributes();
        // Attributes from STRUCT often come as BigDecimal, requiring conversion.
        this.orderId = ((BigDecimal) attrs[0]).intValue();
        this.partId = ((BigDecimal) attrs[1]).intValue();
        this.quantity = ((BigDecimal) attrs[2]).intValue();
        // We ignore attrs[3] (the timestamp) as planned.
    }

    /**
     * Converts this Java object into a database Datum (a STRUCT).
     * @param c The active database connection.
     * @return A Datum representing this object.
     */
    @Override
    public Datum toDatum(Connection c) throws SQLException {
        StructDescriptor descriptor = StructDescriptor.createDescriptor(SQL_TYPE_NAME, c);
        Object[] attrs = { orderId, partId, quantity, null }; // Pass null for the timestamp
        return new STRUCT(descriptor, c, attrs);
    }

    // --- Standard Getters and Setters ---
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getPartId() { return partId; }
    public void setPartId(int partId) { this.partId = partId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}