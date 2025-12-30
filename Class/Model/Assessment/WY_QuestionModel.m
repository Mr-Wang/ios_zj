//
//  WY_QuestionModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuestionModel.h"

@implementation WY_QuestionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"optionList"        : [WY_QuestionOptionModel class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    NSDictionary *dic=@{@"nsDescription" :@"description"};
    return dic;
}

@end
