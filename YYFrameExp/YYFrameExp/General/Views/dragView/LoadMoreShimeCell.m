//
//  LoadMoreShimeCell.m
//  jimao
//
//  Created by pan chow on 14/12/8.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "LoadMoreShimeCell.h"
#import "FBShimmeringView.h"

@implementation LoadMoreShimeCell

- (void)awakeFromNib {
    // Initialization code
    tipsLB.textColor=DETAIL_COLOR;

    
    [self animate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//实例化本类
+ (instancetype)getInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreShimeCell" owner:nil options:nil] lastObject];
}
- (void)animate
{
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:shimmeringView];
    shimmeringView.translatesAutoresizingMaskIntoConstraints = NO;
    [shimmeringView lyt_alignToParent];
    [self layoutIfNeeded];
    //    shimmeringView.shimmeringPauseDuration=.3;
    //    shimmeringView.shimmeringSpeed=290;
    shimmeringView.shimmeringAnimationOpacity = .3;
    shimmeringView.shimmeringOpacity = .5;
    shimmeringView.shimmeringHighlightLength= .7;
    shimmeringView.contentView = tipsLB;
    
    // Start shimmering.
    shimmeringView.shimmering = YES;
}


@end
