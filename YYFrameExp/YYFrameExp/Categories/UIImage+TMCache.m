//
//  UIImage+TMCache.m
//  FlowExp
//
//  Created by Dongle Su on 14-4-11.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UIImage+TMCache.h"
#import "TMCache.h"

@implementation UIImage (TMCache)

+ (UIImage*)imageWithURLStr:(NSString*)urlStr error:(NSError **)error{
    UIImage *image = [[TMCache sharedCache] objectForKey:urlStr];
    if (image == nil) {
        NSURLResponse *response = nil;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        NSError *networkError = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&networkError];
        if (!networkError) {
            image = [[UIImage alloc] initWithData:data scale:[[UIScreen mainScreen] scale]];
            if (image) {
                [[TMCache sharedCache] setObject:image forKey:urlStr];
                NSLog(@"store image url:%@ to cache.", urlStr);
            }
            else{
                NSLog(@"get store image failed:%@", urlStr);
            }

        }
        else{
            NSLog(@"%@", networkError);
            if (error) {
                *error = networkError;
            }
        }
    }
    else{
        NSLog(@"got image url:%@ from cache!", urlStr);
    }
    return image;
}

@end
