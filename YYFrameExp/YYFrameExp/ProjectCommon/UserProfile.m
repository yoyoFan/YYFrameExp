//
//  UserProfile.m
//  FlowExp
//
//  Created by fwr on 14-4-16.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UserProfile.h"
#import "TMCache.h"
#import "AFNetworking.h"

#define kcachingPlist @"/userProfile.plist"

#define kUserInfoKey @"userInfo"
#define kdefaultAddressKey @"defaultAddress"
#define klocationAddKey @"locationAdd"

#define kSysConfigKey @"sysConfigList"
#define kLoadBgKey @"loadBg"
#define kIsFisrtLaunchKey @"isFirstLaunch"
#define kIsBindInstallCalledKey @"isBindInstallCalled"
#define kVersionKey @"version"
#define kAccessTokenKey @"accessToken"
#define kserverTimeKey @"serverTime"
#define kCurrentProfileVersion 4

#define kLevel @"level"
#define kinvite_code @"invite_code"

@implementation UserProfile{
    NSString *cachingPlist_;
    NSDictionary *cacheProfileDic_;
    NSMutableArray *imageRequestArray_;
}

+ (UserProfile *)sharedInstance{
    static UserProfile *webService=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webService = [[UserProfile alloc] init];
    });
    return webService;
}

