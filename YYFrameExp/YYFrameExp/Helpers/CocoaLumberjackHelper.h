//
//  CocoaLumberjackHelper.h
//  jimao
//
//  Created by pan chow on 15/4/17.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface CocoaLumberjackHelper : NSObject

+ (void)addLogger;

+ (void)configCustomFMDBLoogger;
+ (NSArray *)getItemsFromFMDBLogger;
@end
