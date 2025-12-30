//
//  WY_BiddingProjectTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_BiddingProjectTableViewCell.h"
#import "UIView+WY_Badge.h"
#import "M13BadgeView.h"
#import "WY_HandleTempCAViewController.h"

@implementation WY_BiddingProjectTableViewCell
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
    
    self.lblBottom = [UILabel new];
    [self.lblBottom setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.lblBottom setTextColor:HEXCOLOR(0xB7B7B7)];
    [self.lblBottom setFont:WY_FONTRegular(12)];
    [self.lblBottom setTextAlignment:NSTextAlignmentCenter];
    [self.lblBottom setNumberOfLines:2];
    [self.lblBottom setHidden:YES];
    [self.viewCont addSubview:self.lblBottom];
    
    self.lblBottomA = [UILabel new]; 
    [self.lblBottomA setTextColor:[UIColor blackColor]];
    [self.lblBottomA setFont:WY_FONTRegular(12)];
    [self.lblBottomA setTextAlignment:NSTextAlignmentCenter];
    [self.lblBottomA setNumberOfLines:2];
    [self.lblBottomA setHidden:YES];
    [self.viewCont addSubview:self.lblBottomA];
    
    self.btnCall = [UIButton new];
    self.btnCall1 = [UIButton new];
    self.btnJieMi = [UIButton new];
    self.btnPingJia = [UIButton new];
    self.btnDLPingJia = [UIButton new];
    
    
    self.btnHandleCA = [UIButton new];
    
    [self.btnCall.titleLabel setFont:WY_FONT375Regular(12)];
    [self.btnHandleCA.titleLabel setFont:WY_FONT375Regular(12)];
    
    [self.btnCall1.titleLabel setFont:WY_FONT375Regular(12)];
    
    [self.btnJieMi.titleLabel setFont:WY_FONT375Regular(12)];
    [self.btnPingJia.titleLabel setFont:WY_FONT375Regular(12)];
    [self.btnDLPingJia.titleLabel setFont:WY_FONT375Regular(12)];
    
    
    [self.viewCont addSubview:self.btnCall];
    [self.viewCont addSubview:self.btnHandleCA];
    [self.viewCont addSubview:self.btnCall1];
    
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

- (void)showCellByItem:(WY_ExpertModel *)withWY_ExpertModel{
    self.mWY_ExpertModel = withWY_ExpertModel;
    if (self.mWY_ExpertModel.createtime.length > 19) {
        self.lblTitle.text = [self.mWY_ExpertModel.createtime substringToIndex:19];
        
    } else {
        self.lblTitle.text = self.mWY_ExpertModel.createtime;
        
    }
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.lblTitle] && ![viewT isEqual:self.lblBottom]&& ![viewT isEqual:self.lblBottomA] && ![viewT isEqual:self.btnCall] && ![viewT isEqual:self.btnCall1] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnPingJia] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnDLPingJia] && ![viewT isEqual:self.btnHandleCA]) {
            [viewT removeFromSuperview];
        }
    }
    lastY = self.lblTitle.bottom;
    
    UIImageView *imgType = [UIImageView new];
    [imgType setFrame:CGRectMake(0, 0, k375Width(53), k375Width(53))];
    [self.viewCont addSubview:imgType];
    if ([self.mWY_ExpertModel.status isEqualToString:@"1"] && [self.mWY_ExpertModel.bidSectionState isEqualToString:@"1"] ) {
        //待评
        [imgType setImage:[UIImage imageNamed:@"0701_yqr"]];
        [imgType setHidden:NO];
    } else if ([self.mWY_ExpertModel.status isEqualToString:@"2"]) {
        //历史
        //        [imgType setImage:[UIImage imageNamed:@"lsxm"]];
        [imgType setHidden:YES];
    } else{
        [imgType setHidden:YES];
    }
    
    
    
    
    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:self.mWY_ExpertModel.name isAcc:NO withBlcok:nil];
    //    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:@"项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称" isAcc:NO withBlcok:nil];
    
    [self  byReturnColCellTitle:@"代理机构：" byLabelStr:self.mWY_ExpertModel.daili isAcc:NO withBlcok:nil];
    
    if (self.mWY_ExpertModel.time.length > 16) {
        [self  byReturnColCellTitle:@"集合时间：" byLabelStr:[self.mWY_ExpertModel.time substringToIndex:16] isAcc:NO withBlcok:nil];
    } else {
        [self  byReturnColCellTitle:@"集合时间：" byLabelStr:self.mWY_ExpertModel.time isAcc:NO withBlcok:nil];
    }
