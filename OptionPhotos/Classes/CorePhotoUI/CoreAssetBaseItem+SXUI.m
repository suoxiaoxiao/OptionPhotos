//
//  CoreAssetBaseItem+SXUI.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "CoreAssetBaseItem+SXUI.h"
#import <objc/runtime.h>

@implementation CoreAssetBaseItem (SXUI)

- (BOOL)selected
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setSelected:(BOOL)selected
{
    objc_setAssociatedObject(self, @selector(selected), [NSNumber numberWithBool:selected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
