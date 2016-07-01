//
//  SharePopupView.m
//  FlowExp
//
//  Created by Dongle Su on 14-5-8.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "SharePopupView.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Graphic.h"
#import "UIView+Common.h"
#import "HairlineView.h"
#import "Tip.h"

#define kContentheight 282
#define kCopyTextHeight 46
#define kAnimateDuaration 0.3

typedef void(^SocialButtonClickedBlockType)(SharePopupView * popupView, int index);

@implementation SharePopupView{
    UIPageControl *pageControl_;
    UIView *contentView_;
    UIView *blurView_;
    NSString *title_;
    NSString *aCopyText_;
    SocialButtonClickedBlockType socialButtonClicked_;
}

+ (SharePopupView *)popupInView:(UIView *)view
                          title:(NSString *)title
                     socialList:(NSArray *)socialList
            socailButtonClicked:(void(^)(SharePopupView * popupView, int index))onClicked{
    SharePopupView *instance = [[SharePopupView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    instance->socialButtonClicked_ = onClicked;
    instance->title_ = title;
    [instance initContentViewWithSocialList:socialList backView:view];
    
    [instance appearInView:view];
    return instance;
}

+ (SharePopupView *)popupInView:(UIView *)view
                          title:(NSString *)title
                       copyText:(NSString *)aCopyText
                     socialList:(NSArray *)socialList
            socailButtonClicked:(void(^)(SharePopupView * popupView, int index))onClicked{
    SharePopupView *instance = [[SharePopupView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    instance->socialButtonClicked_ = onClicked;
    instance->title_ = title;
    instance->aCopyText_ = aCopyText;
    [instance initContentViewWithSocialList:socialList copyText:aCopyText backView:view];
    
    [instance appearInView:view];
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClicked)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)initContentViewWithSocialList:(NSArray*)socialList backView:(UIView *)backView{
    CGFloat y;
    if([backView viewController].tabBarController.tabBar.translucent){
        y = self.bottom - kContentheight - [backView viewController].tabBarController.tabBar.height;
    }
    else{
        y = self.bottom - kContentheight;
    }
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.width, kContentheight)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
    //blur,title, button, page control
    //blurView_ = [self addBlurOfbackView:backView onView:contentView];
    
    [self addTitle:title_ onView:contentView];
    [self addButtonsOfSocialList:socialList onView:contentView];
    [self initPageControl];
    
    //cancel button
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setBackgroundImage:[UIImage imageNamed:@"sharePopupCancel"] forState:UIControlStateNormal];
    [bt setBackgroundImage:[UIImage imageNamed:@"sharePopupCancel_d"] forState:UIControlStateHighlighted];
    [bt sizeToFit];
    [bt setFrame:CGRectMake((self.width-bt.width)/2, 230, bt.width, bt.height)];
    [bt addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview:bt];
    contentView_ = contentView;
}

- (void)initContentViewWithSocialList:(NSArray*)socialList copyText:(NSString *)aCopyText backView:(UIView *)backView{
    CGFloat y;
    if([backView viewController].tabBarController.tabBar.translucent){
        y = self.bottom - kContentheight - [backView viewController].tabBarController.tabBar.height;
    }
    else{
        y = self.bottom - kContentheight;
    }
    CGFloat copyTextHeight = [aCopyText length]?kCopyTextHeight:0;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, y-copyTextHeight, self.width, kContentheight+copyTextHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
    //blur,title, button, page control
    //blurView_ = [self addBlurOfbackView:backView onView:contentView];
    
    [self addTitle:title_ onView:contentView];
    [self addButtonsOfSocialList:socialList onView:contentView];
    [self initPageControl];
    
    CGRect rc = CGRectMake((self.width-270)/2, 230.0f, 270, 40);
    // copy button
    if ([aCopyText length]) {
        UIButton *cpBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [cpBt setBackgroundImage:[UIImage imageNamed:@"orangeButton215"] forState:UIControlStateNormal];
        [cpBt setBackgroundImage:[UIImage imageNamed:@"orangeButton_d215"] forState:UIControlStateHighlighted];
        [cpBt setTitle:@"复制内容" forState:UIControlStateNormal];
        [cpBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cpBt sizeToFit];
        [cpBt setFrame:rc];
        [cpBt addTarget:self action:@selector(copyTaped:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cpBt];
    }

    //cancel button
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
    //[bt setBackgroundImage:[UIImage imageNamed:@"sharePopupCancel"] forState:UIControlStateNormal];
    //[bt setBackgroundImage:[UIImage imageNamed:@"sharePopupCancel_d"] forState:UIControlStateHighlighted];
    //[bt sizeToFit];
    //    CGRect rc = CGRectMake((self.width-270)/2, 230.0f+copyTextHeight, 270, 40);
    rc = CGRectMake(0, contentView.height-50, self.width, 50);
    [bt setBackgroundColor:MAIN_BACK_GROUND_COLOR];
    [bt setTitleColor:ColorC5 forState:UIControlStateNormal];
    [bt setTitle:@"取消" forState:UIControlStateNormal];
    [bt setFrame:rc];
    [bt addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview:bt];
    contentView_ = contentView;
}

- (UIView *)addBlurOfbackView:(UIView *)backView onView:(UIView *)contentView{
    UIImage *screenshot = [backView screenshot];
    UIImage *blur = [screenshot applyLightEffect];
    _bluredBackground = blur;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:blur];
    imageView.contentMode = UIViewContentModeBottom;
    [contentView addSubview:imageView];
    return imageView;
}
- (void)addTitle:(NSString *)title onView:(UIView *)contentView{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:titleLabel];
    
    HairlineView *hairline = [[HairlineView alloc] initWithFrame:CGRectMake(15, 40, self.width-30, 1)];
    hairline.backgroundColor = BORDER_COLOR;
    [contentView addSubview:hairline];
}

