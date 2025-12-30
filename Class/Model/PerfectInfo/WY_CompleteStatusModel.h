//
//  WY_CompleteStatusModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CompleteStatusModel : MHObject
/*"approvalStatus": "1",
 "expertName": null,
 "gender": null,
 "idCard": null,
 "expertWarehousing": null,
 "commintTime": "2020-06-18 15:56:58",
 "approvalTime": null,
 "delFlag": null,
 "idCardEle": null,
 "socialSecurityEle": null,
 "id": 116,
 "expertPhone": null,
 "expertType": null,
 "status": null*/
@property (nonatomic, strong) NSString * approvalStatus;
@property (nonatomic, strong) NSString * expertName;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * expertWarehousing;
@property (nonatomic, strong) NSString * commintTime;
@property (nonatomic, strong) NSString * approvalTime;
@property (nonatomic, strong) NSString * delFlag;
@property (nonatomic, strong) NSString * idCardEle;
@property (nonatomic, strong) NSString * socialSecurityEle;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * expertPhone;
@property (nonatomic, strong) NSString * expertType;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *renewalFlag;
//修改意见
@property (nonatomic, strong) NSString *approvalContent;


/*
 修改专家管理属地的
 "changeCityCode": null,
 "updateCity": null,
 "picUrl": null,
 "cityName": null,
 "commitTime": "2020-12-25 20:00:09",
 "idCard": null,
 "cityCode": null,
 "approval": "2020-12-29 16:58:24",
 "name": "康志永",
 "changeCity": null,
 "content": "同意",
 "status": "1"
 */

@property (nonatomic, strong) NSString *commitTime;
@property (nonatomic, strong) NSString *approval;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *approvalTitle;
@end

NS_ASSUME_NONNULL_END
