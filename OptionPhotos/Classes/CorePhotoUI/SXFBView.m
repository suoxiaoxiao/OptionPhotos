//
//  SXFBView.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXFBView.h"

@interface SXFBView ()

@property (nonatomic , strong) UILabel *animationLb;
@property (nonatomic , strong) UIButton *previewBtn;
@property (nonatomic , strong) UIButton *sendBtn;
@property (nonatomic , strong) UIImageView *line;

@end


@implementation SXFBView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.previewBtn setTitle:@"预览" forState:0];
        [self.previewBtn setTitle:@"预览" forState:UIControlStateDisabled];
        [self.previewBtn setTitleColor:UIColor.darkGrayColor forState:0];
        [self.previewBtn setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
        self.previewBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.previewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.previewBtn addTarget:self action:@selector(didPreViewAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.previewBtn];
        
        self.animationLb = [[UILabel alloc] init];
        self.animationLb.font = [UIFont systemFontOfSize:12];
        self.animationLb.textColor = [UIColor whiteColor];
        self.animationLb.textAlignment = NSTextAlignmentCenter;
        self.animationLb.layer.masksToBounds = YES;
        self.animationLb.layer.cornerRadius = 10;
        self.animationLb.backgroundColor = [UIColor colorWithRed:43/255.0 green:101/255.0 blue:249/255.0 alpha:1.0];
        [self addSubview:self.animationLb];
        
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sendBtn setTitle:@"发送" forState:0];
        [self.sendBtn setTitle:@"发送" forState:UIControlStateDisabled];
        [self.sendBtn setTitleColor:UIColor.darkGrayColor forState:0];
        [self.sendBtn setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
        self.sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.sendBtn addTarget:self action:@selector(didSendAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendBtn];
        
        self.line = [UIImageView new];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.line];
    }
    return self;
}

- (void)didPreViewAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fbviewDidPreviewActionOf:)]) {
        [self.delegate fbviewDidPreviewActionOf:self];
    }
}

- (void)didSendAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fbviewDidComplateActionOf:)]) {
        [self.delegate fbviewDidComplateActionOf:self];
    }
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    
    if (count <= 0) {
        //预览按钮置灰
        self.previewBtn.enabled = NO;
        //发送按钮置灰
        self.sendBtn.enabled = NO;
        //提示取消显示
        self.animationLb.hidden = YES;
    }else{
        //预览按钮启用
        self.previewBtn.enabled = YES;
        //发送按钮启用
        self.sendBtn.enabled = YES;
        //提示显示
        self.animationLb.hidden = NO;
        
        //进行提示动画
        self.animationLb.text = [NSString stringWithFormat:@"%ld",count];
        
        //动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[[NSNumber numberWithFloat:0.95],
                             [NSNumber numberWithFloat:1.2],
                             [NSNumber numberWithFloat:1.0]];
        animation.keyTimes = @[[NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:0.20],
                               [NSNumber numberWithFloat:0.5]];
        animation.duration = 0.5;
        animation.repeatCount = 1;
        animation.autoreverses = NO;
        [self.animationLb.layer addAnimation:animation forKey:@"transform"];
        
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.previewBtn.frame = CGRectMake(10, 0, 30, 44);
    
    self.animationLb.frame = CGRectMake(self.frame.size.width - 35 - 10 - 20, (44 - 20) * 0.5, 20, 20);
    
    self.sendBtn.frame = CGRectMake(self.frame.size.width - 30 - 10, 0, 30, 44);
    
    self.line.frame = CGRectMake(0, 0, self.frame.size.width, 1.0/[UIScreen mainScreen].scale);
    
}


@end
