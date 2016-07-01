//
//  ImageLabel.h
//  FlowExp
//
//  Created by Dongle Su on 14-5-9.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageLabelTailImageAlign) {
    ImageLabelTailImageAlignVTop,
    ImageLabelTailImageAlignVCenter,
    ImageLabelTailImageAlignVBottom,
    ImageLabelTailImageAlignVTextTop,
    ImageLabelTailImageAlignVTextBottom,
};

@interface ImageLabel : UILabel
@property(assign, nonatomic) ImageLabelTailImageAlign tailImageAlignment;
- (void)setTailImage:(UIImage *)image;
@end
