//
//  WY_AddressManageTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AddressManageTableViewCell.h"

@implementation WY_AddressManageTableViewCell
{
    UIImageView * imgLine;
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
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(232), k360Width(82))];
    [self.contentView addSubview:self.lblTitle];

    self.lblDef = [[UILabel alloc] initWithFrame:CGRectMake(self.width - k360Width(96), k360Width(16), k360Width(80), k360Width(22))];
    [self.lblDef setTextAlignment:NSTextAlignmentRight];
    [self.lblDef setFont:WY_FONTMedium(14)];
    [self.lblDef setTextColor:HEXCOLOR(0x7F7F7F)];
    [self.contentView addSubview:self.lblDef];
    
    [self.contentView addSubview:self.colSender];
     
    self.btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(288), self.lblDef.bottom + k360Width(5), k360Width(24), k360Width(24))];
     [self.btnEdit setBackgroundImage:[UIImage imageNamed:@"0218_xgdz"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnEdit];

}

- (void)showCellByItem:(WY_AddressManageModel*)withWY_AddressManageModel{
    self.mWY_AddressManageModel = withWY_AddressManageModel;
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:self.mWY_AddressManageModel.UserName];
    [attStr1 setYy_font:WY_FONTRegular(14)];
    [attStr1 setYy_color:[UIColor blackColor]];
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"     %@",self.mWY_AddressManageModel.Mobile]];
    [attStr2 setYy_font:WY_FONTRegular(14)];
    [attStr2 setYy_color:[UIColor blackColor]];
    NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@%@%@%@",self.mWY_AddressManageModel.province,self.mWY_AddressManageModel.city,self.mWY_AddressManageModel.district,self.mWY_AddressManageModel.Address]];
    [attStr3 setYy_font:WY_FONTRegular(12)];
    [attStr3 setYy_color:APPTextGayColor];
    [attStr1 appendAttributedString:attStr2];
    [attStr1 appendAttributedString:attStr3];
    
    [attStr1 setYy_lineSpacing:5];
    
    [self.lblDef setText:@"默认地址"];
    if ([self.mWY_AddressManageModel.IsDefault isEqualToString:@"1"]) {
        [self.lblDef setHidden:NO];
    } else {
        [self.lblDef setHidden:YES];
    }
    [self.lblTitle setFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(232), k360Width(82))];
    [self.lblTitle setNumberOfLines:0];
    [self.lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
    self.lblTitle.attributedText = attStr1;
    [self.lblTitle sizeToFit];
   
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.lblTitle.bottom + k360Width(16),self.width - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];

 
    self.height = imgLine.bottom;
    [self.colSender setFrame:self.bounds];
    
}

@end
