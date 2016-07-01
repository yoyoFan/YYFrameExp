//
//  SocailShare.h
//  FlowExp
//
//  Created by Dongle Su on 14-4-12.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SocialShareAuthState) {
    SocialShareAuthStateNotAuth,
    SocialShareAuthStateExpired,
    SocialShareAuthStateOkAuth,
};

@interface SocialShare : NSObject
+ (void)shareInit;

+ (void)shareContent:(NSString *)content
               title:(NSString *)title
                 url:(NSString *)url
               image:(UIImage *)image
          socialName:(NSString *)socailName
              sucess:(void(^)())sucess
             failure:(void(^)(NSString *errorDesc))failure;

+ (void)shareContent:(NSString *)content
               title:(NSString *)title
                 url:(NSString *)url
       imageFilePath:(NSString *)imageFilePath
          socialName:(NSString *)socailName
              sucess:(void(^)())sucess
             failure:(void(^)(NSString *errorDesc))failure;

+ (void)shareContent:(NSString *)content
               title:(NSString *)title
                 url:(NSString *)url
            imageUrl:(NSString *)imageUrl
          socialName:(NSString *)socailName
              sucess:(void(^)())sucess
             failure:(void(^)(NSString *errorDesc))failure;

+ (void)followUserName:(NSString *)name
            socialName:(NSString *)socialName
                sucess:(void(^)())sucess
               failure:(void(^)(NSString *errorDesc))failure;

+ (BOOL)hasAuthorizedWithSocialName:(NSString *)socialName;
+ (SocialShareAuthState)authorizedStateOfSocialName:(NSString *)socialName;
+ (void)authorizeToSocialName:(NSString *)socialName successed:(void(^)())sucessed failed:(void(^)(NSString *errorMaybeNil))failed;
+ (void)authorizeToSocialName:(NSString *)socialName;
+ (void)cancelAuthOfSocialName:(NSString *)socialName;


@end
