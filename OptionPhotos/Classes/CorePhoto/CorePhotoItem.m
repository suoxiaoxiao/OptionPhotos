//
//  CorePhotoItem.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CorePhotoItem.h"
#import "PHAssetCollection+Thumb.h"
#import "UIImage+compression.h"


@interface CorePhotoItem ()

@property (nonatomic , strong) PHAsset *asset;
@property (nonatomic , assign) PHImageRequestID ID;
@property (nonatomic , strong) UIImage *largeImage;

@end

@implementation CorePhotoItem

- (instancetype)initWithAsset:(PHAsset *)asset
{
    
    self = [super init];
    if (self) {
        
        self.asset = asset;
        self.localIdentifier = asset.localIdentifier;
        //解析asset
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        //最后编辑
        options.version = PHImageRequestOptionsVersionCurrent;
        //一般图
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        //这里必须规定尺寸,要不图片大小不受控制,会造成内存不稳定
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        options.synchronous = YES;//同步
        
//        @autoreleasepool {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:asset.sx_targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

                self.thumbSize = result.size;
                self.thumbnailImage = result;
//                NSLog(@"%@",NSStringFromCGSize(self.thumbnailImage.size));

            }];
            
//        }
        
    }
    return self;
}

- (void)cancleRequestImage
{
    if (self.ID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.ID];
    }
}

//异步操作获取图片
- (void)gainLargeImage:(void(^)(UIImage *large))complate
{
    if (self.largeImage) {
        complate(self.largeImage);
        return;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    //最后编辑
    options.version = PHImageRequestOptionsVersionCurrent;
    //获取原图 提供最高质量的图像，无论它需要多少时间加载
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.synchronous = NO;//异步  这里是同步会造成界面展示卡顿
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    float imageWidth = self.asset.pixelWidth;
    float imageHeight = self.asset.pixelHeight;
    float width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    float height = imageHeight/(imageWidth/width);
    
    //使用requestImageForAsset  会使用PHImageContentModeAspectFit 这个属性把图片本身进行一次裁剪
    self.ID = [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(width, height) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.largeImage = result;
            if (complate) {
                complate(result);
            }
        });
    }];
}
- (void)gainOriginImage:(void(^)(NSData *origin))complate
{
    if (self.originData) {
        if (complate) {
            complate(self.originData);
        }
        return ;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    //最后编辑
    options.version = PHImageRequestOptionsVersionCurrent;
    //获取原图 提供最高质量的图像，无论它需要多少时间加载
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = YES;//同步
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset
                                                      options:options
                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                    self.originData = imageData;
                                                    if (complate) {
                                                        complate(self.originData);
                                                    }
                                                }];
}

- (id)copyWithZone:(NSZone *)zone
{
    CorePhotoItem *item = [[CorePhotoItem alloc] init];
    
    item.localIdentifier = self.localIdentifier;
    item.asset = self.asset;
    item.originData = self.originData;
    item.largeImage = self.largeImage;
    item.thumbSize = self.thumbSize;
    item.thumbnailImage = self.thumbnailImage;
    item.originSize = self.originSize;
    
    return item;
}

@end
