//
//  WY_CompleteStatusTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_CompleteStatusTableViewCell.h"

@implementation WY_CompleteStatusTableViewCell

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
    [self setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    self.colSender = [[UIControl alloc] init];
    self.viewCont = [UIView new];
    [self.viewCont setFrame:CGRectMake(k360Width(0), k360Width(0), kScreenWidth, k360Width(40))];
    [self.viewCont setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.viewCont];
    self.img1 = [UIImageView new];
    self.img2 = [UIImageView new];
    self.img3 = [UIImageView new];
    
    [self.viewCont addSubview:self.img1];
    [self.viewCont addSubview:self.img2];
    [self.viewCont addSubview:self.img3];
    self.imgLine = [UIImageView new];
    [self.viewCont addSubview:self.imgLine];
    
    [self.img1 setFrame:CGRectMake(k375Width(12), k375Width(14), k375Width(25), k375Width(25))];
    [self.img2 setFrame:CGRectMake(k375Width(12),self.img1.bottom + k375Width(16), k375Width(14), k375Width(14))];
    [self.img3 setFrame:CGRectMake(k375Width(12),self.img2.bottom + k375Width(16), k375Width(14), k375Width(14))];

    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.img1.right + k375Width(10), 0, self.viewCont.width - k360Width(16), k360Width(34))];
    self.lblTitle.centerY = self.img1.centerY;
    [self.lblTitle setFont:WY_FONTMedium(16)];
    [self.lblTitle setTextColor:HEXCOLOR(0x939393)];
     [self.viewCont addSubview:self.lblTitle];
    
    self.lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - k375Width(12), k360Width(24))];
    self.lblStatus.centerY = self.lblTitle.centerY;
    [self.lblStatus setFont:WY_FONTRegular(16)];
    [self.lblStatus setTextAlignment:NSTextAlignmentRight];
     [self.viewCont addSubview:self.lblStatus];
     
    
    self.lblLeft1 = [[UILabel alloc] initWithFrame:CGRectMake(self.img2.right + k375Width(10), 0, self.viewCont.width - k360Width(16), k360Width(34))];
    self.lblLeft1.centerY = self.img2.centerY;
    [self.lblLeft1 setFont:WY_FONTMedium(14)];
    [self.lblLeft1 setTextColor:HEXCOLOR(0x939393)];
     [self.viewCont addSubview:self.lblLeft1];
    
    self.lblRight1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - k375Width(12), k360Width(24))];
    self.lblRight1.centerY = self.lblLeft1.centerY;
    [self.lblRight1 setFont:WY_FONTRegular(14)];
    [self.lblRight1 setTextAlignment:NSTextAlignmentRight];
     [self.viewCont addSubview:self.lblRight1];
    
    self.lblLeft2 = [[UILabel alloc] initWithFrame:CGRectMake(self.img2.right + k375Width(10), 0, self.viewCont.width - k360Width(16), k360Width(34))];
       self.lblLeft2.centerY = self.img3.centerY;
       [self.lblLeft2 setFont:WY_FONTMedium(14)];
       [self.lblLeft2 setTextColor:HEXCOLOR(0x939393)];
        [self.viewCont addSubview:self.lblLeft2];
       
       self.lblRight2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - k375Width(12), k360Width(24))];
       self.lblRight2.centerY = self.lblLeft2.centerY;
       [self.lblRight2 setFont:WY_FONTRegular(14)];
       [self.lblRight2 setTextAlignment:NSTextAlignmentRight];
        [self.viewCont addSubview:self.lblRight2];
    self.lblshyy = [UILabel new];
    [self.lblshyy setFont:WY_FONTMedium(14)];
    [self.lblshyy setTextColor:HEXCOLOR(0x939393)];
    [self.viewCont addSubview:self.lblshyy];
}
- (void)showCellByItem:(WY_CompleteStatusModel *)withWY_CompleteStatusModel
{
    
    if ([withWY_CompleteStatusModel.source intValue] == 1) {
        self.lblTitle.text = @"综合专家完善信息";
    } else   if ([withWY_CompleteStatusModel.source intValue] == 2) {
        self.lblTitle.text = @"铁路专家完善信息";
    } else   if ([withWY_CompleteStatusModel.source intValue] == 3) {
        self.lblTitle.text = @"地铁专家完善信息";
    }
    if ([withWY_CompleteStatusModel.renewalFlag intValue] == 1) {
        self.lblTitle.text = @"续聘专家完善信息";
    }
    
    if ([self.nsType isEqualToString:@"2"]) {
        self.lblTitle.text = @"专家修改地区信息";
    }
    
    self.lblLeft1.text = @"提交时间";
    self.lblLeft2.text = @"审核时间";
//    self.lblStatus.text = withWY_CompleteStatusModel.approvalStatus;
    self.lblRight1.text = withWY_CompleteStatusModel.commintTime;
    self.lblRight2.text = withWY_CompleteStatusModel.approvalTime;

    [self.img1 setImage:[UIImage imageNamed:@"0628_updates"]];
    [self.img2 setImage:[UIImage imageNamed:@"0628_sj"]];
    [self.img3 setImage:[UIImage imageNamed:@"0628_sh"]];
    self.viewCont.height = self.img3.bottom + k375Width(10);
    self.height = self.viewCont.bottom;
    
    
    /*
       0   没完善过    可以完善；
       1   待核验 - 不可以完善；
       2   行业监管核验通过；不可以完善；
       3   市发改委核验通过；   不可以完善；
       4   省发改委核验通过；   不可以完善；
       5   资质不符        不可以完善；
       6   资料不全        可以完善；
       7  续聘的审核中
    */
    
    NSString *statusStr = @"";
    UIColor *statusColor =nil;
    switch ([withWY_CompleteStatusModel.approvalStatus intValue]) {
        case 1:
            case 2:
            case 3:
            case 7:
               {
                   statusStr = @"审核中";
                   statusColor = HEXCOLOR(0xFF8933);
               }
               break;
          case 4:
                 {
                     statusStr = @"审核通过";
                     statusColor = HEXCOLOR(0x00C38A);
                 }
                 break;
            case 5:
            {
                statusStr = @"资料不全";
                statusColor = HEXCOLOR(0x777676);
            }
            break;
            case 6:
            {
                statusStr = @"材料不足，审核失败";
                statusColor = HEXCOLOR(0x777676);
            }
            break;
        default:
        {
            statusStr = @"审核状态";
            statusColor = HEXCOLOR(0x00C38A);

        }
            break;
    }
    
    self.lblStatus.text = statusStr;
    self.lblStatus.textColor = statusColor;
    float lastY = 0;
    if ([statusStr isEqualToString:@"审核中"]) {
        [self.img3 setHidden:YES];
        [self.lblLeft2 setHidden:YES];
        [self.lblRight2 setHidden:YES];
        lastY = self.img2.bottom + k375Width(10);
    } else {
        [self.img3 setHidden:NO];
        [self.lblLeft2 setHidden:NO];
        [self.lblRight2 setHidden:NO];
        lastY = self.img3.bottom + k375Width(10);
    }
    
    [self.lblshyy setFrame:CGRectMake(self.img2.right + k375Width(10), lastY, kScreenWidth - self.img2.right - k360Width(20), k360Width(30))];
//    withWY_CompleteStatusModel.approvalContent = @"阿比US度啊闪电发货啊闪电发货啊闪电发货啊闪电发货啊闪电发货啊闪电发货";
    if (withWY_CompleteStatusModel.approvalContent.length > 0) {
        self.lblshyy.text = [NSString stringWithFormat:@"处理意见：%@",withWY_CompleteStatusModel.approvalContent];
    } else {
        self.lblshyy.text = @"处理意见：无";
    }
    [self.lblshyy setNumberOfLines:0];
    [self.lblshyy sizeToFit];
    self.viewCont.height = self.lblshyy.bottom + k375Width(10);
    self.height = self.viewCont.bottom;
    
    [self.imgLine setFrame:CGRectMake(0, self.viewCont.height - 1, kScreenWidth, 1)];
    [self.imgLine setBackgroundColor:APPLineColor];
}

