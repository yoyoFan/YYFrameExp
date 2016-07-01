//
//  CommicView.m
//  Doujia
//
//  Created by pan zhou on 13-12-16.
//  Copyright (c) 2013年 pan zhou. All rights reserved.
//

#import "CommicView.h"
#import "UIView+Common.h"
#import "CommonUtil.h"
#import "UIColor+Common.h"

#import "UIImageView+TMCache.h"

#define PAGE_NUM 2

#define PageWidth APP_SCREEN_WIDTH

@interface CommicView ()
{
    
}
@property (nonatomic,strong)NSMutableArray *imgViews;
@property (nonatomic,strong)NSMutableArray *indiViews;
@property (nonatomic,strong)NSArray *urls;
@end
@implementation CommicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
+ (CommicView *)sharedInstance
{
    static CommicView *sharedInstance=nil;
    static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    sharedInstance =  [[[NSBundle mainBundle] loadNibNamed:@"CommicView" owner:nil options:nil] firstObject];
    
    CGFloat height;
    if ([CommonUtil SystemVersion]<7) {
        height=APP_SCREEN_CONTENT_HEIGHT;
    }
    else{
        height=APP_SCREEN_HEIGHT;
    }

    sharedInstance.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, height);
    sharedInstance.backgroundColor=[UIColor colorWithWhite:.7 alpha:.9];
    
    sharedInstance.pageCtl.centerX=sharedInstance.centerX;
    sharedInstance.pageCtl.bottom=APP_SCREEN_CONTENT_HEIGHT-10;
    sharedInstance.pageCtl.numberOfPages = 0;
    sharedInstance.pageCtl.currentPage = 0;
    
    
    sharedInstance.backScrollView.clipsToBounds=YES;
    sharedInstance.backScrollView.bounds=CGRectMake(0, 0, PageWidth, height);
    sharedInstance.backScrollView.center=sharedInstance.center;
    sharedInstance.backScrollView.contentSize = CGSizeMake(0, sharedInstance.height);
    sharedInstance.backScrollView.userInteractionEnabled = YES;
    [sharedInstance.backScrollView setDelaysContentTouches:NO];
    sharedInstance.backScrollView.delegate = sharedInstance;

   });
    return sharedInstance;
}
//pageCtl的点击事件
- (IBAction)pageChanged:(UIPageControl *)control
{
    NSInteger page = control.currentPage;
    [_backScrollView setContentOffset:CGPointMake(page * _backScrollView.width, 0) animated:YES];
}

