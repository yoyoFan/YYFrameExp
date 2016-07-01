//
//  CustomDDLogFormatter.h
//  jimao
//
//  Created by pan chow on 15/4/23.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/DDLog.h>

@interface CustomDDLogFormatter : NSObject<DDLogFormatter>
{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end
