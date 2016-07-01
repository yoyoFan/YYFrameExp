//
//  QRCodeViewController.h
//  jimao
//
//  Created by pan chow on 15/5/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "BaseViewController.h"
#import "ProjectStructDef.h"

@import AVFoundation;
#import "QRView.h"

@class QRCodeViewController;
typedef void(^QRUrlBlock)(NSString *url,QRCodeViewController *qrCtrl);

@interface QRCodeViewController : BaseViewController

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@property (nonatomic,assign)QR_Type qr_type;
@property (nonatomic,assign)BOOL isPresent;

- (void)pop;
@end
