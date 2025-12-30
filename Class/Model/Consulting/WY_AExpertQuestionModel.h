//
//  WY_AExpertQuestionModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/26.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_AnswerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_AExpertQuestionModel : MHObject

@property (nonatomic ,strong) NSString *id;
//城市
@property (nonatomic ,strong) NSString *qaCityCode;
@property (nonatomic ,strong) NSString *qaCityName;
//类型 1 咨询 2 投诉 3 建议
@property (nonatomic ,strong) NSString *qaType;
//标题
@property (nonatomic ,strong) NSString *qaTitle;
//内容
@property (nonatomic ,strong) NSString *qaContent;
//附件
@property (nonatomic ,strong) NSString *qaFile;
//删除
@property (nonatomic ,strong) NSString *qaDel;
//专家身份证
@property (nonatomic ,strong) NSString *expertIdCard;
//专家姓名
@property (nonatomic ,strong) NSString *expertName;
//专家电话
@property (nonatomic ,strong) NSString *expertPhone;
//专家单位
@property (nonatomic ,strong) NSString *expertDanweiname;
//提出时间
@property (nonatomic ,strong) NSString *qaTime;

//专家头像
@property (nonatomic ,strong) NSString *expertPic;
//是否回复 1是已回复
@property (nonatomic ,strong) NSString *isAnswer;
 //专家管理属地
@property (nonatomic ,strong) NSString *expertCity;

@property (nonatomic ,strong) NSArray *tags;

//管理回复
@property (nonatomic ,strong) WY_AnswerModel *answer;

@end

NS_ASSUME_NONNULL_END
