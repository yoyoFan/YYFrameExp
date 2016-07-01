//
//  DLTagsView.m
//  tagViewTest
//
//  Created by Dongle Su on 15/8/3.
//  Copyright (c) 2015年 dongle. All rights reserved.
//

#import "DLTagsView.h"

#import "DLTagItemView.h"

#import <objc/runtime.h>

@implementation DLTagsView{
    CGFloat width_;
    CGFloat height_;
}

- (void)setTags:(NSArray *)tags{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    width_ = height_ = 0;
    _tags = tags;
    
    CGFloat x = self.margin.left;
    CGFloat y = self.margin.top;
    int i = 0;
    for (NSString *tagText in tags) {
        DLTagItemView *tagItem = [[DLTagItemView alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
        tagItem.text = tagText;
        tagItem.textColor = self.tagColor;
        if (self.tagBackgroundColor) {
            tagItem.backgroundColor = self.tagBackgroundColor;
        }
        if(self.borderColor)
        {
            tagItem.borderColor = _borderColor;
        }
        tagItem.font = self.tagFont;
        [tagItem sizeToFit];
        
        x = tagItem.frame.origin.x + tagItem.frame.size.width;
        if (x + self.margin.right > self.preferredMaxLayoutWidth) {
            x = self.margin.left;
            y += tagItem.frame.size.height + self.itemSpace.y;
            tagItem.frame = CGRectMake(x, y, tagItem.frame.size.width, tagItem.frame.size.height);
            
            x += tagItem.frame.size.width + self.itemSpace.x;
        }
        else {
            x += self.itemSpace.x;
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagTaped:)];
        [tagItem addGestureRecognizer:tapGesture];
        objc_setAssociatedObject(tapGesture, (__bridge const void *)(tapGesture),
                                 [NSNumber numberWithInteger:i],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        tagItem.userInteractionEnabled = YES;
        [self addSubview:tagItem];
        
        if (width_ < tagItem.frame.origin.x + tagItem.frame.size.width + self.margin.right) {
            width_ = tagItem.frame.origin.x + tagItem.frame.size.width + self.margin.right;
        }
        if (height_ < tagItem.frame.origin.y + tagItem.frame.size.height + self.margin.bottom) {
            height_ = tagItem.frame.origin.y + tagItem.frame.size.height + self.margin.bottom;
        }
        i++;
    }

    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(width_, height_);
}

- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(width_, height_);
}

- (void)tagTaped:(UITapGestureRecognizer *)tap{
    NSNumber *num = objc_getAssociatedObject(tap, (__bridge const void *)(tap));
    if (self.delegate && [self.delegate respondsToSelector:@selector(DLTagsView:tapedAt:)]) {
        [self.delegate DLTagsView:self tapedAt:[num integerValue]];
    }
}
@end
