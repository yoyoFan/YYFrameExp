//
//  UIImageView+TMCache.h
//  FlowExp
//
//  Created by pan chow on 14-4-10.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (TMCache)

- (void)TMCacheImageWithURL:(NSURL *)url;
- (void)TMCacheImageWithURL:(NSURL *)url finished:(void(^)(id userInfo,NSString *key, id object,BOOL success))block;
@end
