//
//  CommonHelper.m
//  jimao
//
//  Created by Dongle Su on 14-11-25.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "CommonHelper.h"
#import "CommonUtil.h"
#import "RegExHelper.h"
#import "WebService.h"
#import "Tip.h"
#import "QRCodeViewController.h"
#import "WebViewController.h"
#import "ForwardCenter.h"

@implementation CommonHelper
+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class )aclass{
    id ret = nil;
    for (id obj in [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil]) {
        if ([obj isKindOfClass:aclass]) {
            ret = obj;
            break;
        }
    }
    return ret;
}

#pragma mark ---  public  ---
+ (AppDelegate *)getApp
{
    AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    return del;
}
+ (UIWindow *)getAppWindow
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

#pragma mark ---string---
+ (BOOL)stringIsEmpty:(NSString *)string
{
    if (!string || ![string isKindOfClass:[NSString class]] ||string.length == 0)
    {
        return YES;
    }
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}
+ (NSString *)trimString:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
+ (BOOL)isContainsubStr:(NSString *)sub_str inStr:(NSString *)str
{
    return [str rangeOfString:sub_str].location !=NSNotFound;
}
+ (NSString *)formatString:(NSString *)anStr withKeyArray:(NSArray *)anArray
{
    if([CommonHelper stringIsEmpty:anStr])
    {
        return @"";
    }
    NSMutableString *tmpMutableStr=[NSMutableString stringWithString:anStr];
    NSArray *deleteArray=[NSArray arrayWithArray:anArray];
    
    NSInteger count=[deleteArray count];
    for(int i=0;i<count;i++)
    {
        NSRange range=[tmpMutableStr rangeOfString:[deleteArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            [tmpMutableStr replaceOccurrencesOfString: [deleteArray objectAtIndex:i]
                                           withString: @""
                                              options: NSLiteralSearch
                                                range: NSMakeRange(0, [tmpMutableStr length])];
        }
    }
    return [[self class] trimString:tmpMutableStr];
    
}

+ (NSDateFormatter *)sharedDateFormmater
{
    static NSDateFormatter *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance =  [[NSDateFormatter alloc] init];
        [sharedInstance setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [sharedInstance  setLocale:[NSLocale systemLocale]];
    });
    return sharedInstance;
}
+ (NSString *)getPrettySize:(int)size
{
    float prettySize;
    NSString *pretty;
    if (size > 1024*1024*1024) { //G
        prettySize = ((float)size)/(1024*1024*1024);
        pretty = [NSString stringWithFormat:@"%.2fG", prettySize];
    }
    else if (size > 1024*1024){ //M
        prettySize = ((float)size)/(1024*1024);
        pretty = [NSString stringWithFormat:@"%.2fM", prettySize];
    }
    else if (size > 1024){ //K
        prettySize = ((float)size)/1024;
        pretty = [NSString stringWithFormat:@"%.2fK", prettySize];
    }
    else{
        pretty = [NSString stringWithFormat:@"%dB", size];
    }
    
    return pretty;
}

+ (NSString *)getPrettyCount:(NSInteger)count
{
    float prettyCount;
    NSString *pretty;
    if (count > 10000*10000) { //亿
        prettyCount = ((float)count)/(10000*10000);
        pretty = [NSString stringWithFormat:@"%.1f亿", prettyCount];
    }
    else if (count > 10000){ //万
        prettyCount = ((float)count)/10000;
        pretty = [NSString stringWithFormat:@"%.1f万", prettyCount];
    }
    else{
        pretty = [NSString stringWithFormat:@"%ld", (long)count];
    }
    return pretty;
}
+ (NSString *)getPrettyCountUti99:(NSInteger)count
{
    NSString *pretty;
     if (count > 999999){
        pretty = [NSString stringWithFormat:@"99W+"];
    }
    else{
        pretty = [NSString stringWithFormat:@"%ld", (long)count];
    }
    return pretty;
}
+ (NSString *)getPrettyCountWith_K_W:(NSInteger)count//千、万 ：K、K+、W、W+
{
    NSString *pretty;
    if(count < 1000)
    {
        pretty = [NSString stringWithFormat:@"%ld",count];
    }
    else if (count < 10000)
    {
        if(count%1000 == 0)
        {
            pretty = [NSString stringWithFormat:@"%ldK",count/1000];
        }
        else
        {
            pretty = [NSString stringWithFormat:@"%ldK+",count/1000];
        }
    }
    else
    {
        if(count%10000 == 0)
        {
            pretty = [NSString stringWithFormat:@"%dW",count/10000];
        }
        else
        {
            pretty = [NSString stringWithFormat:@"%ldW+",count/10000];
        }
    }
    return pretty;
}




