//
//  CorePhotoRootViewController.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/2.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CorePhotoRootViewController.h"
#import "CorePhotoAsset.h"
#import "AlbumTableViewCell.h"
#import "CorePhotoListViewController.h"
#import "SXCoreResult.h"

@interface CorePhotoRootViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) UITableView *tableView;

@end

@implementation CorePhotoRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self)weakSelf = self;
    [[CorePhotoAsset sharedInstance] gainAlbums:^(NSArray<CoreAlbumItem *> * _Nullable param, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        [weakSelf.dataArray addObjectsFromArray:param];
        [weakSelf.tableView reloadData];
    }];
    
    //取消按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleSelected)];
    item.tintColor = UIColor.darkGrayColor;
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view.
}

- (void)cancleSelected
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        //清缓存
        [[CorePhotoAsset sharedInstance] clearClutter];
        //清空返回结果
        [[SXCoreResult sharedInstance] clearClutter];
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCellID"];
    
    CoreAlbumItem *item = self.dataArray[indexPath.row];
    
    cell.image.image = item.coverPhoto;
    cell.titleLb.text = item.title;
    cell.countLb.text = [NSString stringWithFormat:@"%ld张",item.count];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CorePhotoListViewController *vc = [[CorePhotoListViewController alloc] init];
    vc.item = self.dataArray[indexPath.row];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    item.tintColor = [UIColor darkGrayColor];
    
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:@"AlbumTableViewCellID"];
    }
    return _tableView;
}

- (void)dealloc
{
    NSLog(@"CorePhotoRootViewController.m");
}

@end
