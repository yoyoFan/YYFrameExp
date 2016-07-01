//
//  SharePopupView.h
//  FlowExp
//
//  Created by Dongle Su on 14-5-8.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePopupView : UIView<UIScrollViewDelegate>
+ (SharePopupView *)popupInView:(UIView *)view
                          title:(NSString *)title
                     socialList:(NSArray *)socialList
            socailButtonClicked:(void(^)(SharePopupView * popupView, int index))onClicked;
+ (SharePopupView *)popupInView:(UIView *)view
                          title:(NSString *)title
                       copyText:(NSString *)aCopyText
                     socialList:(NSArray *)socialList
            socailButtonClicked:(void(^)(SharePopupView * popupView, int index))onClicked;

- (void)disappearWithComplete:(void(^)())block;
- (void)disappearToLeftWithComplete:(void (^)())block;
@property(nonatomic, readonly) UIImage *bluredBackground;
@end
