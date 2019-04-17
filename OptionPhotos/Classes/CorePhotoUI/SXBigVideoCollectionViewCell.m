//
//  SXBigVideoCollectionViewCell.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SXBigVideoCollectionViewCell.h"
#import <AVKit/AVKit.h>
#import "CoreVideoItem.h"

@interface SXBigVideoCollectionViewCell ()

@property (nonatomic , strong) AVPlayer *player;
@property (nonatomic , strong) AVPlayerLayer *playerLayer;
@property (nonatomic , strong) UIButton *playerBtn;

@end

@implementation SXBigVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord
                 withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                       error:nil];
        AVPlayerLayer *layer = [[AVPlayerLayer alloc] init];
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerLayer = layer;
        [self.contentView.layer addSublayer:layer];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CorePhotoResource" ofType:@"bundle"];
        
        self.playerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.playerBtn setImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"player"]] forState:0];
        [self.playerBtn setImage:[UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"pause"]] forState:UIControlStateSelected];
        [self.playerBtn addTarget:self action:@selector(playerControl:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.playerBtn];
        
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView)]];
        
    }
    return self;
}

- (void)tapContentView
{
    self.playerBtn.hidden = NO;

    if (self.playerBtn.isSelected) {//播放
        
        [self performSelector:@selector(hideControlBtn) withObject:nil afterDelay:1.5];

    }
}

- (void)playerControl:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlBtn) object:nil];
    
    if (sender.selected) {//播放
        
        [self.player play];
        [self performSelector:@selector(hideControlBtn) withObject:nil afterDelay:1.5];
        
    }else{//暂停
        
        [self.player pause];
    }
}

- (void)hideControlBtn
{
    self.playerBtn.hidden = YES;
}

- (void)stopPlayer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlBtn) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player pause];
    [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    self.playerBtn.selected = NO;
    self.playerBtn.hidden = NO;
    
}

- (void)setItem:(CoreVideoItem *)item
{
    _item = item;
    
    [self.player pause];
    self.player = nil;
    
    AVPlayerItem *playitem = [[AVPlayerItem alloc] initWithAsset:item.videoAsset];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:playitem];
    self.playerLayer.player = self.player;
    
    //设置视频跳转到开始的位置
    [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    //关注播放结束的通知,关注通知AVPlayerItemDidPlayToEndTimeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //让视频暂停
     [self.player pause];
}

- (void)playEnd:(NSNotification *)not
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //跳转到开头
        self.playerBtn.selected = NO;
        self.playerBtn.hidden = NO;
        [self.player pause];
        [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    
    self.playerBtn.frame = CGRectMake((self.frame.size.width - 64) * 0.5, (self.frame.size.height - 64) * 0.5, 64, 64);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
