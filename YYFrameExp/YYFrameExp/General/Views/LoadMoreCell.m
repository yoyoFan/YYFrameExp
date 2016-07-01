//
//  LoadMoreCell.m
//  FlowStorm
//
//  Created by fwr on 14-10-11.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell

- (void)awakeFromNib {
    // Initialization code
    indiView.hidden=YES;
    [indiView stopAnimating];
    [labelLoadMore setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMoreBtnClick:)];
    [labelLoadMore addGestureRecognizer:tap];
    
    labelLoadMore.font = [UIFont systemFontOfSize:14];
    labelLoadMore.textColor = ColorC4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//实例化本类
+ (LoadMoreCell *)getInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:nil options:nil] lastObject];
}
////运转indicator代码实现之--在ios6中nib方式不起作用
//- (void)animate
//{
//    [indicator setHidesWhenStopped:YES];
//    [indicator setHidden:NO];
//    [indicator startAnimating];
//}

 


-(void)loadMoreBtnClick:(UITapGestureRecognizer *)tap
{
    if([self.delegate respondsToSelector:@selector(loadMoreClick:)])
    {
        [_delegate loadMoreClick:self];
    }
}
- (void)showLoading
{
    labelLoadMore.hidden=YES;
    indiView.hidden=NO;
    [indiView startAnimating];
}
- (void)stopLoading
{
    labelLoadMore.hidden=NO;
    indiView.hidden=YES;
    [indiView stopAnimating];
}
@end
