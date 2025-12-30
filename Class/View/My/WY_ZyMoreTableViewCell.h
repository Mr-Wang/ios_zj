//
//  WY_ZyMoreTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/2/9.
//  Copyright © 2022 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_CurZyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ZyMoreTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblStatus;
@property (nonatomic, strong) UILabel *lblRight1;
@property (nonatomic, strong) UILabel *lblRight2;  

 @property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) WY_CurZyModel *mWY_CurZyModel;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) UIImageView *imgLineA;

- (void)showCellByItem:(NSDictionary *)withWY_CurZyModel withInt:(int)withInt;
@end

NS_ASSUME_NONNULL_END
