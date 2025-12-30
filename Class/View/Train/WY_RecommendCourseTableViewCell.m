//
//  WY_RecommendCourseTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_RecommendCourseTableViewCell.h"

@implementation WY_RecommendCourseTableViewCell
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
    self.imgCourse = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(113), k360Width(67))];
     
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.imgCourse.right + k360Width(16), self.imgCourse.top,kScreenWidth - (self.imgCourse.right + k360Width(32)), k360Width(44))];
    [self.lblTitle setFont:WY_FONTRegular(14)];
    [self.lblTitle setNumberOfLines:2];
    
    self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom + k360Width(5), k360Width(100), k360Width(15))];
    [self.lblPrice setFont:WY_FONTRegular(12)];
    [self.lblPrice setTextColor:HEXCOLOR(0xD94C5A)];
    
    self.lblCount = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth -k360Width(216), self.lblPrice.top, k360Width(200), k360Width(15))];
    [self.lblCount setTextAlignment: NSTextAlignmentRight];
    [self.lblCount setTextColor:HEXCOLOR(0x7F7F7F)];
    [self.lblCount setFont:WY_FONTRegular(12)];

    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.lblCount.bottom + k360Width(16),kScreenWidth - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];

    
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
    [self.imgCourse rounded:k360Width(44)/8];
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
          self.lblPrice.text = @"免费";
           [self.lblPrice setTextColor:HEXCOLOR(0x5FA350)];
    } else {
          self.lblPrice.text = [NSString stringWithFormat:@"￥%@",self.mWY_TrainItemModel.Price];
        [self.lblPrice setTextColor:HEXCOLOR(0xD94C5A)];
     }
    
    //隐藏掉付费内容；
    [self.lblPrice setHidden:YES];
    
    self.height = imgLine.bottom;
    [self.colSender setFrame:self.bounds];
}



- (void)showZJHomeCellByItem:(WY_TrainItemModel*)withWY_TrainItemModel
{
    self.mWY_TrainItemModel = withWY_TrainItemModel;
    if ([self.mWY_TrainItemModel.Photo rangeOfString:@"https://"].length <= 0&& [self.mWY_TrainItemModel.Photo rangeOfString:@"http://"].length <= 0) {
        [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://www.lnwlzb.com:8086/EpointFrame/%@",self.mWY_TrainItemModel.Photo]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];
    } else {
        [self.imgCourse sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TrainItemModel.Photo]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];

    }
    [self.imgCourse rounded:k360Width(44)/8];
    self.lblTitle.text = self.mWY_TrainItemModel.Title;
    [self.lblTitle setFont:WY_FONTMedium(14)];
    
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
    
    UIImageView *userhead = [[UIImageView alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblCount.top, k360Width(10), k360Width(12))];
    [userhead setImage:[UIImage imageNamed:@"0818_userhead"]];
    [self.contentView addSubview:userhead];
    
    self.lblCount.left = userhead.right + k360Width(3);
    [self.lblCount setTextAlignment:NSTextAlignmentLeft];
    
    self.lblCount.attributedText = atStr;

    UILabel *lblwybm = [UILabel new];
    [lblwybm setFrame:CGRectMake(kScreenWidth - k360Width(72), self.lblCount.top, k360Width(62), k360Width(22))];
    [lblwybm setTextAlignment:NSTextAlignmentCenter];
    [lblwybm setFont:WY_FONTMedium(12)];
    [lblwybm rounded:k360Width(22/8)];
    [lblwybm setTextColor:[UIColor whiteColor]];
    [lblwybm setBackgroundColor:HEXCOLOR(0x89B5FF)];
    [self.contentView addSubview:lblwybm];
    lblwybm.centerY = self.lblCount.centerY;
    userhead.centerY = self.lblCount.centerY;
    self.height = imgLine.bottom;
    [self.colSender setFrame:self.bounds];
     
    
        NSString *coursestarttimeStr = @"";
        if (self.mWY_TrainItemModel.liveEndTime.length > 19) {
            coursestarttimeStr = [self.mWY_TrainItemModel.liveEndTime  substringToIndex:19];
        }else {
            coursestarttimeStr = self.mWY_TrainItemModel.liveEndTime;
        }
        // 指定的时间
        NSDate *coursestartDate = [NSDate dateWithString:coursestarttimeStr format:@"yyyy-MM-dd HH:mm:ss" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        // 判断是否大于此事件，这里是拿当前时间和指定的时间判断
        BOOL isAday = [NSDate date].timeIntervalSince1970 - coursestartDate.timeIntervalSince1970 >= 0;
        if (isAday || isFull) {
             if (isFull) {
                [lblwybm setText:@"报名已满"];
            } else {
                   [lblwybm setText:@"报名截止"];
            }
         } else {
            [lblwybm setText:@"我要报名"];
        }
}
@end
