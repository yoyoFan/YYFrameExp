//
//  MyUIAlertView.h
//  FlowExp
//
//  Created by Dongle Su on 14-5-21.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUIAlertView : NSObject<UIAlertViewDelegate>
+ (MyUIAlertView *)sharedInstance;
- (void)alertTitle:(NSString *)title
           message:(NSString *)message
          finished:(void (^)(int buttonIndex))finished
       isNoDismiss:(BOOL)noDismiss
           buttons:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
