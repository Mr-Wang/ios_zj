//
//  WY_MyInvoiceListTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/22.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyInvoiceListTableViewCell.h"

@implementation WY_MyInvoiceListTableViewCell

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
    self.viewBG = [UIView new];
    self.imgGreen = [UIImageView new];
    self.imgInvoiceType = [UIImageView new];
    self.lblTypeStr = [UILabel new];
    self.lblContent = [UILabel new];
    
    [self.viewBG addSubview:self.imgGreen];
    [self.viewBG addSubview:self.imgInvoiceType];
    [self.viewBG addSubview:self.lblContent];
    [self.viewBG addSubview:self.lblTypeStr];
    [self addSubview:self.viewBG];
    
    [self.viewBG setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(150))];
    [self.viewBG setBackgroundColor:[UIColor whiteColor]];
    [self.viewBG rounded:k360Width(44/8) width:1 color:APPLineColor];
    
    [self.imgGreen setFrame:CGRectMake(k360Width(16), k360Width(26), k360Width(10), k360Width(10))];
    [self.imgGreen setBackgroundColor:[UIColor greenColor]];
    [self.imgGreen rounded:self.imgGreen.height / 2];
    
    [self.lblTypeStr setFrame:CGRectMake(self.imgGreen.right + k360Width(5), k360Width(16), k360Width(100), k360Width(22))];
    [self.lblTypeStr setTextColor:APPTextGayColor];
    [self.lblTypeStr setFont:WY_FONTRegular(14)];
    
    self.imgGreen.centerY = self.lblTypeStr.centerY;
    
    [self.imgInvoiceType setFrame:CGRectMake(self.viewBG.width - k360Width(48 + 16), k360Width(16), k360Width(48), k360Width(35))];
    [self.lblContent setFrame:CGRectMake(k360Width(16), self.imgInvoiceType.bottom, self.viewBG.width - k360Width(32), k360Width(100))];
    [self.lblContent setNumberOfLines:0];
    
}
- (void)showCellByItem:(WY_InvoiceListItemModel *)withWY_InvoiceListItemModel {
    self.mWY_InvoiceListItemModel = withWY_InvoiceListItemModel;
    if ([withWY_InvoiceListItemModel.InvoiceType isEqualToString:@"1"]) {
        self.lblTypeStr.text = @"企业";
    } else {
        self.lblTypeStr.text = @"个人";
    }
    if ([withWY_InvoiceListItemModel.invoiceoftype isEqualToString:@"1"]) {
        [self.imgInvoiceType setImage:[UIImage imageNamed:@"icon_dzfp"]];
    } else if ([withWY_InvoiceListItemModel.invoiceoftype isEqualToString:@"2"]) {
        [self.imgInvoiceType setImage:[UIImage imageNamed:@"icon_zzfp"]];
    } else if ([withWY_InvoiceListItemModel.invoiceoftype isEqualToString:@"3"]) {
        [self.imgInvoiceType setImage:[UIImage imageNamed:@"icon_zp"]];
    }
    NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:withWY_InvoiceListItemModel.InvoiceName];
    NSMutableAttributedString *strContent1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n发票金额：￥%@",withWY_InvoiceListItemModel.Amount]];
    NSString *kpztStr = @"";
    if ([withWY_InvoiceListItemModel.fpzt isEqualToString:@"1"]) {
        kpztStr = @"已开票";
    } else {
        kpztStr = @"未开票";
    }
    NSMutableAttributedString *strContent2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n开票状态：%@",kpztStr]];
    
    [strContent setYy_font:WY_FONTMedium(16)];
    [strContent setYy_color:[UIColor blackColor]];
    
    [strContent1 setYy_font:WY_FONTRegular(14)];
    [strContent2 setYy_font:WY_FONTRegular(14)];
    [strContent1 setYy_color:APPTextGayColor];
    [strContent2 setYy_color:APPTextGayColor];
    
    [strContent appendAttributedString:strContent1];
    [strContent appendAttributedString:strContent2];
    
    [strContent setYy_lineSpacing:6];
    
    self.lblContent.attributedText = strContent;
    self.viewBG.height = self.lblContent.bottom + k360Width(16);
    self.height = self.viewBG.bottom + k360Width(8);
}

@end
