//
//  ImageViewer.m
//  FlowExp
//
//  Created by Dongle Su on 14-4-17.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "ImageViewer.h"

@implementation ImageViewer{
    UIImageView *imageView_;
    CGRect oriRect_;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView_ = [[UIImageView alloc] initWithFrame:frame];
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:imageView_];
        
        self.scrollEnabled = YES;
//        self.alwaysBounceHorizontal = YES;
//        self.alwaysBounceVertical = YES;
        imageView_.userInteractionEnabled = NO;
//
        self.contentSize = self.frame.size;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
//        //拖动
//        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
//        [panGesture setMinimumNumberOfTouches:1];
//        [panGesture setMaximumNumberOfTouches:2];
//        [imageView_ addGestureRecognizer:panGesture];
        
        //缩放
//        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//        [imageView_ addGestureRecognizer:pinch];
        
        self.delegate = self;
        self.minimumZoomScale = 0.5;
        self.maximumZoomScale = 2.0;
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    imageView_.image = image;
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    oriRect_ = rect;
    CGFloat width = APP_SCREEN_WIDTH;
    CGFloat height = width*(rect.size.height/rect.size.width);
    CGFloat top = (view.height-height)/2;
    top = top < 0.0 ? 0.0: top;
    //CGRect newRect = CGRectMake(0, 0, 320, height);
    imageView_.frame = rect;
    [self setContentSize:CGSizeMake(width, height)];
    [view addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView_.frame = CGRectMake(0, top, APP_SCREEN_WIDTH, height);
    } completion:^(BOOL finished) {
//        imageView_.frame = newRect;
//        float insetx = imageView_.width<self.width ? (self.width-imageView_.width)/2.0 : 0;
//        float insety = imageView_.height<self.height ? (self.height-imageView_.height)/2.0 : 0;
//        [self setContentSize:CGSizeMake(MAX(self.width, width), MAX(self.height, height))];
//        [self setContentOffset:CGPointMake(0, -top)];
//        [self setContentInset:UIEdgeInsetsMake(insety, insetx, 0, 0)];
    }];
}

- (void)removeFromSuperview{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    self.backgroundColor = [UIColor clearColor];
    [self setContentOffset:CGPointZero];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView_.frame = oriRect_;

    } completion:^(BOOL finished) {
        [super removeFromSuperview];

    }];
}
- (void)tap:(id)sender{
    [self removeFromSuperview];
}

//缩放
//- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
//{
////    self.scrollEnabled = YES;
//    if(gesture.state == UIGestureRecognizerStateEnded)
//    {
//        currentScale = gesture.scale;
//    }
//    else if(gesture.state == UIGestureRecognizerStateBegan && currentScale !=.0f)
//    {
//        gesture.scale=currentScale;
//    }
//    
//    if(gesture.scale != NAN && gesture.scale !=.0f)
//    {
//        gesture.scale=MAX(.4, gesture.scale);
//        gesture.scale=MIN(2.0, gesture.scale);
//        //imageView_.transform=CGAffineTransformMakeScale(gesture.scale, gesture.scale);
//        
//        CGPoint oldOffset = self.contentOffset;
//        UIEdgeInsets oldInsets = self.contentInset;
//        CGPoint center = CGPointMake(-oldOffset.x + oldInsets.left +imageView_.center.x, -oldOffset.y + oldInsets.top +imageView_.center.y);
//        CGSize size = CGSizeMake(imageView_.width*gesture.scale, imageView_.height*gesture.scale);
//        if (size.width < self.width) {
//            center.x = self.width/2.0;
//        }
//        if (size.height < self.height) {
//            center.y = self.height/2.0;
//        }
//        CGPoint origin;
//        origin.x = center.x - size.width/2.0;
//        origin.y = center.y - size.height/2.0;
//
//        
//        float insetx, insety, offsetx, offsety;
//        if (origin.x > 0 && size.width<self.width) {
//            insetx = origin.x;
//            offsetx = 0;
//        }
//        else{
//            insetx = 0;
//            offsetx = -origin.x;
//        }
//        if (origin.y > 0 && size.height<self.height) {
//            insety = origin.y;
//            offsety = 0;
//        }
//        else{
//            insety = 0;
//            offsety = -origin.y;
//        }
//
//        //self.contentSize = CGSizeMake(MAX(self.width, size.width), MAX(self.height, size.height));
//        self.contentSize = CGSizeMake(size.width, size.height);
//        self.contentOffset = CGPointMake(offsetx, offsety);
//        //self.contentInset = UIEdgeInsetsMake(insety, insetx, 0, 0);
//        imageView_.frame = CGRectMake(insetx, insety, size.width, size.height);
//
//        gesture.scale = 1.0;
//    }
//    
//    
////    self.contentSize = imageView_.frame.size;
////    self.contentOffset = CGPointMake(-imageView_.frame.origin.x, -imageView_.frame.origin.y);
////    imageView_.frame = CGRectMake(0, 0, imageView_.width, imageView_.height);
//    
//    //    CGPoint p1 = [gesture locationOfTouch: 0 inView:self];
//    //    imageView_.layer.anchorPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    
//    //     imageView_.frame = CGRectMake( - newCenter.x/4, - newCenter.y/4, imageView_.width, imageView_.height);
//}


//拖动
/*
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if(gesture.state != UIGestureRecognizerStateEnded && gesture.state != UIGestureRecognizerStateFailed)
    {
        CGPoint location=[gesture locationInView:self];
        
        imageView_.center=location; 
        
        if(gesture.state == UIGestureRecognizerStateEnded)
        {
            if(location.x<0 || location.y>imageView_.height || location.y<0 || location.y>imageView_.width)
            {
                location.x=MAX(0, location.x);
                location.x=MIN(imageView_.height, location.x);
                
                location.y=MAX(0, location.y);
                location.y=MIN(imageView_.width, location.y);
                
                imageView_.center=location;
            }
        }
    }
}
 */


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView_;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = imageView_;
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    CGSize size = CGSizeMake(MAX(self.width, imageView_.width), MAX(self.height, imageView_.height));
//    self.contentSize = size;
//    float insetx = imageView_.width<self.width ? (self.width-imageView_.width)/2.0 : 0;
//    float insety = imageView_.height<self.height ? (self.height-imageView_.height)/2.0 : 0;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.contentInset = UIEdgeInsetsMake(insety, insetx, 0, 0);
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

@end
