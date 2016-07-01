//
//  UIAlertView+Common.m
//  FlowExp
//
//  Created by Dongle Su on 14-4-11.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UIAlertView+Common.h"
#define kTitle kAppName
@implementation UIAlertView (Common)
+ (void)alertMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
}

@end
