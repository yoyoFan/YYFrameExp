//
//  FMDBHelper.h
//  jimao
//
//  Created by pan chow on 14/11/25.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

//see:https://github.com/yuantiku/YTKKeyValueStore

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface FMDBItem : NSObject

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id itemObject;
@property (strong, nonatomic) NSString *createdTime;

@end

@interface FMDBHelper : NSObject

- (id)initDBWithName:(NSString *)dbName;

- (id)initWithDBWithPath:(NSString *)dbPath;

- (BOOL)createTableWithName:(NSString *)tableName;

- (BOOL)clearTable:(NSString *)tableName;

- (void)close;

///************************ Put&Get methods *****************************************

- (BOOL)putObject:(id)object withId:(NSString *)objectId timeString:(NSString *)createdTime intoTable:(NSString *)tableName;

- (BOOL)deleteObjectByTime:(NSString *)time fromTable:(NSString *)tableName;

- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (FMDBItem *)getYTKKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName;

- (void)putString:(NSString *)string withId:(NSString *)stringId timeString:(NSString *)createdTime intoTable:(NSString *)tableName;

- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId timeString:(NSString *)createdTime intoTable:(NSString *)tableName;

- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

- (NSArray *)getAllItemsFromTable:(NSString *)tableName;

- (BOOL)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;

- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;

//add
- (NSUInteger)getCountFromTable:(NSString *)tableName;
@end
