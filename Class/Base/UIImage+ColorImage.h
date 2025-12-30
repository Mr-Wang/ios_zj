//
//  HybirdAppViewController.h
//  London2
//
//  Created by Mr.Yao on 16/3/23.
//  Copyright © 2016年 yaoquafeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (ColorImage)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)yal_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius;
/**
 *  等比例缩放裁剪 
 *
 *  @param targetSize <#targetSize description#>
 *
 *  @return <#return value description#>
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;


/**
 水印图

 @param img <#img description#>
 @param logo <#logo description#>
 @return <#return value description#>
 */
-(UIImage *)addWatermark;

+ (UIImage *)zt_imageWithPureColor:(UIColor *)color;
+ (UIImage *)zt_imageWithPureColor:(UIColor *)color size:(CGSize )size;
@end
