//
//  SelectCollectionViewCell.h
//  jimao
//
//  Created by pan chow on 14/12/3.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCollectionViewCell : UICollectionViewCell
{
    IBOutlet UILabel *titleLB;
}
- (void)loadCell:(NSString *)title;
- (CGSize)cellSize;
@end
