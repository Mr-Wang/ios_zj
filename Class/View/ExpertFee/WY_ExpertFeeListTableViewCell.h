//
//  WY_ExpertFeeListTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExpertFeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ExpertFeeListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *btnCall;

@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_ExpertFeeModel *mWY_ExpertFeeModel;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;
- (void)showCellByItem:(WY_ExpertFeeModel *)withWY_ExpertFeeModel;
@property (nonatomic,copy) void(^leavePhoneBlock)(WY_ExpertFeeModel *withModel);

@end

NS_ASSUME_NONNULL_END
