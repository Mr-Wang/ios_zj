//
//  WY_CreditMianModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/7/6.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_CreditItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CreditMianModel : MHObject
/*"expertName": null,
"processState": null,
"idCard": null,
"num": null,
"beLate": 1,
"commintTime": null,
"tenderProjectCode": null,
"tenderProjectName": null,
"meettingAddress": null,
"processName": null,
"leave": 0,
"bidSectionCodes": null,
"violation": 0,
"id": null,
"expertPhone": null,
"infoList": [*/

//正常次数
@property (nonatomic, strong) NSString *normal;

//旷评次数
@property (nonatomic, strong) NSString *criticism;
//迟到次数
@property (nonatomic, strong) NSString *beLate;
//请假次数
@property (nonatomic, strong) NSString *leave;
//违规次数
@property (nonatomic, strong) NSString *violation;
//替补参加数量
@property (nonatomic, strong) NSString *substitute;
//顶部文字
@property (nonatomic, strong) NSString *message;
//收入
@property (nonatomic, strong) NSString *evaluationFee;
  @property (nonatomic, readwrite, copy) NSArray <WY_CreditItemModel *> *infoList;

@end

NS_ASSUME_NONNULL_END
