//
//  CorePhotoMemoryCache.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/30.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CorePhotoMemoryCache.h"

static NSString *kAssetCollectionDefaultKey = @"kAssetCollectionDefaultKey";

@interface CorePhotoMemoryCache()

@property (nonatomic , strong) NSMutableDictionary *cache;

@end

@implementation CorePhotoMemoryCache

- (NSMutableDictionary *)cache
{
    if (!_cache) {
        _cache = [NSMutableDictionary dictionary];
    }
    return _cache;
}

+ (instancetype)defaultCache
{
    static CorePhotoMemoryCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CorePhotoMemoryCache alloc] init];
    });
    return instance;
}
/*********************获取 -- START*****************************/
///获取相集缓存
- (NSArray<CoreAlbumItem * > * _Nullable )getAssetCollectionCacheForKey:(NSString * _Nullable)key
{
    //如果key不出在 则返回空
    //或者key不是NSString类型 则返回空
    //或者是空字符串 则返回空
    if ( !key || ![key isKindOfClass:[NSString class]] || [key isEqualToString:@""]) {
        key = kAssetCollectionDefaultKey;
    }else if (![self.cache.allKeys containsObject:key]) {
        return nil;
    }

    NSArray *result = [[self.cache objectForKey:key] copy];
    
    return result;

}
///获取相集里面的全部照片缓存
- (NSArray<CoreAssetBaseItem *> * _Nullable )getAssetsCacheForAssetCollection:(CoreAlbumItem *)collection
{
    //如果key不存在 返回空
    if (![self.cache.allKeys containsObject:collection.assetCollection.localIdentifier]) {
        return nil;
    }
    
    NSArray<CoreAssetBaseItem *> *result = [self.cache objectForKey:collection.assetCollection.localIdentifier];
    
    return [result copy];
}
/*****************************获取 -- END******************************/
/*****************************添加缓存 Collection***********************************/
///缓存添加相集
- (void)addAssetCollectionCacheFor:(CoreAlbumItem *)collection
{
    [self addAssetCollectionCacheFor:collection forKey:kAssetCollectionDefaultKey];
}
- (void)addAssetCollectionCacheFor:(CoreAlbumItem *)collection forKey:(NSString *)collectionsKey
{
    if ( !collectionsKey || ![collectionsKey isKindOfClass:[NSString class]] || [collectionsKey isEqualToString:@""]) {
        collectionsKey = kAssetCollectionDefaultKey;
    }
    
    //如果不包含
    if (![self.cache.allKeys containsObject:collectionsKey]) {
        NSMutableArray *saves = [NSMutableArray array];
        [saves addObject:[collection copy]];
        [self.cache setObject:saves forKey:collectionsKey];
        return;
    }
    
    //现获取相册集数组
    NSArray *array = [self.cache objectForKey:collectionsKey];
    
    int index = -1;
    for (CoreAlbumItem *item in array) {
        
        if ([item.assetCollection.localIdentifier isEqualToString:collection.assetCollection.localIdentifier]) {
            index++;
            break;
        }
        index++;
    }
    NSMutableArray *saves = [NSMutableArray arrayWithArray:array];
    if (index == -1) {//不是重复的
        [saves addObject:[collection copy]];
    }else{//是重复的相集
        [saves replaceObjectAtIndex:index withObject:[collection copy]];
    }
    
    [self.cache setObject:saves forKey:collectionsKey];
    
}

//添加多个相集
- (void)addAssetCollectionsCacheFor:(NSArray<CoreAlbumItem * > * )collections
{
    [self addAssetCollectionsCacheFor:collections forKey:kAssetCollectionDefaultKey];
}
- (void)addAssetCollectionsCacheFor:(NSArray<CoreAlbumItem *> *)collections forKey:(NSString *)collectionsKey
{
    if ( !collectionsKey || ![collectionsKey isKindOfClass:[NSString class]] || [collectionsKey isEqualToString:@""]) {
        collectionsKey = kAssetCollectionDefaultKey;
    }
    
    //如果不包含
    if (![self.cache.allKeys containsObject:collectionsKey]) {
        NSMutableArray *saves = [NSMutableArray array];
        for (CoreAlbumItem *item in collections) {
            [saves addObject:[item copy]];
        }
        [self.cache setObject:saves forKey:collectionsKey];
        return;
    }
    
    //现获取相册集数组
    NSArray *caches = [self.cache objectForKey:collectionsKey];
    NSMutableArray *saves = [NSMutableArray arrayWithArray:caches];
    
    //是否有重复的
    for (CoreAlbumItem *item in collections) {//遍历需要保存的相册集
        
        int index = -1;
        for (CoreAlbumItem *cacheItem in caches) {//遍历当前已经缓存的数组
            
            if ([item.assetCollection.localIdentifier isEqualToString:cacheItem.assetCollection.localIdentifier]) {
                index++;
                break;
            }
            index++;
        }
        
        if (index == -1) {//不是重复的
            [saves addObject:[item copy]];
        }else{//是重复的相集
            [saves replaceObjectAtIndex:index withObject:[item copy]];
        }
    }
    
    [self.cache setObject:saves forKey:collectionsKey];
}
/*****************************添加缓存 Collection***********************************/
/*****************************添加缓存 Asset***********************************/

