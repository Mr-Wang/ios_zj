//
//  WY_MyBankCardTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_CompleteStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MyBankCardTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblStatus;
@property (nonatomic, strong) UILabel *lblLeft1;
@property (nonatomic, strong) UILabel *lblLeft2;
@property (nonatomic, strong) UILabel *lblRight1;
@property (nonatomic, strong) UILabel *lblRight2;
@property (nonatomic, strong) UIImageView *img1;
@property (nonatomic, strong) UIImageView *img2;
@property (nonatomic, strong) UIImageView *img3;
@property (nonatomic, strong) UIImageView *imgLine;

 @property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_CompleteStatusModel *mWY_CompleteStatusModel;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic, strong) UIImageView *imgBG;
@property (nonatomic, strong) UIImageView *imgBankIcon;
@property (nonatomic, strong) UIButton *btnJcbd;
@property (nonatomic, strong) UILabel *lblCardNum;
@property (nonatomic, strong) UIButton *btnjcbd;

- (void)showCellByItem:(WY_CompleteStatusModel *)withWY_CompleteStatusModel withInt:(int)withInt;
@end

NS_ASSUME_NONNULL_END
