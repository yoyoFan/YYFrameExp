//
//  BubbleView.h
//  Mei
//
//  Created by fwr on 15/12/3.
//  Copyright © 2015年 pan chow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaoPaoMovingView;

@protocol PaoPaoMovingViewDelegate <NSObject>

@optional
-(void)PaoPaoMovingView:(PaoPaoMovingView *)view didDissmissWithButtonIndex:(NSInteger)btnIndex ObjectItem:(NSString *)titleString;
@end


@interface PaoPaoMovingView : UIView
@property (weak,nonatomic) id< PaoPaoMovingViewDelegate>delegate;

-(void)initWithButtonTitleArray:(NSArray *)arrTitle ButtonDetailArray:(NSArray *)arrDetail delegate:(id /*<PaoPaoMovingViewDelegate>*/)delegate showInView:(UIView *)view;

@end
