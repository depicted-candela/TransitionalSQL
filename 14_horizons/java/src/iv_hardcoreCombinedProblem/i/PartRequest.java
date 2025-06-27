// Final, Deprecation-Free PartRequest.java
package iv_hardcoreCombinedProblem.i;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Struct; // FIX 1: Import the standard JDBC Struct interface

// Import the required Oracle-specific interfaces
import oracle.sql.Datum;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;

// No longer need: import oracle.sql.STRUCT;
// No longer need: import oracle.sql.StructDescriptor;

/**
 * A Java class that maps to the HORIZONS.PARTREQUESTTYPE SQL object.
 * It uses the modern, non-deprecated ORAData implementation pattern
 * based on the standard java.sql.Struct interface.
 */
public class PartRequest implements Serializable, ORAData, ORADataFactory {
    private static final long serialVersionUID = 5L; // Version updated for new implementation

    public static final String SQL_TYPE_NAME = "HORIZONS.PARTREQUESTTYPE";
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
    
    // --- ORADataFactory Implementation (no changes needed here) ---
    public static ORADataFactory getORADataFactory() {
        return _factory;
    }
    
    @Override
    public ORAData create(Datum d, int sqlType) throws SQLException {
        if (d == null) return null;
        // The factory will now create an instance using the modern Struct-based constructor
        return new PartRequest((Struct) d);
    }

    // --- ORAData Implementation (Modernized) ---
    
    /**
     * Modern constructor used by the factory to create an instance from a Struct.
     * This avoids the deprecated oracle.sql.STRUCT class.
     */
    public PartRequest(Struct s) throws SQLException {
        if (s == null) {
            throw new SQLException("Cannot create PartRequest from a null Struct.");
        }
        Object[] attrs = s.getAttributes();
        // Attributes from STRUCT often come as BigDecimal, requiring conversion.
        this.orderId = ((BigDecimal) attrs[0]).intValue();
        this.partId = ((BigDecimal) attrs[1]).intValue();
        this.quantity = ((BigDecimal) attrs[2]).intValue();
    }

    /**
     * Modern method to convert this Java object into a standard JDBC Struct.
     * This avoids the deprecated oracle.sql.STRUCT and StructDescriptor classes.
     */
    @Override
    public Datum toDatum(Connection c) throws SQLException {
        // The modern way to create a Struct is directly from the Connection object.
        Object[] attrs = {
            new BigDecimal(this.orderId), 
            new BigDecimal(this.partId), 
            new BigDecimal(this.quantity), 
            null // Pass null for the timestamp as it's not used
        };
        return (Datum) c.createStruct(SQL_TYPE_NAME, attrs);
    }

    // --- Standard Getters and Setters (unchanged) ---
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getPartId() { return partId; }
    public void setPartId(int partId) { this.partId = partId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}