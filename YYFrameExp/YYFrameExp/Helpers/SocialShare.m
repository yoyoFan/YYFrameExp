//
//  SocailShare.m
//  FlowExp
//
//  Created by Dongle Su on 14-4-12.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "SocialShare.h"
#import <ShareSDK/ShareSDK.h>
#import "UIAlertView+Common.h"
#import "Tip.h"
#import "AddressBookReader.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

#define kAddressbookType 100

#define SHARESDK_APPKEY @"9c318b7c1151"

#define SINA_WEIBO_APPKEY @"608193071"
#define SINA_WEIBO_APPSECRET @"5ed44cecb54413ef9a0cf0ff7af77df0"


#define QZONE_APPKEY @"101122431"
#define QZONE_APPSECRET @"1245c83355683708d31248a59ef0ef67"

//微信只能用同一套AppID：见WXAppId
//#define WECHAT_APPKEY @"wxf70922724a9151a6"
//#define WECHAT_APPSECRET @"2549b52bd2368c089b9e2e4ab7559b1b"
//废弃
#define RENREN_APPKEY @"62695248f67940be8c8a78ae3c481b5f"
#define RENREN_APPSECRET @"355d1cbd395b42398ba5e6f51097b521"

//typedef enum{
//    ShareSourceTypeEarnBean,
//    ShareSourceTypeGift
//}ShareSourceType;

@implementation SocialShare
+ (void)registerShareSDK
{
    [ShareSDK registerApp:SHARESDK_APPKEY];
}

+ (void)addSinaWeibo
{
    [ShareSDK connectSinaWeiboWithAppKey:SINA_WEIBO_APPKEY
                               appSecret:SINA_WEIBO_APPSECRET
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
}
+ (void)addQZone
{
    [ShareSDK connectQZoneWithAppKey:QZONE_APPKEY
                           appSecret:QZONE_APPSECRET
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}
+ (void)addQFriends
{
    [ShareSDK connectQQWithQZoneAppKey:QZONE_APPKEY
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
}
+ (void)addRenRen
{
    [ShareSDK connectRenRenWithAppKey:RENREN_APPKEY
                            appSecret:RENREN_APPSECRET];
    
}
+ (void)addWechat
{
    [ShareSDK connectWeChatSessionWithAppId:WXAppId wechatCls:[WXApi class]];
    [ShareSDK connectWeChatTimelineWithAppId:WXAppId wechatCls:[WXApi class]];
}

+ (void)shareInit{
    [SocialShare registerShareSDK];
    
    [SocialShare addSinaWeibo];
    [SocialShare addQZone];
    [SocialShare addQFriends];
    [SocialShare addRenRen];
    [SocialShare addWechat];
    [ShareSDK connectSMS];
    
    //[ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE target:self action:@selector(userInfoUpdateHandler:)];
}

+ (void)userInfoUpdateHandler:(NSNotification *)notif
{
    
}

+ (void)shareContent:(NSString *)content
               title:(NSString *)title
                 url:(NSString *)url
               image:(UIImage *)image
          socialName:(NSString *)socailName
              sucess:(void(^)())sucess
             failure:(void(^)(NSString *errorDesc))failure{
    NSString *imgPath = nil;
    if (image) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        imgPath = [docDir stringByAppendingString:@"/upload.jpg"];
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        [data writeToFile:imgPath atomically:YES];
    }
    
    [self shareContent:content title:title url:url imageFilePath:imgPath socialName:socailName sucess:sucess failure:failure];
}

+ (ShareType)shareTypeOfName:(NSString*)socialName{
    ShareType shareType;
    if ([socialName hasPrefix:@"新浪微博"]) {
        shareType = ShareTypeSinaWeibo;
    }
//    else if ([socialName hasPrefix:@"腾讯微博"]){
//        shareType = ShareTypeTencentWeibo;
//    }
    else if ([socialName hasPrefix:@"人人网"]){
        shareType = ShareTypeRenren;
    }
    else if ([socialName hasPrefix:@"QQ好友"]){
        shareType = ShareTypeQQ;
    }
    else if ([socialName hasPrefix:@"QQ空间"]){
        shareType = ShareTypeQQSpace;
    }
    else if ([socialName hasPrefix:@"微信好友"]){
        shareType = ShareTypeWeixiSession;
    }
    else if ([socialName hasPrefix:@"微信朋友圈"]){
        shareType = ShareTypeWeixiTimeline;
    }
//    else if ([socialName hasPrefix:@"易信好友"]){
//        shareType = ShareTypeYiXinSession;
//    }
//    else if ([socialName hasPrefix:@"易信朋友圈"]){
//        shareType = ShareTypeYiXinTimeline;
//    }
    else if ([socialName hasPrefix:@"短信"]){
        shareType = ShareTypeSMS;
    }
//    else if ([socialName hasPrefix:@"邮箱"]){
//        shareType = ShareTypeMail;
//    }
    else if ([socialName hasPrefix:@"手机通讯录"]){
        shareType = kAddressbookType;
    }
    else{
        [Tip tipError:GetString(@"share_way_err", "") OnView:nil];
        return ShareTypeAny;
    }
    
    return shareType;
}
+ (void)shareContent:(NSString *)content
               title:(NSString *)title
                 url:(NSString *)url
       imageFilePath:(NSString *)imageFilePath
          socialName:(NSString *)socailName
              sucess:(void(^)())sucess
             failure:(void(^)(NSString *errorDesc))failure{
    id<ISSContent> publishContent = [ShareSDK content:content defaultContent:@"默认内容" image:[imageFilePath length]?[ShareSDK imageWithPath:imageFilePath]:nil title:[title length]?title:APP_NAME url:[url length]?url:@"http://www.llmao.cn" description:content mediaType:SSPublishContentMediaTypeNews];

    ShareType shareType = [SocialShare shareTypeOfName:socailName];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES scopes:nil powerByHidden:YES followAccounts:nil authViewStyle:SSAuthViewStylePopup viewDelegate:nil authManagerViewDelegate:nil];
    [ShareSDK shareContent:publishContent
                      type:shareType
               authOptions:authOptions
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateSuccess)
                        {
                            sucess();
                        }
                        else if (state == SSResponseStateFail)
                        {
                            NSLog(@"share error:%@", [error errorDescription]);
                            failure(@"分享失败");
                        }
                    }];
}
+ (void)shareContent:(NSString *)content
               title:(NSString *)title
                 url:(NSString *)url
           imageUrl:(NSString *)imageUrl
          socialName:(NSString *)socailName
              sucess:(void(^)())sucess
             failure:(void(^)(NSString *errorDesc))failure{
    id<ISSContent> publishContent = [ShareSDK content:content defaultContent:@"默认内容" image:[imageUrl length]?[ShareSDK imageWithUrl:imageUrl]:nil title:[title length]?title:APP_NAME url:[url length]?url:@"http://www.llmao.cn" description:content mediaType:SSPublishContentMediaTypeNews];
  
    
    ShareType shareType = [SocialShare shareTypeOfName:socailName];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES scopes:nil powerByHidden:YES followAccounts:nil authViewStyle:SSAuthViewStylePopup viewDelegate:nil authManagerViewDelegate:nil];
    [ShareSDK shareContent:publishContent
                      type:shareType
               authOptions:authOptions
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateSuccess)
                        {
                            sucess();
                        }
                        else if (state == SSResponseStateFail)
                        {
                            NSLog(@"share error:%@", [error errorDescription]);
                            failure(@"分享失败");
                        }
                    }];
}

