//
//  WY_QRCompanyHeaderTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_RankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QRCompanyHeaderTableViewCell : UITableViewCell
@property (nonatomic, strong) WY_RankModel *mWY_RankModel;
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) UIImageView *imgContent;
@property (nonatomic, strong) UILabel *lblNum;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) UILabel *lblRight;
- (void)showCellByItem:(WY_RankModel*)withWY_RankModel;

@end

NS_ASSUME_NONNULL_END
