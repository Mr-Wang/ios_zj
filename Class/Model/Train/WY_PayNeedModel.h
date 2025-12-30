//
//  WY_PayNeedModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_PayNeedModel : MHObject
    //费用
    @property (nonatomic , strong) NSString *cost;
    /**
     * 支付方式
     */
    @property (nonatomic , strong) NSString *paymethod;
    /**
     * 商品描述
     */
    @property (nonatomic , strong) NSString *body;
    /**
     * 商品订单号
     */
    @property (nonatomic , strong) NSString *out_trade_no;

    @property (nonatomic , strong) NSString *orderDetailBean;
@property (nonatomic , strong) NSString *userGuid;

    @property (nonatomic , strong) NSString *orderGuid;
@end

NS_ASSUME_NONNULL_END
