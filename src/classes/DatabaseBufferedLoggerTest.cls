/**
 * Created by Wenbo on 7/1/2017.
 * DatabaseBufferedLoggerTest
 */

@IsTest
private class DatabaseBufferedLoggerTest {
    static testMethod void testBufferedLogging() {
        Log_Setting__c logLevelSetting = new Log_Setting__c();
        logLevelSetting.Name = 'Log_Level';
        logLevelSetting.Value__c = 'DEBUG';
        logLevelSetting.Short_Description__c = 'Default log currentLoggingLevel for loggers. Values from LoggingLevel enum class';
        insert logLevelSetting;

        DatabaseBufferedLogger logger = new DatabaseBufferedLogger();
        logger.info('Test logging', '{ jsonData: true }', '{ jsonData: true }',
                DatabaseBufferedLoggerTest.class, 'ref0001');
        logger.debug('Test logging', '{ jsonData: true }', '{ jsonData: true }',
                DatabaseBufferedLoggerTest.class, 'ref0001');
        logger.warn('Test logging', '{ jsonData: true }', '{ jsonData: true }',
                DatabaseBufferedLoggerTest.class, 'ref0001');
        logger.error('Test logging', '{ jsonData: true }', '{ jsonData: true }',
                DatabaseBufferedLoggerTest.class, 'ref0001');

        try {
            throw new GeneralException('My exception');
        } catch (Exception ex) {
            logger.error(ex, DatabaseBufferedLoggerTest.class, null);
            logger.error('Test loggin', ex, DatabaseBufferedLoggerTest.class, null);
        }

        List<Log__c> logList = [SELECT Id FROM Log__c];
        System.assertEquals(0, logList.size());

        logger.flush();

        logList = [SELECT Id FROM Log__c];
        System.assertEquals(6, logList.size());
    }
}