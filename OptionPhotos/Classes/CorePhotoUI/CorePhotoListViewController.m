//
//  CorePhotoListViewController.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CorePhotoListViewController.h"
#import "CoreAssetBaseItem+SXUI.h"
#import "CorePhotoAsset.h"
#import "SXCorePhotoConfig.h"
#import "PhotoCollectionViewCell.h"
#import "VideoCollectionViewCell.h"
#import "SXBigPicturePreviewViewController.h"
#import "SXCoreResult.h"
#import "SXFBView.h"
#import "SXContent.h"

@interface CorePhotoListViewController ()<UICollectionViewDelegate , UICollectionViewDataSource,CollectionCellDidSelectedAssetDelegate,SXFBViewActionDelegate>

@property (nonatomic , strong) UICollectionView *coll;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) SXFBView *fb;

@end

@implementation CorePhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.coll];
    [self.view addSubview:self.fb];
    
    [[CorePhotoAsset sharedInstance] gainPhotosFromAlbum:self.item complate:^(NSArray<CoreAssetBaseItem *> * _Nullable param, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:param];
       
        //这一步是将已经选中的变成选中状态
        for (CoreAssetBaseItem *sub in [SXCoreResult sharedInstance].selectedAsset) {
            if ([self.dataArray containsObject:sub]) {
                [self.dataArray replaceObjectAtIndex:[self.dataArray indexOfObject:sub] withObject:sub];
            }
        }
        
        [self.coll reloadData];
    }];
    
    //取消按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleSelected)];
    item.tintColor = UIColor.darkGrayColor;
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.coll reloadData];
    self.fb.count = [SXCoreResult sharedInstance].selectedAsset.count;
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    CoreAssetBaseItem *item = self.dataArray[indexPath.row];
    
    if ([item isKindOfClass:[CorePhotoItem class]]) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCellID" forIndexPath:indexPath];
        PhotoCollectionViewCell *cl = (PhotoCollectionViewCell *)cell;
        cl.delegate = self;
        cl.item = self.dataArray[indexPath.row];
        return cl;
        
    }
    if ([item isKindOfClass:[CoreVideoItem class]]) {
         cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCellID" forIndexPath:indexPath];
        VideoCollectionViewCell *cl = (VideoCollectionViewCell *)cell;
        cl.delegate = self;
        cl.item = self.dataArray[indexPath.row];
    }
    
    if (@available(iOS 9.1, *)) {
        if ([item isKindOfClass:[CoreLivePhotoItem class]]) {
            
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCellID" forIndexPath:indexPath];
            PhotoCollectionViewCell *cl = (PhotoCollectionViewCell *)cell;
            cl.delegate = self;
            cl.item = self.dataArray[indexPath.row];
        }
    } else {
        // Fallback on earlier versions
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转至大图浏览选择
    [self jumpBigPreView:indexPath.row item:self.dataArray];
    
}


#pragma mark - CollectionCellDidSelectedAssetDelegate
- (BOOL)collectionCell:(SXBaseCollectionViewCell *)cell didSelected:(BOOL)selected forItem:(CoreAssetBaseItem *)item
{
    if ([SXCorePhotoConfig sharedInstance].selectorCount == 0) {
        //不限制张数
    }else{
        //限制张数
        if ([SXCoreResult sharedInstance].selectedAsset.count >= [SXCorePhotoConfig sharedInstance].selectorCount) {
            return NO;
        }
    }
    
    if (selected) {
        item.selected = YES;
        [[SXCoreResult sharedInstance] addSelectedAsset:item];
    }else{
        item.selected = NO;
        [[SXCoreResult sharedInstance] removeSelectedAsset:item];
    }
    
    self.fb.count = [SXCoreResult sharedInstance].selectedAsset.count;
    
    return YES;
}
#pragma mark - SXFBViewActionDelegate
- (void)fbviewDidComplateActionOf:(SXFBView *)fbview
{
    //点击完成需要将result里面的东西返回给外界
    //这里面有图片和视频还有PhotoLive
    if ([SXCorePhotoConfig sharedInstance].delegate && [[SXCorePhotoConfig sharedInstance].delegate respondsToSelector:@selector(sxCorePhotoSelectedAssets:)]) {
        [[SXCorePhotoConfig sharedInstance].delegate sxCorePhotoSelectedAssets:[[SXCoreResult sharedInstance].selectedAsset mutableCopy]];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //清缓存
        [[CorePhotoAsset sharedInstance] clearClutter];
        //清空返回结果
        [[SXCoreResult sharedInstance] clearClutter];
    }];
}

- (void)fbviewDidPreviewActionOf:(SXFBView *)fbview
{
    //这里点击预览
    //会进入大图浏览
    [self jumpBigPreView:0 item:[SXCoreResult sharedInstance].selectedAsset];
    
}

- (void)jumpBigPreView:(NSInteger)currentIndex item:(NSMutableArray<CoreAssetBaseItem *> * _Nonnull)array
{
    //跳转至大图浏览选择
    SXBigPicturePreviewViewController *vc = [SXBigPicturePreviewViewController new];
    vc.items = array;
    vc.currentIndex = currentIndex;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    item.tintColor = [UIColor whiteColor];
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
- (UICollectionView *)coll
{
    if (!_coll) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        CGFloat space = ([UIScreen mainScreen].bounds.size.width - 4 * 100)/6.0;
        layout.minimumInteritemSpacing = space;
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        layout.minimumLineSpacing = space;
        _coll = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) collectionViewLayout:layout];
        _coll.backgroundColor = UIColor.whiteColor;
        _coll.delegate = self;
        _coll.dataSource = self;
        _coll.layer.masksToBounds = YES;
        [_coll registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCellID"];
        [_coll registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"VideoCollectionViewCellID"];
        [_coll registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _coll;
}
- (SXFBView *)fb
{
    if (!_fb) {
        _fb = [[SXFBView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - ([SXContent ISIOSX]?78:44),self.view.bounds.size.width , [SXContent ISIOSX]?78:44)];//34
        _fb.delegate = self;
        _fb.count = [SXCoreResult sharedInstance].selectedAsset.count;
    }
    return _fb;
}
- (void)dealloc
{
    NSLog(@"CorePhotoListViewController.m");
}

@end
