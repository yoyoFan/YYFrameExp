//
//  SelectPopView.h
//  jimao
//
//  Created by pan chow on 14/12/3.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectPopView;
@protocol SelectPopViewDelegate <NSObject>

@optional
- (void)selectPopView:(SelectPopView *)popView checkRow:(NSInteger)row column:(NSInteger)col;
- (void)doneBtnPressedInselectPopView:(SelectPopView *)popView;
- (void)canceledInselectPopView:(SelectPopView *)popView;

@end
@interface SelectPopView : UIView

@property (nonatomic,weak)id<SelectPopViewDelegate>delegate;

// TODO: checked
+ (instancetype)getInstance;
- (void)showPopViewOnCtl:(UIViewController *)ctl withData:(NSDictionary *)dic;
- (void)hidePopView;
- (void)hide;
@end
