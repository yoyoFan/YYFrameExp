//
//  NSMutableDictionary+SafeCheck.m
//  jimao
//
//  Created by pan chow on 14/12/23.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "NSMutableDictionary+SafeCheck.h"

@implementation NSMutableDictionary (SafeCheck)

- (void)safelySetValue:(NSString *)value key:(NSString *)key
{
    if(!value || ![value isKindOfClass:[NSString class]] ||value.length == 0)
    {
        return;
    }
    [self setObject:value forKey:key];
}
@end
