//
//  ProjectUtil.m
//  jimao
//
//  Created by pan chow on 14/11/26.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "ProjectUtil.h"
#import "CommonUtil.h"
#import "ProjectStructDef.h"

#import "WebViewController.h"
#import "WebService.h"
#import "AppDelegate.h"
//#import "EncrypteWrapper.h"

@implementation ProjectUtil

SINGLETON_GCD(ProjectUtil);

#pragma mark --- AD 跳转 ---
+ (void)jumpFromAdViewWithType:(NSInteger)openType
                       openUrl:(NSString *)url
            clientRedirectType:(NSInteger)redirectType
                         objId:(NSInteger)objId
                   baseViewCtl:(UIViewController *)viewCtl
                    shareImage:(UIImage *)shareImage
                         title:(NSString *)title
{
    [ProjectUtil jumpFromAdViewWithType:openType openUrl:url clientRedirectType:redirectType objId:objId baseViewCtl:viewCtl shareImage:shareImage title:title taskId:nil];
}
+ (void)jumpFromAdViewWithType:(NSInteger)openType
                       openUrl:(NSString *)url
            clientRedirectType:(NSInteger)redirectType
                         objId:(NSInteger)objId
                   baseViewCtl:(UIViewController *)viewCtl
                    shareImage:(UIImage *)shareImage
                         title:(NSString *)title
                        taskId:(NSString *)taskId
{
    
}

#pragma mark --- 默认文本格式 ---
+ (NSAttributedString *)getAttributeStringFrom:(NSString *)text font:(UIFont *)font
{
    NSParagraphStyle *defaultStyle = [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = defaultStyle.alignment;
    style.lineBreakMode = defaultStyle.lineBreakMode;
    style.lineSpacing = 3.0;
    style.firstLineHeadIndent=0.0f;
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
    
    NSAttributedString *attribText = [[NSAttributedString alloc] initWithString:text attributes:attrsDictionary];
    return attribText;
}
#pragma mark --- 默认文本格式字典 ---
+ (NSDictionary *)getAttributeDicWithFont:(UIFont *)font
{
    NSParagraphStyle *defaultStyle = [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = defaultStyle.alignment;
    style.lineBreakMode = defaultStyle.lineBreakMode;
    style.lineSpacing = 4.0;
    style.firstLineHeadIndent=0.0f;
    
//    NSShadow *shadow=[[NSShadow alloc] init];
//    [shadow setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
//    
//    [shadow setShadowBlurRadius:4.0];
//    
//    [shadow setShadowOffset:CGSizeMake(0, 0)];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:NSTextEffectLetterpressStyle,NSTextEffectAttributeName,font, NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
    
    return attrsDictionary;
}


+ (void)loadImg:(UIImage *)img toImgView:(UIImageView *)imgView maxSize:(CGSize)aSize
{
    CGPoint center=imgView.center;
    CGSize size=[CommonUtil fitSize:img.size inSize:aSize];
    imgView.image=img;
    imgView.bounds=CGRectMake(0, 0, size.width, size.height);
    imgView.center=center;
}


+ (NSArray *)sharedPcDate
{
    static NSArray *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance =  [CommonUtil getObjFromBundleWithName:@"area" type:@"js"];
    });
    return sharedInstance;
}
+ (NSString *)stringDesWithPId:(NSInteger)pId cId:(NSInteger )cId
{
    NSArray *array=[ProjectUtil sharedPcDate];
    
    __block NSString *pString=@"";
    __block NSString *cString=@"";
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *pDic=obj;
        if([pDic[@"pId"] integerValue]==pId)
        {
            pString=pDic[@"pName"];
            
            NSArray *cArray=pDic[@"citys"];
            [cArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *cDic=obj;
                
                if(([cDic[@"cId"] integerValue]==cId) && (cId!=0))
                {
                    cString=cDic[@"cName"];
                    *stop=YES;
                }
            }];
            *stop=YES;
        }
    }];
    return [NSString stringWithFormat:@"%@  %@",pString,cString];
}

+ (NSString *)stringPriviceWithPId:(NSInteger)pId
{
    NSArray *array=[ProjectUtil sharedPcDate];
    
    __block NSString *pString=@"";
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *pDic=obj;
        if([pDic[@"pId"] integerValue]==pId)
        {
            pString=pDic[@"pName"];
            *stop=YES;
        }
    }];
    return [NSString stringWithFormat:@"%@",pString];
}

