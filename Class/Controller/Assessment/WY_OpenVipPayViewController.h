//
//  WY_OpenVipPayViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/21.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_VipMainModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_OpenVipPayViewController : UIViewController
@property (nonatomic, strong) WY_VipMainModel *mWY_VipMainModel;
@property (nonatomic) NSInteger selIndex;
@property (nonatomic, strong) NSString *isOpen;// 1开通 、2续费；3升级
@end

NS_ASSUME_NONNULL_END
