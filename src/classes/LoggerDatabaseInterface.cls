/**
 * Created by Wenbo on 6/24/2017.
 * LoggerDatabaseInterface - Defines a set of methods for database logging
 */

global interface LoggerDatabaseInterface extends LoggerInterface {
    Id info(String logMessage, String data, String outboundData, Object logObject, String reference);
    Id debug(String logMessage, String data, String outboundData, Object logObject, String reference);
    Id warn(String logMessage, String data, String outboundData, Object logObject, String reference);
    Id error(String logMessage, String data, String outboundData, Object logObject, String reference);

    Id info(String logMessage, String data, String outboundData, Object logObject, String reference, Id parentId);
    Id debug(String logMessage, String data, String outboundData, Object logObject, String reference, Id parentId);
    Id warn(String logMessage, String data, String outboundData, Object logObject, String reference, Id parentId);
    Id error(String logMessage, String data, String outboundData, Object logObject, String reference, Id parentId);
}