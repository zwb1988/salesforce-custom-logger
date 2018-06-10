/**
 * Created by Wenbo on 6/25/2017.
 * DatabaseLoggerTest
 */

@IsTest
private class DatabaseLoggerTest {
    static DatabaseLogger logger;

    static {
        logger = (DatabaseLogger) LoggerUtils.getLogger('DatabaseLogger');
    }

    static testMethod void testDatabaseLoggerStandardMethods() {
        Test.startTest();
        logger.setLevel(LoggingLevel.DEBUG);
        logger.info('Test logging', DatabaseLoggerTest.class, 'testInfo');
        logger.debug('Test logging', DatabaseLoggerTest.class, 'testDebug');
        logger.warn('Test logging', DatabaseLoggerTest.class, 'testWarn');
        logger.error('Test logging', DatabaseLoggerTest.class, 'testError');
        try {
            throw new GeneralException('My exception');
        } catch (Exception ex) {
            logger.error(ex, ConsoleLogger.class, 'testErrExcept');
            logger.error('Test loggin', ex, ConsoleLogger.class, 'testErrExceptMsg');
        }

        assertSingleLog('testInfo');
        assertSingleLog('testDebug');
        assertSingleLog('testWarn');
        assertSingleLog('testError');
        assertSingleLog('testErrExcept');
        assertSingleLog('testErrExceptMsg');

        Test.stopTest();
    }

    static testMethod void testDatabaseLoggerExtendedMethods() {
        Test.startTest();
        logger.setLevel(LoggingLevel.DEBUG);
        Id logId;
        Id childLogId;
        List<Log__c> logList;
        List<Log__c> childLogList;

        logId = logger.info('Test message', '{ samepleJsonData: "hello" }', '{ samepleJsonData: "hello" }',
                DatabaseLoggerTest.class, 'testInfo');
        logList = [SELECT Id, Data__c FROM Log__c WHERE Id = :logId];
        System.assertEquals(1, logList.size());
        System.assert(String.isNotBlank(logList[0].Data__c));

        childLogId =
                logger.info('Test message', '{ samepleJsonData: "hello" }', '{ samepleJsonData: "hello" }',
                        DatabaseLoggerTest.class, 'testInfoChild', logId);
        childLogList = [SELECT Id FROM Log__c WHERE Parent_Log__c = :logId];
        System.assertEquals(1, childLogList.size());

        logId = logger.debug('Test message', '{ samepleJsonData: "hello" }', '{ samepleJsonData: "hello" }',
                DatabaseLoggerTest.class, 'testDebug');
        logList = [SELECT Id, Data__c FROM Log__c WHERE Id = :logId];
        System.assertEquals(1, logList.size());
        System.assert(String.isNotBlank(logList[0].Data__c));

        childLogId =
                logger.debug('Test message', '{ samepleJsonData: "hello" }', '{ samepleJsonData: "hello" }',
                        DatabaseLoggerTest.class, 'testInfoChild', logId);
        childLogList = [SELECT Id FROM Log__c WHERE Parent_Log__c = :logId];
        System.assertEquals(1, childLogList.size());

        logId = logger.warn('Test message', '{ samepleJsonData: "hello" }', '{ samepleJsonData: "hello" }',
                DatabaseLoggerTest.class, 'testWarn');
        logList = [SELECT Id, Data__c FROM Log__c WHERE Id = :logId];
        System.assertEquals(1, logList.size());
        System.assert(String.isNotBlank(logList[0].Data__c));

        childLogId =
                logger.warn('Test message', '{ samepleJsonData: "hello" }', '{ samepleJsonData: "hello" }',
                        DatabaseLoggerTest.class, 'testInfoChild', logId);
        childLogList = [SELECT Id, Data__c FROM Log__c WHERE Parent_Log__c = :logId];
        System.assertEquals(1, childLogList.size());

        logId = logger.error('Test message', '{ samepleJsonData: "hello" }', '{ samepleJsonData: "hello" }',
                DatabaseLoggerTest.class, 'testError');
        logList = [SELECT Id, Data__c FROM Log__c WHERE Id = :logId];
        System.assertEquals(1, logList.size());
        System.assert(String.isNotBlank(logList[0].Data__c));

        childLogId =
                logger.error('Test message', '{ samepleJsonData: "hello" }', '{ samepleJsonData: "hello" }',
                        DatabaseLoggerTest.class, 'testInfoChild', logId);
        childLogList = [SELECT Id, Data__c FROM Log__c WHERE Parent_Log__c = :logId];
        System.assertEquals(1, childLogList.size());

        Test.stopTest();
    }

    static testMethod void testDatabaseLoggerWithWarningLevel() {
        Test.startTest();
        logger.setLevel(LoggingLevel.WARN);
        logger.info('Test logging', DatabaseLoggerTest.class, 'testInfoW');
        logger.debug('Test logging', DatabaseLoggerTest.class, 'testDebugW');
        logger.warn('Test logging', DatabaseLoggerTest.class, 'testWarnW');
        logger.error('Test logging', DatabaseLoggerTest.class, 'testErrorW');

        assertSingleLogNotExist('testInfoW');
        assertSingleLogNotExist('testDebugW');
        assertSingleLog('testWarnW');
        assertSingleLog('testErrorW');

        Test.stopTest();
    }

    static void assertSingleLog(String reference) {
        List<Log__c> logList = [SELECT Id FROM Log__c WHERE Reference__c = :reference];
        System.assertEquals(1, logList.size());
    }

    static void assertSingleLogNotExist(String reference) {
        List<Log__c> logList = [SELECT Id FROM Log__c WHERE Reference__c = :reference];
        System.assertEquals(0, logList.size());
    }
}