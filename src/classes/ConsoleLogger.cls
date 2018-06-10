/**
 * Created by Wenbo on 6/22/2017.
 * ConsoleLogger - For logging error in the developer console and SF log entries
 */

global virtual without sharing class ConsoleLogger implements LoggerInterface {
    global static final String DEFAULT_CONSOLE_LOG_FORMAT
            = '[{0}][{1}][{2}][{3}({4})] --- \n{5}';
    global static final String DEFAULT_CONSOLE_DATETIME_FORMAT
            = 'yyyy-MM-dd HH:mm:ss z';
    private LoggingLevel level { get; set; }
    global String logFormat { get; set; }
    global String timeFormat { get; set; }
    global String userId {
        get {
            return UserInfo.getUserId();
        }
    }
    global String userName {
        get {
            return UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        }
    }

    /*
     * Constructor
     */
    global ConsoleLogger() {
        logFormat = DEFAULT_CONSOLE_LOG_FORMAT;
        timeFormat = DEFAULT_CONSOLE_DATETIME_FORMAT;
        level = LoggerSetting.getDefaultLoggingLevel();
        if (level == null) {
            level = LoggingLevel.DEBUG;
        }
    }

    /*
     * Sets the maximum logging level
     * @param level the maximum logging level
     */
    global void setLevel(LoggingLevel level) {
        if (level == null) return;
        this.level = level;
    }

    /*
     * Formats the log
     * @param level the logging level
     * @param logMessage a message to be logged
     * @param logObject object for which the log is originated
     * @param reference an user reference for identification
     * @return a formatted log message
     */
    private String formatLog(LoggingLevel level, String logMessage, Object logObject, String reference) {
        String log = String.format(this.logFormat, new List<String>{
                DateTime.now().formatGMT(this.timeFormat),
                String.valueOf(level),
                LoggerUtils.getObjectType(logObject),
                this.userName,
                this.userId,
                logMessage
        });
        return log;
    }

    /*
     * Log an info message
     * @param logMessage message to be logged
     * @param logObject object for which the log is originated
     * @param reference an user reference for identification
     */
    global void info(String logMessage, Object logObject, String reference) {
        try {
            if (LoggingLevel.INFO.ordinal() < level.ordinal()) return;
            System.debug(LoggingLevel.INFO, formatLog(LoggingLevel.INFO, logMessage, logObject, reference));
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, ex);
        }
    }

    /*
     * Log a debug message
     * @param logMessage message to be logged
     * @param logObject object for which the log is originated
     * @param reference an user reference for identification
     */
    global void debug(String logMessage, Object logObject, String reference) {
        try {
            if (LoggingLevel.DEBUG.ordinal() < level.ordinal()) return;
            System.debug(LoggingLevel.DEBUG, formatLog(LoggingLevel.DEBUG, logMessage, logObject, reference));
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, ex);
        }
    }

    /*
     * Log a warning message
     * @param logMessage message to be logged
     * @param logObject object for which the log is originated
     * @param reference an user reference for identification
     */
    global void warn(String logMessage, Object logObject, String reference) {
        try {
            if (LoggingLevel.WARN.ordinal() < level.ordinal()) return;
            System.debug(LoggingLevel.WARN, formatLog(LoggingLevel.WARN, logMessage, logObject, reference));
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, ex);
        }
    }

    /*
     * Log an error message
     * @param logMessage message to be logged
     * @param logObject object for which the log is originated
     * @param reference an user reference for identification
     */
    global void error(String logMessage, Object logObject, String reference) {
        try {
            System.debug(LoggingLevel.ERROR, formatLog(LoggingLevel.ERROR, logMessage, logObject, reference));
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, ex);
        }
    }

    /*
     * Log an error exception
     * @param ex Exception object to be logged
     * @param logObject object for which the log is originated
     * @param reference an user reference for identification
     */
    global void error(Exception ex, Object logObject, String reference) {
        try {
            String exceptionMessage = LoggerUtils.formatExceptionTree(ex);
            System.debug(LoggingLevel.ERROR, formatLog(LoggingLevel.ERROR, exceptionMessage, logObject, reference));
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e);
        }
    }

    /*
     * Log an error exception with a custom log message
     * @param logMessage message to be logged
     * @param ex Exception object to be logged
     * @param logObject object for which the log is originated
     * @param reference an user reference for identification
     */
    global void error(String logMessage, Exception ex, Object logObject, String reference) {
        try {
            String exceptionMessage = LoggerUtils.formatExceptionTree(ex);
            String outputMessage = logMessage + '\n' + exceptionMessage;
            System.debug(LoggingLevel.ERROR, formatLog(LoggingLevel.ERROR, outputMessage, logObject, reference));
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e);
        }
    }
}