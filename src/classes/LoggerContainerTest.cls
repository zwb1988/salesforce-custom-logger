/**
 * Created by Wenbo on 7/1/2017.
 * LoggerContainerTest
 */

@IsTest
private class LoggerContainerTest {
    static testMethod void testContainer() {
        LoggerContainer container = new LoggerContainer();
        container.setLevel(LoggingLevel.DEBUG);
        container.register(ConsoleLogger.class.getName())
                .register(DatabaseLogger.class.getName())
                .unregister(ConsoleLogger.class.getName());

        System.assertEquals(1, container.getAllRegisteredNames().size());

        Log_Setting__c debugSetting = new Log_Setting__c();
        debugSetting.Name = 'Log_Level';
        debugSetting.Value__c = 'DEBUG';
        insert debugSetting;

        Log_Setting__c loggerSetting = new Log_Setting__c();
        loggerSetting.Name = 'Classes_STD_Logger';
        loggerSetting.Value__c = 'DatabaseLogger';
        insert loggerSetting;

        LoggerManager.Logger.info('Test logging', ConsoleLogger.class, null);
        LoggerManager.Logger.debug('Test logging', ConsoleLogger.class, null);
        LoggerManager.Logger.warn('Test logging', ConsoleLogger.class, null);
        LoggerManager.Logger.error('Test logging', ConsoleLogger.class, null);

        try {
            throw new GeneralException('My exception');
        } catch (Exception ex) {
            LoggerManager.Logger.error(ex, ConsoleLogger.class, null);
            LoggerManager.Logger.error('Test loggin', ex, ConsoleLogger.class, null);
        }

        List<Log__c> logList = [SELECT Id FROM Log__c];
        System.assertEquals(6, logList.size());
    }
}