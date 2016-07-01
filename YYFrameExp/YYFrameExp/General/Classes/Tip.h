//
//  Tip.h
//  FlowExp
//
//  Created by Dongle Su on 14-4-12.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tip : NSObject
+ (void)tipProgress:(NSString *)msgString OnView:(UIView *)superView;
+ (void)tipHideOnView:(UIView*)superView;
+ (void)tipImmediateHideOnView:(UIView*)superView;
+ (void)showTip:(NSString *)msg OnView:(UIView *)superView;
+ (void)tipMsg:(NSString *)msgString OnView:(UIView *)superView;
+ (void)tipError:(NSString *)errorString OnView:(UIView *)superView;
//+ (void)tipErrorTitle:(NSString *)title detail:(NSString *)detail OnView:(UIView *)superView;
+ (void)tipSuccess:(NSString *)msg OnView:(UIView *)superView;
+ (void)tipErrorTitle:(NSString *)title detail:(NSString *)detail OnView:(UIView *)superView;
@end
