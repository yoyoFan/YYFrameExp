//
//  FlowCatKeyChainUtil.m
//  FlowExp
//
//  Created by pan chow on 14-6-27.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "FlowCatKeyChainUtil.h"
#import "KeyChainUtil.h"
static NSString * const GUID_IN_DIC = @"com.jimao.app.guiddic";
static NSString * const GUID_IN_KEYCHAIN = @"com.jimao.app.guidinfo";

@implementation FlowCatKeyChainUtil

+ (void)saveguid:(NSString *)guid
{
    NSMutableDictionary *guidKVPairs = [NSMutableDictionary dictionary];
    [guidKVPairs setObject:guid forKey:GUID_IN_DIC];
    [KeyChainUtil save:GUID_IN_KEYCHAIN data:guidKVPairs];
}
+ (id)getGUIDFromKeyChain
{
    NSMutableDictionary *guidKVPairs = (NSMutableDictionary *)[KeyChainUtil load:GUID_IN_KEYCHAIN];
    return [guidKVPairs objectForKey:GUID_IN_DIC];
}
+ (void)deleteGUID
{
    [KeyChainUtil delete:GUID_IN_KEYCHAIN];
}
@end
