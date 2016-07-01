//
//  UIImage+TMCache.h
//  FlowExp
//
//  Created by Dongle Su on 14-4-11.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (TMCache)
/**
 Try to load image from cache. On failure load image from a url string, and store it to cache.(synchronized method).
 */
+ (UIImage*)imageWithURLStr:(NSString*)urlStr error:(NSError **)error;
//+ (void)cacheImage:(UIImage *)image forUrlstr:(NSString*)urlStr;

@end
