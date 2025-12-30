//
//  WY_VideoItemTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_VideoItemTableViewCell.h"

@implementation WY_VideoItemTableViewCell



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
    self.imgContent = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(132))];
    [self.imgContent rounded:k360Width(44)/8];
    [self.contentView addSubview:_imgContent];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.imgContent.bottom + 10, self.imgContent.width, k360Width(22))];
    [self.lblTitle setFont: WY_FONTMedium(14)];
    [self.contentView addSubview:self.lblTitle];
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.lblTitle.bottom + 10, self.imgContent.width, k360Width(22))];
    [self.lblDate setFont: WY_FONTRegular(14)];
    [self.lblDate setTextColor:HEXCOLOR(0x909090)];
    [self.contentView addSubview:self.lblDate];
    
    [self.contentView addSubview: self.colSender];
}

- (void)showCellByItem:(WY_InfomationModel*)withWY_InfomationModel {
    self.mWY_InfomationModel = withWY_InfomationModel;
    self.lblTitle.text = self.mWY_InfomationModel.title;
    if ([self.mWY_InfomationModel.isRead isEqualToString:@"1"]) {
        [self.lblTitle setTextColor:APPTextGayColor];
    } else {
        [self.lblTitle setTextColor:[UIColor blackColor]];
    }
    [self.imgContent sd_setImageWithURL:[NSURL URLWithString:[self.mWY_InfomationModel.imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    
    NSString *typeStr = [WY_WLTools categoryStringByNum:self.mWY_InfomationModel.categorynum];
    
     self.lblDate.text = [NSString stringWithFormat:@"%@    %@",typeStr,self.mWY_InfomationModel.infodate];
    self.height = self.lblDate.bottom + k360Width(10);
    [self.colSender setFrame:self.bounds];

}
@end
