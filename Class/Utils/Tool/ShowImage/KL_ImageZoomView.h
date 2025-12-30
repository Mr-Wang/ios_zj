//
//  KL_ImageZoomView.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProgressView.h"
//#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"

@interface KL_ImageZoomView : UIView <UIScrollViewDelegate>
{
    CGFloat viewscale;
    NSString *downImgUrl;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) BOOL isViewing;
@property (nonatomic, retain)UIView *containerView;
@property (nonatomic, retain)DDProgressView *progress;

- (void)resetViewFrame:(CGRect)newFrame;
- (void)updateImage:(NSString *)imgName;
- (void)setImageViewWithImg:(UIImage *)img;
- (void)uddateImageWithUrl:(NSString *)imgUrl withSize:(CGSize)withSize;

@end
