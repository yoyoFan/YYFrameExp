//
//  ForwardCenter.m
//  jimao
//
//  Created by Dongle Su on 15/5/21.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "ForwardCenter.h"
#import <objc/runtime.h>
//#define OBJC_OLD_DISPATCH_PROTOTYPES 1
#import <objc/message.h>
//#import "UserLoginManager.h"
#import "Tip.h"
#import "RegExHelper.h"
#import "RegExCategories.h"

#import "WebViewController.h"


@implementation ForwardCenter{
    NSDictionary *tableDic_;
}
+ (ForwardCenter *)sharedInstance{
    static ForwardCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ForwardCenter alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]) {
        NSString *configFile = [[NSBundle mainBundle] pathForResource:@"forwardTable" ofType:@"plist"];

        tableDic_ = [NSDictionary dictionaryWithContentsOfFile:configFile];
        //SLLog(@"forward table:\n%@", tableDic_);

    }
    return self;
}
- (void)forwardInnerFromBaseViewController:(UIViewController *)base withPageId:(NSString *)pageId paramDic:(NSDictionary *)paramDic{
    NSDictionary *forward = [tableDic_ objectForKey:pageId];
    NSString *action = [forward objectForKey:@"action"];
    if ([action isEqualToString:@"push"]) {
        [self pushForward:forward params:paramDic baseViewController:base];
    }
    else if ([action isEqualToString:@"pushLocalWeb"]){
        [self pushWebForward:forward params:paramDic isLocal:YES baseViewController:base];
    }
    else if ([action isEqualToString:@"pushRemoteWeb"]){
        [self pushWebForward:forward params:paramDic isLocal:NO baseViewController:base];
    }
    else if ([action isEqualToString:@"openUrl"]){
        [self openUrlForward:forward params:paramDic];
    }
    else if ([action isEqualToString:@"tabSelect"]){
        [self tabSelectForward:forward params:paramDic baseViewController:base];
    }
    else if ([action isEqualToString:@"login"]){
        //if ([UserLoginManager isLogin]) {
            [Tip tipError:@"已经登录" OnView:base.view];
        }
        //else
        {
//            [UserLoginManager checkToLoginWithBaseController:base Successed:^(LoginResponse *result) {
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    base.tabBarController.selectedIndex = 0;
////                    [(UINavigationController *)base.tabBarController.selectedViewController popToRootViewControllerAnimated:YES];
////                });
//            } canceled:^{
//                
//            } failure:^(NSError *error) {
//                [Tip tipError:error.localizedDescription OnView:base.view];
//            }];
        }
    //}
}

- (void)tabSelectForward:(NSDictionary *)forward params:(NSDictionary *)paramDic baseViewController:(UIViewController *)base{
    NSDictionary *params = [forward objectForKey:@"param"];
    id indexVal = [params objectForKey:@"index"];
    
    NSInteger index = 0;
    if ([indexVal isMatch:RX(@"^[0-9]+$")]) { // just a number.
        index = [indexVal integerValue];
    }
    else { // just a string
        id val = [paramDic objectForKey:indexVal];
        index = [val integerValue];
    }
    
    base.tabBarController.selectedIndex = index;
    [(UINavigationController *)base.tabBarController.selectedViewController popToRootViewControllerAnimated:YES];
}

- (void)pushWebForward:(NSDictionary *)forward params:(NSDictionary *)paramDic isLocal:(BOOL)isLocal baseViewController:(UIViewController *)base{
    NSDictionary *params = [forward objectForKey:@"param"];
    NSString *url = [forward objectForKey:@"url"];

    NSString *urlStr;
    if (isLocal) {
        NSString *docPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        urlStr = [docPath stringByAppendingPathComponent:url];
    }
    else{
        urlStr = url;
    }
    
    WebViewController *ctrl = [[WebViewController alloc] init];
    ctrl.enablePanGesture = YES;
    [ctrl loadUrlRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] loadFinished:^(WebViewController *sender) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *format = key;
            NSString *valueKey = obj;
            NSString *jsStr = [NSString stringWithFormat:format, [paramDic objectForKey:valueKey]];
            //[ctrl.webView stringByEvaluatingJavaScriptFromString:jsStr];
        }];
    }];

    UINavigationController *nav = [base navigationController];
    [nav pushViewController:ctrl animated:YES];
}

- (void)openUrlForward:(NSDictionary *)forward params:(NSDictionary *)paramDic{
//    NSString *keyName = [forward objectForKey:@"param"];
//    NSString *url = [paramDic objectForKey:keyName];
    
    NSDictionary *params = [forward objectForKey:@"param"];
    NSString *urlKey = [params objectForKey:@"url"];
    NSString *url = [paramDic objectForKey:urlKey];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)pushForward:(NSDictionary *)forward params:(NSDictionary *)paramDic baseViewController:(UIViewController *)base{
    NSString *name = [forward objectForKey:@"name"];
    NSDictionary *params = [forward objectForKey:@"param"];
    id ctrl = [self initByClassName:name];
    [self applyParams:params withDictionary:paramDic toInstance:ctrl];
    
    UINavigationController *nav = [base navigationController];
    [nav pushViewController:ctrl animated:YES];
}

- (NSString *)setterOfProperty:(NSString *)propName{
    unichar C = [propName characterAtIndex:0];
    char c = (char)C;
    if (c >= 'a') {
        c += 'A' - 'a';
    }
    
    NSString *ret = [NSString stringWithFormat:@"set%c%@:", c, [propName substringFromIndex:1]];
    return ret;
}

