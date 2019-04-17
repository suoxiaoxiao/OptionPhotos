//
//  SXBaseCollectionViewCell.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXBaseCollectionViewCell.h"
#import "CoreAssetBaseItem+SXUI.h"

@implementation SXBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CorePhotoResource" ofType:@"bundle"];
        [self.selectedBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"check_normal"]] forState:0];
        [self.selectedBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"check_selected"]] forState:UIControlStateSelected];
        [self.selectedBtn addTarget:self action:@selector(didSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectedBtn];
        
    }
    return self;
}

- (void)didSelectedBtn:(UIButton *)sender
{
    BOOL ret = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionCell:didSelected:forItem:)]) {
       ret = [self.delegate collectionCell:self didSelected:!self.selectedBtn.isSelected forItem:self.item];
    }
    if (ret) {
        self.selectedBtn.selected = !sender.isSelected;
        //动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[[NSNumber numberWithFloat:0.95],
                             [NSNumber numberWithFloat:1.2],
                             [NSNumber numberWithFloat:1.0]];
        animation.keyTimes = @[[NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:0.15],
                               [NSNumber numberWithFloat:0.3]];
        animation.duration = 0.3;
        animation.repeatCount = 1;
        animation.autoreverses = NO;
        [self.selectedBtn.layer addAnimation:animation forKey:@"transform"];
    }
}

- (void)setItem:(CoreAssetBaseItem *)item
{
    _item = item;
    
    self.selectedBtn.selected = item.selected;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectedBtn.frame = CGRectMake(self.frame.size.width - 30, 5, 25, 25);
}

@end
