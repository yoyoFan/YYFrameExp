//
//  SlidePopMenuView.m
//  jimao
//
//  Created by pan chow on 15/8/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "SlidePopMenuView.h"

#import "CircleImgLayer.h"
#import "TextLayer.h"

#import <POP/POP.h>

@interface SlidePopMenuView ()<POPAnimationDelegate>
{
    CAShapeLayer *_backLayer;
    
    UIImage *_img;
    NSString *_titleString;
    
    CGRect ori_Rect;
    CGRect fold_rect;
    BOOL _isfold;
}

@end
@implementation SlidePopMenuView

- (void)dealloc
{
    [self.layer pop_removeAllAnimations];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initial];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initial];
    }
    return self;
}
- (void)initial
{
    ori_Rect = self.frame;
    fold_rect = CGRectMake(ori_Rect.origin.x + ori_Rect.size.width - 38, ori_Rect.origin.y, 38, 52);
    
    _isfold = YES;
    self.frame = fold_rect;
    self.backgroundColor = [UIColor clearColor];
    [self addGestue];
    self.layer.masksToBounds = YES;
}
- (void)fillMenuWithImg:(UIImage *)img title:(NSString *)title
{
    _img = [UIImage imageNamed:@"unfoldcircle"];
    _titleString = title;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
   
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    if(_isfold)
    {
        [self drawSorrow:rect];
    }
    else
    {
        [self drawBackGround:rect];
        [self drawImg:rect];
        [self drawString:rect];
    }
}

- (void)drawBackGround:(CGRect)rect
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 5;
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    [path moveToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width, height )];
    [path addLineToPoint:CGPointMake(height*.5, height)];
   
    [path addLineToPoint:CGPointMake(height*.5,0)];
    [path addLineToPoint:CGPointMake(width,0)];
    
    [path addArcWithCenter:CGPointMake(height*.5, height*.5) radius:height*.5 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    
    [[UIColor clearColor] setStroke];
    [[UIColor colorWithRed:255/255.0 green:228/255.0 blue:0/255.0 alpha:.9] setFill];
    [path closePath];
    
    [path stroke];
    [path fill];
    
}
- (void)drawImg:(CGRect)rect
{
    if(_img)
    {
        CGFloat height = rect.size.height;
        
        CircleImgLayer *layer=[CircleImgLayer layer];
        layer.bounds=CGRectMake(0, 0, 28, 28);
        layer.position = CGPointMake(height*.5, height*.5);
        
        //设置图层代理
        [layer fillWithImg:_img];
        
        //添加图层到根图层
        [self.layer addSublayer:layer];
    }
}
- (void)drawString:(CGRect)rect
{
    if(_titleString)
    {
        CGFloat height = rect.size.height;
        CGFloat width = rect.size.width;
        
     
        CATextLayer *layer=[CATextLayer layer];
        layer.frame=CGRectMake(height + 8, height*.5-20+100, width - height - 8*2, 40);
        layer.position = CGPointMake(height + 8 + layer.bounds.size.width*.5, height*.5);
        
        layer.contentsScale = [UIScreen mainScreen].scale;
        
       
        
        layer.alignmentMode = kCAAlignmentJustified;
        layer.truncationMode = kCATruncationNone;
        layer.wrapped = YES;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 2;
        
        NSDictionary *attDic = @{NSForegroundColorAttributeName:MAIN_TITLE_COLOR,NSFontAttributeName:UIFont14,NSBackgroundColorAttributeName:[UIColor clearColor]};
        
        CGRect calRect = [_titleString boundingRectWithSize:layer.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attDic context:nil];
        CGFloat minHeight = roundf(MIN(CGRectGetHeight(calRect), CGRectGetHeight(layer.frame))/UIFont14.xHeight)*UIFont14.xHeight;
        layer.frame = CGRectMake(layer.frame.origin.x, height*.5-minHeight*.5 , CGRectGetWidth(layer.frame), minHeight);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_titleString attributes:attDic];
        layer.string = attrString;
         [self.layer addSublayer:layer];
    }
}
- (void)drawSorrow:(CGRect)rect
{
    CircleImgLayer *layer=[CircleImgLayer layer];
    layer.frame=CGRectMake(0, 0, CGRectGetWidth(fold_rect), CGRectGetHeight(fold_rect));
    layer.position = CGPointMake(22, 26);//有px的偏差(19,26)
   
    //设置图层代理
    [layer fillWithImg:[UIImage imageNamed:@"fold_saorrow"] Circle:NO];
    
    //添加图层到根图层
    [self.layer addSublayer:layer];
    
    
}
#pragma mark ======  touch  ======
- (void)addGestue
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    
    [self addGestureRecognizer:recognizer];
        
    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
