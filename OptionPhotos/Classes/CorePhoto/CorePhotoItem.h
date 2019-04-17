//
//  CorePhotoItem.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CoreAssetBaseItem.h"


/**
 类说明
 这是每一张相片的模型
 
 缩略图数据
 原图数据
 图片大小
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface CorePhotoItem : CoreAssetBaseItem 

@property (nonatomic , strong) NSData *originData;//懒加载

@property (nonatomic , strong) UIImage *thumbnailImage;
@property (nonatomic , assign) CGSize originSize;
@property (nonatomic , assign) CGSize thumbSize;

//异步操作获取图片
- (void)gainLargeImage:(void(^)(UIImage *large))complate;
//异步操作获取图片
- (void)gainOriginImage:(void(^)(NSData *origin))complate;

- (void)cancleRequestImage;

@end

NS_ASSUME_NONNULL_END
