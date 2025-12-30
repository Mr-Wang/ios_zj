//
//  WY_InvoiceListItemModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/22.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_InvoiceListItemModel : MHObject
//    发票ID
@property (nonatomic , strong) NSString * RowGuid;
//    开具人类型:1为公司，0位个人
@property (nonatomic , strong) NSString * InvoiceType;
//    发票类型：0：纸质发票，1：纸质专票，2：电子发票
@property (nonatomic , strong) NSString * invoiceoftype;
//    发票抬头
@property (nonatomic , strong) NSString * InvoiceName;
//    发票金额
@property (nonatomic , strong) NSString * Amount;
// 发票状态
@property (nonatomic , strong) NSString * fpzt;

@end

NS_ASSUME_NONNULL_END