- (void)addButtonsOfSocialList:(NSArray*)socialList onView:(UIView *)contentView{
    UIScrollView *scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, self.width, 188)];
    scollView.showsHorizontalScrollIndicator = NO;
    scollView.delegate = self;
    
    float imageWidth = 45;
    float imageHeight = 45;
    float labelWidth = 85;
    float labelHeight = 14;
    
    float imageStartX = 25;
    float imageStartY = 10;
    float spaceX = (APP_SCREEN_WIDTH-2*imageStartX-4*imageWidth)/3+imageWidth;
    float spaceY = 88;
    float labelStartX = imageStartX+imageWidth/2 - labelWidth/2;
    float labelStartY = imageStartY+imageHeight+5;
    
    for (int i = 0; i<socialList.count; i++) {
        NSString *socialType = [socialList objectAtIndex:i];
        int row = i%8/4;
        int col = i%4;
        float pageStart = i/8 * self.width;
        
        float imageX = imageStartX + spaceX*col + pageStart;
        float imageY = imageStartY + spaceY*row;
        float labelX = labelStartX + spaceX*col + pageStart;
        float labelY = labelStartY + spaceY*row;
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setBackgroundImage:[self imageWithType:socialType isPress:NO] forState:UIControlStateNormal];
        //[bt setBackgroundImage:[self imageWithType:socialType isPress:YES] forState:UIControlStateHighlighted];
        [bt setFrame:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
        bt.tag = i;
        [bt addTarget:self action:@selector(socialButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scollView addSubview:bt];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.text = socialType;
        label.backgroundColor = [UIColor clearColor];
        [scollView addSubview:label];
    }
    
    NSInteger pageCount = (socialList.count+7)/8;
    scollView.contentSize = CGSizeMake(pageCount*self.width, 183);
    scollView.pagingEnabled = YES;
    [contentView addSubview:scollView];
    
    [self setupPageControlWithScrollView:scollView onView:contentView PageCount:pageCount];
}

