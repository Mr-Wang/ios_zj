//
//  WY_MyCreditTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/22.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyCreditTableViewCell.h"

@implementation WY_MyCreditTableViewCell
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
    self.imgInvoiceType = [UIImageView new];
    self.lblContent = [UILabel new];
    self.lblContent1 = [UILabel new];
    self.lblName = [UILabel new];
    self.lblData = [UILabel new];
    self.lbl4 = [UILabel new];
    self.lbl41 = [UILabel new];
    
    [self.imgInvoiceType setFrame:CGRectMake(k360Width(16), k360Width(36), k360Width(37), k360Width(37))];
    [self.lblName setFrame:CGRectMake(self.imgInvoiceType.right + k360Width(16), k360Width(10), kScreenWidth - self.imgInvoiceType.right, k360Width(22))];
    [self.lblContent setFrame:CGRectMake(self.imgInvoiceType.right +k360Width(16), self.lblName.bottom + k360Width(5), kScreenWidth - self.imgInvoiceType.right, k360Width(22))];
    
    [self.lblContent1 setFrame:CGRectMake(k360Width(145), self.lblName.bottom + k360Width(7), kScreenWidth - k360Width(145), k360Width(22))];
 

//    [self.lblContent setNumberOfLines:2];
//    [self.lblContent setTextAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:self.lblName];
    [self.contentView addSubview:self.lblData];
    [self.contentView addSubview:self.lblContent];
    [self.contentView addSubview:self.lblContent1];
    [self.contentView addSubview:self.imgInvoiceType];
    [self.contentView addSubview:self.lbl4];
    [self.contentView addSubview:self.lbl41];
    imgLine = [UIImageView new];
    [self.contentView addSubview:imgLine];
    
}
- (void)showCellByItem:(WY_CreditItemModel *)withWY_CreditItemModel {
    self.mWY_CreditItemModel = withWY_CreditItemModel;
    self.lblName.text = [NSString stringWithFormat:@"项目状态：%@",self.mWY_CreditItemModel.processName];//self.mWY_CreditItemModel.processName;
    self.lblData.text = [NSString stringWithFormat:@"评标时间：%@",[self.mWY_CreditItemModel.evaluationTime  substringToIndex:10]];//;
    self.lblContent.text = @"项目名称：";//self.mWY_CreditItemModel.tenderProjectName;
    
    self.lblContent1.text = self.mWY_CreditItemModel.tenderProjectName;
    [self.lblContent1 setNumberOfLines:0];
    [self.lblContent1 sizeToFit];
    [self.lblData setFrame:CGRectMake(self.imgInvoiceType.right +k360Width(16), self.lblContent1.bottom + k360Width(5), kScreenWidth - self.imgInvoiceType.right, k360Width(22))];
    [self.lbl4 setFrame:CGRectMake(self.imgInvoiceType.right +k360Width(16), self.lblData.bottom + k360Width(5), kScreenWidth - self.imgInvoiceType.right, k360Width(22))];
    [self.lbl41 setFrame:CGRectMake(k360Width(145), self.lblData.bottom + k360Width(7), kScreenWidth - k360Width(145), k360Width(22))];

    self.lbl4.text = @"代理机构：";
    self.lbl41.text = self.mWY_CreditItemModel.agencyName;
    [self.lbl41 setNumberOfLines:0];
    [self.lbl41 sizeToFit];
     //1旷评、2请假、3迟到、4违法、5替补
    switch ([self.mWY_CreditItemModel.processState intValue]) {
            case 0:
                   {
                       [self.imgInvoiceType setImage:[UIImage imageNamed:@"0703_zc"]];

                   }
            break;
        case 1:
        {
            [self.imgInvoiceType setImage:[UIImage imageNamed:@"0703_kp"]];

        }
            break;
              case 2:
                 {
                     [self.imgInvoiceType setImage:[UIImage imageNamed:@"0703_qj"]];

                 }
                     break;
              case 3:
                 {
                     [self.imgInvoiceType setImage:[UIImage imageNamed:@"0703_cd"]];

                 }
                     break;
              case 4:
                 {
                     [self.imgInvoiceType setImage:[UIImage imageNamed:@"0703_wg"]];

                 }
                     break;
              case 5:
                 {
                     [self.imgInvoiceType setImage:[UIImage imageNamed:@"0703_tb"]];

                 }
                     break;
            
        default:
            break;
    }
    self.height =   self.lbl41.bottom + k360Width(10); //k360Width(75);
    
    [imgLine setFrame:CGRectMake(0, self.height, kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
}

@end
