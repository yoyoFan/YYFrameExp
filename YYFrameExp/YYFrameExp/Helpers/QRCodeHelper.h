//
//  QRCodeHelper.h
//  jimao
//
//  Created by pan chow on 15/5/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QRCodeViewController.h"
#import "ShowQRCodeViewController.h"

/*
 gmall://{"pageCode":"", "openValue":{}}
 friend://15156079063
 http://
 */
@interface QRCodeHelper : NSObject
//扫描二维码。block为nil时，自动处理
/*
 首页：QR_Type_HTTP | QR_Type_PAGE | QR_Type_FLOWCARD
 flowCard：QR_Type_FLOWCARD
 wap：QR_Type_PAGE | QR_Type_CUSTOM
 */
+ (void)pushQRCodeViewCtrlBaseOnCtrl:(UIViewController *)ctrl qrType:(QR_Type)qr_type completeBlock:(QRUrlBlock)block;
+ (void)pushQRCodeViewCtrlBaseOnCtrl:(UIViewController *)ctrl qrType:(QR_Type)qr_type;

+ (void)pushShowQRCodeViewCtrlBaseOnCtrl:(UIViewController *)ctrl withString:(NSString *)string;
+ (UIImage *)QRCodeImgWithInfo:(NSString *)string logo:(UIImage *)logoImg;

////我的二维码
//+ (void)pushShowMyQRCodeBaseOnCtrl:(UIViewController *)ctrl;
//生成gmall的二维码(logo为nil，取默认)
+ (UIImage *)QRCodeImgWithGmallPageCode:(NSString *)code openValue:(NSString *)value logo:(UIImage *)logoImg;
//http
+ (UIImage *)QRCodeImgWithHTTPString:(NSString *)httpString logo:(UIImage *)logoImg;
@end
