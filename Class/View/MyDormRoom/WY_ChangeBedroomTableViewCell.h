//
//  WY_ChangeBedroomTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/10/26.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_ChangeBedroomTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) UILabel *lblTimeNum;
@property (nonatomic, strong) UILabel *lblTimeNum2;

@property (nonatomic, strong) UILabel *lblTimeNum3;
@property (nonatomic, strong) UIView *viewInfo;
@property (nonatomic, strong) UIImageView *viewInfoBg;
@end

NS_ASSUME_NONNULL_END
