//
//  CustomFMDBDDLogger.m
//  jimao
//
//  Created by pan chow on 15/4/24.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "CustomFMDBDDLogger.h"
#import "FMDBLogEntry.h"


#define DATABASE_DIR @"SQLiteLogger"
#define DATABASE_NAME @"log.sqlite"
#define LOGGER_TABLE_NAME @"logs"

@interface CustomFMDBDDLogger()

@end

@implementation CustomFMDBDDLogger



+ (instancetype)sharedInstance
{
    static CustomFMDBDDLogger *sharedInstance=nil;
    static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    
    sharedInstance = [[CustomFMDBDDLogger alloc] initWithLogDirectory:[[self class] applicationFilesDirectory]];
    
    sharedInstance.saveThreshold     = 500;//500条进行记录
    sharedInstance.saveInterval      = 60;               // 60 seconds
    sharedInstance.maxAge            = 60 * 60 * 24 * 7; //  7 days
    sharedInstance.deleteInterval    = 60 * 5;           //  5 minutes
    sharedInstance.deleteOnEverySave = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:sharedInstance
                                             selector:@selector(saveOnSuspend)
                                                 name:@"UIApplicationWillResignActiveNotification"
                                               object:nil];
    
    
    });
    return sharedInstance;
}
- (void)saveOnSuspend {
    dispatch_async(_loggerQueue, ^{
        [self db_save];
    });
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSArray *)getItemsFromFMDB
{
    NSArray *array = nil;
    array = [dbHelper getAllItemsFromTable:LOGGER_TABLE_NAME];
    return array;
}

- (id)initWithLogDirectory:(NSString *)aLogDirectory
{
    if ((self = [super init]))
    {
        logDirectory = [aLogDirectory copy];
        
        pendingLogEntries = [[NSMutableArray alloc] initWithCapacity:_saveThreshold];
        
        _fmt = [[NSDateFormatter alloc] init];
        [_fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        [self initLogDirectory];
        [self initDatabaseHelper];
    }
    
    return self;
}
#pragma mark ======  private  ======
+ (NSString *)applicationFilesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();//   NSApplicationSupportDirectory
    
    return [basePath stringByAppendingPathComponent:DATABASE_DIR];
}
- (void)initLogDirectory
{
    // Validate log directory exists or create the directory.
    
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:logDirectory isDirectory:&isDirectory])
    {
        if (!isDirectory)//not dir
        {
            logDirectory = nil;
        }
    }
    else
    {
        NSError *error = nil;
        
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory
                                                withIntermediateDirectories:YES
                                                                 attributes:nil
                                                                      error:&error];
        if (!result)
        {
            logDirectory = nil;
        }
    }
}
- (void)initDatabaseHelper
{
    if (logDirectory == nil)
    {
        return;
    }
    
    NSString *path = [logDirectory stringByAppendingPathComponent:DATABASE_NAME];
    dbHelper =  [[FMDBHelper alloc] initWithDBWithPath:path];
    
    if(0)//! open
    {
        dbHelper = nil;
        return;
    }
    
    if(![dbHelper createTableWithName:LOGGER_TABLE_NAME])
    {
        dbHelper = nil;
        return;
    }
}
+ (NSString *)getSafelyValue:(id)value
{
    if(value)
    {
        return [NSString stringWithFormat:@"%@",value];
    }
    return @"";
}
#pragma mark AbstractDatabaseLogger Overrides

