/**
 * Created by Wenbo on 6/25/2017.
 * LoggerUtilsTest
 */

@IsTest
private class LoggerUtilsTest {
    static final String DEFAULT_LOGGER = 'ConsoleLogger';
    static testMethod void testGetLogger() {
        LoggerInterface consoleLogger = LoggerUtils.getLogger(DEFAULT_LOGGER);
        System.assert(consoleLogger != null);
    }

    static testMethod void testGetObjectType() {
        String accountType = LoggerUtils.getObjectType(new Account());
        System.assertEquals('Account', accountType);

        String primitiveType = LoggerUtils.getObjectType(12345.12);
        System.assertEquals('Decimal', primitiveType);

        String stringType = LoggerUtils.getObjectType('String');
        System.assertEquals('String', stringType);

        String booleanType = LoggerUtils.getObjectType(false);
        System.assertEquals('Boolean', booleanType);

        String dateType = LoggerUtils.getObjectType(Date.today());
        System.assertEquals('Date', dateType);

        String timeType = LoggerUtils.getObjectType(Time.newInstance(0, 0, 0, 0));
        System.assertEquals('Time', timeType);

        String dateTimeType = LoggerUtils.getObjectType(Datetime.now());
        System.assertEquals('DateTime', dateTimeType);
    }

    static testMethod void testConvertIdListToStringList() {
        List<Account> accountList = new List<Account>();
        final Integer maxCount = 10;
        for (Integer i = 0; i < maxCount; i++) {
            Account newAccount = new Account();
            newAccount.Name = 'Test' + i;
            accountList.add(newAccount);
        }
        insert accountList;
        List<Id> idList = new List<Id>();
        for (Account acc : accountList) {
            idList.add(acc.Id);
        }
        List<String> stringIdList = LoggerUtils.convertIdListToStringList(idList);
        System.assertEquals(maxCount, stringIdList.size());
        for (Integer i = 0; i < maxCount; i++) {
            System.assert(stringIdList[i] == String.valueOf(idList[i]));
        }
    }
}