- (void)applyParams:(NSDictionary *)params withDictionary:(NSDictionary *)dic toInstance:(id)inst{
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyName = key;
        NSString *valName = [obj description];
        id val;
        if ([valName isMatch:RX(@"^[0-9]+$")]) { // just a number.
            val = [NSNumber numberWithInteger:[valName integerValue]];
        }
        else if([valName hasPrefix:@"\""] && [valName hasSuffix:@"\""]){ // just a string
            val = [valName substringWithRange:NSMakeRange(1, [valName length]-2)];
        }
        else{ // a key of paramDic
            val = [dic objectForKey:valName];
        }
        
        [self setInst:inst property:keyName value:val];
    }];
}

- (void)setInst:(id)inst property:(NSString *)propName value:(id)value{
    SEL sel =NSSelectorFromString([self setterOfProperty:propName]);
    
    objc_property_t property = class_getProperty(object_getClass(inst), [propName UTF8String]);
    const char * propAttrib = property_getAttributes(property);
    printf("prop of %s:%s\n", [propName UTF8String], propAttrib);
    if (strncmp(propAttrib, "Ti,VintDefault", 2) == 0) {
        ((void (*) (id, SEL, int))objc_msgSend)(inst, sel, [value intValue]);
    }
    else if (strncmp(propAttrib, "Tl,VlongDefault", 2) == 0 || strncmp(propAttrib, "Tq", 2) == 0) {
        ((void (*) (id, SEL, long))objc_msgSend)(inst, sel, [value intValue]);
    }
    else if (strncmp(propAttrib, "TB", 2) == 0) {
        ((void (*) (id, SEL, BOOL))objc_msgSend)(inst, sel, [value boolValue]);
    }
    else if (strncmp(propAttrib, "TQ", 2) == 0) {
        ((void (*) (id, SEL, unsigned long))objc_msgSend)(inst, sel, [value unsignedLongValue]);
    }

    else if (strncmp(propAttrib, "T@,VidDefault", 2) == 0) {
        ((void (*) (id, SEL, id))objc_msgSend)(inst, sel, value);
    }
    else{
        SLLog(@"unSupported property:%@ %@", propName, [NSString stringWithUTF8String:propAttrib]);
    }

}

- (void)forwardFromBaseViewController:(UIViewController *)base withPageId:(NSString *)pageId paramStr:(NSString *)paramStr{
    NSError *error = nil;
    NSDictionary *paramDic = nil;
    if (paramStr.length) {
        id param = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:paramStr.UTF8String length:strlen(paramStr.UTF8String)] options:0 error:&error];
        if(!error){
            if ([param isKindOfClass:[NSDictionary class]]) {
                paramDic = param;
            }
            else{
                SLog(@"paramStr is not a dictionary!");
                return;
            }
        }
        else{
            SLog(@"failed with error: %@", error.userInfo);
            return;
        }
    }
    
    [self forwardFromBaseViewController:base withPageId:pageId paramDic:paramDic];
    
//    id inst = [self initByClassName:"TaskDetailViewController"];
//    //id inst = [[TaskDetailViewController alloc] init];
//    //SEL initSel =NSSelectorFromString(@"init");
//    //objc_msgSend(inst, initSel);
////    IMP initImp=[inst methodForSelector:initSel];
////    initImp();
//    id model = [self initByClassName:"TaskModel"];
//    //id model = [[TaskModel alloc] init];
//    
//    SEL sel = NSSelectorFromString(@"setId:");
//    ((void (*) (id, SEL, int))objc_msgSend)(model, sel, 18);
//
//    //callInstSel(modal, @"setId:", 1);
//    sel = NSSelectorFromString(@"setTModel:");
//    ((void (*) (id, SEL, id))objc_msgSend)(inst, sel, model);
//
//    //objc_msgSend(inst, sel, model);
//    //callInstSel(inst, @"setTModel:", model);
//    
//    id nav = ((id (*) (id, SEL))objc_msgSend)(base, NSSelectorFromString(@"navigationController"));
//    ((void (*) (id, SEL, id, BOOL))objc_msgSend)(nav, NSSelectorFromString(@"pushViewController:animated:"), inst, YES);
}

- (void)forwardFromBaseViewController:(UIViewController *)base withPageId:(NSString *)pageId paramDic:(NSDictionary *)paramDic{
    NSDictionary *forward = [tableDic_ objectForKey:[pageId description]];
    if (!forward) {
        SLLog(@"unSupport pageId:%@, param:%@", pageId, paramDic);
        return;
    }
    
    if ([forward objectForKey:@"isNeedLogin"] && [[forward objectForKey:@"isNeedLogin"] boolValue]) {
//        [UserLoginManager checkToLoginWithBaseController:base Successed:^(LoginResponse *result) {
//            [self forwardInnerFromBaseViewController:base withPageId:pageId paramDic:paramDic];
//        } canceled:^{
//            
//        } failure:^(NSError *error) {
//            [Tip tipError:error.localizedDescription OnView:base.view];
//        }];
        
    }
    else{
        [self forwardInnerFromBaseViewController:base withPageId:pageId paramDic:paramDic];
    }
}

- (id)initByClassName:(NSString *)name{
    Class cls = NSClassFromString(name);
//    Method allocM = class_getClassMethod(cls, @selector(alloc));
//    id inst = method_getImplementation(allocM)(cls, @selector(alloc));
//    SEL initSel =NSSelectorFromString(@"init");
//    IMP initImp=[inst methodForSelector:initSel];
//    id ret = initImp(inst, initSel);
    id ret = [[cls alloc] init];
    return ret;
}

//id callInstSel(id inst, NSString *selName ,...){
//    Class cls = object_getClass(inst);
//    SEL sel = NSSelectorFromString(selName);
//
//    va_list args;
//    va_start(args, selName);
//    id ret = ((void (*) (id, SEL, ...))objc_msgSend)(inst, sel, args);
//    va_end(args);
//    return ret;
//}

@end
