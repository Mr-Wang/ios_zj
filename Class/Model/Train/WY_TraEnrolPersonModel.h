//
//  WY_TraEnrolPersonModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_TraEnrolPersonModel : MHObject
@property (nonatomic , strong) NSString * job;
@property (nonatomic , strong) NSString * DanWeiName;
@property (nonatomic , strong) NSString * email;
@property (nonatomic , strong) NSString * UserName;
@property (nonatomic , strong) NSString * isruku;
@property (nonatomic , strong) NSString * WeiXin;
@property (nonatomic , strong) NSString * Phone;
@property (nonatomic , strong) NSString * ClassGuid;
//        "isfree": "1 是 0否", 
@property (nonatomic , strong) NSString * isfree;
@property (nonatomic , strong) NSString *  sex; //1男 2女
@property (nonatomic , strong) NSString *  baomingidcard;

/// 附件
@property (nonatomic , strong) NSString *ettachmentUrl;//申请表

/// 职称
@property (nonatomic , strong) NSString *ettachmentZhiCUrl;

/// 论文
@property (nonatomic , strong) NSString *ettachmentWorkUrl;

/// 奖惩情况
@property (nonatomic , strong) NSString *ettachmentAwardUrl;

@end

NS_ASSUME_NONNULL_END
