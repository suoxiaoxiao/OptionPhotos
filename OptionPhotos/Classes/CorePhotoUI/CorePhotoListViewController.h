//
//  CorePhotoListViewController.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//
/**
    这个界面是每一个相集的内部图片列表
 */
#import <UIKit/UIKit.h>
@class CoreAlbumItem;
NS_ASSUME_NONNULL_BEGIN

@interface CorePhotoListViewController : UIViewController

@property (nonatomic , strong) CoreAlbumItem *item;

@end

NS_ASSUME_NONNULL_END
