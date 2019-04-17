//
//  CorePhotoCache.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/30.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

/**
 
 存储思路:
 仅仅是内初引用
 第一:相集的保存内部会自己生成一个数据来保存相集,也可以自己设定一个Key来保存需要自定义的相集
 第二:相册的保存是针对每一个相集来说的, 会根据每一个相集的id来保存相集中的相片  是一一对应的
  */

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "CorePhotoAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface CorePhotoMemoryCache : NSObject

+ (instancetype)defaultCache;

///获取相集缓存
- (NSArray<CoreAlbumItem * > * _Nullable )getAssetCollectionCacheForKey:(NSString * _Nullable)key;
///获取相集里面的全部照片缓存
- (NSArray<CoreAssetBaseItem *> * _Nullable )getAssetsCacheForAssetCollection:(CoreAlbumItem *)collection;

///缓存添加相集到默认相册集数组
- (void)addAssetCollectionCacheFor:(CoreAlbumItem *)collection;
///缓存到传进去的key的相册集数组
- (void)addAssetCollectionCacheFor:(CoreAlbumItem *)collection forKey:(NSString *)collectionsKey;
//添加多个相集
- (void)addAssetCollectionsCacheFor:(NSArray<CoreAlbumItem * > * )collections;
///缓存到传进去的key的相册集数组
- (void)addAssetCollectionsCacheFor:(NSArray<CoreAlbumItem * > * )collections forKey:(NSString *)collectionsKey;

///添加相集中的全部照片
- (void)addAssetsCacheFor:(NSArray<CoreAssetBaseItem *> *)asstes ofCollection:(CoreAlbumItem *)collection;
///删除相集
- (void)removeAssetCollectionCacheFor:(CoreAlbumItem *)collection;
///删除多个相集
- (void)removeAssetCollectionsCacheFor:(NSArray<CoreAlbumItem * > *)collections;
///删除相集相片
- (void)removeAssetsCacheFor:(CoreAlbumItem *)collection;
///删除多个相集照片
- (void)removeAssetsCacheForMultipleCollection:(NSArray<CoreAlbumItem * > *)collections;
///清空缓存
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
