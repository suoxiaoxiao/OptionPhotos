//
//  CoreAlbumItem.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CoreAlbumItem.h"
#import "SXCorePhotoConfig.h"
#import "UIImage+compression.h"
#import "PHAssetCollection+Thumb.h"

@implementation CoreAlbumItem

- (instancetype)initWithAsset:(PHAssetCollection *)asset
{
    if (self = [super init]) {
        
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:asset options:fetchOptions];
        
        //过滤个数
        NSMutableArray *temp = [NSMutableArray array];
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *sub = obj;
            switch (sub.mediaSubtypes) {
                case PHAssetMediaSubtypeNone:
                {
                    switch (sub.mediaType) {
                        case PHAssetMediaTypeImage:
                        {
                            if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypePhoto) {
                                [temp addObject:sub];
                            }
                        }
                            break;
                        case PHAssetMediaTypeVideo:
                        {
                            if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypeVideo) {
                                [temp addObject:sub];
                            }
                        }
                            break;
                        default:
                        {
                            
                        }
                            break;
                    }
                }
                    break;
                    //photo
                case  PHAssetMediaSubtypePhotoPanorama:
                case  PHAssetMediaSubtypePhotoScreenshot:
                case  PHAssetMediaSubtypePhotoDepthEffect:
                {
                    if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypePhoto) {
                        [temp addObject:sub];
                    }
                }
                    break;
                case PHAssetMediaSubtypePhotoHDR:
                case  PHAssetMediaSubtypePhotoLive:
                {
                    if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypeLivePhoto) {
                        [temp addObject:sub];
                    }
                }
                    break;
                    //video
                case PHAssetMediaSubtypeVideoStreamed:
                case PHAssetMediaSubtypeVideoHighFrameRate:
                case PHAssetMediaSubtypeVideoTimelapse:
                {
                    if ([SXCorePhotoConfig sharedInstance].demandType & CorePhotoDemandTypeVideo) {
                        [temp addObject:sub];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        result = nil;
        
        PHAsset *firstAsset = nil;
        if (temp.count > 0) {
           firstAsset =  temp.firstObject;
        }else
        {
            self.count = 0;
        }
        if (asset.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            //如果是相机胶卷 取的是最后一张
            firstAsset = temp.lastObject;
        }
        
        _assetCollection = asset;
        self.title = asset.localizedTitle;
        if ([asset.localizedTitle isEqualToString:@"Camera Roll"]) {
            self.title = @"相机胶卷";
        }
        self.count = temp.count;
        
        if (firstAsset) {
            
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            //编辑之后
            options.version = PHImageRequestOptionsVersionCurrent;
            //一般图
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            //这里必须规定尺寸,要不图片大小不受控制,会造成内存不稳定
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.synchronous = YES;//同步
            
            //这个方法是否会产生IO缓存 应该不会, 按照内存增生时间, 这里并不会产生IO缓存
            [[PHImageManager defaultManager] requestImageForAsset:firstAsset targetSize:asset.sx_targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                self.coverPhoto = result;
                
            }];
            
        }
        
    }
    
    return self;

}
- (id)copyWithZone:(nullable NSZone *)zone
{
    CoreAlbumItem *item = [CoreAlbumItem new];
    
    item.coverPhoto = self.coverPhoto;
    item.title = self.title;
    item.assetCollection = self.assetCollection;
    item.count = self.count;
    return item;
    
}



@end
