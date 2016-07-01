//
//  AppStoreVersion.m
//  jimao
//
//  Created by Dongle Su on 15/9/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "AppStoreVersion.h"

@implementation AppStoreVersion

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        if(dic && [dic isKindOfClass:[NSDictionary class]] && dic.count > 0)
        {
            self.appId = dic[@"trackId"];
            self.artistName = dic[@"artistName"];
            self.appDescription = dic[@"description"];
            self.price = [dic[@"price"] floatValue];
            self.releaseNotes = dic[@"releaseNotes"];
            self.minimumOsVersion = dic[@"minimumOsVersion"];

            self.trackViewUrl = dic[@"trackViewUrl"];
            self.version = dic[@"version"];
            
            return self;
        }
    }
    return nil;
}
@end


@implementation AppStoreVersionCheck
+ (AppStoreVersionCheck *)sharedInstance{
    static AppStoreVersionCheck *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppStoreVersionCheck alloc] init];
    });
    return instance;
}
- (void)getLatestVersionOfAppId:(NSString *)appId
                      successed:(void (^)(AppStoreVersion *version))successed
                        failure:(void (^)(NSError *error))failure
{
//#ifdef DEBUG
//    AppStoreVersion *model1 = [[AppStoreVersion alloc] init];
//    model1.version = @"2.4.0";
//    model1.trackViewUrl = @"https://itunes.apple.com/cn/app/ji-mao-liu-liang-mian-fei/id888169317?mt=8";
//    successed(model1);
//#else

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appId];
        NSURL *url=[NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if(error)
        {
            failure(error);
            return ;
        }
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        if(error)
        {
            failure(error);
            return;
        }
        
        NSArray *infoArray = [infoDic objectForKey:@"results"];
        if (!infoArray || infoArray.count == 0)
        {
            error = [NSError errorWithDomain:@"bad params" code:333 userInfo:@{NSLocalizedDescriptionKey:@"返回数据错误"}];
            failure(error);
            return;
        }
        AppStoreVersion *model = [[AppStoreVersion alloc] initWithDictionary:infoArray[0]];
        successed(model);
    });
//    #endif
}
@end