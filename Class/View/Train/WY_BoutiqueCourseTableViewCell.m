//
//  WY_BoutiqueCourseTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_BoutiqueCourseTableViewCell.h"

@implementation WY_BoutiqueCourseTableViewCell


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
    self.imgCourse = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, k375Width(160), k375Width(90))];
    self.lblIsPay = [[UILabel alloc] initWithFrame:CGRectMake(self.imgCourse.left, self.imgCourse.bottom + k375Width(10), k375Width(32), k375Width(14))];
    [self.lblIsPay setFont:WY_FONTRegular(10)];
    [self.lblIsPay setTextAlignment:NSTextAlignmentCenter];
    [self.lblIsPay rounded:k375Width(14/8)];
    
//    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.lblIsPay.right + k360Width(5), self.lblIsPay.top, k360Width(119), k360Width(17))];
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(5), self.lblIsPay.top, self.width - k375Width(10), k375Width(17))];

    [self.lblTitle setFont:WY_FONTRegular(14)];
    self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.lblIsPay.left, self.lblIsPay.bottom + k375Width(5), k375Width(100), k375Width(15))];
    [self.lblPrice setFont:[UIFont systemFontOfSize:k375Width(12)]];
    [self.lblPrice setTextColor:HEXCOLOR(0xD94C5A)];
    
    self.lblCount = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lblPrice.top, self.imgCourse.width, k375Width(15))];
    [self.lblCount setTextAlignment: NSTextAlignmentRight];
    [self.lblCount setTextColor:HEXCOLOR(0x7F7F7F)];
    [self.lblCount setFont:[UIFont systemFontOfSize:k375Width(12)]];

    [self.contentView addSubview:self.imgCourse];
    [self.contentView addSubview:self.lblIsPay];
    [self.contentView addSubview:self.lblTitle];
    [self.contentView addSubview:self.lblPrice];
    [self.contentView addSubview:self.lblCount];
    [self.contentView addSubview:self.colSender];
}

- (void)showCellByItem:(WY_TrainItemModel*)withWY_TrainItemModel
{
    self.mWY_TrainItemModel = withWY_TrainItemModel;
    if ([self.mWY_TrainItemModel.Photo rangeOfString:@"https://"].length <= 0&& [self.mWY_TrainItemModel.Photo rangeOfString:@"http://"].length <= 0) {
        [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://www.lnwlzb.com:8086/EpointFrame/%@",self.mWY_TrainItemModel.Photo]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];
    } else {
        [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TrainItemModel.Photo]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];

    }
    [self.imgCourse rounded:k375Width(44)/8];
    self.lblTitle.text = self.mWY_TrainItemModel.Title;
    self.lblPrice.text = [NSString stringWithFormat:@"￥%@",self.mWY_TrainItemModel.Price];
    
    //隐藏掉付费内容；
    [self.lblPrice setHidden:YES];
    
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
        [self.lblIsPay setBackgroundColor:HEXCOLOR(0xCDF3C4)];
        [self.lblIsPay setTextColor:HEXCOLOR(0x5FA350)];
        self.lblIsPay.text = @"免费";
        [self.lblPrice setHidden:YES];
    } else {
        self.lblIsPay.text = @"收费";
        [self.lblIsPay setBackgroundColor:HEXCOLOR(0xE3D2B7)];
        [self.lblIsPay setTextColor:HEXCOLOR(0xC3913D)];
        [self.lblPrice setHidden:NO];
    }
    //隐藏掉付费内容；
         [self.lblPrice setHidden:YES];
       [self.lblIsPay setHidden:YES];
    self.height = self.lblCount.bottom;
    [self.colSender setFrame:self.bounds];
}
@end
