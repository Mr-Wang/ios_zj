//
//  WY_EditAddressViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/10.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_AddressManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_EditAddressViewController : UIViewController
@property (nonatomic) BOOL isEdit;
@property (nonatomic, strong) WY_AddressManageModel *mEditModel;
@end

NS_ASSUME_NONNULL_END
