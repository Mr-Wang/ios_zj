//
//  WY_MyBankCardTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyBankCardTableViewCell.h"

@implementation WY_MyBankCardTableViewCell

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
    [self setBackgroundColor:HEXCOLOR(0xFAFAFA)];
//    self.colSender = [[UIControl alloc] init];
    self.imgBG = [UIImageView new];
    [self.imgBG setFrame:CGRectMake(k375Width(19), k375Width(5), k375Width(336), k375Width(112))];
    [self.contentView addSubview:self.imgBG];
    
    self.imgBankIcon = [UIImageView new];
    [self.imgBankIcon setFrame:CGRectMake(k375Width(38), k375Width(20), k375Width(19), k375Width(15))];
    [self.imgBankIcon setImage:[UIImage imageNamed:@"0629_cardicon"]];
    [self.contentView addSubview:self.imgBankIcon];
    
    self.lblTitle = [UILabel new];
    [self.lblTitle setFrame:CGRectMake(self.imgBankIcon.right + k375Width(5), self.imgBankIcon.top - k375Width(5), k375Width(200), self.imgBankIcon.height + k375Width(10))];
    [self.lblTitle setFont:[UIFont fontWithName:@"Source Han Sans SC" size:k375Width(14)]];
    [self.lblTitle setTextColor:[UIColor whiteColor]];    
    [self.contentView addSubview:self.lblTitle];
    
    self.btnjcbd = [UIButton new];
    [self.btnjcbd setFrame:CGRectMake(self.imgBG.right - k375Width(70), k375Width(9), k375Width(63), k375Width(18))];
    [self.btnjcbd setBackgroundImage:[UIImage imageNamed:@"0629_jcbd"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnjcbd];
    
    self.lblCardNum = [UILabel new];
    [self.lblCardNum setFrame:CGRectMake(0, self.lblTitle.bottom + k375Width(14), kScreenWidth, k375Width(44))];
    [self.lblCardNum setFont:[UIFont systemFontOfSize:k375Width(26)]];
    [self.lblCardNum setTextColor:[UIColor whiteColor]];
    [self.lblCardNum setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.lblCardNum];
}
- (void)showCellByItem:(WY_CompleteStatusModel *)withWY_CompleteStatusModel withInt:(int)withInt
{
    if (withInt%2==1) {
        [self.imgBG setImage:[UIImage imageNamed:@"0629_cardlist1"]];
    } else {
        [self.imgBG setImage:[UIImage imageNamed:@"0629_cardlist2"]];
    }
    self.lblTitle.text = @"建设银行";
    self.lblCardNum.text = @"****    ****    ****    0000";
         self.height = self.imgBG.bottom + k375Width(10);
}

@end
