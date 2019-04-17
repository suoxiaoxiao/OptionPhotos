//
//  CoreVideoItem.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CoreAssetBaseItem.h"
/**
 类说明
 这是每一个视频的基本的模型
 
 视频文件
 视频首屏图
 视频界面尺寸
 视频时长
 
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface CoreVideoItem : CoreAssetBaseItem


@property (nonatomic , strong) AVAsset *videoAsset;

@property (nonatomic , strong) UIImage *coverImage;

@property (nonatomic , assign) CGSize videoSize;

@end

NS_ASSUME_NONNULL_END
