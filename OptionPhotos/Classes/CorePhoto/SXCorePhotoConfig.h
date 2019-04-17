//
//  SXCorePhotoConfig.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/5.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreAssetBaseItem;

typedef NS_OPTIONS(NSUInteger, CorePhotoDemandType) {
    CorePhotoDemandTypePhoto = 1 << 0,//0001
    CorePhotoDemandTypeLivePhoto = 1 << 1,//0010
    CorePhotoDemandTypeVideo = 1 << 2,//0100
    CorePhotoDemandTypeAll = 0b0111,//111
};


@protocol CorePhotoConfigDelegate <NSObject>
@optional
- (void)sxCorePhotoSelectedAssets:(NSMutableArray <CoreAssetBaseItem *>*)array;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SXCorePhotoConfig : NSObject

/**
 * 需求类型, 默认是CorePhotoDemandTypePhoto  就是获取照片中的资源来源类型
 */
@property (nonatomic , assign) CorePhotoDemandType demandType;

/**
 * 选择图片张数 默认是0
 * 0 代表无限制
 */
@property (nonatomic , assign) NSInteger selectorCount;

/** definition 与 definitionSize 是冲突的 , 只有一个值有效 definitionSize > definition */
/** default is 0.5
 值在0-1之间  0: 表示清晰度低 1:表示清晰度高  这个值只针对缩略图,
 大图也不会受到影响 ,
 原图不会压缩*/
@property (nonatomic , assign) float definition;
/** 无默认值 可以设置清晰度的大小, 这个大小不会造成图片拉伸 缩略图会按照Fit模式进行以设定尺寸为基准的缩放, 不会按照所给出尺寸严格进行返回*/
@property (nonatomic , assign) CGSize definitionSize;

/** 默认是yes 是否需要缓存已经获取的数据(相集/相片)  请注意这个是内存缓存 */
@property (nonatomic , assign) BOOL isNeedCache;

/** 默认是no, 是否需要live照片, 不需要会将live照片当做一般的图片处理*/
@property (nonatomic , assign) BOOL isNeedPhototLive;

+ (instancetype)sharedInstance;

@property (nonatomic , weak) id <CorePhotoConfigDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
