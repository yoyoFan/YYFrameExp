//
//  MySoundUtil.h
//  FlowExp
//
//  Created by Dongle Su on 14-6-7.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySoundUtil : NSObject
+ (MySoundUtil *)sharedInstance;

- (void)playNewMessageSound;
- (void)vibrate;

@end
