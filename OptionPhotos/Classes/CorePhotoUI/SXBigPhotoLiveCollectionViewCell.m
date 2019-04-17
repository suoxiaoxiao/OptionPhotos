//
//  SXBigPhotoLiveCollectionViewCell.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXBigPhotoLiveCollectionViewCell.h"
#import <PhotosUI/PhotosUI.h>
#import "CoreLivePhotoItem.h"

@interface SXBigPhotoLiveCollectionViewCell ()

@property (nonatomic , strong) PHLivePhotoView *livePhoto;


@end

@implementation SXBigPhotoLiveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (@available(iOS 9.1, *)) {
            self.contentView.backgroundColor = [UIColor blackColor];
            self.livePhoto = [[PHLivePhotoView alloc] init];
             [self.contentView addSubview:self.livePhoto];
        } else {
            // Fallback on earlier versions
        }
        
       
    }
    return self;
}

- (void)setItem:(CoreLivePhotoItem *)item
API_AVAILABLE(ios(9.1)){
    _item = item;
    NSLog(@"ssss");
    [item gainLive:^(PHLivePhoto *livePhoto) {
        self.livePhoto.livePhoto = livePhoto;
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (@available(iOS 9.1, *)) {
        self.livePhoto.frame = self.bounds;
    } else {
        // Fallback on earlier versions
    }
}

@end
