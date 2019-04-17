//
//  PHAssetCollection+Thumb.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/29.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "PHAssetCollection+Thumb.h"
#import <objc/runtime.h>

@implementation PHAssetCollection (Thumb)

- (CGSize )sx_targetSize
{
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}
- (void)setSx_targetSize:(CGSize)sx_targetSize
{
    objc_setAssociatedObject(self, @selector(sx_targetSize),[NSValue valueWithCGSize:sx_targetSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
@implementation PHAsset (Thumb)

- (CGSize )sx_targetSize
{
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}
- (void)setSx_targetSize:(CGSize)sx_targetSize
{
    objc_setAssociatedObject(self, @selector(sx_targetSize), [NSValue valueWithCGSize:sx_targetSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
