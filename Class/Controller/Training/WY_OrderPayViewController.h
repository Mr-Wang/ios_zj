//
//  WY_OrderPayViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_SendEnrolmentMessageModel.h"
#import "WY_TraCourseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_OrderPayViewController : UIViewController
@property (nonatomic , strong) NSDictionary *dicSignUpSuccess;
@property (nonatomic , strong) WY_SendEnrolmentMessageModel *mWY_SendEnrolmentMessageModel;
@property (nonatomic,strong)WY_TraCourseDetailModel *mWY_TraCourseDetailModel;
@end

NS_ASSUME_NONNULL_END
