//
//  WY_PerfectInfo2ViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExpertMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_PerfectInfo2ViewController : UIViewController
@property (nonatomic , strong) WY_ExpertMessageModel *mWY_ExpertMessageModel;
@property (nonatomic) int approvalStatusNum;
@property (nonatomic,strong) NSString*source;
@end

NS_ASSUME_NONNULL_END
