//
//  WY_PerfectListTableViewCell.m
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_PerfectListTableViewCell.h"

@implementation WY_PerfectListTableViewCell
{
    int lastY;
    UILabel *lblTiShi;
    UIButton *btnTongBu;
    UILabel *lblTongBuTs;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
     }
    return self;
}
 

-(void)addSubViews{
    self.rightLab = [UILabel new];
    self.titleLab = [UILabel new];
    self.jujueTitle = [UILabel new];
    self.jujueContent = [UILabel new];
    self.logoImg = [UIImageView new];
    self.rImg = [UIImageView new];
    self.lineView = [UIImageView new];
    self.lineView2 = [UIImageView new];
    btnTongBu = [UIButton new];
    lblTongBuTs = [UILabel new];
    
    [self.contentView addSubview:self.logoImg];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.rImg];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.lineView2];

    [self.contentView addSubview:self.rightLab];
    [self.contentView addSubview:self.jujueTitle];
    [self.contentView addSubview:self.jujueContent];
    [self.contentView addSubview:btnTongBu];
    [self.contentView addSubview:lblTongBuTs];
    
//    1市级核验 2培训考试 3省级核验（预备库） 4正式专家
    self.stepView = [XFStepView new];
    [self addSubview:self.stepView];
    [self.stepView setHidden:YES];
    
    lblTiShi = [UILabel new];
    [lblTiShi setFrame:CGRectMake(k360Width(16), k360Width(10), kScreenWidth - k360Width(32), k360Width(30))];
    [self.contentView addSubview:lblTiShi];
    [lblTiShi setHidden:YES];
    
    self.viewStepVertical = [UIView new];
    [self addSubview:self.viewStepVertical];
    [self.viewStepVertical setHidden:YES];
    
    self.curZyView = [UIView new];
    [self addSubview:self.curZyView];
    [self.curZyView setHidden:YES];

}

