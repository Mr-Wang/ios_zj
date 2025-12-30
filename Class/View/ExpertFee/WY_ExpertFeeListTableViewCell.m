//
//  WY_ExpertFeeListTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ExpertFeeListTableViewCell.h"

@implementation WY_ExpertFeeListTableViewCell
{
    int lastY;
    UILabel *lblMsg;
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
    
    lblMsg = [UILabel new];
    [self.viewCont addSubview:lblMsg];
}

- (void)showCellByItem:(WY_ExpertFeeModel *)withWY_ExpertFeeModel{
    self.mWY_ExpertFeeModel = withWY_ExpertFeeModel;
  
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.btnCall] && ![viewT isEqual:lblMsg]) {
            [viewT removeFromSuperview];
        }
    }
    lastY = k360Width(16);
    NSString *bidEvaluationType = [self.mWY_ExpertFeeModel.bidEvaluationType intValue] == 1 ?@"正常评标":@"项目复议";
    
    NSString *clearingStatus = @"";
//    0待结算 1已结算 2结算中
    switch ([self.mWY_ExpertFeeModel.clearingStatus intValue]) {
        case 0:
        {
            clearingStatus = @"待结算";
        }
            break;
        case 1:
        {
            clearingStatus = @"已结算";
        }
            break;
        case 2:
        {
            clearingStatus = @"结算中";
        }
            break;
        case 3:
        {
            clearingStatus = @"异议中";
        }
            break;
          
        default:
            break;
    }
    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:self.mWY_ExpertFeeModel.tenderProjectName isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"评标类型：" byLabelStr:bidEvaluationType isAcc:NO withBlcok:nil];

    [self  byReturnColCellTitle:@"开始时间：" byLabelStr:self.mWY_ExpertFeeModel.evaluationTime isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"结束时间：" byLabelStr:self.mWY_ExpertFeeModel.evaluationEndTime isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"结算费用：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.mWY_ExpertFeeModel.clearingFees floatValue]] isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"结算状态：" byLabelStr:clearingStatus isAcc:NO withBlcok:nil];
    [self.btnCall setUserInteractionEnabled:NO];
    //如果需要展示结束费用按钮
    if ([self.mWY_ExpertFeeModel.clearingStatus intValue]==0) {
        [self.btnCall setFrame:CGRectMake(self.viewCont.width -  k375Width(60+16), lastY + k360Width(10), k375Width(60), k375Width(30))];
        [self.btnCall setTitle:@"结算费用" forState:UIControlStateNormal];
         [self.btnCall addTarget:self action:@selector(btnCallAction) forControlEvents:UIControlEventTouchUpInside];
        [self.btnCall setBackgroundColor:MSTHEMEColor];
         [self.btnCall rounded:k375Width(30/8)];
        [self.btnCall setHidden:NO];
        self.viewCont.height = self.btnCall.bottom + k360Width(16);
    } else {
        [self.btnCall setHidden:YES];
        self.viewCont.height = lastY + k360Width(16);
    }
//
    
    if ([self.mWY_ExpertFeeModel.clearingStatus intValue] == 0) {
        //显示提示文字；
        [lblMsg setFrame:CGRectMake(k360Width(16), self.viewCont.height, self.viewCont.width - k360Width(32), k360Width(22))];
        [lblMsg setFont:WY_FONTMedium(12)];
        [lblMsg setNumberOfLines:0];
        [lblMsg setLineBreakMode:NSLineBreakByWordWrapping];
        [lblMsg setText:self.mWY_ExpertFeeModel.msg];
        [lblMsg sizeToFit];
        lblMsg.height += 10;
        [lblMsg setTextColor:HEXCOLOR(0xb32126)];
        [lblMsg setHidden:NO];
        
        self.viewCont.height = lblMsg.bottom + k360Width(16);

    } else {
        [lblMsg setHidden:YES];
    }
    
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}
- (void)btnCallAction {
    if (self.leavePhoneBlock) {
        self.leavePhoneBlock(self.mWY_ExpertFeeModel);
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
    [lblTitle setFont:WY_FONTMedium(14)];
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
    
    if ([titleStr isEqualToString:@"项目名称"]) {
        [withLabel setFont:WY_FONTMedium(14)];
    } else {
        [withLabel setFont:WY_FONTRegular(14)];
    }
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
