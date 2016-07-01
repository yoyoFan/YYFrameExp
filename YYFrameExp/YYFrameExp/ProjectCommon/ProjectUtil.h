//
//  ProjectUtil.h
//  jimao
//
//  Created by pan chow on 14/11/26.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseTypeDef.h"


@interface ProjectUtil : NSObject
{
    
}
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

+(ProjectUtil *)sharedInstance;

#pragma mark --- AD 跳转 ---
+ (void)jumpFromAdViewWithType:(NSInteger)openType
                       openUrl:(NSString *)url
            clientRedirectType:(NSInteger)redirectType
                         objId:(NSInteger)objId
                   baseViewCtl:(UIViewController *)viewCtl
                    shareImage:(UIImage *)shareImage
                         title:(NSString *)title;

+ (NSAttributedString *)getAttributeStringFrom:(NSString *)text font:(UIFont *)font;
#pragma mark --- 默认文本格式字典 ---
+ (NSDictionary *)getAttributeDicWithFont:(UIFont *)font;


+ (void)loadImg:(UIImage *)img toImgView:(UIImageView *)imgView maxSize:(CGSize)aSize;

+ (NSString *)stringDesWithPId:(NSInteger)pId cId:(NSInteger )cId;
+ (NSString *)stringPriviceWithPId:(NSInteger)pId;

+ (void)IndexOfPId:(NSInteger)pId toPIndex:(NSInteger *)pIndex cId:(NSInteger )cId toCIndex:(NSInteger *)cIndex;

//活动跳转
+ (void)gotoActivity:(NSString *)url BaseController:baseCtrl;

+ (UIImage *)placeHolderImageOfSize:(CGSize)size;
+ (void)gotoHome;


#pragma mark --- user login name ---
+ (NSString *)getPreLoginNameFromLocal;
+ (void)saveUserLoginNameToLocal:(NSString *)name;

+ (NSString *)getPreLoginPwdFromLocal;
+ (void)saveUserLoginPwdToLocal:(NSString *)name;
+ (void)clearPwd;
+ (NSString *)encryPwd:(NSString *)pwd;
@end
