//
//  SXCorePhotoCoder.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/7.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

//   由于图片加载的IO会缓存于内存中, 无法主动释放  则在这里去进行缓存来代替系统做的IO缓存

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXCorePhotoCoder : NSObject

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
