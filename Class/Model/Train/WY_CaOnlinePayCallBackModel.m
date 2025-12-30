//
//  WY_CaOnlinePayCallBackModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_CaOnlinePayCallBackModel.h"

@implementation WY_CaOnlinePayCallBackModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"traEnrolPersonBeans" : [WY_TraEnrolPersonModel class],
              };
}
@end
