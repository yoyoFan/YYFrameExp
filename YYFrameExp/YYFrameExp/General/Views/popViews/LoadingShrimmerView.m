//
//  LoadingShrimmerView.m
//  jimao
//
//  Created by pan chow on 14/12/2.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "LoadingShrimmerView.h"
#import "FBShimmeringView.h"

#define LOADING_SHIMMER_VIEW_TAG 11236

@interface LoadingShrimmerView ()
{
    IBOutlet UILabel *loadingLB;
}
@end
@implementation LoadingShrimmerView


#pragma mark --- init ---
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initlize];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        [self initlize];
    }
    return self;
}
- (void)initlize
{
    self.tag=LOADING_SHIMMER_VIEW_TAG;
}
- (void)shimmer
{
    loadingLB.textColor=[UIColor colorFromHexString:@"#929292"];
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.bounds];
    [self addSubview:shimmeringView];
//    shimmeringView.shimmeringPauseDuration=.3;
//    shimmeringView.shimmeringSpeed=290;
    shimmeringView.contentView = loadingLB;
    
    // Start shimmering.
    shimmeringView.shimmering = YES;
}
#pragma mark --- private ---
+ (instancetype)loadingView
{
    LoadingShrimmerView *loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingShrimmerView" owner:nil options:nil] lastObject];
   
    return loadingView;
}

#pragma mark --- public ---
+ (void)showLoadingOnView:(UIView *)aView
{
    LoadingShrimmerView *loadingView = (LoadingShrimmerView *)[aView viewWithTag:LOADING_SHIMMER_VIEW_TAG];
    if(!loadingView)
    {
        loadingView=[[self class] loadingView];
        [aView insertSubview:loadingView atIndex:aView.subviews.count];
        
        loadingView.translatesAutoresizingMaskIntoConstraints=NO;
        [loadingView lyt_alignLeftToParent];
        [loadingView lyt_alignRightToParent];
        [loadingView lyt_alignTopToParent];
        [loadingView lyt_alignBottomToParent];

        [loadingView updateConstraintsIfNeeded];
    }
}
+ (void)hideLoadingonView:(UIView *)aView
{
    LoadingShrimmerView *loadingView = (LoadingShrimmerView *)[aView viewWithTag:LOADING_SHIMMER_VIEW_TAG];
    if(loadingView)
    {
        [loadingView removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self shimmer];
}

@end
