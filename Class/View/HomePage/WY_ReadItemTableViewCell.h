//
//  WY_ReadItemTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_InfomationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ReadItemTableViewCell : UITableViewCell
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) UIImageView *imgContent;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) WY_InfomationModel *mWY_InfomationModel;

- (void)showCellByItem:(WY_InfomationModel*)withWY_InfomationModel;


@end

NS_ASSUME_NONNULL_END
