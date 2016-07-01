//
//  APPiraterHelper.m
//  jimao
//
//  Created by pan chow on 15/3/31.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "APPiraterHelper.h"

@implementation APPiraterHelper

+ (void)initializeInAppFinishLaunch
{
    [Appirater setAppId:kAppStoreID];
    
    [Appirater setDaysUntilPrompt:5];//5
    [Appirater setUsesUntilPrompt:10];//10
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    
    [Appirater appLaunched:YES];
}
+ (void)settingInEnterForeground
{
    [Appirater appEnteredForeground:YES];
}
+ (void)settingWhenUserSignificant
{
    [Appirater userDidSignificantEvent:YES];
}

+ (void)appiraterEnableDebug:(BOOL)isDebug
{
    [Appirater setDebug:isDebug];
}

+ (void)rateApp
{
    //[Appirater setOpenInAppStore:NO];
    [Appirater rateApp];
}
@end
