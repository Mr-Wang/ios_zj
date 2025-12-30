//
//  WY_OTDMessageTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OTDMessageTableViewCell.h"

@implementation WY_OTDMessageTableViewCell {
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
 
    self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16),  k360Width(16),kScreenWidth - k360Width(100), k360Width(22))];
    [self.lblName setFont:WY_FONTRegular(14)];
    [self.lblName setTextColor:APPTextGayColor];
    
     self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lblName.top, kScreenWidth - k360Width(16), k360Width(22))];
    [self.lblDate setTextAlignment:NSTextAlignmentRight];
    [self.lblDate setFont:WY_FONTRegular(14)];
     [self.lblDate setTextColor:APPTextGayColor];
    
    self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(self.lblName.left, self.lblName.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(14))];
    [self.lblContent setFont:WY_FONTRegular(10)];
 [self.lblContent setFont:WY_FONTMedium(14)];
  [self.lblContent setTextColor:[UIColor blackColor]];

    
 
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.lblContent.bottom + k360Width(16),kScreenWidth - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];

    
    [self.contentView addSubview:self.lblName];
    [self.contentView addSubview:self.lblDate];
    [self.contentView addSubview:self.lblContent];
    [self.contentView addSubview:self.colSender];
}

- (void)showCellByItem:(WY_GuestBookModel*)withModel
{
    self.mWY_GuestBookModel = withModel;
    NSString *uctimeStr = [self.mWY_GuestBookModel.userCreateTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    uctimeStr = [uctimeStr substringToIndex:8];
    uctimeStr = [uctimeStr substringFromIndex:4];
    NSString *phoneStr = [self.mWY_GuestBookModel.phone substringFromIndex:7];
    NSString *nameStr = [NSString stringWithFormat:@"WL%@%@",uctimeStr,phoneStr];
    
     self.lblName.text = nameStr;
    self.lblDate.text = self.mWY_GuestBookModel.createtime;
    self.lblContent.text = self.mWY_GuestBookModel.content;
    [self.lblContent setFrame:CGRectMake(self.lblName.left, self.lblName.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(14))];
    
    [self.lblContent setNumberOfLines:0];
    [self.lblContent setLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.lblContent sizeToFit];
    
    [imgLine setFrame:CGRectMake(k360Width(16),self.lblContent.bottom + k360Width(16),kScreenWidth - k360Width(32), 1)];

    self.height = imgLine.bottom;
    [self.colSender setFrame:self.bounds];
}
@end
