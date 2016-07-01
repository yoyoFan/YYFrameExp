//
//  TagView.h
//  FlowExp
//
//  Created by pan chow on 14-4-30.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagView;
@protocol TagViewDelegatge <NSObject>

@optional
- (void)TagViewDelegateFinished;
- (void)TagViewDelegateFinishedbyIndex:(NSInteger)index;
- (void)tagViewAddPressed;
- (void)tagItemPressedInTagView:(TagView *)tagView index:(NSInteger)index;

@end

@interface TagView : UIView

@property (nonatomic,strong)NSArray *colors;
@property (nonatomic,weak)id<TagViewDelegatge>delegate;

- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors addBtn:(BOOL)isAdd longPress:(BOOL)isPermit;

- (void)setTagItem:(NSString *)title animated:(BOOL)animated;
- (void)setTagItems:(NSArray *)titles animated:(BOOL)animated;
- (void)reset;
@end
