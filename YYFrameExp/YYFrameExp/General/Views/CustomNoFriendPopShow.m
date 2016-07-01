//
//  CustomNoFriendPopShow.m
//  jimao
//
//  Created by fwr on 14/12/10.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "CustomNoFriendPopShow.h"
#define WIN_HEIGHT            [UIScreen mainScreen].bounds.size.height

#define CALERT_WIDTH 246
#define kBackViewHeight 150

#define CALERT_TAG 65535876

const UIWindowLevel UIWindowLevelSIAlert = 1999.0;  // don't overlap system's alert
const UIWindowLevel UIWindowLevelSIAlertBackground = 1998.0; // below the alert window


@interface CustomNoFriendPopShowView ()

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)NSMutableArray *btnTitiles;

@end


@implementation CustomNoFriendPopShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.btnTitiles=[NSMutableArray array];
        self.tag=CALERT_TAG;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.style=ZPCustomAlertViewTransitionStyleBounce;
        
    }
    return self;
}
+ (instancetype)sharedInstance
{
    static CustomNoFriendPopShowView *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CustomNoFriendPopShowView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    });
    return instance;
}




#pragma mark --- public ---
- (instancetype)initWithTitle:(NSString *)title  messages:(NSString *) tempMessage delegate:(id /*<CustomNoFriendPopShowViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self=[CustomNoFriendPopShowView sharedInstance];
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:.7];
    if(self)
    {
        [self reset];
        if(delegate)
        {
            self.delegate=delegate;
        }
        else
        {
            self.delegate=nil;
        }
 
        if(_backView)
        {
            self.backView=nil;
        }
        self.backView=[[UIView alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH-CALERT_WIDTH)*.5,(APP_SCREEN_HEIGHT - kBackViewHeight)*0.5, CALERT_WIDTH, kBackViewHeight)];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(CALERT_WIDTH-40-4,2,40,40);
        [btn setImage:[UIImage imageNamed:@"ShopAddFriendCloseBtn.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ShopAddFriendCloseBtn.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:btn];
        
        UILabel *msgLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, _backView.bottom/2 - 40 -8 - 25, _backView.bounds.size.width, 25)];
        msgLabel.backgroundColor=[UIColor clearColor];
        msgLabel.textAlignment=NSTextAlignmentCenter;
        msgLabel.textColor=[UIColor blackColor];
        msgLabel.font=[UIFont boldSystemFontOfSize:16.0f];
        msgLabel.text= tempMessage;
        [_backView addSubview:msgLabel];

        
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*))
        {
            [self.btnTitiles addObject:str];
        }
        va_end(args);
         
        [_btnTitiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *title=obj;
            
            @autoreleasepool
            {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                
                btn.frame=CGRectMake(idx*(CALERT_WIDTH)/2,_backView.bottom/2 - 40,CALERT_WIDTH/2,40);
                
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
                
                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ShopAddFriendPopShowBtn%d",idx + 1]] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ShopAddFriendPopShowBtn%d",idx + 1]] forState:UIControlStateHighlighted];
                btn.tag=idx;
                
                [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
                [_backView addSubview:btn];
            }
        }];
        UIImage *backImg=[UIImage imageNamed:@"ShopAddFriendBg1.png"];
        UIImageView *backImgView=[[UIImageView alloc] initWithFrame:_backView.bounds];
        backImgView.contentMode=UIViewContentModeScaleToFill;
        backImgView.image=backImg;
        [_backView insertSubview:backImgView belowSubview:btn];
        
        [self addSubview:_backView];
    }
    return self;
}



- (void)show
{
    UIWindow *win=[self getMainWindow];
    
    CustomNoFriendPopShowView *alert=(CustomNoFriendPopShowView *)[win viewWithTag:CALERT_TAG];
    if(alert)
    {
        [alert hide];
    }
    self.alpha=1.0f;
    [win addSubview:self];
    [self transitionInCompletion:^{
        
    }];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    return _btnTitiles[buttonIndex];
}
- (void)dismissAnimated:(BOOL)animated
{
    if(animated)
    {
        [self hide];
    }
    else
    {
        [[self getMainWindow] makeKeyAndVisible];
        [self removeFromSuperview];
    }
}
#pragma mark --- private ---
 - (void)btn:(UIButton *)btn
{
    [self hide];
    if([self.delegate respondsToSelector:@selector(CustomNoFriendPopShowView:didDismissWithButtonIndex:)])
    {
        [_delegate CustomNoFriendPopShowView:self didDismissWithButtonIndex:btn.tag];
    }
}
- (void)closeBtn:(UIButton *)btn
{
    [self hide];
}
- (void)tap:(UITapGestureRecognizer *)tap
{
    [self hide];
}
- (void)hide
{
    [self transitionOutCompletion:^{
        [UIView animateWithDuration:.2 animations:^{
            self.alpha=.0f;
        } completion:^(BOOL finished) {
            // TODO: hide and remove
            [[self getMainWindow] makeKeyAndVisible];
            [self removeFromSuperview];
            
            
        }];
    }];
}
- (UIWindow *)getMainWindow
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}
- (void)reset
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.btnTitiles removeAllObjects];
    self.delegate=nil;
}
#pragma mark - Transitions

- (void)transitionInCompletion:(void(^)(void))completion
{
    switch (self.style) {
        case ZPCustomAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.backView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            self.backView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.backView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case ZPCustomAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.backView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.backView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.backView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case ZPCustomAlertViewTransitionStyleFade:
        {
            self.backView.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.backView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case ZPCustomAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.backView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
        case ZPCustomAlertViewTransitionStyleDropDown:
        {
            CGFloat y = self.backView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.backView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    switch (_style) {
        case ZPCustomAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.backView.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.backView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case ZPCustomAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.backView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.backView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case ZPCustomAlertViewTransitionStyleFade:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.backView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case ZPCustomAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.backView.layer addAnimation:animation forKey:@"bounce"];
            
            self.backView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
        case ZPCustomAlertViewTransitionStyleDropDown:
        {
            CGPoint point = self.backView.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.backView.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 self.backView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}


@end
