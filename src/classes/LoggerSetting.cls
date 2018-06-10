/**
 * Created by Wenbo on 6/24/2017.
 * LoggerSetting - Contains a set of static methods and constants for loggers' configuration.
 * Usually these settings will be retrieved from external configuration source.
 */

global without sharing class LoggerSetting {
    public static final String PARAM_ENABLED = 'Enabled';
    public static final String PARAM_LOG_LEVEL = 'Log_Level';
    public static final String PARAM_DB_LOGGER = 'Class_DBLogger';
    public static final String PARAM_STD_Logger = 'Classes_STD_Logger';
    public static final String PARAM_MAX_LOG_LENGTH = 'Max_Log_Length';
    global static final Integer MAX_STRING_LOG_LENGTH;

    static {
        try {
            Log_Setting__c setting = [
                    SELECT Value__c
                    FROM Log_Setting__c
                    WHERE Name = :LoggerSetting.PARAM_MAX_LOG_LENGTH
            ];
            Integer maxLogLength = Integer.valueOf(setting.Value__c);
            if (maxLogLength > 255) {
                MAX_STRING_LOG_LENGTH = maxLogLength;
            } else {
                MAX_STRING_LOG_LENGTH = 131072;
            }
        } catch (Exception ex) {
            System.debug(ex);
            MAX_STRING_LOG_LENGTH = 131072;
        }
    }

    /*
     * A kill switch to turn off the custom logging
     * @return a boolean value indicate whether logging activities should be enabled
     */
    global static Boolean isLoggingEnabled() {
        try {
            Log_Setting__c setting = [
                    SELECT Value__c
                    FROM Log_Setting__c
                    WHERE Name = :LoggerSetting.PARAM_ENABLED
            ];
            return Boolean.valueOf(setting.Value__c);
        } catch (Exception ex) {
            System.debug(ex);
        }
        return true;
    }

    /*
     * Gets the default logging level
     * @return the default logging level
     */
    global static LoggingLevel getDefaultLoggingLevel() {
        // damn Apex is tedious in terms of enum parsing
        try {
            Log_Setting__c setting = [
                    SELECT Value__c
                    FROM Log_Setting__c
                    WHERE Name = :LoggerSetting.PARAM_LOG_LEVEL
            ];
            String level = setting.Value__c;
            if (level.toUpperCase() == 'DEBUG') {
                return LoggingLevel.DEBUG;
            }
            if (level.toUpperCase() == 'ERROR') {
                return LoggingLevel.ERROR;
            }
            if (level.toUpperCase() == 'FINE') {
                return LoggingLevel.FINE;
            }
            if (level.toUpperCase() == 'FINER') {
                return LoggingLevel.FINER;
            }
            if (level.toUpperCase() == 'FINEST') {
                return LoggingLevel.FINEST;
            }
            if (level.toUpperCase() == 'INFO') {
                return LoggingLevel.INFO;
            }
            if (level.toUpperCase() == 'INTERNAL') {
                return LoggingLevel.INTERNAL;
            }
            if (level.toUpperCase() == 'NONE') {
                return LoggingLevel.NONE;
            }
            if (level.toUpperCase() == 'WARN') {
                return LoggingLevel.WARN;
            }
        } catch (Exception ex) {
            System.debug(ex);
        }
        return LoggingLevel.ERROR;
    }

    /*
     * Gets a list of available logger's names
     * @return a list of logger's names
     */
    global static List<String> getLoggerNames() {
        try {
            List<String> loggerClasses = new List<String>();
            Log_Setting__c setting = [
                    SELECT Value__c
                    FROM Log_Setting__c
                    WHERE Name = :LoggerSetting.PARAM_STD_Logger
            ];
            if (setting.Value__c.contains(',')) {
                loggerClasses = setting.Value__c.split(',');
            } else {
                loggerClasses = new List<String>{
                        setting.Value__c
                };
            }

            // check if type exists. If not, use the default logger
            Boolean allValidClasses = true;
            for (String className : loggerClasses) {
                Type classType = Type.forName(className);
                if (classType == null) {
                    allValidClasses = false;
                }
            }
            if (allValidClasses) {
                return loggerClasses;
            }
        } catch (Exception ex) {
            System.debug(ex);
        }

        return new List<String>{
                ConsoleLogger.class.getName()
                //DatabaseLogger.class.getName()
        };
    }

    /*
     * Gets a class of the DB logger
     * @return the name of the DB logger
     */
    global static String getDBLoggerName() {
        try {
            Log_Setting__c setting = [
                    SELECT Value__c
                    FROM Log_Setting__c
                    WHERE Name = :LoggerSetting.PARAM_DB_LOGGER
            ];
            String className = setting.Value__c;
            Type classType = Type.forName(className);
            if (classType != null) {
                return className;
            }
        } catch (Exception ex) {
            System.debug(ex);
        }
        return DatabaseLogger.class.getName();
    }
}