//
//  WY_SettlementRecordTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_SettlementRecordTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *btnCall;

@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) NSDictionary *mNSDictionary;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;
- (void)showCellByItem:(NSDictionary *)withNSDictionary;
@property (nonatomic,copy) void(^leavePhoneBlock)(NSDictionary *withModel);

@end

NS_ASSUME_NONNULL_END
