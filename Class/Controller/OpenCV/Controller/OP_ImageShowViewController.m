//
//  OP_ImageShowViewController.m
//  opencvDemo
//
//  Created by 王杨 on 2020/10/9.
//  Copyright © 2020 ilogie. All rights reserved.
//

#import "OP_ImageShowViewController.h"
#import "WDOpenCVEditingViewController.h"

@interface OP_ImageShowViewController ()<WDOpenCVEditingViewControllerDelegate>

@end

@implementation OP_ImageShowViewController

- (void)upAlignment:(UIButton *)focusBtn {
    [focusBtn.titleLabel setFont:WY_FONTRegular(12)];
    focusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [focusBtn setTitleEdgeInsets:UIEdgeInsetsMake(focusBtn.imageView.frame.size.height ,-focusBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [focusBtn setImageEdgeInsets:UIEdgeInsetsMake(-focusBtn.imageView.frame.size.height, 0.0,0.0, -focusBtn.titleLabel.bounds.size.width)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑图片";
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.imgS = [UIImageView new];
    [self.imgS setBackgroundColor:[UIColor whiteColor]];
    [self.imgS setFrame:CGRectMake(20, 20, kScreenWidth - 40, kScreenHeight - k360Width(44 ) - JCNew64 - 40)];
    self.imgS.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgS setImage:self.imgA];
    [self.view addSubview:self.imgS];
    
    UIView *viewBottom = [UIView new];
    
    [viewBottom setFrame:CGRectMake(0, kScreenHeight - MH_APPLICATION_TAB_BAR_HEIGHT - JCNew64, kScreenWidth, MH_APPLICATION_TAB_BAR_HEIGHT)];
    [viewBottom setBackgroundColor:MSTHEMEColor];
    [self.view addSubview:viewBottom];
    
    
    
    UIButton *btnXuan = [UIButton new];
    [btnXuan setFrame:CGRectMake(0, 0, kScreenWidth/4, viewBottom.height)];
    [btnXuan setTitle:@"旋转向左" forState:UIControlStateNormal];
    [btnXuan setImage:[UIImage imageNamed:@"op_btn1"] forState:UIControlStateNormal];
    [btnXuan addTarget:self action:@selector(btnXuanLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnXuan];
    
    UIButton *btnXuanRight = [UIButton new];
    [btnXuanRight setFrame:CGRectMake(btnXuan.right, 0, kScreenWidth/4, viewBottom.height)];
    [btnXuanRight setTitle:@"旋转向右" forState:UIControlStateNormal];
    [btnXuanRight setImage:[UIImage imageNamed:@"op_btn2"] forState:UIControlStateNormal];
    [btnXuanRight addTarget:self action:@selector(btnXuanRightAction) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnXuanRight];
    
    //手动截取
    UIButton *btnDiy = [UIButton new];
    [btnDiy setFrame:CGRectMake(btnXuanRight.right, 0, kScreenWidth/4, viewBottom.height)];
    [btnDiy setTitle:@"手动截取" forState:UIControlStateNormal];
    [btnDiy setImage:[UIImage imageNamed:@"op_btn3"] forState:UIControlStateNormal];
    [btnDiy addTarget:self action:@selector(btnDiyAction) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnDiy];
    
    //完成按钮
    UIButton *btnDone = [UIButton new];
    [btnDone setFrame:CGRectMake(btnDiy.right, 0, kScreenWidth/4, viewBottom.height)];
    [btnDone setTitle:@"确认完成" forState:UIControlStateNormal];
    [btnDone setImage:[UIImage imageNamed:@"op_btn4"] forState:UIControlStateNormal];

    [btnDone addTarget:self action:@selector(btnDoneAction) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnDone];
 
    
    [self upAlignment:btnXuan];
    [self upAlignment:btnXuanRight];
    [self upAlignment:btnDiy];
    [self upAlignment:btnDone];
    
    
    if ([self.nsType isEqualToString:@"2"]) {
        [self btnDiyAction];
    }
}

- (void)btnDoneAction {
    if (self.selEditEndImageBlock) {
        self.selEditEndImageBlock(self.imgS.image);
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.selBack2EditEndImageBlock) {
        self.selBack2EditEndImageBlock(self.imgS.image);
        NSArray *pushVCAry=[self.navigationController viewControllers];
        UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-3];
        [self.navigationController popToViewController:popVC animated:YES];

    }
    
}

- (void)btnXuanLeftAction {
    
    
    [UIView animateWithDuration:0.7 animations:^{
        [self.imgS setImage:[self image:self.imgS.image rotation:UIImageOrientationLeft]];

    } completion:^(BOOL finished) {

    }];

}
- (void)btnXuanRightAction {
     
    [UIView animateWithDuration:0.7 animations:^{
        [self.imgS setImage:[self image:self.imgS.image rotation:UIImageOrientationRight]];

    } completion:^(BOOL finished) {

    }];

}

- (void)btnDiyAction {
    NSLog(@"手动截取");
    WDOpenCVEditingViewController *editor = [[WDOpenCVEditingViewController alloc] init];
    editor.delegate = self;
    editor.originImage = self.imgB;
    editor.autoDectorCorner = YES;
    [self.navigationController pushViewController:editor animated:YES];
}

#pragma mark - WDOpenCVEditingViewControllerDelegate
- (void)editingController:(WDOpenCVEditingViewController *)editor didFinishCropping:(UIImage *)finalCropImage {
    self.imgA = finalCropImage;
    [self.imgS setImage:self.imgA];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
