//
//  WY_MyCreditTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/22.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_CreditItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MyCreditTableViewCell : UITableViewCell
@property (nonatomic, strong) WY_CreditItemModel *mWY_CreditItemModel;
@property (nonatomic, strong) UIControl *colSender;
 @property (nonatomic, strong) UIImageView *imgInvoiceType;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UILabel *lblContent1;
@property (nonatomic, strong) UILabel *lblData;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lbl4;
@property (nonatomic, strong) UILabel *lbl41;
- (void)showCellByItem:(WY_CreditItemModel *)withWY_CreditItemModel;
@end

NS_ASSUME_NONNULL_END
