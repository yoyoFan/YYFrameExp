//
//  AppMacro.h
//  jimao
//
//  Created by Dongle Su on 14-11-24.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#ifndef jimao_AppMacro_h
#define jimao_AppMacro_h

#define GetString(key, comment) NSLocalizedString(key, comment)

#pragma mark --- project ---
#define kAppStoreID @"1090785325"  //设置应用的ID

#define APP_INFO_URL [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppStoreID]
//#define APP_URL  [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%d?mt=8",kAppStoreID] //无法识别


#define APP_URLString @"https://itunes.apple.com/cn/app/id1090785325?mt=8"


#define FLURRY_API_KEY @""
#define CRASHLYTICS_API_KEY @""

//#define UMENG_APP_KEY @"55d4649de0f55a0f170036ed"
//#define DEBUG_UMENG_APP_KEY @"55d464d2e0f55abb0e000309"

#define BAIDU_MAP_KEY @"qxfm8z9wBclZU3ao5SIA1AMa"

//#define AlixPayResultNotification  @"AlixPayResultNotification"

//微信支付功能账号信息==================================================
/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
#define WXAppId @"wxa5fd8e630a1571e2"    //开放平台申请应用时的Id
#define kAppScheme  @"Mei2016"  //用于支付宝回调的
 

//#define WX_PAY_NOTIFICATION @"WXPayResultNotification"

#define AccessTokenKey @"access_token"
#define PrePayIdKey @"prepayid"
#define errcodeKey @"errcode"
#define errmsgKey @"errmsg"
#define expiresInKey @"expires_in"

#define kRemoteNotify @"RemoteNofify"





#endif
