//
//  NocornerFlatButton.h
//  jimao
//
//  Created by pan chow on 15/1/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NocornerFlatButton : UIButton

+ (instancetype)button;


- (void)redEnable:(BOOL)isEnable;
- (void)grayInTaskEnable:(BOOL)isEnable;
- (void)grownEnable:(BOOL)isEnable;
- (void)whitBorderEnable:(BOOL)isEnable;
- (void)grayEnable:(BOOL)isEnable;

@end
