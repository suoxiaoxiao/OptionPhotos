//
//  CoreAlbumItem.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

/**
   类说明
    这是分组的模型
 
    一个相册拥有的字段
    封面图片
    相册名称
    相册名称对应的Code码(可以忽略)
    相册张数
 
 */

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreAlbumItem : NSObject <NSCopying>

@property (nonatomic , strong) UIImage *coverPhoto;//缩略图

@property (nonatomic , copy) NSString *title;

@property (nonatomic , strong) PHAssetCollection *assetCollection;

@property (nonatomic , assign) NSInteger count;

- (instancetype)initWithAsset:(PHAssetCollection *)asset;

@end

NS_ASSUME_NONNULL_END
