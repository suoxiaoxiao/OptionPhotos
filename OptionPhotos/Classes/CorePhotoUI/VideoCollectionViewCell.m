//
//  VideoCollectionViewCell.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import "CoreVideoItem.h"

@interface VideoCollectionViewCell ()

@property (nonatomic , strong) UIImageView *image;

@end


@implementation VideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImageView new];
        self.image.layer.masksToBounds = YES;
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.image];
        [self bringSubviewToFront:self.selectedBtn];
    }
    return self;
}

- (void)setItem:(CoreAssetBaseItem *)item
{
    [super setItem:item];
    
    CoreVideoItem *obj = (CoreVideoItem *)item;
    
    [self.image setImage:obj.coverImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.image.frame = self.bounds;
}

@end
