//
//  ImageLabel.m
//  FlowExp
//
//  Created by Dongle Su on 14-5-9.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "ImageLabel.h"

@implementation ImageLabel{
    UIImageView *tailImageView_;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tailImageAlignment = ImageLabelTailImageAlignVCenter;
    }
    return self;
}

- (void)layoutImage{
    CGSize textSize = [super sizeThatFits:CGSizeMake(10000, self.height)];//[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.width, self.height)];
    
    float y = 0;
    if (self.tailImageAlignment == ImageLabelTailImageAlignVTop) {
        y = 0;
    }
    else if (self.tailImageAlignment == ImageLabelTailImageAlignVCenter){
        y = (self.height - tailImageView_.height)/2;
    }
    else if (self.tailImageAlignment == ImageLabelTailImageAlignVBottom){
        y = self.height - tailImageView_.height;
    }
    else if (self.tailImageAlignment == ImageLabelTailImageAlignVTextTop){
        y = (self.height - textSize.height)/2;
    }
    else if (self.tailImageAlignment == ImageLabelTailImageAlignVTextBottom){
        y = self.height - (self.height - textSize.height)/2 - tailImageView_.height;
    }
    
    tailImageView_.frame = CGRectMake(textSize.width + tailImageView_.width/4.0f, y, tailImageView_.width, tailImageView_.height);

}
- (void)setTailImage:(UIImage *)image{
    if (!tailImageView_) {
        tailImageView_ = [[UIImageView alloc] initWithImage:image];
        [self addSubview:tailImageView_];
    }
    else{
        tailImageView_.image = image;
        [tailImageView_ sizeToFit];
    }
    [self layoutImage];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self layoutImage];
}
- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self layoutImage];
}

- (void)sizeToFit{
    [super sizeToFit];
    if (tailImageView_) {
        self.frame = CGRectMake(self.left, self.top, tailImageView_.right+2, self.height);
    }
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize ret = [super sizeThatFits:size];
    if (tailImageView_) {
        ret = CGSizeMake(ret.width + tailImageView_.width/4.0f + tailImageView_.width, ret.height);
    }
    return ret;
}
- (CGSize)intrinsicContentSize{
    CGSize ret = [super intrinsicContentSize];
    if (tailImageView_) {
        ret = CGSizeMake(ret.width + tailImageView_.width/4.0f + tailImageView_.width, ret.height);
    }
    return ret;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
