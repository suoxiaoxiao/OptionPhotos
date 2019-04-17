//
//  SXBigPicturePreviewViewController.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreAssetBaseItem;

NS_ASSUME_NONNULL_BEGIN

@interface SXBigPicturePreviewViewController : UIViewController

@property (nonatomic , strong) NSMutableArray <CoreAssetBaseItem *>*items;

@property (nonatomic , assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