//    major 没有返回nil - 未解密时返回*** 解密后返回正常
    if (![self.mWY_ExpertModel.major isEqual:[NSNull null]] && self.mWY_ExpertModel.major.length > 0) {
        [self  byReturnColCellTitle:@"抽取专业：" byLabelStr:self.mWY_ExpertModel.major isAcc:NO withBlcok:nil];
    }
    
    //导航这个-  因为高德收费- 不用了
    [self  byReturnColCellTitle:@"集合地点：" byLabelStr:self.mWY_ExpertModel.place isAcc:NO withBlcok:nil];
    //    if ([self.mWY_ExpertModel.status isEqualToString:@"1"]) {
    //        //评标通知里加导航
    //        [self  byReturnColCellTitle:@"集合地点：" byLabelStr:self.mWY_ExpertModel.place isAcc:YES withBlcok:^{
    //            NSLog(@"点击了集合地点");
    //            if (self.btnNavigationBlock) {
    //                self.btnNavigationBlock(self.mWY_ExpertModel);
    //            }
    //        }];
    //
    //    } else {
    //        //评标历史里不加
    //        [self  byReturnColCellTitle:@"集合地点：" byLabelStr:self.mWY_ExpertModel.place isAcc:NO withBlcok:nil];
    //
    //    }
    
    
    //    [self  byReturnColCellTitle:@"应急电话：" byLabelStr:self.mWY_ExpertModel.yjphone isAcc:NO withBlcok:nil];

    //新加的
    if(self.mWY_ExpertModel.remark.length > 0) {
        [self  byReturnColCellTitle:@"备注：" byLabelStr:self.mWY_ExpertModel.remark isAcc:NO withBlcok:nil];
    }
    NSString *statusStr = @"未签到";
    if ([self.mWY_ExpertModel.signFlag isEqualToString:@"1"]|| [self.mWY_ExpertModel.signFlag isEqualToString:@"2"]) {
        statusStr = @"已签到";
    }
    
    if ([self.mWY_ExpertModel.leaveFlag boolValue]) {
        statusStr = @"已请假";
    }
    [self  byReturnColCellTitle:@"当前状态：" byLabelStr:statusStr isAcc:NO withBlcok:nil];
    if ([self.mWY_ExpertModel.signFlag isEqualToString:@"1"]|| [self.mWY_ExpertModel.signFlag isEqualToString:@"2"]) {
     //签到之后 显示 -验证码
        if (self.mWY_ExpertModel.yzm != nil && ![self.mWY_ExpertModel.yzm isEqual:[NSNull null]]) {
            //判断非空
         [self  byReturnColCellTitle:@"验 证 码：" byLabelStr:self.mWY_ExpertModel.yzm isAcc:NO withBlcok:nil];
        }
    }
    if (self.mWY_ExpertModel.typeID == 3) {
        if ([self.mWY_ExpertModel.isReconsider isEqualToString:@"0"]) {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"未申诉" isAcc:NO withBlcok:nil];
        } if ([self.mWY_ExpertModel.isReconsider isEqualToString:@"1"]||[self.mWY_ExpertModel.isReconsider isEqualToString:@"2"]) {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"申诉完成" isAcc:NO withBlcok:nil];
        }
    }
    //update - 2023-03-09 09:21:53 增加字段 是否隔夜评标、  并且隐藏- 预计评标时长 和 报酬；
    if(self.mWY_ExpertModel.isOvernight.length > 0) {
        [self  byReturnColCellTitle:@"是否隔夜评标：" byLabelStr:self.mWY_ExpertModel.isOvernight isAcc:NO withBlcok:nil];
    }
    
    
    if(self.mWY_ExpertModel.estimatedEvaluationTime.length > 0) {
        [self  byReturnColCellTitle:@"预计评标时长：" byLabelStr:self.mWY_ExpertModel.estimatedEvaluationTime isAcc:NO withBlcok:nil];
        
    }
    if(self.mWY_ExpertModel.estimatedEvaluationPrice.length > 0) {
        //        2022-05-16 10:57:34 -税后报酬 改成 含税报酬-  刘林说开会说的
        //        [self  byReturnColCellTitle:@"预计劳务报酬（税后报酬）：" byLabelStr:self.mWY_ExpertModel.estimatedEvaluationPrice isAcc:NO withBlcok:nil];
        [self  byReturnColCellTitle:@"预计劳务报酬（含税报酬）：" byLabelStr:self.mWY_ExpertModel.estimatedEvaluationPrice isAcc:NO withBlcok:nil];
        
    }
    //评标通知
    if ([self.mWY_ExpertModel.status isEqualToString:@"1"]) {
        
         
        [self.btnCall1 setFrame:CGRectMake(k375Width(100), lastY + k360Width(10), k375Width(64), k375Width(30))];
        [self.btnHandleCA setFrame:CGRectMake(k375Width(100), lastY + k360Width(10), k375Width(94), k375Width(30))];
        
        [self.btnCall setFrame:CGRectMake(k375Width(190), lastY + k360Width(10), k375Width(84), k375Width(30))];
        [self.btnJieMi setFrame:CGRectMake(k375Width(280), lastY + k360Width(10), k375Width(44), k375Width(30))];
        
        [self.btnCall1 setTitle:@"在线请假" forState:UIControlStateNormal];
        [self.btnHandleCA setTitle:@"办理项目云签章" forState:UIControlStateNormal];
        [self.btnCall setTitle:@"拨打应急电话" forState:UIControlStateNormal];
        [self.btnJieMi setTitle:@"签到" forState:UIControlStateNormal];
        [self.btnCall addTarget:self action:@selector(btnCallAction) forControlEvents:UIControlEventTouchUpInside];
        [self.btnJieMi addTarget:self action:@selector(btnJieMiAction) forControlEvents:UIControlEventTouchUpInside];
        [self.btnCall1 addTarget:self action:@selector(btnCall1Action) forControlEvents:UIControlEventTouchUpInside];
        [self.btnHandleCA addTarget:self action:@selector(btnHandleCAAction) forControlEvents:UIControlEventTouchUpInside];

        
        [self.btnCall setBackgroundColor:MSTHEMEColor];
        [self.btnCall1 setBackgroundColor:MSTHEMEColor];
        [self.btnJieMi setBackgroundColor:MSTHEMEColor];
        [self.btnHandleCA setBackgroundColor:MSTHEMEColor];
        
         
        [self.btnCall rounded:k375Width(30/8)];
        [self.btnCall1 rounded:k375Width(30/8)];
        [self.btnHandleCA rounded:k375Width(30/8)];
        
        [self.btnJieMi rounded:k375Width(30/8)];
        
        
        if ([self.mWY_ExpertModel.signFlag isEqualToString:@"1"]|| [self.mWY_ExpertModel.signFlag isEqualToString:@"2"] || [self.mWY_ExpertModel.leaveFlag boolValue]) {
            //已经解密； 隐藏按钮；
            
            self.btnCall.left = k375Width(240);
            [self.btnCall setHidden:NO];
            [self.btnJieMi setHidden:YES];
            self.btnHandleCA.right = self.btnCall.left - k375Width(6);
            
            self.btnCall1.right = self.btnHandleCA.left - k375Width(6);
            
            [self.btnHandleCA setHidden:NO];
//            if(![self.mWY_ExpertModel.isNeedHandleCA isEqualToString:@"1"]) {
//                [self.btnHandleCA setUserInteractionEnabled:NO];
//                [self.btnHandleCA setBackgroundColor:[UIColor grayColor]];
//             } else {
                [self.btnHandleCA setUserInteractionEnabled:YES];
                [self.btnHandleCA setBackgroundColor:MSTHEMEColor];
//            }
            
            
            [self.lblBottomA setFrame:CGRectMake(k360Width(10), self.btnCall.bottom + k360Width(5), self.viewCont.width - k360Width(20), k360Width(40))];
            
            if (self.mWY_ExpertModel.platformContent != nil && ![self.mWY_ExpertModel.platformContent isEqual:[NSNull null]]) {
                [self.lblBottomA setText:self.mWY_ExpertModel.platformContent];
                [self.lblBottomA setNumberOfLines:0];
                [self.lblBottomA setLineBreakMode:NSLineBreakByWordWrapping];
                [self.lblBottomA sizeToFit];
                self.lblBottomA.height += k360Width(10);
                [self.lblBottom setFrame:CGRectMake(0, self.lblBottomA.bottom + k360Width(5), self.viewCont.width, k360Width(40))];
                [self.lblBottomA setHidden:NO];

            } else {
                [self.lblBottomA setHidden:YES];
                [self.lblBottom setFrame:CGRectMake(0, self.btnCall.bottom + k360Width(10), self.viewCont.width, k360Width(40))];
            }
            
            
        } else {
            self.btnCall.left = k375Width(190);
            //这个是一键请假按钮- 后台人员各种没空 任务被搁置；
//            self.btnCall1.right = self.btnCall.left - k375Width(6);
            [self.btnCall setHidden:NO];
            [self.btnJieMi setHidden:NO];
            [self.lblBottom setFrame:CGRectMake(0, self.btnCall.bottom + k360Width(10), self.viewCont.width, k360Width(40))];
            //如果未签到 - 不显示办理云签章按钮
            self.btnHandleCA.right = self.btnCall.left - k375Width(6);
            self.btnCall1.right = self.btnHandleCA.left - k375Width(6);

//            if(![self.mWY_ExpertModel.isNeedHandleCA isEqualToString:@"1"]) {
//                [self.btnHandleCA setUserInteractionEnabled:NO];
//                [self.btnHandleCA setBackgroundColor:[UIColor grayColor]];
//            } else {
                [self.btnHandleCA setUserInteractionEnabled:YES];
                [self.btnHandleCA setBackgroundColor:MSTHEMEColor];
//            }
            
            [self.btnHandleCA setHidden:YES];
            [self.lblBottomA setHidden:YES];
        }
        //        self.btnCall.left = k375Width(190);
        //        [self.btnCall setHidden:NO];
        //        [self.btnJieMi setHidden:NO];
        //        [self.lblBottom setFrame:CGRectMake(0, self.btnCall.bottom + k360Width(10), self.viewCont.width, k360Width(40))];
        
        //        isShowLeave; //是否显示请假按钮 显示 true 不显示false
        if (![self.mWY_ExpertModel.isShowLeave boolValue]) {
            //后台接口没有- 暂时不上 - 2025-07-02 13:39:06
            //现在要上了 - 2025-08-07 09:04:47
            [self.btnCall1 setHidden:YES];
        } else {
            [self.btnCall1 setHidden:NO];
        }
        [self.btnHandleCA setHidden:NO];
        
//        if(![self.mWY_ExpertModel.isNeedHandleCA isEqualToString:@"1"]) {
//            [self.btnHandleCA setUserInteractionEnabled:NO];
//            [self.btnHandleCA setBackgroundColor:[UIColor grayColor]];
////             [self.lblBottom setFrame:CGRectMake(0, self.btnCall.bottom + k360Width(10), self.viewCont.width, k360Width(40))];
//        } else {
            [self.btnHandleCA setUserInteractionEnabled:YES];
            [self.btnHandleCA setBackgroundColor:MSTHEMEColor];
//        }
                
        [self.lblBottomA setFrame:CGRectMake(k360Width(10), self.btnCall.bottom + k360Width(5), self.viewCont.width - k360Width(20), k360Width(40))];

        if (self.mWY_ExpertModel.platformContent != nil && ![self.mWY_ExpertModel.platformContent isEqual:[NSNull null]]) {
            [self.lblBottomA setText:self.mWY_ExpertModel.platformContent];
            [self.lblBottomA setNumberOfLines:0];
            [self.lblBottomA setLineBreakMode:NSLineBreakByWordWrapping];
            [self.lblBottomA sizeToFit];
            self.lblBottomA.height += k360Width(10);
            [self.lblBottom setFrame:CGRectMake(0, self.lblBottomA.bottom + k360Width(5), self.viewCont.width, k360Width(40))];
            [self.lblBottomA setHidden:NO];

        } else {
            [self.lblBottomA setHidden:YES];
            [self.lblBottom setFrame:CGRectMake(0, self.btnCall.bottom + k360Width(10), self.viewCont.width, k360Width(40))];
        }
        

        
        self.lblBottom.text = self.mWY_ExpertModel.message;
        [self.lblBottom setNumberOfLines:0];
        //        [self.lblBottom sizeToFit];
        //        self.lblBottom.height += k360Width(10);
        [self.lblBottom setHidden:NO];
        self.viewCont.height = self.lblBottom.bottom;
    } else {
        
        
        [self.lblBottom setHidden:YES];
        
        //        if ([self.mWY_ExpertModel.canRate isEqualToString:@"1"] && [self.mWY_ExpertModel.beRated isEqualToString:@"0"]) {
        // -显示评论按钮 -
        [self.btnPingJia setFrame:CGRectMake(k375Width(280-20), lastY + k360Width(10), k375Width(20+44), k375Width(30))];
        [self.btnPingJia setTitle:@"查看评价" forState:UIControlStateNormal];
        [self.btnPingJia addTarget:self action:@selector(btnPingJiaAction) forControlEvents:UIControlEventTouchUpInside];
        [self.btnPingJia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnPingJia.titleLabel setFont:WY_FONTMedium(14)];
        [self.btnPingJia setBackgroundColor:MSTHEMEColor];
        [self.btnPingJia rounded:k375Width(30/4)];
        [self.btnPingJia setHidden:NO];
        self.viewCont.height = self.btnPingJia.bottom + k360Width(10);
        //        } else if ([self.mWY_ExpertModel.beRated isEqualToString:@"1"]) {
        //            //显示 我的评论按钮
        //            [self.btnPingJia setFrame:CGRectMake(k375Width(280-30), lastY + k360Width(10), k375Width(30+44), k375Width(30))];
        //            [self.btnPingJia setTitle:@"我的评价" forState:UIControlStateNormal];
        //            [self.btnPingJia addTarget:self action:@selector(btnMyPingJiaAction) forControlEvents:UIControlEventTouchUpInside];
        //            [self.btnPingJia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //            [self.btnPingJia.titleLabel setFont:WY_FONTMedium(14)];
        //            [self.btnPingJia setBackgroundColor:MSTHEMEColor];
        //            [self.btnPingJia rounded:k375Width(30/4)];
        //            [self.btnPingJia setHidden:NO];
        //            self.viewCont.height = self.btnPingJia.bottom + k360Width(10);
        //        } else {
        //            //            隐藏评论按钮
        //            [self.btnPingJia setHidden:YES];
        //             self.viewCont.height = lastY + k360Width(10);
        //        }
        
        if ([self.mWY_ExpertModel.isRated isEqualToString:@"1"]) {
            //显示 我的评论按钮
            [self.btnDLPingJia setFrame:CGRectMake(k375Width(280-110), lastY + k360Width(10), k375Width(110+44), k375Width(30))];
            [self.btnDLPingJia setTitle:@"查看代理对我的评价" forState:UIControlStateNormal];
            [self.btnDLPingJia addTarget:self action:@selector(btnDLPingJiaAction) forControlEvents:UIControlEventTouchUpInside];
            [self.btnDLPingJia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnDLPingJia.titleLabel setFont:WY_FONTMedium(14)];
            [self.btnDLPingJia setBackgroundColor:MSTHEMEColor];
            [self.btnDLPingJia rounded:k375Width(30/4)];
            [self.btnDLPingJia setHidden:NO];
            
            self.btnPingJia.left = self.btnDLPingJia.left - self.btnPingJia.width - k360Width(5);
            self.viewCont.height = self.btnDLPingJia.bottom + k360Width(10);
            
        } else {
            [self.btnDLPingJia setHidden:YES];
        }
        
        //历史项目
        //        [self.lblBottom setHidden:YES];
        //        self.viewCont.height = lastY + k360Width(10);
    }
    
    
    //2023-11-17 11:14:29 - 因后台系统没弄完 暂时先隐藏项目云签章入口
