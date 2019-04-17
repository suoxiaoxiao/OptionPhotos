//
//  CoreVideoItem.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CoreVideoItem.h"
#import "PHAssetCollection+Thumb.h"

@implementation CoreVideoItem

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        
        //解析asset
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        //最后编辑
        options.version = PHImageRequestOptionsVersionCurrent;
        //一般图 为了平衡图像质量和响应速度 PHImageRequestOptionsDeliveryModeFastFormat
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        options.synchronous = YES;//同步
        
        self.localIdentifier = asset.localIdentifier;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:asset.sx_targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.coverImage = result;
        }];
        
        //获取视频
        PHVideoRequestOptions *videooption = [[PHVideoRequestOptions alloc] init];
        videooption.version = PHVideoRequestOptionsVersionCurrent;
        //最好的质量
        videooption.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;

        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videooption resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            self.videoAsset = asset;
            
        }];
        
        self.videoSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    CoreVideoItem *item = [[CoreVideoItem alloc] init];
    
    item.localIdentifier = self.localIdentifier;
    item.videoSize = self.videoSize;
    item.videoAsset = self.videoAsset;
    item.coverImage = self.coverImage;
    
    return item;
}

@end
