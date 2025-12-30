//
//  WY_ParamAddQuestionModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_QuestionOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ParamAddQuestionModel : MHObject

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
     * 1简单2一般3困难
     */
    @property (nonatomic , strong) NSString * questionLevel;
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
     * 0添加草稿 1提交
     */
    @property (nonatomic , strong) NSString * auditStatus;
    /**
     * 出题人
     */
    @property (nonatomic , strong) NSString * userGuid;

    /**
     * 出题单位
     */
    @property (nonatomic , strong) NSString * orgGuid;

 
@property (nonatomic, readwrite, copy) NSArray <WY_QuestionOptionModel *> *optionList;

@end

NS_ASSUME_NONNULL_END
