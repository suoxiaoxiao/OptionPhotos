//
//  SXBigVideoCollectionViewCell.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreVideoItem;
NS_ASSUME_NONNULL_BEGIN

@interface SXBigVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong) CoreVideoItem *item;

- (void)stopPlayer;

@end

NS_ASSUME_NONNULL_END
