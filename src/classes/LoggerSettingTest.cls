/**
 * Created by Wenbo on 9/4/2017.
 */

@IsTest
public with sharing class LoggerSettingTest {

    static testMethod void testDefaultSettings() {
        System.assertEquals(true, LoggerSetting.isLoggingEnabled());
        System.assert(LoggingLevel.ERROR == LoggerSetting.getDefaultLoggingLevel());

        List<String> returnStringList = LoggerSetting.getLoggerNames();
        System.assertEquals('ConsoleLogger', returnStringList.get(0));

        Log_Setting__c stdLogger = new Log_Setting__c();
        stdLogger.Name = 'Classes_STD_Logger';
        stdLogger.Value__c = 'DatabaseLogger';
        insert stdLogger;
        returnStringList = LoggerSetting.getLoggerNames();
        System.assertEquals('DatabaseLogger', returnStringList.get(0));

        System.assertEquals('DatabaseLogger', LoggerSetting.getDBLoggerName());
    }

    static testMethod void testLoggerMaxLengthSmallerThanThreshold() {
        Log_Setting__c maxLogLengthSetting = new Log_Setting__c();
        maxLogLengthSetting.Name = 'Max_Log_Length';
        maxLogLengthSetting.Value__c = '100';
        maxLogLengthSetting.Short_Description__c = 'Maximum length for the log message';
        insert maxLogLengthSetting;
        System.assertEquals(131072, LoggerSetting.MAX_STRING_LOG_LENGTH);
    }

    static testMethod void testLoggerSettings() {
        Test.startTest();

        Log_Setting__c stdLoggerSetting = new Log_Setting__c();
        stdLoggerSetting.Name = 'Classes_STD_Logger';
        stdLoggerSetting.Value__c = 'Account,Case';
        stdLoggerSetting.Short_Description__c = 'Demo data only';
        insert stdLoggerSetting;

        Log_Setting__c enabledSetting = new Log_Setting__c();
        enabledSetting.Name = 'Enabled';
        enabledSetting.Value__c = 'TRUE';
        enabledSetting.Short_Description__c = 'Turn the loggers on if the value is TRUE, FALSE otherwise';
        insert enabledSetting;

        Log_Setting__c maxLogLengthSetting = new Log_Setting__c();
        maxLogLengthSetting.Name = 'Max_Log_Length';
        maxLogLengthSetting.Value__c = '131072';
        maxLogLengthSetting.Short_Description__c = 'Maximum length for the log message';
        insert maxLogLengthSetting;

        Log_Setting__c logLevelSetting = new Log_Setting__c();
        logLevelSetting.Name = 'Log_Level';
        logLevelSetting.Value__c = 'DEBUG';
        logLevelSetting.Short_Description__c = 'Default log currentLoggingLevel for loggers. Values from LoggingLevel enum class';
        insert logLevelSetting;

        Log_Setting__c dbLoggerSetting = new Log_Setting__c();
        dbLoggerSetting.Name = 'Class_DBLogger';
        dbLoggerSetting.Value__c = 'Account';
        dbLoggerSetting.Short_Description__c = 'Demo data only';
        insert dbLoggerSetting;

        // test logging enable
        System.assert(LoggerSetting.isLoggingEnabled());
        enabledSetting.Value__c = 'false';
        update enabledSetting;
        System.assert(!LoggerSetting.isLoggingEnabled());

        // test default logging currentLoggingLevel
        LoggingLevel currentLoggingLevel;
        logLevelSetting.Value__c = 'DEBUG';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.DEBUG == currentLoggingLevel);

        logLevelSetting.Value__c = 'ERROR';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.ERROR == currentLoggingLevel);

        logLevelSetting.Value__c = 'FINE';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.FINE == currentLoggingLevel);

        logLevelSetting.Value__c = 'FINER';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.FINER == currentLoggingLevel);

        logLevelSetting.Value__c = 'FINEST';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.FINEST == currentLoggingLevel);

        logLevelSetting.Value__c = 'INFO';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.INFO == currentLoggingLevel);

        logLevelSetting.Value__c = 'INTERNAL';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.INTERNAL == currentLoggingLevel);

        logLevelSetting.Value__c = 'NONE';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.NONE == currentLoggingLevel);

        logLevelSetting.Value__c = 'WARN';
        update logLevelSetting;
        currentLoggingLevel = LoggerSetting.getDefaultLoggingLevel();
        System.assert(LoggingLevel.WARN == currentLoggingLevel);

        // test get default log name - use only test class type
        List<String> returnStringList = LoggerSetting.getLoggerNames();
        System.assertEquals(2, returnStringList.size());
        System.assertEquals('Account', returnStringList.get(0));
        System.assertEquals('Case', returnStringList.get(1));
        stdLoggerSetting.Value__c = 'abc,Account';
        update stdLoggerSetting;
        returnStringList = LoggerSetting.getLoggerNames();
        System.assertEquals('ConsoleLogger', returnStringList.get(0));
        stdLoggerSetting.Value__c = '';
        update stdLoggerSetting;
        System.assertEquals('ConsoleLogger', returnStringList.get(0));

        // test get default DB logger name - use only test class type
        String returnString = LoggerSetting.getDBLoggerName();
        System.assertEquals('Account', returnString);
        dbLoggerSetting.Value__c = '';
        update dbLoggerSetting;
        returnString = LoggerSetting.getDBLoggerName();
        System.assertEquals('DatabaseLogger', returnString);

        Test.stopTest();
    }
}