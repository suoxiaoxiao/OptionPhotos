//
//  UIImage+compression.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/28.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (compression)

+ (UIImage *)sx_imageWithData:(NSData *)data;

- (UIImage *)sx_image;

+(UIImage *)sx_thbum_compressImageWith:(UIImage *)image;

+ (UIImage *)sx_compressImageWith:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
