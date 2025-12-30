//
//  WY_OnlineTrainDetailsViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/24.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TrainItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_OnlineTrainDetailsViewController : UIViewController
@property (nonatomic, strong) WY_TrainItemModel *mWY_TrainItemModel;
@property (nonatomic)NSInteger selZJIndex;
@end

NS_ASSUME_NONNULL_END
