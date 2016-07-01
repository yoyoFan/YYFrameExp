//
//  UITextField+InputCheck.h
//  HealthFriends
//
//  Created by zhoupan on 15/6/11.
//  Copyright (c) 2015年 pan chow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TFType) {
    TFTypeMobile = 0,
    TFTypePwd = 1,
    TFTypeConfirmPwd = 2,
    TFTypeAuthCode = 3,
};

extern NSString *const ZP_tftype_mobile;
extern NSString *const ZP_tftype_pwd;
extern NSString *const ZP_tftype_confirmPwd;
extern NSString *const ZP_tftype_authcode;

@interface UITextField (InputCheck)

@property (nonatomic,assign)NSString *textFiledType;

- (BOOL)isEmpty;
- (NSString *)trimString;
- (NSString *)clearStringWithWhiteSpace;
- (BOOL)isMobile;
- (BOOL)isPwd;
- (BOOL)is_Pos_Number;
- (BOOL)is_Number;
- (BOOL)is_charactor_Number;//字母、数字或组合

- (void)settingWithType:(NSString *)type;

@end
