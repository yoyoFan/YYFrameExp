//
//  APPiraterHelper.h
//  jimao
//
//  Created by pan chow on 15/3/31.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Appirater/Appirater.h>

@interface APPiraterHelper : NSObject

+ (void)initializeInAppFinishLaunch;

+ (void)settingInEnterForeground;
+ (void)settingWhenUserSignificant;

+ (void)appiraterEnableDebug:(BOOL)isDebug;
+ (void)rateApp;
@end
