//
//  PullRefreshProgressViewCreater.m
//  jimao
//
//  Created by Dongle Su on 14-12-15.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "PullRefreshProgressViewCreater.h"


@implementation PullRefreshProgressViewCreater
+ (UIView<BMYProgressViewProtocol> *)pullRefreshProgressView2{
    UIImage *logoImage = nil;//[UIImage imageNamed:@"app60"];
    UIImage *backCircleImage = [UIImage imageNamed:@"light_circle"];
    UIImage *frontCircleImage = [UIImage imageNamed:@"dark_circle"];
    BMYCircularProgressView *progressView = [[BMYCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)
                                                                                      logo:logoImage
                                                                           backCircleImage:backCircleImage
                                                                          frontCircleImage:frontCircleImage];
    return progressView;
}


+ (UIView<BMYProgressViewProtocol> *)pullRefreshProgressView{
    UIImage *logoImage = nil;//[UIImage imageNamed:@"app60"];
    UIImage *backCircleImage = [UIImage imageNamed:@"index_refresh_bg"];
//    UIImage *frontCircleImage = [UIImage imageNamed:@"dark_circle"];
    UIImage *frontCircleImage = nil;
//    NSString  *titleLabel = @"正在加载";
    
    BMYCircularProgressLabelView *progressView = [[BMYCircularProgressLabelView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)
                                                                              logo:logoImage
                                                                           backCircleImage:backCircleImage
                                                                          frontCircleImage:frontCircleImage
                                                                         updateLabelString:@"下拉刷新.." loadLabel:@"松开后刷新"];
    return progressView;
}

@end
