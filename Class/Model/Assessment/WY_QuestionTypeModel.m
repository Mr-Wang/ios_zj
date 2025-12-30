//
//  WY_QuestionTypeModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuestionTypeModel.h"

@implementation WY_QuestionTypeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"tQuestionList"        : [WY_QuestionModel class]             };
} 
@end
