//
//  PhotoCollectionViewCell.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "CorePhotoItem.h"
#import "CoreLivePhotoItem.h"

@interface PhotoCollectionViewCell ()

@property (nonatomic , strong) UIImageView *image;


@end

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImageView new];
        self.image.layer.masksToBounds = YES;
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.image];
//        self.selectedBtn.backgroundColor = [UIColor redColor];
        [self.contentView bringSubviewToFront:self.selectedBtn];
        
    }
    return self;
}

- (void)setItem:(CoreAssetBaseItem *)item
{
    [super setItem:item];
    
    if ([item isKindOfClass:[CorePhotoItem class]]) {
        CorePhotoItem *obj = (CorePhotoItem *)item;
        
        [self.image setImage:obj.thumbnailImage];
    }else{
        
        if (@available(iOS 9.1, *)) {
            
            CoreLivePhotoItem *obj = (CoreLivePhotoItem *)item;
            [self.image setImage:obj.coverImage];
            
        } else {
        }
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.image.frame = self.bounds;
    
}
@end
