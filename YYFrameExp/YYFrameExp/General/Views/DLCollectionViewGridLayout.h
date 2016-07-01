//
//  DLCollectionViewGridLayout.h
//  jimao
//
//  Created by Dongle Su on 15/6/2.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLCollectionViewGridLayout : UICollectionViewLayout
@property(nonatomic, assign) CGSize headerSize;
@property(nonatomic, assign) CGSize marginSize;
@property(nonatomic, assign) CGSize paddingSize;
@property(nonatomic, assign) CGSize footerSize;
@property(nonatomic, assign) NSInteger numberOfCellsPerRow;
@property(nonatomic, copy) CGFloat (^calcCellHeight)(CGFloat cellWidth);

@end
