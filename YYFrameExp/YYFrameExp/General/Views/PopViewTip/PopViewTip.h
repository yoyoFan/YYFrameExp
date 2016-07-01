//
//  PopViewTip.h
//  Mei
//
//  Created by fwr on 15/12/8.
//  Copyright © 2015年 pan chow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopViewTip : UIView

+(PopViewTip *)shareInstance;


-(void)initPopViewTipInView:(UIView *)view  dissmisAfterTime:(NSInteger)time  TipTitle:(NSString *)msgTitle TipMessage:(NSString *)tipMsg onDisplay:(void (^)(PopViewTip *sender))onDisplay onTap:(void (^)(PopViewTip *sender))onTap;
@end
