//
//  RuntimeInfo.m
//  FlowExp
//
//  Created by Dongle Su on 14-4-24.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "RuntimeInfo.h"
#import "AFNetworking.h"

@implementation RuntimeInfo
+ (RuntimeInfo *)sharedInstance{
    static RuntimeInfo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RuntimeInfo alloc] init];
        instance.networkType = 1;
    });
    return instance;
}

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)startMonitorNetwork{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                SLog(@"No Internet Connection");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.networkType=NetworkTypeEnumWifi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.networkType=NetworkTypeEnumWifi;
                break;
            default:
                SLog(@"Unkown network status");
                break;
        }
    }];
}
- (NSString *)appVersion{
    return @"1.0";
}

- (NSString *)osVersion{
    return @"7.04";
}

- (NSString *)phoneModel{
    return @"iPhone5s";
}

@end
