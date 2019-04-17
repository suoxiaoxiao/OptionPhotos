//
//  AlbumTableViewCell.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *image;
@property (nonatomic , strong) UILabel *titleLb;
@property (nonatomic , strong) UILabel *countLb;

@end

NS_ASSUME_NONNULL_END
