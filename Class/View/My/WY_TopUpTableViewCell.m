//
//  WY_TopUpTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_TopUpTableViewCell.h"

@implementation WY_TopUpTableViewCell
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
        [self.lblContent setFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), k360Width(44))];
    
    [self.lblContent setNumberOfLines:0];
    [self.contentView addSubview:self.lblContent];
    
    self.btnBuy = [UIButton new];
    self.btnBuy.userInteractionEnabled = NO;
    [self.btnBuy setFrame:CGRectMake(kScreenWidth - k360Width(93), 9, k360Width(75), k360Width(30))];
    [self.btnBuy.titleLabel setFont:WY_FONTRegular(10)];
    self.btnBuy.centerY = self.lblContent.centerY;
    [self.btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnBuy setBackgroundColor:HEXCOLOR(0xDD3429)];
    [self.btnBuy.titleLabel setFont:WY_FONTRegular(14)];
    [self.btnBuy rounded:k360Width(30 / 6)];
    [self.contentView addSubview:self.btnBuy];
    
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), self.lblContent.bottom - 1, kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];
    
}
- (void)showCellByItem:(WY_TopUpModel *)withWY_TopUpModel {
    self.mWY_TopUpModel = withWY_TopUpModel;
    self.lblContent.text = withWY_TopUpModel.itemText;
    [self.btnBuy setTitle:[NSString stringWithFormat:@"￥%.2f",[withWY_TopUpModel.itemValue floatValue]] forState:UIControlStateNormal];
     self.height = self.lblContent.bottom;
}

@end
