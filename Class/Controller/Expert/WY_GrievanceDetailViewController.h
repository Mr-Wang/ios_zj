//
//  WY_GrievanceDetailViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/12/13.
//  Copyright © 2022 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExpertModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_GrievanceDetailViewController : UIViewController
@property (nonatomic, strong) WY_ExpertModel *mWY_ExpertModel;
@property (nonatomic, strong) NSString *eID;
@property (nonatomic, strong) NSString * nsType;//1是查看评价

@end

NS_ASSUME_NONNULL_END