+ (void)followUserName:(NSString *)name
            socialName:(NSString *)socialName
                sucess:(void(^)())sucess
               failure:(void(^)(NSString *errorDesc))failure{
    ShareType shareType = [SocialShare shareTypeOfName:socialName];
    
    [ShareSDK followUserWithType:shareType field:name fieldType:SSUserFieldTypeName authOptions:nil viewDelegate:nil result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (state == SSResponseStateSuccess)
        {
            sucess();
        }
        else if (state == SSResponseStateFail)
        {
            failure([error errorDescription]);
        }
    }];
}

+ (BOOL)hasAuthorizedWithSocialName:(NSString *)socialName{
    ShareType shareType = [SocialShare shareTypeOfName:socialName];

    if (shareType == kAddressbookType) {
        return [[AddressBookReader sharedInstance] isBinded];
    }
    else{
        return [ShareSDK hasAuthorizedWithType:shareType];
    }
}

+ (SocialShareAuthState)authorizedStateOfSocialName:(NSString *)socialName{
    ShareType shareType = [SocialShare shareTypeOfName:socialName];
    
    if (shareType == kAddressbookType) {
        return [[AddressBookReader sharedInstance] isBinded] ? SocialShareAuthStateOkAuth : SocialShareAuthStateNotAuth;
    }
    else{
        id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:shareType];
        if (credential) {
            NSDate *expired = [credential expired];
            NSDate *today = [NSDate date];
            if ([today compare:expired] == NSOrderedDescending) {
                return SocialShareAuthStateExpired;
            }
            
            if ([credential available]) {
                return SocialShareAuthStateOkAuth;
            }
        }
        else{
            return SocialShareAuthStateNotAuth;
        }
        
        return SocialShareAuthStateNotAuth;
    }

}

+ (void)authorizeToSocialName:(NSString *)socialName{
    [SocialShare authorizeToSocialName:socialName successed:nil failed:nil];
//    ShareType shareType = [SocialShare shareTypeOfName:socialName];
//
//    if (shareType == kAddressbookType) {
//        [[AddressBookReader sharedInstance] bind];
//    }
//    else{
//        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                             allowCallback:YES
//                                                             authViewStyle:SSAuthViewStylePopup
//                                                              viewDelegate:nil
//                                                   authManagerViewDelegate:nil];
//        
//        
//        [ShareSDK getUserInfoWithType:shareType
//                          authOptions:authOptions
//                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//                                   if (result)
//                                   {
//                                       //                                   [item setObject:[userInfo nickname] forKey:@"username"];
//                                       //                                   [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
//                                   }
//                                   NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
//                               }];
//
//    }

}
+ (void)authorizeToSocialName:(NSString *)socialName successed:(void(^)())sucessed failed:(void(^)(NSString *errorMaybeNil))failed{
    ShareType shareType = [SocialShare shareTypeOfName:socialName];
    
    if (shareType == kAddressbookType) {
        [[AddressBookReader sharedInstance] bind];
    }
    else{
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                             authViewStyle:SSAuthViewStylePopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        
        [ShareSDK getUserInfoWithType:shareType
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   if (result)
                                   {
                                       if (sucessed) {
                                           sucessed();
                                       }
                                       //                                   [item setObject:[userInfo nickname] forKey:@"username"];
                                       //                                   [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                   }
                                   else{
                                       if (failed) {
                                           failed(error?[error errorDescription]:nil);
                                       }
                                   }
                                   NSLog(@"%ld:%@",(long)[error errorCode], [error errorDescription]);
                               }];
        
    }
    
}

+ (void)cancelAuthOfSocialName:(NSString *)socialName{
    ShareType shareType = [SocialShare shareTypeOfName:socialName];

    if (shareType == kAddressbookType) {
        [Tip tipError:@"请到设置->隐私->通讯录中设置" OnView:nil];
    }
    else{
        [ShareSDK cancelAuthWithType:shareType];
    }
}

@end
