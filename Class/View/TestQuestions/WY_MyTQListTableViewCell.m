//
//  WY_MyTQListTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyTQListTableViewCell.h"

@implementation WY_MyTQListTableViewCell
{
    UIImageView * imgLine;
    UIImageView *imgA;
    UIImageView *img1;
    UIImageView *img2;
    UIImageView *img3;
    UIImageView *img4;
    
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
    
    imgA = [UIImageView new];
    [imgA setFrame:CGRectMake(k360Width(7), k360Width(7), k360Width(22), k360Width(22))];
    [imgA setImage:[UIImage imageNamed:@"addct"]];
    [self.viewCont addSubview:imgA];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(34), 0, k360Width(232), k360Width(34))];
    [self.lblTitle setFont:WY_FONTMedium(16)];
    [self.viewCont addSubview:self.lblTitle];
    
    self.lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(34), self.lblTitle.bottom, k360Width(232), k360Width(24))];
    [self.viewCont addSubview:self.lbl1];
    
    self.lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(34), self.lbl1.bottom, k360Width(232), k360Width(24))];
    [self.viewCont addSubview:self.lbl2];
    
    self.lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(34), self.lbl2.bottom, k360Width(232), k360Width(24))];
    [self.viewCont addSubview:self.lbl3];
    
    self.lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(34), self.lbl3.bottom, k360Width(232), k360Width(24))];
    [self.viewCont addSubview:self.lbl4];
    
    self.lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lblTitle.bottom, self.viewCont.width - k360Width(16), k360Width(24))];
    [self.lbl5 setTextAlignment:NSTextAlignmentRight];
    [self.viewCont addSubview:self.lbl5];
    
    self.btnUpdate = [UIButton new];
    [self.btnUpdate setFrame:CGRectMake(self.viewCont.width - k360Width(86), self.lbl5.bottom + k360Width(32), k360Width(70), k360Width(30))];
    [self.btnUpdate setBackgroundColor:MSTHEMEColor];
    [self.btnUpdate rounded:k360Width(30/6)];
    [self.btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnUpdate setUserInteractionEnabled:NO];
    [self.viewCont addSubview:self.btnUpdate];
    
    img1 = [UIImageView new];
    img2 = [UIImageView new];
    img3 = [UIImageView new];
    img4 = [UIImageView new];
    [self.viewCont addSubview:img1];
    [self.viewCont addSubview:img2];
    [self.viewCont addSubview:img3];
    [self.viewCont addSubview:img4];
    [img1 setFrame:CGRectMake(0, 0, k360Width(8), k360Width(8))];
    [img2 setFrame:CGRectMake(0, 0, k360Width(8), k360Width(8))];
    [img3 setFrame:CGRectMake(0, 0, k360Width(8), k360Width(8))];
    [img4 setFrame:CGRectMake(0, 0, k360Width(8), k360Width(8))];
    
    img1.centerX = imgA.centerX;
    img2.centerX = imgA.centerX;
    img3.centerX = imgA.centerX;
    img4.centerX = imgA.centerX;
    
    img1.centerY = self.lbl1.centerY;
    img2.centerY = self.lbl2.centerY;
    img3.centerY = self.lbl3.centerY;
    img4.centerY = self.lbl4.centerY;
    
    [img1 setBackgroundColor:HEXCOLOR(0xFCBA41)];
    [img2 setBackgroundColor:HEXCOLOR(0xA3D032)];
    [img3 setBackgroundColor:HEXCOLOR(0xFC817A)];
    [img4 setBackgroundColor:HEXCOLOR(0xFCBA41)];
    
    [img1 rounded:k360Width(8 / 2)];
    [img2 rounded:k360Width(8 / 2)];
    [img3 rounded:k360Width(8 / 2)];
    [img4 rounded:k360Width(8 / 2)];
}

