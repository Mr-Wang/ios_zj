//
//  WY_BiddingProjectTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExpertModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_BiddingProjectTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lbl1;
@property (nonatomic, strong) UILabel *lblBottom;
@property (nonatomic, strong) UILabel *lblBottomA;
@property (nonatomic, strong) UIButton *btnUpdate;
@property (nonatomic, strong) UIButton *btnCall;
@property (nonatomic, strong) UIButton *btnCall1;

@property (nonatomic, strong) UIButton *btnJieMi;
@property (nonatomic, strong) UIButton *btnPingJia;
@property (nonatomic, strong) UIButton *btnDLPingJia;

@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_ExpertModel *mWY_ExpertModel;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic, strong) UIButton *btnHandleCA;

- (void)showCellByItem:(WY_ExpertModel *)withWY_ExpertModel;
- (void)showCellLSByItem:(WY_ExpertModel *)withWY_ExpertModel;
- (void)showCellSSByItem:(WY_ExpertModel *)withWY_ExpertModel;

@property (nonatomic,copy) void(^leavePhoneBlock)(WY_ExpertModel *withModel);
@property (nonatomic,copy) void(^btnDecryptBlock)(WY_ExpertModel *withModel);
@property (nonatomic,copy) void(^btnPingJiaBlock)(WY_ExpertModel *withModel);
@property (nonatomic,copy) void(^btnMyPingJiaBlock)(WY_ExpertModel *withModel);
@property (nonatomic,copy) void(^btnDLPingJiaBlock)(WY_ExpertModel *withModel);
@property (nonatomic,copy) void(^btnNavigationBlock)(WY_ExpertModel *withModel);
@property (nonatomic,copy) void(^btnHandleCABlock)(WY_ExpertModel *withModel);
@property (nonatomic,copy) void(^btnOnlineLeaveBlock)(WY_ExpertModel *withModel);

@end

NS_ASSUME_NONNULL_END
