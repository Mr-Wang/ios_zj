//
//  WY_VDInfoViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/8.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_InfomationModel.h"

#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_VDInfoViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic , strong) WY_InfomationModel *mWY_InfomationModel;

@end

NS_ASSUME_NONNULL_END
