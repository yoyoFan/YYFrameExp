//
//  FirstStartPageView.h
//  newAdmite
//
//  Created by fwr on 15/3/30.
//  Copyright (c) 2015年 fwr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLaunchPageView : UIView<UIScrollViewDelegate>
{
    
}
@property (nonatomic,weak)IBOutlet  UIScrollView *backScrollView;
@property (nonatomic,weak) IBOutlet UIPageControl *pageCtl;
@property (nonatomic, assign) BOOL isTapToClose;
@property (nonatomic, assign) BOOL isTapLastPageToClose;

+ (FirstLaunchPageView *)sharedInstance;
- (void)LoadLaunchBgImg;
- (void)close;

- (void)setPageControlHidden:(BOOL)hidden;

@end
