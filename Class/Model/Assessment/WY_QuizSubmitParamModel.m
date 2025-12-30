//
//  WY_QuizSubmitParamModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuizSubmitParamModel.h"

@implementation WY_QuizSubmitParamModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"questionBeanList"        : [WY_QuestionModel class]             };
} 
@end
