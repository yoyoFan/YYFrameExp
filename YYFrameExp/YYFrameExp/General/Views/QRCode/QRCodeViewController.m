//
//  QRCodeViewController.m
//  jimao
//
//  Created by pan chow on 15/5/6.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "QRCodeViewController.h"

#import "QRCodeHelper.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "Tip.h"
#import "WebService.h"
#import "RegExHelper.h"
#import "ForwardCenter.h"
#import "WebViewController.h"
@interface Barcode : NSObject
@property (nonatomic, strong) AVMetadataMachineReadableCodeObject *metadataObject;
@property (nonatomic, strong) UIBezierPath *cornersPath;
@property (nonatomic, strong) UIBezierPath *boundingBoxPath;
@end

@implementation Barcode
@end

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL hasChecked;
}
@property (strong, nonatomic) AVCaptureSession * captureSession;
@property (strong, nonatomic) AVCaptureDevice * videoDevice;

@property (strong, nonatomic) AVCaptureDeviceInput * videoInput;
@property (strong, nonatomic) AVCaptureMetadataOutput * metadataOutput;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong)QRView *qrRectView;

@property (nonatomic,strong)NSMutableDictionary *barcodes;

@property (nonatomic, weak) IBOutlet UISlider *zoomSlider;

@end

@implementation QRCodeViewController
{
    BOOL _running;
    
    CGFloat _initialPinchZoom;
    
    BOOL _loading;
}

- (void)initNav
{
    self.title = @"扫一扫";
    if(!_isPresent)
    {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"navback"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIButton *bbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [bbtn setImage:[UIImage imageNamed:@"navback"] forState:UIControlStateNormal];
        //bbtn.bounds = CGRectMake(0, 0, 44, 44);
        [bbtn sizeToFit];
        [bbtn addTarget:self action:@selector(preBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bbtn];
        self.navigationItem.leftBarButtonItem=item;
    }
#ifdef DEBUG
//    UIBarButtonItem *rbtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showQRCode:)];
//    self.navigationItem.rightBarButtonItem=rbtn;
#else
#endif
}
- (void)preBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showQRCode:(id)sender
{
    [QRCodeHelper pushShowQRCodeViewCtrlBaseOnCtrl:self withString:@"http://www.baidu.com"];
}
- (void)pop
{
    if(!_isPresent)
    {
        [self back];
    }
    else
    {
        [self preBack];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNav];
    
    [self setupCaptureSession];
    
    [_previewView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startRunning];
    hasChecked = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopRunning];
}

#pragma mark - Notifications

- (void)applicationWillEnterForeground:(NSNotification*)note
{
    [self startRunning];
}

- (void)applicationDidEnterBackground:(NSNotification*)note
{
    [self stopRunning];
}

#pragma mark - Video stuff

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    _running = YES;
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - _qrRectView.transparentArea.width) / 2,
                                 (screenHeight - _qrRectView.transparentArea.height)/ 2,
                                 _qrRectView.transparentArea.width,
                                 _qrRectView.transparentArea.height);
    
    _metadataOutput.rectOfInterest = [_previewLayer metadataOutputRectOfInterestForRect:CGRectMake(CGRectGetMinX(cropRect)-10, CGRectGetMinY(cropRect)-10, CGRectGetWidth(cropRect)+20, CGRectGetHeight(cropRect)+20)];
}

- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    _running = NO;
}

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;

    self.captureSession = [[AVCaptureSession alloc] init];

    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 2
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [_videoDevice lockForConfiguration:nil];
    [_videoDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    if (!_videoDevice) {
        SLog(@"No video camera on this device!");
        return;
    }
    //3
    NSError *error = nil;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&error];
    if(error)
    {
        UIAlertView *alert = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"请在\"设置-隐私-相机\"选项中,允许本应用访问相机"];
        [alert bk_addButtonWithTitle:@"知道了" handler:^{
            [self pop];
        }];
        [alert show];
        
        return;
    }
    if ([_captureSession canAddInput:_videoInput])
    {
        [_captureSession addInput:_videoInput];
    }
    //4
    self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue = dispatch_queue_create("com.razeware.ColloQR.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
    
    _metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];//AVMetadataObjectTypeQRCode
    
    //5
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self.view addSubview:_previewView];
    
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;//AVLayerVideoGravityResizeAspectFill
    
    _previewLayer.frame =_previewView.bounds;
    
    _previewView.backgroundColor = [UIColor clearColor];
    [_previewView.layer addSublayer:_previewLayer];
    
    self.qrRectView = [[QRView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    _qrRectView.transparentArea = CGSizeMake(200, 200);
    _qrRectView.backgroundColor = [UIColor clearColor];
    [_previewView addSubview:_qrRectView];

    UILabel *tipsLB = [[UILabel alloc] initWithFrame:CGRectMake(0, _qrRectView.centerY + 108, APP_SCREEN_WIDTH, 36)];
    tipsLB.backgroundColor = [UIColor clearColor];
    tipsLB.text = @"将二维码放入框内，即可自动扫描";
    tipsLB.textAlignment = NSTextAlignmentCenter;
    tipsLB.textColor = [UIColor whiteColor];
    [_previewView addSubview:tipsLB];
    
    UIButton * myQRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myQRBtn.frame = CGRectMake((APP_SCREEN_WIDTH - 200)*.5, tipsLB.bottom , 200, 44);
    //[myQRBtn setTitle:@"我的二维码>" forState:UIControlStateNormal];
    [myQRBtn setTitle:@"请正确扫描二维码" forState:UIControlStateNormal];
    [myQRBtn setTitleColor:ColorC5 forState:UIControlStateNormal];
    //[myQRBtn addTarget:self action:@selector(showQRCode:) forControlEvents:UIControlEventTouchUpInside];
    //[_previewView addSubview:myQRBtn];
    
    self.barcodes = [NSMutableDictionary new];
}


#pragma mark -

- (Barcode*)processMetadataObject:(AVMetadataMachineReadableCodeObject*)code {
    // 1
    Barcode *barcode = _barcodes[code.stringValue];
    
    // 2
    if (!barcode) {
        barcode = [Barcode new];
        _barcodes[code.stringValue] = barcode;
    }
    
    // 3
    barcode.metadataObject = code;
    
    // Create the path joining code's corners
    
    // 4
    CGMutablePathRef cornersPath = CGPathCreateMutable();
    
    // 5
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)code.corners[0], &point);
    
    // 6
    CGPathMoveToPoint(cornersPath, nil, point.x, point.y);
    
    // 7
    for (int i = 1; i < code.corners.count; i++) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)code.corners[i], &point);
        CGPathAddLineToPoint(cornersPath, nil, point.x, point.y);
    }
    
    // 8
    CGPathCloseSubpath(cornersPath);
    
    // 9
    barcode.cornersPath = [UIBezierPath bezierPathWithCGPath:cornersPath];
    CGPathRelease(cornersPath);
    
    // Create the path for the code's bounding box
    
    // 10
    barcode.boundingBoxPath = [UIBezierPath bezierPathWithRect:code.bounds];
    
    // 11
    return barcode;
}

