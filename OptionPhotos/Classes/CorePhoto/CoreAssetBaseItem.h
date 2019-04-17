//
//  CoreAssetBaseItem.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/**
 类说明
 这是每一个资源的基本的模型
 
 资源类型
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface CoreAssetBaseItem : NSObject <NSCopying>

@property (nonatomic , copy) NSString *localIdentifier;

- (instancetype)initWithAsset:(PHAsset *)asset;



@end

NS_ASSUME_NONNULL_END
