//
//  WY_SignUpViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/12.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TraCourseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_SignUpViewController : UIViewController
@property (nonatomic,strong)WY_TraCourseDetailModel *mWY_TraCourseDetailModel;
//可报名人数
@property (nonatomic) NSInteger canGovNum;
@end

NS_ASSUME_NONNULL_END
