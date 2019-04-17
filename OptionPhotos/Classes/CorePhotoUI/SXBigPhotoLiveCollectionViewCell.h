//
//  SXBigPhotoLiveCollectionViewCell.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreLivePhotoItem;
NS_ASSUME_NONNULL_BEGIN

@interface SXBigPhotoLiveCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong) CoreLivePhotoItem *item;

@end

NS_ASSUME_NONNULL_END
