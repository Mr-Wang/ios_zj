//
//  WY_CaOnlinePayCallBackModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_TraEnrolPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CaOnlinePayCallBackModel : MHObject
@property (nonatomic , strong) NSString * OrderGuid;
@property (nonatomic , strong) NSString *userGuid;

//传 03
@property (nonatomic , strong) NSString *paymethod;

@property (nonatomic , strong) NSString * isca;

@property (nonatomic, readwrite, copy) NSArray <WY_TraEnrolPersonModel *> *traEnrolPersonBeans;
@end

NS_ASSUME_NONNULL_END
