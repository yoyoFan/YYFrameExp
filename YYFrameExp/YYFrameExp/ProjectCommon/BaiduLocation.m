//
//  BaiduLocation.m
//  jimao
//
//  Created by fwr on 15/6/8.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "BaiduLocation.h"
#define  kUserCurrentLocation @"UserCurrentLocation"

@interface BaiduLocation(){
    BMKLocationService* _locService;
    
}
@end

@implementation BaiduLocation
+ (BaiduLocation *)sharedInstance
{
    static BaiduLocation *baiduLocation=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baiduLocation = [[BaiduLocation alloc] init];
    });
    return baiduLocation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if([[NSUserDefaults standardUserDefaults] objectForKey: kUserCurrentLocation])
        {
          _currentUserLocation = [[NSUserDefaults standardUserDefaults] objectForKey: kUserCurrentLocation];
        }
        else
        {
            _currentUserLocation = @"";
        }
    }
    return self;
}


-(void)initWithLocationService{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}



/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    SLog(@"start location");
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    // 物理地址
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
    search.delegate=self;
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = userLocation.location.coordinate;
    [search reverseGeoCode:rever];
//    SLog(@"定位开始%d",[search reverseGeoCode:rever]);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
    search.delegate=self;
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = userLocation.location.coordinate;
    [search reverseGeoCode:rever];
 }

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    SLog(@"停止定位");
    NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil userInfo:@{@"1":@"123"}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
}
          
/**
 *定位失败后，会调用此函数
 
 *@param mapView 地图View
 
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    SLog(@"location error");
}


#pragma mark 获取到物理地址信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if(result && result.addressDetail.city!= nil && ![result.addressDetail.city isEqualToString: @""])
    {
        _currentUserLocation  = [NSString stringWithFormat:@"%@|%@",result.addressDetail.province,result.addressDetail.city];
        [[NSUserDefaults standardUserDefaults] setObject:_currentUserLocation forKey:kUserCurrentLocation];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_locService stopUserLocationService];
    }
}


-(void)setCurrentUserLocation:(NSString *)currentUserLocation
{
   if(![_currentUserLocation isEqualToString:currentUserLocation])
   {
       _currentUserLocation = currentUserLocation;
       [[NSUserDefaults standardUserDefaults] setObject:_currentUserLocation forKey:kUserCurrentLocation];
       [[NSUserDefaults standardUserDefaults] synchronize];
   }
}




-(void)stopLocationService
{
    [_locService stopUserLocationService];
}


-(void)LocationOnceEveryDay
{
    [self initWithLocationService];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *currentDateStr;
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"BaiduLocationKey"])
//    {
//        currentDateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"BaiduLocationKey"];
//        if(![currentDateStr isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
//        {
//            [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"BaiduLocationKey"];
//            //开始定位
//            [self initWithLocationService];
//        }
//    }
//    else
//    {
//        currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
//        [[NSUserDefaults standardUserDefaults] setObject:currentDateStr forKey:@"BaiduLocationKey"];
//        //定位
//        [self initWithLocationService];
//        
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
