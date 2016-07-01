//
//  CustomAlertView.h
//  FlowExp
//
//  Created by pan chow on 14-5-21.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^clickBlock)(NSInteger index,NSString *title);

typedef NS_ENUM(NSInteger, CustomAlertViewTransitionStyle) {
    CustomAlertViewTransitionStyleSlideFromBottom = 0,
    CustomAlertViewTransitionStyleSlideFromTop,
    CustomAlertViewTransitionStyleFade,
    CustomAlertViewTransitionStyleBounce,
    CustomAlertViewTransitionStyleDropDown
};

@class CustomAlertView;
@protocol CustomAlertViewDelegate<NSObject>

@optional
- (void)customAlertView:(CustomAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
@interface CustomAlertView : UIView

@property (nonatomic)CustomAlertViewTransitionStyle style;
@property (nonatomic,weak)id<CustomAlertViewDelegate>delegate;
@property (nonatomic,copy)clickBlock clickBlock;

- (instancetype)initWithTitle:(NSString *)title count:(NSTimeInterval)interval delegate:(id /*<CustomAlertViewDelegate>*/)delegate clickBlock:(clickBlock)block;
- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail messages:(NSArray *)messages clickBlock:(clickBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (void)show;
- (void)dismissAnimated:(BOOL)animated;
- (void)hide2;
@end
