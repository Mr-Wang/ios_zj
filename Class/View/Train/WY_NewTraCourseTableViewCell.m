//
//  WY_NewTraCourseTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_NewTraCourseTableViewCell.h"
#import "NSDate+Extension.h"

@implementation WY_NewTraCourseTableViewCell


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
//    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(88), k360Width(23))];
//    [self.lblTitle setFont:WY_FONTMedium(14)];
//    [self.lblTitle setText:@"报名开始时间"];
    
    self.imgContentBg = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), k360Width(80))];
    self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(self.imgContentBg.left + k360Width(7), self.imgContentBg.top + k360Width(7), self.imgContentBg.width - k360Width(14), k360Width(40))];
     [self.lblContent setFont:WY_FONTMedium(14)];
    [self.lblContent setNumberOfLines:2];
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(self.imgContentBg.left + k360Width(7), self.imgContentBg.bottom - k360Width(27), self.imgContentBg.width - k360Width(14), k360Width(20))];
    [self.lblDate setTextAlignment:NSTextAlignmentLeft];
    [self.lblDate setFont:WY_FONTMedium(12)];
    [self.lblDate setTextColor:[UIColor whiteColor]];

    
    self.lblLjbm = [[UILabel alloc] initWithFrame:CGRectMake(self.imgContentBg.left + k360Width(7), self.imgContentBg.bottom - k360Width(27), self.imgContentBg.width - k360Width(14), k360Width(20))];
    [self.lblLjbm setTextAlignment:NSTextAlignmentRight];
    [self.lblLjbm setFont:WY_FONTMedium(12)];

    self.imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(self.lblLjbm.right + k360Width(5), self.lblLjbm.top, k360Width(7), k360Width(10))];
    [self.imgAcc setImage:[UIImage imageNamed:@"0210_qianjin"]];
    self.imgAcc.centerY = self.imgContentBg.centerY;
    
 
    [self.contentView addSubview:self.imgContentBg];
    [self.contentView addSubview:self.lblTitle];
    [self.contentView addSubview:self.lblDate];
    [self.contentView addSubview:self.lblContent];
    [self.contentView addSubview:self.lblLjbm];
    [self.contentView addSubview:self.imgAcc];
    [self.contentView addSubview:self.colSender];
}

- (void)showCellByItem:(WY_TrainItemModel*)withWY_TrainItemModel withNum:(int)withNum{
    
     self.mWY_TrainItemModel = withWY_TrainItemModel;
    [self.imgContentBg setImage:[UIImage imageNamed:@"zxtz0"]];
    
    BOOL isFull = NO;
    if ([withWY_TrainItemModel.num intValue] >= [withWY_TrainItemModel.baomingnum intValue]) {
         isFull = YES;
    }
    
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
        [self.imgContentBg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"zxtz%d",withNum % 4 + 1]]];
         if (isFull) {
             [self.lblLjbm setText:@"报名已满"];
         } else {
                [self.lblLjbm setText:@"报名截止"];
         }
        [self.lblContent setTextColor:[UIColor blackColor]];
        [self.lblLjbm setTextColor:APPTextGayColor];
         [self.lblDate setTextColor:APPTextGayColor];
     } else {
        [self.lblDate setTextColor:[UIColor whiteColor]];
        [self.lblLjbm setTextColor:HEXCOLOR(0xBCD79D)];
        [self.lblLjbm setText:@"正在报名"];
        [self.lblContent setTextColor:[UIColor whiteColor]];
        [self.imgContentBg setImage:[UIImage imageNamed:@"zxtz0"]];
    }
    
    if (self.mWY_TrainItemModel.coursestarttime.length > 19) {
            self.lblDate.text = [NSString stringWithFormat:@"开课时间：%@",[self.mWY_TrainItemModel.coursestarttime  substringToIndex:19]];
    } else {
        self.lblDate.text = [NSString stringWithFormat:@"开课时间：%@" ,self.mWY_TrainItemModel.coursestarttime];
    }
    self.lblContent.text = self.mWY_TrainItemModel.Title;
    
//    self.mWY_TrainItemModel.Title = @"（第一期）电子化评标技能提升——辽宁省工程建设项目数字化开标评标系统（农业农村工程）实操讲解";
//    NSRange rangeTemp =  NSMakeRange(0,0);
//    for (int i = 0 ; i < 1000; i ++) {
//        rangeTemp = [self.mWY_TrainItemModel.Title rangeOfString:[NSString stringWithFormat:@"%d期",i]];
//        if (rangeTemp.length > 0) {
//            break;
//        }
//    }
//    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:self.mWY_TrainItemModel.Title];
//    [strAtt yy_setColor:HEXCOLOR(0xFFA422) range:rangeTemp];
//    [strAtt yy_setFont:WY_FONTMedium(14) range:rangeTemp];
//
//    [self.lblContent setAttributedText:strAtt];
    
     self.height = self.imgContentBg.bottom;
    [self.colSender setFrame:self.bounds];
}

@end