//    [self.btnHandleCA setHidden:YES];

    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}

//历史-Cell
- (void)showCellLSByItem:(WY_ExpertModel *)withWY_ExpertModel{
    self.mWY_ExpertModel = withWY_ExpertModel;
    if (self.mWY_ExpertModel.createtime.length > 19) {
        self.lblTitle.text = [self.mWY_ExpertModel.createtime substringToIndex:19];
        
    } else {
        self.lblTitle.text = self.mWY_ExpertModel.createtime;
        
    }
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.lblTitle] && ![viewT isEqual:self.lblBottom] && ![viewT isEqual:self.btnCall] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnPingJia] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnDLPingJia]) {
            [viewT removeFromSuperview];
        }
    }
    lastY = self.lblTitle.bottom;
    
    UIImageView *imgType = [UIImageView new];
    [imgType setFrame:CGRectMake(0, 0, k375Width(53), k375Width(53))];
    [self.viewCont addSubview:imgType];
    if ([self.mWY_ExpertModel.status isEqualToString:@"1"] && [self.mWY_ExpertModel.bidSectionState isEqualToString:@"1"] ) {
        //待评
        [imgType setImage:[UIImage imageNamed:@"0701_yqr"]];
        [imgType setHidden:NO];
    } else if ([self.mWY_ExpertModel.status isEqualToString:@"2"]) {
        //历史
        //        [imgType setImage:[UIImage imageNamed:@"lsxm"]];
        [imgType setHidden:YES];
    } else{
        [imgType setHidden:YES];
    }
    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:self.mWY_ExpertModel.name isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"标段名称：" byLabelStr:self.mWY_ExpertModel.bidSectionName isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"招 标 人：" byLabelStr:self.mWY_ExpertModel.tendereeName isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"代理机构：" byLabelStr:self.mWY_ExpertModel.daili isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"评标时间：" byLabelStr:self.mWY_ExpertModel.pbTime isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"评标地点：" byLabelStr:self.mWY_ExpertModel.pbAddress isAcc:NO withBlcok:nil];
    //2023-11-17 09:32:51add - 历史记录增加 集合时间、签到状态、签到时间显示
    if (self.mWY_ExpertModel.time.length > 16) {
        [self  byReturnColCellTitle:@"集合时间：" byLabelStr:[self.mWY_ExpertModel.time substringToIndex:16] isAcc:NO withBlcok:nil];
    } else {
        [self  byReturnColCellTitle:@"集合时间：" byLabelStr:self.mWY_ExpertModel.time isAcc:NO withBlcok:nil];
    }
    if ([self.mWY_ExpertModel.signFlag isEqualToString:@"1"]) {
        [self  byReturnColCellTitle:@"签到状态：" byLabelStr:@"正常签到" isAcc:NO withBlcok:nil];
        [self  byReturnColCellTitle:@"签到时间：" byLabelStr:self.mWY_ExpertModel.signTime isAcc:NO withBlcok:nil];
    }else  if ([self.mWY_ExpertModel.signFlag isEqualToString:@"2"]) {
        [self  byReturnColCellTitle:@"签到状态：" byLabelStr:@"迟到签到" isAcc:NO withBlcok:nil];
        [self  byReturnColCellTitle:@"签到时间：" byLabelStr:self.mWY_ExpertModel.signTime isAcc:NO withBlcok:nil];
    } else if ([self.mWY_ExpertModel.leaveFlag boolValue]) {
        [self  byReturnColCellTitle:@"签到状态：" byLabelStr:@"请假" isAcc:NO withBlcok:nil];
    } else {
        [self  byReturnColCellTitle:@"签到状态：" byLabelStr:@"未签到" isAcc:NO withBlcok:nil];
    }
    
    
    
 
    [self.lblBottom setHidden:YES];
    
    //        if ([self.mWY_ExpertModel.canRate isEqualToString:@"1"] && [self.mWY_ExpertModel.beRated isEqualToString:@"0"]) {
    // -显示评论按钮 -
    [self.btnPingJia setFrame:CGRectMake(k375Width(280-20), lastY + k360Width(10), k375Width(20+44), k375Width(30))];
    [self.btnPingJia setTitle:@"查看评价" forState:UIControlStateNormal];
    [self.btnPingJia addTarget:self action:@selector(btnPingJiaAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPingJia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPingJia.titleLabel setFont:WY_FONTMedium(12)];
    [self.btnPingJia setBackgroundColor:MSTHEMEColor];
    [self.btnPingJia rounded:k375Width(30/8)];
    [self.btnPingJia setHidden:NO];
    
    if ([self.mWY_ExpertModel.deductionCount intValue] > 0) {
        [self.btnPingJia setHidden:NO];
        self.viewCont.height = self.btnPingJia.bottom + k360Width(10);
        //未读数
        if ([self.mWY_ExpertModel.unReadDeductionCount intValue] > 0) {
            badgeSuperView = [[UIView alloc] initWithFrame:self.btnPingJia.frame];
            [badgeSuperView setUserInteractionEnabled:NO];
            [self.viewCont addSubview:badgeSuperView];
            [badgeSuperView setBackgroundColor:[UIColor clearColor]];
            badgeView = [[M13BadgeView alloc] init];
            badgeSuperView.left = self.btnPingJia.right;
            badgeView.text = self.mWY_ExpertModel.unReadDeductionCount;//self.mWY_ExpertModel.deductionCount;
            [badgeSuperView addSubview:badgeView];
        }
        
    } else {
        [self.btnPingJia setHidden:YES];
        self.viewCont.height = self.btnPingJia.top + k360Width(10);
    }
    
    //        } else if ([self.mWY_ExpertModel.beRated isEqualToString:@"1"]) {
    //            //显示 我的评论按钮
    //            [self.btnPingJia setFrame:CGRectMake(k375Width(280-30), lastY + k360Width(10), k375Width(30+44), k375Width(30))];
    //            [self.btnPingJia setTitle:@"我的评价" forState:UIControlStateNormal];
    //            [self.btnPingJia addTarget:self action:@selector(btnMyPingJiaAction) forControlEvents:UIControlEventTouchUpInside];
    //            [self.btnPingJia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //            [self.btnPingJia.titleLabel setFont:WY_FONTMedium(14)];
    //            [self.btnPingJia setBackgroundColor:MSTHEMEColor];
    //            [self.btnPingJia rounded:k375Width(30/4)];
    //            [self.btnPingJia setHidden:NO];
    //            self.viewCont.height = self.btnPingJia.bottom + k360Width(10);
    //        } else {
    //            //            隐藏评论按钮
    //            [self.btnPingJia setHidden:YES];
    //             self.viewCont.height = lastY + k360Width(10);
    //        }
    
    if ([self.mWY_ExpertModel.isRated isEqualToString:@"1"]) {
        //显示 我的评论按钮
        [self.btnDLPingJia setFrame:CGRectMake(k375Width(280-110), lastY + k360Width(10), k375Width(110+44), k375Width(30))];
        [self.btnDLPingJia setTitle:@"查看代理对我的评价" forState:UIControlStateNormal];
        [self.btnDLPingJia addTarget:self action:@selector(btnDLPingJiaAction) forControlEvents:UIControlEventTouchUpInside];
        [self.btnDLPingJia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnDLPingJia.titleLabel setFont:WY_FONTMedium(14)];
        [self.btnDLPingJia setBackgroundColor:MSTHEMEColor];
        [self.btnDLPingJia rounded:k375Width(30/4)];
        [self.btnDLPingJia setHidden:NO];
        
        self.btnPingJia.left = self.btnDLPingJia.left - self.btnPingJia.width - k360Width(5);
        self.viewCont.height = self.btnDLPingJia.bottom + k360Width(10);
        
    } else {
        [self.btnDLPingJia setHidden:YES];
    }
    
    
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}

