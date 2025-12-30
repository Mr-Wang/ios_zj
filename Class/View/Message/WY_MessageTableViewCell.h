//
//  WY_MessageTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/10/24.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_MessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) UILabel *lblTimeNum;
 @property (nonatomic, strong) UIView *viewInfo;
@property (nonatomic, strong) UIImageView *viewInfoBg;
@property (nonatomic, strong) WY_MessageModel *mWY_MessageModel;
- (void)showCellByItem:(WY_MessageModel *)withModel;

@end

NS_ASSUME_NONNULL_END
