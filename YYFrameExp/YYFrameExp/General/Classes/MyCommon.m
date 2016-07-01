//
//  MyCommon.m
//  FlowExp
//
//  Created by Dongle Su on 14-5-13.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "MyCommon.h"

@implementation MyCommon
+ (NSString *)getPrettySize:(int)size{
    float prettySize;
    NSString *pretty;
    if (size > 1024*1024*1024) { //G
        prettySize = ((float)size)/(1024*1024*1024);
        pretty = [NSString stringWithFormat:@"%.2fG", prettySize];
    }
    else if (size > 1024*1024){ //M
        prettySize = ((float)size)/(1024*1024);
        pretty = [NSString stringWithFormat:@"%.2fM", prettySize];
    }
    else if (size > 1024){ //K
        prettySize = ((float)size)/1024;
        pretty = [NSString stringWithFormat:@"%.2fK", prettySize];
    }
    else{
        pretty = [NSString stringWithFormat:@"%dB", size];
    }

    return pretty;
}

+ (NSString *)getPrettyCount:(int)count{
    float prettyCount;
    NSString *pretty;
    if (count > 10000*10000) { //亿
        prettyCount = ((float)count)/(10000*10000);
        pretty = [NSString stringWithFormat:@"%.1f亿", prettyCount];
    }
    else if (count > 10000){ //万
        prettyCount = ((float)count)/10000;
        pretty = [NSString stringWithFormat:@"%.1f万", prettyCount];
    }
    else{
        pretty = [NSString stringWithFormat:@"%d", count];
    }
    return pretty;
}

+ (NSString *)stringOfDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *stringRepresentation = [dateFormatter stringFromDate:date];
    return stringRepresentation;
}

@end
