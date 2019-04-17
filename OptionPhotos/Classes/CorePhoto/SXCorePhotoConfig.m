//
//  SXCorePhotoConfig.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/5.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXCorePhotoConfig.h"

@implementation SXCorePhotoConfig

+ (instancetype)sharedInstance
{
    static SXCorePhotoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SXCorePhotoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.demandType = CorePhotoDemandTypeAll;
    
    self.selectorCount = 0;
    
    self.definition = 0.5;
    
    self.isNeedCache = YES;
    
    self.isNeedPhototLive = NO;
}


@end
