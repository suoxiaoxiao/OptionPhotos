//
//  CorePhotoAsset.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//
/**
 类的说明:
 1: 这是核心类,这个核心讲的是提供相册功能,关键是与系统相册类操作
  提供对相册和照片的提取和删除和保存
 */
#import <Foundation/Foundation.h>
#import "CoreAssetBaseItem.h"
#import "CoreAlbumItem.h"
#import "CorePhotoItem.h"
#import "CoreVideoItem.h"
#import "CoreLivePhotoItem.h"
#import "SXCorePhotoConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// code = 217
static NSErrorDomain kErrorWithoutAuthorizationKey = @"kErrorWithoutAuthorizationKey";
/// code = 500
static NSErrorDomain kErrorAuthorizationWrongKey = @"kErrorAuthorizationWrongKey";

typedef void(^DownloadSystemAlbumsComplateBlock)( NSArray <CoreAlbumItem *>* _Nullable  param,  NSError *_Nullable error);
typedef void(^DownloadSystemImageComplateBlock)( NSArray <CoreAssetBaseItem *>* _Nullable  param, NSError * _Nullable error);

@interface CorePhotoAsset : NSObject

+ (instancetype)sharedInstance;

//获取非空相册集(其他软件创建的相册和自己的相机胶卷)
- (void)gainAlbums:(DownloadSystemAlbumsComplateBlock)complateBlock;

//获取对应相册集的相片
- (void)gainPhotosFromAlbum:( CoreAlbumItem *)album complate:(DownloadSystemImageComplateBlock)complateBlock;
/** 清空杂物, 释放占用缓存 */
- (void)clearClutter;

@end

NS_ASSUME_NONNULL_END
