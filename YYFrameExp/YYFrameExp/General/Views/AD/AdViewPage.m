//
//  AdViewPage.m
//  FlowExp
//
//  Created by fwr on 14-7-1.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "AdViewPage.h"
#import "NSTimer+Addition.h"
#import "UIImageView+AFNetworking.h"

//#define PageWidth 230
//#define PageHeight 150
//#define MoveIntervalTime 2
//#define adViewPlaceHolderImg AD_PLACEHODER_IMG_NAME

@interface AdViewPage()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *placeHolderView_;
    UIPageControl *defaultPageControl_;
    int pageWidth_;
    int pageHeight_;
    
}
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSMutableArray *adArrays;
@end

@implementation AdViewPage

- (id)pageControl{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageControl)]) {
        return [self.delegate pageControl];
    }
    else{
        if (!defaultPageControl_) {
            defaultPageControl_=[[UIPageControl alloc] initWithFrame:CGRectMake(0,_scrollView.bounds.size.height - 10,self.bounds.size.width ,10)];
            //[defaultPageControl_ addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
//            defaultPageControl_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;

            [self addSubview:defaultPageControl_];
            
            NSDictionary *viewsDictionary =
            NSDictionaryOfVariableBindings(defaultPageControl_);
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[defaultPageControl_]|"
                                                                           options:0 metrics:nil views:viewsDictionary];
            [self addConstraints:constraints];
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[defaultPageControl_]-10-|"
                                                                  options:0 metrics:nil views:viewsDictionary];
            [self addConstraints:constraints];
        }
        return defaultPageControl_;
    }
}
-(NSMutableArray *)adArrays
{
    if(!_adArrays)
    {
        _adArrays =[[NSMutableArray alloc] init];
    }
    return _adArrays;
} 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

-(void)awakeFromNib{
    _scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = _scrollView.bounds.size;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.alwaysBounceVertical=NO;
    _scrollView.alwaysBounceHorizontal=NO;
    
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:self.width/self.height constant:0];
//    [_scrollView addConstraint:constraint];

//    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|
//     UIViewAutoresizingFlexibleLeftMargin|
//     UIViewAutoresizingFlexibleRightMargin|
//     UIViewAutoresizingFlexibleBottomMargin|
//     UIViewAutoresizingFlexibleWidth|
//     UIViewAutoresizingFlexibleHeight];
    
    [self addSubview:_scrollView];
    
//    NSDictionary *viewsDictionary =
//    NSDictionaryOfVariableBindings(_scrollView);
//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_scrollView]|"
//                                                                   options:0 metrics:nil views:viewsDictionary];
//    [self addConstraints:constraints];
//    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|"
//                                                          options:0 metrics:nil views:viewsDictionary];
//    [self addConstraints:constraints];

    _MoveIntervalTime = 3.5;
    pageWidth_ = _scrollView.width;
    pageHeight_ = _scrollView.height;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    pageWidth_ = _scrollView.width;
    pageHeight_ = _scrollView.height;
    
    int i=0;
    for (UIView *subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            subView.frame = CGRectMake(i*pageWidth_, 0,pageWidth_, pageHeight_);
            i++;
        }
    }
    _scrollView.contentSize = CGSizeMake(pageWidth_ * [self.adArrays count], self.bounds.size.height);
    [_scrollView setContentOffset:CGPointMake(pageWidth_ * [[self pageControl] currentPage], 0) animated:NO];
}

- (void)dealloc{
    [self.timer invalidate];
    _scrollView.delegate = nil;
}
//-(void)pageControl:(UIPageControl *)ctrl
//{
//    [_scrollView setContentOffset:CGPointMake(self.PageWidth * [self pageControl].currentPage, 0) animated:YES];
//    [self.timer resumeTimerAfterTimeInterval:5.0f];
//}

//点击单个
-(void)adPressed:(UIGestureRecognizer *)gesture
{
    if([self.delegate respondsToSelector:@selector(AdPressedAtIndex:)])
    {
         [_delegate AdPressedAtIndex:[[self pageControl] currentPage]]; // bug incase pagecontrol is null.
    }
}

- (void)setAdImages:(NSArray *)adArraytemp{
    [self.adArrays removeAllObjects];
    [self.adArrays addObject:[adArraytemp lastObject]];
    [self.adArrays addObjectsFromArray:adArraytemp];
    [self.adArrays addObject:[adArraytemp firstObject]];
    
    //_scrollView.frame = CGRectMake(0, 0, pageWidth_, pageHeight_);
    _scrollView.contentOffset = CGPointMake(pageWidth_, 0);
    _scrollView.contentSize = CGSizeMake(pageWidth_ * [self.adArrays count], self.bounds.size.height);
    [[self pageControl] setNumberOfPages:[self.adArrays count] - 2]; //
    [[self pageControl] setCurrentPage:0];
    [[self pageControl] updateCurrentPageDisplay];
  
    for ( int i=0; i<[self.adArrays count]; i++) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[self.adArrays objectAtIndex:i]];
        img.frame = CGRectMake(i*pageWidth_, 0,pageWidth_, pageHeight_);
        [_scrollView addSubview:img];
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adPressed:)];
        [img addGestureRecognizer:tap1];
    }
    
}

- (void)start
{
    if (self.adArrays.count > 1) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_MoveIntervalTime target:self selector:@selector(moveImageView) userInfo:nil repeats:YES];
    }
}