+ (void)IndexOfPId:(NSInteger)pId toPIndex:(NSInteger *)pIndex cId:(NSInteger )cId toCIndex:(NSInteger *)cIndex
{
    NSArray *array=[ProjectUtil sharedPcDate];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *pDic=obj;
        if([pDic[@"pId"] integerValue]==pId)
        {
            *pIndex=idx;
            
            NSArray *cArray=pDic[@"citys"];
            [cArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *cDic=obj;
                
                if([cDic[@"cId"] integerValue]==cId)
                {
                    *cIndex=idx;
                    *stop=YES;
                }
            }];
            *stop=YES;
        }
    }];
}

//活动跳转
+ (void)gotoActivity:(NSString *)url BaseController:baseCtrl
{
    WebViewController *ctrl = [[WebViewController alloc] init];
    ctrl.urlString = url;
    [baseCtrl pushViewController:ctrl animated:YES];
}

+ (UIImage *)placeHolderImageOfSize:(CGSize)size{
    //todo
    CGRect imageRect = CGRectMake(0, 0, size.width, size.height);
    UIImage *centerImage = [UIImage imageNamed:AD_PLACEHODER_IMG_NAME];
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, 0, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.926 green:0.900 blue:0.812 alpha:1.000].CGColor);
    CGContextFillRect(context, imageRect);
    [centerImage drawInRect:CGRectMake((size.width-centerImage.size.width)/2.0f, (size.height-centerImage.size.height)/2.0f, centerImage.size.width, centerImage.size.height)];
    //CGContextDrawImage(context, CGRectMake((size.width-centerImage.size.width)/2.0f, (size.height-centerImage.size.height)/2.0f, centerImage.size.width, centerImage.size.height), centerImage.CGImage);
    
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (void)gotoHome{
//    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDele.sideMenuViewController hideMenuViewController];
//    UITabBarController *tabControl = (UITabBarController *)appDele.sideMenuViewController.contentViewController;
//    [(UINavigationController *)tabControl.selectedViewController popToRootViewControllerAnimated:NO];
//    [self performSelector:@selector(setTabControlToFirstPage:) withObject:tabControl afterDelay:.3f];
}
+ (void)setTabControlToFirstPage:(UITabBarController *)tabControl{
    tabControl.selectedIndex = 0;
}
#pragma mark --- user login name ---
+ (NSString *)getPreLoginNameFromLocal
{
    NSString *loginName = [CommonHelper stringFromUserDefaultsWithKey:@"USER_LOGIN_NAME"];
    return loginName;
}
+ (void)saveUserLoginNameToLocal:(NSString *)name
{
    if(![CommonHelper stringIsEmpty:name])
    {
        [CommonHelper setString:name toUserDefaultsWithKey:@"USER_LOGIN_NAME"];
    }
}

+ (NSString *)getPreLoginPwdFromLocal
{
    NSString *loginName = [CommonHelper stringFromUserDefaultsWithKey:@"USER_LOGIN_PWD"];
    return loginName;
}
//+ (void)saveUserLoginPwdToLocal:(NSString *)name
//{
//    if(![CommonHelper stringIsEmpty:name])
//    {
//        NSString *enPwd = [ProjectUtil getPreLoginPwdFromLocal];
//        if([CommonHelper stringIsEmpty:enPwd])
//        {
//            enPwd = [[EncrypteWrapper sharedInstance] encryptPassword:[CommonHelper trimString:name]];
//            [CommonHelper setString:enPwd toUserDefaultsWithKey:@"USER_LOGIN_PWD"];
//        }
//    }
//}
+ (void)clearPwd
{
    NSString *enPwd = [ProjectUtil getPreLoginPwdFromLocal];
    if(![CommonHelper stringIsEmpty:enPwd])
    {
        [CommonHelper removeStringWithKey:@"USER_LOGIN_PWD"];
    }
}
//+ (NSString *)encryPwd:(NSString *)pwd
//{
//    NSString *enPwd = [[EncrypteWrapper sharedInstance] encryptPassword:pwd];
//    return enPwd;
//}
@end
