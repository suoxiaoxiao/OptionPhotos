//
//  CoreAssetBaseItem.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/27.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CoreAssetBaseItem.h"

@implementation CoreAssetBaseItem

- (instancetype)initWithAsset:(PHAsset *)asset
{
    if (self = [super init]) {
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    
    if (object && [object isKindOfClass:[CoreAssetBaseItem class]]) {
        CoreAssetBaseItem *item = (CoreAssetBaseItem *)object;
        return [self.localIdentifier isEqualToString:item.localIdentifier];
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [CoreAssetBaseItem new];
}

@end
