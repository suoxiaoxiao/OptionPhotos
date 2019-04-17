//
//  SXContent.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/7.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXContent.h"

@implementation SXContent

BOOL isiOSX(){
    return (SX_SCREEN_WIDTH == 375.0) && (SX_SCREEN_HEIGHT == 812);
}
BOOL isiOSXS(){
    return (SX_SCREEN_WIDTH == 375.0) && (SX_SCREEN_HEIGHT == 812);
}
BOOL isiOSXR(){
    return (SX_SCREEN_WIDTH == 414.0) && (SX_SCREEN_HEIGHT == 896.0);
}
BOOL isiOSXSMax(){
    return (SX_SCREEN_WIDTH == 414.0) && (SX_SCREEN_HEIGHT == 896.0);
}
BOOL ISIOSX(){
    
    if (isiOSX() || isiOSXS() || isiOSXR() || isiOSXSMax() ) {
        return YES;
    }
    return NO;
}

+ (BOOL)ISIOSX
{
   return ISIOSX();
}

+ (BOOL)isiOSX
{
    return isiOSX();
}
+ (BOOL)isiOSXR
{
    return isiOSXR();
}
+ (BOOL)isiOSXSM
{
    return isiOSXSMax();
}

@end
