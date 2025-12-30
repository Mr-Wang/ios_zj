//
//  WY_QuizSubmitParamModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuizSubmitParamModel : MHObject
@property (nonatomic , strong) NSString *  examid;

@property (nonatomic , strong) NSString *  orgnum;

@property (nonatomic , strong) NSString *  userguid;

@property (nonatomic , strong) NSString *  examTime;

@property (nonatomic , strong) NSString *  mixSelectScore;//多选提漏选分数

@property (nonatomic, readwrite, copy) NSArray <WY_QuestionModel *> *questionBeanList;
//专家考试- 加了个身份证号
@property (nonatomic , strong) NSString *idCard;
@end

NS_ASSUME_NONNULL_END
