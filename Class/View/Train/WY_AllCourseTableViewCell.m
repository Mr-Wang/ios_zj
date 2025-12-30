//
//  WY_AllCourseTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AllCourseTableViewCell.h"

@implementation WY_AllCourseTableViewCell
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
    self.imgCourse = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(132), k360Width(80))];
     
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.imgCourse.right + k360Width(16), self.imgCourse.top,kScreenWidth - (self.imgCourse.right + k360Width(32)), k360Width(40))];
    [self.lblTitle setFont:WY_FONTRegular(14)];
    [self.lblTitle setNumberOfLines:2];
    self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom + k360Width(5), k360Width(100), k360Width(15))];
    [self.lblPrice setFont:WY_FONTRegular(12)];
    [self.lblPrice setTextColor:HEXCOLOR(0xD94C5A)];
    
    self.lblIsPay = [[UILabel alloc] initWithFrame:CGRectMake(self.lblPrice.left, self.lblPrice.top, k360Width(32), k360Width(14))];
    [self.lblIsPay setFont:WY_FONTRegular(10)];
    [self.lblIsPay setTextAlignment:NSTextAlignmentCenter];
    [self.lblIsPay rounded:k360Width(14/8)];

    
    self.lblCount = [[UILabel alloc] initWithFrame:CGRectMake( self.lblIsPay.left, self.lblIsPay.bottom + k360Width(5), k360Width(200), k360Width(15))];
    [self.lblCount setTextAlignment: NSTextAlignmentLeft];
    [self.lblCount setTextColor:HEXCOLOR(0x7F7F7F)];
    [self.lblCount setFont:WY_FONTRegular(12)];

    self.btnPj = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(100), self.lblCount.bottom + k360Width(16), k360Width(84), k360Width(35))];
    [self.btnPj rounded:10];
    [self.btnPj setBackgroundColor:MSTHEMEColor];
    [self.btnPj.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnPj setHidden:YES];
    
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.lblCount.bottom + k360Width(16),kScreenWidth - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];

    
    [self.contentView addSubview:self.imgCourse];
    [self.contentView addSubview:self.lblIsPay];
    [self.contentView addSubview:self.lblTitle];
    [self.contentView addSubview:self.lblPrice];
    [self.contentView addSubview:self.lblCount];
    [self.contentView addSubview:self.colSender];
    [self.contentView addSubview:self.btnPj];

}

