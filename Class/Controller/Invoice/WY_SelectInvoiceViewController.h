//
//  WY_SelectInvoiceViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_SendEnrolmentMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_SelectInvoiceViewController : UIViewController
@property (nonatomic, strong) WY_SendEnrolmentMessageModel *mWY_SendEnrolmentMessageModel;
@property (nonatomic,copy) void(^saveInvoiceBlock)(WY_SendEnrolmentMessageModel *saveModel);
//咨询类别 -1线上咨询 。2线下支付
@property (nonatomic , strong) NSString *adviceType;

@property (nonatomic, strong) NSString *invoiceID;
@property (nonatomic) BOOL isCanSave;
@end

NS_ASSUME_NONNULL_END