#pragma mark --- UIScrollView Delegate ---
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    if (page == _imgViews.count)//最后一页时
    {
        //[self removeFromWindow];
        [self close];
        [self reset];
    }
    else
    {
        [_pageCtl setCurrentPage:page];
    }
}
#pragma mark --- private ---
- (NSMutableArray *)imgViews
{
    if(!_imgViews)
    {
        _imgViews=[[NSMutableArray alloc] init];
    }
    return _imgViews;
}
- (NSMutableArray *)indiViews
{
    if(!_indiViews)
    {
        _indiViews=[[NSMutableArray alloc] init];
    }
    return _indiViews;
}
- (void)changeImgViewsWithCount:(NSInteger)count
{
    if(count>self.imgViews.count)
    {
        [self addimgViewsWithCount:count - _imgViews.count];
    }
    else if(count<_imgViews.count)
    {
        [self removeImgviewsWithCount:_imgViews.count - count];
    }
    else
    {
        
    }
}
- (void)addimgViewsWithCount:(NSInteger)count
{
    NSInteger oldCount = _imgViews.count;
    //add new imgs
    CGFloat top=APP_SCREEN_HEIGHT;
    if([CommonUtil SystemVersion]<7)
    {
        top=APP_SCREEN_CONTENT_HEIGHT;
    }
     CGSize pageSize =CGSizeMake(PageWidth, top);
    
    for( int i = 0; i < count; i++)
    {
        @autoreleasepool
        {
            
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(pageSize.width * (oldCount + i), 0, pageSize.width, pageSize.height)];
            
            imgView.backgroundColor = [UIColor clearColor];
            imgView.contentMode=UIViewContentModeScaleAspectFit;
            [self.imgViews addObject:imgView];
            [_backScrollView addSubview:imgView];
            
            UIActivityIndicatorView *indiView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
            indiView.center=imgView.center;
            indiView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
            [indiView startAnimating];
            indiView.hidden=NO;
            [self.indiViews addObject:indiView];
            [_backScrollView insertSubview:indiView aboveSubview:imgView];
            
            
        }
    }
    _pageCtl.numberOfPages = _imgViews.count;
    _backScrollView.contentSize = CGSizeMake(pageSize.width * _imgViews.count,_backScrollView.frame.size.height);
}
- (void)removeImgviewsWithCount:(NSInteger)count
{
    for (int i = 0; i < count; i++)
    {
        UIImageView * imgView = [self.imgViews lastObject];
        [imgView removeFromSuperview];
        [self.imgViews removeLastObject];
        
        UIActivityIndicatorView * indiView = [self.indiViews lastObject];
        [indiView stopAnimating];
        [indiView setHidden:YES];
        [indiView removeFromSuperview];
        [self.indiViews removeLastObject];
    }
    _pageCtl.numberOfPages = _imgViews.count;
    _backScrollView.contentSize = CGSizeMake(PageWidth * _imgViews.count, _backScrollView.frame.size.height);
    //重置至lastPage
    if (_backScrollView.contentOffset.x > _backScrollView.contentSize.width - PageWidth)
    {
        [_backScrollView setContentOffset:CGPointMake(_backScrollView.contentSize.width - PageWidth, 0) animated:YES];
        _pageCtl.currentPage = _imgViews.count - 1;
    }
}
- (void)loadingImgsWithURLs:(NSArray *)array
{
    self.urls=array;
    
    
    if ([array count] > 1) {
        self.pageCtl.hidden = NO;
    }
    else{
        self.pageCtl.hidden = YES;
    }

    [self changeImgViewsWithCount:_urls.count];
    
    [_imgViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imgView=obj;
        
        NSURL *url=[NSURL URLWithString:_urls[idx]];
        [imgView TMCacheImageWithURL:url finished:^(id userInfo ,NSString *key, id object,BOOL success) {
            if(success)
            {
                NSInteger index=[self.imgViews indexOfObject:userInfo];
                if (index >= 0 && index < self.indiViews.count) {
                    UIActivityIndicatorView * indiView = self.indiViews[index];
                    [indiView stopAnimating];
                    [indiView setHidden:YES];
                }
                
            }
            else
            {
                
            }
            
        }];

    }];
    
    _backScrollView.contentSize=CGSizeMake(_backScrollView.contentSize.width+PageWidth, _backScrollView.contentSize.height);
    [self addToWindowAnimated:YES];
}
- (void)loadingImgs:(NSArray *)array
{
    [self changeImgViewsWithCount:array.count];
    
    [_imgViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imgView=obj;
        
        imgView.image = [array objectAtIndex:idx];
        
        UIActivityIndicatorView * indiView = self.indiViews[idx];
        [indiView stopAnimating];
        [indiView setHidden:YES];
    }];
    
    if ([array count] > 1) {
        self.pageCtl.hidden = NO;
    }
    else{
        self.pageCtl.hidden = YES;
    }
    
    _backScrollView.contentSize=CGSizeMake(_backScrollView.contentSize.width+PageWidth, _backScrollView.contentSize.height);
    [self addToWindowAnimated:YES];
}

//重置
- (void)reset
{
    [_pageCtl setCurrentPage:0];
    [_backScrollView setContentOffset:CGPointZero];
    [self removeImgviewsWithCount:_imgViews.count];
//    [_imgViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//     {
//         UIImageView *imgView=obj;
//         imgView.image=nil;
//     }];
    self.isTapToClose = NO;
    self.isTapLastPageToClose = NO;
}
//添加至window之上
- (void)addToWindowAnimated:(BOOL)animated
{
    CGFloat top=.0f;
    if([CommonUtil SystemVersion]<7)
    {
        top=20.0f;
    }
    UIWindow * window = [CommonUtil getAppWindow];//view层级关系不一样，应具体问题具体分析
    //self.frame = CGRectMake(0, top, _backScrollView.width, _backScrollView.height);
    //  window.windowLevel = UIWindowLevelAlert;
    if (animated)
    {
        self.frame = CGRectMake(APP_SCREEN_WIDTH, top, APP_SCREEN_WIDTH, self.height);
        //_backScrollView.contentOffset = CGPointMake(-self.width, 0);
        [window addSubview:self];
        //[_backScrollView setContentOffset:CGPointZero animated:YES];
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, top, APP_SCREEN_WIDTH, self.height);
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        [window addSubview:self];
    }
    [window bringSubviewToFront:self];
}
//移除本view
- (void)removeFromWindow
{
    [self removeFromSuperview];
}

- (void)close{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromWindow];
            [self reset];
            self.alpha = 1.0;
        }];
    });
}

- (void)setPageControlHidden:(BOOL)hidden{
    self.pageCtl.hidden = hidden;
}
- (void)autoCloseAfter:(CGFloat)elapseTime{
    [self performSelector:@selector(close) withObject:nil afterDelay:elapseTime];
}

- (void)gotoPage:(NSInteger)page{
    self.pageCtl.currentPage = page;
    [_backScrollView setContentOffset:CGPointMake(page * _backScrollView.width, 0) animated:NO];
}
- (IBAction)onScrollViewTaped:(UITapGestureRecognizer *)sender {
    if (self.isTapToClose) {
        [self close];
    }
    if (self.isTapLastPageToClose && self.pageCtl.currentPage == self.pageCtl.numberOfPages-1) {
        [self close];
    }
}
@end
