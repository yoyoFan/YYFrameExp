//
//  RegExHelper.m
//  jimao
//
//  Created by pan chow on 14/12/11.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "RegExHelper.h"

#import <RegExCategories/RegExCategories.h>

//mobile
static NSString *mobileRegex = @"^1(3[4-9]|5[012789]|8[78])\\d{8}$";//移动:134.135.136.137.138.139.150.151.152.157.158.159.187.188 ,147(数据卡)
static NSString *unicomeRegex = @"^1(3[0-2]|5[56]|8[56])\\d{8}$";//联通：130.131.132.155.156.185.186
static NSString *telecomeRegex = @"^18[09]\\d{8}$";//电信：133.153.180.189
static NSString *cdmaRegex = @"^1[35]3\\d{8}$";//CDMA: 133,153

//email
static NSString *emailRegex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
//qq
static NSString *qqRegex = @"^[1-9]\\d{4,14}$";

//中文
static NSString *chineseRegex = @"[\\u4e00-\\u9fa5]{1,14}";

//英文字符 大写，小写
static NSString *characterRegex = @"^[A-Za-z]+$";
static NSString *upperCharacterRegex = @"^[A-Z]+$";
static NSString *lowerCharacterRegex = @"^[a-z]+$";
//英文，数字，下划线
static NSString *normalCharacterRegex = @"^\\w+$";
//英文和数字
static NSString *characterAndNumberRegex = @"^[\\dA-Za-z]+$";
//邮编
static NSString *zipCodeRegex = @"[1-9]\\d{5}(?!\\d)";

//汉字、字母，数字，下划线
static NSString *chi_cha_num_line_Regex = @"^[\u4E00-\u9FA5\\dA-Za-z_]+$";//@"^( !_)( !.* _$)[a-zA-Z0-9_\u4e00-\u9fa5]+$";
//正整数
static NSString *act_num_Regex = @"^[1-9]\\d*$";
//整数
static NSString *num_Regex = @"^[0-9]\\d*$";

//汉字、字母
static NSString *chi_cha_Regex = @"^[\u4E00-\u9FA5A-Za-z_]+$";
@implementation RegExHelper

+ (BOOL)isMatchMobile:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(mobileRegex)];
    }
}
+ (BOOL)isMatchUnicome:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(unicomeRegex)];
    }
}
+ (BOOL)isMatchTelecome:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(telecomeRegex)];
    }
}
+ (BOOL)isMatchCDMA:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(cdmaRegex)];
    }
}
//mobile
+ (BOOL)isMatchPhone:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string] || (string.length!=11) || ([string hasPrefix:@"0"]) || (![string hasPrefix:@"1"]))
    {
        return NO;
    }
    return YES;
    //return [[self class] isMatchMobile:string] || [[self class] isMatchUnicome:string] || [[self class] isMatchTelecome:string] || [[self class] isMatchCDMA:string] ;
}
+ (BOOL)isMatchNumString:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string] || (string.length!=11) || ([string hasPrefix:@"0"]))
    {
        return NO;
    }
    return [string isMatch:RX(@"^[0-9]\\d*$")];
}
//email
+ (BOOL)isMatchEmail:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(emailRegex)];
    }
}
//email
+ (BOOL)isMatchQQ:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(qqRegex)];
    }
}
//中文
+ (BOOL)isMatchChinese:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(chineseRegex)];
    }
}
//英文
+ (BOOL)isMatchCharacter:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(characterRegex)];
    }
}
//英文，数字，下划线
+ (BOOL)isMatchNormalCharacter:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(characterAndNumberRegex)];
    }
}
//汉字，字母，数字，下划线
+ (BOOL)isMatchChi_cha_num_line:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(chi_cha_num_line_Regex)];
    }
}
//汉字，字母
+ (BOOL)isMatchChi_cha:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(chi_cha_Regex)];
    }
}
//邮编
+ (BOOL)isMatchZipCode:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(zipCodeRegex)];
    }
}
//英文&&字母
+ (BOOL)isMatchCharacterAndNumer:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        if(string.length<6)
        {
            return NO;
        }
        return YES;
        
//        NSCharacterSet *set = [NSCharacterSet decimalDigitCharacterSet];
//        if([string rangeOfCharacterFromSet:set options:NSCaseInsensitiveSearch].location==NSNotFound)
//        {
//            return NO;
//        }
//        set = [NSCharacterSet letterCharacterSet];
//        if([string rangeOfCharacterFromSet:set options:NSCaseInsensitiveSearch].location==NSNotFound)
//        {
//            return NO;
//        }
//        return YES;
        //return [string isMatch:RX(characterAndNumberRegex)];
    }
}
//正整数
+ (BOOL)isMatchAct_num_Code:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(act_num_Regex)];
    }
}
//整数
+ (BOOL)isMatch_num_Code:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        return NO;
    }
    else
    {
        return [string isMatch:RX(num_Regex)];
    }
}
@end
