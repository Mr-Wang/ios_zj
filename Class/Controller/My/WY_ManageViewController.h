//
//  WY_ManageViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/29.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_ManageViewController : UIViewController
//管理权限  - 1-全部权限、2-仅查看咨询投诉、3-仅查看抽取状态
@property (nonatomic) int administrativePermissions;

@end

NS_ASSUME_NONNULL_END
