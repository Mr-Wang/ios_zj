//
//  WY_VDListViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/8.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_InfomationModel.h"

#import "ZJScrollPageViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_VDListViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic , strong) WY_InfomationModel *mWY_InfomationModel;

@property (nonatomic , strong) WY_InfomationModel *selModel;

@property (nonatomic,copy) void(^selPlayVideoBlock)(WY_InfomationModel *withSelModel);
@property (nonatomic,copy) void(^selFirstPlayVideoBlock)(WY_InfomationModel *withSelModel);
- (void)allPlayAction;

@end

NS_ASSUME_NONNULL_END
