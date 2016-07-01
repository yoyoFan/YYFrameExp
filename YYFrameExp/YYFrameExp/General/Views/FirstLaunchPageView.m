//
//  FirstStartPageView.m
//  newAdmite
//
//  Created by fwr on 15/3/30.
//  Copyright (c) 2015年 fwr. All rights reserved.
//

#import "FirstLaunchPageView.h"
#import "CommonUtil.h"

#define PAGE_NUM 4

#define PageWidth  APP_SCREEN_WIDTH

@interface FirstLaunchPageView()
{
    UIView *launchView1;
    UIImageView *imgBg1;
    
    UIView *launchView2;
    UIImageView *imgBg2;
    
    UIView *launchView3;
    UIImageView *imgBg3;
    double angleSun;
    UIImageView *imgSun;
    UIImageView *imgYun;
    
    NSTimer *lauchTimer1;
    
    UIImageView *maskView_;
}

@end

@implementation FirstLaunchPageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (void)addLaunchImageAsMask{
    NSString *launchImage;
    BOOL isIos7 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
    //BOOL isIos8 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
    float screenHeight = APP_SCREEN_HEIGHT;
    
    if (screenHeight > 667.0) { // iPhone6+
        launchImage = @"LaunchImage-800-Portrait-736h";
    }
    else if (screenHeight > 568.0){ // iPhone6
        launchImage = @"LaunchImage-800-667h";
    }
    else if (screenHeight > 480.0){ //iPhone5
        if (isIos7) {
            launchImage = @"LaunchImage-700-568h";
        }
        else{
            launchImage = @"LaunchImage-568h";
        }
    }
    else{ // iPhone4
        if (isIos7) {
            launchImage = @"LaunchImage-700";
        }
        else{
            launchImage = @"LaunchImage";
        }
    }
    
    maskView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    if (!isIos7) {
        [maskView_ setFrame:CGRectMake(0, -20, maskView_.width, maskView_.height)];
    }
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake((maskView_.width-activityView.width)/2, (maskView_.height-activityView.height)/2, activityView.width, activityView.height);
    [maskView_ addSubview:activityView];
    [activityView startAnimating];
    self.userInteractionEnabled = NO;
    [self addSubview:maskView_];
}


- (void)LoadLaunchBgImg
{
    [self addToWindowAnimated:YES];
    [self LoadFirst];
    
//    static BOOL loaded = NO;
//    if (!loaded) {
//        
// //        [self addLaunchImageAsMask];
//        
//        //请求Web数据
//        
//        
//        
////        //请求成功以后 移除这个覆盖层
////        [maskView_ removeFromSuperview];
////         maskView_ = nil;
//        
//        
//        loaded = YES;
//    }
    
}


//查找启动图片
-(NSString *)LaunchImgNameWithPageNum:(NSInteger)num
{
    NSString *launchImage;
    float screenHeight = APP_SCREEN_HEIGHT;
    
    NSString *iphoneStr;
    NSString *PageNumStr;
    
    if (screenHeight > 667.0) { // iPhone6+
        iphoneStr = @"i6s";
    }
    else if (screenHeight > 568.0){ // iPhone6
        iphoneStr = @"i6";
    }
    else if (screenHeight > 480.0){ //iPhone5
       iphoneStr = @"i5";
    }
    else{ // iPhone4
     iphoneStr = @"i4";
    }
    
    switch (num) {
        case 1:
        {
            PageNumStr = @"launchOneBg";
        }break;
        case 2:
        {
            PageNumStr = @"launchTwoBg";
        }break;
        case 3:
        {
            PageNumStr = @"launchTreeBg";
            
        }break;
        default:
            break;
    }
    launchImage = [NSString stringWithFormat:@"%@_%@",PageNumStr,iphoneStr];
    return launchImage;
}


