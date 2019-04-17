//
//  SXCoreResult.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreAssetBaseItem.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString  * const kSelectedAssetDidChangeNotification;


@interface SXCoreResult : NSObject

+ (instancetype)sharedInstance;

///添加里面的东西保证了唯一性
@property (nonatomic , strong) NSMutableArray <CoreAssetBaseItem *>*selectedAsset;

@property (nonatomic , strong) NSMutableDictionary *result;


- (void)addSelectedAsset:(CoreAssetBaseItem *)item;
- (void)removeSelectedAsset:(CoreAssetBaseItem *)item;
/** 清空缓存 */
- (void)clearClutter;

@end

NS_ASSUME_NONNULL_END
