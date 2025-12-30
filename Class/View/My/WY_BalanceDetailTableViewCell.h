//
//  WY_BalanceDetailTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/7.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TopUpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_BalanceDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) WY_TopUpModel *mWY_TopUpModel;
@property (nonatomic, strong) UIControl *colSender;
 @property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UILabel *lblMoney;
@property (nonatomic, strong) UILabel *lblCurrentMoney;
@property (nonatomic, strong) UILabel *lblDate;
- (void)showCellByItem:(WY_TopUpModel *)withWY_TopUpModel;

@end

NS_ASSUME_NONNULL_END
