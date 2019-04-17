//
//  CoreLivePhotoItem.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/28.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CoreAssetBaseItem.h"

typedef void(^OnLoadPhotoLiveBlock)(PHLivePhoto *livePhoto);

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(9.1))
@interface CoreLivePhotoItem : CoreAssetBaseItem

@property (nonatomic , strong) PHAsset *asset;

@property (nonatomic , strong) UIImage *coverImage;

@property (nonatomic , assign) CGSize size;

- (void)gainLive:(OnLoadPhotoLiveBlock)block;

@end

NS_ASSUME_NONNULL_END
