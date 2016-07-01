//
//  ShareTagPopupView.h
//  FlowStorm
//
//  Created by Dongle Su on 14-10-14.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareTagPopupView;

@protocol ShareTagPopupViewDelegate <NSObject>
- (void)ShareTagPopupView:(ShareTagPopupView *)tagView clickedTagIndex:(int)tagIndex;
@end

@interface ShareTagPopupView : UIView
@property (nonatomic, weak) id<ShareTagPopupViewDelegate> delegate;

- (void)setupWithTitle:(NSString *)title tagList:(NSArray*)tagList bluredBackImage:(UIImage *)bluredBackImage;
- (void)disappearWithComplete:(void(^)())block;
- (void)appearFromRightInView:(UIView *)view animated:(BOOL)animated;
@end
