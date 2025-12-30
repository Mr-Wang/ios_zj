//
//  WY_HomeVideoItemTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/7.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_InfomationModel.h"
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_HomeVideoItemTableViewCell : UITableViewCell
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) UIImageView *imgContent;
@property (nonatomic, strong) SDCycleScrollView *headerView;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) WY_InfomationModel *mWY_InfomationModel;
@property (nonatomic)NSInteger currentSelIndex;
- (void)showCellByItem:(NSArray*)withArrModel;

@end

NS_ASSUME_NONNULL_END
