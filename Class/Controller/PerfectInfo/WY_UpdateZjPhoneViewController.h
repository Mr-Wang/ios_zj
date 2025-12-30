//
//  WY_UpdateZjPhoneViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/7/23.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_UpdateZjPhoneViewController : UIViewController
@property (nonatomic,copy) void(^updateSuccessBlock)(NSString *phoneNum);
@end

NS_ASSUME_NONNULL_END
