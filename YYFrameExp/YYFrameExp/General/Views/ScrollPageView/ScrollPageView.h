//
//  ScrollPageView.h
//  jimao
//
//  Created by fwr on 15/5/27.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollPageView;

@protocol ScrollPageViewDelegate <NSObject>
- (void)ScrollPageViewTapWithIndex:(ScrollPageView *)ScrollPageView clickedWithArrIndex:(NSInteger)arrIndex;
@end


@interface ScrollPageView : UIView<UIScrollViewDelegate>

@property(strong,nonatomic) UIScrollView *scrollView;
@property(weak,nonatomic)id<ScrollPageViewDelegate> delegate;

/**
 *  传入Cell的Array
 *
 *  @param viewArr  Cell的数组
 *  @param spacing  中间间隔
 *  @param Lspacing 左边间隔
 *  @param vHeight  根据不同硬件计算后的高度
 */
-(void)ScrollPageViewWithViewArray:(NSArray *)viewArr ViewSpacing:(CGFloat)spacing LeftSpacing:(CGFloat)Lspacing ViewHeight:(CGFloat)vHeight;

@end
