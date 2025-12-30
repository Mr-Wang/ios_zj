//
//  ViewController.m
//  opencvDemo
//
//  Created by zp on 2017/8/28.
//  Copyright © 2017年 ilogie. All rights reserved.
//

#import "OP_CameraViewController.h"
#import "VideoCamera.h"
#import <opencv2/core.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc.hpp>

#import "BusinessCardDetector.h"
#import "BusinessCard.hpp"
#import "MaskLayer.h"
#import "OP_ImageShowViewController.h"
#import "WDOpenCVHelper.h"
#import "UIImageView+SHMContentRect.h"
#include <algorithm>

#import "HWCircleView.h" 

//缩小比例
const double DETECT_RESIZE_FACTOR = 0.5;
//成功帧数次数 - 建议阈值 30 - 50
const double SUCCESS_FRAMES_COUNT = 50;

@interface OP_CameraViewController ()<CvVideoCameraDelegate>
{
    BusinessCardDetector *businessCardDetector;
    std::vector<BusinessCard> detectedBusinessCards;
    CGFloat height;
    CGFloat width;
    NSMutableArray * array;
    int countA;
}
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong)MaskLayer *bordermask;

@property (nonatomic, strong) HWCircleView *circleView;
@property VideoCamera *videoCamera;
@property (nonatomic, strong) UILabel *lblStatus;
@property (nonatomic) int alStatus;
@end