//申诉-Cell
- (void)showCellSSByItem:(WY_ExpertModel *)withWY_ExpertModel{
    self.mWY_ExpertModel = withWY_ExpertModel;
    if (self.mWY_ExpertModel.createtime.length > 19) {
        self.lblTitle.text = [self.mWY_ExpertModel.createtime substringToIndex:19];
        
    } else {
        self.lblTitle.text = self.mWY_ExpertModel.createtime;
        
    }
    for (UIView *viewT in self.viewCont.subviews) {
        if (![viewT isEqual:self.lblTitle] && ![viewT isEqual:self.lblBottom] && ![viewT isEqual:self.btnCall] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnPingJia] && ![viewT isEqual:self.btnJieMi] && ![viewT isEqual:self.btnDLPingJia]) {
            [viewT removeFromSuperview];
        }
    }
    lastY = self.lblTitle.bottom;
    
    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:self.mWY_ExpertModel.projectName isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"标段名称：" byLabelStr:self.mWY_ExpertModel.bidSectionName isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"申诉条目：" byLabelStr:self.mWY_ExpertModel.deductionName isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"申诉时间：" byLabelStr:self.mWY_ExpertModel.evaluateTime isAcc:NO withBlcok:nil];
    //appealStatus  /0未读  1已读  2申诉中 3申诉成功 4申诉失败 5二次申诉 6二次申诉成功 7二次申诉失败
    switch ([self.mWY_ExpertModel.appealStatus intValue]) {
        case 0:
        {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"未读" isAcc:NO withBlcok:nil];
            
        }
            break;
        case 1:
        {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"已读" isAcc:NO withBlcok:nil];
            
        }
            break;
        case 2:
        {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"申诉中" isAcc:NO withBlcok:nil];
        }
            break;
        case 3:
        {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"申诉成功" isAcc:NO withBlcok:nil];
        }
            break;
        case 4:
        {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"申诉失败" isAcc:NO withBlcok:nil];
        }
            break;
        case 5:
        {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"二次申诉中" isAcc:NO withBlcok:nil];
        }
            break;
        case 6:
        {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"二次申诉成功" isAcc:NO withBlcok:nil];
        }
            break;
        case 7:
        {
            [self  byReturnColCellTitle:@"申诉状态：" byLabelStr:@"二次申诉失败" isAcc:NO withBlcok:nil];
        }
            break;
        default:
            break;
    }
    
    
    [self.lblBottom setHidden:YES];
    
    //        if ([self.mWY_ExpertModel.canRate isEqualToString:@"1"] && [self.mWY_ExpertModel.beRated isEqualToString:@"0"]) {
    // -显示评论按钮 -
    [self.btnPingJia setFrame:CGRectMake(k375Width(280-20), lastY + k360Width(10), k375Width(20+44), k375Width(30))];
    [self.btnPingJia setTitle:@"查看申诉" forState:UIControlStateNormal];
    [self.btnPingJia addTarget:self action:@selector(btnPingJiaAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPingJia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPingJia.titleLabel setFont:WY_FONTMedium(12)];
    [self.btnPingJia setBackgroundColor:MSTHEMEColor];
    [self.btnPingJia rounded:k375Width(30/8)];
    [self.btnPingJia setHidden:NO];
    self.viewCont.height = self.btnPingJia.bottom + k360Width(10);
    
    
    [self.btnDLPingJia setHidden:YES];
    
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}



