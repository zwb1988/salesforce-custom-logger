/**
 * Created by Wenbo on 6/25/2017.
 * LoggerManagerTest
 */

@IsTest
private class LoggerManagerTest {
    static testMethod void testLoggerManager() {
        System.assert(LoggerManager.DBLogger != null);
        System.assert(LoggerManager.DBufLogger != null);

        System.assert(LoggerManager.Logger != null);
        LoggerManager.Logger.info('Test logging', LoggerManagerTest.class, null);
        LoggerManager.Logger.debug('Test logging', LoggerManagerTest.class, null);
        LoggerManager.Logger.warn('Test logging', LoggerManagerTest.class, null);
        LoggerManager.Logger.error('Test logging', LoggerManagerTest.class, null);

        try {
            throw new GeneralException('My exception');
        } catch (Exception ex) {
            LoggerManager.Logger.error(ex, LoggerManagerTest.class, null);
            LoggerManager.Logger.error('Test loggin', ex, LoggerManagerTest.class, null);
        }
    }

    static testMethod void testIntegrationLogger() {
        Log_Setting__c setting = new Log_Setting__c();
        setting.Name = 'Log_Level';
        setting.Value__c = 'DEBUG';
        insert setting;

        System.assert(LoggerManager.DBLogger != null);
        System.assert(
                LoggerManager.DBLogger.info(
                        'Test logging',
                        '{ jsonData: true }',
                        '{ jsonData: true }',
                        LoggerManagerTest.class, // replace with "this" if used in an instance class
                        'ref0001') != null
        );
        System.assert(
                LoggerManager.DBLogger.debug(
                        'Test logging',
                        '{ jsonData: true }',
                        '{ jsonData: true }',
                        LoggerManagerTest.class, // replace with "this" if used in an instance class
                        'ref0001') != null
        );
        System.assert(
                LoggerManager.DBLogger.warn(
                        'Test logging',
                        '{ jsonData: true }',
                        '{ jsonData: true }',
                        LoggerManagerTest.class, // replace with "this" if used in an instance class
                        'ref0001') != null
        );
        System.assert(
                LoggerManager.DBLogger.error(
                        'Test logging',
                        '{ jsonData: true }',
                        '{ jsonData: true }',
                        LoggerManagerTest.class, // replace with "this" if used in an instance class
                        'ref0001') != null
        );
    }
}