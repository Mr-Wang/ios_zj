//
//  WY_MyVipTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyVipTableViewCell.h"

@implementation WY_MyVipTableViewCell


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
     self.openVip = [UIView new];
    [self.contentView addSubview:self.openVip];
}

- (void)showVipViewByVipModel:(WY_VipInfoModel *)withWY_VipInfoModel {
    [self.openVip removeAllSubviews];
//0 未开通 1 开通；
    if ([withWY_VipInfoModel.isOpen isEqualToString:@"0"]) {
        [self.openVip setFrame:CGRectMake(k360Width(12), 0 , kScreenWidth - k360Width(24), k360Width(44))];
        UIImageView *imgBg = [UIImageView new];
        [imgBg setFrame:self.openVip.bounds];
        [imgBg setImage:[UIImage imageNamed:@"0520_vipinBg"]];
        [self.openVip addSubview:imgBg];
        
        UIImageView *imgIcon1 = [UIImageView new];
        [imgIcon1 setFrame:CGRectMake(k360Width(16), 0, k360Width(25), k360Width(22))];
        [imgIcon1 setImage:[UIImage imageNamed:@"0520vipicon"]];
        [self.openVip addSubview:imgIcon1];
        
        UIImageView *imgIcon2 = [UIImageView new];
        [imgIcon2 setFrame:CGRectMake(imgIcon1.right + k360Width(5), 0, k360Width(49), k360Width(14))];
        [imgIcon2 setImage:[UIImage imageNamed:@"0520vipicon1"]];
        [self.openVip addSubview:imgIcon2];
        
        UILabel *lblTitle = [UILabel new];
        [lblTitle setFrame:CGRectMake(imgIcon2.right + k360Width(24), 0, self.openVip.width, self.openVip.height)];
        [lblTitle setText:@"开通即享会员专属特权"];
        [lblTitle setFont:WY_FONTRegular(12)];

         [self.openVip addSubview:lblTitle];
        
        UIButton *btnOpen = [UIButton new];
        [btnOpen setFrame:CGRectMake(self.openVip.width - k360Width(66 + 10), k360Width(10), k360Width(66), k360Width(30))];
        [btnOpen setBackgroundImage:[UIImage imageNamed:@"0520_vipkt"] forState:UIControlStateNormal];
        [self.openVip addSubview:btnOpen];
        [btnOpen addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (self.openVipAction) {
                self.openVipAction();
            }
        }];
        imgIcon1.centerY = imgBg.centerY;
        imgIcon2.centerY = imgBg.centerY;
 
    } else {
        [self.openVip setFrame:CGRectMake(k360Width(12), 0 , kScreenWidth - k360Width(24), k360Width(205))];
        UIImageView *imgBg = [UIImageView new];
        [imgBg setFrame:self.openVip.bounds];
        [imgBg setImage:[UIImage imageNamed:@"0520myvipicon1"]];
        [self.openVip addSubview:imgBg];
        
        UIView *viewTop = [UIView new];
        [viewTop setFrame:CGRectMake(0, 0 , kScreenWidth - k360Width(40), k360Width(44))];
        [viewTop setBackgroundColor:[UIColor clearColor]];
        [self.openVip addSubview:viewTop];
        
               UIImageView *imgIcon1 = [UIImageView new];
               [imgIcon1 setFrame:CGRectMake(k360Width(16), 0, k360Width(81), k360Width(14))];
               [imgIcon1 setImage:[UIImage imageNamed:@"0520_vipIcon1"]];
               [viewTop addSubview:imgIcon1];
 
               UILabel *lblTitle = [UILabel new];
               [lblTitle setFrame:CGRectMake(imgIcon1.right + k360Width(24), 0, self.openVip.width, viewTop.height)];
               [lblTitle setText:withWY_VipInfoModel.dateStr];
        [lblTitle setFont:WY_FONTRegular(12)];
                [viewTop addSubview:lblTitle];
               
               UIButton *btnOpen = [UIButton new];
               [btnOpen setFrame:CGRectMake(viewTop.width - k360Width(66 + 10), k360Width(10), k360Width(66), k360Width(30))];
               [btnOpen setBackgroundImage:[UIImage imageNamed:@"0520_vipxf"] forState:UIControlStateNormal];
               [viewTop addSubview:btnOpen];
        [btnOpen addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (self.openVipAction) {
                self.openVipAction();
            }
        }];
               imgIcon1.centerY = viewTop.centerY;
 
    }
    self.height = self.openVip.bottom;
 
    
} 
///给View设置阴影和圆角
- (void)viewShadowCorner:(UIView *)viewInfoTemp {
    viewInfoTemp.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
    viewInfoTemp.layer.shadowOffset = CGSizeMake(5, 5);
    viewInfoTemp.layer.shadowOpacity = 1;
    viewInfoTemp.layer.shadowRadius = 9.0;
    viewInfoTemp.layer.cornerRadius = k360Width(44) / 8;
    [viewInfoTemp setBackgroundColor:[UIColor whiteColor]];
    viewInfoTemp.clipsToBounds = NO;
}
@end
