//
//  CorePhotoAsset.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CorePhotoAsset.h"
#import "CorePhotoMemoryCache.h"
#import <Photos/Photos.h>
#import "PHAssetCollection+Thumb.h"
#import "MemoryMonitoring.h"

static const NSInteger datumUnit = 512;

@interface CorePhotoAsset ()

//队列 无法控制线程个数  造成内存激增  因为需要返回数组, 图片过多会拿去过多的资源
@property (nonatomic , strong) dispatch_queue_t readAssetQueue;

//队列  可以控制线程个数, 内初不会激增
@property (nonatomic , strong) NSOperationQueue *readQueue;


@end

@implementation CorePhotoAsset

+ (instancetype)sharedInstance
{
    static CorePhotoAsset *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CorePhotoAsset alloc] init];
        [instance initqueue];
    });
    return instance;
}

- (void)initqueue
{
    self.readAssetQueue = dispatch_queue_create("com.album.asset",DISPATCH_QUEUE_CONCURRENT);
    
    self.readQueue = [[NSOperationQueue alloc] init];
    self.readQueue.maxConcurrentOperationCount = 5;
    
}


//获取相册集
- (void)gainAlbums:(DownloadSystemAlbumsComplateBlock)complateBlock
{
    NSLog(@"%s 调用开始时间: %@",__func__,[NSDate date]);
    //标记
    static BOOL flag = NO;
    //授权
    PHAuthorizationStatus status = [PHPhotoLibrary  authorizationStatus];
    
    if (status == PHAuthorizationStatusNotDetermined) {//第一次使用
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //这里为了防止造成死循环做一个标记
                if (!flag) {
                    flag = YES;
                    [self gainAlbums:complateBlock];
                    
                }else{//状态重复, 返回
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSError *error = [[NSError alloc] initWithDomain:kErrorAuthorizationWrongKey code:217 userInfo:@{kErrorAuthorizationWrongKey:@"权限错误"}];
                        if (complateBlock) {
                            complateBlock(nil,error);
                        }
                    });
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [[NSError alloc] initWithDomain:kErrorWithoutAuthorizationKey code:217 userInfo:@{kErrorWithoutAuthorizationKey:@"没有权限"}];
                    if (complateBlock) {
                        complateBlock(nil,error);
                    }
                });
            }
        }];
        
    }else if (status != PHAuthorizationStatusAuthorized) {//不是第一次使用q且无权限
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [[NSError alloc] initWithDomain:kErrorWithoutAuthorizationKey code:217 userInfo:@{kErrorWithoutAuthorizationKey:@"没有权限"}];
            if (complateBlock) {
                complateBlock(nil,error);
            }
            
        });
        return;
    }
    
    //缓存处理
    if ([SXCorePhotoConfig sharedInstance].isNeedCache) {
        
        NSArray *caches = [[CorePhotoMemoryCache defaultCache] getAssetCollectionCacheForKey:nil];
        if (caches) {
            NSLog(@"使用了缓存相集");
            if (complateBlock) {
                complateBlock(caches,nil);
            }
            return ;
        }
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{//搜索占用时间, 在子线程操作
    
        //获取所有有照片的相薄
        NSMutableArray *photoGroups = [NSMutableArray array];
        PHFetchOptions *options = [PHFetchOptions new];
        //获取手机相薄
        PHAssetCollectionSubtype subType = PHAssetCollectionSubtypeAlbumRegular;
        PHAssetCollectionType type = PHAssetCollectionTypeAlbum;
        PHFetchResult *smartAlbumsResult = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                                                    subtype:subType
                                                                                    options:options];
        
        //    NSLog(@"%@",smartAlbumsResult);
        //获取手机相机胶卷
        subType = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
        type = PHAssetCollectionTypeSmartAlbum;
        PHFetchResult *smartAlbumsResult1 = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                                                     subtype:subType
                                                                                     options:options];
        //    NSLog(@"%@",smartAlbumsResult1);
        
        
        //获取所有的相薄
        [smartAlbumsResult enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                
                PHAssetCollection *asset = (PHAssetCollection *)obj;
                PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:asset options:fetchOptions];
                if (result.count) {
                    
                    if (!CGSizeEqualToSize(CGSizeZero, [SXCorePhotoConfig sharedInstance].definitionSize)) {
                        asset.sx_targetSize = [SXCorePhotoConfig sharedInstance].definitionSize;
                    }else{
                        asset.sx_targetSize = CGSizeMake(datumUnit * [SXCorePhotoConfig sharedInstance].definition, datumUnit * [SXCorePhotoConfig sharedInstance].definition);
                    }
                    
                    [photoGroups addObject:asset];
                }
            }
        }];
        
        //为什么有时候没有获取到胶卷???
        //手机胶卷
        [smartAlbumsResult1 enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                
                PHAssetCollection *asset = (PHAssetCollection *)obj;
                PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:asset options:fetchOptions];
                if (result.count) {
                    asset.sx_targetSize = CGSizeMake(datumUnit * [SXCorePhotoConfig sharedInstance].definition, datumUnit * [SXCorePhotoConfig sharedInstance].definition);
                    [photoGroups addObject:asset];
                }
            }
        }];
        
        
        smartAlbumsResult = nil;
        smartAlbumsResult1 = nil;
        
        
        NSMutableArray *resultAssets = [NSMutableArray arrayWithCapacity:photoGroups.count];
        
        dispatch_group_t group = dispatch_group_create();
        NSLock *lock = [[NSLock alloc] init];
        
        //拿到相册数据并进行加载第一个画面
        [photoGroups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            dispatch_group_async(group, self.readAssetQueue, ^{
                
                PHAssetCollection *asset = (PHAssetCollection *)obj;
                //这里面是同步去获取资源
                CoreAlbumItem *item = [[CoreAlbumItem alloc] initWithAsset:asset];
                if (item.count) {
                    [lock lock];
                    [resultAssets addObject:item];
                    [lock unlock];
                }
            });
            //这样做有问题, 应该保证返回的同时,这个数组有数据
            //所以应该线程枷锁去做
            //方案一: 优缺点:   可以一个一个的执行, 并且都保证读取完成 ,
            //首先先开一个串行队列
            //开异步去做事情,
            //因为是block,外界也不知道是否里面拥有线程
            //所以外界上锁, 直至block打开之后再解锁
            //方案二: 优缺点: 可以多个执行, 最后一个执行之前保证其他的都执行完成,
            //因为是block,外界也不知道是否里面拥有线程  所以这一个方案会有问题, 这一步可以得到改善,让系统获取资源变成同步获取
            //首先开一个并行队列组
            //将除了最后一个任务,都放在组中, 然后利用notiy运行最后一个任务, 最后一个任务完成之后将数组返回
            
        }];
        
        dispatch_group_notify(group, self.readAssetQueue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //排序, 讲相机胶卷移到最开始
                NSInteger index = 0;
                for ( CoreAlbumItem *sub in resultAssets) {
                    if (sub.assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary ) {
                        break;
                    }
                    index++;
                }
                [resultAssets exchangeObjectAtIndex:index withObjectAtIndex:0];
                
                if ([SXCorePhotoConfig sharedInstance].isNeedCache) {
                    [[CorePhotoMemoryCache defaultCache] addAssetCollectionsCacheFor:resultAssets];
                }
                NSLog(@"%s 调用结束时间: %@",__func__,[NSDate date]);
                if (complateBlock) {
                    complateBlock(resultAssets,nil);
                }
            });
        });
        
        
    });
    
}

