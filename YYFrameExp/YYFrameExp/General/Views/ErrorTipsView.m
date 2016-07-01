//
//  ErrorTipsView.m
//  jimao
//
//  Created by pan chow on 15/8/13.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "ErrorTipsView.h"
#import <Masonry/Masonry.h>
#import "UIDevice-Reachability.h"
@interface ErrorTipsView ()
{
    IBOutlet UIView *tipsView;
    
    IBOutlet UIImageView *tips_imgView;
    IBOutlet UIImageView *tips_literal_imgView;
    IBOutlet UILabel *tipsLB;
    IBOutlet UIButton *addBtn;
    
}
@end
@implementation ErrorTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initial
{
    self.backgroundColor = MAIN_BACK_GROUND_COLOR;
    self.tag =10010;
    
    tipsView.backgroundColor = [UIColor clearColor];
    
    tipsLB.font = UIFont16;
    tipsLB.textColor = ColorC4;
    tipsLB.textAlignment = NSTextAlignmentCenter;
    tipsLB.numberOfLines = 2;
    tipsLB.backgroundColor = [UIColor clearColor];
    
    addBtn.backgroundColor=ColorC7;
    addBtn.layer.cornerRadius=10;
    addBtn.clipsToBounds=YES;
    [addBtn setTitle:@"去添加" forState:UIControlStateNormal];
    addBtn.hidden=YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img_tap:)];
    tips_imgView.userInteractionEnabled = YES;
    [tips_imgView addGestureRecognizer:tap];
}
- (void)img_tap:(UITapGestureRecognizer *)tap
{
    if(self.refreshBlock)
    {
        _refreshBlock();
    }
}

+ (ErrorTipsView *)initFromNib
{
    ErrorTipsView *eView = [[[NSBundle mainBundle] loadNibNamed:@"ErrorTipsView" owner:nil options:nil] firstObject];
    if(eView)
    {
        [eView initial];
    }
    return eView;
}
//隐藏提示view
+ (void)hideError_viewOnView:(UIView *)view
{
    ErrorTipsView *errorView = (ErrorTipsView *)[view viewWithTag:10010];
    if(errorView && errorView.superview)
    {
        [errorView removeFromSuperview];
    }
}
//网络问题提示
+ (void)show_errorView_when_netbug_onView:(UIView *)baseView refresh:(RefreshBlock)block
{
    ErrorTipsView *errorView = (ErrorTipsView *)[baseView viewWithTag:10010];
    if(!errorView)
    {
        errorView = [ErrorTipsView initFromNib];//[[self class] shareInstance];
    }
    
    if([[UIDevice currentDevice] networkAvailable])
    {
        [errorView showError_tips_when_badnet_onView:baseView refresh:^{
            block();
        }];
    }
    else
    {
        [errorView showError_tips_when_nonet_onView:baseView refresh:^{
            block();
        }];
    }
}

//无数据,并修改提示信息
+ (void)show_errorView_when_nodata_onView:(UIView *)baseView TipMessage:(NSString *)message
{
    ErrorTipsView *errorView = (ErrorTipsView *)[baseView viewWithTag:10010];
    if(!errorView)
    {
        errorView = [ErrorTipsView initFromNib];//[[self class] shareInstance];
    }
    
    [errorView showError_tips_when_nodata_TipMsg_onView:baseView TipMessage:message];
}
- (void)showError_tips_when_nodata_TipMsg_onView:(UIView *)baseView TipMessage:(NSString *)tipMes
{
    tips_literal_imgView.hidden = YES;
    self.refreshBlock = nil;
    
    tipsLB.text = tipMes;
    [tipsLB sizeToFit];
    
    [self refreshOnView:baseView];
}


