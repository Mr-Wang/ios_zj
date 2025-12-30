//
//  KL_ImageZoomView.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "KL_ImageZoomView.h"
#define HandDoubleTap 2
#define HandOneTap 1
#define MaxZoomScaleNum 5.0
#define MinZoomScaleNum 1.0
@implementation KL_ImageZoomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

//获取图片和显示视图宽度的比例系数
- (float)getImgWidthFactor {
   return   self.bounds.size.width / self.image.size.width;
}
//获取图片和显示视图高度的比例系数
- (float)getImgHeightFactor {
    return  self.bounds.size.height / self.image.size.height;
}

//获获取尺寸
- (CGSize)newSizeByoriginalSize:(CGSize)oldSize maxSize:(CGSize)mSize
{
    if (oldSize.width <= 0 || oldSize.height <= 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = CGSizeZero;
    if (oldSize.width > mSize.width || oldSize.height > mSize.height) {
        //按比例计算尺寸
        float bs = [self getImgWidthFactor];
        float newHeight = oldSize.height * bs;
        newSize = CGSizeMake(mSize.width, newHeight);
        
        if (newHeight > mSize.height) {
            bs = [self getImgHeightFactor];
            float newWidth = oldSize.width * bs;
            newSize = CGSizeMake(newWidth, mSize.height);
        }
    }else {
        
        newSize = oldSize;
    }
    return newSize;
}

- (void)_initView {
    
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    [_scrollView addSubview:_containerView];
    
    [self addSubview:_scrollView];

    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_containerView addSubview:_imageView];
    
    //双击
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(TapsAction:)];
    [doubleTapGesture setNumberOfTapsRequired:HandDoubleTap];
    [_containerView addGestureRecognizer:doubleTapGesture];
    
    //单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(TapsAction:)];
    [tapGesture setNumberOfTapsRequired:HandOneTap];
    [_containerView addGestureRecognizer:tapGesture];
    
    //双击失败之后执行单击
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];


    DDProgressView *pro = [[DDProgressView alloc] initWithFrame:CGRectMake(0.0f, (self.bounds.size.height - 2) * 0.5, self.frame.size.width, 5)];
    self.progress = pro;
    self.progress.progress = 0.0;
    self.progress.hidden = YES;
    self.progress.innerColor = [UIColor redColor];//进度颜色
    self.progress.emptyColor = [UIColor whiteColor];//背景
    [self addSubview:self.progress];
 
    
//    CGSize showSize = [self newSizeByoriginalSize:self.image.size maxSize:self.bounds.size];
//
//    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, showSize.width, showSize.height)];
//    imgview.image = self.image;
//     self.imageView = imgview;
//    [imgview release];
    
    self.scrollView.maximumZoomScale = MaxZoomScaleNum;
    self.scrollView.minimumZoomScale = MinZoomScaleNum;
    self.scrollView.zoomScale = MinZoomScaleNum;

}

- (void)resetViewFrame:(CGRect)newFrame
{
    self.frame = newFrame;
    _scrollView.frame = self.bounds;
    _containerView.frame = self.bounds;
    
    CGSize vsize = self.frame.size;
    self.progress.hidden = NO;
    self.progress.frame = CGRectMake(15, (vsize.height - 2) * 0.5,vsize.width - 30 , 2);
}


#pragma mark- 手势事件
//单击 / 双击 手势
- (void)TapsAction:(UITapGestureRecognizer *)tap
{
    [self View_TouchDown:nil];
    NSInteger tapCount = tap.numberOfTapsRequired;
    if (HandDoubleTap == tapCount) {
        //双击
        NSLog(@"双击");
        if (self.scrollView.minimumZoomScale <= self.scrollView.zoomScale && self.scrollView.maximumZoomScale > self.scrollView.zoomScale) {
            [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
        }else {
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        }
        
    }else if (HandOneTap == tapCount) {
        //单击
        NSLog(@"单击");
//        NSLog(@"imgUrl: %@, imgSize:(%f, %f) zoomScale:%f",downImgUrl,self.imageView.frame.size.width,self.imageView.frame.size.height,self.scrollView.zoomScale);
        
    }
    
    
}

- (void)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
#pragma mark- Properties

- (UIImage *)image {
    return _imageView.image;
}

- (void)setImage:(UIImage *)image {
    if(self.imageView == nil){
        self.imageView = [UIImageView new];
        self.imageView.clipsToBounds = YES;
    }
    self.imageView.image = image;
}

//本地图片
- (void)updateImage:(NSString *)imgName {
    self.scrollView.scrollEnabled = YES;
    self.image = [UIImage imageNamed:imgName];
    [self setImageViewWithImg:self.image];
}
//网络图片
- (void)uddateImageWithUrl:(NSString *)imgUrl withSize:(CGSize)withSize
{
    
    self.scrollView.scrollEnabled = NO;
//    self.imageView.image = nil;
    downImgUrl = imgUrl;
    NSLog(@"%@",downImgUrl);
    self.scrollView.scrollEnabled = YES;
    CGSize size = withSize;
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        size = CGSizeMake(kScreenWidth , kScreenHeight - 20 - 44 -44);
    }
    CGSize itemSize = size;
    if(!(size.width <= kScreenWidth && size.height <= kScreenHeight - 20 - 44 -44))
    {
        float mainW = kScreenWidth;
        float mainH = kScreenHeight - 20 - 44 -44;
        float b = mainW/size.width < mainH/size.height ? mainW/size.width : mainH/size.height;
        
        itemSize = CGSizeMake(b*size.width, b*size.height);
        
        UIGraphicsBeginImageContext(itemSize);
    }
    self.imageView.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _scrollView.zoomScale = 1;
    _scrollView.contentOffset = CGPointZero;
    _containerView.bounds = _imageView.bounds;
    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
    [self scrollViewDidZoom:_scrollView];
    // ----- houjia
    /**
     * 检查下载队列中是否已经存在此url
     * 如果存在 则获取已经下载的进度
     * 如果不存在则开始新的下载
     **/
    __block typeof(self) weakSelf = self;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:downImgUrl] options:SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progress.progress = (float)receivedSize/expectedSize;//receivedSize / expectedSize;
        if (receivedSize / expectedSize >= 1) {
            weakSelf.progress.hidden = YES;
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
         weakSelf.progress.hidden = YES;
        if (finished) {
            [weakSelf.imageView setImage:image];
        }
    }];
}

