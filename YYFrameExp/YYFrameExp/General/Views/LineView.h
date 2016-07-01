//
//  LineView.h
//  jimao
//
//  Created by fwr on 15/9/23.
//  Copyright © 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, LineViewType)
{
    LineViewTypeNone   =0,
    LineViewTypeTop    =1,
    LineViewTypeLeft   = 1<< 1,
    LineViewTypeBottom = 1<<2,
    LineViewTypeRight  = 1<<3
};



@interface LineView : UIView


-(void)addLineWithLineType:(LineViewType)type;

@end
