# KBBannerScrollView

使用方法

// 添加bannerview
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bannerView];
}
// 创建bannerview
- (LoopBannerView *)bannerView
{
    if (_bannerView == nil) {
        _bannerView = [[LoopBannerView alloc] initWithFrame:CGRectMake(0, 100, width, 200) imageArray:self.imageArray delegate:self];
    }
    return _bannerView;
}
// bannerview 回调
- (void)bannerView:(LoopBannerView *)bannerView didClickImageAtIndex:(int)index
{
    NSLog(@"----%d",index);
}

- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] init];
        NSString *bannerDic = @"http://7xpt10.com1.z0.glb.clouddn.com/default.jpg";
        [_imageArray addObject:bannerDic];
        NSString *bannerDic1 = @"http://7xpt10.com1.z0.glb.clouddn.com/thumb_IMG_0248_1024.jpg";
        [_imageArray addObject:bannerDic1];
        NSString *bannerDic2 = @"http://7xpt10.com1.z0.glb.clouddn.com/thumb_IMG_0141_1024.jpg";
        [_imageArray addObject:bannerDic2];
        NSString *bannerDic3 = @"http://7xpt10.com1.z0.glb.clouddn.com/thumb_IMG_0248_1024.jpg";
        [_imageArray addObject:bannerDic3];
        NSString *bannerDic4 = @"http://7xpt10.com1.z0.glb.clouddn.com/571894726703c007b4d0e427.jpg";
        [_imageArray addObject:bannerDic4];
        
    }
    return _imageArray;
}


效果图

![image](https://github.com/niuniuKobe/KBBannerScrollView/blob/master/KBLoopBannerViewDemo/demo.gif)
