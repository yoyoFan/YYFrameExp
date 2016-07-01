//
//  FMDBLogEntry.m
//  jimao
//
//  Created by pan chow on 15/4/25.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "FMDBLogEntry.h"

@implementation FMDBLogEntry

- (id)initWithLogMessage:(DDLogMessage *)logMessage
{
    if ((self = [super init]))
    {
        self.keyId = nil;
        
        self.message   = logMessage->_message;
        self.level     =  @(logMessage->_level);
        self.flag     = @(logMessage->_flag);
        self.context   = @(logMessage->_context);
        self.file = logMessage->_file;
        self.fileName = logMessage->_fileName;
        self.function = logMessage->_function;
        self.line = @(logMessage->_line);
        
        //tag
        self.options = @(logMessage->_options);
        self.timestamp = logMessage->_timestamp;
        self.threadID = logMessage->_threadID;
        self.threadName = logMessage->_threadName;
        self.queueLabel = logMessage->_queueLabel;
    }
    return self;
}
- (instancetype)initWithLogDic:(NSDictionary *)dic
{
    if ((self = [super init]))
    {
        self.keyId = dic[@"id"];
        
        self.message   = dic[@"message"];
        self.level     =  dic[@"level"];
        self.flag     = dic[@"flag"];
        self.context   = dic[@"context"];
        self.file = dic[@"file"];
        self.fileName = dic[@"fileName"];
        self.function = dic[@"function"];
        self.line = dic[@"line"];
        
        //tag
        self.options = dic[@"options"];
        self.timestamp = dic[@"timestamp"];
        self.threadID = dic[@"threadID"];
        self.threadName = dic[@"threadName"];
        self.queueLabel = dic[@"queueLabel"];
    }
    return self;
}
@end
