//
//  WY_QuestionReviewModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_QuestionTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuestionReviewModel : MHObject
@property (nonatomic , strong) NSString * rowGuid;
@property (nonatomic , strong) NSString * questionbatch;
@property (nonatomic , strong) NSString * answertime;
@property (nonatomic , strong) NSString * score;
@property (nonatomic , strong) NSString * userGuid;
@property (nonatomic , strong) NSString * orgGuid;
@property (nonatomic , strong) NSString * createtime;
@property (nonatomic , strong) NSString * examTime;
 
@property (nonatomic, readwrite, copy) NSArray <WY_QuestionTypeModel *> *examQuestionBeanList;

@end

NS_ASSUME_NONNULL_END
