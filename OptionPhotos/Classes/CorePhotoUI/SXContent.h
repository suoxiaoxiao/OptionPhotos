//
//  SXContent.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/7.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//屏幕宽
#define SX_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高
#define SX_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface SXContent : NSObject

+ (BOOL)ISIOSX;

+ (BOOL)isiOSX;
+ (BOOL)isiOSXR;
+ (BOOL)isiOSXSM;

@end

NS_ASSUME_NONNULL_END
