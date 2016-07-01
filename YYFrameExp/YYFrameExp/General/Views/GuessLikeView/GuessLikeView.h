//
//  GuessLikeView.h
//  loading
//
//  Created by fwr on 15/5/22.
//  Copyright (c) 2015年 Or Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuessLikeView : UIView<UIScrollViewDelegate>
{
    
}
@property(strong,nonatomic) UIScrollView *scrollView;
-(void)initWithArrayCount:(NSInteger)arrCount ShowLikeImg:(BOOL)isShowLikeImg ShowPageCtrl:(BOOL)isShowPageCtrl;

@end