- (void)showAddressCellByItem:(WY_CompleteStatusModel *)withWY_CompleteStatusModel
{
    self.lblTitle.text = [NSString stringWithFormat:@"专家管理属地变更 - %@",withWY_CompleteStatusModel.cityName];
    self.lblLeft1.text = @"提交时间";
    self.lblLeft2.text = @"审核时间";
//    self.lblStatus.text = withWY_CompleteStatusModel.approvalStatus;
    self.lblRight1.text = withWY_CompleteStatusModel.commitTime;
    self.lblRight2.text = withWY_CompleteStatusModel.approval;

    [self.img1 setImage:[UIImage imageNamed:@"0628_updates"]];
    [self.img2 setImage:[UIImage imageNamed:@"0628_sj"]];
    [self.img3 setImage:[UIImage imageNamed:@"0628_sh"]];
    self.viewCont.height = self.img3.bottom + k375Width(10);
    self.height = self.viewCont.bottom;
    
     
    NSString *statusStr = @"";
    UIColor *statusColor =nil;
//    6未通过   1原市级审核中  2新市级审核中  3省级审核中  4省级核验通过
    switch ([withWY_CompleteStatusModel.status intValue]) {
            case 1:
               {
                   statusStr = @"原市级审核中";
                   statusColor = HEXCOLOR(0xFF8933);
               }
               break;
        case 2:
           {
               statusStr = @"新市级审核中";
               statusColor = HEXCOLOR(0xFF8933);
           }
           break;
        case 3:
           {
               statusStr = @"省级审核中";
               statusColor = HEXCOLOR(0xFF8933);
           }
           break;
          case 4:
                 {
                     statusStr = @"审核通过";
                     statusColor = HEXCOLOR(0x00C38A);
                 }
                 break;
            case 6:
            {
                statusStr = @"审核拒绝";
                statusColor = HEXCOLOR(0x777676);
            }
            break;
        default:
        {
            statusStr = @"未知状态";
            statusColor = HEXCOLOR(0x00C38A);

        }
            break;
    }
    
    self.lblStatus.text = statusStr;
    self.lblStatus.textColor = statusColor;
    float lastY = 0;
    if ([statusStr isEqualToString:@"审核中"]) {
        [self.img3 setHidden:YES];
        [self.lblLeft2 setHidden:YES];
        [self.lblRight2 setHidden:YES];
        lastY = self.img2.bottom + k375Width(10);
    } else {
        [self.img3 setHidden:NO];
        [self.lblLeft2 setHidden:NO];
        [self.lblRight2 setHidden:NO];
        lastY = self.img3.bottom + k375Width(10);
    }
    
    [self.lblshyy setFrame:CGRectMake(self.img2.right + k375Width(10), lastY, kScreenWidth - self.img2.right - k360Width(20), k360Width(30))];
//    withWY_CompleteStatusModel.approvalContent = @"阿比US度啊闪电发货啊闪电发货啊闪电发货啊闪电发货啊闪电发货啊闪电发货";
    if (withWY_CompleteStatusModel.content.length > 0) {
        self.lblshyy.text = [NSString stringWithFormat:@"处理意见：%@",withWY_CompleteStatusModel.content];
    } else {
        self.lblshyy.text = @"处理意见：无";
    }
    [self.lblshyy setNumberOfLines:0];
    [self.lblshyy sizeToFit];
    self.viewCont.height = self.lblshyy.bottom + k375Width(10);
    self.height = self.viewCont.bottom;
    
    [self.imgLine setFrame:CGRectMake(0, self.viewCont.height - 1, kScreenWidth, 1)];
    [self.imgLine setBackgroundColor:APPLineColor];
}

