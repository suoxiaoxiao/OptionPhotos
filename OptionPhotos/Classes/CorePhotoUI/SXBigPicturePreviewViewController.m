//
//  SXBigPicturePreviewViewController.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXBigPicturePreviewViewController.h"
#import "SXBigPhotoCollectionViewCell.h"
#import "SXBigPhotoLiveCollectionViewCell.h"
#import "SXBigVideoCollectionViewCell.h"
#import "CoreAssetBaseItem.h"
#import "CorePhotoItem.h"
#import "CoreVideoItem.h"
#import "CoreLivePhotoItem.h"
#import "SXCoreResult.h"
#import "SXContent.h"
#import "SXCoreResult.h"
#import "CoreAssetBaseItem+SXUI.h"

@interface SXBigPicturePreviewViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView *coll;
@property (nonatomic , strong) UIButton *selectedBtn;
@end


@implementation SXBigPicturePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self.view addSubview:self.coll];
    
    //滑动到选中item
    NSIndexPath *pathItem = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [self.coll scrollToItemAtIndexPath:pathItem atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    CoreAssetBaseItem *item = self.items[self.currentIndex];
    self.selectedBtn.selected = item.selected;
    
    //预加载上一个和下一个
    [self preloadCell];
    
}

- (void)didSelectedBtn:(UIButton *)sender
{
    //这里要进行选中和非选中判断
    //查看当前的indexpath
    NSArray *array = [self.coll indexPathsForVisibleItems];
    NSLog(@"%@",array);
    if (array.count > 1) {
        return;
    }
    self.selectedBtn.selected = !sender.isSelected;
    NSIndexPath *firstPath = array.firstObject;
    CoreAssetBaseItem *item = self.items[firstPath.row];
    if (self.selectedBtn.isSelected) {
        item.selected = YES;
        [[SXCoreResult sharedInstance] addSelectedAsset:item];
        
    }else{
        item.selected = NO;
        [[SXCoreResult sharedInstance] removeSelectedAsset:item];
    }
}

- (void)initNavigationBar
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.coll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    //改变navibar的颜色
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //添加右上角的选中按钮
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CorePhotoResource" ofType:@"bundle"];
    [self.selectedBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"check_normal"]] forState:0];
    [self.selectedBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"check_selected"]] forState:UIControlStateSelected];
    [self.selectedBtn addTarget:self action:@selector(didSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.selectedBtn];
    self.navigationItem.rightBarButtonItem = item;
    
}

/**
 * 预加载
 */
- (void)preloadCell
{
    NSInteger beforerow = self.currentIndex - 1;
    if (beforerow >= 0) {//进行预加载
        CoreAssetBaseItem *item = self.items[beforerow];
        if ([item isKindOfClass:[CoreVideoItem class]]) {
            NSIndexPath *beforeCell = [NSIndexPath indexPathForRow:beforerow inSection:0];
            [self collectionView:self.coll cellForItemAtIndexPath:beforeCell];
        }
    }
    
    NSInteger last = self.currentIndex + 1;
    if (last < self.items.count) {//进行预加载
        CoreAssetBaseItem *item = self.items[last];
        if ([item isKindOfClass:[CoreVideoItem class]]) {
            NSIndexPath *lastCell = [NSIndexPath indexPathForRow:last inSection:0];
            [self collectionView:self.coll cellForItemAtIndexPath:lastCell];
        }
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    CoreAssetBaseItem *item = self.items[indexPath.row];
    
    if ([item isKindOfClass:[CorePhotoItem class]]) {
        SXBigPhotoCollectionViewCell *sub = [collectionView dequeueReusableCellWithReuseIdentifier:@"SXBigPhotoCollectionViewCell" forIndexPath:indexPath];
        
        sub.item = (CorePhotoItem *)item;
        
        return sub;
        
        
    } else if ([item isKindOfClass:[CoreVideoItem class]]) {
        
        SXBigVideoCollectionViewCell *sub = [collectionView dequeueReusableCellWithReuseIdentifier:@"SXBigVideoCollectionViewCell" forIndexPath:indexPath];
        NSLog(@"%ld cellForItemAtIndexPath",indexPath.row);
        sub.item = (CoreVideoItem *)item;
        
        return sub;
        
    }else if (@available(iOS 9.1, *)) {
        if ([item isKindOfClass:[CoreLivePhotoItem class]]) {
            
            SXBigPhotoLiveCollectionViewCell *sub = [collectionView dequeueReusableCellWithReuseIdentifier:@"SXBigPhotoLiveCollectionViewCell" forIndexPath:indexPath];
            
            sub.item = (CoreLivePhotoItem *)item;
            
            return sub;
        }
    } else {
        // Fallback on earlier versions
    }
    
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

/** 已经隐藏的cell */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SXBigVideoCollectionViewCell class]]) {
        [(SXBigVideoCollectionViewCell *)cell stopPlayer];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollX = scrollView.contentOffset.x;
    
    CGFloat scrollUnitW = self.view.frame.size.width;
    
    NSInteger index = floorf((scrollX/scrollUnitW) + 0.5);
    
    if (index < 0){  index = 0;}
    if (index >= self.items.count){ index = self.items.count - 1;}
    
    CoreAssetBaseItem *item = self.items[index];
    
    self.selectedBtn.selected = item.selected;
}
@synthesize items = _items;
- (NSMutableArray<CoreAssetBaseItem *> *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
- (void)setItems:(NSMutableArray<CoreAssetBaseItem *> *)items
{
    if (items) {
        _items = [items mutableCopy];
    }
}

- (UICollectionView *)coll
{
    if (!_coll) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _coll = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        _coll.backgroundColor = UIColor.whiteColor;
        _coll.pagingEnabled = YES;
        _coll.delegate = self;
        _coll.dataSource = self;
        _coll.showsVerticalScrollIndicator = NO;
        _coll.showsHorizontalScrollIndicator = NO;
        _coll.layer.masksToBounds = YES;
        [_coll registerClass:[SXBigPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"SXBigPhotoCollectionViewCell"];
        [_coll registerClass:[SXBigPhotoLiveCollectionViewCell class] forCellWithReuseIdentifier:@"SXBigPhotoLiveCollectionViewCell"];
        [_coll registerClass:[SXBigVideoCollectionViewCell class] forCellWithReuseIdentifier:@"SXBigVideoCollectionViewCell"];
        [_coll registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _coll;
}

- (void)dealloc
{
    NSLog(@"SXBigPicturePreviewViewController.m");
}

@end
