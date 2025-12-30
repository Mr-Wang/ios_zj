//
//  MS_MeModel.h
//  AnCheDangBu
//
//  Created by 古玉彬 on 16/9/21.
//  Copyright © 2016年 ms. All rights reserved.
//

#import "MS_BasicModel.h"

@interface MS_MeModel : MS_BasicModel



/**
 *  用户头像
 */
@property (nonatomic, copy) NSString * userHead;

/**
 *  用户id
 */
@property (nonatomic, copy) NSString * userId;

/**
 *  用户邀请码
 */
@property (nonatomic, copy) NSString * userInvitationCode;

/**
 *  用户等级
 */
@property (nonatomic, copy) NSString * userLevel;

/**
 *   用户钱包
 */
@property (nonatomic, assign) double userMoney;

/**
 *  用户名称
 */
@property (nonatomic, copy) NSString * userName;

/**
 *  用户联系方式
 */
@property (nonatomic, copy) NSString * userPhone;

/**
  是否是有会员车辆 1有会员车辆，2没有会员车辆 ,
 */
@property (nonatomic, copy) NSString *isMember;

/**
 城市
 */
@property (nonatomic, copy) NSString *userCtiyName;
/**
 绑定邀请码
 */
@property (nonatomic, copy) NSString *userBindCode;

+ (instancetype)shareMeModel;

+ (void)setInstances:(id) obj;
//置空
+ (void)removeObj ;

@end