+ (FirstLaunchPageView *)sharedInstance
{
    static FirstLaunchPageView *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance =  [[[NSBundle mainBundle] loadNibNamed:@"FirstLaunchPageView" owner:nil options:nil] firstObject];

        CGFloat height;
        if ([CommonUtil SystemVersion]<7) {
            height=APP_SCREEN_CONTENT_HEIGHT;
        }
        else{
            height=APP_SCREEN_HEIGHT;
        }
        
        sharedInstance.frame = CGRectMake(0, 0, PageWidth, height);
        sharedInstance.backgroundColor = [UIColor clearColor];
        sharedInstance.pageCtl.numberOfPages = PAGE_NUM;
        sharedInstance.pageCtl.currentPage = 0;
        sharedInstance.pageCtl.pageIndicatorTintColor =[UIColor grayColor];
        sharedInstance.pageCtl.currentPageIndicatorTintColor = ColorC7;
        
        sharedInstance.backScrollView.clipsToBounds=YES;
        sharedInstance.backScrollView.showsHorizontalScrollIndicator = NO;
        sharedInstance.backScrollView.showsVerticalScrollIndicator = NO;
        sharedInstance.backScrollView.bounds=CGRectMake(0, 0, PageWidth, height);
        sharedInstance.backScrollView.center=sharedInstance.center;
        sharedInstance.backScrollView.contentSize = CGSizeMake(PAGE_NUM*PageWidth, 0);
        sharedInstance.backScrollView.userInteractionEnabled = YES;
        [sharedInstance.backScrollView setDelaysContentTouches:NO];
        sharedInstance.backScrollView.pagingEnabled = YES;
        sharedInstance.backScrollView.delegate = sharedInstance;
        
    });
    return sharedInstance;
}



#pragma mark    --------刷新Cell
- (void)LoadFirst
{
    CGFloat PageHeight;
    if ([CommonUtil SystemVersion]<7) {
        PageHeight=APP_SCREEN_CONTENT_HEIGHT;
    }
    else{
        PageHeight=APP_SCREEN_HEIGHT;
    }
    
    CGFloat imgWidth = PageWidth;
    CGFloat imgHeight = PageHeight;
    
    //第一页
    launchView1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, PageWidth, PageHeight)];
    imgBg1=[[UIImageView alloc] initWithFrame:CGRectMake(0 ,0,imgWidth,imgHeight)];
    imgBg1.image = [UIImage imageNamed:[self LaunchImgNameWithPageNum:1]];
    [launchView1 addSubview:imgBg1];
    [_backScrollView addSubview:launchView1];
    
    //第二页
    launchView2 = [[UIView alloc] initWithFrame:CGRectMake(PageWidth,0, PageWidth,PageHeight)];
    imgBg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0,imgWidth,imgHeight)];
    imgBg2.image = [UIImage imageNamed:[self LaunchImgNameWithPageNum:2]];
    [launchView2 addSubview:imgBg2];
    [_backScrollView addSubview:launchView2];
    
    //第三页
    launchView3 = [[UIView alloc] initWithFrame:CGRectMake(PageWidth*2, 0, PageWidth, PageHeight)];
    imgBg3 = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0,imgWidth,imgHeight)];
    imgBg3.image = [UIImage imageNamed:[self LaunchImgNameWithPageNum:3]];
    [launchView3 addSubview:imgBg3];
    [_backScrollView addSubview:launchView3];
    
    
    //最后一页
    UIImageView *lastBg =[[UIImageView alloc] initWithFrame:CGRectMake(PageWidth*3, 0,PageWidth, PageHeight)];
    lastBg.image =[UIImage imageNamed:@"LaunchlastBg"];
    [_backScrollView addSubview:lastBg];
    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake((PageWidth - 215)/2 + PageWidth*3, PageHeight*3.7/5, 215, 40);
    [btn1 setBackgroundImage:[UIImage imageNamed: @"launchLastBtn2"] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed: @"launchLastBtn2_d"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(clickZhuCeBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"注册领流量" forState:UIControlStateNormal];
    [btn1 setTitle:@"注册领流量" forState:UIControlStateHighlighted];
    [btn1 setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_backScrollView addSubview:btn1];
    
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame =  CGRectMake((PageWidth - 215)/2 + PageWidth*3, PageHeight*3.7/5 + 50,215, 40);
    [btn2 setBackgroundImage:[UIImage imageNamed: @"launchLastBtn1"] forState:UIControlStateNormal];
     [btn2 setBackgroundImage:[UIImage imageNamed: @"launchLastBtn1"] forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(clickScanBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"随便逛逛" forState:UIControlStateNormal];
    [btn2 setTitle:@"随便逛逛" forState:UIControlStateHighlighted];
    [btn2 setTitleColor:ColorC7 forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_backScrollView addSubview:btn2];
 }


//注册
-(void)clickZhuCeBtn
{
    [self close];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FirstLaunchJumpNotification" object:nil userInfo:nil];
}

//随便看看
-(void)clickScanBtn
{
    [self close];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FirstLaunchLookAroundNotification" object:nil userInfo:nil];
}


-(void)TapLaunchBtn:(UIGestureRecognizer *)tap
{
    [self close];
}

-(void)timerFired:(NSTimer *)time
{
    [UIView animateWithDuration:2.5 animations:
     ^(void){
         CGRect frame = imgBg1.frame;
         frame.origin.x = imgBg1.frame.origin.x + 20;
         imgBg1.frame = frame;
         
     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:2.5 animations:^{
             CGRect frame = imgBg1.frame;
             frame.origin.x = imgBg1.frame.origin.x - 20;
             imgBg1.frame = frame;
         }];
     }];
}