- (void)stop{
    if (self.adArrays.count > 1) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
-(void)moveImageView
{
    if(!(_adArrays.count<=3 && _hidePageCtl))
    {
        [_scrollView setContentOffset:CGPointMake(pageWidth_ * [[self pageControl] currentPage] + pageWidth_*2, 0) animated:YES];
    }
}

//添加的广告资源为URL
- (void)setAdImagesWithURLs:(NSArray *)array{
    [self.adArrays removeAllObjects];
    [placeHolderView_ removeFromSuperview];
    if (array.count == 0) {
        placeHolderView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.placeHolderImageName]];
        placeHolderView_.backgroundColor = [UIColor colorWithRed:0.926 green:0.900 blue:0.812 alpha:1.000];
        placeHolderView_.frame = self.bounds;
        placeHolderView_.contentMode = UIViewContentModeCenter;
        placeHolderView_.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:placeHolderView_];
//        NSDictionary *viewsDictionary =
//        NSDictionaryOfVariableBindings(placeHolderView_);
//        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[placeHolderView_]|"
//                                                                       options:0 metrics:nil views:viewsDictionary];
//        [self addConstraints:constraints];
//        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[placeHolderView_]|"
//                                                              options:0 metrics:nil views:viewsDictionary];
//        [self addConstraints:constraints];

        return;
    }
    
    [self.adArrays addObject:[array lastObject]];
    [self.adArrays addObjectsFromArray:array];
    [self.adArrays addObject:[array firstObject]];
    
    if(_adArrays.count<=3 && _hidePageCtl)
    {
        [[self pageControl] setHidden:YES];
        _scrollView.scrollEnabled=NO;
    }
    else
    {
        [[self pageControl] setHidden:NO];
        _scrollView.scrollEnabled=YES;
    }
    //_scrollView.frame = CGRectMake(0, 0, pageWidth_, pageHeight_);
    _scrollView.contentOffset = CGPointMake(pageWidth_, 0);
    _scrollView.contentSize = CGSizeMake(pageWidth_ * [self.adArrays count], self.bounds.size.height);
    [[self pageControl] setNumberOfPages:[self.adArrays count] - 2];
    [[self pageControl] setCurrentPage:0];
    [[self pageControl] updateCurrentPageDisplay];
    
    for ( int i=0; i<[self.adArrays count]; i++) {
        NSString *url=[self.adArrays objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*pageWidth_, 0,pageWidth_, pageHeight_);
        [_scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES; 
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adPressed:)];
        [imageView addGestureRecognizer:tap1];
        
        UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(pageWidth_ / 2.0, pageHeight_ / 2.0);
        [indicator startAnimating];
        [imageView addSubview: indicator];
        
        __weak UIImageView *weakIamgeView = imageView;
        __weak UIActivityIndicatorView *weakIndicator = indicator;
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            dispatch_async( dispatch_get_main_queue(), ^(void){
                [weakIndicator stopAnimating];
                [weakIamgeView setImage:image];
            });

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            dispatch_async( dispatch_get_main_queue(), ^(void){
                [weakIndicator stopAnimating];
                [weakIamgeView setImage:[UIImage imageNamed:_placeHolderImageName]];
            });
        }];
    }

}

void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL] ;
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock(image);
                               
                           } else {
                               errorBlock();
                           }
                       });
                   });
}


#pragma  mark ------scrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int offsetX = scrollView.contentOffset.x;
//    if(offsetX < 0)
//    {
//        [scrollView setContentOffset:CGPointMake(pageWidth_*(self.adArrays.count-1), 0)];
//    }
//    if(offsetX > pageWidth_*self.adArrays.count)
//    {
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//    }
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stop];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        int offsetX = scrollView.contentOffset.x;
        
        NSInteger page = roundf(offsetX / pageWidth_);
        if(page == self.adArrays.count - 1)
        {
            [scrollView setContentOffset:CGPointMake(pageWidth_, 0) animated:NO];
            [[self pageControl] setCurrentPage:0];
        }
        else if(page == 0){
            [[self pageControl] setCurrentPage:self.adArrays.count-2];
            [scrollView setContentOffset:CGPointMake((self.adArrays.count - 2)*pageWidth_, 0)];
        }
        else{
            [[self pageControl] setCurrentPage:page-1];
        }
        [self start];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        int offsetX = scrollView.contentOffset.x;
        NSInteger page = roundf(offsetX / pageWidth_);
        if(page == self.adArrays.count - 1)
        {
            [scrollView setContentOffset:CGPointMake(pageWidth_, 0) animated:NO];
            [[self pageControl] setCurrentPage:0];
        }
        else if(page == 0){
            [[self pageControl] setCurrentPage:self.adArrays.count-2];
            float delta = (self.adArrays.count - 2)*pageWidth_ - page*pageWidth_;
            [scrollView setContentOffset:CGPointMake(delta + (offsetX-page*pageWidth_), 0)];
        }
        else{
            [[self pageControl] setCurrentPage:page - 1];
        }
        offsetX = scrollView.contentOffset.x;
        if (offsetX % pageWidth_ != 0) {
            int pageNum = offsetX/pageWidth_;
            [scrollView setContentOffset:CGPointMake(pageWidth_*pageNum, 0) animated:YES];
        }
        
        [self start];
    }
}


@end