//得到999+ k,w+,
+ (NSString *)getCountStringWith9999_K_W:(NSInteger)count
{
    NSString *pretty;
//    if(count < 1000)
//    {
//        pretty = [NSString stringWithFormat:@"%ld",(long)count];
//    }
//    else
    
    if (count < 10000)
    {
//        if(count%1000 == 0)
//        {
//            pretty = [NSString stringWithFormat:@"%dK",count/1000];
//        }
//        else
//        {
//            pretty = [NSString stringWithFormat:@"%dK+",count/1000];
//        }
        
        
        pretty = [NSString stringWithFormat:@"%ld",(long)count];
    }
    else
    {
//        if(count%10000 == 0)
//        {
//            pretty = [NSString stringWithFormat:@"%dW",count/10000];
//        }
//        else
//        {
            pretty = [NSString stringWithFormat:@"%dW+",count/10000];
//        }
    }
    return pretty;
}



+(NSString *)formatNumWithComma:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
#pragma mark --- file ---
+ (NSArray *)getArrayInfoFromByLocalPlistName:(NSString *)name
{
    NSString *path=[[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSArray *array=[NSArray arrayWithContentsOfFile:path];
    return array;
}

+ (NSDictionary *)getDicInfoFromByLocalPlistName:(NSString *)name
{
    NSString *path=[[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
}

+ (id)getObjFromBundleWithName:(NSString *)name type:(NSString *)type
{
    NSString *path=[[NSBundle mainBundle] pathForResource:name ofType:type];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path];
    id json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return json;
}
+ (NSUInteger)SystemVersion
{
    static NSUInteger systemVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return systemVersion;
}
#pragma mark --- AutoLayout下文本高度计算 ---
+ (CGFloat)findHeightForAttributedString:(NSAttributedString *)text havingWidth:(CGFloat)widthValue
{
    CGFloat result = .0f;//font.pointSize+4;
    if (text) {
        CGSize size;
        CGRect frame =[text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                         context:nil];
        
        size = CGSizeMake(frame.size.width, frame.size.height+1);
        result = MAX(size.height, result); //At least one row
    }
    return result;
}
#pragma mark ---  photoes  ---
//摄像头是否支持anMediaType功能
+ (BOOL)cameraSupportsMedia:(NSString *)anMediaType sorceType:(UIImagePickerControllerSourceType)sourceType
{
    __block BOOL result=NO;
    
    if(anMediaType.length==0)
    {
        return NO;
    }
    //摄像头支持的所有功能(摄像,录像)
    NSArray *availabelMediaTypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availabelMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType=(NSString *)obj;
        if([mediaType isEqualToString:anMediaType])
        {
            result=YES;
            *stop=YES;
        }
    }];
    return result;
}
//检测摄像头可用性
+ (BOOL)isCameraAvailabel
{
    BOOL valailabel=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    return valailabel;
}
//摄像
+ (BOOL) doesCameraSupportTakingPhotos
{
    BOOL result;
    result=[self cameraSupportsMedia:(NSString *)kUTTypeImage
                           sorceType:UIImagePickerControllerSourceTypeCamera];
    return result;
}

+ (BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL)canUserPickPhotosFromLibrary
{
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage
                           sorceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL)canUserPickVideosFromLibrary
{
    return [self cameraSupportsMedia:(NSString *)kUTTypeMovie
                           sorceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark ---  takephotoes  ---
//拍照
+ (void)takePhotoesWithController:(UIViewController<UIImagePickerControllerDelegate ,UINavigationControllerDelegate> *)viewCtl
{
    if([CommonHelper isCameraAvailabel] && [CommonHelper doesCameraSupportTakingPhotos])
    {
        UIImagePickerController *controller=[[UIImagePickerController alloc] init];
        controller.sourceType=UIImagePickerControllerSourceTypeCamera;
        
        NSString *requiredMediaType=(NSString *)kUTTypeImage;
        controller.mediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
        
        controller.allowsEditing=YES;
        controller.delegate=viewCtl;
        
        
        controller.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        controller.navigationBarHidden=YES;
        
        [viewCtl presentViewController:controller animated:YES completion:^{
            
        }];
    }
    else
    {
        SLog(@"Camera is not availabel");
    }
    
}
//自多媒体库中获取媒体资源
+ (void)getPhotoesAndVideosFromLibrayWithController:(UIViewController<UIImagePickerControllerDelegate ,UINavigationControllerDelegate> *)viewCtl
{
    if([CommonHelper isPhotoLibraryAvailable])
    {
        UIImagePickerController *controller=[[UIImagePickerController alloc] init];
        controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing=YES;
        
        viewCtl.edgesForExtendedLayout = UIRectEdgeNone;
        NSMutableArray *mediaTypes=[NSMutableArray array];
        if([CommonHelper canUserPickPhotosFromLibrary])
        {
            [mediaTypes addObject:(NSString *)kUTTypeImage];
        }
        
        controller.mediaTypes=mediaTypes;
        
        controller.delegate=viewCtl;
        [viewCtl presentViewController:controller animated:YES completion:^{
            
        }];
    }
    else
    {
        SLog(@"not supported PhotoLibrary");
    }
}
#pragma mark ---  archiver  ---
//归档obj数据
+ (NSData *)archiverDataFromObject:(id<NSCoding>)obj
{
    return [NSKeyedArchiver archivedDataWithRootObject:obj];
}
//解档data数据
+ (id)objectFromArchiverData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
+ (void)setString:(NSString *)string toUserDefaultsWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)stringFromUserDefaultsWithKey:(NSString *)key
{
    NSString *string=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if([CommonHelper stringIsEmpty:string])
    {
        return nil;
    }
    return string;
}
+ (void)removeStringWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark ---  keyboard  ---
+ (void)observeKeyboardEventWithTarget:(id)target sel:(SEL)selector willOrDid:(NSString *)willOrDid showOrHide:(NSString *)showOrHide
{
    NSString * notificationName = nil;
    if ([willOrDid isEqualToString:@"will"])
    {
        if ([showOrHide isEqualToString:@"show"])
        {
            notificationName = UIKeyboardWillShowNotification;
        }
        else
        {
            notificationName = UIKeyboardWillHideNotification;
        }
    }
    else
    {
        if ([showOrHide isEqualToString:@"show"])
        {
            notificationName = UIKeyboardDidShowNotification;
        }
        else
        {
            notificationName = UIKeyboardDidHideNotification;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:notificationName object:nil];
}
+ (NSTimeInterval)animationDurationFromKeyboardNotification:(NSNotification *)notification
{
    NSTimeInterval animationDuration;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    return animationDuration;
}

+ (CGRect)endFrameFromKeyboardNotification:(NSNotification *)notification
{
    CGRect keyboardEndFrame;
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    return keyboardEndFrame;
}

+ (UIViewAnimationCurve )animationCurveFromKeyboardNotification:(NSNotification *)notification
{
    UIViewAnimationCurve animationCurve;
    [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    return animationCurve;
}
//file size
+ (NSString *)fileSize:(NSString *)filePath
{
    NSError *error = nil;
    NSDictionary *attribs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (attribs) {
        NSString *string = [NSByteCountFormatter stringFromByteCount:[attribs fileSize] countStyle:NSByteCountFormatterCountStyleFile];
        
        return string;
    }
    return @"0";
}
+ (NSString *)descriptionMonth:(NSString *)monthString
{
    if([monthString isEqualToString:@"01"])
    {
        return @"一月";
    }
    else if([monthString isEqualToString:@"02"])
    {
        return @"二月";
    }
    else if([monthString isEqualToString:@"03"])
    {
        return @"三月";
    }
    else if([monthString isEqualToString:@"04"])
    {
        return @"四月";
    }
    else if([monthString isEqualToString:@"05"])
    {
        return @"五月";
    }
    else if([monthString isEqualToString:@"06"])
    {
        return @"六月";
    }
    else if([monthString isEqualToString:@"07"])
    {
        return @"七月";
    }
    else if([monthString isEqualToString:@"08"])
    {
        return @"八月";
    }
    else if([monthString isEqualToString:@"09"])
    {
        return @"九月";
    }
    else if([monthString isEqualToString:@"10"])
    {
        return @"十月";
    }
    else if([monthString isEqualToString:@"11"])
    {
        return @"十一月";
    }
    else if([monthString isEqualToString:@"12"])
    {
        return @"十二月";
    }
    return nil;
}
#pragma mark --- 计算字符个数 ---
+ (NSInteger)statWordsCount:(NSString *)str
{
    if([CommonHelper stringIsEmpty:str])
    {
        return 0;
    }
    else
    {
        return str.length;
    }
    
    int i,n=[str length],l=0,a=0,b=0;
    
    unichar c;
    for(i=0;i<n;i++){
        c=[str characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0)
    {
        return 0;
    }
    
    int num = l+(int)ceilf((float)(a+b)/2.0);
    return num;
}
+ (NSAttributedString *)getTFPlaceHolder:(NSString *)string color:(UIColor *)color
{
    NSString *text = string;
    NSMutableAttributedString *attribText = [[NSMutableAttributedString alloc] initWithString:text];
    [attribText beginEditing];
    NSRange range;
    range.location = 0;
    range.length = attribText.length;
    [attribText addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attribText endEditing];
    return attribText;
}

+ (BOOL)openURLInSafari:(NSString *)urlString
{
    UIApplication *application=[UIApplication sharedApplication];
    NSURL *url =[NSURL URLWithString:urlString];
    if ([application canOpenURL:url])
    {
        return [application openURL:url];
    }
    else
    {
        return NO;
    }
}

+ (NSArray *)getContentFromFile:(NSString *)fileName
{
    if([CommonHelper stringIsEmpty:fileName])
    {
        return nil;
    }
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * content =[fileManger contentsOfDirectoryAtPath:fileName error:&error];
    return content;
}
#pragma mark ======  search 搜索记录  ======
+ (NSArray *)getSearchHistoryArrayFromLoacal
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_history_list"];
    return array;
}
+ (void)saveSearchHistoryArray:(NSArray *)array
{
    if(array && array.count>0)
    {
        if(array.count > 10)
        {
            NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
            [mArray removeObjectsInRange:NSMakeRange(10, mArray.count - 10)];
            array = mArray;
        }
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"search_history_list"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [CommonHelper clearSearchHistory];
    }
}
+ (void)clearSearchHistory
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"search_history_list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark ======  发现 tipPath  ======
+ (BOOL)isFirstLoadImgWithURL:(NSString *)url
{
    NSString *url_md5 = [CommonUtil md5:url];
    NSString *url_md5_local = [[NSUserDefaults standardUserDefaults] objectForKey:url_md5];
    if(url_md5_local)
    {
        return NO;
    }
    [[self class] checkImgWithMd5_URL:url_md5];
    return YES;
}
+ (void)checkImgWithMd5_URL:(NSString *)url_md5
{
    [[NSUserDefaults standardUserDefaults] setObject:url_md5 forKey:url_md5];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
#pragma mark ======  tf_phone_formater  ======
+ (NSString *)phoneNumFormater:(NSString *)telNum
{
    if([CommonHelper stringIsEmpty:telNum])
    {
        return nil;
    }
    if([RegExHelper isMatchPhone:telNum])
    {
        telNum = [telNum stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        
        NSInteger divIndex = 3;
        while (telNum.length > 0) {
            NSString *subString = [telNum substringToIndex:MIN(telNum.length, divIndex)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == divIndex) {
                newString = [newString stringByAppendingString:@" "];
            }
            telNum = [telNum substringFromIndex:MIN(telNum.length, divIndex)];
            divIndex = 4;
        }
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    else
    {
        return nil;
    }
    
}
#pragma mark ======  二维码跳转  ======
+ (void)settingsWithQRCodeString:(NSString *)qr_string fromQRCtrl:(QRCodeViewController *)ctrl
{
    if([CommonHelper stringIsEmpty:qr_string])
    {
        return;
    }
    
    QR_Type qr_type = ctrl.qr_type;
    
    BOOL has_http_prefix = [[qr_string lowercaseString] hasPrefix:@"http://"] || [[qr_string lowercaseString] hasPrefix:@"https://"];
    
    NSString *custom_prefix = @"custom://";
    BOOL has_custom_prefix = [[qr_string lowercaseString] hasPrefix:custom_prefix];
    
    NSString *page_prefix = @"page://";
    BOOL has_page_prefix = [[qr_string lowercaseString] hasPrefix:page_prefix];
    
    NSString *flowcard_prefix = @"flowcard://";
    BOOL has_flowcard_prefix = [[qr_string lowercaseString] hasPrefix:flowcard_prefix];
    
    NSString *encypt_prefix = @"encrypt://";
    BOOL has_encypt_prefix = [[qr_string lowercaseString] hasPrefix:encypt_prefix];
    
    if(has_encypt_prefix)
    {
        //encypt
        NSString *encyptString = [qr_string substringFromIndex:encypt_prefix.length];
        
        //fwr
//        [[WebService sharedInstance] decryptQRStringWithEncrptString:encyptString Success:^(id jsonObj, NSInteger pageNo, NSInteger totalCount) {
//            //dispatch_async(dispatch_get_main_queue(), ^{
//                [CommonHelper settingsWithQRCodeString:[jsonObj objectForKey:@"decrypt"] fromQRCtrl:ctrl];
//            //});
//
//        } failure:^(NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [Tip tipError:error.localizedDescription OnView:nil];
//                
//                [ctrl pop];
//            });
//        }];
    }
    else if (has_http_prefix && (qr_type & QR_Type_HTTP))
    {
        //http,https
        dispatch_sync(dispatch_get_main_queue(), ^{
            WebViewController *web_ctrl = [[WebViewController alloc] init];
            web_ctrl.urlString = qr_string;
            [ctrl.navigationController pushViewController:web_ctrl animated:YES];
        });
    }
    else if (has_page_prefix && (qr_type & QR_Type_PAGE))
    {
        //page
        NSString *page_string = [qr_string substringFromIndex:page_prefix.length];
        
        NSArray *pageArray = [page_string componentsSeparatedByString:@";"];
        if(pageArray && pageArray.count == 2)
        {
            NSString *pageId = [NSString stringWithFormat:@"%@",pageArray[0]];
            
            NSString *valueString = [NSString stringWithFormat:@"%@",pageArray[1]];
            NSData *date = [valueString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:date options:0 error:&error];
            if(!error)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [[ForwardCenter sharedInstance] forwardFromBaseViewController:ctrl withPageId:pageId paramDic:dic];
                });
                
            }
        }
        else
        {
            [Tip tipError:@"不支持你扫描的二维码格式!" OnView:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [ctrl pop];
            });
        }
        
    }
    else if (has_custom_prefix && (qr_type & QR_Type_CUSTOM))//仅针对流量卡进入
    {
        //wap custom
        
        //dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *custom_string = [qr_string substringFromIndex:custom_prefix.length];
            
            NSArray *flowcardArray = [custom_string componentsSeparatedByString:@";"];
            
            if(flowcardArray && flowcardArray.count == 2)
            {
                NSString *card = [NSString stringWithFormat:@"%@",flowcardArray[0]];
                NSString *pwd = [NSString stringWithFormat:@"%@",flowcardArray[1]];
                
//                ChargeMainViewController *chargeCtrl = nil;
//                BOOL hasPushed = NO;
//                for(UIViewController *subCtrl in ctrl.navigationController.viewControllers)
//                {
//                    if([subCtrl isKindOfClass:[ChargeMainViewController class]])
//                    {
//                        chargeCtrl = (ChargeMainViewController *)subCtrl;
//                        hasPushed = YES;
//                        break;
//                    }
//                }
//                if(!chargeCtrl)
//                {
//                    chargeCtrl = [[ChargeMainViewController alloc] init];
//                }
//                
//                chargeCtrl.index = 1;
//                chargeCtrl.flowcard_num = card;
//                chargeCtrl.flowcard_pwd = pwd;
                
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    if(hasPushed)
//                    {
//                        [ctrl.navigationController popToViewController:chargeCtrl animated:YES];
//                    }
//                    else
//                    {
//                        [ctrl.navigationController pushViewController:chargeCtrl animated:YES];
//                    }
//                });
                
            }
            else
            {
                [Tip tipError:@"不支持你扫描的二维码格式!" OnView:nil];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [ctrl pop];
                });

            }
        //});
        
    }
    else if (has_flowcard_prefix && (qr_type & QR_Type_FLOWCARD))
    {
        //flowcard
        NSString *flowcard_string = [qr_string substringFromIndex:flowcard_prefix.length];
        
        NSArray *flowcardArray = [flowcard_string componentsSeparatedByString:@";"];
        
        if(flowcardArray && flowcardArray.count == 2)
        {
            NSString *card = [NSString stringWithFormat:@"%@",flowcardArray[0]];
            NSString *pwd = [NSString stringWithFormat:@"%@",flowcardArray[1]];
            
//            ChargeMainViewController *chargeCtrl = nil;
//            BOOL hasPushed = NO;
//            for(UIViewController *subCtrl in ctrl.navigationController.viewControllers)
//            {
//                if([subCtrl isKindOfClass:[ChargeMainViewController class]])
//                {
//                    chargeCtrl = (ChargeMainViewController *)subCtrl;
//                    hasPushed = YES;
//                    break;
//                }
//            }
//            if(!chargeCtrl)
//            {
//                chargeCtrl = [[ChargeMainViewController alloc] init];
//            }
//            
//            chargeCtrl.index = 1;
//            chargeCtrl.flowcard_num = card;
//            chargeCtrl.flowcard_pwd = pwd;
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                if(hasPushed)
//                {
//                    [ctrl.navigationController popToViewController:chargeCtrl animated:YES];
//                }
//                else
//                {
//                    [ctrl.navigationController pushViewController:chargeCtrl animated:YES];
//                }
//            });
            
        }
        else
        {
            [Tip tipError:@"不支持你扫描的二维码格式!" OnView:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [ctrl pop];
            });
        }
    }
    else
    {
        [Tip tipError:@"不支持你扫描的二维码格式!" OnView:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [ctrl pop];
        });
        //[ctrl performSelector:@selector(pop) withObject:nil afterDelay:.8];
    }
}
#pragma mark ---- img ----
//使thisSize适配aSize的比例大小--thisSize=imgSize;aSize=imgViewSize
+ (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize
{
    if (thisSize.width <= aSize.width && thisSize.height <= aSize.height)
    {
        return thisSize;
    }
    CGFloat scale;
    CGSize newsize = thisSize;
    
    if (newsize.height && (newsize.height > aSize.height)) {
        scale = aSize.height / newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    
    if (newsize.width && (newsize.width > aSize.width)) {
        scale = aSize.width / newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    newsize.width = roundf(newsize.width);
    newsize.height = roundf(newsize.height);
    return newsize;
}
//小图适配至大图size
+ (CGSize)fitMinSize:(CGSize)thisSize inMaxSize:(CGSize)aSize
{
    if (CGSizeEqualToSize(thisSize, aSize))
    {
        return aSize;
    }
    CGSize newsize = thisSize;
    CGFloat scale = thisSize.height/thisSize.width;
    
    newsize.width = aSize.width;
    newsize.height = newsize.width*scale;
    newsize.width = roundf(newsize.width);
    newsize.height = roundf(newsize.height);
    return newsize;
}

@end
