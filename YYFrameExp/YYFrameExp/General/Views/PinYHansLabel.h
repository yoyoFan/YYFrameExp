//
//  PinYHansLabel.h
//  jimao
//
//  Created by pan chow on 15/6/12.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinYHansLabel : UILabel

@property (nonatomic,assign)CGFloat ContentHeight;

- (void)fillWithPinYins:(NSArray *)pins Hans:(NSArray *)hans attibutes:(NSDictionary *)attDic;
- (instancetype)initWithFrame:(CGRect)frame fillWithPinYins:(NSArray *)pins Hans:(NSArray *)hans attibutes:(NSDictionary *)attDic;
+ (CGFloat)heightForPins:(NSArray *)pins hans:(NSArray *)Hans attibutes:(NSDictionary *)attDic width:(CGFloat)width;
@end
