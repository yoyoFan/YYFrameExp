//
//  RefreshCell.m
//  LoveShopping
//
//  Created by wenjun on 12-11-15.
//
//

#import "RefreshCell.h"

@implementation RefreshCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)awakeFromNib
{
    // Initialization code
//    tipsLB.textColor=DETAIL_COLOR;
//    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height+2)];
//    bkView.backgroundColor = [UIColor clearColor];
//    [self.contentView insertSubview:bkView atIndex:0];
    
}
//实例化本类
+ (RefreshCell *)getInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:@"RefreshCell" owner:nil options:nil] lastObject];
}
//运转indicator代码实现之--在ios6中nib方式不起作用
- (void)animate
{
    [indicator setHidesWhenStopped:YES];
    [indicator setHidden:NO];
    [indicator startAnimating];
}

@end
