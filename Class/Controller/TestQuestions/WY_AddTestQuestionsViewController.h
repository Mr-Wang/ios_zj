//
//  WY_AddTestQuestionsViewController.h
//  出题页面
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ParamAddQuestionModel.h"
#import "WY_QuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_AddTestQuestionsViewController : UIViewController

/// 1 单选、2 多选
@property (nonatomic, strong) NSString *questionType;

/// 1添加、2编辑、3查看、4审核
@property (nonatomic, strong) NSString *isAddType;

@property (nonatomic, strong) WY_ParamAddQuestionModel *mWY_ParamAddQuestionModel;

@property (nonatomic, strong) WY_QuestionModel *mWY_QuestionModel;
@end

NS_ASSUME_NONNULL_END
