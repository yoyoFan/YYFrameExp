//
//  LineProgreesFrontView.m
//  jimao
//
//  Created by pan chow on 14/11/27.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "LineProgreesFrontView.h"

@implementation LineProgreesFrontView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self initialize];
    }
    return self;
}
- (void)becameActive
{
    [self.layer removeAllAnimations];
    [self.layer addAnimation:[self mediumProgressAnimation] forKey:@"animation"];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
# pragma mark - Initialization

- (void)initialize {
    self.image = [UIImage imageNamed:@"progressLine"];
    self.contentMode = UIViewContentModeScaleAspectFit;
    [self.layer addAnimation:[self mediumProgressAnimation] forKey:@"animation"];
}

- (CAAnimation *)mediumProgressAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = @(-self.frame.size.width);
    animation.toValue = @(self.frame.size.width * 2);
    animation.duration = 1.5f;
    animation.fillMode = kCAFillModeBoth;
    animation.repeatCount = INFINITY;
    return animation;
}


@end
