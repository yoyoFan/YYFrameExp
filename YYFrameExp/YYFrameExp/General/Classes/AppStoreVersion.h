//
//  AppStoreVersion.h
//  jimao
//
//  Created by Dongle Su on 15/9/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStoreVersion : NSObject
@property(nonatomic, strong) NSString *appId;
@property(nonatomic, strong) NSString *version;
@property(nonatomic, strong) NSString *trackViewUrl;//download url

@property(nonatomic, strong) NSString *appDescription;
@property(nonatomic, strong) NSString *releaseNotes;
@property(nonatomic, strong) NSString *minimumOsVersion;
@property(nonatomic, strong) NSString *artistName;
@property(nonatomic, assign) float price;

- (id)initWithDictionary:(NSDictionary *)dic;
@end

@interface AppStoreVersionCheck : NSObject
+ (AppStoreVersionCheck *)sharedInstance;
- (void)getLatestVersionOfAppId:(NSString *)appId
                      successed:(void (^)(AppStoreVersion *version))successed
                        failure:(void (^)(NSError *error))failure;
@end
