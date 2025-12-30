//
//  WY_MajorPhotoModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MajorPhotoModel : MHObject
@property (nonatomic) int id;
@property (nonatomic, strong) NSString *majorName;
@property (nonatomic, strong) NSString *majorID;
@property (nonatomic) int currentIndex;
/*
 jobEleid    =  zmPhotos   -职称图片
 qualificationEleId = hyPhotos   -能力证明图片
 */
//提交时：
@property (nonatomic, strong) NSString *zmPhotos;   //职称图片
@property (nonatomic, strong) NSString *hyPhotos;   //能力证明图片


//接收时：
@property (nonatomic, strong) NSString *jobEleid;   //职称图片
@property (nonatomic, strong) NSString *qualificationEleId; //能力证明图片

/* "expertIdCard": null,
 "professionCode": "A027",
 "expertWarehousing": null,
 "professionNameThird": null,
 "professionState": 1,
 "professionCodeSecond": null,
 "professionNameFirst": null,
 "professionCodeFirst": null,
 "professionCodeThird": null,
 "professionNameSecond": null,
 "seniorityEleId": null,
 "commitTime": null,
 "jobEleid": null,
 "professionName": "工程类,水利水工",
 "qualificationEleId": null,
 "id": null,
 "educationEleId": null*/

@property (nonatomic, strong) NSString *expertIdCard;
@property (nonatomic, strong) NSString *professionCode;
@property (nonatomic, strong) NSString *professionNameThird;
//0是新专业、1是老专业
@property (nonatomic, strong) NSString *professionState;
//0是新专业、1是老专业
@property (nonatomic, strong) NSString *isOldOrNew;
//1是原来的 2是新的
@property (nonatomic, strong) NSString *jumpToWhere;
@property (nonatomic, strong) NSString *professionCodeSecond;
@property (nonatomic, strong) NSString *professionNameFirst;
@property (nonatomic, strong) NSString *professionCodeFirst;
@property (nonatomic, strong) NSString *professionCodeThird;
@property (nonatomic, strong) NSString *professionNameSecond;
@property (nonatomic, strong) NSString *seniorityEleId;
@property (nonatomic, strong) NSString *commitTime;
@property (nonatomic, strong) NSString *professionName;
@property (nonatomic, strong) NSString *educationEleId;
//老二级和新三级对应的字段
@property (nonatomic, strong) NSString *oldProfessionCode;

// 提交数据     * majorPhotoBeanList : [{"professionId":"A010101","professionName":"小瑶子","hyPhotos":"lianjie1,lianjie2","zmPhotos":"lianjie1,lianjie2","majorType":0},{"professionId":"b020202","professionName":"小瑶子","hyPhotos":"hhh1","zmPhotos":"ggg2","majorType":1}]

@property (nonatomic, strong) NSString *professionId;
@property (nonatomic, strong) NSString *majorType;
@property (nonatomic, strong) NSString *source;


/// 返回0、1、2，0全部不能编辑，1全部可以编辑，2可以只编辑图片部分
@property (nonatomic, strong) NSString *letEdit;

/// 返回0、1，0不能删除、1可以删除
@property (nonatomic, strong) NSString *letDel;

/// 返回0、1、2， 0是未审核  1审核通过，2审核未通过
@property (nonatomic, strong) NSString *expertWarehousing;
//原专业名称
@property (nonatomic, strong) NSString *beforeProfessionName;
//原专业ID
@property (nonatomic, strong) NSString *beforeProfession;
//获取新专业的第一个 （主评专业）索引值
@property (nonatomic)int newZPIndex;
//获取老专业的第一个 （主评专业）索引值
@property (nonatomic)int oldZPIndex;
//是否为主评专业
@property (nonatomic)int mainProfession;
@end

NS_ASSUME_NONNULL_END
