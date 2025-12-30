//
//  WY_VDListTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/8.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_InfomationModel.h"
#import "WY_PersonalScoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_VDListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) WY_InfomationModel *mWY_InfomationModel;
@property (nonatomic, strong) WY_PersonalScoreModel *mWY_PersonalScoreModel;
- (void)showCellByItem:(WY_InfomationModel*)withWY_InfomationModel withInt:(NSInteger)withInt;
-(void)showOrgIntegralCellByItem:(WY_PersonalScoreModel*)withWY_PersonalScoreModel;

@end

NS_ASSUME_NONNULL_END
