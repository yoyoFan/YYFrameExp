//
//  MJRefreshFooter+EndRefreshSetLabel.m
//  Mei
//
//  Created by fwr on 16/1/8.
//  Copyright © 2016年 pan chow. All rights reserved.
//

#import "MJRefreshFooter+EndRefreshSetLabel.h"

@implementation MJRefreshAutoStateFooter (EndRefreshSetLabel)

- (void)endRefreshingWithNoMoreDataSetLabel
{
      [self setTitle:@"" forState:MJRefreshStateNoMoreData];
}

@end
