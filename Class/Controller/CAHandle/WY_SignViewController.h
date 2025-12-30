//
//  WY_SignViewController.h
//  MigratoryBirds
//
//  Created by 王杨 on 2019/8/27.
//  Copyright © 2019 Doj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_SignViewController : UIViewController
@property (nonatomic,copy) void(^popVCBlock)(NSString *picUrl);
//1是保存签名到 用于签名文档
@property (nonatomic, strong) NSString *isSaveSign;

@end

NS_ASSUME_NONNULL_END
