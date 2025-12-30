//
//  WY_ZJPushMsgTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/1/21.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ZJPushMsgTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblDate;

@property (nonatomic, strong) UIImageView* imgLine;
@property (nonatomic, strong) WY_MessageModel *mWY_MessageModel;
- (void)showCellByItem:(WY_MessageModel *)withModel;
- (void)showCellDocByItem:(WY_MessageModel *)withModel;
@end

NS_ASSUME_NONNULL_END