- (void)btnCallAction {
    if (self.leavePhoneBlock) {
        self.leavePhoneBlock(self.mWY_ExpertModel);
    }
}
- (void)btnCall1Action {
    NSLog(@"在线请假");
    if (self.btnOnlineLeaveBlock) {
        self.btnOnlineLeaveBlock(self.mWY_ExpertModel);
    }
}
- (void)btnHandleCAAction{
    //办理临时云签章
    NSLog(@"办理临时云签章");
     
    
    
    if (self.btnHandleCABlock) {
        self.btnHandleCABlock(self.mWY_ExpertModel);
    }
}
- (void)btnJieMiAction {
        self.btnDecryptBlock(self.mWY_ExpertModel);
    if (self.btnDecryptBlock) {
    }
}

- (void)btnPingJiaAction {
    if (self.btnPingJiaBlock) {
        self.btnPingJiaBlock(self.mWY_ExpertModel);
    }
}
- (void)btnMyPingJiaAction {
    if (self.btnMyPingJiaBlock) {
        self.btnMyPingJiaBlock(self.mWY_ExpertModel);
    }
}


- (void)btnDLPingJiaAction {
    NSLog(@"点击了 查看代理对我的评价按钮");
    if (self.btnDLPingJiaBlock) {
        self.btnDLPingJiaBlock(self.mWY_ExpertModel);
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
