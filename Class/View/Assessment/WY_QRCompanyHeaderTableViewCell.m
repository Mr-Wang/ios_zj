//
//  WY_QRCompanyHeaderTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QRCompanyHeaderTableViewCell.h"

@implementation WY_QRCompanyHeaderTableViewCell
{
    UIImageView *imgBg;
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
    //67
    self.colSender = [[UIControl alloc] init];
    
    imgBg = [UIImageView new];
    [imgBg setFrame:CGRectMake(k360Width(8), k360Width(16), kScreenWidth - k360Width(16), k360Width(82))];
    [imgBg setImage:[UIImage imageNamed:@"0226_Rectangle"]];
    [self.contentView addSubview:imgBg];
    
    self.imgContent = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(32), k360Width(32),  k360Width(44), k360Width(44))];
    _imgContent.centerY = imgBg.centerY;
     [self.contentView addSubview:_imgContent];
 
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.imgContent.right + k360Width(16), self.imgContent.top - k360Width(4), kScreenWidth - k360Width(56), k360Width(22))];
    [self.lblTitle setFont: WY_FONTMedium(16)];
    [self.contentView addSubview:self.lblTitle];
    
    self.lblNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(250), self.lblTitle.top, k360Width(200), k360Width(22))];
    [self.lblNum setFont: WY_FONTRegular(14)];
    [self.lblNum setTextAlignment:NSTextAlignmentRight];
    [self.lblNum setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_lblNum];

    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom + k360Width(8), self.lblTitle.width, k360Width(22))];
    [self.lblDate setFont: WY_FONTRegular(14)];
    [self.lblDate setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:self.lblDate];
    
    self.lblRight = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(250), self.lblTitle.bottom + k360Width(8), k360Width(200), k360Width(22))];
    [self.lblRight setFont: WY_FONTRegular(14)];
    [self.lblRight setTextAlignment:NSTextAlignmentRight];
    [self.lblRight setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:self.lblRight];
    UIView *viewShu = [[UIView alloc] initWithFrame:CGRectMake(k360Width(192), self.lblDate.top, k360Width(2), k360Width(14))];
    [viewShu setBackgroundColor:APPLineColor];
    viewShu.centerY = self.lblDate.centerY;
    [self.contentView addSubview:viewShu];
    [self.contentView addSubview: self.colSender];
 
}

- (void)showCellByItem:(WY_RankModel*)withWY_RankModel {
    self.mWY_RankModel = withWY_RankModel;
    [self.imgContent setImage:[UIImage imageNamed:@"default_head"]];
    self.lblTitle.text = withWY_RankModel.username ;
    
    NSMutableAttributedString *kscsAttStr = [[NSMutableAttributedString alloc] initWithString:@"考试次数"];
    NSMutableAttributedString *kscsAttStr1 = [[NSMutableAttributedString alloc] initWithString:withWY_RankModel.count];
    [kscsAttStr1 setYy_color:[UIColor redColor]];
    NSMutableAttributedString *kscsAttStr2 = [[NSMutableAttributedString alloc] initWithString:@"次"];
    [kscsAttStr appendAttributedString:kscsAttStr1];
    [kscsAttStr appendAttributedString:kscsAttStr2];
    self.lblDate.attributedText = kscsAttStr;
    
    NSMutableAttributedString *wdpmAttStr = [[NSMutableAttributedString alloc] initWithString:@"我的排名"];
    NSMutableAttributedString *wdpmAttStr1 = [[NSMutableAttributedString alloc] initWithString:withWY_RankModel.rank];
    [wdpmAttStr1 setYy_color:[UIColor redColor]];
    NSMutableAttributedString *wdpmAttStr2 = [[NSMutableAttributedString alloc] initWithString:@"名"];
    [wdpmAttStr appendAttributedString:wdpmAttStr1];
    [wdpmAttStr appendAttributedString:wdpmAttStr2];
    self.lblNum.attributedText = wdpmAttStr;
    
    NSMutableAttributedString *zhcjAttStr = [[NSMutableAttributedString alloc] initWithString:@"最好成绩"];
    NSMutableAttributedString *zhcjAttStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[withWY_RankModel.bestscore floatValue]]];
    [zhcjAttStr1 setYy_color:[UIColor redColor]];
    NSMutableAttributedString *zhcjAttStr2 = [[NSMutableAttributedString alloc] initWithString:@"分"];
    [zhcjAttStr appendAttributedString:zhcjAttStr1];
    [zhcjAttStr appendAttributedString:zhcjAttStr2];
    self.lblRight.attributedText = zhcjAttStr;
    self.height = imgBg.bottom + k360Width(16);
    [self.colSender setFrame:self.bounds];
 }


@end
