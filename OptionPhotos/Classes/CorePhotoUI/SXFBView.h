//
//  SXFBView.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/4.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXFBView;

@protocol SXFBViewActionDelegate <NSObject>

- (void)fbviewDidPreviewActionOf:(SXFBView *)fbview;
- (void)fbviewDidComplateActionOf:(SXFBView *)fbview;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SXFBView : UIView

@property (nonatomic , assign) NSInteger count;

@property (nonatomic , weak) id<SXFBViewActionDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
