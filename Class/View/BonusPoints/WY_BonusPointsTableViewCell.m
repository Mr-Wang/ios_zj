//
//  WY_BonusPointsTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_BonusPointsTableViewCell.h"
#import "UIView+WY_Badge.h"
#import "WY_AddNewAppealViewController.h"
#import "M13BadgeView.h" 

@implementation WY_BonusPointsTableViewCell
{
    int lastY;
    M13BadgeView *badgeView;
    UIView *badgeSuperView;
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
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewCont.width - k360Width(16), k360Width(34))];
    [self.lblTitle setFont:WY_FONTRegular(16)];
    [self.lblTitle setTextColor:HEXCOLOR(0xb7b7b7)];
    [self.lblTitle setTextAlignment:NSTextAlignmentRight];
    [self.viewCont addSubview:self.lblTitle];
    
    self.lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(34), self.lblTitle.bottom, k360Width(232), k360Width(24))];
    [self.lbl1 setHidden:YES];
    [self.viewCont addSubview:self.lbl1];
    self.lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(34), self.lbl1.bottom, k360Width(232), k360Width(24))];
    [self.lbl2 setHidden:YES];
    [self.viewCont addSubview:self.lbl2];
    
    self.lblBottom = [UILabel new];
    [self.lblBottom setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.lblBottom setTextColor:HEXCOLOR(0xB7B7B7)];
    [self.lblBottom setFont:WY_FONTRegular(12)];
    [self.lblBottom setTextAlignment:NSTextAlignmentCenter];
    [self.lblBottom setNumberOfLines:2];
    [self.lblBottom setHidden:YES];
    [self.viewCont addSubview:self.lblBottom];
    
    self.btnCall = [UIButton new];
    self.btnJieMi = [UIButton new];
    self.btnPingJia = [UIButton new];
    self.btnDLPingJia = [UIButton new];
    
    [self.btnCall.titleLabel setFont:WY_FONT375Regular(12)];
    [self.btnJieMi.titleLabel setFont:WY_FONT375Regular(12)];
    [self.btnPingJia.titleLabel setFont:WY_FONT375Regular(12)];
    [self.btnDLPingJia.titleLabel setFont:WY_FONT375Regular(12)];
    
    
    [self.viewCont addSubview:self.btnCall];
    [self.viewCont addSubview:self.btnJieMi];
    [self.viewCont addSubview:self.btnPingJia];
    [self.viewCont addSubview:self.btnDLPingJia];
    
    badgeSuperView = [[UIView alloc] initWithFrame:self.btnPingJia.frame];
    
    [badgeSuperView setUserInteractionEnabled:NO];
    [self.viewCont addSubview:badgeSuperView];
    [badgeSuperView setBackgroundColor:[UIColor clearColor]];
    badgeView = [[M13BadgeView alloc] init];
    //        badgeView.text = @"0"; //@"111";//self.mWY_ExpertModel.unReadDeductionCount;//self.mWY_ExpertModel.deductionCount;
    [badgeSuperView addSubview:badgeView];
    
    
}
 
