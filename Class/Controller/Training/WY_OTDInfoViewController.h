//
//  WY_OTDInfoViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
#import "WY_TrainItemModel.h"
#import "WY_TraCourseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_OTDInfoViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic, strong) WY_TrainItemModel *mWY_TrainItemModel;

@property (nonatomic,strong)WY_TraCourseDetailModel *mWY_TraCourseDetailModel;
@end

NS_ASSUME_NONNULL_END
