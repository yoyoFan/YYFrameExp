//
//  BMYCircularProgressViewNew.m
//  jimao
//
//  Created by fwr on 15/3/30.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "BMYCircularProgressLabelView.h"
#import <QuartzCore/QuartzCore.h>

#define degToRad(angle) (angle) * (M_PI / 180.0)

@interface BMYCircularProgressLabelView ()
{
    CGFloat tempDegress;
    CABasicAnimation* rotationAnimation;
}

@property (nonatomic, strong) CAShapeLayer *logoLayer;
@property (nonatomic, strong) CAShapeLayer *backCircleLayer;
@property (nonatomic, strong) CAShapeLayer *frontCircleLayer;

//@property (nonatomic,strong) CATextLayer *updateLayer;
@property (nonatomic,strong) UILabel *loadLabel;

@property (nonatomic,strong) NSString *loadingStr1;
@property (nonatomic,strong) NSString *loadedStr2;

@property (nonatomic, strong) CAShapeLayer *pieLayer;


@end

@implementation BMYCircularProgressLabelView

@dynamic center;
@dynamic size;
@dynamic frame;

- (id)initWithFrame:(CGRect)frame
               logo:(UIImage *)logoImage
    backCircleImage:(UIImage *)backCircleImage
   frontCircleImage:(UIImage *)frontCircleImage
  updateLabelString:(NSString *)updateLabelstring
          loadLabel:(NSString *)loadLabelString
{
    self = [super initWithFrame:frame];
    if (self) {
        _logoLayer = [CAShapeLayer layer];
        _backCircleLayer = [CAShapeLayer layer];
        _frontCircleLayer = [CAShapeLayer layer];
        _pieLayer = [CAShapeLayer layer];

        [self.layer addSublayer:_logoLayer];
        [self.layer addSublayer:_backCircleLayer];
        [self.layer addSublayer:_frontCircleLayer];
        [self.layer addSublayer:_pieLayer];
        
        _loadingStr1 = updateLabelstring;
        _loadedStr2 = loadLabelString;
        
        _loadLabel=[[UILabel alloc] initWithFrame:CGRectMake(30, 4, 80, 20)];
        _loadLabel.text = updateLabelstring;
        _loadLabel.font = [UIFont systemFontOfSize:14];
        _loadLabel.textColor = ColorC4;
        [self addSubview:_loadLabel];
        
        _logoLayer.contents = (__bridge id)[logoImage CGImage];
        _backCircleLayer.contents = (__bridge id)[backCircleImage CGImage];
        _frontCircleLayer.contents = (__bridge id)[frontCircleImage CGImage];
        _frontCircleLayer.mask = _pieLayer;
        _logoLayer.opacity = 0.0f;
        
        tempDegress = 0;
       
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _logoLayer.frame = self.bounds;
//    _backCircleLayer.frame = self.bounds;
//    _frontCircleLayer.frame = self.bounds;
//    _pieLayer.frame = self.bounds;
    
    _logoLayer.frame = CGRectMake(0, 0, 25, 25);
    _backCircleLayer.frame = CGRectMake(0, 0, 25, 25);
    _frontCircleLayer.frame = CGRectMake(0, 0, 25, 25);
    _pieLayer.frame = CGRectMake(0, 0, 25, 25);
}

#pragma mark - BMYProgressViewProtocol

- (void)setProgress:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
//    [self _updatePie:_pieLayer forAngle:progress * 360.0f];
//    _frontCircleLayer.mask = _pieLayer;
//    _logoLayer.opacity = progress;

    if(tempDegress != progress)
    {
        [self RotateCircle :tempDegress*M_PI ToAngle: progress*M_PI];
        tempDegress = progress;
    }
    
    if(progress >= 1)
    {
        _loadLabel.text = _loadedStr2;
    }
    else
    {
        _loadLabel.text = _loadingStr1;
    }
    [CATransaction commit];
}





#pragma mark - Private Methods

- (void)_updatePie:(CAShapeLayer *)layer forAngle:(CGFloat)degrees {
    CGFloat angle = degToRad(-90);
    CGPoint center_ = CGPointMake(CGRectGetWidth(layer.frame)/2.0, CGRectGetWidth(layer.frame)/2.0);
    CGFloat radius = CGRectGetWidth(layer.frame)/2.0;
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center_];
    [piePath addLineToPoint:CGPointMake(center_.x, center_.y - radius)];
    [piePath addArcWithCenter:center_ radius:radius startAngle:angle endAngle:degToRad(degrees - 90.0f) clockwise:YES];
    [piePath addLineToPoint:center_];
    [piePath closePath];
    
    layer.path = piePath.CGPath;
}


-(void)RotateCircle:(CGFloat)degrees ToAngle:(CGFloat)toDegress
{
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: degrees];
//    rotationAnimation.byValue = [NSNumber numberWithFloat: toDegress];
    rotationAnimation.toValue = [NSNumber numberWithFloat: toDegress];
    rotationAnimation.duration = 1.6;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
//    rotationAnimation.repeatDuration = 0;
    [_backCircleLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}




@end
