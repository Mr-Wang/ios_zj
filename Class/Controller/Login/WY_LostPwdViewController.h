//
//  WY_LostPwdViewController.h
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/14.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_LostPwdViewController : UIViewController

@property (nonatomic,copy) void(^updatePwdSuccessBlock)(NSString *uname,NSString *pwd);
@end

NS_ASSUME_NONNULL_END
