//
//  WY_QuestionTypeModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuestionTypeModel : MHObject
@property (nonatomic , strong) NSString * type;

@property (nonatomic, readwrite, copy) NSArray <WY_QuestionModel *> *tQuestionList;

@end

NS_ASSUME_NONNULL_END
