//
//  WY_AddressManageViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_AddressManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_AddressManageViewController : UIViewController
@property (nonatomic) BOOL isSel;
@property (nonatomic,copy) void(^selAddressBlock)(WY_AddressManageModel *selModel);
@end

NS_ASSUME_NONNULL_END
