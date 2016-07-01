//
//  LineProgressManager.m
//  jimao
//
//  Created by pan chow on 14/11/27.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "LineProgressManager.h"
#import "LineProgreesFrontView.h"

@interface LineProgressManager ()
{
    CGFloat _margin;
}
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)LineProgreesFrontView *frontView;
@end

@implementation LineProgressManager

SINGLETON_GCD(LineProgressManager);

# pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
        
    }
    return self;
}


- (void)showProFromBackground:(UIView *)view
{
    [self showProgressUponView:view margin:_margin];
}
# pragma mark - Public

- (void)showProgressUponView:(UIView *)view
{
    [self showProgressUponView:view margin:.0];
}
- (void)showProgressUponView:(UIView *)view margin:(CGFloat)margin
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _margin = margin;
        
        _backView=[self getBackViewWithFrame:view.frame];
        
        _frontView = [self getFrontViewWithFrame:view.frame];
        
        [view addSubview:_backView];
        [view addSubview:self.frontView];
        
        _backView.translatesAutoresizingMaskIntoConstraints=NO;
        _frontView.translatesAutoresizingMaskIntoConstraints=NO;
        
        [_backView lyt_alignLeftToParent];
        [_backView lyt_alignTopToParentWithMargin:margin];
        [_backView lyt_alignRightToParent];
        [_backView lyt_setHeight:3.0f];
        
        [_frontView lyt_alignLeftToParent];
        [_frontView lyt_alignTopToParentWithMargin:margin];
        [_frontView lyt_alignRightToParent];
        [_frontView lyt_setHeight:3.0f];
        
        //[view layoutIfNeeded];
    });
}
- (void)hideProgressView
{
    [self performSelector:@selector(hidePView) withObject:nil afterDelay:2.0f];
}
- (void)hidePView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView * sView = _backView.superview;
        
        [sView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *vw =obj;
            if(vw.tag == 132)
            {
                [vw removeFromSuperview];
            }
        }];
    });
}
# pragma mark - Initialization

- (void)initialize
{
    self.height = 2.0f;
    self.backColor = [UIColor colorWithWhite:0 alpha:.4];
    self.color=[UIColor redColor];
    self.gradientColors=@[[UIColor colorWithWhite:0 alpha:.0],[UIColor colorWithWhite:0 alpha:.1],[UIColor colorWithWhite:0 alpha:.2],[UIColor colorWithWhite:0 alpha:.3],rgb(147, 140, 115),rgb(185, 162, 89),rgb(226, 187, 65),rgb(239, 195, 58),rgb(254, 204, 54)];
}

# pragma mark - Helpers (KIProgressView)

- (UIView *)getBackViewWithFrame:(CGRect)frame
{
    CGRect aFrame = CGRectMake(0, 0, frame.size.width, _height);
    UIView *view=[[UIView alloc] initWithFrame:aFrame];
    view.tag=132;
    view.backgroundColor=_backColor;
    return view;
}
- (LineProgreesFrontView *)getFrontViewWithFrame:(CGRect)frame {
    CGRect aFrame = CGRectMake(0, 0, frame.size.width, _height);
    LineProgreesFrontView *progressView = [[LineProgreesFrontView alloc] initWithFrame:aFrame];
    progressView.tag=132;
    if(_gradientColors)
    {
        self.gradientColors=_gradientColors;
        //progressView.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:aFrame  andColors:_gradientColors];
    }
    else
    {
       //progressView.backgroundColor=_color;
    }
    
    return progressView;
}

- (BOOL)isAnimate
{
    if(self.frontView && self.frontView.superview)
    {
        return YES;
    }
    return NO;
}
@end