- (void)showNNNewCellByItem:(WY_CompleteStatusModel *)withWY_CompleteStatusModel
{
    self.lblTitle.text = withWY_CompleteStatusModel.approvalTitle;
    
    self.lblLeft1.text = @"提交时间";
    self.lblLeft2.text = @"审核时间";
//    self.lblStatus.text = withWY_CompleteStatusModel.approvalStatus;
    self.lblRight1.text = withWY_CompleteStatusModel.commintTime;
    self.lblRight2.text = withWY_CompleteStatusModel.approvalTime;

    [self.img1 setImage:[UIImage imageNamed:@"0628_updates"]];
    [self.img2 setImage:[UIImage imageNamed:@"0628_sj"]];
    [self.img3 setImage:[UIImage imageNamed:@"0628_sh"]];
    self.viewCont.height = self.img3.bottom + k375Width(10);
    self.height = self.viewCont.bottom;
    
    
    /*
     当前状态：编辑中0、市级待核验1、省级待核验2、审核通过3、审核拒绝4
    */
    
    NSString *statusStr = @"";
    UIColor *statusColor =nil;
    switch ([withWY_CompleteStatusModel.approvalStatus intValue]) {
        case 0:
        {
            statusStr = @"编辑中";
            statusColor = HEXCOLOR(0xFF8933);
        }
        break;
            case 1:
           {
               statusStr = @"市级待核验";
               statusColor = HEXCOLOR(0xFF8933);
           }
           break;
            case 2:
               {
                   statusStr = @"省级待核验";
                   statusColor = HEXCOLOR(0xFF8933);
               }
               break;
          case 3:
                 {
                     statusStr = @"审核通过";
                     statusColor = HEXCOLOR(0x00C38A);
                 }
                 break;
            case 4:
            {
                statusStr = @"审核拒绝";
                statusColor = HEXCOLOR(0x777676);
            }
            break;
        default:
        {
            statusStr = @"审核状态";
            statusColor = HEXCOLOR(0x00C38A);

        }
            break;
    }
    
    self.lblStatus.text = statusStr;
    self.lblStatus.textColor = statusColor;
    float lastY = 0;
    if ([statusStr isEqualToString:@"审核中"]) {
        [self.img3 setHidden:YES];
        [self.lblLeft2 setHidden:YES];
        [self.lblRight2 setHidden:YES];
        lastY = self.img2.bottom + k375Width(10);
    } else {
        [self.img3 setHidden:NO];
        [self.lblLeft2 setHidden:NO];
        [self.lblRight2 setHidden:NO];
        lastY = self.img3.bottom + k375Width(10);
    }
    
    [self.lblshyy setFrame:CGRectMake(self.img2.right + k375Width(10), lastY, kScreenWidth - self.img2.right - k360Width(20), k360Width(30))];
     if (withWY_CompleteStatusModel.approvalContent.length > 0) {
        self.lblshyy.text = [NSString stringWithFormat:@"处理意见：%@",withWY_CompleteStatusModel.approvalContent];
    } else {
        self.lblshyy.text = @"处理意见：无";
    }
    [self.lblshyy setNumberOfLines:0];
    [self.lblshyy sizeToFit];
    self.viewCont.height = self.lblshyy.bottom + k375Width(10);
    self.height = self.viewCont.bottom;
    
    [self.imgLine setFrame:CGRectMake(0, self.viewCont.height - 1, kScreenWidth, 1)];
    [self.imgLine setBackgroundColor:APPLineColor];
}

@end
