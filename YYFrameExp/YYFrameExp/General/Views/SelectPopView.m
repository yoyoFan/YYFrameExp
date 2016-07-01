//
//  SelectPopView.m
//  jimao
//
//  Created by pan chow on 14/12/3.
//  Copyright (c) 2014年 etuo. All rights reserved.
//

#import "SelectPopView.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Graphic.h"
#import "SelectCollectionViewCell.h"
#import "UpDownPopBtn.h"
#import <POP/POP.h>

#define SELECT_POP_VIEW_CELL_HEIGHT 44.0f
@interface SelectPopView ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UIImageView *imgView;
    
    IBOutlet NSLayoutConstraint *topCon;
    IBOutlet NSLayoutConstraint *heightCon;
    
    IBOutlet UIView *footView;
    IBOutlet UpDownPopBtn *doneBtn;
}

@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *selects;

@end

@implementation SelectPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark --- init ---
+ (instancetype)getInstance
{
    id popView=[[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] firstObject];
    [popView initlize];
    return popView;
}
- (void)initlize
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.layer.cornerRadius=5.0f;
    _tableView.layer.borderColor = [UIColor clearColor].CGColor;
    _tableView.layer.borderWidth = 2.0f;
    _tableView.layer.shadowColor = [UIColor clearColor].CGColor;
    _tableView.layer.shadowOffset = CGSizeMake(0, 2);
    _tableView.clipsToBounds = YES;
    
    footView.backgroundColor = rgb(240, 240, 240);
    footView.clipsToBounds = YES;
    [doneBtn setTitleColor:rgb(120, 120, 120) forState:UIControlStateNormal];
}
#pragma mark --- public ---
- (void)setDataSource:(NSDictionary *)dic
{
    
    
}
- (void)showPopViewOnCtl:(UIViewController *)ctl withData:(NSDictionary *)dic
{
    //ui
    self.alpha = .0f;
    [ctl.view addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints=NO;
    //[self lyt_alignToParentWithMargin:200];
    [self lyt_alignToParent];
    [ctl.view layoutIfNeeded];
    
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    
    topCon.constant =  ctl.topLayoutGuide.length;
    heightCon.constant = .0f;
    
    imgView.image = nil;//[[ctl.view screenshot] applyLightEffect];
    imgView.alpha = .0f;
    
    [self updateConstraintsIfNeeded];
    
   
    //data
    self.titles=dic[@"titles"];
    self.dataArray=dic[@"dataArray"];
    self.selects =[NSMutableArray arrayWithArray:dic[@"selectArray"]];
    if(!self.selects || [_selects count]<=0)
    {
        self.selects = [NSMutableArray arrayWithArray:@[[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0]]];
    }
    //ui
    heightCon.constant= SELECT_POP_VIEW_CELL_HEIGHT * _titles.count +SELECT_POP_VIEW_CELL_HEIGHT;
   
    _tableView.alpha = .0f;
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
        imgView.alpha=1.0f;
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [_tableView reloadData];
        _tableView.alpha = 1.0f;
        _tableView.tableFooterView = footView;
        
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(1.1, 1.1)];
        scaleAnimation.springBounciness = 18.f;
        [_tableView pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }];
    
}
- (void)hidePopView
{
   [self performSelector:@selector(hide) withObject:nil afterDelay:.0];
    if([self.delegate respondsToSelector:@selector(canceledInselectPopView:)])
    {
        [_delegate canceledInselectPopView:self];
    }
}
- (void)hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        heightCon.constant= 0;
        
        [UIView animateWithDuration:.3 animations:^{
            [self layoutIfNeeded];
            imgView.alpha = .0f;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}
- (IBAction)footView:(UITapGestureRecognizer *)tap
{
    [self hidePopView];
}
- (IBAction)doneBtn:(UpDownPopBtn *)btn
{
//    [btn setImage:[UIImage imageNamed:@"upsorrow"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"downsorrow"] forState:UIControlStateHighlighted];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:.0];
    if([self.delegate respondsToSelector:@selector(doneBtnPressedInselectPopView:)])
    {
        [_delegate doneBtnPressedInselectPopView:self];
    }
}
#pragma mark --- delegate ---

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SELECT_POP_VIEW_CELL_HEIGHT;
}

#pragma mark --- datasource ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //config the cell
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    
    //collectionView
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   layout.headerReferenceSize = CGSizeMake(70, 44);
    layout.sectionInset = UIEdgeInsetsMake(0, 80, 0, 0);
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:cell.contentView.bounds collectionViewLayout:layout];
    collectionView.tag = indexPath.row;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[SelectCollectionViewCell class] forCellWithReuseIdentifier:@"SelectCollectionViewCellId"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    collectionView.backgroundColor=[UIColor clearColor];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    [cell.contentView addSubview:collectionView];
    collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [collectionView lyt_alignToParent];
    [collectionView reloadData];
    return cell;
}


#pragma mark --- UICollectionView ---
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = _dataArray [collectionView.tag];
    return array.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SelectCollectionViewCellId";
    SelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *array = _dataArray [collectionView.tag];
    [cell loadCell:array[indexPath.row]];
    NSInteger index = [_selects[collectionView.tag] integerValue];
    if(index == indexPath.row)
    {
        [cell setSelected:YES];
    }
    else
    {
        [cell setSelected:NO];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId" forIndexPath:indexPath];
    
    UILabel *lb = (UILabel *)[headerView viewWithTag:1001];
    UIImageView *lineImgView = (UIImageView *)[headerView viewWithTag:1002];
    if(!lb)
    {
        lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.width-8, headerView.height)];
        lb.tag=1001;
        lb.textColor =rgb(120, 120, 120);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.backgroundColor=[UIColor clearColor];
        [headerView addSubview:lb];
        
        lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(lb.width, 11, 1, 22)];
        lineImgView.image = [UIImage imageNamed:@"miniwhitelinev"];
        [headerView addSubview:lineImgView];
    }
    lb.text=_titles[collectionView.tag];
    return headerView;
}
#pragma mark --UICollectionViewDelegateFlowLayou
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static SelectCollectionViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[SelectCollectionViewCell alloc] init];
    });
    NSArray *array = _dataArray [collectionView.tag];
    [cell loadCell:array[indexPath.row]];
    return cell.cellSize;
    //return CGSizeMake(60, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selected = [_selects[collectionView.tag] integerValue];
    if(selected == indexPath.row)
    {
        return;
    }
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    NSNumber *index = [NSNumber numberWithInt:indexPath.row];
    [_selects replaceObjectAtIndex:collectionView.tag withObject:index];
    
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:selected inSection:0],indexPath]];
    
    if([self.delegate respondsToSelector:@selector(selectPopView:checkRow:column:)])
    {
        [_delegate selectPopView:self checkRow:collectionView.tag column:indexPath.row];
    } 
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCollectionViewCell * cell = (SelectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
