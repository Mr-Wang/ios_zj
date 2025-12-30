//
//  WY_RecommendCourseTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TrainItemModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface WY_RecommendCourseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgCourse;
@property (nonatomic, strong) UILabel *lblIsPay;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblCount;
@property (nonatomic, strong) UILabel *lblPrice;
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_TrainItemModel *mWY_TrainItemModel;
- (void)showCellByItem:(WY_TrainItemModel*)withWY_TrainItemModel;
- (void)showZJHomeCellByItem:(WY_TrainItemModel*)withWY_TrainItemModel;
@end

NS_ASSUME_NONNULL_END
