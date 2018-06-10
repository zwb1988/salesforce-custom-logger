# salesforce-custom-logger

A custom logger for the Salesforce Apex


## Getting Started

These instructions will get you a copy of the project deployed to your target Salesforce org instance with the **Ant Metadata Migration Tool**.
If your project uses the SFDX, you need to manually copy the source files to appropriate places for your deployment.

### Prerequisites

Ant Migration Tool is required for deploying the project.
If you haven't installed it yet, please follow the official installation guide [here](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool_container_install.htm).

Data Loader is also required for importing logger configuration.
Please find the instruction [here](https://developer.salesforce.com/page/Data_Loader) to set it up.

### Installing

Use the ant migration tool deploy the package to the target Salesforce org. Refer to the documentation for the ant migration tool for its usage.

Once it is deployed sucessfully, use the data loader to import the logger configuration setting, which you can find the csv file under the data directory (*data/log_setting.csv*) in the repo.

### Example

LoggerManager class is the entry point for the logger. See a list of common usage below:
```java
LoggerManager.Logger.info('Logger Message', Apex.class, null);
LoggerManager.Logger.debug('Logger Message', this, '');
LoggerManager.Logger.warn('Logger Message', 'MyClass', '000000000001');
LoggerManager.Logger.error('Logger Message', ex, this, '00000000-0000-0000-0000-000000000000');
```

LoggerManager class also has a DBufLogger, which is used for saving log entries in bulk. By default, DBLogger will create a log entry immediately after any of the logging methods is called. In the case where you want to buffer all the logs and flush them in the end, you can use this DBufLogger. See one usage below:

```java
try {
    LoggerManager.DBufLogger.debug('Callout Example', 'outbound data', null, this, 'my ref');
    // HTTP request ...
    // system callout here. (In Apex, NO DML operation is allowed before a callout)
    // HTTP reponse ...
    LoggerManager.DBufLogger.debug('Callout Example', null, 'inbound data', this, 'my ref');
} catch (Exception ex) {
    LoggerManager.DBufLogger.error('Logger Message', ex, this, 'external ID');
} finally {
    LoggerManager.DBufLogger.flush();
}
```

*For more examples, please check them out in in the test files.*

### Extension
The LoggerManager.Logger is a container that contains one or more logger instances. It is configured in the logger setting (Log_Setting__c.Classes_STD_Logger).
The project provides 2 out of the box loggers: DatabaseLogger and ConsoleLogger. You can also implement your own Logger by  implementing the interface: LoggerInterface and register it in the logger setting.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

