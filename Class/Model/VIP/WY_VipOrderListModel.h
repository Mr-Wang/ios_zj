//
//  WY_VipOrderListModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/7/9.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_VipOrderListModel : MHObject


/*
 applyDate = "<null>";
 danWeiGuid = "<null>";
 dueDate = "2021-07-09 00:00:00.0";
 id = 4;
 infoCount = 1;
 infoType = 3;
 operator = 202005151001029070;
 orderGuid = 202007091124351453;
 price = "0.02";
 reallPrice = "0.01";
 renew = "<null>";
 totalPrice = "0.01";
 userGuid = "<null>";
 userInfo = 202005151001029070;
 userNameInfo = "\U9648\U670b\U6d9b";
 vipStatus = "<null>";
 vipType = "<null>";
 viplevel = "<null>";
 viptype = 2;
 zk = 1;
 */

@property (nonatomic, readwrite, copy) NSString *dueDate;
@property (nonatomic, readwrite, copy) NSString *id;
@property (nonatomic, readwrite, copy) NSString *infoCount;
@property (nonatomic, readwrite, copy) NSString *infoType;
@property (nonatomic, readwrite, copy) NSString *orderGuid;
@property (nonatomic, readwrite, copy) NSString *nsoperator;
//单价
@property (nonatomic, readwrite, copy) NSString *price;
//实付金额
@property (nonatomic, readwrite, copy) NSString *reallPrice;
@property (nonatomic, readwrite, copy) NSString *totalPrice;
@property (nonatomic, readwrite, copy) NSString *userInfo;
@property (nonatomic, readwrite, copy) NSString *userNameInfo;
@property (nonatomic, readwrite, copy) NSString *viptype;
@property (nonatomic, readwrite, copy) NSString * zk;
@property (nonatomic, readwrite, copy) NSString *operateDate;
@property (nonatomic, readwrite, copy) NSString *onlinePayMethod;
@property (nonatomic, readwrite, copy) NSString *invoiceName;
@property (nonatomic, readwrite, copy) NSString *orderNo;
@property (nonatomic, readwrite, copy) NSString *orderRowGuid;
@end

NS_ASSUME_NONNULL_END
