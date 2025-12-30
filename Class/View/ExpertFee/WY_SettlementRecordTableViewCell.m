//
//  WY_SettlementRecordTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SettlementRecordTableViewCell.h"

@implementation WY_SettlementRecordTableViewCell
{
    int lastY;
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
    [self setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    self.colSender = [[UIControl alloc] init];
    self.viewCont = [UIView new];
    [self.viewCont setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(40))];
    [self.viewCont setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.viewCont];
     
    
    self.btnCall = [UIButton new];
    [self.btnCall.titleLabel setFont:WY_FONT375Regular(12)];
    
    [self.viewCont addSubview:self.btnCall];
    
    
}

- (void)showCellByItem:(NSDictionary *)withNSDictionary{
    self.mNSDictionary = withNSDictionary;
  
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.btnCall]) {
            [viewT removeFromSuperview];
        }
    }
    lastY = k360Width(16);
      
    [self  byReturnColCellTitle:@"发起人：" byLabelStr:@"没有这个字段" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"专家姓名：" byLabelStr:self.mNSDictionary[@"expertName"] isAcc:NO withBlcok:nil];

    [self  byReturnColCellTitle:@"代理机构：" byLabelStr:self.mNSDictionary[@"agencyName"] isAcc:NO withBlcok:nil];

    [self  byReturnColCellTitle:@"发起时间：" byLabelStr:self.mNSDictionary[@"createTime"] isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"发起事件：" byLabelStr:@"没有这个字段" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"异议内容：" byLabelStr:self.mNSDictionary[@"content"] isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"附件内容：" byLabelStr:@"没有这个字段" isAcc:NO withBlcok:nil];
    
    //如果需要展示结束费用按钮
    if (1==1) {
        [self.btnCall setFrame:CGRectMake(k375Width(16), lastY + k360Width(10), k375Width(60), k375Width(30))];
        [self.btnCall setTitle:@"附件图片" forState:UIControlStateNormal];
         [self.btnCall addTarget:self action:@selector(btnCallAction) forControlEvents:UIControlEventTouchUpInside];
        [self.btnCall setBackgroundColor:MSTHEMEColor];
         [self.btnCall rounded:k375Width(30/8)];
        [self.btnCall setHidden:NO];
        self.viewCont.height = self.btnCall.bottom + k360Width(16);
     
    } else {
        [self.btnCall setHidden:YES];
        self.viewCont.height = lastY + k360Width(16);
    }
        
    
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}
- (void)btnCallAction {
    if (self.leavePhoneBlock) {
        self.leavePhoneBlock(self.mNSDictionary);
    }
}
    


- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.viewCont.width, k360Width(44))];
    [self.viewCont addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:HEXCOLOR(0x666666)];
    [lblTitle setFont:WY_FONTRegular(14)];
    [viewTemp addSubview:lblTitle];
    [lblTitle sizeToFit];
    if (lblTitle.height < k360Width(22)) {
        lblTitle.height = k360Width(22);
    }
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewCont.width - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"0527_nav"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
    
    UILabel *withLabel = [UILabel new];
    
    [withLabel setFrame:CGRectMake(lblTitle.right, 0, viewTemp.width - lblTitle.right - k360Width(16) - accLeft, k360Width(22))];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextColor:HEXCOLOR(0x666666)];
    [withLabel setFont:WY_FONTRegular(14)];
    withLabel.text = withLabelStr;
    [withLabel sizeToFit];
    if (withLabel.height < k360Width(22)) {
        withLabel.height = k360Width(22);
    }
    
    viewTemp.height = withLabel.bottom;
    [viewTemp addSubview:withLabel];
    
    if (isAcc) {
        [viewTemp setUserInteractionEnabled:YES];
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    } else {
        [viewTemp setUserInteractionEnabled:NO];
    }
    lastY = viewTemp.bottom;
    return viewTemp;
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
