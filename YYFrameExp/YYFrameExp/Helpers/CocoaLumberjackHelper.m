//
//  CocoaLumberjackHelper.m
//  jimao
//
//  Created by pan chow on 15/4/17.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "CocoaLumberjackHelper.h"

#import "CustomDDLogFormatter.h"
#import "CustomFMDBDDLogger.h"

/*
 DDLogError(@"log error");
 DDLogDebug(@"log debug");
 DDLogVerbose(@"log verbose");
 DDLogWarn(@"log warning");
 DDLogInfo(@"log info");
 */
@implementation CocoaLumberjackHelper


#pragma mark ======  private  ======
+ (DDFileLogger *)fileLogger
{
    DDFileLogger *fileLogger;
    if (fileLogger == nil)
    {
        fileLogger = [[DDFileLogger alloc] init];
        
        fileLogger.maximumFileSize = (1024 * 1024 * 1); //  1 MB
        fileLogger.rollingFrequency = (60 * 60 * 24);   // 24 Hours
        
        fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
    }
    
    return fileLogger;
}
/**
 * Suite 1 - Logging to Console only.
 **/
+ (void)configureLoggingForSuite1
{
    [DDLog removeAllLoggers];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}
/**
 * Suite 2 - Logging to File only.
 *
 * We attempt to configure the logging so it will be forced to roll the log files during the test.
 * Rolling the log files requires creating and opening a new file.
 * This could be a performance hit, so we want our benchmark to take this into account.
 **/
+ (void)configureLoggingForSuite2
{
    [DDLog removeAllLoggers];
    
    [DDLog addLogger:[self fileLogger]];
}
/**
 * Suite 3 - Logging to Console & File.
 **/
+ (void)configureLoggingForSuite3
{
    [DDLog removeAllLoggers];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[self fileLogger]];
}
+ (void)configCustomFMDBLoogger
{
    [DDLog removeAllLoggers];
    
    // 定义日志级别
#ifdef DEBUG
    static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
    static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif
    
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:ddLogLevel];
    [DDLog addLogger:[CustomFMDBDDLogger sharedInstance] withLevel:ddLogLevel];
}
+ (NSArray *)getItemsFromFMDBLogger
{
    CustomFMDBDDLogger *logger = [CustomFMDBDDLogger sharedInstance];
    return [logger getItemsFromFMDB];
}
// add logers
+ (void)addLogger
{
    // 定义日志级别
#ifdef DEBUG
    static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
    static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif
    
    //[DDLog addLogger:[DDASLLogger sharedInstance]];
    
    DDTTYLogger *ttyLoger = [DDTTYLogger sharedInstance];
    [ttyLoger setLogFormatter:[[CustomDDLogFormatter alloc] init]];
    [DDLog addLogger:ttyLoger withLevel:ddLogLevel];
    
    [CocoaLumberjackHelper addFileLoggerWithLevel:ddLogLevel];
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
}
+ (void)addFileLoggerWithLevel:(DDLogLevel)level
{
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;//one week
    
    [fileLogger setLogFormatter:[[CustomDDLogFormatter alloc] init]];
    [DDLog addLogger:fileLogger withLevel:level];
}

@end
