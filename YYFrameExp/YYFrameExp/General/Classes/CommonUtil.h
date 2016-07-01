//
//  CommonUtil.h
//  FlowExp
//
//  Created by pan chow on 14-4-10.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

typedef NS_ENUM(NSInteger, CustomRegexMatchesType)
{
    CustomRegexMatchesChinese=0,   //匹配中文字符
    CustomRegexMatchesDoubleByte,  //匹配双字节字符(包括汉字在内)  评注: 可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）
    CustomRegexMatchesBlank,       //空字符串
    CustomRegexMatchesBlankLine,   //匹配空白行  评注: 可以用来删除空白行
    CustomRegexMatchesHTML,        //匹配HTML标记 评注: 仅仅能匹配部分
    CustomRegexMatchesMargin,      //匹配首尾空白字符 评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)
    CustomRegexMatchesEmail,       //匹配Email地址
    CustomRegexMatchesURL,         //匹配网址URL
    CustomRegexMatchesAccount,     //匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)
    CustomRegexMatchesPhone,       //匹配国内电话号码 评注：匹配形式如 0511-4405222 或 021-87888822
    CustomRegexMatchesMobile,      //国内手机号
    CustomRegexMatchesMobileAndPhone,//国内手机号与电话号码
    CustomRegexMatchesQQ,          //匹配腾讯QQ号  评注：腾讯QQ号从10000开始
    CustomRegexMatchesZipCode,     //匹配中国邮政编码 评注：中国邮政编码为6位数字
    CustomRegexMatchesIdentityCard,//匹配身份证  评注：中国的身份证为15位或18位
    CustomRegexMatchesIP,          //匹配ip地址  评注：提取ip地址时有用
    
    //匹配特定数字
    CustomRegexMatchesPositiveInt, //匹配正整数
    CustomRegexMatchesNegativeInt, //匹配负整数
    CustomRegexMatchesInt,         //匹配整数
    CustomRegexMatchesNonnegativeInt,//匹配非负整数（正整数 + 0）
    CustomRegexMatchesNonpositiveInt,//匹配非正整数（负整数 + 0）
    CustomRegexMatchesRealmin,     //匹配正浮点数
    CustomRegexMatchesNoRealmin,   //匹配负浮点数
    CustomRegexMatchesFloat,       //匹配浮点数
    CustomRegexMatchesNonnegativeFloat,//匹配非负浮点数（正浮点数 + 0）
    CustomRegexMatchesNonpositiveFloat,//匹配非正浮点数（负浮点数 + 0）
    
    //匹配特定字符串
    CustomRegexMatchesCharacter,                     //匹配由26个英文字母组成的字符串
    CustomRegexMatchesUpperCharacter,                //匹配由26个英文字母的大写组成的字符串
    CustomRegexMatchesLowerCharacter,                //匹配由26个英文字母的小写组成的字符串
    CustomRegexMatchesNumberAndCharacter,            //匹配由数字和26个英文字母组成的字符串
    CustomRegexMatchesNumberAndCharacterAndUnderline,//匹配由数字、26个英文字母或者下划线组成的字符串
    
    //匹配航班号
    CustomRegexMatchesFlightNumber
};


@interface CommonUtil : NSObject

+ (NSArray *)getArrayInfoFromByLocalPlistName:(NSString *)name;
+ (NSDictionary *)getDicInfoFromByLocalPlistName:(NSString *)name;
+ (id)getObjFromBundleWithName:(NSString *)name type:(NSString *)type;

+ (AppDelegate *)getApp;
+ (UIWindow *)getAppWindow;

+ (NSUInteger)SystemVersion;

+ (void)reSizeLabel:(UILabel *)label withText:(NSString *)text rowHeight:(NSInteger)rowHeight;
+ (void)reSizeLabel:(UILabel *)label withText:(NSString *)text rowWidth:(NSInteger)width;
+ (NSInteger)heightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width rowHeight:(NSInteger)rowHeight;

+ (void)takePhotoesWithController:(UIViewController<UIImagePickerControllerDelegate ,UINavigationControllerDelegate> *)viewCtl;
+ (void)getPhotoesAndVideosFromLibrayWithController:(UIViewController<UIImagePickerControllerDelegate ,UINavigationControllerDelegate> *)viewCtl;

+ (void)observeKeyboardEventWithTarget:(id)target sel:(SEL)selector willOrDid:(NSString *)willOrDid showOrHide:(NSString *)showOrHide;
+ (NSTimeInterval)animationDurationFromKeyboardNotification:(NSNotification *)notification;
+ (CGRect)endFrameFromKeyboardNotification:(NSNotification *)notification;
+ (UIViewAnimationCurve )animationCurveFromKeyboardNotification:(NSNotification *)notification;

+ (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize;

+ (BOOL)stringIsEmpty:(NSString *)string;
+ (NSString *)trimString:(NSString *)str;
+ (NSString *)formatString:(NSString *)anStr withKeyArray:(NSArray *)anArray;

+ (NSDateFormatter *)sharedDateFormmater;
+ (NSString *)descriptionMonth:(NSString *)monthString;

+ (UIDatePicker *)sharedDatePicker;

+ (NSData *)archiverDataFromObject:(id<NSCoding>)obj;
+ (id)objectFromArchiverData:(NSData *)data;
+ (void)setString:(NSString *)string toUserDefaultsWithKey:(NSString *)key;
+ (NSString *)stringFromUserDefaultsWithKey:(NSString *)key;

+(BOOL)strMatches:(NSString *)strM MatchseType:(CustomRegexMatchesType)matchsType;

+ (NSString *)latestVersionFromAppStore;
+ (NSString *)markPhoneNumWithStar:(NSString *)phoneNum;

+ (int)statWordsCount:(NSString *)str;

+ (NSString *)getGUIDFromKeychain;
+ (NSString*)deviceString;
+ (void)getAppStoreId:(NSString **)pAppId url:(NSString **)pAppUrl fromIdOrUrl:(NSString *)idOrUrl;

#pragma mark --- AutoLayout下文本高度计算 ---
+ (CGFloat)findHeightForAttributedString:(NSAttributedString *)text havingWidth:(CGFloat)widthValue;

+ (void)exeAmbiguityLOutForView:(UIView *)vw;

+ (NSString *)descriptionFromDate:(NSDate *)date now:(NSDate *)now;
+ (NSString *)descriptionFromTime:(NSDate *)date now:(NSDate *)now;

+ (BOOL)isEnableNotification;

#pragma mark -- 微信

+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;


#pragma mark =========支付宝返回支付后的提示信息==============
+(NSString *)ResultPayDescript:(int )resultStr;

@end
