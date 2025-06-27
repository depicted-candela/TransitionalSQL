package iv_hardcoreCombinedProblem.i;

/**
 * Centralized configuration for the Horizons Fulfillment System.
 * This class follows the DRY principle, providing a single source of truth for all settings.
 */
public final class HorizonsConfig {
    
    // Private constructor to prevent instantiation of this utility class.
    private HorizonsConfig() {}

    // --- Database & UCP Configuration ---
    public static final String DB_URL = "jdbc:oracle:thin:@localhost:1521/FREEPDB1";
    public static final String DB_USER = "horizons";
    public static final String DB_PASSWORD = "YourPassword"; // Replace with a secure retrieval method in production
    public static final String UCP_POOL_NAME = "ReserverConnectionPool";

    // --- JMS & AQ Configuration ---
    public static final String QUEUE_NAME = "HORIZONS.PARTREQUESTTOPIC";
    public static final String SUBSCRIPTION_NAME = "PartReservationService";
    public static final String CLIENT_ID = "PartReservationClient";

    // --- Web Server Configuration ---
    public static final int WEB_SERVER_PORT = 9090;

    // --- Application Logic Configuration ---
    public static final long BATCH_TIMEOUT_MS = 1500;
}