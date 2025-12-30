//
//  WY_ExamHomeModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ExamHomeModel : MHObject
//是否已有自测结果
@property (nonatomic , strong) NSString *result;
//测试次数
@property (nonatomic , strong) NSString *examCount;
//测试题数
@property (nonatomic , strong) NSString *questionCount;
//平均成绩
@property (nonatomic , strong) NSString *averageScore;
@end

NS_ASSUME_NONNULL_END
