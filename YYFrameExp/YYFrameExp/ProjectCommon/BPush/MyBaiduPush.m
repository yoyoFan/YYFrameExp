//
//  MyBaiduPush.m
//  jimao
//
//  Created by Dongle Su on 15-1-10.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "MyBaiduPush.h"
#import "BPush.h"
#import "UserProfile.h"
#import "WebService.h"
#import "CommonUtil.h"

#define kPlist @"/baiduPush.plist"

#define kChannidKey @"channelId"

//生产
//"API Key：
//qcXXXGKpNddYLm6zynsEXa0Q
//Secret Key：
//G732rgsPaeLLSuvGrgKxndkYiKn4XEhz"


//测试
//API Key：
//c0DEBCi0TS5TgP8iqpbFeVnn
//Secret Key：
//232sV0VCE0lMtdc4Qhb5GOP5BjBN4GGS


#define kDevAPIKey @"c0DEBCi0TS5TgP8iqpbFeVnn"
#define kProdAPIKey @"qcXXXGKpNddYLm6zynsEXa0Q"


@implementation MyBaiduPush{
    NSString *plistFile_;
//    BOOL needRebind_;
    
     NSMutableDictionary *Dic_;
}
+ (MyBaiduPush *)sharedInstance{
    static MyBaiduPush *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyBaiduPush alloc] init];
    });
    return instance;
}

- (void)dealloc{
}
- (id)init{
    if (self = [super init]) {
        plistFile_ = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:kPlist];
        Dic_ = [NSMutableDictionary dictionaryWithContentsOfFile:plistFile_];

//        [self mergeFromDictionary:Dic_ useKeyMapping:NO];
        
        if (Dic_ == nil) {
            Dic_ = [NSMutableDictionary dictionary];
        }
        else{
               _channelId = [Dic_ objectForKey:kChannidKey];
        }
        
        

    }
    return self;
}


- (void)setChannelId:(NSString<Optional> *)channelId
{
    if (![_channelId isEqualToString:channelId]) {
        _channelId = channelId;
        [Dic_ setValue:channelId forKey:kChannidKey];
        [Dic_ writeToFile:plistFile_ atomically:YES];
    }
}


- (void)setupWithLaunchOption:(NSDictionary *)launchOptions{
#ifdef DEBUG
    [BPush registerChannel:launchOptions apiKey:kDevAPIKey pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
#else
    [BPush registerChannel:launchOptions apiKey:kProdAPIKey pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:NO];
#endif
}

- (void)innerBind{
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        if (!error) {
            SLLog(@"bindChannel result%@", result);
            NSString *appid = [BPush getAppId];
//            NSString *userid = [BPush getUserId];
            NSString *channelid = [BPush getChannelId];
            SLog(@"baidu appid:%@", appid);
       
            if(![CommonUtil stringIsEmpty:channelid])
            {
                _channelId = channelid;
                [Dic_ setValue:channelid forKey:kChannidKey];
                [Dic_ writeToFile:plistFile_ atomically:YES];
                [self checkToBindWithChannelId:channelid];
            }
        }
        else{
            SLLog(@"bind channel error with:%ld", (long)error.code);
        }
    }];
}

- (void)bind{
//    if (needRebind_) {
//        [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
//            [self innerBind];
//            if (!error) {
//            }
//            else{
//                SLLog(@"unbind channel error with:%ld", (long)error.code);
//            }
//        }];
//    }
//    else{
        [self innerBind];
//    }
}

- (void)registerDeviceToken:(NSData *)deviceToken{
    SLog(@"我的设备ID: %@", deviceToken);
    [BPush registerDeviceToken:deviceToken]; // 必须
}


- (void)checkToBindWithChannelId: (NSString *)channelId{
    
//    if( ![channelId isEqualToString:self.channelId])
//    {
        [[WebService sharedInstance] asyncBindBaiduPushChannelId:channelId success:^{
             self.channelId = channelId;
            //self.bindedAccessToken = accessToken;
             [Dic_ setValue:channelId forKey:kChannidKey];
            [Dic_ writeToFile:plistFile_ atomically:YES];
        } failure:^(NSError *error) {
            SLLog(@"bind baidu failed:%@", error.localizedDescription);
        }];
//    }
}
@end
