//
//  WY_AddBonusPointsViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2023/2/9.
//  Copyright © 2023 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExpertModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_AddBonusPointsViewController : UIViewController

@property (nonatomic, strong) WY_ExpertModel *mWY_ExpertModel;
@property (nonatomic, strong) NSString * nsType;//1是查看评价
@end

NS_ASSUME_NONNULL_END
