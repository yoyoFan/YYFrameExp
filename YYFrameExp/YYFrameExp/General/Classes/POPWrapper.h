//
//  POPWrapper.h
//  jimao
//
//  Created by Dongle Su on 15-4-1.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <POP/POP.h>

@interface POPWrapper : NSObject
- (void)togglePopAnimation:(BOOL)on progressBlock:(void (^)(CGFloat progress))progressBlock completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock;
@end
