//
//  WY_SendEnrolmentMessageModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SendEnrolmentMessageModel.h"

@implementation WY_SendEnrolmentMessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"traEnrolPersonBeans" : [WY_TraEnrolPersonModel class],
              };
}

//+ (NSDictionary *)modelCustomPropertyMapper {
//    NSDictionary *dic=@{@"InvoiceEmail" :@"Email",@"InvoiceMobile":@"GMFDH",@"InvoiceAddress":@"XSFDZ",@"InvoiceBankNo":@"XSFYHMC",@"InvoiceBankName":@"XSFYHZH"};
//    return dic;
//}

@end
