//
//  LoopBannerView.h
//  KBLoopBannerViewDemo
//
//  Created by liuweiqing on 16/5/24.
//  Copyright © 2016年 Kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoopBannerView;

@protocol LoopBannerViewDelegate <NSObject>

- (void)bannerView:(LoopBannerView *)bannerView didClickImageAtIndex:(int)index;

@end

@interface LoopBannerView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray delegate:(id<LoopBannerViewDelegate>)delegate;
@property (nonatomic, weak) id<LoopBannerViewDelegate> delegate;

@end
