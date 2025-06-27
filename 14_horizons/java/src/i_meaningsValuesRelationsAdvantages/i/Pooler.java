package i_meaningsValuesRelationsAdvantages.i;
// src/i_meaningsValuesRelationsAdvantages/i/Pooler.java

import java.sql.Connection;
import java.sql.SQLException;
import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;


public class Pooler {

    public static void main(String[] args) {
        System.out.println("Attempting to get a connection...");
        try {
            PoolDataSource pds = PoolDataSourceFactory.getPoolDataSource();
            pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
            pds.setURL("jdbc:oracle:thin:@localhost:1521/FREEPDB1");
            pds.setUser("horizons");
            pds.setPassword("YourPassword"); // <-- IMPORTANT: CHANGE THIS
            System.out.println("Pool configured. Requesting connection...");
            // Use a try-with-resources block to automatically close the connection
            try (Connection connection = pds.getConnection()) {
                System.out.println("--> Successfully got a connection!");
                System.out.println("--> Connection is valid: " + connection.isValid(2));
            } // Connection is returned to the pool here

        } catch (SQLException e) {
            System.err.println("ERROR: Operation failed.");
        }
        System.out.println("Application finished.");
    }
}