- (void)showZHCellByItem:(NSMutableDictionary *)withDic {
    NSMutableArray *arrTitles = [NSMutableArray new];
    if (withDic[@"nodes"] != nil && ![withDic[@"nodes"] isEqual:[NSNull null]]) {
        for (NSDictionary *itemDic in withDic[@"nodes"]) {
            [arrTitles addObject:itemDic[@"name"]];
        }
        if (self.stepView) {
            [self.stepView removeFromSuperview];
        }
        self.stepView = [[XFStepView alloc]initWithFrame:CGRectMake(0, k360Width(10), kScreenWidth, 60) Titles:arrTitles];
        [self addSubview:self.stepView];
        [self.stepView setHidden:YES];
        
        
       [lblTiShi setFrame:CGRectMake(k360Width(16), k360Width(10), kScreenWidth - k360Width(32), k360Width(30))];
        [self.contentView addSubview:lblTiShi];
        [lblTiShi setNumberOfLines:0];
        [lblTiShi setLineBreakMode:NSLineBreakByWordWrapping];
        [lblTiShi setHidden:NO];
        
        NSMutableAttributedString *attTs = [[NSMutableAttributedString alloc] initWithString:@"专家核验流程："];
        [attTs setYy_font:WY_FONTMedium(14)];
        [attTs setYy_color:HEXCOLOR(0x000000)];
        
        if ([withDic[@"tips"] isNotBlank]) {
            NSMutableAttributedString *attTs1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",withDic[@"tips"]]];
            [attTs1 setYy_color:HEXCOLOR(0xda7a48)];
            [attTs appendAttributedString:attTs1];
            [attTs1 setYy_font:WY_FONTRegular(12)];
        }
        [lblTiShi setAttributedText:attTs];
        
        [lblTiShi sizeToFit];
        lblTiShi.height += 10;
        //新加了个竖着的。
        
        if (self.viewStepVertical) {
            [self.viewStepVertical removeFromSuperview];
        }
        self.viewStepVertical = [[UIView alloc]initWithFrame:CGRectMake(0, lblTiShi.bottom + k360Width(10), kScreenWidth, 60)];
        [self addSubview:self.viewStepVertical];
//        [self.viewStepVertical setBackgroundColor:[UIColor redColor]];
        
         if (withDic[@"node"] != nil && ![withDic[@"node"] isEqual:[NSNull null]]) {
            lastY = 0;
            int i = 0;
            for (NSDictionary *itemDic in withDic[@"node"]) {
                
                [self initAddItemByDic:itemDic byNum:i];
                i ++;
            }
        }
        
        self.viewStepVertical.height = lastY;
        
        if (self.curZyView) {
            [self.curZyView removeFromSuperview];
        }
        self.curZyView = [[UIControl alloc]initWithFrame:CGRectMake(0, self.viewStepVertical.bottom + k360Width(10), kScreenWidth, 60)];
        [self addSubview:self.curZyView];
        if (self.arrZyData.count == 0) {
            [self.curZyView setHidden:YES];
            [self.curZyView setHeight:0];
        } else {
            [self.curZyView addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                NSLog(@"点击了查看更多");
                if (self.selDidMoreBlock) {
                    self.selDidMoreBlock();
                }
            }];
            
            UILabel *lblCurZyTitle =[UILabel new];
            lblCurZyTitle.text = @"当前可抽取的专业：";
            [lblCurZyTitle setFont:WY_FONTRegular(14)];
            [lblCurZyTitle setFrame:CGRectMake(k360Width(15), k360Width(5), kScreenWidth - k360Width(30), k360Width(30))];
            [lblCurZyTitle setTextColor:HEXCOLOR(0x666666)];
            [self.curZyView addSubview:lblCurZyTitle];
            
            UILabel *lblCurZyContent = [UILabel new];
            [lblCurZyContent setFrame:CGRectMake(k360Width(15), lblCurZyTitle.bottom + k360Width(5), kScreenWidth - k360Width(30) - k360Width(80), k360Width(30))];
            NSMutableAttributedString *attrCz = [[NSMutableAttributedString alloc] initWithString:@""];
            int i = 0;
            for (NSString *titleStr in self.arrZyData) {
                NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
                if  (i < self.arrZyData.count - 1) {
                    [attStr1 yy_appendString:@"\n"];
                }
                
                [attStr1 setYy_color:MSTHEMEColor];
                [attStr1 setYy_font:WY_FONTMedium(16)];
                [attrCz appendAttributedString:attStr1];
                i ++;
            }
            [attrCz setYy_lineSpacing:5];
            [lblCurZyContent setAttributedText:attrCz];
            [lblCurZyContent setLineBreakMode:NSLineBreakByWordWrapping];
            [lblCurZyContent setNumberOfLines:0];
            [lblCurZyContent sizeToFit];
            lblCurZyContent.height += 10;
            [self.curZyView addSubview:lblCurZyContent];

            
            
            [lblCurZyContent setAttributedText:attrCz];

            
            
            UILabel *lblMore = [UILabel new];
            [lblMore setFrame:CGRectMake(kScreenWidth - k360Width(15 + 80 + 20), k360Width(10), k360Width(80), k360Width(30))];
            [lblMore setFont:WY_FONTRegular(12)];
            [lblMore setTextColor:HEXCOLOR(0x333333)];
            [lblMore setTextAlignment:NSTextAlignmentRight];
            [lblMore setCenterY:lblCurZyContent.centerY];
            [lblMore setText:@"更多记录"];
            [self.curZyView addSubview:lblMore];
            
            UIImageView *imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
            [imgAcc setImage:[UIImage imageNamed:@"accup"]];
            [imgAcc setCenterY:lblCurZyContent.centerY];

            [self.curZyView addSubview:imgAcc];
            
            UIImageView *imgLine = [UIImageView new];
            [imgLine setBackgroundColor:APPLineColor];
            [imgLine setFrame:CGRectMake(0, lblCurZyContent.bottom + k360Width(12) - 1, kScreenWidth, 1)];
            [self.curZyView addSubview:imgLine];
            
            self.curZyView.height = lblCurZyContent.bottom + k360Width(12);
        }
         
        lastY = self.curZyView.bottom;
        
        //续聘相关-
        NSMutableDictionary *itemDic  = [NSMutableDictionary new];
        [itemDic setObject:@"续聘信息" forKey:@"name"];

        //        renewal_status
//        0.无需续聘
//        1.待续聘
//        2.待审核
//        3.续聘完成
//        如果续聘被拒绝 变成 待续聘
        
//        renewalFlag 续聘标识：0=不需要,1=需要续聘
      
            switch ([withDic[@"renewalStatus"] intValue]) {
                case 0:
                    {
                        [itemDic setObject:@"无需续聘" forKey:@"result"];
                        [itemDic setObject:@"0" forKey:@"state"];
                       
                    }
                    break;
                case 1:
                    {
                        [itemDic setObject:@"待续聘" forKey:@"result"];
                        [itemDic setObject:@"1" forKey:@"state"];
                        
                    }
                    break;
                case 2:
                    {
                        [itemDic setObject:@"待审核" forKey:@"result"];
                        [itemDic setObject:@"2" forKey:@"state"];
                        
                    }
                    break;
                case 3:
                    {
                        [itemDic setObject:@"续聘完成" forKey:@"result"];
                        [itemDic setObject:@"3" forKey:@"state"];
                        
                    }
                    break;
                default:
                {
                    [itemDic setObject:withDic[@"renewalStatus"] forKey:@"result"];
                    [itemDic setObject:@"0" forKey:@"state"];
                }
                    break;
            }
        for (UIView *viewa in self.contentView.subviews ) {
            if (viewa.tag == 1203) {                
                [viewa removeFromSuperview];
            }
        }
        [self initAddItemByDic:itemDic byNum:5];
        lastY += 10;
        
        [self.lineView2 setFrame:CGRectMake(0, lastY - k360Width(1), kScreenWidth, k360Width(1))];
        
        int stepIndex = [withDic[@"currentNode"] intValue] - 1;
          [self.stepView aaasetStepIndex:stepIndex];
         if ([withDic[@"currentNodeStatus"] intValue] == 1) {
            [self.stepView aaaaStepYesIndex:stepIndex];
        } else if ([withDic[@"currentNodeStatus"] intValue] == 2) {
            [self.stepView aaaaStepNoIndex:stepIndex];
        } else {
            
        }
        //1是考试通过
        int testPass = [withDic[@"testPass"] intValue];
        if (testPass == 1) {
            [self.stepView aaaaStepYesIndex:1];
        }
         
        //1是正式入库
        int isFormal = [withDic[@"isFormal"] intValue];
        if (isFormal == 1) {
            [self.stepView aaaaStepYesIndex:3];
        } else if (isFormal == 2) {
            [self.stepView aaaaStepGthIndex:3];
        }
        
        
//        [self.stepView setHidden:NO];
    }
    
    
    self.rImg.image = [UIImage imageNamed:@"servicedetail_btn_in"];
    self.lineView.backgroundColor = APPLineColor;
    self.lineView2.backgroundColor = APPLineColor;
    
    [self.jujueContent setFont:WY_FONTRegular(14)];
    [self.jujueTitle setFont:WY_FONTRegular(14)];
    [self.titleLab setFont:WY_FONTMedium(14)];

    
    int approvalStatusNum = [withDic[@"approvalStatus"] intValue];
    NSString *cellStr = @"";
    
    switch ([withDic[@"source"] intValue]) {
        case 0:
        {
            cellStr = @"内部/测试人员完善信息";
        }
            break;
        case 1:
        {
            cellStr = @"综合库专家完善信息";
        }
            break;
        case 2:
        {
            cellStr = @"铁路库专家完善信息";
        }
            break;
        case 3:
        {
            cellStr = @"地铁库专家完善信息";
        }
            break;
        
        default:
            break;
    }

    
    [self.logoImg setFrame:CGRectMake(k360Width(24), lastY, k360Width(26), k360Width(26))];
     [self.titleLab setFrame:CGRectMake(self.logoImg.right + k360Width(10), lastY, kScreenWidth - k360Width(28) - self.logoImg.right, k360Width(44))];
    [self.rImg setFrame:CGRectMake(kScreenWidth - k360Width(34), k360Width(16), k360Width(22), k360Width(22))];
    self.rImg.centerY = self.titleLab.centerY;
    self.logoImg.centerY = self.titleLab.centerY;
    [self.rightLab setFrame:CGRectMake(kScreenWidth - k360Width(130), k360Width(0), k360Width(82), k360Width(22))];
    
    [self.rightLab setHidden:NO];
    [self.rightLab rounded:k360Width(22/2)];
    [self.rightLab setTextAlignment:NSTextAlignmentCenter];
    [self.rightLab setFont:WY_FONTRegular(14)];
    
    self.rightLab.centerY = self.titleLab.centerY;

    
    /*
     0   没完善过    可以完善；
     1   待核验 - 不可以完善；
     2   行业监管核验通过；不可以完善；
     3   市发改委核验通过；   不可以完善；
     4   省发改委核验通过；   不可以完善；
     5   资质不符        不可以完善；
     6   资料不全        可以完善；
     7   您还不具有完善信息资格
     */
    if  (approvalStatusNum == 1 || approvalStatusNum == 2 || approvalStatusNum == 3) {
        [self.rightLab setBackgroundColor:HEXCOLOR(0xffefdd)];
        [self.rightLab setTextColor:HEXCOLOR(0xFFA360)];
        [self.rightLab setText:@"审核中"];
    }  else if  (approvalStatusNum == 4) {
        [self.rightLab setBackgroundColor:HEXCOLOR(0x0CC4B9)];
        [self.rightLab setTextColor:HEXCOLOR(0xFFFFFF)];
        [self.rightLab setText:@"审核成功"];
    }else if  (approvalStatusNum == 5 || approvalStatusNum == 6 ) {
        
        [self.rightLab setBackgroundColor:HEXCOLOR(0xAAAAAA)];
        [self.rightLab setTextColor:HEXCOLOR(0x000000)];
        [self.rightLab setText:@"审核失败"];
    }else if  (approvalStatusNum == 0 ) {
        [self.rightLab setBackgroundColor:HEXCOLOR(0xD90000)];
        [self.rightLab setTextColor:HEXCOLOR(0xFFFFFF)];
        [self.rightLab setText:@"需完善"];
    } else if  (approvalStatusNum == 10) {
        [self.rightLab setBackgroundColor:HEXCOLOR(0xAAAAAA)];
        [self.rightLab setTextColor:HEXCOLOR(0x000000)];
        [self.rightLab setText:@"部分通过"];
    }else if  (approvalStatusNum == 7 ) {
        [self.rightLab setHidden:YES];
        
    }else {
        [self.rightLab setHidden:YES];
    }

    
    [self.titleLab setText:cellStr];
     [self.logoImg sd_setImageWithURL:[NSURL URLWithString:withDic[@"imgUrl"]]];

    int tlastY = 0;
    if (approvalStatusNum ==5 || approvalStatusNum == 6 || approvalStatusNum == 10) {
        [self.jujueTitle setHidden:NO];
        [self.jujueContent setHidden:NO];
        
        [self.jujueTitle setText:@"失败原因："];
        [self.jujueTitle setFrame:CGRectMake(k360Width(16), self.titleLab.bottom + k360Width(10), k360Width(80), k360Width(44))];
        [self.jujueContent setFrame:CGRectMake(self.jujueTitle.right, self.jujueTitle.top, kScreenWidth - self.jujueTitle.right - k360Width(32), k360Width(44))];
        
        if (withDic[@"approvalInfo"] !=nil && ![withDic[@"approvalInfo"] isEqual:[NSNull null]]) {
            [self.jujueContent setText:withDic[@"approvalInfo"]];
        } else {
            [self.jujueContent setText:@"无"];
        }
        [self.jujueContent setNumberOfLines:0];
        [self.jujueContent sizeToFit];
        self.jujueContent.height += k360Width(12);
        self.jujueTitle.centerY = self.jujueContent.centerY;
        
        tlastY = self.jujueContent.bottom + k360Width(5);
        
//        self.height = self.jujueContent.bottom + k360Width(5);
//        [self.lineView setFrame:CGRectMake(0, self.height - k360Width(1), kScreenWidth, k360Width(1))];
    } else {
        [self.jujueTitle setHidden:YES];
        [self.jujueContent setHidden:YES];
        tlastY = self.titleLab.bottom;
//        self.height = self.titleLab.bottom;
//         [self.lineView setFrame:CGRectMake(0, self.height - k360Width(1), kScreenWidth, k360Width(1))];
    }
 
    if (![withDic[@"isSync"] isEqual:[NSNull null]] && [withDic[@"isSync"] boolValue]) {
        [btnTongBu setTitle:@"同步专家库信息" forState:UIControlStateNormal];
        [btnTongBu setFrame:CGRectMake(k360Width(16), tlastY, kScreenWidth - k360Width(32), k360Width(36))];
        [btnTongBu rounded:k360Width(36 / 8)];
        [btnTongBu setBackgroundColor:MSTHEMEColor];
        [btnTongBu addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            zj_syncExpertData_HTTP
            if (self.syncExpertData) {
                self.syncExpertData();
            }
            
        }];
        [lblTongBuTs setText:@"*点击按钮后APP中专家信息将与专家库信息同步"];
        [lblTongBuTs setFrame:CGRectMake(k360Width(16), btnTongBu.bottom, kScreenWidth - k360Width(32), k360Width(30))];
        [lblTongBuTs setTextAlignment:NSTextAlignmentCenter];
        [lblTongBuTs setFont:WY_FONTMedium(12)];
        [lblTongBuTs setTextColor:[UIColor redColor]];
        self.height = lblTongBuTs.bottom;
         [self.lineView setFrame:CGRectMake(0, self.height - k360Width(1), kScreenWidth, k360Width(1))];
        
        [btnTongBu setHidden:NO];
         [lblTongBuTs setHidden:NO];
    } else {
        [btnTongBu setHidden:YES];
         [lblTongBuTs setHidden:YES];
        self.height = tlastY;
         [self.lineView setFrame:CGRectMake(0, self.height - k360Width(1), kScreenWidth, k360Width(1))];
    }
   
    
}

