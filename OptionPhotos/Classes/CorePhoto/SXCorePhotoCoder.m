//
//  SXCorePhotoCoder.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/7.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXCorePhotoCoder.h"

@interface SXCorePhotoCoder ()

@end


@implementation SXCorePhotoCoder

+ (instancetype)sharedInstance
{
    static SXCorePhotoCoder *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SXCorePhotoCoder alloc] init];
    });
    return instance;
}

@end
