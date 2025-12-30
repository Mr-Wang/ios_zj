//
//  WY_UserModel.m
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_UserModel.h" 

@implementation WY_UserModel
+ (NSDictionary *)modelCustomPropertyMapper {
    NSDictionary *dic=@{@"nsnewPassword" :@"newPassword"};
    return dic;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"cityList":[WY_CityModel class]
    };
}

@end
