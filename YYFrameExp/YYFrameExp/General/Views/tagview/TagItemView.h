//
//  TagItemView.h
//  FlowExp
//
//  Created by pan chow on 14-4-30.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagItemView;
@protocol TagItemViewDelegate <NSObject>

- (void)tagItemViewLongPressed:(TagItemView *)tagView toShake:(BOOL)shake;
- (void)tagItemViewDeleteBtnPressed:(TagItemView *)tagView;
- (void)tagItemViewAddBtnPressed:(TagItemView *)tagView;
- (void)tagItemViewPressed:(TagItemView *)tagView;
@end
@interface TagItemView : UIView

@property (nonatomic,assign)BOOL shaked;
@property (nonatomic,assign)BOOL permitLongPress;

@property (nonatomic,weak)id<TagItemViewDelegate>delegate;

- (void)setTitle:(NSString *)title colors:(NSDictionary *)color;
- (void)shake;
- (void)stopShake;
@end
