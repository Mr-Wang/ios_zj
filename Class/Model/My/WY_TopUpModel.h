//
//  WY_TopUpModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_TopUpModel : MHObject
@property (nonatomic , strong) NSString *itemText;
@property (nonatomic , strong) NSString *itemValue;
@property (nonatomic , strong) NSString *codeID;

/// 充值或消费金额
@property (nonatomic , strong) NSString *amount;

/// 操作时间
@property (nonatomic , strong) NSString *createTime;

/// 操作类型 - 1充值、2消费
@property (nonatomic , strong) NSString *type;

/// 当时余额
@property (nonatomic , strong) NSString *checkAmount;

/// 消费、充值记录名称
@property (nonatomic , strong) NSString *detailText;

@end

NS_ASSUME_NONNULL_END
