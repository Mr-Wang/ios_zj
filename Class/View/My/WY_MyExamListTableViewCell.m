//
//  WY_MyExamListTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/22.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyExamListTableViewCell.h"

@implementation WY_MyExamListTableViewCell

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
    self.viewBG = [UIView new];
     self.imgInvoiceType = [UIImageView new];
     self.lblContent = [UILabel new];
    
     [self.viewBG addSubview:self.imgInvoiceType];
    [self.viewBG addSubview:self.lblContent];
    [self.contentView addSubview:self.viewBG];
    
    [self.viewBG setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(150))];
    [self.viewBG setBackgroundColor:[UIColor whiteColor]];
    [self.viewBG rounded:k360Width(44/8) width:1 color:APPLineColor];
     
    [self.imgInvoiceType setFrame:CGRectMake(self.viewBG.width - k360Width(62 + 16), k360Width(16), k360Width(62), k360Width(41))];
    [self.lblContent setFrame:CGRectMake(k360Width(16), self.imgInvoiceType.top,  self.imgInvoiceType.left - k360Width(16), k360Width(100))];
    [self.lblContent setNumberOfLines:0];
    
}
- (void)showCellByItem:(WY_PersonalScoreModel *)withWY_PersonalScoreModel {
    self.mWY_PersonalScoreModel = withWY_PersonalScoreModel;
   //或许要改
    if ([withWY_PersonalScoreModel.pass isEqualToString:@"1"]) {
        [self.imgInvoiceType setImage:[UIImage imageNamed:@"tongguo"]];
    } else  {
        [self.imgInvoiceType setImage:[UIImage imageNamed:@"weitongguo"]];
    }
    NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:withWY_PersonalScoreModel.title];
    NSMutableAttributedString *strContent1 = nil;
    
    
    
    if ([withWY_PersonalScoreModel.isface isEqualToString:@"0"]) {
         strContent1 = [[NSMutableAttributedString alloc] initWithString:@"\n考试得分：分数无效"];
    } else {
        strContent1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n考试得分：%.1f",[withWY_PersonalScoreModel.score floatValue]]];
    }
    NSMutableAttributedString *strContent2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n考试时间：%@",withWY_PersonalScoreModel.examTime]];
    
    [strContent setYy_font:WY_FONTMedium(16)];
    [strContent setYy_color:[UIColor blackColor]];
    
    [strContent1 setYy_font:WY_FONTRegular(14)];
    [strContent2 setYy_font:WY_FONTRegular(14)];
    [strContent1 setYy_color:APPTextGayColor];
    [strContent2 setYy_color:APPTextGayColor];
    
    
    if ([withWY_PersonalScoreModel.nsDescription isNotBlank]) {
        [self.lblContent setFrame:CGRectMake(k360Width(16), self.imgInvoiceType.top,  self.viewBG.width - k360Width(32), k360Width(100))];
        [self.imgInvoiceType setHidden:YES];
        NSMutableAttributedString *tishi =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",withWY_PersonalScoreModel.nsDescription]];
        [tishi setYy_font:WY_FONTMedium(14)];
        [tishi yy_setObliqueness:@0.3 range:NSMakeRange(0, withWY_PersonalScoreModel.nsDescription.length)];
        
        [tishi setYy_color:HEXCOLOR(0xFA6400)];
        [strContent appendAttributedString:tishi];

    } else {
        [self.lblContent setFrame:CGRectMake(k360Width(16), self.imgInvoiceType.top,  self.imgInvoiceType.left - k360Width(16), k360Width(100))];
        [self.imgInvoiceType setHidden:NO];
    }
    
    [strContent appendAttributedString:strContent1];
    [strContent appendAttributedString:strContent2];
    
    [strContent setYy_lineSpacing:6];
    
    self.lblContent.attributedText = strContent;

//    [self.lblContent setFrame:CGRectMake(k360Width(16), self.imgInvoiceType.top,  self.imgInvoiceType.left - k360Width(16), k360Width(100))];

    [self.lblContent sizeToFit];
    
    self.viewBG.height = self.lblContent.bottom + k360Width(16);
    self.height = self.viewBG.bottom + k360Width(8);
}

@end
