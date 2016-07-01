//
//  GradualProgressView.h
//  jimao
//
//  Created by pan chow on 14/11/25.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradualProgressView : UIView

@property (nonatomic, strong) NSArray   * progressChunks;

@property (nonatomic, strong) UIColor   * progressTintColor;
@property (nonatomic, strong) UIColor   * trackTintColor;

/*! A Boolean value that controls whether the receiver is hidden when the animation is stopped. Default YES */
@property (nonatomic) BOOL hidesWhenStopped;
@property (nonatomic, readonly) BOOL isAnimating;

- (void)startAnimating;
- (void)stopAnimating;

- (BOOL)isAnimating;

@end
