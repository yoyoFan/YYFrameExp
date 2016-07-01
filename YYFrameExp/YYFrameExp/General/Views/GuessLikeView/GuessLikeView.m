//
//  GuessLikeView.m
//  loading
//
//  Created by fwr on 15/5/22.
//  Copyright (c) 2015年 Or Ron. All rights reserved.
//

#import "GuessLikeView.h"

@interface GuessLikeView()<UIScrollViewDelegate>
{
    int pageWidth_;
    int pageHeight_;
    
    UIPageControl *pageCtrl;
    NSInteger totalPageNum;
}


@end


@implementation GuessLikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self awakeFromNib];
    }
    return self;
}



-(void)awakeFromNib{
//     self.backgroundColor = [UIColor greenColor];
    
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, self.bounds.size.height)];
//    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width,  _scrollView.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator = NO;
     _scrollView.alwaysBounceVertical=NO;
    _scrollView.alwaysBounceHorizontal=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
//    _scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:_scrollView];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    pageWidth_ = APP_SCREEN_WIDTH;
    pageHeight_ = _scrollView.bounds.size.height;
    
    
    pageCtrl =[[UIPageControl alloc] initWithFrame:CGRectMake((self.bounds.size.width - 50)/2, self.bounds.size.height - 15, 50, 20)];
    pageCtrl.currentPage = 0;
    pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
    pageCtrl.pageIndicatorTintColor = [UIColor colorWithWhite:0.706 alpha:1.000];
    pageCtrl.userInteractionEnabled = YES;
    [self addSubview:pageCtrl];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    pageWidth_ = APP_SCREEN_WIDTH;
    pageHeight_ = self.bounds.size.height;
    _scrollView.frame = CGRectMake(0, 0, pageWidth_, pageHeight_);
    int i=0;
    for (UIView *subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            subView.frame = CGRectMake(i*pageWidth_, 0,pageWidth_, pageHeight_);
            i++;
        }
    }
    _scrollView.contentSize = CGSizeMake(pageWidth_ * totalPageNum, pageHeight_);
    pageCtrl.frame = CGRectMake((self.bounds.size.width - 50)/2, self.bounds.size.height - 15, 50, 20);
}



-(void)initWithArrayCount:(NSInteger)arrCount ShowLikeImg:(BOOL)isShowLikeImg ShowPageCtrl:(BOOL)isShowPageCtrl
{
    if(isShowLikeImg)
    {
        UIImageView *likeImg=[[UIImageView alloc] initWithFrame:CGRectMake(0,-6, 83, 21)];
        likeImg.image =[UIImage imageNamed:@"shoppingGuessLike"];
        [self addSubview:likeImg];
    }
    NSInteger pageNum= (arrCount % 2==0)? arrCount/2:arrCount/2 + 1;
    totalPageNum = pageNum;
    if(isShowPageCtrl)
    {
        pageCtrl.numberOfPages = pageNum;
        if(pageNum<=1)
        {
            pageCtrl.hidden = YES;
        }
        else
        {
            pageCtrl.hidden = NO;
        }
     }
    else
    {
        pageCtrl.hidden = YES;
    }
}



#pragma mark ------------ScrollViewDelegate------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        NSInteger page = roundf(_scrollView.contentOffset.x / scrollView.bounds.size.width);
        if (page == totalPageNum )//最后一页时
        {
            
        }
        else
        {
            [pageCtrl setCurrentPage:page];
        }
    }
}


@end