//无数据
+ (void)show_errorView_when_nodata_onView:(UIView *)baseView
{
    ErrorTipsView *errorView = (ErrorTipsView *)[baseView viewWithTag:10010];
    if(!errorView)
    {
        errorView = [ErrorTipsView initFromNib];//[[self class] shareInstance];
    }
    
    [errorView showError_tips_when_nodata_onView:baseView];
}
#pragma mark ======  private  ======
- (void)refreshOnView:(UIView *)baseView
{
    if(!self.superview)
    {
        [baseView addSubview:self];
    }
    self.frame = baseView.bounds;
//    CGPoint center = [[CommonHelper getAppWindow] convertPoint:[CommonHelper getAppWindow].center toView:baseView];
//    SLog(@"%@---------------%@",NSStringFromCGPoint(center),NSStringFromCGPoint(baseView.center));
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(baseView);
//        make.top.equalTo(baseView);
//        make.height.equalTo(baseView);
//        make.width.equalTo(baseView);
//    }];
//    [tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(304);
//        make.height.mas_equalTo(290);
//        make.left.mas_equalTo(center.x - 304*.5);
//        make.top.mas_equalTo(center.y - 290*.5);
//    }];
}
//nodata
- (void)showError_tips_when_nodata_onView:(UIView *)baseView
{
    tips_literal_imgView.hidden = YES;
    self.refreshBlock = nil;
    
    tipsLB.text = @"精彩内容,敬请期待...";
    [tipsLB sizeToFit];
    
    [self refreshOnView:baseView];
}
//bad net
- (void)showError_tips_when_badnet_onView:(UIView *)baseView refresh:(RefreshBlock)block
{
    tips_literal_imgView.hidden = NO;
    self.refreshBlock = block;
    
    tipsLB.text = @"系统出错了...";
    [tipsLB sizeToFit];
    
    [self refreshOnView:baseView];
}
//no net
- (void)showError_tips_when_nonet_onView:(UIView *)baseView refresh:(RefreshBlock)block
{
    tips_literal_imgView.hidden = NO;
    self.refreshBlock = block;
    
    tipsLB.text = @"请检查网络状态...";
    [tipsLB sizeToFit];
    
   [self refreshOnView:baseView];
}


//yu
//no goods
+ (void)showError_tips_when_nogoods_onView:(UIView *)baseView TipMessage:(NSString *)message
{
    ErrorTipsView *errorView = (ErrorTipsView *)[baseView viewWithTag:10010];
    if(!errorView)
    {
        errorView = [ErrorTipsView initFromNib];//[[self class] shareInstance];
    }
    [errorView showError_tips_when_nogoods_onView:baseView TipMsg:message];
}
//no goods
- (void)showError_tips_when_nogoods_onView:(UIView *)baseView TipMsg:message
{
    tips_imgView.image=[UIImage imageNamed:@"myshop_nogoods"];
    tips_literal_imgView.hidden = YES;
    addBtn.hidden=NO;
    tipsLB.text = message;
    [tipsLB sizeToFit];
    [self refreshOnView:baseView];
}




//shopcart no goods
+ (void)showError_tips_when_shopcartnogoods_onView:(UIView *)baseView TipMessage:(NSString *)message
{
    ErrorTipsView *errorView = (ErrorTipsView *)[baseView viewWithTag:10010];
    if(!errorView)
    {
        errorView = [ErrorTipsView initFromNib];//[[self class] shareInstance];
    }
    [errorView showError_tips_when_shopcartnogoods_onView:baseView TipMsg:message];
}
//shopcart no goods
- (void)showError_tips_when_shopcartnogoods_onView:(UIView *)baseView TipMsg:message
{
    tips_imgView.image=[UIImage imageNamed:@"brand_shopcart"];
    tips_literal_imgView.hidden = YES;
    addBtn.hidden=NO;
    tipsLB.text = message;
    tipsLB.numberOfLines=0;
    [tipsLB sizeToFit];
    [self refreshOnView:baseView];
}



#pragma mark ======  dis  ======
+ (instancetype)shareInstance
{
    static ErrorTipsView *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance =  [[[NSBundle mainBundle] loadNibNamed:@"ErrorTipsView" owner:nil options:nil] firstObject];
        
        [sharedInstance initial];
        
    });
    return sharedInstance;
}
+ (void)hideError_view
{
    ErrorTipsView *errorView = [[self class] shareInstance];
    if(errorView.superview)
    {
        [errorView removeFromSuperview];
    }
}
@end
