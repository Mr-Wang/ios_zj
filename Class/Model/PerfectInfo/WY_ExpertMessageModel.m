//
//  WY_ExpertMessageModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ExpertMessageModel.h"

@implementation WY_ExpertMessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"expertProfessions" : [WY_MajorPhotoModel class],
             @"voidCompany" : [WY_ZJCompanyModel class],
             @"jobTitleList" : [WY_ZJCompanyModel class],             
             @"currentCompany" : [WY_ZJCompanyModel class],
             @"originalCompany" : [WY_ZJCompanyModel class],
             @"currentCompany" : [WY_ZJCompanyModel class],
             @"cityList":[WY_CityModel class]
    };
} 
@end