@implementation OP_CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"识别拍照";
    self.backgroundView = [UIView new];
    [self.backgroundView setFrame:self.view.bounds];
    [self.view addSubview:self.backgroundView];
    
    array = [NSMutableArray array];
    height = [UIScreen mainScreen].bounds.size.height;
    width = [UIScreen mainScreen].bounds.size.width;
    businessCardDetector = new BusinessCardDetector();
    self.videoCamera = [[VideoCamera alloc] initWithParentView:self.backgroundView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.letterboxPreview = YES;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    
    self.videoCamera.rotateVideo = YES;
    
    self.bordermask.frame = self.backgroundView.bounds;
    [self.view.layer addSublayer:self.bordermask];
    
    UIButton *btnR = [UIButton new];
    [btnR setFrame:CGRectMake(0, kScreenHeight - k360Width(100) - JCNew64 - JC_TabbarSafeBottomMargin, k360Width(70), k360Width(70))];
    btnR.centerX = self.view.centerX;
    [btnR rounded:k360Width(70/2) width:k360Width(8) color:[UIColor colorWithHexString:@"C3C1C080"]];
    [btnR setBackgroundColor:[UIColor colorWithHexString:@"2864c680"]];
    [btnR addTarget:self action:@selector(btnCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnR];
    
    //圆圈
    self.circleView = [[HWCircleView alloc] initWithFrame:btnR.frame];
    [self.view addSubview:self.circleView];
    [self.circleView setUserInteractionEnabled:NO];
    
    self.lblStatus = [UILabel new];
    [self.lblStatus setFont:WY_FONTRegular(12)];
    [self.lblStatus setFrame:CGRectMake(0, k360Width(16), kScreenWidth - k360Width(32), k360Width(30))];
    self.lblStatus.centerX = self.view.centerX;
    [self.lblStatus rounded:k360Width(30/4)];
    [self.lblStatus setTextColor:[UIColor whiteColor]];
    [self.lblStatus setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.lblStatus];
    [self.lblStatus setHidden:YES];
}
- (void)showMessage:(NSString *)string withStyle:(NSString * )withStr {
    //    self.lblStatus.width = kScreenWidth;
    [self.lblStatus setText:string];
    //    [self.lblStatus sizeToFit];
    //     self.lblStatus.centerX = self.view.centerX;
    if ([withStr isEqualToString:@"1"]) {
        [self.lblStatus setBackgroundColor:[UIColor colorWithHexString:@"8be96a90"]];
    } else if ([withStr isEqualToString:@"2"]) {
        [self.lblStatus setBackgroundColor:[UIColor colorWithHexString:@"2864c690"]];
    } else {
        [self.lblStatus setBackgroundColor:[UIColor colorWithHexString:@"da393c90"]];
    }
    [self.lblStatus setHidden:NO];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortraitUpsideDown:
            self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        default:
            self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    [self refresh];
}
- (void)viewWillAppear:(BOOL)animated{
    [self refresh];
}
- (void)viewDidDisappear:(BOOL)animated {
    [self.videoCamera stop];
}

- (void)refresh {
    countA = 0;
    // Start or restart the video.
    [self.videoCamera stop];
    [self.videoCamera start];
}

- (void)processImage:(cv::Mat &)mat {
    //label闪动动画
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.alStatus == 0) {
            self.lblStatus.alpha -= 0.03;
        } else {
            self.lblStatus.alpha += 0.03;
        }
        
        if (self.lblStatus.alpha <= 0) {
            self.alStatus = 1;
        }
        if (self.lblStatus.alpha >= 1) {
            self.alStatus = 0;
        }
    });
    switch (self.videoCamera.defaultAVCaptureVideoOrientation) {
        case AVCaptureVideoOrientationLandscapeLeft:
        case AVCaptureVideoOrientationLandscapeRight:
            // The landscape video is captured upside-down.
            // Rotate it by 180 degrees.
            cv::flip(mat, mat, -1);
            break;
        default:
            break;
    } 
    // Detect businessCardDetector
    businessCardDetector->detect(mat, detectedBusinessCards,DETECT_RESIZE_FACTOR, true);
    
    if(detectedBusinessCards.size()> 0) {
        BusinessCard b = detectedBusinessCards[0];
        
        CGPoint centerPoint = CGPointMake(businessCardDetector->getCenterX()*1.0/mat.cols*width,businessCardDetector->getCenterY()*1.0/mat.rows*height);
        
        float point1x = businessCardDetector->temp[0].x*1.0/mat.cols*width;
        float point1y = businessCardDetector->temp[0].y*1.0/mat.rows*height;
        CGPoint point1   = {point1x,point1y};
        
        float point2x = businessCardDetector->temp[1].x*1.0/mat.cols*width;
        float point2y = businessCardDetector->temp[1].y*1.0/mat.rows*height;
        CGPoint point2  = {point2x,point2y};
        
        float point3x = businessCardDetector->temp[2].x*1.0/mat.cols*width;
        float point3y = businessCardDetector->temp[2].y*1.0/mat.rows*height;
        CGPoint point3  = {point3x,point3y};
        
        float point4x =  businessCardDetector->temp[3].x*1.0/mat.cols*width;
        float point4y =  businessCardDetector->temp[3].y*1.0/mat.rows*height;
        CGPoint point4  = {point4x,point4y};
        
        NSArray * array = @[NSStringFromCGPoint(point1),
                            NSStringFromCGPoint(point2),
                            NSStringFromCGPoint(point3),
                            NSStringFromCGPoint(point4)];
        
        for (NSString * pointStr in array) {
            CGPoint point = CGPointFromString(pointStr);
            CGFloat widthOffset = point.x - centerPoint.x;
            CGFloat heightOffset = point.y - centerPoint.y;
            if (widthOffset > 0.0) {
                if (heightOffset > 0.0) {
                    self.bordermask.rb = point;
                }else
                {
                    self.bordermask.rt = point;
                }
            }else
            {
                if (heightOffset > 0.0) {
                    
                    self.bordermask.lb = point;
                }else
                {
                    
                    self.bordermask.lt = point;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bordermask startDraw];
//            NSLog(@"开始画");
            countA ++;
            [self  showMessage:@"正在识别请保持" withStyle:@"1"];
            self.circleView.progress = float(countA / SUCCESS_FRAMES_COUNT)  ;
            
            if (countA > SUCCESS_FRAMES_COUNT) {
                 UIImage *imageMat = [self screenSnapshot:self.backgroundView];
                self.circleView.progress = 1;
                [self  showMessage:@"识别成功" withStyle:@"1"];
                //延时1秒 - 要不然跳转页面太突兀；
                sleep(1);
                CGSize imageSize = imageMat.size;
                CGFloat scale = fminf(CGRectGetWidth(self.backgroundView.bounds)/imageSize.width, CGRectGetHeight(self.backgroundView.bounds)/imageSize.height);
                
                CGPoint topLeftPoint = self.bordermask.lt;
                CGPoint topRightPoint = self.bordermask.rt;
                CGPoint bottomLeftPoint = self.bordermask.lb;
                CGPoint bottomRightPoint = self.bordermask.rb;
                
                topLeftPoint.x /= scale;
                topLeftPoint.y /= scale;
                topRightPoint.x /= scale;
                topRightPoint.y /= scale;
                bottomLeftPoint.x /= scale;
                bottomLeftPoint.y /= scale;
                bottomRightPoint.x /= scale;
                bottomRightPoint.y /= scale;
                
                //                UIImage *imageMat = [self screenSnapshot:self.backgroundView];
                // //抠图方法2 方案二：效果较好
                [WDOpenCVHelper asyncCropWithImage:imageMat topLeftPoint:topLeftPoint topRightPoint:topRightPoint bottomLeftPoint:bottomLeftPoint bottomRightPoint:bottomRightPoint completionHandler:^(UIImage * _Nonnull retImage) {
                    OP_ImageShowViewController *tempController = [OP_ImageShowViewController new];
                     tempController.imgA = retImage;
                    tempController.imgB = imageMat;
                    tempController.selBack2EditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
                        [self.videoCamera stop];
                        if (self.selEditEndImageBlock) {
                            self.selEditEndImageBlock(imgEdit);
                        }
                     };
                    [self.navigationController pushViewController:tempController animated:YES];
                }];
                [self.videoCamera stop];
                return;
            }
            else if(countA == SUCCESS_FRAMES_COUNT) {
                [self  showMessage:@"识别成功" withStyle:@"1"];
            }
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bordermask stopDraw];
//            NSLog(@"停止画");
            [self  showMessage:@"正在寻找图像边框" withStyle:@"2"];
            countA = 0;
            self.circleView.progress = 0;
        });
    }
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


