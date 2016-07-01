//
//  ScrollPageView.m
//  jimao
//
//  Created by fwr on 15/5/27.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "ScrollPageView.h"
@interface ScrollPageView()<UIScrollViewDelegate>
{
    NSInteger totalPageNum;
    
    NSMutableArray *CurrentViewsArr;
    CGFloat HSpacing;
    
    CGFloat VWidth;
    CGFloat VHeight;
}
@end

@implementation ScrollPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}


-(void)awakeFromNib{
//    self.backgroundColor = [UIColor greenColor];
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
     _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical=NO;
    _scrollView.alwaysBounceHorizontal=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    [self addSubview:_scrollView];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    int i=0;
    for (UIView *subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            subView.frame = CGRectMake(i*self.bounds.size.width, 0,self.bounds.size.width, self.bounds.size.height);
            i++;
        }
    }
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * totalPageNum, self.bounds.size.height);
}



-(void)ScrollPageViewWithViewArray:(NSArray *)viewArr ViewSpacing:(CGFloat)spacing LeftSpacing:(CGFloat)Lspacing ViewHeight:(CGFloat)vHeight{
    CurrentViewsArr =[[NSMutableArray alloc] init];
    CGFloat x=10.0;
    totalPageNum = viewArr.count %2 == 0?viewArr.count/2:viewArr.count/2 + 1;
    CGFloat viewWidth = (APP_SCREEN_WIDTH-spacing - Lspacing*2)/2;
    for(int i = 0; i<viewArr.count; i++)
    {
        [CurrentViewsArr addObject:[viewArr objectAtIndex:i]];
        UIView  *v = [viewArr objectAtIndex:i];
        v.backgroundColor =[UIColor blueColor];
         v.frame = CGRectMake(x ,0, viewWidth, vHeight);
        [_scrollView addSubview:v];
        [v setUserInteractionEnabled:YES];
         v.tag = i;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView:)];
        [v addGestureRecognizer:tap];
        
        if(i % 2==0)
        {
            x +=viewWidth + spacing;
        }
        else
        {
            x +=viewWidth + Lspacing*2;
        }
    }
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * totalPageNum, self.bounds.size.height);
}


-(void)ClickView:(UIGestureRecognizer *)ges
{
    UIView *imgView=(UIView *)ges.view;
    for(int i=0 ; i< CurrentViewsArr.count ;i++)
    {
        if([self.delegate respondsToSelector:@selector(ScrollPageViewTapWithIndex:clickedWithArrIndex:)] && imgView.tag == i)
        {
            [self.delegate ScrollPageViewTapWithIndex:self clickedWithArrIndex:imgView.tag];
            return;
        }
    }
}


@end
