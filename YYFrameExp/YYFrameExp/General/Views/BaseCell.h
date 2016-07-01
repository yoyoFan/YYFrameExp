//
//  BaseCell.h
//  jimao
//
//  Created by pan chow on 14/11/26.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+Resizable.h"
#import "UIImageView+AFNetworking.h"

@interface BaseCell : UITableViewCell
+ (instancetype)getInstance;
+ (CGFloat)cellHeight;
- (CGFloat)dynamicHeight;

@end
