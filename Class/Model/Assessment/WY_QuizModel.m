//
//  WY_QuizModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuizModel.h"

@implementation WY_QuizModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"tQuestionList"        : [WY_QuestionModel class]             };
} 
@end
