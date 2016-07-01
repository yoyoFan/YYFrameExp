//
//  WebViewController.h
//  YYFrameExp
//
//  Created by fwr on 16/6/18.
//  Copyright © 2016年 com.YoYo. All rights reserved.
//

#import "BaseViewController.h"
#import "DLPanableWebView.h"


@interface WebViewController : BaseViewController
@property(nonatomic, copy) NSString *urlString;
@property(nonatomic, strong) NSMutableURLRequest *urlRequest;
@property (nonatomic,copy)NSString *htmlString;
@property (weak, nonatomic) IBOutlet DLPanableWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *datePickerContainer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

//@property(nonatomic, assign) BOOL stayAfterJump; // goPage后当前页面保留

@property(nonatomic, assign) BOOL enablePanGesture;

@property(nonatomic, copy) BOOL (^onJSCall)(NSString *functionName, NSArray *nameArgArray);

- (void)loadUrlRequest:(NSMutableURLRequest *)request loadFinished:(void(^)(WebViewController *sender))finished;

// protected.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (IBAction)dateConfirmTaped:(id)sender;
- (IBAction)dateCancelTaped:(id)sender;

@end
