//
//  WY_QuizModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuizModel : MHObject

//题目列表
@property (nonatomic, readwrite, copy) NSArray <WY_QuestionModel *> *tQuestionList;

@property (nonatomic , strong) NSString *  limitTime;//时间

@property (nonatomic , strong) NSString * examid;//试题id

@property (nonatomic , strong) NSString * mixSelectScore;//多选题漏选得分


@end

NS_ASSUME_NONNULL_END
