//
//  WY_ExpertModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ExpertModel : MHObject
/*createtime = "2020-04-18 13:32:16";
 daili = "\U8fbd\U5b81\U7701\U56fd\U534e\U62db\U6807\U5de5\U8d44";
 id = 1;
 name = "\U68cb\U76d8\U5c71\U98ce\U666f\U533a\U82b1\U5349\U53ca\U6728\U82d7\U91c7\U8d2d";
 place = "\U6c88\U9633\U5e02\U516c\U5171\U8d44\U6e90\U4ea4\U6613\U4e2d\U5fc3";
 time = "2021-04-18 13:32:16";
 xmcode = "<null>";
 yjphone = 13888888888;
 zjidcard = 130281198801125319;
 zjphone = "<null>";*/
@property (nonatomic , strong) NSString *createtime;
@property (nonatomic , strong) NSString *daili;
@property (nonatomic , strong) NSString *major;
@property (nonatomic , strong) NSString *id;
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *place;
@property (nonatomic , strong) NSString *time;
@property (nonatomic , strong) NSString *xmcode;
@property (nonatomic , strong) NSString *yjphone;
@property (nonatomic , strong) NSString *zjidcard;
@property (nonatomic , strong) NSString *zjphone;
//2是评标历史
@property (nonatomic , strong) NSString *status;
@property (nonatomic , strong) NSString *bidSectionState;

@property (nonatomic , strong) NSString *isDecrypted;//是否解密 0 没 1已经解密
@property (nonatomic , strong) NSString *signFlag;//是否签到 0 没 1已经签到，2是迟到签到
@property (nonatomic , strong) NSString *leaveFlag; //是否请假 请假了 true 没请假false
@property (nonatomic , strong) NSString *isShowLeave; //是否显示请假按钮 显示 true 不显示false
@property (nonatomic , strong) NSString *message;
@property (nonatomic , strong) NSString *yzm;
///标段名称
@property (nonatomic , strong) NSString *bidSectionName;
@property (nonatomic , strong) NSString *projectName;
@property (nonatomic , strong) NSString *deductionName;
@property (nonatomic , strong) NSString *evaluateTime;
//申诉条目
@property (nonatomic , strong) NSString *deductPoints;
///标段编码
@property (nonatomic , strong) NSString *bidSectionCodes;
//appealStatus  0未读  1已读  2申诉中 3申诉成功 4申诉失败
@property (nonatomic , strong) NSString *appealStatus;

@property (nonatomic , strong) NSString *agencyCode;

@property (nonatomic , strong) NSString *tenderProjectCode;
@property (nonatomic , strong) NSString *expertId;


@property (nonatomic , strong) NSString *beRated;// 1  为 已经评价过 不可以评价

@property (nonatomic , strong) NSString *canRate;//0 代表不可以评价

@property (nonatomic , strong) NSString *isRated;//1 是代理对我的评价

@property (nonatomic , strong) NSString *isReconsider;   //0可以申诉,1是 申诉中， 2 是已申诉


@property (nonatomic , strong) NSString *evaluateContent;
@property (nonatomic , strong) NSString *evaluateMark;

@property (nonatomic , strong) NSString *estimatedEvaluationTime;
@property (nonatomic , strong) NSString *estimatedEvaluationPrice;

@property (nonatomic) int typeID;
@property (nonatomic , strong) NSString *remark;

@property (nonatomic , strong) NSString *longitude;
@property (nonatomic , strong) NSString *latitude;

@property (nonatomic , strong) NSString *drawExportCode;
@property (nonatomic , strong) NSString *tendereeName;
@property (nonatomic , strong) NSString *pbTime;
@property (nonatomic , strong) NSString *pbAddress;


@property (nonatomic, strong) NSString *appeal;
@property (nonatomic, strong) NSString *appealAppendix;
@property (nonatomic, strong) NSString *deductionCount;
@property (nonatomic, strong) NSArray *deductionAppendixList;

@property (nonatomic, strong) NSString *bidEvaluatedTime;
@property (nonatomic, strong) NSString *bidEvaluatedAddress;
@property (nonatomic, strong) NSString *appealReply;
@property (nonatomic, strong) NSString *appealReplyTime;

@property (nonatomic, strong) NSString *appeal2;
@property (nonatomic, strong) NSString *appealTime;
@property (nonatomic, strong) NSString *appealTime2;
@property (nonatomic, strong) NSString *appealAppendix2;

@property (nonatomic, strong) NSString *appealAppendJgUrl;
@property (nonatomic, strong) NSString *appealAppendJgUrl2;
@property (nonatomic, strong) NSString *appealReply2;
@property (nonatomic, strong) NSString *appealReplyTime2;
@property (nonatomic, strong) NSString *unReadDeductionCount;

//隔夜
@property (nonatomic , strong) NSString *isOvernight;

/*奖励加分*/

@property (nonatomic, strong) NSString *applyTime;
//奖励加分类型
@property (nonatomic, strong) NSString *rewardTerms;
//具体内容
@property (nonatomic, strong) NSString *rewardContent;
//附件
@property (nonatomic, strong)NSMutableArray *sysAttachList;
//分数
@property (nonatomic, strong) NSString *scoreStandard;


//其他扣分事项
@property (nonatomic, strong) NSString *otherPointsReason;
@property (nonatomic, strong) NSString *otherPointsContent;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *attachmentFileName;

//专家违法行为
@property (nonatomic, strong) NSString *illegalTerms;
@property (nonatomic, strong) NSString *illegalContent;
@property (nonatomic, strong) NSString *processingDecision;
//refuse
//总体参评得分
/*
 unDialed 未接听
 （refuse 主动拒绝
 unanswered 拨通未回复 ） = 主动拒绝
 一级列表-未接听 unanswered
 一级列表-主动拒绝 refuse
 */
@property (nonatomic, strong) NSString *refuse; //未接听 数
@property (nonatomic, strong) NSString *unanswered; //主动拒绝 数
//集合unDialed 未接听（refuse 主动拒绝 unanswered 拨通未回复 ） = 主动拒绝 - 拨打电话 startTime 时间-
@property (nonatomic, strong) NSMutableArray *refuseList;   //
@property (nonatomic, strong) NSMutableArray *unansweredList; //
@property (nonatomic, strong) NSMutableArray *unDialedList; //
@property (nonatomic, strong) NSString *ztType; // 1 是未接通cell,  2是 主动拒绝cell
@property (nonatomic, strong) NSString *unansweredDeductPoints;//年度语音电话未接听数
@property (nonatomic, strong) NSString *refuseDeductPoints;//年度主动拒绝参评数

//当前项目是否已办理云签章 1 是已办理  0 是未办理
@property (nonatomic, strong) NSString *isHandleCA;
//当前项目是否需要办理项目云签章 1 是需要办理  0 是不需要办理
@property (nonatomic, strong) NSString *isNeedHandleCA;
@property (nonatomic, strong) NSString *platformContent;
///增加签到时间字段
@property (nonatomic , strong) NSString *signTime;
@property (nonatomic , strong) NSString *leaveReason;
@property (nonatomic , strong) NSString *leaveAttach;


@end

NS_ASSUME_NONNULL_END
