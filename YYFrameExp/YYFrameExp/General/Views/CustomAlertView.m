//
//  CustomAlertView.m
//  FlowExp
//
//  Created by pan chow on 14-5-21.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "CustomAlertView.h"

#define ZP_WIN_HEIGHT            [UIScreen mainScreen].bounds.size.height

#define ZP_CALERT_WIDTH 264
#define ZP_CALERT_HEIGHT 200
#define ZP_CALERT_TAG 65535876



@interface CustomAlertView ()
{
    NSTimeInterval countIntval;
    NSTimer *countTimer;
    UILabel *countLB;
}
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)NSMutableArray *btnTitiles;

@end
@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.btnTitiles=[NSMutableArray array];
        self.tag=ZP_CALERT_TAG;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.style=CustomAlertViewTransitionStyleBounce;
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        [self addGestureRecognizer:tap];
//        self.userInteractionEnabled=YES;
       
    }
    return self;
}
+ (instancetype)sharedInstance
{
    static CustomAlertView *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    });
    return instance;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //画透明背景
//    CGContextSetRGBFillColor(context, 0, 0, 0, 0.5);
//    CGContextFillRect(context, CGRectMake(0, 0, 320, WIN_HEIGHT));
//    CGContextStrokePath(context);
}

#pragma mark --- public ---
- (instancetype)initWithTitle:(NSString *)title count:(NSTimeInterval)interval delegate:(id /*<CustomAlertViewDelegate>*/)delegate clickBlock:(clickBlock)block
{
    self=[CustomAlertView sharedInstance];
    self.clipsToBounds = YES;
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
        if(block)
        {
            self.clickBlock =block;
        }
        __block CGFloat top=12.0f;
        if(_backView)
        {
            self.backView=nil;
        }
        self.backView=[[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-ZP_CALERT_WIDTH)*.5, 4, ZP_CALERT_WIDTH, top)];
        _backView.clipsToBounds = YES;
        UIImage *logoImg=[UIImage imageNamed:@"cavcat.png"];
        UIImageView *logoImgView=[[UIImageView alloc] initWithFrame:CGRectMake((ZP_CALERT_WIDTH-85)*.5, top, 85, 56)];
        logoImgView.contentMode=UIViewContentModeScaleToFill;
        logoImgView.image=logoImg;
        [_backView addSubview:logoImgView];
        
        top += 65;
        
        [self addSubview:_backView];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(ZP_CALERT_WIDTH-39-4,2,39,39);
        
        [btn setImage:[UIImage imageNamed:@"cavCloseBtn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cavCloseBtn"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:btn];
        
        if(title)
        {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10, top, _backView.bounds.size.width-20, 20)];
            lb.backgroundColor=[UIColor clearColor];
            lb.numberOfLines=0;
            lb.textAlignment=NSTextAlignmentLeft;
            lb.textColor=[UIColor blackColor];
            lb.font=[UIFont fontWithName:@"Arial" size:14];
            
            [self reSizeLabel:lb withText:title rowHeight:12];
            [_backView addSubview:lb];
            top +=lb.bounds.size.height+6;

        }
        top += 40;
        UIImage *bottomImg=[UIImage imageNamed:@"cavbootmback"];
        //bottomImg=[bottomImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 30, 30, 20)];
         UIImageView *bottomImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, top-28, ZP_CALERT_WIDTH-.5, 40)];
        bottomImgView.clipsToBounds = YES;
        bottomImgView.contentMode=UIViewContentModeScaleToFill;
        bottomImgView.image=bottomImg;
        [_backView insertSubview:bottomImgView belowSubview:logoImgView];
        
        countLB=[[UILabel alloc] initWithFrame:bottomImgView.frame];
        countLB.backgroundColor=[UIColor clearColor];
        countLB.textAlignment=NSTextAlignmentCenter;
        countLB.textColor=[UIColor whiteColor];
        countLB.font=[UIFont boldSystemFontOfSize:18.0f];
        [_backView addSubview:countLB];
        

        if(interval>=0)
        {
            countIntval =interval;
            countLB.text=[NSString stringWithFormat:@"%d秒后返回首页",(NSInteger)countIntval];

            //loginname需要赋值
            countTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(verifyTimerTick:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:countTimer forMode:NSDefaultRunLoopMode];
        }
        _backView.frame=CGRectMake(_backView.frame.origin.x, (self.bounds.size.height-top-4)*.5, _backView.frame.size.width, top+12);
        
        UIImage *bkImg=[UIImage imageNamed:@"cavback"];
        bkImg=[bkImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 30, 30, ZP_CALERT_HEIGHT)];
        UIImageView *bkImgView=[[UIImageView alloc] initWithFrame:_backView.bounds];
        bkImgView.contentMode=UIViewContentModeScaleToFill;
        bkImgView.image=bkImg;
        bkImgView.clipsToBounds = YES;
        [_backView insertSubview:bkImgView atIndex:0];
        
        
        [self addSubview:_backView];
    }
    return self;
}
- (void)verifyTimerTick:(NSTimer *)timer{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (countIntval <= 0)
        {
            //hide
            [timer invalidate];
            countIntval = 0;
            [self dismissAnimated:YES];
        }
        else
        {
            countLB.text = countLB.text=[NSString stringWithFormat:@"%d秒后返回首页",(NSInteger)countIntval];
            countIntval--;
        }
    });
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail messages:(NSArray *)messages clickBlock:(clickBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self=[CustomAlertView sharedInstance];
    self.clipsToBounds = YES;
    self.backgroundColor=[UIColor colorWithWhite:0 alpha:.7];
    if(self)
    {
        [self reset];
        
       if(block)
       {
           self.clickBlock = block;
       }
        __block CGFloat top=8.0f;
        if(_backView)
        {
            self.backView=nil;
        }
        self.backView=[[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-ZP_CALERT_WIDTH)*.5, 4, ZP_CALERT_WIDTH, top)];
        _backView.clipsToBounds = YES;
        
        [self addSubview:_backView];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(ZP_CALERT_WIDTH-39-4,4,39,39);
        
        [btn setImage:[UIImage imageNamed:@"cavCloseBtn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cavCloseBtn"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:btn];
        
        top = 15;
        if(title)
        {
            UILabel *titleLB=[[UILabel alloc] initWithFrame:CGRectMake(10, top-5, _backView.bounds.size.width-20, 25)];
            titleLB.backgroundColor=[UIColor clearColor];
            titleLB.textAlignment=NSTextAlignmentCenter;
            titleLB.textColor=ColorC5;
            titleLB.font=[UIFont boldSystemFontOfSize:18.0f];
            titleLB.text=title;
            [_backView addSubview:titleLB];
            
            top+=25+8;
            
            UIImageView *lineimgView= [[UIImageView alloc] initWithFrame:CGRectMake(10, titleLB.bottom+2, _backView.width-20, 1)];
            lineimgView.image = [UIImage imageNamed:@"line"];
            [_backView addSubview:lineimgView];
        }
        if(detail)
        {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10, top, _backView.bounds.size.width-20, 20)];
            lb.backgroundColor=[UIColor clearColor];
            lb.numberOfLines=0;
            lb.textAlignment=NSTextAlignmentLeft;
            lb.textColor=ColorC4;
            lb.font=[UIFont fontWithName:@"Arial" size:14];
            
            [self reSizeLabel:lb withText:detail rowHeight:16];
            [_backView addSubview:lb];
            top +=lb.bounds.size.height+6;

        }
       
        
        NSTextAlignment alignment;
        if(messages.count==1)
        {
            alignment=NSTextAlignmentCenter;
        }
        else
        {
            alignment=NSTextAlignmentLeft;
        }
        [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            @autoreleasepool
            {
                NSString *message=obj;
                
                
                
                UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(25, top, _backView.bounds.size.width-35, 20)];
                lb.backgroundColor=[UIColor clearColor];
                lb.numberOfLines=0;
                lb.textAlignment=alignment;
                lb.textColor=ColorC4;
                lb.font=[UIFont fontWithName:@"Arial" size:14];
                
                [self reSizeLabel:lb withText:message rowHeight:16];
                [_backView addSubview:lb];
                
                UILabel *lb0=[[UILabel alloc] initWithFrame:CGRectMake(18, top, 5, 20)];
                lb0.backgroundColor=[UIColor clearColor];
                lb0.textAlignment=alignment;
                lb0.textColor=ColorC4;
                lb0.font=[UIFont fontWithName:@"Arial" size:14];
                lb0.text = @"•";
                lb0.center = CGPointMake(lb0.centerX, lb.centerY);
                [_backView addSubview:lb0];
                
                UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 5, 5)];
                imgView.image=[UIImage imageNamed:@"refreshkdot.png"];
                imgView.center=CGPointMake(imgView.centerX, lb.centerY);
                [_backView addSubview:imgView];
                top+=lb.bounds.size.height+5;
            }
        }];
        
        UIImage *bottomImg=[UIImage imageNamed:@"cavbootmback"];
        bottomImg=[bottomImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 30, 30, 20)];
        UIImageView *bottomImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, top+10, ZP_CALERT_WIDTH-.5, 40)];
        bottomImgView.contentMode=UIViewContentModeScaleToFill;
        bottomImgView.image=bottomImg;
        [_backView addSubview:bottomImgView];
        
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*))
        {
            [self.btnTitiles addObject:str];
        }
        va_end(args);
        
        btn.hidden=YES;
        if(cancelButtonTitle)
        {
            btn.hidden=NO;
            //[self.btnTitiles addObject:cancelButtonTitle];
        }
        
       
        
        if(_btnTitiles.count==2)
        {
            top += 50;
            [_btnTitiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *title=obj;
                
                @autoreleasepool
                {
                    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    
                    CGFloat width=(_backView.bounds.size.width-20-10)*.5;
                    btn.frame=CGRectMake(10+idx*(width + 10),top-36,width,37);
                    
                    [btn setTitle:title forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btn.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
                    
                    //[btn setBackgroundImage:[UIImage imageNamed:@"caletbtn.png"] forState:UIControlStateNormal];
                    //[btn setBackgroundImage:[UIImage imageNamed:@"caletbtnc.png"] forState:UIControlStateHighlighted];
                    btn.tag=idx;
                    
                    [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
                    [_backView addSubview:btn];
                }
            }];
            //top+=37+4;
        }
        else
        {
            [_btnTitiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *title=obj;
                
                @autoreleasepool
                {
                    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.backgroundColor = [UIColor clearColor];
                    CGFloat width=_backView.bounds.size.width;
                    top += 8;
                    btn.frame=CGRectMake(0,top+5,width-20,37);
                    
                    [btn setTitle:title forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btn.titleLabel.font=[UIFont fontWithName:@"Arial" size:16];
                    
//                    [btn setBackgroundImage:[UIImage imageNamed:@"caletbtn.png"] forState:UIControlStateNormal];
//                    [btn setBackgroundImage:[UIImage imageNamed:@"caletbtnc.png"] forState:UIControlStateHighlighted];
                    btn.tag=idx;
                    
                    [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
                    [_backView addSubview:btn];
                    
                    top+=btn.frame.size.height+5;
                }
            }];
        }
        _backView.frame=CGRectMake(_backView.frame.origin.x, (self.bounds.size.height-top-4)*.5, _backView.frame.size.width, top);
        
        UIImage *bkImg=[UIImage imageNamed:@"cavback"];
        bkImg=[bkImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 30, 30, ZP_CALERT_HEIGHT)];
        UIImageView *bkImgView=[[UIImageView alloc] initWithFrame:_backView.bounds];
        bkImgView.contentMode=UIViewContentModeScaleToFill;
        bkImgView.image=bkImg;
        [_backView insertSubview:bkImgView atIndex:0];

        
        [self addSubview:_backView];
    }
    return self;
}
- (void)show
{
    UIWindow *win=[self getMainWindow];
    
    CustomAlertView *alert=(CustomAlertView *)[win viewWithTag:ZP_CALERT_TAG];
    if(alert)
    {
        [alert hide];
    }
//    self.alpha=.0;
//    [win addSubview:self];
//    
//    [UIView animateWithDuration:.2 animations:^{
//        self.alpha=1.0f;
//    } completion:^(BOOL finished) {
//        [self transitionInCompletion:^{
//            
//        }];
//    }];
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
//据text使label自适应大小，最小高度=rowHeight
- (void)reSizeLabel:(UILabel *)label withText:(NSString *)text rowHeight:(NSInteger)rowHeight
{
    label.text = text;
    if (text.length == 0)
    {
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.bounds.size.width,rowHeight);
        return;
    }
    CGSize size = [text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, 1000) lineBreakMode:label.lineBreakMode];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.bounds.size.width, roundf(size.height / rowHeight) * rowHeight);
}
- (void)btn:(UIButton *)btn
{
    [self hide2];
    if(_clickBlock)
    {
        _clickBlock(btn.tag,[self buttonTitleAtIndex:btn.tag]);
    }
    
    if([self.delegate respondsToSelector:@selector(customAlertView:didDismissWithButtonIndex:)])
    {
        [_delegate customAlertView:self didDismissWithButtonIndex:btn.tag];
    }
}
- (void)closeBtn:(UIButton *)btn
{
    if(countTimer)
    {
        [countTimer invalidate];
        countIntval = 0;
    }
    [self hide2];
    if(_clickBlock)
    {
        _clickBlock(-1,@"close");
    }
}
- (void)tap:(UITapGestureRecognizer *)tap
{
    [self hide2];
    if(_clickBlock)
    {
        _clickBlock(-1,@"close");
    }
}
- (void)hide2
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
- (void)hide
{
    [self transitionOutCompletion:^{
        [UIView animateWithDuration:.2 animations:^{
            self.alpha=.0f;
           
        } completion:^(BOOL finished) {
            // TODO: hide and remove
            [[self getMainWindow] makeKeyAndVisible];
            [self removeFromSuperview];
            
            if(_clickBlock)
            {
                _clickBlock(0,@"");
            }
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
        case CustomAlertViewTransitionStyleSlideFromBottom:
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
        case CustomAlertViewTransitionStyleSlideFromTop:
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
        case CustomAlertViewTransitionStyleFade:
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
        case CustomAlertViewTransitionStyleBounce:
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
        case CustomAlertViewTransitionStyleDropDown:
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
        case CustomAlertViewTransitionStyleSlideFromBottom:
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
        case CustomAlertViewTransitionStyleSlideFromTop:
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
        case CustomAlertViewTransitionStyleFade:
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
        case CustomAlertViewTransitionStyleBounce:
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
        case CustomAlertViewTransitionStyleDropDown:
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
