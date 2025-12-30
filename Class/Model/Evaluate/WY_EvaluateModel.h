//
//  WY_EvaluateModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/12/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_EvaluateModel : MHObject
/**
     * 主键
     */
@property (nonatomic, strong) NSString *id;

    /**
     * 专家证件号
     */
@property (nonatomic, strong) NSString *expertIdCard;

    /**
     * 项目编号
     */
@property (nonatomic, strong) NSString *tenderProjectCode;

    /**
     * 项目名称
     */
@property (nonatomic, strong) NSString *tenderProjectName;

    /**
     * 标段编号
     */
@property (nonatomic, strong) NSString *bidSectionCode;
@property (nonatomic, strong) NSString *bidSectionCodes;

    /**
     * 标段名称
     */
@property (nonatomic, strong) NSString *bidSectionName;
@property (nonatomic, strong) NSString *bidSectionNames;

    /**
     * 代理机构名称
     */
@property (nonatomic, strong) NSString *agencyName;

    /**
     * 代理机构代码
     */
@property (nonatomic, strong) NSString *agencyCode;

    /**
     * 公司形象打分
     */
@property (nonatomic, strong) NSString * companyImage;

    /**
     * 评标现场组织能力打分
     */
@property (nonatomic, strong) NSString * organizationalSkills;

    /**
     * 所评项目业务掌握能力打分
     */
@property (nonatomic, strong) NSString * operationalCapacity;

    /**
     * 服务态度打分
     */
@property (nonatomic, strong) NSString * serviceAttitude;

    /**
     * 工作效率打分
     */
@property (nonatomic, strong) NSString * workEfficiency;

    /**
     * 平均分
     */
@property (nonatomic, strong) NSString * averageScore;

    /**
     * 评价文字
     */
@property (nonatomic, strong) NSString *rateText;

@property (nonatomic, strong) NSString *reconsiderText;
@property (nonatomic, strong) NSString *reconsiderImage;

@property (nonatomic, strong) NSString *leaveReason;
@property (nonatomic, strong) NSString *leaveAttach;
    /**
     * 评价时间
     */
@property (nonatomic, strong) NSString *rateTime;

    /**
     * 附件
     */
@property (nonatomic, strong) NSString *images;

    /**
     * 删除标记
     */
@property (nonatomic, strong) NSString *delFlag;

@property (nonatomic, strong) NSString *bidEvaluationAddress;//评标地址
@property (nonatomic, strong) NSString *bidEvaluationTime;//评标时间
@property (nonatomic, strong) NSString *expertName;
//
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *bidSectionId;
@property (nonatomic, strong) NSString *deductionId;
@property (nonatomic, strong) NSString *deductionName;
@property (nonatomic, strong) NSString *deductionReason;
@property (nonatomic, strong) NSString *deductPoints;
@property (nonatomic, strong) NSString *deductionAppendix;
@property (nonatomic, strong) NSString *legalName;
@property (nonatomic, strong) NSString *tendererName;
@property (nonatomic, strong) NSString *tenderAgentName;
@property (nonatomic, strong) NSString *drawExportCode;
@property (nonatomic, strong) NSString *evaluateTime;
@property (nonatomic) BOOL appealable;
@property (nonatomic, strong) NSString *appeal;
@property (nonatomic, strong) NSString *appealTime;
@property (nonatomic, strong) NSString *appealAppendix;
@property (nonatomic, strong) NSString *appealStatus;
@property (nonatomic, strong) NSString *appealReply;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *del;
@property (nonatomic, strong) NSArray *deductionAppendixList;
@property (nonatomic, strong) NSString *collectedTime;   //集合时间
@property (nonatomic, strong) NSString *signTime;    //签到时间
@property (nonatomic, strong) NSString *lateTime;
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *appealEndTime; //申诉截止时间
@property (nonatomic, strong) NSString *substitute; //是否备选
@end

NS_ASSUME_NONNULL_END
