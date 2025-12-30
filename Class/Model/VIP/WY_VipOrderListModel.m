//
//  WY_VipOrderListModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/7/9.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_VipOrderListModel.h"

@implementation WY_VipOrderListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    NSDictionary *dic=@{@"nsoperator" :@"operator"};
    return dic;
}
@end