- (BOOL)db_log:(DDLogMessage *)logMessage
{
    // You may be wondering, how come we don't just do the insert here and be done with it?
    // Is the buffering really needed?
    //
    // From the SQLite FAQ:
    //
    // (19) INSERT is really slow - I can only do few dozen INSERTs per second
    //
    // Actually, SQLite will easily do 50,000 or more INSERT statements per second on an average desktop computer.
    // But it will only do a few dozen transactions per second. Transaction speed is limited by the rotational
    // speed of your disk drive. A transaction normally requires two complete rotations of the disk platter, which
    // on a 7200RPM disk drive limits you to about 60 transactions per second.
    //
    // Transaction speed is limited by disk drive speed because (by default) SQLite actually waits until the data
    // really is safely stored on the disk surface before the transaction is complete. That way, if you suddenly
    // lose power or if your OS crashes, your data is still safe. For details, read about atomic commit in SQLite.
    //
    // By default, each INSERT statement is its own transaction. But if you surround multiple INSERT statements
    // with BEGIN...COMMIT then all the inserts are grouped into a single transaction. The time needed to commit
    // the transaction is amortized over all the enclosed insert statements and so the time per insert statement
    // is greatly reduced.
    if ([pendingLogEntries count] > 2000) {
        // 如果段时间内进入大量log，并且迟迟发不到服务器上，我们可以判断哪里出了问题，在这之后的 log 暂时不处理了。
        // 但我们依然要告诉 DDLog 这个存进去了。
        return YES;
    }
    FMDBLogEntry *logEntry = [[FMDBLogEntry alloc] initWithLogMessage:logMessage];
    
    [pendingLogEntries addObject:logEntry];
    
    // Return YES if an item was added to the buffer.
    // Return NO if the logMessage was ignored.
    
    return YES;
}
- (void)db_save
{
    if (![self isOnInternalLoggerQueue])
    {
        NSAssert(NO, @"db_saveAndDelete should only be executed on the internalLoggerQueue thread, if you're seeing this, your doing it wrong.");
    }
    
    if ([pendingLogEntries count] == 0)
    {
        // Nothing to save.
        // The superclass won't likely call us if this is the case, but we're being cautious.
        return;
    }

    for (FMDBLogEntry *logEntry in pendingLogEntries)
    {
        NSDictionary *dic = @{@"message" : [CustomFMDBDDLogger getSafelyValue:logEntry.message],
                               @"level" : [CustomFMDBDDLogger getSafelyValue:logEntry.level],
                               @"flag" :[CustomFMDBDDLogger getSafelyValue:logEntry.flag],
                               @"context" :[CustomFMDBDDLogger getSafelyValue:logEntry.context],
                              @"file" :[CustomFMDBDDLogger getSafelyValue:logEntry.file],
                              @"fileName" :[CustomFMDBDDLogger getSafelyValue:logEntry.fileName],
                              @"function" :[CustomFMDBDDLogger getSafelyValue:logEntry.function],
                              @"line" :[CustomFMDBDDLogger getSafelyValue:logEntry.line],
                              @"options" :[CustomFMDBDDLogger getSafelyValue:logEntry.options],
                              @"timestamp" :[CustomFMDBDDLogger getSafelyValue:[_fmt stringFromDate:logEntry.timestamp]],
                              @"threadID" :[CustomFMDBDDLogger getSafelyValue:logEntry.threadID],
                              @"threadName" :[CustomFMDBDDLogger getSafelyValue:logEntry.threadName],
                              @"queueLabel" :[CustomFMDBDDLogger getSafelyValue:logEntry.queueLabel]};
        
        logEntry.keyId = [NSString stringWithFormat:@"%ld",[dbHelper  getCountFromTable:LOGGER_TABLE_NAME]];
        [dbHelper putObject:dic withId:[CustomFMDBDDLogger getSafelyValue:logEntry.keyId] timeString:[_fmt stringFromDate:logEntry.timestamp] intoTable:LOGGER_TABLE_NAME];
//        [database executeUpdate:cmd, logEntry->context,
//         logEntry->level,
//         logEntry->message,
//         logEntry->timestamp];
        /*
         获取缓存中所有数据，之后将缓存清空
         NSArray *oldLogMessagesArray = [_logMessagesArray copy];
         _logMessagesArray = [NSMutableArray arrayWithCapacity:0];
         //用换行符，把所有的数据拼成一个大字符串
         NSString *logMessagesString = [oldLogMessagesArray componentsJoinedByString:@"\n"];
         //发送给咱自己服务器(自己实现了)
         [self post:logMessagesString];
         */
    }
    
    [pendingLogEntries removeAllObjects];
}
- (void)db_delete
{
    if (_maxAge <= 0.0)
    {
        // Deleting old log entries is disabled.
        // The superclass won't likely call us if this is the case, but we're being cautious.
        return;
    }
    
    
    NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:(-1.0 * _maxAge)];
    NSString *dateString = [_fmt stringFromDate:maxDate];
    [dbHelper deleteObjectByTime:[NSString stringWithFormat:@"%@",dateString] fromTable:LOGGER_TABLE_NAME];
}

- (void)db_saveAndDelete
{
    [self db_delete];
    [self db_save];
}

@end
