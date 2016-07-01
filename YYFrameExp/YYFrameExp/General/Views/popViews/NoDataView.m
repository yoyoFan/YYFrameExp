//
//  NoDataView.m
//  jimao
//
//  Created by pan chow on 14/12/30.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)getInstance
{
    NoDataView *view=[[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] firstObject];
    
    [view initilize];
    return view;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //self.layer.cornerRadius = .0f;
    self.backgroundColor = [UIColor redColor];
    nodataTipLB.textColor = rgb(222, 222, 222);
//        _shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.bounds];
//        [self addSubview:_shimmeringView];
//    _shimmeringView.translatesAutoresizingMaskIntoConstraints = NO;
//    [_shimmeringView lyt_alignToParent];
//        //    shimmeringView.shimmeringPauseDuration=.3;
//        //    shimmeringView.shimmeringSpeed=290;
//        _shimmeringView.contentView = nodataTipLB;
//    
//     //Start shimmering.
}
- (void)initilize
{
    self.backgroundColor = [UIColor redColor];
    nodataTipLB.textColor = rgb(222, 222, 222);
    self.translatesAutoresizingMaskIntoConstraints = NO;
}
#pragma mark --- private ---
- (void)startShimmer
{
    _shimmeringView.shimmering = YES;
}
- (void)stopShimmer
{
    _shimmeringView.shimmering = NO;
}
#pragma mark --- public ---
+ (void)showNoDataInCtrl:(UIViewController *)ctrl
{
    
    [[NoDataView getInstance] showInCtrl:ctrl withTips:@"这里什么都没有\n去别的地方看看吧"];
}
+ (void)showNetErrorInCtrl:(UIViewController *)ctrl
{
    [[NoDataView getInstance] showInCtrl:ctrl withTips:@"网络不给力"];
}
- (void)showInCtrl:(UIViewController *)ctrl withTips:(NSString *)tips
{
    nodataTipLB.text = tips;
    
    [ctrl.view addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self lyt_centerInParent];
    
    [ctrl.view layoutIfNeeded];
    //[self startShimmer];
    
}
+ (void)hide
{
    [[NoDataView getInstance] stopShimmer];
    
    [[NoDataView getInstance] removeFromSuperview];
}
- (void)dealloc
{
    [self stopShimmer];
}
@end