//    [self addTarget:self action:@selector(touchupInside:)
//   forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    [self addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    

}
- (void)tap:(UITapGestureRecognizer *)tap
{
    [self scaleAnimation];
    
    CGRect  toRect = CGRectZero;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if(_isfold)
    {
        _isfold = NO;
         toRect = ori_Rect;
        [self transformToRect:toRect];
        
    }
    else
    {
        if(tap.state == UIGestureRecognizerStateEnded)
        {
            CGPoint point = [tap locationInView:self];
            CGRect rect = CGRectMake(0, 0, height, height);
            if(CGRectContainsPoint(rect, point))
            {
                _isfold = YES;
                
                toRect = CGRectMake(ori_Rect.origin.x + width - CGRectGetWidth(fold_rect), ori_Rect.origin.y, CGRectGetWidth(fold_rect), CGRectGetHeight(fold_rect));
                [self transformToRect:toRect];
            }
            else
            {
                if(self.tapBlock)
                {
                    _tapBlock(YES,_isfold);
                }
            }
        }
        
    }
}
- (void)transformToRect:(CGRect)rect
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    scaleAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(rect)+CGRectGetWidth(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
    scaleAnimation.duration = .4f;
    scaleAnimation.delegate = self;
    scaleAnimation.name = @"XAnimation";
    [self.layer pop_addAnimation:scaleAnimation forKey:@"XAnimation"];
    
//    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//    scaleAnimation.toValue = [NSValue valueWithCGRect:rect];
//    scaleAnimation.duration = .8f;
//    scaleAnimation.delegate = self;
//    scaleAnimation.name = @"frameAnimation";
//    [self.layer pop_addAnimation:scaleAnimation forKey:@"frameAnimation"];
    
//    self.frame = rect;
//    [self setNeedsDisplay];
//    
//    if(self.tapBlock)
//    {
//        _tapBlock(NO,_isfold);
//    }

}
- (void)touchupInside:(UIControl *)sender {
    [self scaleAnimation];
    
//    _isfold = !_isfold;
//    CGRect  toRect = CGRectZero;
//    CGFloat width = self.frame.size.width;
//    
//    if(_isfold)
//    {
//        toRect = CGRectMake(ori_Rect.origin.x + width - CGRectGetWidth(fold_rect), ori_Rect.origin.y, CGRectGetWidth(fold_rect), CGRectGetHeight(fold_rect));
//    }
//    else
//    {
//         toRect = ori_Rect;
//    }
//    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//    scaleAnimation.toValue = [NSValue valueWithCGRect:toRect];
//    [self.layer pop_addAnimation:scaleAnimation forKey:@"frameAnimation"];
//    
//    self.frame = toRect;
//    [self setNeedsDisplay];
//    
//    if(self.tapBlock)
//    {
//        _tapBlock(YES,_isfold);
//    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.superview];
    recognizer.view.center = CGPointMake(recognizer.view.center.x,// + translation.x
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
    
   
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat top = MAX(recognizer.view.centerY - CGRectGetHeight(fold_rect)*.5, 0);
        top = MIN(top, APP_SCREEN_CONTENT_HEIGHT - CGRectGetHeight(ori_Rect));
        fold_rect = CGRectMake(CGRectGetMinX(fold_rect), top, CGRectGetWidth(fold_rect), CGRectGetHeight(fold_rect));
        ori_Rect = CGRectMake(CGRectGetMinX(ori_Rect), top, CGRectGetWidth(ori_Rect), CGRectGetHeight(ori_Rect));
        
        CGPoint velocity = [recognizer velocityInView:self.superview];
        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.delegate = self;
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}

#pragma mark - POPAnimationDelegate
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    if([anim.name isEqualToString:@"XAnimation"])
    {
        POPBasicAnimation *bAnim = (POPBasicAnimation *)anim;
        CGRect rect = [bAnim.toValue CGRectValue];
        

        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        scaleAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(rect)-CGRectGetWidth(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
        scaleAnimation.duration = .2f;
        scaleAnimation.name = @"frameAnimation";
        [self.layer pop_addAnimation:scaleAnimation forKey:@"frameAnimation"];

        
        self.frame = rect;
        [self setNeedsDisplay];
        
        if(self.tapBlock)
        {
            _tapBlock(NO,_isfold);
        }
    }
}
- (void)pop_animationDidApply:(POPDecayAnimation *)anim
{
    if([anim.name isEqualToString:@"XAnimation"])
    {
        return;
    }
    BOOL isDragViewOutsideOfSuperView = YES;//!CGRectContainsRect(self.view.frame, backView.frame);
    if (isDragViewOutsideOfSuperView) {
        CGPoint currentVelocity = [anim.velocity CGPointValue];
        CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        positionAnimation.dynamicsMass = 1;
        CGFloat centerX = _isfold ? CGRectGetMidX(fold_rect) : CGRectGetMidX(ori_Rect);
        CGFloat centerY = _isfold ? CGRectGetMidY(fold_rect) : CGRectGetMidY(ori_Rect);
        
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
        [self.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}

- (void)scaleToSmall
{
    [self.layer pop_removeAnimationForKey:@"layerPositionAnimation"];//add
    
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.2f, 2.2f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 14.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}


@end
