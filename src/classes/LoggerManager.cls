/**
 * Created by Wenbo on 6/22/2017.
 * LoggerManager - Serve as an access point for all the loggers and maintaining the logging instances
 * throughout a client session.
 */

global without sharing class LoggerManager {
    private static LoggerContainer container { get; set; }
    private static LoggerDatabaseInterface dbaseLogger { get; set; }
    private static DatabaseBufferedLogger dbuffLogger { get; set; }

    /*
     * Gets an logger container instance implemented with standard logger interface.
     */
    public static LoggerContainer Logger {
        get {
            if (container != null) return container;
            container = new LoggerContainer();
            // Gets the logger from the logger setting for registration`
            for (String loggerName : LoggerSetting.getLoggerNames()) {
                container.register(loggerName);
            }
            return container;
        }
    }

    /*
     * Gets an instance of database logger
     */
    public static LoggerDatabaseInterface DBLogger {
        get {
            if (dbaseLogger != null) return dbaseLogger;
            String loggerName = LoggerSetting.getDBLoggerName();
            if (String.isNotBlank(loggerName)) {
                LoggerInterface logger = LoggerUtils.getLogger(loggerName);
                if (logger instanceof LoggerDatabaseInterface) {
                    return (LoggerDatabaseInterface) logger;
                }
            }
            // Use default database logger
            dbaseLogger = new DatabaseLogger();
            return dbaseLogger;
        }
    }

    /*
     * Gets and instance of buffered database logger
     */
    public static DatabaseBufferedLogger DBufLogger {
        get {
            if (dbuffLogger != null) return dbuffLogger;
            dbuffLogger = new DatabaseBufferedLogger();
            return dbuffLogger;
        }
    }
}