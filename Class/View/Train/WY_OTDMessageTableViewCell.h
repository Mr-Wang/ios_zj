//
//  WY_OTDMessageTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_GuestBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_OTDMessageTableViewCell : UITableViewCell
@property (nonatomic , strong) WY_GuestBookModel *mWY_GuestBookModel;
 @property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UILabel *lblDate;

- (void)showCellByItem:(WY_GuestBookModel*)withModel;

@end

NS_ASSUME_NONNULL_END
