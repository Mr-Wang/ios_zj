//
//  WY_QuestionModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_QuestionOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuestionModel : MHObject

/**
 * 是否选中
 */
@property (nonatomic ) BOOL select;
@property (nonatomic , strong) NSString * rowGuid;
/**
 * 题目类型（选择填空。。。）
 */
@property (nonatomic , strong) NSString * questionType;
/**
 * 题目内容
 */
@property (nonatomic , strong) NSString * questionContent;
/**
 * 知识分类
 */
@property (nonatomic , strong) NSString * contentType;
/**
 * 知识分类
 */
@property (nonatomic , strong) NSString * contentTypeText;
/**
 * 1简单2一般3困难
 */
@property (nonatomic , strong) NSString * questionLevelText;
/**
 * 题目类型（选择填空。。。1单选、2多选、4填空）
 */
@property (nonatomic , strong) NSString * questionTypeText;
/**
 * 1简单2一般3困难
 */
@property (nonatomic , strong) NSString * questionLevel;
/**
 * userAnswer
 * 用户写的答案
 */
@property (nonatomic , strong) NSString * userSolution;
/**
 * 答案
 */
@property (nonatomic , strong) NSString * solution;
/**
 * 答案解析
 */
@property (nonatomic , strong) NSString * nsDescription;
/**
 * 题目分数
 */
@property (nonatomic , strong) NSString * questionScore;
/**
 * 审核状态
 */
@property (nonatomic , strong) NSString * auditStatus;

/**
 * 出题人
 */
@property (nonatomic , strong) NSString * userGuid;
/**
 * 出题时间
 */
@property (nonatomic , strong) NSString * operateDate;

/**
 * 出题单位
 */
@property (nonatomic , strong) NSString * orgGuid;

/**
 * 题目是否正确
 * 1错
 * 0对
 * 2针对于多选题的，漏选情况
 */
@property (nonatomic , strong) NSString * answerIsRight;

@property (nonatomic , strong) NSString * score;

/**
 * 选项
 */
@property (nonatomic, readwrite, copy) NSArray <WY_QuestionOptionModel *> *optionList;

@end

NS_ASSUME_NONNULL_END
