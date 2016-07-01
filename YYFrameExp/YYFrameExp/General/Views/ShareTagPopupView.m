//
//  ShareTagPopupView.m
//  FlowStorm
//
//  Created by Dongle Su on 14-10-14.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "ShareTagPopupView.h"
#import "TagView.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Graphic.h"

#define kContentheight 282
#define kAnimateDuaration 0.3


@implementation ShareTagPopupView{
    UIView *contentView_;
    UIImageView *blurView_;
    NSString *title_;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClicked)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title tagList:(NSArray*)tagList bluredBackImage:(UIImage *)bluredBackImage{
    int y = self.bottom - kContentheight;
    self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.width, kContentheight)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
    //blur
    UIImageView *imageView = [[UIImageView alloc] initWithImage:bluredBackImage];
    imageView.contentMode = UIViewContentModeBottom;
    [contentView addSubview:imageView];
    blurView_ = imageView;

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:titleLabel];

    NSDictionary *dic1=@{@"text":RGBCOLOR(126, 87, 48),@"back":RGBCOLOR(252, 234, 188),@"border":RGBCOLOR(224, 195, 139)};
    NSDictionary *dic2=@{@"text":RGBCOLOR(71, 120, 38),@"back":RGBCOLOR(221, 247, 186),@"border":RGBCOLOR(187, 216, 132)};
    NSDictionary *dic3=@{@"text":RGBCOLOR(90, 119, 161),@"back":RGBCOLOR(197, 229, 252),@"border":RGBCOLOR(161, 192, 223)};
    TagView *tagView = [[TagView alloc] initWithFrame:CGRectMake(40, 60, self.width-80, 170) colors:@[dic1,dic2,dic3] addBtn:NO longPress:NO];
    tagView.delegate = self;
    [tagView setTagItems:tagList animated:YES];
    [contentView addSubview:tagView];
    //
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setBackgroundImage:[UIImage imageNamed:@"sharePopupCancel"] forState:UIControlStateNormal];
    [bt setBackgroundImage:[UIImage imageNamed:@"sharePopupCancel_d"] forState:UIControlStateHighlighted];
    [bt sizeToFit];
    [bt setFrame:CGRectMake((self.width-bt.width)/2, 230, bt.width, bt.height)];
    [bt addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:bt];
    contentView_ = contentView;
}

- (void)appearFromRightInView:(UIView *)view animated:(BOOL)animated{
    int y = contentView_.top;
    if (animated) {
        //contentView_.frame = CGRectMake(view.width, y, contentView_.width, contentView_.height);
        blurView_.frame = CGRectMake(-blurView_.width, contentView_.height-blurView_.height, blurView_.width, blurView_.height);
        //self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(self.width, 0, self.width, self.height);
        self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];

        [view addSubview:self];
        
        
        [UIView animateWithDuration:kAnimateDuaration animations:^{
            //contentView_.frame = CGRectMake(0, y, contentView_.width, contentView_.height);
            blurView_.frame = CGRectMake(0, contentView_.height-blurView_.height, blurView_.width, blurView_.height);
            self.frame = CGRectMake(0, 0, self.width, self.height);
            //self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        contentView_.frame = CGRectMake(0, y, contentView_.width, contentView_.height);
        blurView_.frame = CGRectMake(0, contentView_.height-blurView_.height, blurView_.width, blurView_.height);
        self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];

        [view addSubview:self];
    }
    
}

- (void)disappearWithComplete:(void(^)())block{
    [UIView animateWithDuration:kAnimateDuaration animations:^{
        contentView_.frame = CGRectMake(0, self.bottom, contentView_.width, contentView_.height);
        blurView_.frame = CGRectMake(0, -blurView_.height, blurView_.width, blurView_.height);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (block) {
            block();
        }
    }];
    
}
- (void)backgroundClicked{
    [self disappearWithComplete:nil];
}

- (void)cancelClicked:(UIButton *)sender{
    [self disappearWithComplete:nil];
}

- (void)tagItemPressedInTagView:(TagView *)tagView index:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShareTagPopupView:clickedTagIndex:)]) {
        [self.delegate ShareTagPopupView:self clickedTagIndex:index];
    }
}

@end
