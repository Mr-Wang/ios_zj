//
//  WY_VipMainModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/21.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_TopUpModel.h"
#import "WY_VipItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_VipMainModel : MHObject
@property (nonatomic, readwrite, copy) NSArray <WY_TopUpModel *> *codeMain;
@property (nonatomic, readwrite, copy) NSArray <WY_VipItemModel *> *orderPrice;
@property (nonatomic, readwrite, copy) NSArray <WY_UserModel *> *huiyuanUsers;
@property (nonatomic, readwrite, copy) NSArray <WY_UserModel *> * huiyuanVipXxList;
@property (nonatomic, readwrite, copy) NSString *amount;
@property (nonatomic, readwrite, copy) NSString *realAmount;
@property (nonatomic, readwrite, copy) NSString *zk;

@end

NS_ASSUME_NONNULL_END
