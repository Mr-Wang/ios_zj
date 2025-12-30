//
//  WY_CreditMianModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/7/6.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_CreditMianModel.h"

@implementation WY_CreditMianModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"infoList" : [WY_CreditItemModel class]
    };
}

@end
