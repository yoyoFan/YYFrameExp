//
//  FlowCatKeyChainUtil.h
//  FlowExp
//
//  Created by pan chow on 14-6-27.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowCatKeyChainUtil : NSObject

+ (void)saveguid:(NSString *)guid;
+ (id)getGUIDFromKeyChain;
+ (void)deleteGUID;
@end
