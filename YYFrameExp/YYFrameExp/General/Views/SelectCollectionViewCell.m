//
//  SelectCollectionViewCell.m
//  jimao
//
//  Created by pan chow on 14/12/3.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "SelectCollectionViewCell.h"
#import <POP/POP.h>

@implementation SelectCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.backgroundColor=[UIColor whiteColor];
//    UIView *vw=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    vw.backgroundColor=[UIColor colorFromHexString:@"#e6e6e6"];
//    self.selectedBackgroundView = vw;
    titleLB.textColor = rgb(120, 120, 120);
    titleLB.font = UIFont16;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SelectCollectionViewCell" owner:self options:nil] lastObject];
    }
    return self;
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if(self.selected)
    {
        titleLB.textColor = rgb(224, 59, 61);
    }
    else
    {
        titleLB.textColor = rgb(120, 120, 120);
    }
    
}
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    } else {
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
        scaleAnimation.springBounciness = 18.f;
        [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}

- (void)loadCell:(NSString *)title
{
    titleLB.text=title;
   // [titleLB sizeThatFits:CGSizeMake(91, 44)];
}

- (CGSize)cellSize
{
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end
