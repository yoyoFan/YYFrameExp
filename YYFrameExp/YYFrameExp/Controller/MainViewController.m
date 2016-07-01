//
//  ViewController.m
//  redBook
//
//  Created by oujinlong on 16/6/3.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import "MainViewController.h"
#import "OJLWaterLayout.h"
#import "OJLCollectionViewCell.h"
#import "Model.h"
#import "OUNavigationController.h"
#import "DetailViewController.h"

#import "JSCarouselViewController.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate,OJLWaterLayoutDelegate>
@property (nonatomic, weak) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* modelArray;
@property (nonatomic, strong) OJLWaterLayout* layout;
@end

@implementation MainViewController
- (NSArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [Model models];
    }
    return _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMain];
    
     self.title = @"首页";
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [btn setTitle:@"图片阅览" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ClickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}


-(void)ClickRightBtn
{
    JSCarouselViewController *ctrl =[[JSCarouselViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)setupMain {
   
    
    OJLWaterLayout* layout = [[OJLWaterLayout alloc] init];
    self.layout = layout;
    layout.numberOfCol = 2;
    layout.rowPanding = 15;
    layout.colPanding = 15;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.delegate = self;
    [layout autuContentSize];
    
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [collectionView registerNib:[UINib nibWithNibName:@"OJLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:collectionView];
    
}


#pragma mark UICollectionViewDataSource, UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OJLCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.modelArray[indexPath.item];
    
    
    return cell;
}
#pragma mark OJLWaterLayoutDelegate
-(CGFloat)OJLWaterLayout:(OJLWaterLayout *)OJLWaterLayout itemHeightForIndexPath:(NSIndexPath *)indexPath{
    
    Model* model = self.modelArray[indexPath.item];
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - self.layout.sectionInset.left - self.layout.sectionInset.right - (self.layout.colPanding * (self.layout.numberOfCol - 1))) / self.layout.numberOfCol;
    
    CGFloat scale = [model.w floatValue] / width;
    
    CGFloat height =  [model.h floatValue] / scale + 105;

    
    return height;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Model* model = self.modelArray[indexPath.item];

    OJLCollectionViewCell* cell = (OJLCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
     CGRect desImageViewRect = CGRectMake(0, 60 + 64, [model scaleSize].width, 100);
    
//    CGRect desImageViewRect = CGRectMake(0, 60 + 64, [model scaleSize].width, [model scaleSize].height);
    
//    DetailViewController* vc = [[DetailViewController alloc] initWithModel:model desImageViewRect:desImageViewRect];
//    
//    [((OUNavigationController*) self.navigationController) pushViewController:vc withImageView:cell.imageView desRect:desImageViewRect delegate:vc];


}
@end
