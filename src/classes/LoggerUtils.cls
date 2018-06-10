/**
 * Created by Wenbo on 6/23/2017.
 * LoggerUtils - Utility class for loggers
 */

global without sharing class LoggerUtils {
    /*
     * Gets an instance of the logger by its name
     * @param loggerName a logger's class name
     * @return an instance of the logger with the class name provided
     */
    global static LoggerInterface getLogger(String loggerName) {
        try {
            Type instanceType = Type.forName(loggerName);
            if (instanceType == null) return null;
            return (LoggerInterface) instanceType.newInstance();
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, ex);
        }
        return null;
    }

    /*
     * Gets the object type name
     * @param logObject an object instance
     * @return the name for the object
     */
    global static String getObjectType(Object logObject) {
        System.debug(LoggingLevel.ERROR, '*** :logObject ' + logObject);
        if (logObject == null) return '';

        if (logObject instanceof String 
            || logObject instanceof Type) {
            return String.valueOf(logObject);
        } else if (logObject instanceof Blob) {
            return 'Blob';
        } else if (logObject instanceof Boolean) {
            return 'Boolean';
        } else if (logObject instanceof Date) {
            return 'Date';
        } else if (logObject instanceof Datetime) {
            return 'DateTime';
        } else if (logObject instanceof Decimal) {
            return 'Decimal';
        } else if (logObject instanceof Double) {
            return 'Double';
        } else if (logObject instanceof ID) {
            return 'ID';
        } else if (logObject instanceof Integer) {
            return 'Integer';
        } else if (logObject instanceof Long) {
            return 'Long';
        } else if (logObject instanceof Time) {
            return 'Time';
        } else {
            String[] tokens = String.valueOf(logObject).split(':');
            if (tokens.size() <= 1) {
                return 'Object';
            } else {
                return tokens[0];
            }
        }
    }

    /*
     * Convert a list of IDs to a list of strings
     * @param idList a list of IDs
     * @return a list of equivalent IDs in string type
     */
    global static List<String> convertIdListToStringList(List<Id> idList) {
        if (idList == null || idList.size() == 0) return new List<String>();
        List<String> idStringList = new List<String>();
        for (Id i : idList) {
            idStringList.add((String) i);
        }
        return idStringList;
    }

    /*
     * Format an exception
     * @param ex an exception to be formated
     * @return a string that is formatted from an exception
     */
    global static String formatException(Exception ex) {
        return String.format('Exception - {0}: {1}\n' +
                'Stack trace:\n{2}\n', new List<String>{
                ex.getTypeName(),
                ex.getMessage(),
                ex.getStackTraceString()
        });
    }

    /*
     * Format an exception recursively. If an exception contains sub-cause exceptions, concatenate them and return
     * @param ex an exception to be formated
     * @return a string that is formatted from an exception
     */
    global static String formatExceptionTree(Exception ex) {
        if (ex == null) return '';
        String exceptionLog = formatException(ex);
        Exception causeException = ex.getCause();
        if (causeException == null) return exceptionLog;
        return exceptionLog + '\nCaused by: ' + formatExceptionTree(causeException);
    }
}