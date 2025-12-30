//
//  WY_VDListTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/8.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_VDListTableViewCell.h"

@implementation WY_VDListTableViewCell
{
    UIImageView *imgLine;
    UIImageView *imgNum;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self makeUI];
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
 
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(10), kScreenWidth - k360Width(32), k360Width(22))];
    [self.lblTitle setFont: WY_FONTMedium(14)];
    [self.contentView addSubview:self.lblTitle];
    
    self.lblDate = [[UILabel alloc] init];
    [self.lblDate setFont: WY_FONTRegular(12)];
    [self.lblDate setTextAlignment:NSTextAlignmentRight];
    [self.lblDate setTextColor:HEXCOLOR(0x909090)];
    [self.contentView addSubview:self.lblDate];
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.lblDate.bottom + k360Width(16),kScreenWidth - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];
    
    imgNum = [UIImageView new];
    [imgNum setHidden:YES];
    [self.contentView addSubview:imgNum];
 }

- (void)showCellByItem:(WY_InfomationModel*)withWY_InfomationModel withInt:(NSInteger)withInt{
    
    self.mWY_InfomationModel = withWY_InfomationModel;
    self.lblTitle.text = self.mWY_InfomationModel.title;
    [imgNum setFrame:CGRectMake(k360Width(16), 0, k360Width(44), k360Width(28))];
    [imgNum setHidden:NO];
    [imgNum setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0507_%02ld",withInt + 1]]];

    [self.lblTitle setFrame:CGRectMake( imgNum.right + k360Width(10), k360Width(10), kScreenWidth - imgNum.right - k360Width(32), k360Width(44))];
    [self.lblTitle setNumberOfLines:0];
    [self.lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
    
    
    [self.lblTitle setFont: [UIFont fontWithName:@"STHeitiSC-Medium" size:k360Width(14)]]; 
    [self.lblTitle sizeToFit];
    
    imgNum.top = self.lblTitle.bottom - k360Width(10);
    
    self.lblDate.text = [NSString stringWithFormat:@"%@   %@",withWY_InfomationModel.author,withWY_InfomationModel.videotime];
    [self.lblDate setFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom + k360Width(5), kScreenWidth - imgNum.right - k360Width(32), k360Width(22))];
     [self.lblDate setHidden:NO];
    [self.lblDate setTextAlignment:NSTextAlignmentLeft];
    [self.lblTitle setTextColor:APPTextGayColor];

    //当前播放
    if ([withWY_InfomationModel.isPlay isEqualToString:@"1"]) {
        [self.lblTitle setTextColor:HEXCOLOR(0xD34B4C)];
    } else {
        [self.lblTitle setTextColor:[UIColor blackColor]];
    }
    self.height = self.lblDate.bottom + k360Width(10);
    
    
    imgLine.top = self.height - 1;
}

-(void)showOrgIntegralCellByItem:(WY_PersonalScoreModel*)withWY_PersonalScoreModel {
    self.mWY_PersonalScoreModel = withWY_PersonalScoreModel;
    self.lblTitle.text = self.mWY_PersonalScoreModel.Realname;
    int lblDateWidth = k360Width(88);
    
     [self.lblTitle setFrame:CGRectMake(k360Width(32), k360Width(16), kScreenWidth - lblDateWidth - k360Width(32), k360Width(44))];
    [self.lblTitle setFont: WY_FONTMedium(14)];

     [self.lblTitle setNumberOfLines:0];
     [self.lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
     [self.lblTitle sizeToFit];
     self.lblDate.text = self.mWY_PersonalScoreModel.score;
     [self.lblDate setFrame:CGRectMake(kScreenWidth - lblDateWidth - k360Width(32), 0, lblDateWidth, k360Width(22))];
    [self.lblDate setFont: WY_FONTMedium(14)];
    [self.lblDate setTextColor:[UIColor blackColor]];
     self.lblDate.centerY = self.lblTitle.centerY;
     [self.lblDate setHidden:NO];
     [self.lblTitle setTextColor:[UIColor blackColor]];

    self.height = self.lblTitle.bottom + k360Width(16);
    imgLine.top = self.height - 1;

}
@end