//获取对应相册集的相片
- (void)gainPhotosFromAlbum:(CoreAlbumItem *)album complate:(DownloadSystemImageComplateBlock)complateBlock
{
    NSLog(@"%s 调用开始时间: %@",__func__,[NSDate date]);
    NSLog(@"%f gainPhotosFromAlbum 使用内存",[MemoryMonitoring getDeviceUseMemory]);
    //这里需要做一个内存优化的判断
    if ([SXCorePhotoConfig sharedInstance].isNeedPhototLive) {// 因为PhotoLive比较占用内存, 所以这里的线程数尽量放小
        self.readQueue.maxConcurrentOperationCount = 3;
    }
    
    //标记
    static BOOL sign = NO;
    
    //授权
    PHAuthorizationStatus status = [PHPhotoLibrary  authorizationStatus];
    
    if (status == PHAuthorizationStatusNotDetermined) {//第一次使用
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
                if (!sign) {
                    sign = YES;
                    [self gainPhotosFromAlbum:album complate:complateBlock];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSError *error = [[NSError alloc] initWithDomain:kErrorAuthorizationWrongKey code:217 userInfo:@{kErrorAuthorizationWrongKey:@"权限错误"}];
                        if (complateBlock) {
                            complateBlock(nil,error);
                        }
                    });
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [[NSError alloc] initWithDomain:kErrorWithoutAuthorizationKey code:217 userInfo:@{kErrorWithoutAuthorizationKey:@"没有权限"}];
                    if (complateBlock) {
                        complateBlock(nil,error);
                    }
                });
            }
        }];
        
    }else if (status != PHAuthorizationStatusAuthorized) {//不是授权
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [[NSError alloc] initWithDomain:kErrorWithoutAuthorizationKey code:217 userInfo:@{kErrorWithoutAuthorizationKey:@"没有权限"}];
            if (complateBlock) {
                complateBlock(nil,error);
            }
        });
        return;
    }
    
    //缓存处理
    if ([SXCorePhotoConfig sharedInstance].isNeedCache) {
        
        NSArray *caches = [[CorePhotoMemoryCache defaultCache] getAssetsCacheForAssetCollection:album];
        
        if (caches) {
            //使用了缓存
            NSLog(@"使用了缓存照片");
            if (complateBlock) {
                complateBlock(caches,nil);
            }
            
            return ;
        }
    }
    
    NSLock *lock = [[NSLock alloc] init];
    
    
    dispatch_async(self.readAssetQueue, ^{//执行异步返回,不阻塞当前线程
        
        PHAssetCollection *asset = (PHAssetCollection *)album.assetCollection;
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        //搜索这不操作也占用时间 所以应该采用在子线程搜索
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:asset options:fetchOptions];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:result.count];
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.readQueue addOperationWithBlock:^{
                {
                    PHAsset *phototasset = (PHAsset *)obj;
                    phototasset.sx_targetSize = asset.sx_targetSize;
                    
                    CoreAssetBaseItem *item;
                    
                    switch (phototasset.mediaSubtypes) {
                            
                        case PHAssetMediaSubtypeNone:
                        {
                            switch (phototasset.mediaType) {
                                    
                                case PHAssetMediaTypeImage://子类型为无, 但是类型为image
                                {
                                    if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypePhoto) {
                                        item = [[CorePhotoItem alloc] initWithAsset:phototasset];
                                    }
                                }
                                    break;
                                    
                                case PHAssetMediaTypeVideo://子类型为无, 但是类型为video
                                {
                                    if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypeVideo) {
                                        item = [[CoreVideoItem alloc] initWithAsset:phototasset];
                                    }
                                }
                                    break;
                                case PHAssetMediaTypeAudio://子类型为无, 但是类型为audio
                                {//不尝试着去解析
//                                    @try {
//
//                                        if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypePhoto) {
//                                            item = [[CorePhotoItem alloc] initWithAsset:phototasset];
//                                        }
//
//                                    } @finally {
//
//                                    }
                                }
                                    break;
                                case PHAssetMediaTypeUnknown://子类型为无, 但是类型为未知 可以用image尝试一下
                                {//不尝试着去解析//这里有可能是GIF
                                    @try {
                                        if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypePhoto) {
                                            item = [[CorePhotoItem alloc] initWithAsset:phototasset];
                                        }

                                    } @finally {

                                    }
                                }
                                    break;
                            }
                            
                        }break;
                            // Photo subtypes
                        case PHAssetMediaSubtypePhotoPanorama:
                        case PHAssetMediaSubtypePhotoScreenshot:
                        case PHAssetMediaSubtypePhotoHDR:
                        case PHAssetMediaSubtypePhotoDepthEffect:
                        {
                            if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypePhoto) {
                                item = [[CorePhotoItem alloc] initWithAsset:phototasset];
                            }
                        }
                            break;
                            
                        case PHAssetMediaSubtypePhotoLive:
                        {
                            
                            if (@available(iOS 9.1, *)) {
                                
                                if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypeLivePhoto) {
                                    
                                    if ([SXCorePhotoConfig sharedInstance].isNeedPhototLive) {
                                        
                                        item = [[CoreLivePhotoItem alloc] initWithAsset:phototasset];
                                        
                                    }else{
                                        
                                        item = [[CorePhotoItem alloc] initWithAsset:phototasset];
                                        
                                    }
                                }
                                
                            }else{
                                if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypeLivePhoto) {
                                    item = [[CorePhotoItem alloc] initWithAsset:phototasset];
                                }
                            }
                            
                        }
                            break;
                            // video subtypes
                        case PHAssetMediaSubtypeVideoStreamed:
                        case PHAssetMediaSubtypeVideoHighFrameRate:
                        case PHAssetMediaSubtypeVideoTimelapse:
                        {
                            if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypeVideo) {
                                item = [[CoreVideoItem alloc] initWithAsset:phototasset];
                            }
                        }
                            break;
                        default:
                        {
                            @try {
                                if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypePhoto) {
                                    item = [[CorePhotoItem alloc] initWithAsset:phototasset];
                                }
                            } @finally {
                                
                            }
                        }
                            break;
                    }
                    
                    if (item && [item isKindOfClass:[CoreAssetBaseItem class]]) {
                        [lock lock];
                        [images addObject:item];
                        [lock unlock];
                    }
                }
            }];
            
        }];
        
        //在当前子线程等待readQueue队列执行完成
        [self.readQueue waitUntilAllOperationsAreFinished];
        
        //执行完成之后返回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([SXCorePhotoConfig sharedInstance].isNeedCache) {
                [[CorePhotoMemoryCache defaultCache] addAssetsCacheFor:images ofCollection:album];
            }
            NSLog(@"%f gainPhotosFromAlbum 后 使用内存",[MemoryMonitoring getDeviceUseMemory]);
            NSLog(@"%s 调用结束时间: %@",__func__,[NSDate date]);
            if (complateBlock) {
                complateBlock(images,nil);
            }
        });
        
    });
}


- (void)clearClutter
{
    //取消掉所有的操作
    [self.readQueue cancelAllOperations];
    
    [[CorePhotoMemoryCache defaultCache] clearCache];
    
}


@end
