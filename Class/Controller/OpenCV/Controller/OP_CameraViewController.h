//
//  OP_CameraViewController.h
//  opencvDemo
//
//  Created by 王杨 on 2020/10/13.
//  Copyright © 2020 ilogie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OP_CameraViewController : UIViewController
@property (nonatomic,copy)void(^selEditEndImageBlock)(UIImage *imgEdit);

@end

NS_ASSUME_NONNULL_END
