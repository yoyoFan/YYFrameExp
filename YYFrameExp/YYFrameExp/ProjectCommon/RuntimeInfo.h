//
//  RuntimeInfo.h
//  FlowExp
//
//  Created by Dongle Su on 14-4-24.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseTypeDef.h"

typedef NS_ENUM(NSUInteger, NetworkTypeEnum) {
    NetworkTypeEnum3G = 1,
    NetworkTypeEnumWifi = 2,
};

typedef enum : NSUInteger {
    UnReadNotificationTypeNone = 0,
    UnReadNotificationTypeLaunch = 1,
    UnReadNotificationTypeReceive = 2,
} UnReadNotificationType;

typedef enum : NSUInteger {
    ApplicationLaunchTypeNone = 0,
    ApplicationLaunchTypeNotification = 1,
    ApplicationLaunchTypeAlipay = 2,
    ApplicationLaunchTypeWeixin = 3,
} ApplicationLaunchType;

typedef enum : NSUInteger {
    PaymentCallbackTypeNone = 0,
    PaymentCallbackTypeAlipay = 1,
    PaymentCallbackTypeWeixin = 2,
} PaymentCallbackType;

@interface RuntimeInfo : NSObject

@property(nonatomic, assign) NetworkTypeEnum networkType;
@property(nonatomic, strong) NSNumber *unReadNotificationType;
//@property(nonatomic, strong) NotificationMessage *notificationMessage;
@property(nonatomic, assign) BOOL friendChanged;
@property(nonatomic, assign) BOOL taskChanged;
@property(nonatomic, assign) BOOL orderChanged;
@property(nonatomic, assign) BOOL checkinChanged;
@property(nonatomic, strong) NSNumber *paymentCallbackType;
@property(nonatomic, strong) id paymentInfo;
@property(nonatomic, strong) NSNumber *applicationLaunchType;

@property(nonatomic, assign) NSInteger client_invited_score;
@property(nonatomic, assign) NSInteger client_invition_score;
@property(nonatomic, assign) BOOL ios_audit_status; //审核时不显示积分
@property(nonatomic, strong) NSArray *wapDomains;
@property(nonatomic, strong) NSString *secretKey;

+ (RuntimeInfo *)sharedInstance;

- (void)startMonitorNetwork;

- (NSString*)appVersion;
- (NSString*)osVersion;
- (NSString*)phoneModel;

@end
