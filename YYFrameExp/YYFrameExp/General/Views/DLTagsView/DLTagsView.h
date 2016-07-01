//
//  DLTagsView.h
//  tagViewTest
//
//  Created by Dongle Su on 15/8/3.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLTagsView;

@protocol DLTagsViewDelegate <NSObject>
@optional
- (void)DLTagsView:(DLTagsView *)tagsView tapedAt:(NSInteger)tagIndex;
@end

@interface DLTagsView : UIView
@property(nonatomic, weak) id<DLTagsViewDelegate> delegate;
@property(nonatomic) NSArray *tags;
@property(nonatomic) UIColor* tagColor;
@property(nonatomic) UIColor* tagBackgroundColor;
@property(nonatomic) UIFont* tagFont;
@property(nonatomic) CGFloat preferredMaxLayoutWidth;
@property(nonatomic) UIEdgeInsets margin;
@property(nonatomic) CGPoint itemSpace;

@property(nonatomic) UIColor* borderColor;
@end
