//
//  ShowDebugViewController.m
//  jimao
//
//  Created by pan chow on 15/4/25.
//  Copyright (c) 2015年 etuo. All rights reserved.
//

#import "ShowDebugViewController.h"

#import "FMDBLogEntry.h"
#import "FMDBHelper.h"
#import "WebViewController.h"

@interface ShowDebugViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
    NSIndexPath *_currentindexPath;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ShowDebugViewController

- (void)initNav
{
    self.title = @"debug 日志";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNav];
    
    NSArray *array = [CocoaLumberjackHelper getItemsFromFMDBLogger];
    self.dataArray = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FMDBItem *item = obj;
        NSDictionary *dic = item.itemObject;
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        [mDic addEntriesFromDictionary:dic];
        [mDic setObject:item.itemId forKey:@"id"];
        @autoreleasepool
        {
            FMDBLogEntry *logEntry = [[FMDBLogEntry alloc] initWithLogDic:mDic];
            [_dataArray addObject:logEntry];
        }
    }];
    [_tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_currentindexPath)
    {
        [_tableView deselectRowAtIndexPath:_currentindexPath animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ======  委托事件  ======
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
#pragma mark --- datasource ---

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    FMDBLogEntry *logEntry = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",logEntry.message,logEntry.function];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentindexPath = indexPath;
    
    FMDBLogEntry *logEntry = _dataArray[indexPath.row];
    
    NSString *urlString = [NSString stringWithFormat:@"<br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br><br>%@  :  %@ </br><br>--------------------------</br>",@"id",logEntry.keyId,@"message",logEntry.message,@"level",logEntry.level,@"flag",logEntry.flag,@"context",logEntry.context,@"file",logEntry.file,@"fileName",logEntry.fileName,@"func",logEntry.function,@"line",logEntry.line,@"options",logEntry.options,@"timestamp",logEntry.timestamp,@"threadId",logEntry.threadID,@"threadName",logEntry.threadName,@"queueLB",logEntry.queueLabel];
    
    WebViewController *ctrl = [[WebViewController alloc] init];
    ctrl.htmlString = urlString;
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
