//
//  CommicView.h
//  Doujia
//
//  Created by pan zhou on 13-12-16.
//  Copyright (c) 2013年 pan zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommicView : UIView<UIScrollViewDelegate>
{
    
    
}
@property (nonatomic,weak)IBOutlet  UIScrollView *backScrollView;
@property (nonatomic,weak)IBOutlet UIPageControl *pageCtl;
@property (nonatomic, assign) BOOL isTapToClose;
@property (nonatomic, assign) BOOL isTapLastPageToClose;


+ (CommicView *)sharedInstance;
- (void)addToWindowAnimated:(BOOL)animated;

- (void)loadingImgsWithURLs:(NSArray *)array;
- (void)loadingImgs:(NSArray *)array;
- (void)close;
- (void)autoCloseAfter:(CGFloat)elapseTime;
- (void)gotoPage:(NSInteger)page;
- (void)setPageControlHidden:(BOOL)hidden;

- (IBAction)onScrollViewTaped:(UITapGestureRecognizer *)sender;
@end
