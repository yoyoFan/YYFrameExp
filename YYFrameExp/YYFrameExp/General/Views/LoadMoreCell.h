//
//  LoadMoreCell.h
//  FlowStorm
//
//  Created by fwr on 14-10-11.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadMoreCell;
@protocol LoadMoreCellDelegate <NSObject>

-(void)loadMoreClick:(LoadMoreCell *)cell;

@end

@interface LoadMoreCell : UITableViewCell
{
    IBOutlet UILabel *labelLoadMore;
    IBOutlet UIActivityIndicatorView *indiView;
}

@property(nonatomic,weak)id<LoadMoreCellDelegate> delegate;

+ (LoadMoreCell *)getInstance; 

//- (void)animate;
- (void)showLoading;
- (void)stopLoading;
@end