- (id)init{
    self = [super init];
    if (self) {
        int curVersion = kCurrentProfileVersion;
        _isFirstLaunch = YES;
        _isFirstResponse = YES;
        _isBindInstallCalled = NO;
        imageRequestArray_ = [NSMutableArray array];
        _isFlashMessage = YES;

        cachingPlist_ = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:kcachingPlist];
        cacheProfileDic_ = [NSMutableDictionary dictionaryWithContentsOfFile:cachingPlist_];
        if (cacheProfileDic_ == nil) {
            cacheProfileDic_ = [NSMutableDictionary dictionary];
        }
        else{
            int cachedVersion = [[cacheProfileDic_ objectForKey:kVersionKey] intValue];
            if (cachedVersion == curVersion) {
                _userInfo = [[UserInfo alloc] initWithDictionary:[cacheProfileDic_ objectForKey:kUserInfoKey] error:nil];
//                _defaultAddress =[[AddressListModel alloc] initWithDictionary:[cacheProfileDic_ objectForKey:kdefaultAddressKey] error:nil];
//                
//                _locationModel = [[LocationModel alloc] initWithDictionary:[cacheProfileDic_ objectForKey:klocationAddKey] error:nil];
                
                _sysConfigDic = [cacheProfileDic_ objectForKey:kSysConfigKey];
                _loadBg = [cacheProfileDic_ objectForKey:kLoadBgKey];
                if (![_loadBg isKindOfClass:[NSArray class]]) {
                    _loadBg = nil;
                }
                
                if ([cacheProfileDic_ objectForKey:kIsFisrtLaunchKey]) {
                    _isFirstLaunch = [[cacheProfileDic_ objectForKey:kIsFisrtLaunchKey] boolValue];
                }
                else{
                    _isFirstLaunch = YES;
                }
                
                if ([cacheProfileDic_ objectForKey:@"isFirstResponse"]) {
                    _isFirstResponse = [[cacheProfileDic_ objectForKey:@"isFirstResponse"] boolValue];
                }
                else{
                    _isFirstResponse = YES;
                }

                if ([cacheProfileDic_ objectForKey:kIsBindInstallCalledKey]) {
                    _isBindInstallCalled = [[cacheProfileDic_ objectForKey:kIsBindInstallCalledKey] boolValue];
                }
                else{
                    _isBindInstallCalled = NO;
                }

                if ([cacheProfileDic_ objectForKey:@"unReadMessageCount"]) {
                    _unReadMessageCount = [[cacheProfileDic_ objectForKey:@"unReadMessageCount"] boolValue];
                }
                else{
                    _unReadMessageCount = 0;
                }
                
                if ([cacheProfileDic_ objectForKey:@"isFlashMessage"]) {
                    _isFlashMessage = [[cacheProfileDic_ objectForKey:@"isFlashMessage"] boolValue];
                }
                else{
                    _isFlashMessage = YES;
                }
                
                _accessToken = [cacheProfileDic_ objectForKey:kAccessTokenKey];
                _serviceTime = [cacheProfileDic_ objectForKey:kserverTimeKey];
                _installDate = [cacheProfileDic_ objectForKey:@"installDate"];
                
                if([cacheProfileDic_ objectForKey:kLevel])
                {
                    _level =[[cacheProfileDic_ objectForKey:kLevel] integerValue];
                }
                else
                {
                    _level = 0;
                } 
                _invite_code = [cacheProfileDic_ objectForKey:kinvite_code];
                
            }
            else{
                // not load this version.
                // or upgrade?
            }
        }
//        if (!self.userInfo) {
//            _userInfo = [[UserInfo alloc] init];
//        }
//        if (!self.sysConfigInfo) {
//            _sysConfigInfo = [[SysConfigInfo alloc] init];
//        }
        [cacheProfileDic_ setValue:[NSNumber numberWithInt:curVersion] forKey:kVersionKey];
    }
    return self;
}

 
- (void)setUserInfo:(UserInfo *)userInfo{
    if (_userInfo == userInfo) {
        return;
    }
    _userInfo = userInfo;
    [cacheProfileDic_ setValue:[userInfo toDictionary] forKey:kUserInfoKey];
    BOOL ret = [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    if (!ret) {
        SLog(@"setUserInfo write file failed!");
    }
}

//-(void)setDefaultAddress:(AddressListModel *)defaultAddress
//{
//    if (_defaultAddress == defaultAddress) {
//        return;
//    }
//    _defaultAddress = defaultAddress;
//    [cacheProfileDic_ setValue:[defaultAddress toDictionary] forKey:kdefaultAddressKey];
//    BOOL ret = [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
//    if (!ret) {
//        SLog(@"setDefaultAddress write file failed!");
//    }
//}
//
//
//-(void)setLocationModel:(LocationModel *)locationModel
//{
//    if (_locationModel == locationModel) {
//        return;
//    }
//    _locationModel = locationModel;
//    [cacheProfileDic_ setValue:[locationModel toDictionary] forKey:klocationAddKey];
//    BOOL ret = [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
//    if (!ret) {
//        SLog(@"setDefaultAddress write file failed!");
//    }
//}

- (void)save{
    [cacheProfileDic_ setValue:[_userInfo toDictionary] forKey:kUserInfoKey];
    BOOL ret = [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    if (!ret) {
        SLog(@"UserPofile save failed!");
    }
}
- (void)setSysConfigDic:(NSDictionary *)sysConfigDic{
    if (_sysConfigDic == sysConfigDic) {
        return;
    }
    _sysConfigDic = sysConfigDic;
    [cacheProfileDic_ setValue:sysConfigDic forKeyPath:kSysConfigKey];
    [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    
}

//- (void)logout{
//    [self setUserInfo:nil];
//    self.accessToken = nil;
//}

- (BOOL)bgArray:(NSArray *)bgDicArray containsLoadingImage:(NSString *)imageUrl{
    for (NSDictionary *loadingImageDic in bgDicArray) {
        if ([imageUrl isEqualToString:[loadingImageDic objectForKey:@"url"]]) {
            return YES;
        }
    }
    return NO;
}
- (void)setLoadBg:(NSArray *)loadBg{
//    if (![loadBg isKindOfClass:[NSArray class]]) {
//        return;
//    }
    if (![_loadBg isEqualToArray:loadBg]) {
        NSArray *oldone = _loadBg;
        _loadBg = loadBg;
        
        
        // stop pengding image request.
        @synchronized(self){
            for (AFHTTPRequestOperation *op in imageRequestArray_) {
                [op cancel];
            }
            [imageRequestArray_ removeAllObjects];
        }
        
        NSMutableArray *imagesToLoad = [NSMutableArray array];
        NSMutableArray *imagesToDel = [NSMutableArray array];
        for (NSDictionary* loadingImageDic in loadBg) {
            // images to load.
            NSString *imageUrl = [loadingImageDic objectForKey:@"url"];
            if(![self bgArray:oldone containsLoadingImage:imageUrl]){
                [imagesToLoad addObject:imageUrl];
            }
            else{
                UIImage *image = [[TMCache sharedCache] objectForKey:imageUrl];
                if (!image) {
                    [imagesToLoad addObject:imageUrl];
                }
            }
        }
        
        for (NSDictionary* loadingImageDic in oldone) {
            // images to delete.
            NSString *imageUrl = [loadingImageDic objectForKey:@"url"];
            if(![self bgArray:loadBg containsLoadingImage:imageUrl]){
                [imagesToDel addObject:imageUrl];
            }
        }

        // store new entry
        for (NSString *imageUrl in imagesToLoad) {
            NSString *imageFullPath = imageUrl;

            //UIImage *image = [UIImage imageWithURLStr:imageFullPath error:&error];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageFullPath]]];
            operation.responseSerializer = [AFImageResponseSerializer serializer];
            @synchronized(self){
                [imageRequestArray_ addObject:operation];
            }
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                @synchronized(self){
                    [imageRequestArray_ removeObject:operation];
                }
                [[TMCache sharedCache] setObject:responseObject forKey:imageFullPath];
                
                [cacheProfileDic_ setValue:loadBg forKey:kLoadBgKey];
                /*
                NSError *error;
                NSData *data = [NSPropertyListSerialization dataWithPropertyList:cacheProfileDic_ format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
                if (!error) {
                    [data writeToFile:cachingPlist_ options:NSDataWritingAtomic error:&error];
                    if (error) {
                        SLLog(@"Profile wirte file error:%@", error.localizedDescription);
                    }
                }
                else{
                    SLLog(@"dataWithPropertyList error:%@", error.localizedDescription);
                }
                [self save];
                 */
                [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                @synchronized(self){
                    [imageRequestArray_ removeObject:operation];
                }
                SLLog(@"image request failed:%@", error.localizedDescription);
            }];
            [operation start];
        }

        // clear old cache.
        for (NSString *imageUrl in imagesToDel) {
            NSString *imageFullPath = imageUrl;
            [[TMCache sharedCache] removeObjectForKey:imageFullPath];
        }
    }
}

- (void)setIsFirstLaunch:(BOOL)isFirstLaunch{
    if (_isFirstLaunch != isFirstLaunch) {
        _isFirstLaunch = isFirstLaunch;
        [cacheProfileDic_ setValue:[NSNumber numberWithBool:isFirstLaunch] forKey:kIsFisrtLaunchKey];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}

- (void)setIsFirstResponse:(BOOL)isFirstResponse{
    if (_isFirstResponse != isFirstResponse) {
        _isFirstResponse = isFirstResponse;
        [cacheProfileDic_ setValue:[NSNumber numberWithBool:isFirstResponse] forKey:@"isFirstResponse"];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}

- (void)setIsBindInstallCalled:(BOOL)isBindInstallCalled{
    if (_isBindInstallCalled != isBindInstallCalled) {
        _isBindInstallCalled = isBindInstallCalled;
        [cacheProfileDic_ setValue:[NSNumber numberWithBool:isBindInstallCalled] forKey:kIsBindInstallCalledKey];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}

- (void)setUnReadMessageCount:(NSInteger)unReadMessageCount{
    if (_unReadMessageCount != unReadMessageCount) {
        _unReadMessageCount = unReadMessageCount;
        [cacheProfileDic_ setValue:[NSNumber numberWithBool:unReadMessageCount] forKey:@"unReadMessageCount"];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}

- (void)setAccessToken:(NSString *)accessToken{
    if (![_accessToken isEqualToString:accessToken]) {
        _accessToken = accessToken;
        [cacheProfileDic_ setValue:accessToken forKey:kAccessTokenKey];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}

-(void)setServiceTime:(NSString *)serviceTime
{
    if(![_serviceTime isEqualToString:@""])
    {
        _serviceTime = serviceTime;
        [cacheProfileDic_ setValue:serviceTime forKey:kserverTimeKey];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}

- (void)setInstallDate:(NSString *)installDate
{
    if (![_installDate isEqualToString:installDate]) {
        _installDate = installDate;
        [cacheProfileDic_ setValue:_installDate forKey:@"installDate"];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}
- (void)setIsFlashMessage:(BOOL)isFlashMessage{
    if (_isFlashMessage != isFlashMessage ) {
        _isFlashMessage = isFlashMessage;
        [cacheProfileDic_ setValue:[NSNumber numberWithBool:isFlashMessage] forKey:@"isFlashMessage"];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}


-(void)setLevel:(NSInteger)level
{
    if(_level != level)
    {
        _level =level;
        [cacheProfileDic_ setValue:_installDate forKey:kLevel];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}


-(void)setInvite_code:(NSString *)invite_code
{
    if(![_invite_code isEqualToString:invite_code])
    {
        _invite_code =invite_code;
        [cacheProfileDic_ setValue:_installDate forKey:invite_code];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}

-(void)setSearchHistoryArray:(NSMutableArray *)SearchHistoryArray
{
    if(![SearchHistoryArray isEqualToArray:_SearchHistoryArray])
    {
        _SearchHistoryArray =SearchHistoryArray;
        [cacheProfileDic_ setValue:_SearchHistoryArray forKey:@"SearchHistoryArray"];
        [cacheProfileDic_ writeToFile:cachingPlist_ atomically:YES];
    }
}




@end
