//
//  UINavigationController+TextAttributes.m
//  ImgDemo
//
//  Created by pan chow on 14/11/3.
//  Copyright (c) 2014年 pan chow. All rights reserved.
//

#import "UINavigationController+TextAttributes.h"

@implementation UINavigationController (TextAttributes)

- (void)setMyNavBarTitleTextAttributes:(NSDictionary *)tDic
{
    if(!tDic)
    {
        //tDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:tDic];
}
@end
