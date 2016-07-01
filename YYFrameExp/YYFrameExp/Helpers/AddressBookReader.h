//
//  AdressBookReader.h
//  FlowExp
//
//  Created by Dongle Su on 14-4-21.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AdressbookLoadFinishedNotification @"AdressbookLoadFinishedNotification"

@interface AddressBookReader : NSObject

@property(nonatomic, strong) NSMutableArray *contactArray;
@property(nonatomic, strong) NSMutableArray *noSortContactArray;

+ (AddressBookReader *)sharedInstance;
- (BOOL)isBinded;
- (void)bindSuccess:(void(^)())successed failed:(void(^)(NSString *errorDescription))failed;
- (BOOL)bind;

- (void)reloadAddressBookSuccess:(void(^)())successed failed:(void(^)(NSString *errorDescription))failed;
@end
