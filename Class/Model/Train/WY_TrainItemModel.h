//
//  WY_TrainItemModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/10.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_TrainItemModel : MHObject
@property (nonatomic , strong) NSString *rowGuid;
@property (nonatomic , strong) NSString *tpurl;
@property (nonatomic , strong) NSString *ishy;
@property (nonatomic , strong) NSString *ispl;
@property (nonatomic , strong) NSString *isshowpl;
@property (nonatomic , strong) NSString *traCourseDetailBean;
@property (nonatomic , strong) NSString *baomingnum;//报名的名额
//    报名课程的订单号
@property (nonatomic , strong) NSString *traCourseCode;
//   报名时间
@property (nonatomic , strong) NSString *enrolTime;
//    同一订单报名人数
@property (nonatomic , strong) NSString *enrolPersonNumbers;
//    已报名人数
@property (nonatomic , strong) NSString *alreadybaomingnum;
//  报名人数
@property (nonatomic , strong) NSString *enrolNumber;
//    订单金额
@property (nonatomic , strong) NSString *Amount;
//  课程图片url
@property (nonatomic , strong) NSString *Photo;
//  课程价格
@property (nonatomic , strong) NSString *Price;
//  课程价格
@property (nonatomic , strong) NSString *appListUrl;
//  课程标题
@property (nonatomic , strong) NSString *Title;
//  分类编码
// @property (nonatomic , strong) NSString *CategoryCode;
//  课程唯一标识
@property (nonatomic , strong) NSString *ClassGuid;
//  报名的名额
//@property (nonatomic , strong) NSString *baomingnum;
//  是否签到
@property (nonatomic , strong) NSString *IsSignIn;
//  微信账号
//@property (nonatomic , strong) NSString *WeiXin;
//  所在单位
@property (nonatomic , strong) NSString *DanWeiName;
@property (nonatomic , strong) NSString *userguid;
//  订单唯一标识
@property (nonatomic , strong) NSString *orderguid;
//  是否支付
@property (nonatomic , strong) NSString *ispay;
//  订单支付状态
@property (nonatomic , strong) NSString *OrderStatus;
//  订单号
@property (nonatomic , strong) NSString *OrderNo;
//  是否免费
@property (nonatomic , strong) NSString *isfree;
//  课程分类编码
@property (nonatomic , strong) NSString *categoryCode;
//  课程报名开始时间
@property (nonatomic , strong) NSString *liveStartTime;
//  课程报名结束时间
//@property (nonatomic , strong) NSString *LiveEndTime;
@property (nonatomic , strong) NSString *liveEndTime;
//  课程开始时间
@property (nonatomic , strong) NSString *coursestarttime;
//报名人数
@property (nonatomic , strong) NSString *num;

@property (nonatomic , strong) NSString *content;
@property (nonatomic , strong) NSString *pxbs;
@property (nonatomic , strong) NSString *pxxx;
@property (nonatomic , strong) NSString *userCreateTime;
@end

NS_ASSUME_NONNULL_END
