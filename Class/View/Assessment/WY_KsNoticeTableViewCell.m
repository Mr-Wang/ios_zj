//
//  WY_KsNoticeTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_KsNoticeTableViewCell.h"

@implementation WY_KsNoticeTableViewCell

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
    [self.contentView addSubview: self.colSender];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(132), k360Width(22))];
    [self.lblTitle setFont: WY_FONTMedium(16)];
    [self.contentView addSubview:self.lblTitle];
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom + k360Width(8), self.lblTitle.width, k360Width(22))];
    [self.lblDate setFont: WY_FONTRegular(14)];
    [self.lblDate setTextColor:HEXCOLOR(0x909090)];
    [self.contentView addSubview:self.lblDate];
    
    self.btnRight = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(116), self.lblTitle.top + k360Width(4), k360Width(100), k360Width(40))];
    [self.btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRight.titleLabel setFont:WY_FONTRegular(14)];
    [self.btnRight setBackgroundColor:MSTHEMEColor];
    [self.btnRight rounded:k360Width(40/2)];
    [self.contentView addSubview:self.btnRight];

    
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.lblDate.bottom + k360Width(13),kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];

}

- (void)showCellByItem:(WY_ExamListModel*)withWY_ExamListModel
{
    self.lblTitle.text = withWY_ExamListModel.title;
    self.lblDate.text = [NSString stringWithFormat:@"考试时间：%@",withWY_ExamListModel.examStartTime];
    self.height = imgLine.bottom;
    //认证 都 改成了- 确认
    if ([withWY_ExamListModel.rzbs isEqualToString:@"1"]) {
        [self.btnRight setTitle:@"已确认" forState:UIControlStateNormal];
        [self.btnRight setUserInteractionEnabled:NO];
    } else {
        [self.btnRight setTitle:@"开始确认" forState:UIControlStateNormal];
        [self.btnRight setUserInteractionEnabled:YES];
     }
    
    [self.colSender setFrame:self.bounds];
}
@end
