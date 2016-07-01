//
//  UIImageView+TMCache.m
//  FlowExp
//
//  Created by pan chow on 14-4-10.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "UIImageView+TMCache.h"
#import "TMCache.h"

@implementation UIImageView (TMCache)

- (void)TMCacheImageWithURL:(NSURL *)url
{
    [[TMCache sharedCache] objectForKey:[url absoluteString]
                                  block:^(TMCache *cache, NSString *key, id object) {
                                      if (object) {
                                          [self setImageOnMainThread:(UIImage *)object];
                                          return;
                                      }
                                      
                                      NSLog(@"cache miss, requesting %@", url);
                                      
                                      NSURLResponse *response = nil;
                                      NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                      NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
                                      
                                      UIImage *image = [[UIImage alloc] initWithData:data scale:[[UIScreen mainScreen] scale]];
                                      [self setImageOnMainThread:image];
                                      
                                      [[TMCache sharedCache] setObject:image forKey:[url absoluteString]];
                                  }];
}
- (void)TMCacheImageWithURL:(NSURL *)url finished:(void(^)(id userInfo,NSString *key, id object,BOOL success))block
{
    [[TMCache sharedCache] objectForKey:[url absoluteString]
                                  block:^(TMCache *cache, NSString *key, id object) {
                                      if (object) {
                                          [self setImageOnMainThread:(UIImage *)object];
                                          if(block)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  block(self,key,object,YES);
                                              });
                                          }
                                          return;
                                      }
                                      
                                      NSLog(@"cache miss, requesting %@", url);
                                      
                                      NSURLResponse *response = nil;
                                      NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                      NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
                                      
                                      UIImage *image = [[UIImage alloc] initWithData:data scale:[[UIScreen mainScreen] scale]];
                                      [self setImageOnMainThread:image];
                                      
                                      [[TMCache sharedCache] setObject:image forKey:[url absoluteString]];
                                      if(block)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              BOOL success=NO;
                                              if(image)
                                              {
                                                  success=YES;
                                              }
                                              block(self,key,object,success);
                                          });
                                      }
                                  }];
}


- (void)setImageOnMainThread:(UIImage *)image
{
    if (!image)
        return;
    
    NSLog(@"setting view image %@", NSStringFromCGSize(image.size));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = image;
    });
}
@end
