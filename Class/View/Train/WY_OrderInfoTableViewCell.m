//
//  WY_OrderInfoTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OrderInfoTableViewCell.h"
#import "WY_SelectInvoiceViewController.h"

@implementation WY_OrderInfoTableViewCell
{
    UIImageView *imgLine;
    UILabel *lblddhContent;
    UILabel *lblFkfs;
    UILabel *lblFptt;
    UILabel *lblFpContent;
    UIButton *btnChaKan;
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
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [self.contentView addSubview:viewBlue1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(viewBlue1.right + k360Width(8), k360Width(0), k360Width(264), k360Width(44));
    label.text = @"订单信息";
    label.font = WY_FONTMedium(16);
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8/1.0];
    [self.contentView addSubview:label];
    
    UILabel *lblddh = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), label.bottom + k360Width(16), k360Width(80), k360Width(30))];
    lblddh.text = @"订 单 号 ：";
    [self.contentView addSubview:lblddh];
    
    lblddhContent = [[UILabel alloc] initWithFrame:CGRectMake(lblddh.right - k360Width(10), label.bottom + k360Width(16), k360Width(288), k360Width(30))];
    lblddhContent.text = @"";
    [lblddhContent setFont:WY_FONTRegular(12)];
    [lblddhContent setTextColor:APPTextGayColor];
    [self.contentView addSubview:lblddhContent];
    
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(44),kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];

    lblFkfs = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), lblddhContent.bottom + k360Width(10), k360Width(200), k360Width(30))];
      [self.contentView addSubview:lblFkfs];
    
    lblFptt = [UILabel new];
    lblFpContent = [UILabel new];
    [self.contentView addSubview:lblFptt];
    [self.contentView addSubview:lblFpContent];
    
      self.viewOrder = [UIView new];
      [self.viewOrder setBackgroundColor:MSColor(242, 242, 242)];
    [self.contentView addSubview:self.viewOrder];
    UILabel *lblDH = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(44))];
    [lblDH setTextColor:APPTextGayColor];
    [lblDH setText:@"客服电话：400-125-7788"];
    [lblDH setTextAlignment:NSTextAlignmentCenter];
    [self.viewOrder addSubview:lblDH];
    
    UIButton *btnFuZhi = [UIButton new];
    [btnFuZhi setFrame:CGRectMake(kScreenWidth - k360Width(60), lblddhContent.top, k360Width(44), k360Width(30))];
    [btnFuZhi setTitle:@"复制" forState:UIControlStateNormal];
    [btnFuZhi setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    [btnFuZhi.titleLabel setFont:WY_FONTRegular(14)];
    [btnFuZhi addTarget:self action:@selector(btnFuZhiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnFuZhi];
    
    btnChaKan = [UIButton new];
    [btnChaKan setHidden:YES];
    [btnChaKan setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    [btnChaKan.titleLabel setFont:WY_FONTRegular(14)];
    [self.contentView addSubview:btnChaKan];
    
    
}

- (void)showCellByItem:(NSDictionary*)withDicOrder withPaymethod:(NSString *)withPaymethod
{
    self.dicOrder = withDicOrder;
    lblddhContent.text = self.dicOrder[@"orderId"];
    if ([self.priceStr floatValue] > 0) {
        if ([withPaymethod isEqualToString:@"04"]) {
            lblFkfs.text = @"付款方式：余额支付";
        } else {
            lblFkfs.text = @"付款方式：微信支付";
        }
    } else {
        lblFkfs.text = @"付款方式：免费订单";
    }
    [lblFkfs setHidden:YES];
    if (self.mWY_SendEnrolmentMessageModel.isInvoice) {
        lblFptt.text = @"发票抬头：";
        lblFpContent.text =  self.mWY_SendEnrolmentMessageModel.InvoiceName;
        [lblFpContent setFont:WY_FONTRegular(12)];
        [lblFpContent setTextColor:APPTextGayColor];

        [lblFptt setFrame:CGRectMake(k360Width(16), lblFkfs.bottom + k360Width(10), k360Width(80), k360Width(44))];
        [lblFpContent setFrame:CGRectMake(lblFptt.right - k360Width(10), lblFkfs.bottom + k360Width(7), k360Width(200), k360Width(50))];
        lblFpContent.numberOfLines = 2;
        [lblFptt setHidden:NO];
        [lblFpContent setHidden:NO];
        [btnChaKan setTitle:@"查看" forState:UIControlStateNormal];
        [btnChaKan setFrame:CGRectMake(kScreenWidth - k360Width(60), lblFpContent.top, k360Width(44), k360Width(30))];
           [btnChaKan setHidden:NO];
        [btnChaKan addTarget:self action:@selector(btnChaKanAction) forControlEvents:UIControlEventTouchUpInside];

        [self.viewOrder setFrame:CGRectMake(0, lblFptt.bottom + k360Width(16), kScreenWidth, k360Width(44))];

    } else {
        [lblFptt setHidden:YES];
        [lblFpContent setHidden:YES];
        [btnChaKan setHidden:YES];
        
        [self.viewOrder setFrame:CGRectMake(0, lblddhContent.bottom + k360Width(16), kScreenWidth, k360Width(44))];

    }
 
}
- (void)btnFuZhiAction {
//    self.dicOrder[@"orderId"]
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.dicOrder[@"orderId"];
    
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}
- (void)btnChaKanAction {
    NSLog(@"点击查看发票按钮");
    //点击查看发票按钮；
    if (self.gotoInvoiceBlock) {
        self.gotoInvoiceBlock();
    }
}

@end
