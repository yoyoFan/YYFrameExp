//
//  ErrorTipsView.h
//  jimao
//
//  Created by pan chow on 15/8/13.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)();

@interface ErrorTipsView : UIView

@property (nonatomic,copy)RefreshBlock refreshBlock;

+ (void)hideError_viewOnView:(UIView *)view;
//网络问题提示
+ (void)show_errorView_when_netbug_onView:(UIView *)baseView refresh:(RefreshBlock)block;
//无数据
+ (void)show_errorView_when_nodata_onView:(UIView *)baseView;


//无数据,并修改提示信息
+ (void)show_errorView_when_nodata_onView:(UIView *)baseView TipMessage:(NSString *)message;


//无商品
+ (void)showError_tips_when_nogoods_onView:(UIView *)baseView TipMessage:(NSString *)message;

//shopcart no goods
+ (void)showError_tips_when_shopcartnogoods_onView:(UIView *)baseView TipMessage:(NSString *)message;

@end