- (void)initAddItemByDic:(NSDictionary *)withDic byNum:(int)numA {
    UIView *viewT = [UIView new];
    viewT.tag = 1203;
    [viewT setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), k360Width(44))];
    [viewT rounded:k360Width(44/8) width:1 color: APPLineColor];
    UILabel *lblNum = [UILabel new];
    UILabel *lblTitle = [UILabel new];
    UILabel *lblState = [UILabel new];
    [lblNum setFrame:CGRectMake(k360Width(10), 0, k360Width(20),k360Width(20))];
    [lblTitle setFrame:CGRectMake(lblNum.right + k360Width(10), 0, k360Width(200), viewT.height)];
    [lblState setFrame:CGRectMake(kScreenWidth -  k360Width(20+ 96), 0, k360Width(80), viewT.height)];
    [lblState setTextAlignment:NSTextAlignmentRight];
    
    [lblNum setCenterY:lblState.centerY];
    [lblNum setText:[NSString stringWithFormat:@"%d",numA+1]];
    [lblNum rounded:k360Width(20/2) width:2 color:HEXCOLOR(0xa6c2fa)];
    [lblNum setBackgroundColor:MSTHEMEColor];
    [lblNum setTextColor:[UIColor whiteColor]];
    [lblNum setFont:WY_FONTMedium(14)];
    [lblNum setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setText:withDic[@"name"]];
    [lblState setText:withDic[@"result"]];
    [lblTitle setFont:WY_FONTRegular(14)];
    [lblState setFont:WY_FONTRegular(14)];
    switch ([withDic[@"state"] intValue]) {
        case 0:
            [lblState setTextColor:HEXCOLOR(0x000000)];
            break;
        case 1:
            [lblState setTextColor:HEXCOLOR(0x00CC66)];
            break;
        case 2:
            [lblState setTextColor:HEXCOLOR(0xc23431)];
            break;
        case 3:
            [lblState setTextColor:HEXCOLOR(0x448eed)];
            break;
        default:
            [lblState setTextColor:HEXCOLOR(0x000000)];
            break;
    }
    
    [viewT addSubview:lblTitle];
    [viewT addSubview:lblNum];
    [viewT addSubview:lblState];
    if (numA == 5) {
        [self.contentView addSubview:viewT];
    } else {
        [self.viewStepVertical addSubview:viewT];
    }
    lastY = viewT.bottom;
}

