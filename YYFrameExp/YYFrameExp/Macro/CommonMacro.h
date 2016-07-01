//
//  CommonMacro.h
//  WithTrip
//
//  Created by pan zhou on 13-7-12.
//  Copyright (c) 2013年 pan zhou. All rights reserved.
//
#pragma mark ---  全局宏定义  ---

#ifndef WithTrip_CommonMacro_h
#define WithTrip_CommonMacro_h

#pragma mark --- code ---
//  单例模式宏

#define SINGLETON_GCD(classname)                        \
\
+ (classname *)sharedInstance {                      \
\
static dispatch_once_t pred;                        \
__strong static classname * shared##classname = nil;\
dispatch_once( &pred, ^{                            \
shared##classname = [[self alloc] init]; });    \
return shared##classname;                           \
}

#pragma mark --- settings ---
//debug&pro
#ifdef DEBUG

#define SLog(xx, ...)   NSLog(xx, ##__VA_ARGS__)
#define SLLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define SLLogInset(inset) \
SLLog(@"%s left=%f, top=%f, right=%f, bottom=%f", #inset, inset.left, inset.top, \
inset.right, inset.bottom)

#define SLLogRect(rect) \
SLLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y, \
rect.size.width, rect.size.height)

#define SLLogPoint(pt) \
SLLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)

#define SLLogSize(size) \
SLLog(@"%s w=%f, h=%f", #size, size.width, size.height)

#define SLLogColor(_COLOR) \
SLLog(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)

#define SLLogSuperViews(_VIEW) \
{ for (UIView* view = _VIEW; view; view = view.superview) { SLLog(@"%@", view); } }

#define SLLogSubViews(_VIEW) \
{ for (UIView* view in [_VIEW subviews]) { SLLog(@"%@", view); } }
#else
#define SLog(xx, ...)  ((void)0)
#define SLLog(xx, ...)  ((void)0)
#endif

//system version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//home dir
#define HOME_DIR [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:((float)r)/255.0 green:((float)g)/255.0 blue:((float)b)/255.0 alpha:1.0] 


#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define APP_SCREEN_CONTENT_HEIGHT   ([UIScreen mainScreen].bounds.size.height-20.0)


// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define  screen_width   [[UIScreen mainScreen] bounds].size.width
#define  screen_height  [[UIScreen mainScreen] bounds].size.height


#define APP_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
#define PHONE_MODEL [[UIDevice currentDevice] localizedModel]
//广告滚动视图高度
#define AD_SCROLLER_HIGHT 125

#define BuyGoodsCountMax 99   //购买商品个数最多99
#define BusinesIdMine  -9999  //自营商品为-9999

//app
//版本信息在info.plist中获取
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]//显示和适用参数版本号
#define APP_BUILD_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]//发布版本
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]




#endif

