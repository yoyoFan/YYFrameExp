//
//  MyUIAlertView.m
//  FlowExp
//
//  Created by Dongle Su on 14-5-21.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "MyUIAlertView.h"

@implementation MyUIAlertView{
    void (^buttonClickBlock_)(int buttonIndex);
    BOOL isNoDismiss_;
    NSString *buttonTitles_;
}

SINGLETON_GCD(MyUIAlertView);

- (void)alertTitle:(NSString *)title
           message:(NSString *)message
          finished:(void (^)(int buttonIndex))finished
       isNoDismiss:(BOOL)noDismiss
           buttons:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:buttonTitles, nil];

    id eachObject;
    va_list arglist;
    if (buttonTitles)                      // The first argument isn't part of the varargs list,
    {                                   // so we'll handle it separately.
        va_start(arglist, buttonTitles);          // Start scanning for arguments after firstObject.
        while ((eachObject = va_arg(arglist, id))) // As many times as we can get an argument of type "id"
        {
            [alert addButtonWithTitle:eachObject];
        }
        va_end(arglist);
    }
    
    alert.alertViewStyle = UIAlertViewStyleDefault;
    buttonClickBlock_ = finished;
    isNoDismiss_ = noDismiss;
    buttonTitles_ = buttonTitles;
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonClickBlock_) {
        buttonClickBlock_(buttonIndex);
    }
    if (isNoDismiss_) {
        [self alertTitle:alertView.title message:alertView.message finished:buttonClickBlock_ isNoDismiss:isNoDismiss_ buttons:buttonTitles_, nil];
    }
}
@end
