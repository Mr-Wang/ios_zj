//
//  WY_MyInvoiceListTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/22.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_InvoiceListItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MyInvoiceListTableViewCell : UITableViewCell
@property (nonatomic, strong) WY_InvoiceListItemModel *mWY_InvoiceListItemModel;
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic, strong) UIView *viewBG;
@property (nonatomic, strong) UIImageView *imgGreen;
@property (nonatomic, strong) UILabel *lblTypeStr;
@property (nonatomic, strong) UIImageView *imgInvoiceType;
@property (nonatomic, strong) UILabel *lblContent;
- (void)showCellByItem:(WY_InvoiceListItemModel *)withWY_InvoiceListItemModel;
@end

NS_ASSUME_NONNULL_END
