//
//  PopupAdView.h
//  jimao
//
//  Created by Dongle Su on 15/6/10.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupAdView : UIView
+ (PopupAdView *)sharedInstance;
- (void)popupInView:(UIView *)view withImageUrl:(NSString *)imageUrl onDisplay:(void (^)(PopupAdView *sender))onDisplay onTap:(void (^)(PopupAdView *sender))onTap;
- (void)close;
@end
