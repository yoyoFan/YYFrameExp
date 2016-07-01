//
//  SlidePopMenuView.h
//  jimao
//
//  Created by pan chow on 15/8/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)(BOOL isTap,BOOL isFold);//isTap:标签是否被点击；isFold：折叠与否
@interface SlidePopMenuView : UIControl

@property (nonatomic, copy) TapBlock tapBlock;
- (void)fillMenuWithImg:(UIImage *)img title:(NSString *)title;
@end
