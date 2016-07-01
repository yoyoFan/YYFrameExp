//
//  NoDataView.h
//  jimao
//
//  Created by pan chow on 14/12/30.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBShimmeringView.h"

@interface NoDataView : UIView
{
    IBOutlet UIImageView *noDataImgView;
    IBOutlet UILabel *nodataTipLB;
    
    FBShimmeringView *_shimmeringView;
}
+ (void)showNoDataInCtrl:(UIViewController *)ctrl;
+ (void)showNetErrorInCtrl:(UIViewController *)ctrl;
+ (void)hide;
@end
