/*      Exercise 1.3: Asynchronous Pipelining vs. Standard Batching
Problem
A Java application needs to run three independent DML statements against the horizons schema in the most efficient manner possible to reduce application-side 
blocking.
Relational: How does Oracle's 23ai JDBC Pipelining feature differ fundamentally from standard JDBC batching (addBatch/executeBatch)?
Answer: the difference lies in the asynchronous nature of the pipelining, where JDBC batching sends many requests and waits for their responses, and pipelining
sends multiple requests trusting they'll be well received without errors (to assure this are necessary fine grained tests), thus resources are freed and more 
requests are sent
Value (Code Snippet): Write a conceptual Java snippet using the 23ai JDBC API to pipeline three independent UPDATE statements on the productCatalog table. */

package i_meaningsValuesRelationsAdvantages.iii;
// src/i_meaningsValuesRelationsAdvantages/iii/MultipleUpdatingPipeliner.java

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;
import oracle.jdbc.OraclePreparedStatement;

/**
 * An enhanced example of Oracle JDBC statement pipelining.
 *
 * Enhancements from the original version:
 * 1.  Scalable Design: Uses a List of IDs to update multiple records, not just two fixed ones.
 * 2.  Secure and Flexible SQL: Uses a parameterized PreparedStatement to prevent SQL injection and allow dynamic values.
 * 3.  Improved Resource Management: Correctly handles Connections and Statements within try-catch-finally blocks.
 * 4.  Better Code Organization: Centralizes configuration and uses a dedicated method for the business logic.
 */
public class MultipleUpdatingPipeliner {

    // --- 1. Centralized Configuration ---
    // Using constants makes the code cleaner and easier to modify.
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1";
    private static final String DB_USER = "horizons";
    private static final String DB_PASSWORD = "YourPassword";

    private static final String UPDATE_PRODUCT_SQL = "UPDATE PRODUCTCATALOG SET ISRESERVABLE = ? WHERE PARTID = ?";

    private static PoolDataSource pds;

    public static void main(String[] args) {
        try {
            initializeDataSource();
            List<Integer> partIdsToUpdate = Arrays.asList(1, 2, 3, 4);
            boolean newReservableStatus = false;
            try (Connection connection = pds.getConnection()) {
                pipelineUpdateTransaction(connection, partIdsToUpdate, newReservableStatus);
            }
        } catch (SQLException e) {
            System.err.println("A critical database error occurred. The operation could not be completed.");
            e.printStackTrace(System.err);
        }
    }

    /**
     * Initializes the Universal Connection Pool (UCP).
     */
    private static void initializeDataSource() throws SQLException {
        pds = PoolDataSourceFactory.getPoolDataSource();
        pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
        pds.setURL(DB_URL);
        pds.setUser(DB_USER);
        pds.setPassword(DB_PASSWORD);
    }

    /**
     * Executes a series of UPDATE statements as a single pipelined transaction.
     *
     * @param connection The database connection to use.
     * @param partIds The list of PARTIDs to update.
     * @param isReservable The new value for the ISRESERVABLE column.
     * @throws SQLException if a database access error occurs.
     */
    private static void pipelineUpdateTransaction(Connection connection, List<Integer> partIds, boolean isReservable) throws SQLException {
        List<OraclePreparedStatement> preparedStatements = new ArrayList<>();
        try {
            connection.setAutoCommit(false);
            System.out.println("Starting pipelined transaction for " + partIds.size() + " updates...");
            for (Integer partId : partIds) {
                OraclePreparedStatement ops = connection.prepareStatement(UPDATE_PRODUCT_SQL).unwrap(OraclePreparedStatement.class);
                preparedStatements.add(ops);
                ops.setBoolean(1, isReservable);
                ops.setInt(2, partId);
                ops.executeUpdateAsyncOracle();
                System.out.println("  -> Pipelined update for PARTID: " + partId);
            }
            connection.commit();
            System.out.println("\nThe pipelined transaction has found its shore. All updates committed successfully.");

        } catch (SQLException e) {
            System.err.println("Transaction failed. Rolling back changes...");
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                System.err.println("Error: Could not roll back the transaction.");
                e.addSuppressed(rollbackEx);
            }
            throw e;

        } finally {
            for (OraclePreparedStatement stmt : preparedStatements) {
                if (stmt != null) {
                    try {
                        stmt.close();
                    } catch (SQLException closeEx) {
                        System.err.println("Warning: Failed to close a PreparedStatement.");
                        closeEx.printStackTrace(System.err);
                    }
                }
            }
        }
    }
}

// Advantage: What is the primary advantage of using pipelining for application throughput and scalability?