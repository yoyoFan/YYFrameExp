//
//  SystemSetting.m
//  jimao
//
//  Created by Dongle Su on 14-12-15.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "SystemSetting.h"

@implementation SystemSetting{
}
+ (instancetype)sharedInstance{
    static SystemSetting *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SystemSetting alloc] init];
    });
    return instance;
}

- (id)init{
    self = [super init];
    if (self) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAllowPushNotify"]) {
            _isAllowPushNotify = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAllowPushNotify"] boolValue];
        }
        else{
            self.isAllowPushNotify = YES;
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAllowOrderNotify"]) {
            _isAllowOrderNotify = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAllowOrderNotify"] boolValue];
        }
        else{
            self.isAllowOrderNotify = YES;
        }
 
    }
    return self;
}

- (void)setIsAllowPushNotify:(BOOL)isAllowPushNotify{
    if (isAllowPushNotify != _isAllowPushNotify) {
        _isAllowPushNotify = isAllowPushNotify;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isAllowPushNotify] forKey:@"isAllowPushNotify"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}


-(void)setIsAllowOrderNotify:(BOOL)isAllowOrderNotify
{
    if (isAllowOrderNotify != _isAllowOrderNotify) {
        _isAllowOrderNotify = isAllowOrderNotify;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isAllowOrderNotify] forKey:@"isAllowOrderNotify"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}




@end
