//
//  MyAdViewWrapper.m
//  FlowExp
//
//  Created by Dongle Su on 14-7-3.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "MyAdViewWrapper.h"
#import "ResponseTypeDef.h"
#import "UIImageView+AFNetworking.h"
#import "WebService.h"
#import "BaseViewController.h"
#import "SMPageControl.h"

@implementation MyAdViewWrapper{
    NSArray *adsArray_;
    UIView *adBannerView_;
    SMPageControl *smPageControl_;
}
- (void)setAdViewPage:(AdViewPage *)adViewPage{
    _adViewPage = adViewPage;
    _adViewPage.delegate = self;
    
    adBannerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, _adViewPage.height-10,  APP_SCREEN_WIDTH, 10)];
    adBannerView_.backgroundColor = [UIColor clearColor];//[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:adBannerView_.bounds andColors:@[[UIColor colorWithWhite:0 alpha:0],[UIColor colorWithWhite:0 alpha:0.0],[UIColor colorWithWhite:0 alpha:0.0],[UIColor colorWithWhite:0 alpha:0.0],[UIColor colorWithWhite:0 alpha:0.1],[UIColor colorWithWhite:0 alpha:0.2],[UIColor colorWithWhite:0 alpha:0.5],[UIColor colorWithWhite:0 alpha:0.6]]];
    adBannerView_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_adViewPage addSubview:adBannerView_];
    
    //    NSDictionary *viewsDictionary =
    //    NSDictionaryOfVariableBindings(adBannerView, _adViewPage);
    //    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[adBannerView]|"
    //                                                                   options:0 metrics:nil views:viewsDictionary];
    //    [_tableHeaderView addConstraints:constraints];
    //    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[adBannerView(==10)]"
    //                                                                   options:0 metrics:nil views:viewsDictionary];
    //    [_tableHeaderView addConstraints:constraints];
    //
    //    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:adBannerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_adViewPage attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0];
    //    constraint.priority = 900;
    //    [_tableHeaderView addConstraint:constraint];
    
    smPageControl_ = [[SMPageControl alloc] initWithFrame:CGRectMake(15, 0, adBannerView_.width-30, adBannerView_.height)];
    smPageControl_.alignment = SMPageControlAlignmentRight;
    [smPageControl_ setPageIndicatorImage:[UIImage imageNamed:@"pageCtlgrayDot.png"]];
    [smPageControl_ setCurrentPageIndicatorImage:[UIImage imageNamed:@"pageCtlredDot.png"]];
    [adBannerView_ addSubview:smPageControl_];
    
    adViewPage.hidePageCtl = YES;
    //self.customPageControl = smPageControl;
}
- (void)setAdInfoArray:(NSArray *)adsArray{
    adsArray_ = adsArray;
    
    NSMutableArray *urlAry = [NSMutableArray array];
    [adsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SingleAdInfo *adInfo = obj;
        [urlAry addObject:adInfo.iconPath];
    }];
    
    if (self.adViewPage) {
        switch (self.placeType) {
            case AdPlaceTypeHomeBanner: //首页广告
            {
                self.adViewPage.placeHolderImageName = PlaceHolder_Ad_HomeIMG;
            } break;
            case AdPlaceTypeFlowCharge:
            {
                self.adViewPage.placeHolderImageName = PlaceHolder_Ad_FlowMainIMG;
            } break;
            case AdPlaceTypeFlowCard:
            {
                self.adViewPage.placeHolderImageName = PlaceHolder_Ad_FlowMainIMG;
            }break;
            default:
                self.adViewPage.placeHolderImageName = PlaceHolder_Ad_FlowMainIMG;
                break;
        }
       
        [self.adViewPage setAdImagesWithURLs:urlAry];
        if (urlAry.count > 1) {
            [self.adViewPage start];
        }
    }
}
- (id)pageControl{
    //return self.customPageControl;
    return smPageControl_;
}
- (void)AdPressedAtIndex:(NSInteger)index{
    SingleAdInfo *adInfo = [adsArray_ objectAtIndex:index];
    
    //埋点
    NSDictionary *dict = @{@"nameId": [NSString stringWithFormat:@"%d",adInfo.id],@"place":[NSString stringWithFormat:@"%ld",_placeType]};
    //[UMengHelper uMengEventId:@"mainPageFocusTapEID" attributes:dict];
    
    if ([self.baseController isKindOfClass:[BaseViewController class]]) {
        [(BaseViewController *)self.baseController goPageId:adInfo.pageType.pageType paramStr:adInfo.pageType.openValue];
    }
    if([self.delegate respondsToSelector:@selector(MyAdViewWrapper:adClicked:)])
    {
        [_delegate MyAdViewWrapper:self adClicked:index];
    }
    ProjectUtil *util=[ProjectUtil sharedInstance];
//    if(adInfo.openType==3)
//    {
//        util.backgroundTask=UIBackgroundTaskInvalid;
//        util.backgroundTask=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//            SLog(@"Background handler called. Not running background tasks anymore.");
//            [[UIApplication sharedApplication] endBackgroundTask:[ProjectUtil sharedInstance].backgroundTask];
//            [ProjectUtil sharedInstance].backgroundTask = UIBackgroundTaskInvalid;
//        }];
//    }
//    else
//    {
//        util.backgroundTask=UIBackgroundTaskInvalid;
//    }
//    [[WebService sharedInstance] asyncSaveClickAdType:AdTypeSelf place:self.placeType adId:adInfo.id openType:[NSString stringWithFormat:@"%d",adInfo.openType] success:^{
//    } failure:^(NSError *error) {
//    }];
    
    UIImage *image = [[UIImageView sharedImageCache] cachedImageForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:adInfo.iconPath]]];
    
    //[ProjectUtil jumpFromAdViewWithType:adInfo.openType openUrl:adInfo.url clientRedirectType:adInfo.clientRedirect objId:adInfo.objId baseViewCtl:self.baseController shareImage:image title:adInfo.title];
}
- (void)stop
{
    [_adViewPage stop];
}
@end
