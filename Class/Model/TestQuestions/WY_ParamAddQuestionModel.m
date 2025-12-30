//
//  WY_ParamAddQuestionModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ParamAddQuestionModel.h"

@implementation WY_ParamAddQuestionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"optionList"        : [WY_QuestionOptionModel class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    NSDictionary *dic=@{@"nsDescription" :@"description"};
    return dic;
}
@end
