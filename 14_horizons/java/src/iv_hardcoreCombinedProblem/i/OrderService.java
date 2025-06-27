package iv_hardcoreCombinedProblem.i;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Service class responsible for all customer order business logic.
 * It provides methods to fetch orders and to trigger the fulfillment process.
 */
public class OrderService {

    public String getOrdersAsJson() throws SQLException {
        StringBuilder jsonBuilder = new StringBuilder("[");
        String sql = "SELECT orderId, customerName, orderStatus FROM horizons.customerOrders ORDER BY orderId";
        
        try (Connection conn = DriverManager.getConnection(HorizonsConfig.DB_URL, HorizonsConfig.DB_USER, HorizonsConfig.DB_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            boolean first = true;
            while (rs.next()) {
                if (!first) jsonBuilder.append(",");
                jsonBuilder.append(String.format(
                    "{\"orderId\":%d,\"customerName\":\"%s\",\"orderStatus\":\"%s\"}",
                    rs.getInt("orderId"),
                    rs.getString("customerName"),
                    rs.getString("orderStatus")
                ));
                first = false;
            }
        }
        jsonBuilder.append("]");
        return jsonBuilder.toString();
    }

    public void processOrder(int orderId) throws SQLException {
        String plsqlCall = "{call horizons.orderFulfillment.processNewOrder(?)}";
        
        try (Connection conn = DriverManager.getConnection(HorizonsConfig.DB_URL, HorizonsConfig.DB_USER, HorizonsConfig.DB_PASSWORD);
             CallableStatement cstmt = conn.prepareCall(plsqlCall)) {

            conn.setAutoCommit(false);
            cstmt.setInt(1, orderId);
            cstmt.execute();
            conn.commit();
        }
    }
}