//
//  WY_CreditItemModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/7/6.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CreditItemModel : MHObject
/*"meettingAddress": null,
"expertName": "周长平",
"processState": "3",
"processName": "迟到",
"idCard": "211222196901040429",
"bidSectionCodes": "202021011412942646001",
"num": "3",
"commintTime": "2020-07-02 17:46:50",
"id": 44,
"expertPhone": "13840050999",
"tenderProjectCode": "202021011412942646",
"tenderProjectName": "于洪区2020年农村公路维修改造工程监理"*/
@property (nonatomic, strong) NSString *processName;
@property (nonatomic, strong) NSString *meettingAddress;
@property (nonatomic, strong) NSString *expertName;
@property (nonatomic, strong) NSString *processState; //1旷评、2请假、3迟到、4违法、5替补
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *bidSectionCodes;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *commintTime;
@property (nonatomic, strong) NSString *evaluationTime;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *expertPhone;
@property (nonatomic, strong) NSString *tenderProjectCode;
@property (nonatomic, strong) NSString *tenderProjectName;
@property (nonatomic, strong) NSString *agencyName;
@end

NS_ASSUME_NONNULL_END
