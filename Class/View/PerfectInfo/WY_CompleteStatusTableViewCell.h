//
//  WY_CompleteStatusTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_CompleteStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CompleteStatusTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblStatus;
@property (nonatomic, strong) UILabel *lblLeft1;
@property (nonatomic, strong) UILabel *lblLeft2;
@property (nonatomic, strong) UILabel *lblRight1;
@property (nonatomic, strong) UILabel *lblRight2;
@property (nonatomic, strong) UILabel *lblshyy;
@property (nonatomic, strong) UIImageView *img1;
@property (nonatomic, strong) UIImageView *img2;
@property (nonatomic, strong) UIImageView *img3;
@property (nonatomic, strong) UIImageView *imgLine;

 @property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_CompleteStatusModel *mWY_CompleteStatusModel;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSString *nsType;//综合审核记录 1 、地区审核记录 2
- (void)showCellByItem:(WY_CompleteStatusModel *)withWY_CompleteStatusModel;
- (void)showAddressCellByItem:(WY_CompleteStatusModel *)withWY_CompleteStatusModel;
- (void)showNNNewCellByItem:(WY_CompleteStatusModel *)withWY_CompleteStatusModel;
@end

NS_ASSUME_NONNULL_END
