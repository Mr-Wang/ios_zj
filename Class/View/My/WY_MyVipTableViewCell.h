//
//  WY_MyVipTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WY_VipInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_MyVipTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *openVip;
@property (nonatomic, strong) WY_VipInfoModel *vipModel;
- (void)showVipViewByVipModel:(WY_VipInfoModel *)withWY_VipInfoModel;

@property (nonatomic,copy) void(^openVipAction)(void);
@end

NS_ASSUME_NONNULL_END
