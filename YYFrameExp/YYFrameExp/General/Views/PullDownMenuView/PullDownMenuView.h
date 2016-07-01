//
//  PullDownMenuView.h
//  Mei
//
//  Created by fwr on 15/12/5.
//  Copyright © 2015年 pan chow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PullDownMenuView : UIView


/*
弹出下拉菜单 （可展示图片，文字）
 */
-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);


@end
