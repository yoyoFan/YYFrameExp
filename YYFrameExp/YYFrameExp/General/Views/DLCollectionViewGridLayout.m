//
//  DLCollectionViewGridLayout.m
//  jimao
//
//  Created by Dongle Su on 15/6/2.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "DLCollectionViewGridLayout.h"
@interface DLCollectionViewGridLayout()
@end


@implementation DLCollectionViewGridLayout
{
    NSMutableArray *layoutAttribArray_;
    UICollectionViewLayoutAttributes *headerAttrib_;
    UICollectionViewLayoutAttributes *footerAttrib_;
    CGSize contentSize_;
}
- (void)prepareLayout{
    NSInteger cellCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    layoutAttribArray_ = [NSMutableArray arrayWithCapacity:cellCount+1];
    
    CGFloat cellWidth = (self.collectionView.frame.size.width - self.marginSize.width*2 - self.paddingSize.width*(self.numberOfCellsPerRow -1))/self.numberOfCellsPerRow;
    CGFloat cellHeight = self.calcCellHeight(cellWidth);
    
    // cells
    CGFloat y = self.headerSize.height + self.marginSize.height;
    NSInteger i=0;
    CGFloat x = self.marginSize.width;
    UICollectionViewLayoutAttributes *attrib;
    for (; i<cellCount; i++) {
        attrib = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attrib.frame = CGRectMake(x, y, cellWidth, cellHeight);
        [layoutAttribArray_ addObject:attrib];
        
        x += cellWidth + self.paddingSize.width;
        
        if ((i+1)%self.numberOfCellsPerRow == 0) {
            x = self.marginSize.width;
            y += self.paddingSize.height + cellHeight;
        }
    }
    
    //header
    headerAttrib_ = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    headerAttrib_.frame = CGRectMake(0, 0, self.headerSize.width, self.headerSize.height);
    if (self.headerSize.width > 0 && self.headerSize.height > 0) {
        [layoutAttribArray_ addObject:headerAttrib_];
    }

    // footer
    footerAttrib_ = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    footerAttrib_.frame = CGRectMake(0, attrib.frame.origin.y + attrib.frame.size.height + self.marginSize.height, self.footerSize.width, self.footerSize.height);
    if (self.footerSize.width > 0 && self.footerSize.height > 0) {
        [layoutAttribArray_ addObject:footerAttrib_];
    }

    //content size
    CGFloat height = footerAttrib_.frame.origin.y + footerAttrib_.frame.size.height;
    contentSize_ = CGSizeMake(self.collectionView.width, height);
}
- (CGSize)collectionViewContentSize{
    return contentSize_;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *ret = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attrib in layoutAttribArray_) {
        if (CGRectIntersectsRect(attrib.frame, rect)) {
            [ret addObject:attrib];
        }
    }
    return ret;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrib = [layoutAttribArray_ objectAtIndex:indexPath.item];
    return attrib;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionViewLayoutAttributes *attrib = headerAttrib_;

        return attrib;
    }
    else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionViewLayoutAttributes *attrib = footerAttrib_;
        
        return attrib;
    }
    else{
        return nil;
    }
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
