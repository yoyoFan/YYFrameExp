//
//  UISearchBar+TextField.m
//  jimao
//
//  Created by Dongle Su on 15/8/21.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "UISearchBar+TextField.h"

@implementation UISearchBar (TextField)
- (UITextField *)textField{
    UITextField *searchBarTextField = nil;
    for (UIView *subView in self.subviews)
    {
        for (UIView *sndSubView in subView.subviews)
        {
            if ([sndSubView isKindOfClass:[UITextField class]])
            {
                searchBarTextField = (UITextField *)sndSubView;
                break;
            }
        }
    }
    return searchBarTextField;
}
@end
