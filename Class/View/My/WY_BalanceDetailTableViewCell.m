//
//  WY_BalanceDetailTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/7.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_BalanceDetailTableViewCell.h"

@implementation WY_BalanceDetailTableViewCell
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
     }
    return self;
}

- (void)makeUI {
      self.lblContent = [UILabel new];
    [self.lblContent setNumberOfLines:0];
    [self.contentView addSubview:self.lblContent];
    
    self.lblMoney = [UILabel new];
     [self.lblMoney setTextAlignment:NSTextAlignmentRight];
      [self.contentView addSubview:self.lblMoney];
    
      self.lblDate = [UILabel new];
         [self.contentView addSubview:self.lblDate];
    
        self.lblCurrentMoney = [UILabel new];
                [self.lblCurrentMoney setTextAlignment:NSTextAlignmentRight];
          [self.contentView addSubview:self.lblCurrentMoney];
          
 
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), self.lblCurrentMoney.bottom - 1, kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];
    
}
- (void)showCellByItem:(WY_TopUpModel *)withWY_TopUpModel {
    self.mWY_TopUpModel = withWY_TopUpModel;
    [self.lblContent setFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(100), k360Width(44))];
    [self.lblMoney setFrame:CGRectMake(kScreenWidth - k360Width(166), 0, k360Width(150), k360Width(44))];
    [self.lblDate setFrame:CGRectMake(k360Width(16), self.lblContent.bottom, kScreenWidth - k360Width(166 + 32), k360Width(44))];
    [self.lblCurrentMoney setFrame:CGRectMake(kScreenWidth - k360Width(166), self.lblMoney.bottom, k360Width(150), k360Width(44))];
    
//    [self.lblContent setBackgroundColor:[UIColor redColor]];
    self.lblContent.text =  withWY_TopUpModel.detailText;
    [self.lblContent setFont:WY_FONTRegular(14)];
    [self.lblMoney setFont:WY_FONTMedium(14)];
    [self.lblDate setFont:WY_FONTRegular(12)];
    [self.lblCurrentMoney setFont:WY_FONTRegular(12)];
    [self.lblDate setTextColor:APPTextGayColor];
    [self.lblCurrentMoney setTextColor:APPTextGayColor];
    if ([withWY_TopUpModel.type isEqualToString:@"1"]) {
        self.lblMoney.text = [NSString stringWithFormat:@"+%.2f",[withWY_TopUpModel.amount floatValue]];
        [self.lblMoney setTextColor:HEXCOLOR(0xe5b14a)];
//        self.lblContent.text = @"充值";
    } else {
        self.lblMoney.text = [NSString stringWithFormat:@"-%.2f",[withWY_TopUpModel.amount floatValue]];
        [self.lblMoney setTextColor:[UIColor blackColor]];
//        self.lblContent.text = withWY_TopUpModel.detailText;

    }
    self.lblDate.text = withWY_TopUpModel.createTime;
    self.lblCurrentMoney.text = [NSString stringWithFormat:@"余额%.2f",[withWY_TopUpModel.checkAmount floatValue]];
        
    imgLine.top = self.lblCurrentMoney.bottom - 1;
      self.height = self.lblCurrentMoney.bottom;
}

@end
