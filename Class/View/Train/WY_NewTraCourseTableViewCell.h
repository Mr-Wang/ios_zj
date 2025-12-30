//
//  WY_NewTraCourseTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TrainItemModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface WY_NewTraCourseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_TrainItemModel *mWY_TrainItemModel;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) UIImageView *imgContentBg;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UILabel *lblLjbm;
@property (nonatomic, strong) UIImageView *imgAcc;
@property (nonatomic, strong) UIImageView *bgImg;


- (void)showCellByItem:(WY_TrainItemModel*)withWY_TrainItemModel withNum:(int)withNum;
@end

NS_ASSUME_NONNULL_END
