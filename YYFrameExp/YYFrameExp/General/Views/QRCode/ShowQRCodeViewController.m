//
//  ShowQRCodeViewController.m
//  jimao
//
//  Created by pan chow on 15/5/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "ShowQRCodeViewController.h"
#import "QRCodeHelper.h"
#import "UserProfile.h"
#import "GBPathImageView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <POP/POP.h>

@interface ShowQRCodeViewController ()
{
    IBOutlet UIControl *backView;
    
    IBOutlet GBPathImageView *headerImgView;
    IBOutlet UILabel *nameLB;
    IBOutlet UIView *headerBackView;
    
    IBOutlet UIImageView *QRCodeImgView;
    
    IBOutlet UILabel *tipsLB;
    
    IBOutlet NSLayoutConstraint *topCon;
}
@end

@implementation ShowQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的二维码";
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = MAIN_BACK_GROUND_COLOR;
    
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.shadowOffset = CGSizeMake(2, 2);
    backView.layer.shadowRadius = 2;
    backView.layer.shadowColor = [UIColor blackColor].CGColor;
    backView.layer.shadowOpacity = 0.5;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];

    
    [backView addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [backView addGestureRecognizer:recognizer];
    
    NSString *iconPath = [[UserProfile sharedInstance] userInfo].headIcon;
    __weak __typeof(GBPathImageView *)weakHeaderImgView = headerImgView;
    [headerImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:iconPath]] placeholderImage:PLACEHODER_HEADER_USER_CENTER_IMG success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        __strong __typeof(GBPathImageView *)strongheaderImgView = weakHeaderImgView;
        [strongheaderImgView setOriImg:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    nameLB.text = [[UserProfile sharedInstance] userInfo].nickName;
    
    headerBackView.backgroundColor = MAIN_TINT_COLOR;
    
    QRCodeImgView.image = [QRCodeHelper QRCodeImgWithInfo:_codeString logo:[UIImage imageNamed:@"watemask"]];
    
    QRCodeImgView.layer.shadowOffset = CGSizeMake(0, 2);
    QRCodeImgView.layer.shadowRadius = 2;
    QRCodeImgView.layer.shadowColor = [UIColor blackColor].CGColor;
    QRCodeImgView.layer.shadowOpacity = 0.5;
    
    tipsLB.textColor = MAIN_TITLE_COLOR;
    
    if(APP_SCREEN_HEIGHT <=480)
    {
        topCon.constant = 28;
        [self.view setNeedsDisplay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view];
        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.delegate = self;
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidApply:(POPDecayAnimation *)anim
{
    BOOL isDragViewOutsideOfSuperView = YES;//!CGRectContainsRect(self.view.frame, backView.frame);
    if (isDragViewOutsideOfSuperView) {
        CGPoint currentVelocity = [anim.velocity CGPointValue];
        CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, topCon.constant+backView.height*.5)];
        [backView.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}

@end
