//
//  PHAssetCollection+Thumb.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/29.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAssetCollection (Thumb)

@property (nonatomic , assign) CGSize sx_targetSize;

@end


@interface PHAsset (Thumb)

@property (nonatomic , assign) CGSize sx_targetSize;

@end

NS_ASSUME_NONNULL_END