- (void)startRunningWhenWrongCheck
{
    if(self.view.window)
    {
        [self startRunning];
    }
}
- (void)invokeURlblock:(NSString *)retString
{
    self.qrUrlBlock(retString,self);
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if(hasChecked)
    {
        return;
    }
    //dispatch_sync(dispatch_get_main_queue(), ^{
        if(metadataObjects.count>0)
        {
            AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject*)metadataObjects[0];
            
            if ([code isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
            {
                hasChecked = YES;
                
                [self playAudio];
                
                if (self.qrUrlBlock)
                {
//                    __weak typeof(self)weakSelf = self;
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        __strong typeof(weakSelf)strongSelf = self;
//                        [strongSelf pop];
//                    });
                    NSString *backString = code.stringValue;
                    [self invokeURlblock:backString];
                }
                else
                {
                    NSString *codeString = code.stringValue;
                    if(![CommonHelper stringIsEmpty:codeString])
                    {
                        [CommonHelper settingsWithQRCodeString:codeString fromQRCtrl:self];
                    }
                }
                //[self performSelector:@selector(startRunningWhenWrongCheck) withObject:nil afterDelay:2.0];
            }
            
        }

    //});
}
- (void)playAudio
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//shake
    SystemSoundID audioSoundId;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"qrcode_checked" ofType:@"wav"];;
    NSURL *audioURL = [NSURL fileURLWithPath:path];
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioURL, &audioSoundId);
    if(error)
    {
        return;
    }
    AudioServicesAddSystemSoundCompletion(audioSoundId, NULL, NULL, SoundFinished, (__bridge void *)(audioURL));
    AudioServicesPlayAlertSound(audioSoundId);
}
//音频播放结束调用此方法
static void SoundFinished(SystemSoundID soundID,void* sample)
{
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID((SystemSoundID)sample);
    CFRelease(sample);
    CFRunLoopStop(CFRunLoopGetCurrent());
}
- (void)addFriendRequestWithString:(NSString *)string
{
    if([CommonHelper stringIsEmpty:string])
    {
        [Tip tipError:GetString(@"LS_Friend_Search_Error_Tips", @"") OnView:nil];
        return;
    }
    if(![RegExHelper isMatchPhone:string])
    {
        [Tip tipError:GetString(@"pwd_input_your_phone_format_error", @"") OnView:nil];
        return;
    }
    if(_loading)
    {
        return;
    }
    _loading = YES;
    
    [Tip tipProgress:GetString(@"LS_Friend_Add_request", @"") OnView:nil];
//    [[WebService sharedInstance] addFriendWithId:string msg:@"" Success:^(id jsonObj, NSInteger pageNo, NSInteger totalPages, NSInteger totalCount) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [RuntimeInfo sharedInstance].friendChanged = YES;
//            _loading=NO;
//            [Tip tipSuccess:GetString(@"LS_Friend_Added_request", @"") OnView:nil];
//            [self bk_performBlock:^(id obj) {
//                [self pop];
//            } afterDelay:1.4];
//        });
//    } failure:^(NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _loading=NO;
//            
//            [Tip tipError:error.localizedDescription OnView:nil];
//        });
//    }];
    
}
#pragma mark - Actions

CGFloat ZoomFactorCalc(CGFloat maxZoomFactor, CGFloat sliderValue) {
    CGFloat factor = pow(maxZoomFactor, sliderValue);
    return MIN(10.0f, factor);
}

- (IBAction)zoomSliderChanged:(id)sender {
    if (!_videoDevice) return;
    
    NSError *error = nil;
    [_videoDevice lockForConfiguration:&error];
    if (!error) {
        CGFloat zoomFactor = ZoomFactorCalc(_videoDevice.activeFormat.videoMaxZoomFactor, _zoomSlider.value);
        _videoDevice.videoZoomFactor = zoomFactor;
        [_videoDevice unlockForConfiguration];
    }
}

- (void)pinchDetected:(UIPinchGestureRecognizer*)recogniser {
    // 1
    if (!_videoDevice) return;
    
    // 2
    if (recogniser.state == UIGestureRecognizerStateBegan) {
        _initialPinchZoom = _videoDevice.videoZoomFactor;
    }
    
    // 3
    NSError *error = nil;
    [_videoDevice lockForConfiguration:&error];
    
    if (!error) {
        CGFloat zoomFactor;
        CGFloat scale = recogniser.scale;
        if (scale < 1.0f) {
            // 4
            zoomFactor = _initialPinchZoom - pow(_videoDevice.activeFormat.videoMaxZoomFactor, 1.0f - recogniser.scale);
        } else {
            // 5
            zoomFactor = _initialPinchZoom + pow(_videoDevice.activeFormat.videoMaxZoomFactor, (recogniser.scale - 1.0f) / 2.0f);
        }
        
        // 6
        zoomFactor = MIN(10.0f, zoomFactor);
        zoomFactor = MAX(1.0f, zoomFactor);
        
        // 7
        _videoDevice.videoZoomFactor = zoomFactor;
        
        // 8
        [_videoDevice unlockForConfiguration];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
