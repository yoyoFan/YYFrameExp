//
//  NSMutableDictionary+SafeCheck.h
//  jimao
//
//  Created by pan chow on 14/12/23.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SafeCheck)
- (void)safelySetValue:(NSString *)value key:(NSString *)key;
@end
