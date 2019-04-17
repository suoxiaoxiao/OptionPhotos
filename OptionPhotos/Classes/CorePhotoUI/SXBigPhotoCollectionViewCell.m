//
//  SXBigPhotoCollectionViewCell.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXBigPhotoCollectionViewCell.h"
#import "CorePhotoItem.h"

@interface SXBigPhotoCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) UIImageView *coverImage;

@end

@implementation SXBigPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.coverImage];
    }
    return self;
}

- (UIImageView *)coverImage
{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
        _coverImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImage;
}

- (void)setItem:(CorePhotoItem *)item
{
    _item = item;
    
    [item gainLargeImage:^(UIImage * _Nonnull large) {
        [self.coverImage setImage:large];
    }];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 5;
        _scrollView.zoomScale = 1.0;
        UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleRecognizer.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleRecognizer];
        
    }
    return _scrollView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale < 1) {
        scrollView.zoomScale = 1;
    }
}

- (void)doubleTap:(UIGestureRecognizer *)ges
{
    if (self.scrollView.zoomScale > 2) {
        [self.scrollView setZoomScale:1 animated:YES];
    }else{
        [self.scrollView setZoomScale:(self.scrollView.zoomScale + 1) animated:YES];
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.coverImage;//要放大的视图
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.coverImage.frame = self.bounds;
}

@end