//申诉-Cell
- (void)showCellSSByItem:(WY_ExpertModel *)withWY_ExpertModel{
    self.mWY_ExpertModel = withWY_ExpertModel;
    if (self.mWY_ExpertModel.createtime.length > 19) {
        self.lblTitle.text = [self.mWY_ExpertModel.applyTime substringToIndex:19];
        
    } else {
        self.lblTitle.text = self.mWY_ExpertModel.applyTime;
        
    }
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.lblTitle] && ![viewT isEqual:self.lbl1] && ![viewT isEqual:self.lbl2] && ![viewT isEqual:self.btnCall] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnPingJia] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnDLPingJia]) {
            [viewT removeFromSuperview];
        }
    }
    lastY = self.lblTitle.bottom;
    
    [self  byReturnColCellTitle:@"申请奖励加分事项类型：" byLabelStr:@"" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"" byLabelStr:self.mWY_ExpertModel.rewardTerms isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"具体内容：" byLabelStr:@"" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"" byLabelStr:self.mWY_ExpertModel.rewardContent isAcc:NO withBlcok:nil];
    
    [self  byReturnColCellTitle:@"证明材料" byLabelStr:@"" isAcc:NO withBlcok:nil];
    //附件1
    NSMutableArray *arrImgs1 = [NSMutableArray new];
    NSMutableArray *arrImgs2 = [NSMutableArray new];
    for (NSDictionary *dicImg in self.mWY_ExpertModel.sysAttachList) {
        if ([dicImg[@"sysAttachcol"] intValue] == 1) {
            [arrImgs1 addObject:dicImg[@"url"]];
        } else  if ([dicImg[@"sysAttachcol"] intValue] == 2) {
            [arrImgs2 addObject:dicImg[@"url"]];
        }
    }
    if (arrImgs1.count > 0) {
        int picW = (self.viewCont.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, lastY + k360Width(5), self.viewCont.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in arrImgs1) {
            UIButton *btnPic = [UIButton new];
            [btnPic setFrame:CGRectMake(btnPicX, 0, picW, picW )];
       
            if ([picUrl rangeOfString:@".pdf"].length > 0) {
                //                pdf
                [btnPic setBackgroundImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
                //是pdf
            } else {
                [btnPic sd_setBackgroundImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
                //是图片
            }
                [btnPic addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    
                    if(self.btnImageShowBlock) {
                        self.btnImageShowBlock(picUrl);
                    }
                    
                }];
            [viewPic addSubview:btnPic];
            btnPicX = btnPic.right+k360Width(5);
        }
        [self.viewCont addSubview:viewPic];
        lastY = viewPic.bottom;
    }
    
    [self  byReturnColCellTitle:@"协会确认的奖励加分申请表" byLabelStr:@"" isAcc:NO withBlcok:nil];
    //附件2
    if (arrImgs2.count > 0) {
        int picW = (self.viewCont.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, lastY + k360Width(5), self.viewCont.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in arrImgs2) {
            UIButton *btnPic = [UIButton new];
            [btnPic setFrame:CGRectMake(btnPicX, 0, picW, picW )];
            
 
            if ([picUrl rangeOfString:@".pdf"].length > 0) {
                //                pdf
                [btnPic setBackgroundImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
                //是pdf
            } else {
                [btnPic sd_setBackgroundImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
                //是图片
            }
                [btnPic addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    
                    if(self.btnImageShowBlock) {
                        self.btnImageShowBlock(picUrl);
                    }
                    
                }];
            [viewPic addSubview:btnPic];
            btnPicX = btnPic.right+k360Width(5);
        }
        [self.viewCont addSubview:viewPic];
        lastY = viewPic.bottom;
    }
    //status 4 - 专家提交 2 协会审核通过，3省级审核通过 5，审核拒绝
    switch ([self.mWY_ExpertModel.status intValue]) {
        case 2:
        case 4:
        {
            [self  byReturnColCellTitle:@"审核状态：" byLabelStr:@"审核中" isAcc:NO withBlcok:nil];
            
        }
            break;
        case 3:
        {
            [self  byReturnColCellTitle:@"审核状态：" byLabelStr:@"审核通过" isAcc:NO withBlcok:nil];
            [self  byReturnColCellTitle:@"奖励加分：" byLabelStr:[NSString stringWithFormat:@"%.1f分",[self.mWY_ExpertModel.scoreStandard floatValue]] isAcc:NO withBlcok:nil];
        }
            break;
        case 5:
        {
            [self  byReturnColCellTitle:@"审核状态：" byLabelStr:@"审核拒绝" isAcc:NO withBlcok:nil];
        }
            break;
        default:
            break;
    }
    
    self.viewCont.height = lastY + k360Width(10);
     
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}

//-其他扣分
- (void)showCellOPByItem:(WY_ExpertModel *)withWY_ExpertModel{
    self.mWY_ExpertModel = withWY_ExpertModel;
    if (self.mWY_ExpertModel.createtime.length > 19) {
        self.lblTitle.text = [self.mWY_ExpertModel.applyTime substringToIndex:19];
        
    } else {
        self.lblTitle.text = self.mWY_ExpertModel.applyTime;
        
    }
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.lblTitle] && ![viewT isEqual:self.lbl1] && ![viewT isEqual:self.lbl2] && ![viewT isEqual:self.btnCall] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnPingJia] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnDLPingJia]) {
            [viewT removeFromSuperview];
        }
    }
    lastY = self.lblTitle.bottom;
    
    [self  byReturnColCellTitle:@"其他（基本信息）扣分：" byLabelStr:@"" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"" byLabelStr:self.mWY_ExpertModel.otherPointsReason isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"具体内容：" byLabelStr:@"" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"" byLabelStr:self.mWY_ExpertModel.otherPointsContent isAcc:NO withBlcok:nil];
    
    [self  byReturnColCellTitle:@"证明材料" byLabelStr:@"" isAcc:NO withBlcok:nil];
    //附件1
