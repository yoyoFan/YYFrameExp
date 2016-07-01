//
//  BaseCell.m
//  jimao
//
//  Created by pan chow on 14/11/26.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell



+ (instancetype)getInstance
{
    id cell=[[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] firstObject];
    return cell;
}
- (CGFloat)dynamicHeight
{
    [self layoutSubviews];

    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}
+ (CGFloat)cellHeight
{
    return 0;
}

- (void)awakeFromNib {
    // Initialization code
//    self.backgroundView=[[UIView alloc] initWithFrame:self.bounds];
//    self.backgroundView.backgroundColor=[UIColor clearColor];
//    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
//    self.selectedBackgroundView.backgroundColor = SUB_ITEM_COLOR;
    
//    self.mainTitleLabel.textColor = MAIN_TITLE_COLOR;
//    self.subTitleLabel.textColor = DETAIL_COLOR;
}

@end
