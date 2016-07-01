//
//  FMDBLogEntry.h
//  jimao
//
//  Created by pan chow on 15/4/25.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBLogEntry : NSObject

@property (nonatomic,copy) NSString *keyId;

@property (nonatomic,copy)NSString * message;
@property (nonatomic,strong)NSNumber * level;
@property (nonatomic,strong)NSNumber * flag;
@property (nonatomic,strong)NSNumber * context;
@property (nonatomic,copy)NSString * file;
@property (nonatomic,copy)NSString *fileName;
@property (nonatomic,copy)NSString * function;
@property (nonatomic,strong)NSNumber *line;

//@property (nonatomic,strong)NSString *tag;
@property (nonatomic,strong)NSNumber * options;
@property (nonatomic,strong)NSDate   * timestamp;
@property (nonatomic,copy)NSString *threadID;
@property (nonatomic,copy)NSString *threadName;
@property (nonatomic,copy)NSString *queueLabel;

- (id)initWithLogMessage:(DDLogMessage *)logMessage;
- (instancetype)initWithLogDic:(NSDictionary *)dic;
@end