//    NSMutableArray *arrImgs1 = [NSMutableArray new];
    
 
    NSMutableArray *arrImgs1 = [[NSMutableArray alloc] initWithArray:[self.mWY_ExpertModel.attachmentFileName componentsSeparatedByString:@","]];
    if (arrImgs1.count > 0) {
        int picW = (self.viewCont.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, lastY + k360Width(5), self.viewCont.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in arrImgs1) {
            
            UIButton *btnPic = [UIButton new];
            [btnPic setFrame:CGRectMake(btnPicX, 0, picW, picW )];
       
                [btnPic addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {

                    if(self.btnImageShowBlock) {
                        self.btnImageShowBlock(picUrl);
                    }

                }];
            
            if ([picUrl rangeOfString:@".pdf"].length > 0) {
                //                pdf
                [btnPic setBackgroundImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
                //是pdf
            } else {
                [btnPic sd_setBackgroundImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
                //是图片
            }
            
            [viewPic addSubview:btnPic];
            btnPicX = btnPic.right+k360Width(5);
        }
        [self.viewCont addSubview:viewPic];
        lastY = viewPic.bottom;
    }
      
    self.viewCont.height = lastY + k360Width(10);
     
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}

//-违法行为
- (void)showCellLLByItem:(WY_ExpertModel *)withWY_ExpertModel{
    self.mWY_ExpertModel = withWY_ExpertModel;
    if (self.mWY_ExpertModel.createtime.length > 19) {
        self.lblTitle.text = [self.mWY_ExpertModel.applyTime substringToIndex:19];
        
    } else {
        self.lblTitle.text = self.mWY_ExpertModel.applyTime;
        
    }
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.lblTitle] && ![viewT isEqual:self.lbl1] && ![viewT isEqual:self.lbl2] && ![viewT isEqual:self.btnCall] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnPingJia] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnDLPingJia]) {
            [viewT removeFromSuperview];
        }
    }
    lastY = self.lblTitle.bottom;
    
    [self  byReturnColCellTitle:@"专家违法行为" byLabelStr:@"" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"" byLabelStr:self.mWY_ExpertModel.illegalTerms isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"具体内容：" byLabelStr:@"" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"" byLabelStr:self.mWY_ExpertModel.illegalContent isAcc:NO withBlcok:nil];
    
    [self  byReturnColCellTitle:@"证明材料" byLabelStr:@"" isAcc:NO withBlcok:nil];
    //附件1
