//
//  MyAdViewWrapper.h
//  FlowExp
//
//  Created by Dongle Su on 14-7-3.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AdViewPage.h"
#import "ProjectStructDef.h"

@class MyAdViewWrapper;
@protocol MyAdViewWrapperDelegate <NSObject>

- (void)MyAdViewWrapper:(MyAdViewWrapper *)wrapper adClicked:(NSInteger )index;

@end
@interface MyAdViewWrapper : NSObject<AdViewPageDelegate>
@property (nonatomic, strong) AdViewPage *adViewPage;
//@property (nonatomic, strong) id customPageControl;
@property (nonatomic, weak) UIViewController *baseController;
@property(nonatomic, assign) AdPlaceType placeType;

@property (weak,nonatomic)id<MyAdViewWrapperDelegate>delegate;

- (void)setAdInfoArray:(NSArray *)adsArray;
- (void)stop;
@end
