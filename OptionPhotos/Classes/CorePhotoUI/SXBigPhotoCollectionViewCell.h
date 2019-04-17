//
//  SXBigPhotoCollectionViewCell.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CorePhotoItem;
NS_ASSUME_NONNULL_BEGIN

@interface SXBigPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong) CorePhotoItem *item;

@end

NS_ASSUME_NONNULL_END
