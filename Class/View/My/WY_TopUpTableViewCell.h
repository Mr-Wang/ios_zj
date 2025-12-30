//
//  WY_TopUpTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TopUpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_TopUpTableViewCell : UITableViewCell
@property (nonatomic, strong) WY_TopUpModel *mWY_TopUpModel;
@property (nonatomic, strong) UIControl *colSender;
 @property (nonatomic, strong) UIButton *btnBuy;
@property (nonatomic, strong) UILabel *lblContent;
- (void)showCellByItem:(WY_TopUpModel *)withWY_TopUpModel;

@end

NS_ASSUME_NONNULL_END
