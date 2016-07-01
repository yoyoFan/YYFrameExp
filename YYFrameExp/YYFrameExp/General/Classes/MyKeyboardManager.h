//
//  MyKeyboardManager.h
//  FlowExp
//
//  Created by Dongle Su on 14-5-15.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MyKeyboardManagerDelegate <NSObject>
@optional
- (void)onTextFieldReturn:(UITextField *)textField;
@end

@interface MyKeyboardManager : UIResponder<UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (assign, nonatomic) BOOL autoNext;
@property (weak, nonatomic) IBOutlet id<MyKeyboardManagerDelegate> delegate;
@end
