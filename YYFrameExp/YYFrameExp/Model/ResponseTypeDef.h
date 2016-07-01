//
//  ResponseTypeDef.h
//  YYFrameExp
//
//  Created by fwr on 16/6/18.
//  Copyright © 2016年 com.YoYo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ResponseTypeDef : NSObject
@end


 

@interface UserInfo : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString<Optional> *nickName;
@property (strong, nonatomic) NSString<Optional> *headIcon;
@property (strong, nonatomic) NSString *inviteCode;
@property(nonatomic,assign) NSInteger score;
@property(nonatomic,assign) NSInteger mCoin;
@property(nonatomic,assign) NSInteger isVip;
@end