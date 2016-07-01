//
//  MyPopupView.h
//  jimao
//
//  Created by Dongle Su on 15-3-13.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPopupView : UIView
+ (MyPopupView *)popupInView:(UIView *)view
                       title:(NSString *)title
                     content:(NSString *)content
             leftButtonTitle:(NSString *)leftButton
            rightButtonTitle:(NSString *)rightButton
             onButtonClicked:(void(^)(MyPopupView * popupView, int button))onClicked;

- (void)dismiss;

@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)closeTaped:(id)sender;
- (IBAction)leftButtonTaped:(id)sender;
- (IBAction)rightButtonTaped:(id)sender;
@end
