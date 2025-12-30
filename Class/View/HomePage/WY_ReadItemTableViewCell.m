//
//  WY_ReadItemTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ReadItemTableViewCell.h"

@implementation WY_ReadItemTableViewCell
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
    self.imgContent = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16),  k360Width(12), k360Width(12))];
     [self.contentView addSubview:_imgContent];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.imgContent.right + k360Width(16), k360Width(8), kScreenWidth - k360Width(56), k360Width(22))];
    [self.lblTitle setFont: WY_FONTMedium(14)];
    [self.contentView addSubview:self.lblTitle];
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom + k360Width(16), self.lblTitle.width, k360Width(22))];
    [self.lblDate setFont: WY_FONTRegular(14)];
    [self.lblDate setTextColor:HEXCOLOR(0x909090)];
    [self.contentView addSubview:self.lblDate];
    
    [self.contentView addSubview: self.colSender];
    
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.lblDate.bottom + k360Width(16),kScreenWidth - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];

}

- (void)showCellByItem:(WY_InfomationModel*)withWY_InfomationModel {
    self.mWY_InfomationModel = withWY_InfomationModel;
    if ([self.mWY_InfomationModel.isRead isEqualToString:@"1"]) {
        [self.lblTitle setTextColor:APPTextGayColor];
    } else {
        [self.lblTitle setTextColor:[UIColor blackColor]];
    }
    
    if ([self.mWY_InfomationModel.isTop isEqualToString:@"1"]) {
        NSMutableAttributedString *topTitle =[NSMutableAttributedString new];
        [topTitle yy_appendString:@"【置顶】"];
        [topTitle setYy_color:[UIColor redColor]];
        
        NSMutableAttributedString *topTitle1 =[[NSMutableAttributedString alloc] initWithString:self.mWY_InfomationModel.title];
        [topTitle appendAttributedString:topTitle1];
        
        self.lblTitle.attributedText = topTitle;
    } else {
        NSMutableAttributedString *topTitle1 =[[NSMutableAttributedString alloc] initWithString:self.mWY_InfomationModel.title];
 
        self.lblTitle.attributedText = topTitle1;
    }
    
   
    if ([self.mWY_InfomationModel.categorynum isEqualToString:@"002"]) {
        self.imgContent.width = k360Width(16);
        self.imgContent.height = k360Width(16);
    } else {
        self.imgContent.width = k360Width(12);
        self.imgContent.height = k360Width(12);
    }
    [self.imgContent setImage:[UIImage imageNamed:[WY_WLTools categoryImgStringByNum:self.mWY_InfomationModel.categorynum]]];
//    [self.imgContent sd_setImageWithURL:[NSURL URLWithString:[WY_WLTools categoryImgStringByNum:self.mWY_InfomationModel.categorynum]]];
    NSString *typeStr = [WY_WLTools categoryStringByNum:self.mWY_InfomationModel.categorynum];
    
     self.lblDate.text = [NSString stringWithFormat:@"%@    %@",typeStr,self.mWY_InfomationModel.infodate];
    self.height = imgLine.bottom + k360Width(5);
    [self.colSender setFrame:self.bounds];

}
@end