- (void)showCellByItem:(WY_TrainItemModel*)withWY_TrainItemModel
{
    self.mWY_TrainItemModel = withWY_TrainItemModel;
    if ([self.mWY_TrainItemModel.tpurl isNotBlank]) {
            if ([self.mWY_TrainItemModel.tpurl rangeOfString:@"https://"].length <= 0&& [self.mWY_TrainItemModel.tpurl rangeOfString:@"http://"].length <= 0) {
            [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://www.lnwlzb.com:8086/EpointFrame/%@",self.mWY_TrainItemModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];
        } else {
            [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TrainItemModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];

        }

    } else {
        if ([self.mWY_TrainItemModel.Photo rangeOfString:@"https://"].length <= 0&& [self.mWY_TrainItemModel.Photo rangeOfString:@"http://"].length <= 0) {
        [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://www.lnwlzb.com:8086/EpointFrame/%@",self.mWY_TrainItemModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];
    } else {
        [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TrainItemModel.Photo]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];

    }
        
        
 
    }
    self.lblTitle.text = self.mWY_TrainItemModel.Title;
    int currentNum = [self.mWY_TrainItemModel.num intValue];
    BOOL isFull = NO;
    if ([self.mWY_TrainItemModel.num intValue] >= [self.mWY_TrainItemModel.baomingnum intValue]) {
        currentNum = [self.mWY_TrainItemModel.baomingnum intValue];
        isFull = YES;
    }
    NSMutableAttributedString *atStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d人报名",currentNum]];
    if (isFull) {
        NSMutableAttributedString *atStrA = [[NSMutableAttributedString alloc] initWithString:@"(已满)"];
        [atStrA setYy_color:[UIColor redColor]];
        [atStr appendAttributedString:atStrA];
    }
    self.lblCount.attributedText = atStr;
    //判断是否免费
    if ([self.mWY_TrainItemModel.isfree isEqualToString:@"1"]) {
          self.lblIsPay.text = @"免费";
        [self.lblIsPay setBackgroundColor:HEXCOLOR(0xCDF3C4)];
        [self.lblIsPay setTextColor:HEXCOLOR(0x5FA350)];
        [self.lblPrice setHidden:YES];

    } else {
          self.lblPrice.text = [NSString stringWithFormat:@"￥%@",self.mWY_TrainItemModel.Price];
        [self.lblPrice setTextColor:HEXCOLOR(0xD94C5A)];
        [self.lblPrice setHidden:NO];
        [self.lblIsPay setHidden:YES];
     }
    //隐藏掉付费内容；
      [self.lblPrice setHidden:YES];
    [self.lblIsPay setHidden:YES];
    self.height = imgLine.bottom;
    [self.colSender setFrame:self.bounds];
}


- (void)showMyCourseCellByItem:(WY_TrainItemModel*)withWY_TrainItemModel
{
    self.mWY_TrainItemModel = withWY_TrainItemModel;
    if (self.mWY_TrainItemModel.tpurl) {
            if ([self.mWY_TrainItemModel.tpurl rangeOfString:@"https://"].length <= 0&& [self.mWY_TrainItemModel.tpurl rangeOfString:@"http://"].length <= 0) {
            [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://www.lnwlzb.com:8086/EpointFrame/%@",self.mWY_TrainItemModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];
        } else {
            [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TrainItemModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];

        }

    } else {
        [self.imgCourse setImage:[UIImage imageNamed:@"0211_CourseDef"]];
        
    }
    self.lblTitle.text = self.mWY_TrainItemModel.Title;
    
    NSString *baomingNumStr = self.mWY_TrainItemModel.alreadybaomingnum;
       if ([self.mWY_TrainItemModel.alreadybaomingnum intValue] >= [self.mWY_TrainItemModel.baomingnum intValue]) {
           baomingNumStr = self.mWY_TrainItemModel.baomingnum;
       }
    
    self.lblCount.text = [NSString stringWithFormat:@"报名人数：%@",baomingNumStr];
    [self.lblPrice setHidden:YES];
    [self.lblIsPay setHidden:YES];
    
    [self.lblPrice setHidden:NO];

    NSString *coursestarttimeStr = self.mWY_TrainItemModel.coursestarttime;
    if (self.mWY_TrainItemModel.coursestarttime.length > 19) {
        coursestarttimeStr = [self.mWY_TrainItemModel.coursestarttime  substringToIndex:19];
     }
    self.lblPrice.width = kScreenWidth;
//    [self.lblPrice setTextColor:HEXCOLOR(0x7F7F7F)];

    self.lblPrice.text = [NSString stringWithFormat:@"开课时间：%@",coursestarttimeStr];
    
    if ([self.mWY_TrainItemModel.isshowpl isEqualToString:@"1"]) {
        [self.btnPj setHidden:NO];
        if ([self.mWY_TrainItemModel.ispl isEqualToString:@"1"]) {
            [self.btnPj setTitle:@"查看评价" forState:UIControlStateNormal];
        } else {
            [self.btnPj setTitle:@"添加评价" forState:UIControlStateNormal];
        }
        imgLine.top = self.btnPj.bottom + k360Width(16);
    } else {
        [self.btnPj setHidden:YES];
        imgLine.top = self.lblCount.bottom + k360Width(16);
    }
    
    self.height = imgLine.bottom;
    [self.colSender setFrame:self.bounds];
}
@end
