//
//  NormalFlatButton.h
//  jimao
//
//  Created by pan chow on 14/12/4.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalFlatButton : UIButton

+ (instancetype)button;


- (void)redEnable:(BOOL)isEnable;
- (void)grayInTaskEnable:(BOOL)isEnable;
- (void)grownEnable:(BOOL)isEnable;
- (void)whitBorderEnable:(BOOL)isEnable;
- (void)grayEnable:(BOOL)isEnable;
- (void)whiteEnable:(BOOL)isEnable;

- (void)PrograyEnable:(BOOL)isEnable;
@end
