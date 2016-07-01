//
//  JimaoShare.h
//  jimao
//
//  Created by Dongle Su on 15/5/20.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JimaoShare : NSObject
+ (JimaoShare *)sharedInstance;

- (void)shareWithBaseViewController:(UIViewController *)ctrl
                           sourceId:(int)sourceId
                              objId:(int)objId
                            objName:(NSString *)objName
                              title:(NSString *)title
                           imageUrl:(NSString*)imageUrl
                            content:(NSString *)content
                                url:(NSString *)url
                       shareSuccess:(void (^)())shareSuccess;

@end
