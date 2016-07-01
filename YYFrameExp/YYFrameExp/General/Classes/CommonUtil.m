//
//  CommonUtil.m
//  FlowExp
//
//  Created by pan chow on 14-4-10.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "CommonUtil.h"
#import "FlowCatKeyChainUtil.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation CommonUtil

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
+ (NSUInteger)SystemVersion
{
    static NSUInteger systemVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return systemVersion;
}


/**
 *	@brief	去掉号码字串中特殊字串以及空格，如电话号码去@"+86",@"-",@"",etc
 *
 *	@param 	anPhoneNum 	字串
 *	@param 	delArray 	删除的特殊字串数组
 *
 *	@return	过滤后的字串
 */
- (NSString *)formatPhoneNum:(NSString *)anPhoneNum delArray:(NSArray *)delArray

{
    NSMutableString *tmpNum=[NSMutableString stringWithString:anPhoneNum];
    NSArray *deleteArray=[NSArray arrayWithArray:delArray];
    
    NSInteger count=[deleteArray count];
    for(int i=0;i<count;i++)
    {
        NSRange range=[tmpNum rangeOfString:[deleteArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            [tmpNum replaceOccurrencesOfString: [deleteArray objectAtIndex:i]
                                    withString: @""
                                       options: NSLiteralSearch
                                         range: NSMakeRange(0, [tmpNum length])];
        }
    }
    return [tmpNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//据text使label自适应大小，最小高度=rowHeight
+ (void)reSizeLabel:(UILabel *)label withText:(NSString *)text rowHeight:(NSInteger)rowHeight
{
    label.text = text;
    if (text.length == 0)
    {
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.bounds.size.width,rowHeight);
        return;
    }
    CGSize size = [text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, 1000) lineBreakMode:label.lineBreakMode];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.bounds.size.width, roundf(size.height / rowHeight) * rowHeight);
}
+ (void)reSizeLabel:(UILabel *)label withText:(NSString *)text rowWidth:(NSInteger)width
{
    label.text = text;
    if (text.length == 0)
    {
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,width, label.bounds.size.height);
        return;
    }
    CGSize size = [text sizeWithFont:label.font constrainedToSize:CGSizeMake( 1000,label.bounds.size.height) lineBreakMode:label.lineBreakMode];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,roundf(size.width / width) * width, label.bounds.size.height);
}
+ (NSInteger)heightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width rowHeight:(NSInteger)rowHeight
{
    if (text.length == 0)
    {
        return rowHeight;
    }
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000)];
    return roundf(size.height / rowHeight) * rowHeight;
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
    if([CommonUtil isCameraAvailabel] && [CommonUtil doesCameraSupportTakingPhotos])
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
    if([CommonUtil isPhotoLibraryAvailable])
    {
        UIImagePickerController *controller=[[UIImagePickerController alloc] init];
        controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing=YES;
        NSMutableArray *mediaTypes=[NSMutableArray array];
        if([CommonUtil canUserPickPhotosFromLibrary])
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
    if([CommonUtil stringIsEmpty:anStr])
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
    });
    return sharedInstance;
}
+ (UIDatePicker *)sharedDatePicker
{
    static UIDatePicker *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance =  [[UIDatePicker alloc] init];
        sharedInstance.datePickerMode=UIDatePickerModeDate;
    });
    return sharedInstance;
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
    if([CommonUtil stringIsEmpty:string])
    {
        return nil;
    }
    return string;
}
#pragma mark --- regex ---
+(BOOL)strMatches:(NSString *)strM MatchseType:(CustomRegexMatchesType)matchsType
{
    NSString *regex=@"";
    switch (matchsType)
    {
        case CustomRegexMatchesChinese:
        {
            regex=@"[\\u4e00-\\u9fa5]{1,10}";
            break;
        }
        case CustomRegexMatchesDoubleByte:
        {
            regex=@"[^\\x00-\\xff]";
            break;
        }
        case CustomRegexMatchesBlank:
        {
            regex=@"^\\s*$";
            break;
        }
        case CustomRegexMatchesBlankLine:
        {
            regex=@"\\n\\s*\\r";
            break;
        }
        case CustomRegexMatchesHTML:
        {
            regex=@"<(\\S*?)[^>]*>.*?</\\1>|<.*? />";
            break;
        }
        case CustomRegexMatchesMargin:
        {
            regex=@"^\\s*|\\s*$";
            break;
        }
        case CustomRegexMatchesEmail:
        {
            regex=@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
            break;
        }
        case CustomRegexMatchesURL:
        {
            regex=@"[a-zA-z]+://[^\\s]*";
            break;
        }
        case CustomRegexMatchesAccount:
        {
            regex=@"^[a-zA-Z][a-zA-Z0-9_]{4,15}$";
            break;
        }
        case CustomRegexMatchesPhone:
        {
            regex=@"\\d{3}-\\d{8}|\\d{4}-\\d{7}";
            break;
        }
        case CustomRegexMatchesMobile:
        {
            regex=@"^[1]+\\d{10}";
            break;
        }
        case CustomRegexMatchesMobileAndPhone:
        {
            regex=@"(^(\\d{3,4})?\\d{7,8})$|(^[1]+\\d{10})";
            break;
        }
        case CustomRegexMatchesQQ:
        {
            regex=@"[1-9][0-9]{4,15}";
            break;
        }
        case CustomRegexMatchesZipCode:
        {
            regex=@"[1-9]\\d{5}(?!\\d)";
            break;
        }
        case CustomRegexMatchesIdentityCard:
        {
            regex=@"\\d{15}|\\d{18}";
            break;
        }
        case CustomRegexMatchesIP:
        {
            regex=@"\\d+\\.\\d+\\.\\d+\\.\\d+";
            break;
        }
        case CustomRegexMatchesPositiveInt:
        {
            regex=@"^[1-9]\\d*$";
            break;
        }
        case CustomRegexMatchesNegativeInt:
        {
            regex=@"^-[1-9]\\d*$";
            break;
        }
        case CustomRegexMatchesInt:
        {
            regex=@"^-?[1-9]\\d*$";
            break;
        }
        case CustomRegexMatchesNonnegativeInt:
        {
            regex=@"^[1-9]\\d*|0$";
            break;
        }
        case CustomRegexMatchesNonpositiveInt:
        {
            regex=@"^-[1-9]\\d*|0$";
            break;
        }
        case CustomRegexMatchesRealmin:
        {
            regex=@"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
            break;
        }
        case CustomRegexMatchesNoRealmin:
        {
            regex=@"^-([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*)$";
            break;
        }
        case CustomRegexMatchesFloat:
        {
            regex=@"^-?([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*|0?\\.0+|0)$";
            break;
        }
        case CustomRegexMatchesNonnegativeFloat:
        {
            regex=@"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*|0?\\.0+|0$";
            break;
        }
        case CustomRegexMatchesNonpositiveFloat:
        {
            regex=@"^(-([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*))|0?\\.0+|0$";
            break;
        }
        case CustomRegexMatchesCharacter:
        {
            regex=@"^[A-Za-z]+$";
            break;
        }
        case CustomRegexMatchesUpperCharacter:
        {
            regex=@"^[A-Z]+$";
            break;
        }
        case CustomRegexMatchesLowerCharacter:
        {
            regex=@"^[a-z]+$";
            break;
        }
        case CustomRegexMatchesNumberAndCharacter:
        {
            regex=@"^[A-Za-z0-9]+$";
            break;
        }
        case CustomRegexMatchesNumberAndCharacterAndUnderline:
        {
            regex=@"^\\w+$";
            break;
        }
        case CustomRegexMatchesFlightNumber:
        {
            regex=@"^[a-zA-Z0-9]{2}[a-zA-Z0-9]{1,5}$";
            break;
        }
        default:
            break;
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:strM];
}

