//
//  WY_CACSOrderTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_CompleteStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CACSOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) UIButton *btnShouHuo;
@property (nonatomic, strong) UIButton *btnDel;
@property (nonatomic, strong) UIButton *btnToDetai;
 @property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) UIImageView *imgukey;
@property (nonatomic, strong) UIImageView *imgNew;
@property (nonatomic, strong) NSMutableDictionary *mWY_CompleteStatusModel;
@property (nonatomic, strong) UIView *viewCont;
@property (nonatomic, strong) WY_UserModel *mUser;
- (void)showCellByItem:(NSMutableDictionary *)withWY_CompleteStatusModel;
@end

NS_ASSUME_NONNULL_END
