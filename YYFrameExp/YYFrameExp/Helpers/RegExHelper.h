//
//  RegExHelper.h
//  jimao
//
//  Created by pan chow on 14/12/11.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegExHelper : NSObject

+ (BOOL)isMatchPhone:(NSString *)string;

+ (BOOL)isMatchEmail:(NSString *)string;
//email
+ (BOOL)isMatchQQ:(NSString *)string;
//中文
+ (BOOL)isMatchChinese:(NSString *)string;
//英文
+ (BOOL)isMatchCharacter:(NSString *)string;
//英文，数字，下划线
+ (BOOL)isMatchNormalCharacter:(NSString *)string;
//汉字，字母，数字，下划线
+ (BOOL)isMatchChi_cha_num_line:(NSString *)string;

//汉字，字母
+ (BOOL)isMatchChi_cha:(NSString *)string;

//邮编
+ (BOOL)isMatchZipCode:(NSString *)string;
//英文，字母
+ (BOOL)isMatchCharacterAndNumer:(NSString *)string;
//正整数
+ (BOOL)isMatchAct_num_Code:(NSString *)string;
//
+ (BOOL)isMatchNumString:(NSString *)string;

//整数
+ (BOOL)isMatch_num_Code:(NSString *)string;
@end
