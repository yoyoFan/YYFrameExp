//
//  ForwardCenter.h
//  jimao
//
//  Created by Dongle Su on 15/5/21.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForwardCenter : NSObject
+ (ForwardCenter *)sharedInstance;
- (void)forwardFromBaseViewController:(UIViewController *)base withPageId:(NSString *)pageId paramStr:(NSString *)paramStr;
- (void)forwardFromBaseViewController:(UIViewController *)base withPageId:(NSString *)pageId paramDic:(NSDictionary *)paramDic;
@end
