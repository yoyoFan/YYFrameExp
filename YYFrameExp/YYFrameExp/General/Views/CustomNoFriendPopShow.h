//
//  CustomNoFriendPopShow.h
//  jimao
//
//  Created by fwr on 14/12/10.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZPCustomAlertViewTransitionStyle) {
    ZPCustomAlertViewTransitionStyleSlideFromBottom = 0,
    ZPCustomAlertViewTransitionStyleSlideFromTop,
    ZPCustomAlertViewTransitionStyleFade,
    ZPCustomAlertViewTransitionStyleBounce,
    ZPCustomAlertViewTransitionStyleDropDown
};

@class CustomNoFriendPopShowView;
@protocol CustomNoFriendPopShowViewDelegate<NSObject>

@optional
- (void)CustomNoFriendPopShowView:(CustomNoFriendPopShowView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end


@interface CustomNoFriendPopShowView : UIView

@property (nonatomic)ZPCustomAlertViewTransitionStyle style;
@property (nonatomic,weak)id<CustomNoFriendPopShowViewDelegate>delegate;

- (instancetype)initWithTitle:(NSString *)title  messages:(NSString *)tempMessage delegate:(id /*<CustomNoFriendPopShowViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end