-(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
-(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
-(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

- (void)setImageViewWithImg:(UIImage *)img {
    self.scrollView.scrollEnabled = YES;
    self.progress.hidden = YES;
    self.imageView.image = img;
    CGSize size = img.size;
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        size = CGSizeMake(kScreenWidth , kScreenHeight - 20 - 44 -44);
    }
    CGSize itemSize = size;
    if(!(size.width <= kScreenWidth && size.height <= kScreenHeight - 20 - 44 -44))
    {
        float mainW = kScreenWidth;
        float mainH = kScreenHeight - 20 - 44 -44;
        float b = mainW/size.width < mainH/size.height ? mainW/size.width : mainH/size.height;
        itemSize = CGSizeMake(b*size.width, b*size.height);
        UIGraphicsBeginImageContext(itemSize);
    }
    self.imageView.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _scrollView.zoomScale = 1;
    _scrollView.contentOffset = CGPointZero;
    _containerView.bounds = _imageView.bounds;
    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
    [self scrollViewDidZoom:_scrollView];
    
    
//    
//    //
//    self.scrollView.scrollEnabled = NO;
//    self.imageView.image = nil;
//    downImgUrl = imgUrl;
//    NSLog(@"%@",downImgUrl);
//    self.scrollView.scrollEnabled = YES;
//    CGSize size = withSize;
//    if(CGSizeEqualToSize(CGSizeZero, size))
//    {
//        size = CGSizeMake(kScreenWidth , kScreenHeight - 20 - 44 -44);
//    }
//    CGSize itemSize = size;
//    if(!(size.width <= kScreenWidth && size.height <= kScreenHeight - 20 - 44 -44))
//    {
//        float mainW = kScreenWidth;
//        float mainH = kScreenHeight - 20 - 44 -44;
//        float b = mainW/size.width < mainH/size.height ? mainW/size.width : mainH/size.height;
//        
//        itemSize = CGSizeMake(b*size.width, b*size.height);
//        
//        UIGraphicsBeginImageContext(itemSize);
//    }
//    self.imageView.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    _scrollView.zoomScale = 1;
//    _scrollView.contentOffset = CGPointZero;
//    _containerView.bounds = _imageView.bounds;
//    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
//    [self scrollViewDidZoom:_scrollView];
}

//- (void)setImageView:(UIImageView *)imageView {
//    if(imageView != _imageView){
//        [_imageView removeObserver:self forKeyPath:@"image"];
//        [_imageView removeFromSuperview];
//        
//        _imageView = imageView;
//        
//        CGSize showSize = [self newSizeByoriginalSize:self.image.size maxSize:self.bounds.size];
//
//        _imageView.frame = CGRectMake(0, 0, showSize.width, showSize.height);
//        
//        [_imageView addObserver:self forKeyPath:@"image" options:0 context:nil];
//        
//        [_containerView addSubview:_imageView];
//        
//        _scrollView.zoomScale = 1;
//        _scrollView.contentOffset = CGPointZero;
//        _containerView.bounds = _imageView.bounds;
//        
//        [self resetZoomScale];
//        _scrollView.zoomScale  = _scrollView.minimumZoomScale;
//        [self scrollViewDidZoom:_scrollView];
//    }
//    
//}

- (BOOL)isViewing {
    return (_scrollView.zoomScale != _scrollView.minimumZoomScale);
}

#pragma mark- observe
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if(object==self.imageView){
//        [self imageDidChange];
//    }
//}

//- (void)imageDidChange {
//    CGSize size = (self.imageView.image) ? self.imageView.image.size : self.bounds.size;
//    CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
//    CGFloat W = ratio * size.width;
//    CGFloat H = ratio * size.height;
//    self.imageView.frame = CGRectMake(0, 0, W, H);
//    
//    _scrollView.zoomScale = 1;
//    _scrollView.contentOffset = CGPointZero;
//    _containerView.bounds = _imageView.bounds;
//    
//    [self resetZoomScale];
//    _scrollView.zoomScale  = _scrollView.minimumZoomScale;
//    [self scrollViewDidZoom:_scrollView];
//}

#pragma mark- Scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containerView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _containerView.frame.size.width;
    CGFloat H = _containerView.frame.size.height;
    
    CGRect rct = _containerView.frame;
    rct.origin.x = MAX((Ws-W)*0.5, 0);
    rct.origin.y = MAX((Hs-H)*0.5, 0);
    _containerView.frame = rct;
    
}



//- (void)resetZoomScale {
//    CGFloat Rw = _scrollView.frame.size.width / self.imageView.frame.size.width;
//    CGFloat Rh = _scrollView.frame.size.height / self.imageView.frame.size.height;
//    
//    CGFloat scale = 1;
//    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
//    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
//    
//    _scrollView.contentSize = _imageView.frame.size;
//    _scrollView.minimumZoomScale = 1;
//    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
//}
 

@end
