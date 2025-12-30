//
//  WY_SignUpStudentItemTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SignUpStudentItemTableViewCell.h"

@implementation WY_SignUpStudentItemTableViewCell
{
    UIImageView *imgLine;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self makeUI];
        [self.colSender setUserInteractionEnabled:NO];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        self.userInteractionEnabled = YES;
        [self makeUI];
        [self.colSender setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)makeUI {
    self.colSender = [[UIControl alloc] init];
    self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(70), k360Width(20))];
    self.imgSex = [[UIImageView alloc] initWithFrame:CGRectMake(self.lblName.right, self.lblName.top, k360Width(12), k360Width(20))];
    self.lblPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(self.imgSex.right + k360Width(16), self.imgSex.top, k360Width(160), k360Width(20))];
    self.lblCompanyName = [[UILabel alloc] initWithFrame:CGRectMake(self.lblName.left, self.lblName.bottom + k360Width(10), kScreenWidth - k360Width(32), k360Width(20))];
    
        imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.lblCompanyName.bottom + k360Width(14),kScreenWidth, 1)];
        [imgLine setBackgroundColor:APPLineColor];
        [self.contentView addSubview:imgLine];

    [self.lblName setFont: WY_FONTMedium(16)];
    [self.lblPhoneNum setFont:WY_FONTRegular(12)];
    [self.lblPhoneNum setTextColor:HEXCOLOR(0x626262)];
    [self.lblCompanyName setFont:WY_FONTRegular(14)];

    [self.contentView addSubview:self.lblName];
    [self.contentView addSubview:self.lblPhoneNum];
    [self.contentView addSubview:self.lblCompanyName];
    [self.contentView addSubview:self.imgSex];
    
}

- (void)showCellByItem:(WY_TraEnrolPersonModel*)withWY_TraEnrolPersonModel
{
    self.mWY_TraEnrolPersonModel = withWY_TraEnrolPersonModel;
    self.lblName.text = self.mWY_TraEnrolPersonModel.UserName;
    self.lblPhoneNum.text = self.mWY_TraEnrolPersonModel.Phone;
    self.lblCompanyName.text = self.mWY_TraEnrolPersonModel.DanWeiName;
    // 1男  0女
    if ([self.mWY_TraEnrolPersonModel.sex isEqualToString:@"1"]) {
        [self.imgSex setImage:[UIImage imageNamed:@"nan"]];
    } else {
          [self.imgSex setImage:[UIImage imageNamed:@"nv"]];
    }    
    self.height = imgLine.bottom;
}

@end
