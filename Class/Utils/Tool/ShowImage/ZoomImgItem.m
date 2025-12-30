//
//  ZoomImgItem.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "ZoomImgItem.h"
@implementation ZoomImgItem
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


- (void)_initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    imageView = [[KL_ImageZoomView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imageView];
}
- (void)setImgPictures:(NSString *)imgPictures {
    if (imgPictures != nil && ![imgPictures isEqualToString:@""]) {
        //如果传了缩略图片-查看是否有图片缓存；如果有缓存则初始加载缓存图片-
        //cache第一种 message imgSD
//        UIImage *cacheImage = [XHCacheManager imageWithURL:[NSURL URLWithString:imgPictures] storeMemoryCache:NO];
//        if  (!cacheImage) {
//            //cache第二种 buttonSd
//            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imgPictures]];
//            cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
//        }
//        
//        if  (!cacheImage) {
//            //cache第三种
//        }
        
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imgPictures]];
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        [imageView resetViewFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        [imageView setImageViewWithImg:cacheImage];
    }
}
- (void)setImgName:(NSString *)imgName {
   
    [imageView resetViewFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    [imageView uddateImageWithUrl:imgName withSize:self.imgSize];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
