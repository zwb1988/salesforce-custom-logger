/**
 * Created by Wenbo on 6/25/2017.
 * ConsoleLoggerTest
 */

@isTest
public class ConsoleLoggerTest {

    static testMethod void testConsoleLogger() {
        LoggerInterface logger;
        logger = LoggerUtils.getLogger('ConsoleLogger');
        System.assert(logger != null);

        logger.info('Test logging', ConsoleLogger.class, null);
        logger.debug('Test logging', ConsoleLogger.class, null);
        logger.warn('Test logging', ConsoleLogger.class, null);
        logger.error('Test logging', ConsoleLogger.class, null);

        try {
            throw new GeneralException('My exception');
        } catch (Exception ex) {
            logger.error(ex, ConsoleLogger.class, null);
            logger.error('Test loggin', ex, ConsoleLogger.class, null);
        }
    }
}