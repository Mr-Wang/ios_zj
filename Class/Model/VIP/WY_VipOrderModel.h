//
//  WY_VipOrderModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/7/9.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_HuiyuanVipXxModel.h"
#import "WY_TraEnrolPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_VipOrderModel : MHObject
@property (nonatomic, readwrite, copy) WY_HuiyuanVipXxModel *huiyuanVipXx;
@property (nonatomic, readwrite, copy) NSArray <WY_TraEnrolPersonModel *> *traEnrolPersonBeans;

@end

NS_ASSUME_NONNULL_END
