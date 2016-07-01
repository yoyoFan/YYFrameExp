//
//  UserProfile.h
//  FlowExp
//
//  Created by fwr  on 14-4-16.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseTypeDef.h"

@interface UserProfile : JSONModel
@property (strong, nonatomic) UserInfo *userInfo; //用户信息
@property(nonatomic, retain) NSString *accessToken; //用户登录成功后生成的唯一令牌
@property(nonatomic, retain) NSString *serviceTime; //服务器时间
//@property (strong, nonatomic) AddressListModel *defaultAddress; //默认地址

//@property (strong, nonatomic) LocationModel *locationModel; //定位地址

@property(nonatomic, retain) NSDictionary *sysConfigDic;

@property (nonatomic,retain) NSString *invite_code; //用户邀请码
@property (nonatomic,assign) NSInteger level ; //用户等级
@property (nonatomic,retain) NSMutableArray *SearchHistoryArray;//商城搜索历史记录

//待用
@property(nonatomic, retain) NSString *installDate;
@property(nonatomic, retain) NSArray *loadBg;
@property(nonatomic, assign) BOOL isFirstLaunch;
@property(nonatomic, assign) BOOL isFirstResponse;
@property(nonatomic, assign) BOOL isBindInstallCalled;
@property(nonatomic, assign) BOOL isFlashMessage;
@property(nonatomic, assign) NSInteger unReadMessageCount;
//- (void)logout;

+ (UserProfile *)sharedInstance;
- (void)save;
@end
