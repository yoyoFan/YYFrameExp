//
//  PopupAdView.m
//  jimao
//
//  Created by Dongle Su on 15/6/10.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "PopupAdView.h"
#import "UIImageView+AFNetworking.h"

#define kCornerRadius 7.0f
#define kMarginH 40.0f
#define kMarginV 40.0f

@interface PopupAdView()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, copy) void (^onTap)(PopupAdView *sender);
@end

@implementation PopupAdView{

}

+ (PopupAdView *)sharedInstance{
    static PopupAdView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PopupAdView alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTaped)];
        [self addGestureRecognizer:tap];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton sizeToFit];
        [self addSubview:_closeButton];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)popupInView:(UIView *)view withImageUrl:(NSString *)imageUrl onDisplay:(void (^)(PopupAdView *sender))onDisplay onTap:(void (^)(PopupAdView *sender))onTap{
    if (self.imageView) {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    self.onTap = onTap;
    
    self.frame = view.bounds;
    __weak typeof(self) weakSelf = self;
    self.imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.layer.cornerRadius = kCornerRadius;
    self.imageView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped)];
    [self.imageView addGestureRecognizer:tap];

    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf) {
                CGFloat maxWidth = weakSelf.frame.size.width - kMarginH;
                CGFloat maxHeight = weakSelf.frame.size.height - kMarginV;
                CGSize size = CGSizeMake(maxWidth, maxHeight);
                CGSize fitsize = [CommonHelper fitMinSize:image.size inMaxSize:size];
                weakSelf.imageView.bounds = CGRectMake(0, 0, fitsize.width, fitsize.height);
//                weakSelf.imageView.image = image;
//                [weakSelf.imageView sizeToFit];
//                CGFloat maxWidth = weakSelf.frame.size.width - kMarginH;
//                CGFloat maxHeight = weakSelf.frame.size.height - kMarginV;
//                CGRect rc = weakSelf.imageView.frame;
//                if (rc.size.width > maxWidth || rc.size.height > maxHeight) {
//                    CGFloat w_h_ratio = rc.size.width/rc.size.height;
//                    if (w_h_ratio > weakSelf.frame.size.width/weakSelf.frame.size.height) {
//                        rc.size.width = maxWidth;
//                        rc.size.height = maxWidth/w_h_ratio;
//                    }
//                    else{
//                        rc.size.width = maxHeight*w_h_ratio;
//                        rc.size.height = maxHeight;
//                    }
//                    weakSelf.imageView.frame = rc;
//                }
                weakSelf.imageView.image = image;
                weakSelf.imageView.center = view.center;
                weakSelf.closeButton.frame = CGRectMake(weakSelf.imageView.right-weakSelf.closeButton.width-5, weakSelf.imageView.top+5, weakSelf.closeButton.width, weakSelf.closeButton.height);
                [weakSelf addSubview:weakSelf.imageView];
                [weakSelf bringSubviewToFront:weakSelf.closeButton];
                [view addSubview:weakSelf];
                if (onDisplay) {
                    onDisplay(weakSelf);
                }
            }
        });
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

- (void)close{
    [self removeFromSuperview];
}
- (void)backTaped{
    [self close];
}
- (void)imageTaped{
    [self close];
    if (self.onTap) {
        self.onTap(self);
    }
}
@end