- (void)showCellByItem:(WY_QuestionModel *)withWY_QuestionModel{
    self.mWY_QuestionModel = withWY_QuestionModel;
    
    self.lblTitle.text = self.mWY_QuestionModel.questionContent;
    
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"试题类型："];
    [attStr1 setYy_color:APPTextGayColor];
    [attStr1 setYy_font:WY_FONTRegular(14)];
    NSMutableAttributedString *attStrA1 = [[NSMutableAttributedString alloc] initWithString:self.mWY_QuestionModel.questionTypeText];
    [attStrA1 setYy_color:[UIColor blackColor]];
    [attStrA1 setYy_font:WY_FONTMedium(14)];
    [attStr1 appendAttributedString:attStrA1];
    self.lbl1.attributedText = attStr1;
    
    
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:@"试题分类："];
    [attStr2 setYy_color:APPTextGayColor];
    [attStr2 setYy_font:WY_FONTRegular(14)];
    NSMutableAttributedString *attStrA2 = [[NSMutableAttributedString alloc] initWithString:self.mWY_QuestionModel.contentTypeText];
    [attStrA2 setYy_color:[UIColor blackColor]];
    [attStrA2 setYy_font:WY_FONTRegular(14)];
    [attStr2 appendAttributedString:attStrA2];
    self.lbl2.attributedText = attStr2;
    
    NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc] initWithString:@"我的答案："];
    [attStr3 setYy_color:APPTextGayColor];
    [attStr3 setYy_font:WY_FONTRegular(14)];
    NSMutableAttributedString *attStrA3 = [[NSMutableAttributedString alloc] initWithString:self.mWY_QuestionModel.solution];
    [attStrA3 setYy_color:[UIColor blackColor]];
    [attStrA3 setYy_font:WY_FONTRegular(14)];
    [attStr3 appendAttributedString:attStrA3];
    self.lbl3.attributedText = attStr3;
    
    NSMutableAttributedString *attStr4 = [[NSMutableAttributedString alloc] initWithString:@"审核状态："];
    [attStr4 setYy_color:APPTextGayColor];
    [attStr4 setYy_font:WY_FONTRegular(14)];
    NSMutableAttributedString *attStrA4 = [[NSMutableAttributedString alloc] initWithString:[self retStrbyStatusID:self.mWY_QuestionModel.auditStatus]];
    [attStrA4 setYy_color:[UIColor blackColor]];
    [attStrA4 setYy_font:WY_FONTRegular(14)];
    [attStr4 appendAttributedString:attStrA4];
    self.lbl4.attributedText = attStr4;
    
    NSMutableAttributedString *attStr5 = [[NSMutableAttributedString alloc] initWithString:@"试题难度："];
    [attStr5 setYy_color:APPTextGayColor];
    [attStr5 setYy_font:WY_FONTRegular(14)];
    NSMutableAttributedString *attStrA5 = [[NSMutableAttributedString alloc] initWithString:self.mWY_QuestionModel.questionLevelText];
    [attStrA5 setYy_color:[UIColor blackColor]];
    [attStrA5 setYy_font:WY_FONTRegular(14)];
    [attStr5 appendAttributedString:attStrA5];
    self.lbl5.attributedText = attStr5;
    [self.btnUpdate setHidden:NO];
    if ([self.mWY_QuestionModel.auditStatus isEqualToString:@"6"] || [self.mWY_QuestionModel.auditStatus isEqualToString:@"7"]) {
        //被拒绝的 编辑 并且是自己出的题目-可以编辑
        if ([self.mUser.UserGuid isEqualToString:self.mWY_QuestionModel.userGuid]) {
            //编辑
            [self.btnUpdate setTitle:@"编辑" forState:UIControlStateNormal];
        } else {
            //查看
            [self.btnUpdate setHidden:YES];
        }
    } else {
        //当前用户是企业主 -并且审核状态是 待企业主审核的；
        if ([self.mUser.UserType isEqualToString:@"2"] && [self.mWY_QuestionModel.auditStatus isEqualToString:@"2"]) {
            //审核
            [self.btnUpdate setTitle:@"审核" forState:UIControlStateNormal];
        } else {
            //查看
            [self.btnUpdate setHidden:YES];
        }
    }
    
    
    self.viewCont.height = self.lbl4.bottom + k360Width(5);
    [self viewShadowCorner:self.viewCont];
    self.height = self.viewCont.bottom + k360Width(8);
    [self.colSender setFrame:self.bounds];
    
}
- (NSString *)retStrbyStatusID:(NSString *)statusID {
    NSString *retStr = @"";
    /*titleList.add("待企业主审核");
     titleList.add("企业主审核通过");
     titleList.add("系统审核通过");
     titleList.add("企业主审核拒绝");
     titleList.add("系统审核拒绝");*/
    switch ([statusID intValue]) {
        case 2:
        {
            retStr = @"待企业主审核";
        }
            break;
        case 4:
        {
            retStr = @"企业主审核通过";
        }
            break;
        case 5:
        {
            retStr = @"系统审核通过";
        }
            break;
        case 6:
        {
            retStr = @"企业主审核拒绝";
        }
            break;
        case 7:
        {
            retStr = @"系统审核拒绝";
        }
            break;
            
        default:
            break;
    }
    return retStr;
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
