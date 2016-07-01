//
//  FollowCourseState.m
//  FlowExp
//
//  Created by Dongle Su on 14-5-16.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "FollowCourseState.h"
#define kconfigFile @"/followCourse.plist"

@implementation FollowCourseState{
    NSMutableDictionary *dic_;
}

SINGLETON_GCD(FollowCourseState);

- (id)init{
    self = [super init];
    if (self) {
        dic_ = [NSMutableDictionary dictionaryWithContentsOfFile:[HOME_DIR stringByAppendingString:kconfigFile]];
        if (!dic_) {
            dic_ = [NSMutableDictionary dictionary];
        }
    }
    return self;
}
- (BOOL)isNeverShowCourseOfType:(FollowCourseType)type{
    return [[dic_ objectForKey:[NSString stringWithFormat:@"%d", type]] boolValue];
}
- (void)setNeverShowCourseOfType:(FollowCourseType)type{
    [dic_ setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", type]];
    [dic_ writeToFile:[HOME_DIR stringByAppendingString:kconfigFile] atomically:YES];
}

@end
