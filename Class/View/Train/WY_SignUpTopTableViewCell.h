//
//  WY_SignUpTopTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TraCourseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_SignUpTopTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgCourse;
@property (nonatomic, strong) UILabel *lblIsPay;
@property (nonatomic, strong) YYLabel *lblTitle;
@property (nonatomic, strong) UILabel *lblCount;
@property (nonatomic, strong) UILabel *lblPrice;
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_TraCourseDetailModel *mWY_TraCourseDetailModel;
- (void)showCellByItem:(WY_TraCourseDetailModel*)withWY_TraCourseDetailModel;

@end

NS_ASSUME_NONNULL_END