- (void)showCellByItem:(NSMutableDictionary *)withDic {
    if (self.stepView) {
        [self.stepView removeFromSuperview];
    }
    if (self.viewStepVertical) {
        [self.viewStepVertical removeFromSuperview];
    }
    if (self.curZyView) {
        [self.curZyView removeFromSuperview];
    }
    
    self.rImg.image = [UIImage imageNamed:@"servicedetail_btn_in"];
    self.lineView.backgroundColor = APPLineColor;
    self.lineView2.backgroundColor = APPLineColor;
    [self.jujueContent setFont:WY_FONTRegular(14)];
    [self.jujueTitle setFont:WY_FONTRegular(14)];
    [self.titleLab setFont:WY_FONTMedium(14)];

    
    int approvalStatusNum = [withDic[@"approvalStatus"] intValue];
    NSString *cellStr = @"";
    
    switch ([withDic[@"source"] intValue]) {
        case 0:
        {
            cellStr = @"内部/测试人员完善信息";
        }
            break;
        case 1:
        {
            cellStr = @"综合库专家完善信息";
        }
            break;
        case 2:
        {
            cellStr = @"铁路库专家完善信息";
        }
            break;
        case 3:
        {
            cellStr = @"地铁库专家完善信息";
        }
            break;
        
        default:
            break;
    }

    
    [self.logoImg setFrame:CGRectMake(k360Width(24), k360Width(10), k360Width(26), k360Width(26))];
     [self.titleLab setFrame:CGRectMake(self.logoImg.right + k360Width(10), k360Width(0), kScreenWidth - k360Width(28) - self.logoImg.right, k360Width(44))];
    [self.rImg setFrame:CGRectMake(kScreenWidth - k360Width(34), k360Width(16), k360Width(22), k360Width(22))];
    self.rImg.centerY = self.titleLab.centerY;
    self.logoImg.centerY = self.titleLab.centerY;
    [self.rightLab setFrame:CGRectMake(kScreenWidth - k360Width(130), k360Width(0), k360Width(82), k360Width(22))];
    
    [self.rightLab setHidden:NO];
    [self.rightLab rounded:k360Width(22/2)];
    [self.rightLab setTextAlignment:NSTextAlignmentCenter];
    [self.rightLab setFont:WY_FONTRegular(14)];
    
    self.rightLab.centerY = self.titleLab.centerY;

    
    /*
     0   没完善过    可以完善；
     1   待核验 - 不可以完善；
     2   行业监管核验通过；不可以完善；
     3   市发改委核验通过；   不可以完善；
     4   省发改委核验通过；   不可以完善；
     5   资质不符        不可以完善；
     6   资料不全        可以完善；
     7 您还不具有完善信息资格
     */
    if  (approvalStatusNum == 1 || approvalStatusNum == 2 || approvalStatusNum == 3) {
        [self.rightLab setBackgroundColor:HEXCOLOR(0xffefdd)];
        [self.rightLab setTextColor:HEXCOLOR(0xFFA360)];
        [self.rightLab setText:@"审核中"];
    }  else if  (approvalStatusNum == 4) {
        [self.rightLab setBackgroundColor:HEXCOLOR(0x0CC4B9)];
        [self.rightLab setTextColor:HEXCOLOR(0xFFFFFF)];
        [self.rightLab setText:@"审核成功"];
    }else if  (approvalStatusNum == 5 || approvalStatusNum == 6 ) {
        
        [self.rightLab setBackgroundColor:HEXCOLOR(0xAAAAAA)];
        [self.rightLab setTextColor:HEXCOLOR(0x000000)];
        [self.rightLab setText:@"审核失败"];
    }else if  (approvalStatusNum == 0 ) {
        [self.rightLab setBackgroundColor:HEXCOLOR(0xD90000)];
        [self.rightLab setTextColor:HEXCOLOR(0xFFFFFF)];
        [self.rightLab setText:@"需完善"];
    } else if  (approvalStatusNum == 10) {
        [self.rightLab setBackgroundColor:HEXCOLOR(0xAAAAAA)];
        [self.rightLab setTextColor:HEXCOLOR(0x000000)];
        [self.rightLab setText:@"部分通过"];
    }else if  (approvalStatusNum == 7 ) {
        [self.rightLab setHidden:YES];
        
    }else {
        [self.rightLab setHidden:YES];
    }

    
    [self.titleLab setText:cellStr];
     [self.logoImg sd_setImageWithURL:[NSURL URLWithString:withDic[@"imgUrl"]]];

    int tlastY = 0;
    if (approvalStatusNum ==5 || approvalStatusNum == 6 || approvalStatusNum == 10) {
        [self.jujueTitle setHidden:NO];
        [self.jujueContent setHidden:NO];
        
        [self.jujueTitle setText:@"失败原因："];
        [self.jujueTitle setFrame:CGRectMake(k360Width(16), self.titleLab.bottom + k360Width(10), k360Width(80), k360Width(44))];
        [self.jujueContent setFrame:CGRectMake(self.jujueTitle.right, self.jujueTitle.top, kScreenWidth - self.jujueTitle.right - k360Width(32), k360Width(44))];
        
        if (withDic[@"approvalInfo"] !=nil && ![withDic[@"approvalInfo"] isEqual:[NSNull null]]) {
            [self.jujueContent setText:withDic[@"approvalInfo"]];
            [self.jujueContent setTextColor:[UIColor redColor]];
        } else {
            [self.jujueContent setText:@"无"];
        }
        [self.jujueContent setNumberOfLines:0];
        [self.jujueContent sizeToFit];
        self.jujueContent.height += k360Width(12);
        self.jujueTitle.centerY = self.jujueContent.centerY;
        tlastY = self.jujueContent.bottom + k360Width(5);
        
//        self.height = self.jujueContent.bottom + k360Width(5);
//        [self.lineView setFrame:CGRectMake(0, self.height - k360Width(1), kScreenWidth, k360Width(1))];
    } else {
        [self.jujueTitle setHidden:YES];
        [self.jujueContent setHidden:YES];
        tlastY = self.titleLab.bottom;
//        self.height = self.titleLab.bottom;
//         [self.lineView setFrame:CGRectMake(0, self.height - k360Width(1), kScreenWidth, k360Width(1))];
    }
    
    if (![withDic[@"isSync"] isEqual:[NSNull null]] && [withDic[@"isSync"] boolValue]) {
        [btnTongBu setTitle:@"同步专家库信息" forState:UIControlStateNormal];
        [btnTongBu setFrame:CGRectMake(k360Width(16), tlastY, kScreenWidth - k360Width(32), k360Width(36))];
        [btnTongBu rounded:k360Width(36 / 8)];
        [btnTongBu setBackgroundColor:MSTHEMEColor];
        [btnTongBu addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            zj_syncExpertData_HTTP
            if (self.syncExpertData) {
                self.syncExpertData();
            }
            
        }];
        [lblTongBuTs setText:@"*点击按钮后APP中专家信息将与专家库信息同步"];
        [lblTongBuTs setFrame:CGRectMake(k360Width(16), btnTongBu.bottom, kScreenWidth - k360Width(32), k360Width(30))];
        [lblTongBuTs setTextAlignment:NSTextAlignmentCenter];
        [lblTongBuTs setFont:WY_FONTMedium(12)];
        [lblTongBuTs setTextColor:[UIColor redColor]];
        self.height = lblTongBuTs.bottom;
         [self.lineView setFrame:CGRectMake(0, self.height - k360Width(1), kScreenWidth, k360Width(1))];
        [btnTongBu setHidden:NO];
         [lblTongBuTs setHidden:NO];
    } else {
        [btnTongBu setHidden:YES];
         [lblTongBuTs setHidden:YES];
        self.height = tlastY;
         [self.lineView setFrame:CGRectMake(0, self.height - k360Width(1), kScreenWidth, k360Width(1))];
    }
}
 
 

@end
