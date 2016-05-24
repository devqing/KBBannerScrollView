//
//  LoopBannerView.m
//  KBLoopBannerViewDemo
//
//  Created by liuweiqing on 16/5/24.
//  Copyright © 2016年 Kobe. All rights reserved.
//

#import "LoopBannerView.h"
#import "UIImageView+WebCache.h"

@interface LoopBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) int currentPageIndex;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LoopBannerView

#pragma mark --init
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray delegate:(id<LoopBannerViewDelegate>)delegate
{
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
        self.imageArray = imageArray;
        self.currentPageIndex = 0;
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;

    for (int i = 0; i < self.scrollView.subviews.count; i ++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*3, 0);
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    self.pageControl.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 10);
}

- (void)nextPage
{
    [self.scrollView setContentOffset:CGPointMake(2*self.frame.size.width, 0) animated:YES];
}

#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetx = scrollView.contentOffset.x;
    CGFloat offsety = scrollView.contentOffset.y;
    if (offsetx <= 0) {
        // 向前面翻页
        self.currentPageIndex = self.currentPageIndex-1;
        if (self.currentPageIndex < 0) {
            self.currentPageIndex = (int)self.imageArray.count-1;
        }
        [self refreshScroll];
    }
    if (offsetx >= self.frame.size.width*2) {
        // 向后面翻页
        self.currentPageIndex = self.currentPageIndex+1;
        if (self.currentPageIndex > self.imageArray.count-1) {
            self.currentPageIndex = 0;
        }
        [self refreshScroll];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


#pragma mark --reload scrollview
- (void)refreshScroll
{
    NSArray *indexArray = [self fetchIndex];
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[[indexArray[i] intValue]]]];
    }
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    self.pageControl.currentPage = self.currentPageIndex;
}

#pragma mark --计算当前页的前一页和后一页
- (NSArray *)fetchIndex
{
    int preIndex = self.currentPageIndex-1;
    int nextIndex = self.currentPageIndex+1;
    if (preIndex < 0) {
        preIndex = (int)self.imageArray.count-1;
    }
    if (nextIndex > (int)self.imageArray.count-1) {
        nextIndex = 0;
    }
    
    return @[@(preIndex),@(self.currentPageIndex),@(nextIndex)];
}

#pragma mark --image taped
- (void)imageTap
{
    if ([self.delegate respondsToSelector:@selector(bannerView:didClickImageAtIndex:)]) {
        [self.delegate bannerView:self didClickImageAtIndex:self.currentPageIndex];
    }
}

#pragma mark --getter&setter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        for (NSNumber *number in [self fetchIndex]) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[[number intValue]]]];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)]];
            [_scrollView addSubview:imageView];
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.imageArray.count;
        _pageControl.currentPage = self.currentPageIndex;
        
    }
    return _pageControl;
}

@end
