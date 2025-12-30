//
//  WY_ExamListModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ExamListModel : MHObject
@property (nonatomic , strong) NSString *  orderPay;
@property (nonatomic , strong) NSString *  sex;
@property (nonatomic , strong) NSString *  job;
@property (nonatomic , strong) NSString *  email;
@property (nonatomic , strong) NSString *  userguid;
@property (nonatomic , strong) NSString *  orderguid;
@property (nonatomic , strong) NSString *  isfree;
@property (nonatomic , strong) NSString *  ispay;
@property (nonatomic , strong) NSString *  name;
@property (nonatomic , strong) NSString *  baomingidcard;
@property (nonatomic , strong) NSString * authCode;
@property (nonatomic , strong) NSString *  rzbs;//认证状态 1 是已经认证
@property (nonatomic , strong) NSString *  examGuid;
@property (nonatomic , strong) NSString *  examStartTime;
@property (nonatomic , strong) NSString *  examEndTime;
@property (nonatomic , strong) NSString *  examAddress;
@property (nonatomic , strong) NSString *  title;
@property (nonatomic , strong) NSString *  operateDate;
@property (nonatomic , strong) NSString *  UserName;
@property (nonatomic , strong) NSString *  UserGuid;
@property (nonatomic , strong) NSString *  DanWeiName;
@property (nonatomic , strong) NSString *  ClassGuid;//认证判断用这个
@property (nonatomic , strong) NSString *  RowGuid;
@property (nonatomic , strong) NSString *  Phone;
@property (nonatomic , strong) NSString *  CGRDanWeiName;
@property (nonatomic , strong) NSString * IsSignIn;
@property (nonatomic , strong) NSString *  WeiXin;
@property (nonatomic , strong) NSString *  SignInDate;
@property (nonatomic , strong) NSString *  examInfoId;//考试接口用这个
@end

NS_ASSUME_NONNULL_END
