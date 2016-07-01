//
//  SystemSetting.h
//  jimao
//
//  Created by Dongle Su on 14-12-15.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSetting : NSObject
+ (instancetype)sharedInstance;
@property(nonatomic, assign) BOOL isAllowPushNotify; //通知
@property(nonatomic, assign) BOOL isAllowOrderNotify; //订单

//@property(nonatomic, assign) BOOL isVibrateNotify;

//@property(nonatomic, assign) BOOL isAutoCheckUpdate;
- (void)clearCache;
@end
