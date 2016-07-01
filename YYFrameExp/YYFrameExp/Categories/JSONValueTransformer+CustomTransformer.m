//
//  JSONValueTransformer+CustomTransformer.m
//  jimao
//
//  Created by pan chow on 14/12/1.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "JSONValueTransformer+CustomTransformer.h"

#define DEFAULT_DATEFORMMATER @"yyyy-MM-dd HH:mm:ss"

@implementation JSONValueTransformer (CustomTransformer)

- (NSDate *)NSDateFromNSString:(NSString*)string
{
    NSDateFormatter *formatter =[CommonHelper sharedDateFormmater];
    [formatter setDateFormat:DEFAULT_DATEFORMMATER];
    return [formatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date
{
    NSDateFormatter *formatter = [CommonHelper sharedDateFormmater];
    [formatter setDateFormat:DEFAULT_DATEFORMMATER];
    return [formatter stringFromDate:date];
}


@end
