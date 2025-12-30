//
//  WY_MyTQListTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MyTQListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lbl1;
@property (nonatomic, strong) UILabel *lbl2;
@property (nonatomic, strong) UILabel *lbl3;
@property (nonatomic, strong) UILabel *lbl4;
@property (nonatomic, strong) UILabel *lbl5;
@property (nonatomic, strong) UIButton *btnUpdate;
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_QuestionModel *mWY_QuestionModel;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;
- (void)showCellByItem:(WY_QuestionModel *)withWY_QuestionModel;
@end

NS_ASSUME_NONNULL_END
