//
//  WY_SignUpStudentItemTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TraEnrolPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_SignUpStudentItemTableViewCell : UITableViewCell
@property (nonatomic ,strong) WY_TraEnrolPersonModel *mWY_TraEnrolPersonModel;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblPhoneNum;
@property (nonatomic, strong) UILabel *lblCompanyName;
@property (nonatomic, strong) UIImageView *imgSex;
@property (nonatomic, strong) UIControl *colSender;
- (void)showCellByItem:(WY_TraEnrolPersonModel*)withWY_TraEnrolPersonModel;
@end

NS_ASSUME_NONNULL_END
