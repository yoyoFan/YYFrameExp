//
//  AdViewPage.h
//  FlowExp
//
//  Created by fwr on 14-7-1.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdViewPageDelegate <NSObject>
@optional
- (id)pageControl;
-(void)AdPressedAtIndex:(NSInteger) index;

@end

@interface AdViewPage : UIView<UIScrollViewDelegate>
{
    
}

@property(nonatomic,weak)id<AdViewPageDelegate> delegate;
@property(nonatomic,assign) float MoveIntervalTime;
@property(nonatomic,strong) NSString *placeHolderImageName;

@property (nonatomic,assign)BOOL hidePageCtl;

//添加的广告资源为URLArray
- (void)setAdImagesWithURLs:(NSArray *)array;
//添加的广告资源为ImagesArray
- (void)setAdImages:(NSArray *)adArray;
- (void)start;
- (void)stop;
@end