//
//  BaiduLocation.h
//  jimao
//
//  Created by fwr on 15/6/8.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件

@interface BaiduLocation : NSObject<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
+ (BaiduLocation *)sharedInstance;
-(void)LocationOnceEveryDay;

@property(nonatomic, strong) NSString *currentUserLocation;

@end