//    NSMutableArray *arrImgs1 = [NSMutableArray new];
    
 
    NSMutableArray *arrImgs1 = [[NSMutableArray alloc] initWithArray:[self.mWY_ExpertModel.attachmentFileName componentsSeparatedByString:@","]];
    if (arrImgs1.count > 0) {
        int picW = (self.viewCont.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, lastY + k360Width(5), self.viewCont.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in arrImgs1) {
            
            UIButton *btnPic = [UIButton new];
            [btnPic setFrame:CGRectMake(btnPicX, 0, picW, picW )];
                [btnPic addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {

                    if(self.btnImageShowBlock) {
                        self.btnImageShowBlock(picUrl);
                    }

                }];
            
            if ([picUrl rangeOfString:@".pdf"].length > 0) {
                //                pdf
                [btnPic setBackgroundImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
                //是pdf
            } else {
                [btnPic sd_setBackgroundImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
                //是图片
            }
            
            [viewPic addSubview:btnPic];
            btnPicX = btnPic.right+k360Width(5);
        }
        [self.viewCont addSubview:viewPic];
        lastY = viewPic.bottom;
    }
      
    [self  byReturnColCellTitle:@"处理决定" byLabelStr:@"" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"" byLabelStr:self.mWY_ExpertModel.processingDecision isAcc:NO withBlcok:nil];
    
    self.viewCont.height = lastY + k360Width(10);
     
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}

//-总体参评
- (void)showCellZTCPByItem:(WY_ExpertModel *)withWY_ExpertModel{
    self.mWY_ExpertModel = withWY_ExpertModel;
  
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.lblTitle] && ![viewT isEqual:self.lbl1] && ![viewT isEqual:self.lbl2] && ![viewT isEqual:self.btnCall] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnPingJia] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnDLPingJia]) {
            [viewT removeFromSuperview];
        }
    }
    [self.lblTitle setFrame:CGRectMake(k360Width(16), k360Width(5), self.viewCont.width - k360Width(32), k360Width(30))];
    [self.lbl1 setFrame:CGRectMake(self.viewCont.width - k360Width(216),  k360Width(5),k360Width(200), k360Width(30))];
    [self.lblTitle setTextAlignment:NSTextAlignmentLeft];
    [self.lbl1 setTextAlignment:NSTextAlignmentRight];
    [self.lbl1 setHidden:NO];
    NSMutableAttributedString *attStrLeft = nil;
    NSMutableAttributedString *attStrLeft1 = nil;
    NSMutableAttributedString *attStrRight = nil;
    NSMutableAttributedString *attStrRight1 = nil;
    // 1 是未接通cell,  2是 主动拒绝cell
    if ([withWY_ExpertModel.ztType isEqualToString:@"1"]) {
        attStrLeft =[[NSMutableAttributedString alloc] initWithString:@"年度语音电话未接听数"];
        attStrLeft1 =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %d次",withWY_ExpertModel.unDialedList.count]];
        attStrRight =[[NSMutableAttributedString alloc] initWithString:@"转换扣分"];
        attStrRight1 =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %.1f分",[withWY_ExpertModel.unansweredDeductPoints floatValue]]];
    } else {
        attStrLeft =[[NSMutableAttributedString alloc] initWithString:@"年度主动拒绝参评数"];
        attStrLeft1 =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %d次",withWY_ExpertModel.refuseList.count + withWY_ExpertModel.unansweredList.count]];
        attStrRight =[[NSMutableAttributedString alloc] initWithString:@"转换扣分"];
        attStrRight1 =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %.1f分",[withWY_ExpertModel.refuseDeductPoints floatValue]]];
    }
    [attStrLeft setYy_color:[UIColor blackColor]];
    [attStrLeft1 setYy_color:HEXCOLOR(0x0c00ff)];
    [attStrLeft setYy_font:WY_FONTMedium(14)];
    [attStrLeft1 setYy_font:WY_FONTMedium(14)];
    [attStrLeft appendAttributedString:attStrLeft1];
    [self.lblTitle setAttributedText:attStrLeft];
    
    [attStrRight1 setYy_color:HEXCOLOR(0xc23431)];
    [attStrRight setYy_font:WY_FONTMedium(14)];
    [attStrRight1 setYy_font:WY_FONTMedium(14)];
    [attStrRight appendAttributedString:attStrRight1];
    [self.lbl1 setAttributedText:attStrRight];
    
    lastY = self.lblTitle.bottom;
    
    if ([withWY_ExpertModel.ztType isEqualToString:@"1"]) {
        for (NSDictionary *dicItem in withWY_ExpertModel.unDialedList) {
            NSString *cellStr = [NSString stringWithFormat:@"%@拨打未接听",dicItem[@"startTime"]];
            [self  byReturnColCellTitle:cellStr byLabelStr:@"" isAcc:NO withBlcok:nil];
        }
    } else {
        for (NSDictionary *dicItem in withWY_ExpertModel.refuseList) {
            NSString *cellStr = [NSString stringWithFormat:@"%@主动拒绝评标邀请",dicItem[@"startTime"]];
            [self  byReturnColCellTitle:cellStr byLabelStr:@"" isAcc:NO withBlcok:nil];
        }
        for (NSDictionary *dicItem in withWY_ExpertModel.unansweredList) {
            NSString *cellStr = [NSString stringWithFormat:@"%@拨通未回复",dicItem[@"startTime"]];
            [self  byReturnColCellTitle:cellStr byLabelStr:@"" isAcc:NO withBlcok:nil];
        }
    }
    
  
    
    self.viewCont.height = lastY + k360Width(10);
     
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}

 
- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.viewCont.width, k360Width(44))];
    [self.viewCont addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:[UIColor blackColor]];
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
    [withLabel setFont:WY_FONTRegular(14)];
    withLabel.text = withLabelStr;
    [withLabel sizeToFit];
    if (withLabel.height < k360Width(22)) {
        withLabel.height = k360Width(22);
    }
    
    viewTemp.height = withLabel.bottom;
    [viewTemp addSubview:withLabel];
    
    if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
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
