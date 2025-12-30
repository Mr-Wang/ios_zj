//
//  WY_CAOrderTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_CAOrderTableViewCell.h"

@implementation WY_CAOrderTableViewCell


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
    [self.viewCont setFrame:CGRectMake(k360Width(12), k360Width(12), kScreenWidth - k360Width(24), k360Width(40))];
    [self.viewCont setBackgroundColor:[UIColor whiteColor]];
    [self.viewCont rounded:k360Width(40/8)];
    [self.contentView addSubview:self.viewCont];
    self.lblDate = [UILabel new];
    self.lblContent = [UILabel new];
    self.lblTitle = [UILabel new];
    self.btnShouHuo = [UIButton new];
    self.btnDel = [UIButton new];
    self.btnToDetai = [UIButton new];
    self.imgNew = [UIImageView new];
    
    [self.btnToDetai setUserInteractionEnabled:NO];
    
    [self.viewCont addSubview:self.lblDate];
    [self.viewCont addSubview:self.lblTitle];
    [self.viewCont addSubview:self.lblContent];
    [self.viewCont addSubview:self.btnShouHuo];
    [self.viewCont addSubview:self.btnToDetai];
    [self.viewCont addSubview:self.btnDel];
    self.imgukey = [UIImageView new];
    [self.imgukey setImage:[UIImage imageNamed:@"0323ukey"]];
    [self.viewCont addSubview:self.imgukey];
    [self.viewCont addSubview:self.imgNew];
    

    [self.btnShouHuo setHidden:YES];
    [self.btnDel setHidden:YES];
}
- (void)showCellByItem:(NSMutableDictionary *)withWY_CompleteStatusModel
{
    [self.imgNew setImage:[UIImage imageNamed:@"0330_new"]];
    [self.imgNew setFrame:CGRectMake(k360Width(16), k360Width(5), k360Width(20), k360Width(20))];
    [self.imgNew setHidden:YES];

    
    if (![withWY_CompleteStatusModel[@"isRead"] isEqual:[NSNull null]] && withWY_CompleteStatusModel[@"isRead"] != nil) {
        if ([withWY_CompleteStatusModel[@"isRead"] intValue] == 0) {
            [self.imgNew setHidden:NO];
        } else
        {
            [self.imgNew setHidden:YES];
        }
    }

    [self.lblDate setFrame:CGRectMake(0, k360Width(5), self.viewCont.width - k360Width(16), k360Width(30))];
    [self.lblDate setTextAlignment:NSTextAlignmentRight];
    [self.lblDate setText:withWY_CompleteStatusModel[@"createDate"]];
    [self.lblTitle setFrame:CGRectMake(k360Width(16), self.lblDate.bottom + k360Width(5), self.viewCont.width - k360Width(32), k360Width(30))];
    [self.lblTitle setText:withWY_CompleteStatusModel[@"sqjg"]];
    [self.lblTitle setTextColor:[UIColor blackColor]];
    [self.lblTitle setFont:WY_FONT375Medium(16)];
    [self.imgukey setFrame:CGRectMake(self.viewCont.width - k360Width(75+16), self.lblTitle.top, k360Width(75), k360Width(35))];

    [self.imgNew setCenterY:self.lblDate.centerY];
    
    [self.lblContent setFrame:CGRectMake(k360Width(16), self.lblTitle.bottom + k360Width(10), self.viewCont.width - k360Width(32), k360Width(30))];
    [self.lblContent setTextColor:HEXCOLOR(0x666666)];
    [self.lblContent setFont:WY_FONT375Medium(14)];

    
    NSString *lqfsStr = @"";
    //islingqu 1领取 2 邮寄
    if ([withWY_CompleteStatusModel[@"islingqu"] intValue] == 1) {
        lqfsStr = @"领取";
    } else {
        lqfsStr = @"邮寄（顺丰寄付）";
    }
    NSString *yxqStr = @"";
    if ([withWY_CompleteStatusModel[@"dqsj"] isEqual:[NSNull null]]) {
        yxqStr = @"有 效 期 ：自数字证书(CA)制作之日起一年内有效";
    } else {
        yxqStr = [NSString stringWithFormat:@"有效期至：%@",withWY_CompleteStatusModel[@"dqsj"]];
    }
    
    NSMutableAttributedString *attC1Str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金      额：%.2f元\n%@\n领取方式：%@\n订单状态：",[withWY_CompleteStatusModel[@"amountPrice"] floatValue],yxqStr,lqfsStr]];
    NSString *statusTitle = @"";
    UIColor *statusColor = HEXCOLOR(0xEA0000);
    //status  0待审核 、1 审核通过、2 审核未通过、
//    orderStatus  1待支付 、2已支付、3 已发货 4 已领取
    
    switch ([withWY_CompleteStatusModel[@"orderStatus"] intValue]) {
        case 1:
        {
            statusTitle = @"待支付";
            statusColor = HEXCOLOR(0xEA0000);
            
        }
            break;
        case 2:
        {
            // 1待支付 、2（邮寄-待发货）（领取-待领取）、3 已发货 4 已领取
            statusTitle = @"已支付";
            statusColor = HEXCOLOR(0x666666);
        }
            break;
        case 3:
        {
            // 如果是邮寄 - 显示已发货、  如果是领取- 显示待领取
            statusTitle = @"已发货";
            statusColor = HEXCOLOR(0x06C06F);

        }
            break;
        case 4:
        {
            statusTitle = @"已领取";
            statusColor = HEXCOLOR(0x06C06F);

        }
            break;
        case 5:
        {
            statusTitle = @"已取消";
            statusColor = HEXCOLOR(0x1F1F24);

        }
            break;
        default:
            break;
    }
    
    NSMutableAttributedString *attC2Str = [[NSMutableAttributedString alloc] initWithString:statusTitle];
    [attC2Str setYy_color:statusColor];
    
    NSMutableAttributedString *attC3Str = [[NSMutableAttributedString alloc] initWithString:@"\n审核状态："];
    NSString *statusSHTitle = @"";
    UIColor *statusSHColor = HEXCOLOR(0xEA0000);
    //status  0待审核 、1 审核通过、2 审核未通过、
    switch ([withWY_CompleteStatusModel[@"status"] intValue]) {
        case 0:
        {
            statusSHTitle = @"待审核";
            statusSHColor = HEXCOLOR(0xff9600);
        }
            break;
        case 1:
        {
            statusSHTitle = @"审核通过";
            statusSHColor = HEXCOLOR(0x06C06F);
        }
            break;
        case 2:
        {
            statusSHTitle = @"审核未通过";
            statusSHColor = HEXCOLOR(0xEA0000);

        }
            break;
       
        default:
            break;
    }

    
    NSMutableAttributedString *attC4Str = [[NSMutableAttributedString alloc] initWithString:statusSHTitle];
    //判断状态颜色；
    [attC4Str setYy_color:statusSHColor];
 
    NSMutableAttributedString *attC4AStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n退回原因：%@",withWY_CompleteStatusModel[@"reason"]]];
    if ([withWY_CompleteStatusModel[@"status"] intValue] == 2) {
        [attC4Str appendAttributedString:attC4AStr];
    }
    
    [attC1Str appendAttributedString:attC2Str];
    
    NSMutableAttributedString *attC2AStr = [[NSMutableAttributedString alloc] initWithString:@"\n*数字证书(CA)审核自支付成功之日起24小时内审核，请随时关注数字证书(CA)审核状态。审核状态为待审核或审核未通过状态无法制作证书且不能领取。"];
    [attC2AStr setYy_color:[UIColor redColor]];

    
    if ([withWY_CompleteStatusModel[@"orderStatus"] intValue] != 1) {
        [attC1Str appendAttributedString:attC3Str];
        [attC1Str appendAttributedString:attC4Str];
        [attC1Str appendAttributedString:attC2AStr];
     }
    
    [attC1Str setYy_lineSpacing:5];
    [self.lblContent setAttributedText:attC1Str];
    [self.lblContent setNumberOfLines:0];
    [self.lblContent sizeToFit];
     
    //判断是否显示按钮
    [self.btnToDetai setFrame:CGRectMake(k360Width(234), self.lblContent.bottom + k360Width(5), k360Width(85), k360Width(30))];
    [self.btnToDetai rounded:k360Width(30/4)];
    [self.btnToDetai setBackgroundColor:MSTHEMEColor];
    [self.btnToDetai.titleLabel setFont:WY_FONTRegular(12)];
    [self.btnToDetai setTitle:@"订单详情" forState:UIControlStateNormal];

    //判断是否显示按钮
    [self.btnShouHuo setFrame:CGRectMake(k360Width(234-95), self.lblContent.bottom + k360Width(5), k360Width(85), k360Width(30))];
    [self.btnShouHuo rounded:k360Width(30/4)];
    [self.btnShouHuo setBackgroundColor:MSTHEMEColor];
    [self.btnShouHuo.titleLabel setFont:WY_FONTRegular(12)];
    [self.btnShouHuo setHidden:YES];

    //判断是否显示按钮
    [self.btnDel setFrame:CGRectMake(k360Width(234 - 95-95), self.lblContent.bottom + k360Width(5), k360Width(85), k360Width(30))];
    [self.btnDel rounded:k360Width(30/4)];
    [self.btnDel setBackgroundColor:MSTHEMEColor];
    [self.btnDel.titleLabel setFont:WY_FONTRegular(12)];
    [self.btnDel setHidden:YES];
    if ([withWY_CompleteStatusModel[@"orderStatus"] intValue] == 1) {
        //显示删除按钮
        [self.btnDel setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.btnDel setBackgroundColor:[UIColor whiteColor]];
        [self.btnDel setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [self.btnDel rounded:k360Width(30/4) width:k360Width(1) color:HEXCOLOR(0x9f9f9f)];

        [self.btnDel setHidden:NO];
        //显示支付按钮
        [self.btnShouHuo setHidden:NO];

        //待支付
        [self.btnShouHuo setTitle:@"去支付" forState:UIControlStateNormal];
        [self.btnShouHuo setBackgroundColor:HEXCOLOR(0x63ce90)];
        
        
        [self viewShadowCorner:self.viewCont];
        self.viewCont.height = self.btnShouHuo.bottom + k375Width(12);
        self.height = self.viewCont.bottom;
        return;
    }
  if ([withWY_CompleteStatusModel[@"islingqu"] intValue] == 1 && [withWY_CompleteStatusModel[@"status"] intValue] == 1 && [withWY_CompleteStatusModel[@"orderStatus"] intValue] == 3){
        //审核通过 - 如果是领取 - 并且是审核通过状态 - 显示确认收货按钮；
      
      //2021-03-22 15:33:16（需求确认修改、删除掉确认收货按钮）
//        [self.btnShouHuo setTitle:@"确认收货" forState:UIControlStateNormal];
//        [self viewShadowCorner:self.viewCont];
//        self.viewCont.height = self.btnShouHuo.bottom + k375Width(12);
//        self.height = self.viewCont.bottom;
//        return;
    }
    [self.btnShouHuo setHidden:YES];
    self.viewCont.height = self.btnToDetai.bottom + k375Width(12);
    self.height = self.viewCont.bottom;
    return;
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
