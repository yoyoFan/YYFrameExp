//
//  CustomMarqueeLabel.h
//  Demo
//
//  Created by pan zhou on 13-3-21.
//  Copyright (c) 2013年 pan zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLabel.h"

/**
 *	@brief 自定义Label:实现内容的循环滚动 by pan
 */
@interface CustomMarqueeLabel: UIView
{
    @private
    UIScrollView *backScrollView;
    ImageLabel *frontLB;
    ImageLabel *behindLB;
    
    float scrollSpeed;
    NSTimeInterval delayInterval;
}
/**
 *	@brief	显示的文本内容
 */
@property (nonatomic,copy)NSString *text;

/**
 *	@brief	标示文本内容是否允许滚动
 */
@property (nonatomic,assign)BOOL permitScrolling;

/**
 *	@brief	初始化
 *
 *	@param 	frame 	Label的位置大小
 *	@param 	anSpeed 	滚动速率
 *
 *	@return	本类的实例
 */
- (id)initWithFrame:(CGRect)frame byScrollSpeed:(float)anSpeed;

/**
 *	@brief	设置文本颜色
 *
 *	@param 	color 	颜色参数
 */
- (void)setTextColor:(UIColor *)color;


/**
 *	@brief	设置文本颜色以及字体
 *
 *	@param 	color 	颜色参数
 *	@param 	font 	字体参数
 */
- (void)setTextColor:(UIColor *)color font:(UIFont *)font;

- (void)setTextColor:(UIColor *)TtColor backColor:(UIColor *)bkColor;
- (void)setFontSize:(CGFloat)fontSize;
- (void)setSpeed:(float)anSpeed;

- (void)setTailImage:(UIImage *)image;
@end
