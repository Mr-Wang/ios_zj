//
//  WY_TraCourseDetailModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/12.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_TraCourseDetailModel : MHObject
@property (nonatomic , strong) NSString * Photo;
@property (nonatomic , strong) NSString * Price;
@property (nonatomic , strong) NSString * Title;
@property (nonatomic , strong) NSString * ClassGuid;
@property (nonatomic , strong) NSString * LiveStartTime;   //    开始报名时间
@property (nonatomic , strong) NSString * LiveEndTime; //    报名结束时间
@property (nonatomic , strong) NSString *isallowqy; //1是全部可以报名、0是只有企业可以报名
@property (nonatomic , strong) NSString * coursestarttime;
@property (nonatomic , strong) NSString * courseendtime; 
@property (nonatomic , strong) NSString * courseaddress;
@property (nonatomic , strong) NSString * LessonDetail;
@property (nonatomic , strong) NSString * baomingnum;
@property (nonatomic , strong) NSString * alreadybaomingnum;
@property (nonatomic) NSInteger limitenum;
@property (nonatomic , strong) NSString *tpurl;
//服务类别
@property (nonatomic , strong) NSString *serviceType;
//咨询类别 -1线上咨询 。2线下支付
@property (nonatomic , strong) NSString *adviceType;

@property (nonatomic , strong) NSString *CategoryCode;
@property (nonatomic , strong) NSString *isend;
@property (nonatomic , strong) NSString *examType;
@property (nonatomic , strong) NSString *isNeedAttachment;
@property (nonatomic , strong) NSString *authCode;
//1是自主学习
@property (nonatomic , strong) NSString *iszz;
@end

NS_ASSUME_NONNULL_END