-(void)addTitleTip:(NSInteger)currentPage
{
    UIView *img1 = [self viewWithTag :11111];
    [img1 removeFromSuperview];
    
    UIView *img2 = [self viewWithTag :22222];
    [img2 removeFromSuperview];
    
    float spaceCenter1;
    float spaceCenter2;
    
    //iphone 5
    float tip1Img1_w = 175;
    float tip1Img1_h = 35;
     //iphone 6
    float tip1Img2_w = 207;
    float tip1Img2_h = 41;

     //iphone 5
    float tip2Img1_w=171;
    float tip2Img1_h = 18;
    //iphone 6
    float tip2Img2_w=204;
    float tip2Img2_h = 21;
    
    
    if(IS_IPhone6)
    {
       spaceCenter1=PageWidth/2 - 207/2;
       spaceCenter2=PageWidth/2 - 204/2;
    }
    else
    {
       spaceCenter1=PageWidth/2 - 175/2;
       spaceCenter2=PageWidth/2 - 171/2;
    }
    
    float top1= 30;
    float top2= 80;
    
    UIImageView *imgTip1;
    if(IS_IPhone6)
    {
         imgTip1 = [[UIImageView alloc] initWithFrame:CGRectMake(currentPage*PageWidth + tip1Img2_w + spaceCenter1, top1, tip1Img2_w, tip1Img2_h)];
         imgTip1.image = [UIImage imageNamed:[NSString stringWithFormat:@"LaunchOneTip%d_2",currentPage+1]];
    }
    else
    {
         imgTip1 = [[UIImageView alloc] initWithFrame:CGRectMake(currentPage*PageWidth + tip1Img1_w + spaceCenter1, top1, tip1Img1_w, tip1Img1_h)];

        imgTip1.image = [UIImage imageNamed:[NSString stringWithFormat:@"LaunchOneTip%d",currentPage+1]];
    }
    imgTip1.tag = 11111;
    [_backScrollView addSubview:imgTip1];
    
    UIImageView *imgTip2;
    if(IS_IPhone6)
    {
        imgTip2=[[UIImageView alloc] initWithFrame:CGRectMake(currentPage*PageWidth - tip2Img2_w, top2, tip2Img2_w, tip2Img2_h)];
        imgTip2.image = [UIImage imageNamed:[NSString stringWithFormat:@"LaunchTwoTip%d_2",currentPage+1]];
    }
    else
    {
        imgTip2=[[UIImageView alloc] initWithFrame:CGRectMake(currentPage*PageWidth - tip2Img1_w, top2, tip2Img1_w, tip2Img1_h)];
        imgTip2.image = [UIImage imageNamed:[NSString stringWithFormat:@"LaunchTwoTip%d",currentPage+1]];
    }
    imgTip2.tag = 22222;
    [_backScrollView addSubview:imgTip2];
    
    [UIView animateWithDuration:0.4 animations:
     ^(void){
         
         CGRect frame = imgTip1.frame;
         if(IS_IPhone6)
         {
            frame.origin.x = imgTip1.frame.origin.x - tip1Img2_w;
         }
         else
         {
             frame.origin.x = imgTip1.frame.origin.x - tip1Img1_w;
         }
         imgTip1.frame = frame;
         
     } completion:^(BOOL finished){
         
         [UIView animateWithDuration:0.4 animations:^{
             CGRect frame = imgTip2.frame;
             if(IS_IPhone6)
             {
                frame.origin.x = imgTip2.frame.origin.x + tip2Img2_w + spaceCenter2;
             }
             else
             {
                 frame.origin.x = imgTip2.frame.origin.x + tip2Img1_w + spaceCenter2;
             }
             imgTip2.frame = frame;
         }];
     }];
}

