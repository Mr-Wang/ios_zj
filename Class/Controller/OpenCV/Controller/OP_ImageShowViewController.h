//
//  OP_ImageShowViewController.h
//  opencvDemo
//
//  Created by 王杨 on 2020/10/9.
//  Copyright © 2020 ilogie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OP_ImageShowViewController : UIViewController
@property (strong,nonatomic) UIImageView *imgS;

@property (strong,nonatomic)UIImage *imgA;
@property (strong,nonatomic)UIImage *imgB;
@property (strong,nonatomic) NSString *nsType;//1-显示图片、2直接进入裁剪图片
@property (nonatomic,copy)void(^selEditEndImageBlock)(UIImage *imgEdit);
@property (nonatomic,copy)void(^selBack2EditEndImageBlock)(UIImage *imgEdit);

@end

NS_ASSUME_NONNULL_END