- (UIImage*)screenSnapshot:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage * iii = [[UIImage alloc] initWithData: UIImageJPEGRepresentation(image, 0.8)];
    
    return [self reSizeImage:iii toSize:CGSizeMake(1080, 1920)];
}
//2.自定长宽
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
////计算最终图像的宽高
static inline cv::Size CalcDstSize(const std::vector<cv::Point2f>& corners) {
    cv::Size size;
    int h1 = sqrt((corners[0].x - corners[3].x)*(corners[0].x - corners[3].x) + (corners[0].y - corners[3].y)*(corners[0].y - corners[3].y));
    int h2 = sqrt((corners[1].x - corners[2].x)*(corners[1].x - corners[2].x) + (corners[1].y - corners[2].y)*(corners[1].y - corners[2].y));
    size.height = MAX(h1, h2);
    
    int w1 = sqrt((corners[0].x - corners[1].x)*(corners[0].x - corners[1].x) + (corners[0].y - corners[1].y)*(corners[0].y - corners[1].y));
    int w2 = sqrt((corners[2].x - corners[3].x)*(corners[2].x - corners[3].x) + (corners[2].y - corners[3].y)*(corners[2].y - corners[3].y));
    size.width = MAX(w1, w2);
    
    return size;
}

- (MaskLayer *)bordermask
{
    if (!_bordermask) {
        MaskLayer * mask = [MaskLayer layer];
        _bordermask = mask;
    }
    return _bordermask;
}
- (void)btnCameraAction {
    sleep(0.5);
    UIImage *imageMat = [self screenSnapshot:self.backgroundView];
    OP_ImageShowViewController *tempController = [OP_ImageShowViewController new];
    tempController.imgA = imageMat;
    tempController.imgB = imageMat;
    tempController.selBack2EditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
        [self.videoCamera stop];
        if (self.selEditEndImageBlock) {
            self.selEditEndImageBlock(imgEdit);
        }
     };
    [self.navigationController pushViewController:tempController animated:YES];
    [self.videoCamera stop];
    
}

- (void)dealloc {
    [self.videoCamera stop];
}
@end
