//
//  WY_OrderInfoTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_SendEnrolmentMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_OrderInfoTableViewCell : UITableViewCell
@property (nonatomic , strong) WY_SendEnrolmentMessageModel *mWY_SendEnrolmentMessageModel;
@property (nonatomic , strong) UIView *viewOrder;
@property (nonatomic ,strong) NSMutableDictionary *dicOrder;
@property (nonatomic, strong) UIControl *colSender;
@property (nonatomic) NSString *priceStr;
@property (nonatomic,copy) void(^gotoInvoiceBlock)(void);
- (void)showCellByItem:(NSDictionary*)withDicOrder withPaymethod:(NSString *)withPaymethod;

@end

NS_ASSUME_NONNULL_END
