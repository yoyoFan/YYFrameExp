//
//  RefreshCell.h
//  LoveShopping
//
//  Created by wenjun on 12-11-15.
//
//

#import <UIKit/UIKit.h>

@interface RefreshCell : UITableViewCell
{
    IBOutlet UIActivityIndicatorView * indicator;
    IBOutlet UILabel * tipsLB;
}

+ (RefreshCell *)getInstance;
- (void)animate;


@end
