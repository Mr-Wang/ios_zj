//
//  WY_ExpertFeeModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/12.
//  Copyright © 2022 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_ExpertFeeModel : MHObject
//"id": 16,
//            "tenderProjectName": "阳光14",
//            "tenderProjectCode": "14",
//            "bidEvaluationType": 2,
//            "evaluationTime": "2022-04-11 14:55:40",
//            "evaluationEndTime": "2022-04-11 14:55:40",
//            "bidEvaluationTime": 2,
//            "clearingFees": 600.0,
//            "clearingStatus": 0,
//            "expertName": "王杨",
//            "expertIdcardnum": "130303198912180317 ",
//            "expertPhone": "13940104171"
@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *tenderProjectName;
@property (nonatomic ,strong) NSString *tenderProjectCode;
@property (nonatomic ,strong) NSString *bidEvaluationType;
@property (nonatomic ,strong) NSString *evaluationTime;
@property (nonatomic ,strong) NSString *evaluationEndTime;
@property (nonatomic ,strong) NSString *clearingFees;
@property (nonatomic ,strong) NSString *clearingStatus;
@property (nonatomic ,strong) NSString *expertName;
@property (nonatomic ,strong) NSString *expertIdcardnum;
@property (nonatomic ,strong) NSString *expertPhone;
@property (nonatomic ,strong) NSString *expertId;
@property (nonatomic ,strong) NSString *msg;
@end

NS_ASSUME_NONNULL_END
