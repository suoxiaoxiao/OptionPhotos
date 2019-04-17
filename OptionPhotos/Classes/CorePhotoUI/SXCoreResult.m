//
//  SXCoreResult.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXCoreResult.h"

NSString *const kSelectedAssetDidChangeNotification = @"kSelectedAssetDidChangeNotification";


@implementation SXCoreResult

+ (instancetype)sharedInstance
{
    static SXCoreResult *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance setUp];
    });
    return instance;
}
- (void)setUp{
    self.result = [NSMutableDictionary dictionary];
    self.selectedAsset = [NSMutableArray array];
}
- (void)addSelectedAsset:(CoreAssetBaseItem *)item
{
    if (item) {
        //判断是否有重复数据
        for (CoreAssetBaseItem *sub in self.selectedAsset) {
            
            if ([sub isEqual:item]) {//判断是否相同
                return;
            }
        }
        
        [self.selectedAsset addObject:item];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedAssetDidChangeNotification object:nil];
        
    }
}
- (void)removeSelectedAsset:(CoreAssetBaseItem *)item
{
    if (item) {//存在
        if ([self.selectedAsset containsObject:item]) {//是否报班
            [self.selectedAsset removeObject:item];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedAssetDidChangeNotification object:nil];
        }else{//不存在
            
            BOOL flag = NO;
            for (CoreAssetBaseItem *sub in self.selectedAsset) {
                if ([sub isEqual:item]) {//判断是否相同
                    item = sub;
                    flag = YES;
                    break;
                }
            }
            if (flag) {
                [self.selectedAsset removeObject:item];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedAssetDidChangeNotification object:nil];
            }
        }
    }
}

- (void)clearClutter
{
    [self.result removeAllObjects];
    [self.selectedAsset removeAllObjects];
}

@end
