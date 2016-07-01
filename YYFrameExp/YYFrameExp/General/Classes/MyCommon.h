//
//  MyCommon.h
//  FlowExp
//
//  Created by Dongle Su on 14-5-13.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommon : NSObject
+ (NSString *)getPrettySize:(int)size;
+ (NSString *)getPrettyCount:(int)count;
+ (NSString *)stringOfDate:(NSDate *)date format:(NSString *)format;
@end
