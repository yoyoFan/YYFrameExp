//
//  PopViewTip.m
//  Mei
//
//  Created by fwr on 15/12/8.
//  Copyright © 2015年 pan chow. All rights reserved.
//

#import "PopViewTip.h"


@interface PopViewTip()
{
    NSInteger  totalTime;
    NSInteger currentTime;
    NSTimer *timer;
}
@property(nonatomic, copy) void (^onTap)(PopViewTip *sender);
@end


@implementation PopViewTip

+(PopViewTip *)shareInstance
{
    static PopViewTip *popView;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
       
        popView = [[PopViewTip alloc] init];
    });
    return popView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTaped)];
        [self addGestureRecognizer:tap];
        
        
        
        
    }
    return self;
}



-(void)initPopViewTipInView:(UIView *)view  dissmisAfterTime:(NSInteger)time  TipTitle:(NSString *)msgTitle TipMessage:(NSString *)tipMsg onDisplay:(void (^)(PopViewTip *sender))onDisplay onTap:(void (^)(PopViewTip *sender))onTap{
    
    self.onTap = onTap;
    self.frame = view.bounds;
    
    UIImage *img =[UIImage imageNamed:@"iosbg"];
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(40, 150, view.width - 80, 260)];
    imgView.image = img;
    [self addSubview:imgView];
    
    //在image上加 文字
    UILabel *titleLabel =[[UILabel alloc] init];
    titleLabel.frame =CGRectMake(imgView.centerX - 200/2, 30, 200, 50);
    titleLabel.text =msgTitle;
    titleLabel.font =[UIFont systemFontOfSize:25];
    titleLabel.textColor = [UIColor redColor];
    [imgView addSubview:titleLabel];
    
    
    [view  addSubview:self];
    
    totalTime = time;
    imgView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:1 animations:^{
        imgView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            imgView.transform = CGAffineTransformMakeScale(0.8,0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                imgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
            }];
        }];
    }];

    [self StartTime:1];
}

-(void)StartTime:(NSInteger)time
{
    timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [timer fire];
}


- (void)close{
    [self removeFromSuperview];
}
- (void)backTaped{
    [self close];
}
- (void)imageTaped{
    [self close];
    if (self.onTap) {
        self.onTap(self);
    }
}


-(void)dealloc
{
    [timer invalidate];
}


#pragma mark =======动画效果======
-(void)timerFired:(NSTimer *)time
{
    currentTime ++;
        if(currentTime >= totalTime)
    {
        [timer invalidate];
        [self removeFromSuperview];
    }
}



@end
