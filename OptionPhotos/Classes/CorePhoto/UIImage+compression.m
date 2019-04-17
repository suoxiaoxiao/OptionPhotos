//
//  UIImage+compression.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/28.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "UIImage+compression.h"
#import "MemoryMonitoring.h"

@implementation UIImage (compression)


+ (UIImage *)sx_imageWithData:(NSData *)data
{
//    NSLog(@"前: %f",[MemoryMonitoring getDeviceUseMemory]);
    UIImage *image = [UIImage imageWithData:data];
//    NSLog(@"后: %f",[MemoryMonitoring getDeviceUseMemory]);
    
    if (data.length/1024 > 128) {
        image = [self sx_compressImageWith:image];
    }
//    NSLog(@"压缩后: %f",[MemoryMonitoring getDeviceUseMemory]);
    return image;
}

- (UIImage *)sx_image
{
    NSData *data = UIImageJPEGRepresentation(self, 1);
    
    UIImage *image = [UIImage imageWithData:data];
    
    if (data.length/1024 > 128) {
        image = [UIImage sx_compressImageWith:image];
    }
    
    return image;
}

+(UIImage *)sx_thbum_compressImageWith:(UIImage *)image
{
    //    NSLog(@"%@",[NSThread currentThread]);
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 256;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth/width;
    float heightScale = imageHeight/height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0,0,imageWidth/heightScale,height)];
    }
    else {
        [image drawInRect:CGRectMake(0,0,width,imageHeight/widthScale)];
    }
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)sx_compressImageWith:(UIImage *)image
{
//    NSLog(@"%@",[NSThread currentThread]);
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth/width;
    float heightScale = imageHeight/height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0,0,imageWidth/heightScale,height)];
    }
    else {
        [image drawInRect:CGRectMake(0,0,width,imageHeight/widthScale)];
    }
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
