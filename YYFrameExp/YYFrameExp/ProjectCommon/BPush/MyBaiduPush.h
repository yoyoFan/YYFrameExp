//
//  MyBaiduPush.h
//  jimao
//
//  Created by Dongle Su on 15-1-10.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBaiduPush : JSONModel
@property(nonatomic, strong) NSString<Optional> *userId;
@property(nonatomic, strong) NSString<Optional> *channelId;
//@property(nonatomic, strong) NSNumber *isProduction;
//@property(nonatomic, strong) NSString<Optional> *bindedAccessToken;

+ (MyBaiduPush *)sharedInstance;
- (void)setupWithLaunchOption:(NSDictionary *)launchOptions;
- (void)bind;
- (void)registerDeviceToken:(NSData *)deviceToken;
@end
