//
//  AlbumTableViewCell.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/3.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "AlbumTableViewCell.h"

@interface AlbumTableViewCell ()

@property (nonatomic , strong) UIImageView *line;

@end

@implementation AlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.image = [[UIImageView alloc] init];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        self.image.layer.masksToBounds = YES;
        [self.contentView addSubview:self.image];
        
        self.line = [[UIImageView alloc] init];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.line];
        
        self.titleLb = [[UILabel alloc] init];
        self.titleLb.textColor = UIColor.blackColor;
        self.titleLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLb];
        
        self.countLb = [[UILabel alloc] init];
        self.countLb.textColor = UIColor.grayColor;
        self.countLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.countLb];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.line.frame = CGRectMake(15, self.frame.size.height - 1, self.frame.size.width - 15, 1.0/[UIScreen mainScreen].scale);
    self.image.frame = CGRectMake(10, 10, 50, 50);
    self.titleLb.frame = CGRectMake(70, 10, self.frame.size.width - 70, 20);
    self.countLb.frame = CGRectMake(70, 30, self.frame.size.width - 70, 20);
}

@end
