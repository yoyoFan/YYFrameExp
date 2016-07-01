//
//  MyKeyboardManager.m
//  FlowExp
//
//  Created by Dongle Su on 14-5-15.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "MyKeyboardManager.h"
#import "UIView+Common.h"

@implementation MyKeyboardManager{
    NSMutableArray *scrollViews_;
    UITextField *activeField_;
    //UIEdgeInsets oriInsets_;
}

+ (MyKeyboardManager *)sharedInstance{
    static MyKeyboardManager *webService=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webService = [[MyKeyboardManager alloc] init];
    });
    return webService;
}

- (id)init{
    self = [super init];
    if (self) {
        [self registerForKeyboardNotifications];
    }
    return self;
}
- (void)dealloc{
    [self removeKeyboardNotifications];
    for (UITextField *textField in self.textFields) {
        textField.delegate = nil;
    }

}

//- (void)setScrollView:(UIScrollView *)scrollView{
//    _scrollView = scrollView;
//    //scrollView.contentSize = scrollView.frame.size;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTaped:)];
//    [_scrollView addGestureRecognizer:tap];
//}
- (void)setTextFields:(NSArray *)textFields{
    _textFields = textFields;
    for (UITextField *textField in textFields) {
        textField.delegate = self;
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewTaped:(UITapGestureRecognizer *)tap{
    [activeField_ resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField_ = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField_ = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    int index = [self.textFields indexOfObject:textField];
    if (index < 0) {
        return YES;
    }
    if (index < self.textFields.count-1) {
        if (self.autoNext) {
            UITextField *next = [self.textFields objectAtIndex:index+1];
            [next becomeFirstResponder];
        }
    }
    else{
        [textField resignFirstResponder];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onTextFieldReturn:)]) {
            [self.delegate onTextFieldReturn:textField];
        }
    }
    return YES;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    double animDur = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animDur];
    [UIView setAnimationCurve:animCurve];

    //oriInsets_ = self.scrollView.contentInset;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    [UIView commitAnimations];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.scrollView.frame;
    aRect.size.height -= kbSize.height;
    
    for (UITextField *textField in self.textFields) {
        if ([textField isFirstResponder]) {
            activeField_ = textField;
            break;
        }
    }
    
    if (activeField_.superview == self.scrollView) {
        CGRect rc = CGRectMake(activeField_.left, activeField_.top+activeField_.height, activeField_.width, 1);
        if (activeField_ && !CGRectContainsPoint(aRect, rc.origin) ) {
            [self.scrollView scrollRectToVisible:rc animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    double animDur = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animDur];
    [UIView setAnimationCurve:animCurve];

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    [UIView commitAnimations];
}

@end
