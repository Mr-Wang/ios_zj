//
//  WY_QuestionReviewModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuestionReviewModel.h"

@implementation WY_QuestionReviewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"examQuestionBeanList"        : [WY_QuestionTypeModel class]             };
}
@end
