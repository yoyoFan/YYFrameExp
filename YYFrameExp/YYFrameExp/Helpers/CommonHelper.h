//
//  CommonHelper.h
//  jimao
//
//  Created by Dongle Su on 14-11-25.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@class QRCodeViewController;

@interface CommonHelper : NSObject
+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class )aclass;
+ (AppDelegate *)getApp;
+ (UIWindow *)getAppWindow;

+ (BOOL)stringIsEmpty:(NSString *)string;
+ (NSString *)trimString:(NSString *)str;

+ (NSDateFormatter *)sharedDateFormmater;

+ (NSString *)getPrettySize:(int)size;
+ (NSString *)getPrettyCount:(NSInteger)count;
+ (NSString *)getPrettyCountUti99:(NSInteger)count;
+ (NSString *)getPrettyCountWith_K_W:(NSInteger)count;
+(NSString *)formatNumWithComma:(NSString *)num;

+ (NSArray *)getArrayInfoFromByLocalPlistName:(NSString *)name;
+ (NSDictionary *)getDicInfoFromByLocalPlistName:(NSString *)name;
+ (id)getObjFromBundleWithName:(NSString *)name type:(NSString *)type;


//得到9999+  ,w+,
+ (NSString *)getCountStringWith9999_K_W:(NSInteger)count;


+ (NSUInteger)SystemVersion;

#pragma mark --- AutoLayout下文本高度计算 ---
+ (CGFloat)findHeightForAttributedString:(NSAttributedString *)text havingWidth:(CGFloat)widthValue;

+ (void)takePhotoesWithController:(UIViewController<UIImagePickerControllerDelegate ,UINavigationControllerDelegate> *)viewCtl;
+ (void)getPhotoesAndVideosFromLibrayWithController:(UIViewController<UIImagePickerControllerDelegate ,UINavigationControllerDelegate> *)viewCtl;

+ (NSData *)archiverDataFromObject:(id<NSCoding>)obj;
+ (id)objectFromArchiverData:(NSData *)data;
+ (void)setString:(NSString *)string toUserDefaultsWithKey:(NSString *)key;
+ (NSString *)stringFromUserDefaultsWithKey:(NSString *)key;
+ (void)removeStringWithKey:(NSString *)key;

+ (void)observeKeyboardEventWithTarget:(id)target sel:(SEL)selector willOrDid:(NSString *)willOrDid showOrHide:(NSString *)showOrHide;
+ (NSTimeInterval)animationDurationFromKeyboardNotification:(NSNotification *)notification;
+ (CGRect)endFrameFromKeyboardNotification:(NSNotification *)notification;
+ (UIViewAnimationCurve )animationCurveFromKeyboardNotification:(NSNotification *)notification;

+ (NSString *)formatString:(NSString *)anStr withKeyArray:(NSArray *)anArray;

+ (NSString *)descriptionMonth:(NSString *)monthString;
#pragma mark --- 计算字符个数 ---
+ (NSInteger)statWordsCount:(NSString *)str;

+ (NSAttributedString *)getTFPlaceHolder:(NSString *)string color:(UIColor *)color;

+ (BOOL)openURLInSafari:(NSString *)urlString;

+ (NSArray *)getContentFromFile:(NSString *)fileName;
#pragma mark ======  search 搜索记录  ======
+ (NSArray *)getSearchHistoryArrayFromLoacal;
+ (void)saveSearchHistoryArray:(NSArray *)array;
+ (void)clearSearchHistory;

+ (BOOL)isFirstLoadImgWithURL:(NSString *)url;

+ (NSString *)phoneNumFormater:(NSString *)telNum;

#pragma mark ======  二维码跳转  ======
+ (void)settingsWithQRCodeString:(NSString *)qr_string fromQRCtrl:(QRCodeViewController *)ctrl;

//使thisSize适配aSize的比例大小--thisSize=imgSize;aSize=imgViewSize
+ (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize;
+ (CGSize)fitMinSize:(CGSize)thisSize inMaxSize:(CGSize)aSize;
@end
