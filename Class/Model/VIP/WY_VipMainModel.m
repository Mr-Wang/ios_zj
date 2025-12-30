//
//  WY_VipMainModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/21.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_VipMainModel.h"

@implementation WY_VipMainModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"codeMain"        : [WY_TopUpModel class],
             @"orderPrice"    : [WY_VipItemModel class],
             @"huiyuanUsers"    : [WY_UserModel class]
             };
}
@end
