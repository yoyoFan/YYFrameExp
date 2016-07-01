//
//  FollowCourseState.h
//  FlowExp
//
//  Created by Dongle Su on 14-5-16.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FollowCourseType) {
    FollowCourseTypeWeixin = 1,
    FollowCourseTypeYixin,
};

@interface FollowCourseState : NSObject
+ (FollowCourseState *)sharedInstance;
- (BOOL)isNeverShowCourseOfType:(FollowCourseType)type;
- (void)setNeverShowCourseOfType:(FollowCourseType)type;
@end
