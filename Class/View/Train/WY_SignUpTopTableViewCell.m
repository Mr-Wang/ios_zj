//
//  WY_SignUpTopTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SignUpTopTableViewCell.h"

@implementation WY_SignUpTopTableViewCell
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
    self.imgCourse = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(113), k360Width(67))];
      
    self.lblTitle = [[YYLabel alloc] initWithFrame:CGRectMake(self.imgCourse.right + k360Width(16), self.imgCourse.top,kScreenWidth - (self.imgCourse.right + k360Width(32)), k360Width(67))];
    [self.lblTitle setFont:WY_FONTRegular(14)];
    [self.lblTitle setTextVerticalAlignment:YYTextVerticalAlignmentTop];
    [self.lblTitle setNumberOfLines:4];
    self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom + k360Width(3), k360Width(100), k360Width(18))];
    [self.lblPrice setFont:WY_FONTRegular(14)];
    [self.lblPrice setTextColor:HEXCOLOR(0xD94C5A)];
    
    self.lblIsPay = [[UILabel alloc] initWithFrame:CGRectMake(self.lblPrice.left, self.lblPrice.top, k360Width(32), k360Width(14))];
    [self.lblIsPay setFont:WY_FONTRegular(10)];
    [self.lblIsPay setTextAlignment:NSTextAlignmentCenter];
    [self.lblIsPay rounded:k360Width(14/8)];

    
    self.lblCount = [[UILabel alloc] initWithFrame:CGRectMake( self.lblIsPay.left, self.lblIsPay.bottom + k360Width(5), k360Width(100), k360Width(15))];
    [self.lblCount setTextAlignment: NSTextAlignmentLeft];
    [self.lblCount setTextColor:HEXCOLOR(0x7F7F7F)];
    [self.lblCount setFont:WY_FONTRegular(12)];

    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.lblIsPay.bottom + k360Width(16),kScreenWidth - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
//    [self.contentView addSubview:imgLine];

    
    [self.contentView addSubview:self.imgCourse];
    [self.contentView addSubview:self.lblIsPay];
    [self.contentView addSubview:self.lblTitle];
    [self.contentView addSubview:self.lblPrice];
//    [self.contentView addSubview:self.lblCount];
    [self.contentView addSubview:self.colSender];
}

- (void)showCellByItem:(WY_TraCourseDetailModel*)withWY_TraCourseDetailModel
{
    self.mWY_TraCourseDetailModel = withWY_TraCourseDetailModel;
    if ([self.mWY_TraCourseDetailModel.tpurl rangeOfString:@"https://"].length <= 0 && [self.mWY_TraCourseDetailModel.tpurl rangeOfString:@"http://"].length <= 0) {
        [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://www.lnwlzb.com:8086/EpointFrame/%@",self.mWY_TraCourseDetailModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];
    } else {
        [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TraCourseDetailModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];

    }
     self.lblTitle.text = self.mWY_TraCourseDetailModel.Title;
       self.lblPrice.text = [NSString stringWithFormat:@"￥%@",self.mWY_TraCourseDetailModel.Price];
    [self.lblPrice setTextColor:HEXCOLOR(0xD94C5A)];
    [self.lblPrice setHidden:NO];
    [self.lblIsPay setHidden:YES];

    //隐藏掉付费内容；
      [self.lblPrice setHidden:YES];
    [self.lblIsPay setHidden:YES];
    
    self.height = imgLine.bottom;
    [self.colSender setFrame:self.bounds];
}
@end
