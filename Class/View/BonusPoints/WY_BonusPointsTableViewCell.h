//
//  WY_BonusPointsTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExpertModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_BonusPointsTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lbl1;
@property (nonatomic, strong) UILabel *lbl2;
@property (nonatomic, strong) UILabel *lblBottom;
@property (nonatomic, strong) UIButton *btnUpdate;
@property (nonatomic, strong) UIButton *btnCall;
@property (nonatomic, strong) UIButton *btnJieMi;
@property (nonatomic, strong) UIButton *btnPingJia;
@property (nonatomic, strong) UIButton *btnDLPingJia;

@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_ExpertModel *mWY_ExpertModel;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;

- (void)showCellSSByItem:(WY_ExpertModel *)withWY_ExpertModel;
- (void)showCellOPByItem:(WY_ExpertModel *)withWY_ExpertModel;
- (void)showCellLLByItem:(WY_ExpertModel *)withWY_ExpertModel;
- (void)showCellZTCPByItem:(WY_ExpertModel *)withWY_ExpertModel;

@property (nonatomic,copy) void(^btnImageShowBlock)(NSString *withUrl);

@end

NS_ASSUME_NONNULL_END
