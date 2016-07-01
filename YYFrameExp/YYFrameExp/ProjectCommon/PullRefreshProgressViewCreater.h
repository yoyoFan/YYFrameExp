//
//  PullRefreshProgressViewCreater.h
//  jimao
//
//  Created by Dongle Su on 14-12-15.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMYCircularProgressView.h"
#import "BMYCircularProgressLabelView.h"

@interface PullRefreshProgressViewCreater : NSObject
+ (UIView<BMYProgressViewProtocol> *)pullRefreshProgressView;
@end