+ (NSString *)latestVersionFromAppStore
{
    NSURL *url=[NSURL URLWithString:APP_INFO_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(!response)
    {
        return nil;
    }
    NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *infoArray = [infoDic objectForKey:@"results"];
    if (!infoArray || infoArray.count == 0)
    {
        return nil;
    }
    
    NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
    NSString *version = [releaseInfo objectForKey:@"version"];
    return version;
}
+ (NSString *)markPhoneNumWithStar:(NSString *)phoneNum
{
    if([CommonUtil stringIsEmpty:phoneNum])
    {
        return nil;
    }
    NSMutableString *string=[NSMutableString stringWithString:phoneNum];
    [string replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return string;
}
#pragma mark --- 计算字符个数 ---
+ (int)statWordsCount:(NSString *)str
{
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
#pragma mark --- 获取GUID ---
+ (NSString *)gen_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    uuid=[CommonUtil formatString:uuid withKeyArray:@[@"-"]];
    return uuid;
}
+ (NSString *)getGUIDFromKeychain
{
    NSString *guid=nil;
    guid=[FlowCatKeyChainUtil getGUIDFromKeyChain];
    if([CommonUtil stringIsEmpty:guid])
    {
        guid=[CommonUtil gen_uuid];
        [FlowCatKeyChainUtil saveguid:guid];
    }
    return guid;
}


+ (void)getAppStoreId:(NSString **)pAppId url:(NSString **)pAppUrl fromIdOrUrl:(NSString *)idOrUrl{
    if ([CommonUtil strMatches:idOrUrl MatchseType:CustomRegexMatchesInt]) {
        if (pAppId) {
            *pAppId = idOrUrl;
        }
        if (pAppUrl) {
            *pAppUrl = [CommonUtil appStoreUrlFromAppStoreId:idOrUrl];
        }
    }
    else{
        if (pAppId) {
            *pAppId = [CommonUtil appStoreIdFromUrl:idOrUrl];
        }
        if (pAppUrl) {
            *pAppUrl = idOrUrl;
        }

    }
}
+ (NSString *)appStoreIdFromUrl:(NSString *)url{
    NSRange startRange = [url rangeOfString:@"/id"];
    if (startRange.location == NSNotFound) {
        return nil;
    }
    
    int i = startRange.location + startRange.length;
    for (; i<url.length; i++) {
        unichar ch = [url characterAtIndex:i];
        if (ch >= '0' && ch <= '9') {
            //isdiget
        }
        else{
            break;
        }
    }
    
    NSRange range;
    range.location = startRange.location + startRange.length;
    range.length = i - range.location;
    NSString *appId = [url substringWithRange:range];
    return appId;
}
+ (NSString *)appStoreUrlFromAppStoreId:(NSString *)appStroreId{
    NSString *appStoreUrl = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", appStroreId];
    return appStoreUrl;
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
#pragma mark --- 查看某个view所有可能的布局（仅在该view上才起作用） ---
+ (void)exeAmbiguityLOutForView:(UIView *)vw
{
    [vw exerciseAmbiguityInLayout];
}
//人性化描述时间方案1
+ (NSString *)descriptionFromDate:(NSDate *)date now:(NSDate *)now
{
    if (!date)
    {
        return nil;
    }
    if (!now)
    {
        now = [NSDate date];
    }
    NSTimeInterval interval = [date timeIntervalSinceDate:now];
    if ( -interval < 60)
    {
        return @"刚刚";
    }
    if ( -interval < 3600)//60min
    {
        NSInteger min = floor( -interval / 60);
        return [NSString stringWithFormat:@"%d分钟前",min];
    }
    if ( -interval < 3600 * 24) //24hour
    {
        NSInteger hour = floor( -interval / 3600);
        return [NSString stringWithFormat:@"%d小时前",hour];
    }
    
    NSDateFormatter * fmt = [CommonUtil sharedDateFormmater];
    [fmt setDateFormat:@"MM-dd HH:mm"];
    return [fmt stringFromDate:date];
    
    /********/
    int dayFrom = (int)( -interval / 86400);
    
    if (dayFrom == 0)
    {
        [fmt setDateFormat:@"今天 HH:mm"];
        return [fmt stringFromDate:date];
    }
    if (dayFrom == 1) {
        [fmt setDateFormat:@"昨天 HH:mm"];
        return [fmt stringFromDate:date];
    }
    if (dayFrom == 2)
    {
        [fmt setDateFormat:@"前天 HH:mm"];
        return [fmt stringFromDate:date];
    }
    [fmt setDateFormat:@"MM-dd"];
    return [fmt stringFromDate:date];
}
//人性化描述时间方案2
+ (NSString *)descriptionFromTime:(NSDate *)date now:(NSDate *)now
{
    if (!date)
    {
        return nil;
    }
    if (!now)
    {
        now = [NSDate date];
    }
    NSTimeInterval interval = [date timeIntervalSinceDate:now];
    if ( -interval < 60)
    {
        return @"刚刚";
    }
    if ( -interval < 1800)
    {
        NSInteger min = floor( -interval / 60);//向下舍入
        return [NSString stringWithFormat:@"%d分钟前",min];
    }
    
    NSDateFormatter * fmt = [CommonUtil sharedDateFormmater];
    int dayFrom = (int)( -interval / 86400);
    
    if (dayFrom == 0)
    {
        [fmt setDateFormat:@"今天 HH:mm"];
        return [fmt stringFromDate:date];
    }
    if (dayFrom == 1) {
        [fmt setDateFormat:@"昨天 HH:mm"];
        return [fmt stringFromDate:date];
    }
    if (dayFrom == 2)
    {
        [fmt setDateFormat:@"前天 HH:mm"];
        return [fmt stringFromDate:date];
    }
    [fmt setDateFormat:@"MM-dd HH:mm"];
    return [fmt stringFromDate:date];
}
+ (BOOL)isEnableRemotePush
{
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIUserNotificationType types;
            types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
            return (types & UIRemoteNotificationTypeAlert);
        }
        else
        {
            UIRemoteNotificationType types;
            types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            return (types & UIRemoteNotificationTypeAlert);
        }
        
    }

}

+ (BOOL)isEnableNotification{
    if ([CommonUtil SystemVersion]>=8){
        return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else{
        return [[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone;
        
    }
}



+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)sha1:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    int i =0;
    int len = strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}




#pragma mark =========支付宝返回支付后的提示信息==============
+(NSString *)ResultPayDescript:(int )resultStr
{
    switch (resultStr) {
        case 9000:
        {
            return GetString(@"payment_success", @"");
            break;
        }
        case 4000:
        {
            return GetString(@"payment_error", @"");
            break;
        }
        case 4001:
        {
            return GetString(@"payment_format_error", @"");
            break;
        }
        case 4003:
        {
            return GetString(@"payment_unper_error", @"");
            break;
        }
        case 4004:
        {
            return GetString(@"payment_user_error", @"");
            break;
        }
        case 4005:
        {
            return GetString(@"payment_band_error", @"");
            break;
        }
        case 4006:
        {
            return GetString(@"payment_payment_error", @"");
            break;
        }
        case 4010:
        {
            return GetString(@"payment_band_again", @"");
            break;
        }
        case 6000:
        {
            return GetString(@"payment_upgreat", @"");
            break;
        }
        case 6001:
        {
            return GetString(@"payment_interrupt_error", @"");
            break;
        }
        default: return GetString(@"payment_net_error", @"");
            break;
    }
}



@end