///添加相集中的全部照片
- (void)addAssetsCacheFor:(NSArray<CoreAssetBaseItem *> *)asstes ofCollection:(CoreAlbumItem *)collection
{
    if (!collection || !asstes) {
        return ;
    }
    //如果不存在
    if (![self.cache.allKeys containsObject:collection.assetCollection.localIdentifier]) {
        
        [self.cache setObject:asstes forKey:collection.assetCollection.localIdentifier];
        
        return ;
    }
    
    NSMutableArray *need = [NSMutableArray arrayWithArray:asstes];
    NSString *key = collection.assetCollection.localIdentifier;
    
    //这里并不知道内存中保存着多少的照片, 所以采用异步处理
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        //拿出缓存:
        //如果存在
        NSArray *caches = [self.cache objectForKey:key];
        NSMutableArray *repeat = [NSMutableArray array];
        //去重
        if (caches.count > need.count) {
            for (CoreAssetBaseItem *assetneed in need) {
                for (CoreAssetBaseItem * assetcache in caches) {
                    if ([assetcache.localIdentifier isEqualToString:assetneed.localIdentifier]) {
                        [repeat addObject:assetcache];
                        break;
                    }
                }
            }
            
        }else{
            
            for (CoreAssetBaseItem *assetcache in caches) {
                for (CoreAssetBaseItem * assetneed in need) {
                    if ([assetcache.localIdentifier isEqualToString:assetneed.localIdentifier]) {
                        [repeat addObject:assetcache];
                        break;
                    }
                }
            }
        }
        
        //这里这样做的含义是用最新的覆盖新的 -->  删除旧的, 新增新的
        if (repeat.count) {
            
            NSMutableArray *cachesM = [NSMutableArray arrayWithArray:caches];
            [cachesM removeObjectsInArray:repeat];
            [need addObjectsFromArray:cachesM];
        }else{
            [need addObjectsFromArray:caches];
        }
        
        [self.cache setObject:need forKey:key];
    });
}

/*****************************添加缓存 Asset***********************************/

///删除相集
- (void)removeAssetCollectionCacheFor:(CoreAlbumItem *)collection
{
    if (!collection) {
        return ;
    }
    
    if (![self.cache.allKeys containsObject:kAssetCollectionDefaultKey]) {
        return ;
    }
    
    NSArray *caches = [self.cache objectForKey:kAssetCollectionDefaultKey];
    PHAssetCollection *need = nil;
    
    for (PHAssetCollection *coll in caches) {
        if ([coll.localIdentifier isEqualToString:collection.assetCollection.localIdentifier]) {
            need = coll;
            break;
        }
    }
    
    if (need) {
        NSMutableArray *save = [NSMutableArray arrayWithArray:caches];
        [save removeObject:need];
        [self.cache setObject:save forKey:kAssetCollectionDefaultKey];
    }
}
///删除多个相集
- (void)removeAssetCollectionsCacheFor:(NSArray<CoreAlbumItem * > *)collections
{
    if (!collections || ![collections isKindOfClass:[NSArray class]] || collections.count == 0) {
        return ;
    }
    for (CoreAlbumItem *coll in collections) {
        [self removeAssetCollectionCacheFor:coll];
    }
}
///删除相集相片
- (void)removeAssetsCacheFor:(CoreAlbumItem *)collection
{
    if (!collection || ![self.cache.allKeys containsObject:collection.assetCollection.localIdentifier]) {
        return ;
    }
    
    [self.cache removeObjectForKey:collection.assetCollection.localIdentifier];

}
///删除多个相集照片
- (void)removeAssetsCacheForMultipleCollection:(NSArray<CoreAlbumItem * > *)collections
{
    if (!collections || ![collections isKindOfClass:[NSArray class]] || collections.count == 0) {
        return ;
    }
    for (CoreAlbumItem *coll in collections) {
        [self removeAssetsCacheFor:coll];
    }
}

///清空缓存
- (void)clearCache
{
    [self.cache removeAllObjects];
}


@end
