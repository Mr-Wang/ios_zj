//
//  WY_AddressManageTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_AddressManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_AddressManageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_AddressManageModel
*mWY_AddressManageModel;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDef;
@property (nonatomic, strong) UIButton *btnEdit;

- (void)showCellByItem:(WY_AddressManageModel*)withWY_AddressManageModel;

@end

NS_ASSUME_NONNULL_END
