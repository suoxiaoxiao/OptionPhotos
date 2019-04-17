//
//  SXBaseCollectionViewCell.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoreAssetBaseItem;
@class SXBaseCollectionViewCell;

@protocol CollectionCellDidSelectedAssetDelegate <NSObject>

- (BOOL)collectionCell:(SXBaseCollectionViewCell *)cell  didSelected:(BOOL)selected forItem:(CoreAssetBaseItem *)item;

@end


NS_ASSUME_NONNULL_BEGIN

@interface SXBaseCollectionViewCell : UICollectionViewCell
@property (nonatomic , weak) id <CollectionCellDidSelectedAssetDelegate>delegate;
@property (nonatomic , strong) UIButton *selectedBtn;
@property (nonatomic , strong) CoreAssetBaseItem *item;
- (void)didSelectedBtn:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
