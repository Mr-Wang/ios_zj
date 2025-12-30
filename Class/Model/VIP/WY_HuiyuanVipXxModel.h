//
//  WY_HuiyuanVipXxModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/7/9.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_HuiyuanVipXxModel : MHObject
/// 折扣，你调我算价钱那个接口给你返回的值里有
@property (nonatomic, readwrite, copy) NSString *zk;
/// 办理人数
@property (nonatomic, readwrite, copy) NSString *infoCount;
/// 单价，就是选的哪个会员级别的钱，比如357
@property (nonatomic, readwrite, copy) NSString *price;
/// 你调我算价钱那个接口给你返回的值里有  实际收的费用
@property (nonatomic, readwrite, copy) NSString *reallPrice;
/// 总价 没打折之前的，你们前端要显示的那个，传给我
@property (nonatomic, readwrite, copy) NSString *totalPrice;
/// vipType;
@property (nonatomic, readwrite, copy) NSString *vipType;
/// 办理人员标识，逗号隔开
@property (nonatomic, readwrite, copy) NSString *userInfo;
/// 办理人员名称，逗号隔开
@property (nonatomic, readwrite, copy) NSString *userNameInfo;
/// 办理类型  1开通 2续费 3 升级
@property (nonatomic, readwrite, copy) NSString *infoType;
@end

NS_ASSUME_NONNULL_END
