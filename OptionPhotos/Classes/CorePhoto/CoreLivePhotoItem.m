//
//  CoreLivePhotoItem.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/28.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CoreLivePhotoItem.h"
#import "PHAssetCollection+Thumb.h"
#import "MemoryMonitoring.h"

@interface CoreLivePhotoItem ()

@property (nonatomic , strong) PHLivePhoto *livePhoto;

@end

@implementation CoreLivePhotoItem

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        NSLog(@"%s 前 使用内存:%f",__func__,[MemoryMonitoring getDeviceUseMemory]);
        
        self.asset = asset;
        
        self.localIdentifier = asset.localIdentifier;
        //解析asset
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        //最后编辑
        options.version = PHImageRequestOptionsVersionCurrent;
        //高清图
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        options.synchronous = YES;//同步
        
        if (@available(iOS 9.1, *)) {
            
            //由于这里比较消耗内存, 所以延迟加载
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
           
            
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                                       targetSize:asset.sx_targetSize
                                                      contentMode:PHImageContentModeAspectFit
                                                          options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                              self.coverImage = result;
           
                                                          }];
            
        } else {
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.synchronous = YES;//同步
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                                       targetSize:CGSizeZero
                                                      contentMode:PHImageContentModeAspectFit options:options
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        self.coverImage = result;
                                                        self.size = result.size;
                                                    }];
            
        }
        NSLog(@"%s 后 使用内存:%f",__func__,[MemoryMonitoring getDeviceUseMemory]);
    }
    return self;
}

- (void)gainLive:(OnLoadPhotoLiveBlock)block
{
    if (self.livePhoto) {
        if (block) {
            block(self.livePhoto);
            return;
        }
        return;
    }
    
    PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc] init];
    option.version =  PHImageRequestOptionsVersionCurrent;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
    float imageWidth = self.asset.pixelWidth;
    float imageHeight = self.asset.pixelHeight;
    float width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    float height = imageHeight/(imageWidth/width);
    
    [[PHImageManager defaultManager] requestLivePhotoForAsset:self.asset
                                                   targetSize:CGSizeMake(width, height)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:option
                                                resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
                                                    self.livePhoto = livePhoto;
                                                    self.size = livePhoto.size;
                                                    if (block) {
                                                        block(self.livePhoto);
                                                    }
                                                }];
}

- (id)copyWithZone:(NSZone *)zone
{
    CoreLivePhotoItem *item = [[CoreLivePhotoItem alloc] init];
    
    item.localIdentifier = self.localIdentifier;
    item.asset = self.asset;
    item.livePhoto = self.livePhoto;
    item.size = self.size;
    item.coverImage = self.coverImage;
    
    return item;
}

@end
