//
//  WY_ParamExpertModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ParamExpertModel.h"

@implementation WY_ParamExpertModel
+ (NSDictionary *)modelContainerPropertyGenericClass {    
    return @{@"zjCompanyList" : [WY_ZJCompanyModel class],@"majorPhotoBeanList" : [WY_MajorPhotoModel class]
    };
} 
@end
