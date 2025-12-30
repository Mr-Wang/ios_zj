//
//  WY_KsNoticeTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExamListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_KsNoticeTableViewCell : UITableViewCell
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) WY_ExamListModel *mWY_ExamListModel;
- (void)showCellByItem:(WY_ExamListModel*)withWY_ExamListModel;
@end

NS_ASSUME_NONNULL_END