- (UIImage *)imageWithType:(NSString*)typeName isPress:(BOOL)isPress{
    NSString *imageName;
    if ([typeName isEqualToString:@"新浪微博"]) {
        imageName = @"inviteInputWeibo";
    }
    else if ([typeName isEqualToString:@"腾讯微博"]){
        imageName = @"inviteInputTweibo";
    }
    else if ([typeName isEqualToString:@"人人网"]){
        imageName = @"inviteInputRenren";
    }
    else if ([typeName isEqualToString:@"微信好友"]){
        imageName = @"inviteInputWeixin";
    }
    else if ([typeName isEqualToString:@"微信朋友圈"]){
        imageName = @"inviteInputWeixinFriends";
    }
    else if ([typeName isEqualToString:@"QQ空间"]){
        imageName = @"inviteInputQzone";
    }
    else if ([typeName isEqualToString:@"QQ好友"]){
        imageName = @"inviteInputQQ";
    }
    else if ([typeName isEqualToString:@"短信"]){
        imageName = @"inviteInputSms";
    }
    else if ([typeName isEqualToString:@"好友动态"]){
        imageName = @"inviteInputFriendDynamic";
    }

    if (isPress) {
        imageName = [imageName stringByAppendingString:@"_d"];
    }
    
    return [UIImage imageNamed:imageName];
}

- (void)initPageControl{
    pageControl_ = [[UIPageControl alloc] initWithFrame:CGRectMake(200, 30, 50, 20)];
    pageControl_.userInteractionEnabled = NO;
    pageControl_.numberOfPages = 1;
    pageControl_.currentPage = 0;
    pageControl_.pageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
    pageControl_.currentPageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
}

- (void)setupPageControlWithScrollView:(UIScrollView *)scrollView onView:(UIView *)view PageCount:(int)pageCount{
    CGSize size = [pageControl_ sizeForNumberOfPages:pageCount];
    CGRect rect = CGRectMake((scrollView.width-size.width)/2, scrollView.height-size.height+20, size.width, size.height);
    rect = [view convertRect:rect fromView:scrollView];
    pageControl_.frame = rect;
    pageControl_.numberOfPages = pageCount;
    pageControl_.currentPage = 0;
    pageControl_.hidesForSinglePage = YES;
    
    [view addSubview:pageControl_];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = (scrollView.contentOffset.x+0.9)/self.width;
    pageControl_.currentPage = page;
}

- (void)appearInView:(UIView *)view{
    int y = contentView_.top;
    contentView_.frame = CGRectMake(0, self.bottom, contentView_.width, contentView_.height);
    blurView_.frame = CGRectMake(0, -blurView_.height, blurView_.width, blurView_.height);
    self.backgroundColor = [UIColor clearColor];
    
    [view addSubview:self];
    
    
    [UIView animateWithDuration:kAnimateDuaration animations:^{
        contentView_.frame = CGRectMake(0, y, contentView_.width, contentView_.height);
        blurView_.frame = CGRectMake(0, contentView_.height-blurView_.height, blurView_.width, blurView_.height);
        self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
    } completion:^(BOOL finished) {
        
    }];

}

- (void)disappearToLeftWithComplete:(void (^)())block{
    [UIView animateWithDuration:kAnimateDuaration animations:^{
        //contentView_.frame = CGRectMake(-contentView_.width, y, contentView_.width, contentView_.height);
        self.frame = CGRectMake(-self.width, 0, self.width, self.height);
        blurView_.frame = CGRectMake(contentView_.width, contentView_.height-blurView_.height, blurView_.width, blurView_.height);
        //self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (block) {
            block();
        }
    }];

}
- (void)disappearWithComplete:(void(^)())block{
    [UIView animateWithDuration:kAnimateDuaration animations:^{
        contentView_.frame = CGRectMake(0, self.bottom, contentView_.width, contentView_.height);
        blurView_.frame = CGRectMake(0, -blurView_.height, blurView_.width, blurView_.height);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (block) {
            block();
        }
    }];

}
- (void)backgroundClicked{
    [self disappearWithComplete:nil];
}

- (void)cancelClicked:(UIButton *)sender{
    [self disappearWithComplete:nil];
}

- (void)copyTaped:(UIButton *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = aCopyText_;
    [self disappearWithComplete:^{
        [Tip tipSuccess:@"复制成功" OnView:nil];
    }];
}
- (void)socialButtonClicked:(UIButton *)sender{
    //[self disappearWithComplete:^{
        if (socialButtonClicked_) {
            socialButtonClicked_(self, sender.tag);
        }
    //}];
}
@end
