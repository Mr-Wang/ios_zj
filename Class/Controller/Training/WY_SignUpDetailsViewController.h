//
//  WY_SignUpDetailsViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/19.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TraCourseDetailModel.h"
#import "WY_SendEnrolmentMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_SignUpDetailsViewController : UIViewController
@property (nonatomic,strong)WY_TraCourseDetailModel *mWY_TraCourseDetailModel;
@property (nonatomic , strong) NSDictionary *dicSignUpSuccess;
@property (nonatomic , strong) WY_SendEnrolmentMessageModel *mWY_SendEnrolmentMessageModel;
@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) NSString *paymethod;
 @end

NS_ASSUME_NONNULL_END