-(void) startAnimationSun
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimationYun)];
    imgSun.transform = CGAffineTransformMakeRotation(angleSun * (M_PI / -180.0f));
    [UIView commitAnimations];
}

-(void)endAnimationYun
{
    angleSun += 3*2;
    [self startAnimationSun];
}

-(void)startYunMove
{
    [UIView animateWithDuration:2.5 animations:
     ^(void){
         CGRect frame = imgYun.frame;
         frame.origin.x = imgYun.frame.origin.x + 20;
         imgYun.frame = frame;
         
     } completion:^(BOOL finished){//do other thing
         [self endYunMove];
     }];
}

-(void)endYunMove
{
    [UIView animateWithDuration:2.5 animations:
     ^(void){
         CGRect frame = imgYun.frame;
         frame.origin.x = imgYun.frame.origin.x - 20;
         imgYun.frame = frame;
         
     } completion:^(BOOL finished){//do other thing
         [self startYunMove];
     }];

}


- (void)addToWindowAnimated:(BOOL)animated
{
    CGFloat top=.0f;
    if([CommonUtil SystemVersion]<7)
    {
        top=20.0f;
    }
    UIWindow * window = [self getAppWindow];//view层级关系不一样，应具体问题具体分析
    if (animated)
    {
        self.frame = CGRectMake(APP_SCREEN_WIDTH, top, APP_SCREEN_WIDTH, self.height);
        [window addSubview:self];
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, top, APP_SCREEN_WIDTH, self.height);
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        self.frame = CGRectMake(APP_SCREEN_WIDTH, top, APP_SCREEN_WIDTH, self.height);
        [window addSubview:self];
    }
    [window bringSubviewToFront:self];
}


- (UIWindow *)getAppWindow
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}


- (void)setPageControlHidden:(BOOL)hidden{
    self.pageCtl.hidden = hidden;
}

#pragma mark --- UIScrollView Delegate ---
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    if (page == PAGE_NUM)//最后一页时
    {
        [self close];
    }
    else
    {
        if(page == PAGE_NUM - 1)
        {
            [_pageCtl setHidden:YES];
        }
        else
        {
            [_pageCtl setHidden:NO];
        }
        [_pageCtl setCurrentPage:page];
    }
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    float Progress = scrollView.contentOffset.x / scrollView.bounds.size.width;
//    if(Progress < 1 )
//    {
//        launchView1.layer.opacity =1- Progress;
//        launchView2.layer.opacity =Progress;
//    }
//    else if (Progress >=1 && Progress < 2)
//    {
//        Progress = Progress-1;
//        launchView1.layer.opacity = 1;
//        launchView2.layer.opacity =1- Progress;
//        launchView3.layer.opacity = Progress;
//    }
//    else
//    {
//         _pageCtl.layer.opacity = 1- Progress;
//        launchView2.layer.opacity = 1;
//        launchView3.layer.opacity = 1;
//    }
//}

//移除本view
- (void)removeFromWindow
{
    [lauchTimer1 invalidate];
    [self removeFromSuperview];
}

- (void)close{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [launchView1 removeFromSuperview];
            [launchView2 removeFromSuperview];
            [launchView3 removeFromSuperview];
            [self removeFromWindow];
            self.alpha = 1.0;
        }];
    });
}

@end
