//
//  WY_ConsultingTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/10/24.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_ConsultingTableViewCell.h"

@implementation WY_ConsultingTableViewCell
@synthesize lblName,lblDate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self makeUI];
    }
    return self;
}
- (void)makeUI {
    [self setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    self.imgYhf = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0425_yhf"]];
    [self.imgYhf setFrame:CGRectMake(kScreenWidth - k360Width(53), 0, k360Width(53), k360Width(53))];
    [self.contentView addSubview:self.imgYhf];
    [self.imgYhf setHidden:YES];
    
    self.imgHead = [UIImageView new];
    [self.contentView addSubview:self.imgHead];
    
    self.viewZhuanYe = [UIView new];
    [self.contentView addSubview:self.viewZhuanYe];
    
    self.lblZJName = [UILabel new];
    [self.contentView addSubview:self.lblZJName];

    self.lblName = [UILabel new];
    [self.contentView addSubview:self.lblName];

    
    //同学名称
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(24))];
    self.lblTitle.font = WY_FONTMedium(14);//默认使用系统的17
    self.lblTitle.textColor = [UIColor blackColor];//默认使用文本黑色
    self.lblTitle.textAlignment = NSTextAlignmentLeft;//默认是左对齐
    [self.contentView addSubview:self.lblTitle];
    
    //同学名称
    self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.lblTitle.bottom, kScreenWidth - k360Width(32), k360Width(44))];
    self.lblName.font = WY_FONTMedium(14);//默认使用系统的17
    self.lblName.textColor = [UIColor blackColor];//默认使用文本黑色
    self.lblName.textAlignment = NSTextAlignmentLeft;//默认是左对齐
    [self.contentView addSubview:self.lblName];
    
      
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.lblName.bottom, kScreenWidth - k360Width(32), k360Width(44))];
    self.lblDate.font = WY_FONTRegular(14);//默认使用系统的17
    self.lblDate.textColor = APPTextGayColor;//默认使用文本黑色
    self.lblDate.textAlignment = NSTextAlignmentLeft;//默认是左对齐
    [self.contentView addSubview:self.lblDate];
     
    
    self.imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.lblDate.bottom + k360Width(1), kScreenWidth, 1)];
    [self.imgLine setBackgroundColor:APPLineColor];
     [self.contentView addSubview:self.imgLine];
     
}

- (void)showCellByItem:(WY_MessageModel *)withModel
{
    [self.lblName setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32),k360Width(44))];
    self.lblName.text = withModel.text;
    [self.lblName setNumberOfLines:0];
    [self.lblName setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblName sizeToFit];
    
    [self.lblDate setFrame:CGRectMake(k360Width(16), self.lblName.bottom, kScreenWidth - k360Width(32),k360Width(44))];

    self.lblDate.text = [NSString stringWithFormat:@"电话拨打时间：%@",withModel.cqsj];
    self.imgLine.top = self.lblDate.bottom + k360Width(5);
     self.height = self.imgLine.bottom;

}

- (void)showCellDocByItem:(WY_AExpertQuestionModel *)withModel
{
    if ([withModel.isAnswer isEqualToString:@"1"]) {
        [self.imgYhf setHidden:NO];
    } else {
        [self.imgYhf setHidden:YES];
    }
    
    [self.imgHead setFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(35), k360Width(35))];
    [self.imgHead rounded:k360Width(35/2)];
    [self.lblZJName setFrame:CGRectMake(self.imgHead.right + k360Width(10), k360Width(16), k360Width(300), k360Width(50))];
    [self.lblZJName setTextColor:HEXCOLOR(0x7a7a7a)];

    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:withModel.expertPic] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    [self.lblZJName setNumberOfLines:2];
    
    NSString *expertCityStr = @"";
    if (withModel.expertCity !=NULL && ![withModel.expertCity isEqual:[NSNull null]] && ![withModel.expertCity isEqualToString:@""]) {
        expertCityStr = [NSString stringWithFormat:@"\n%@",withModel.expertCity];
    }
    
    [self.lblZJName setText:[NSString stringWithFormat:@"%@   %@%@",withModel.expertName,withModel.expertPhone,expertCityStr]];
    [self.lblZJName setCenterY:self.imgHead.centerY];
    
    [self.lblTitle setFrame:CGRectMake(k360Width(16), self.imgHead.bottom + k360Width(10), kScreenWidth - k360Width(32),k360Width(20))];
    
    NSString *typeStr = @"";
    //类型 1 咨询 2 投诉 3 建议
    switch ([withModel.qaType intValue]) {
        case 1:
        {
            typeStr = @"咨询";
        }
            break;
        case 2:
        {
            typeStr = @"投诉";
        }
            break;
        case 3:
        {
            typeStr = @"建议";
        }
            break;
        default
            :
            break;
    }
    if (withModel.qaCityName == nil || [withModel.qaCityName isEqual:[NSNull null]]) {
        withModel.qaCityName = @"";
    }
    
    NSMutableAttributedString *attStrA1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@] [%@] ",typeStr,withModel.qaCityName]];
    [attStrA1 setYy_font:WY_FONTRegular(16)];
    [attStrA1 setYy_color:MSTHEMEColor];
    
    NSMutableAttributedString *attStrA2 = [[NSMutableAttributedString alloc] initWithString:withModel.qaTitle];
    [attStrA2 setYy_font:WY_FONTMedium(16)];
    [attStrA2 setYy_color:HEXCOLOR(0x434343)];
    [attStrA1 appendAttributedString:attStrA2];
    
//    [self.lblTitle setText:[NSString stringWithFormat:@"[%@] [%@] %@",typeStr,withModel.qaCityName,withModel.qaTitle]];
//    [self.lblTitle setFont:WY_FONTMedium(16)];
//    [self.lblTitle setTextColor:HEXCOLOR(0x434343)];
    [self.lblTitle setAttributedText:attStrA1];
    [self.lblTitle setNumberOfLines:0];
    [self.lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblTitle sizeToFit];
    
    [self.lblName setFrame:CGRectMake(k360Width(16), self.lblTitle.bottom + k360Width(5), kScreenWidth - k360Width(32),k360Width(44))];
    
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:withModel.qaContent];
    NSString *str3 = @"";
    
    if ([withModel.isAnswer isEqualToString:@"1"]) {
        str3 = [NSString stringWithFormat:@"\n提交时间：%@\n回复时间：%@",withModel.qaTime,withModel.answer.anTime];
    } else {
        str3 = [NSString stringWithFormat:@"\n提交时间：%@",withModel.qaTime];
    }
    
    NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc] initWithString:str3];
    
    [attStr2 setYy_font:WY_FONTRegular(14)];
    [attStr3 setYy_font:WY_FONTRegular(14)];
    
     [attStr2 setYy_color:HEXCOLOR(0x7a7a7a)];
    [attStr3 setYy_color:HEXCOLOR(0xB7b7b7)];
    
     [attStr2 appendAttributedString:attStr3];
    [attStr2 setYy_lineSpacing:5];
     
    [self.lblName setAttributedText:attStr2];
    [self.lblName setNumberOfLines:0];
    [self.lblName setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblName sizeToFit];
    
    [self.lblDate setHidden:YES];
//    [self.lblDate setFrame:CGRectMake(k360Width(16), self.lblName.bottom, kScreenWidth - k360Width(32),k360Width(44))];
//
//    self.lblDate.text = [NSString stringWithFormat:@"电话拨打时间：%@",withModel.cqsj];
    self.imgLine.top = self.lblName.bottom + k360Width(5);
     self.height = self.imgLine.bottom;
    
    
    int zyLeft = 0;
    if (withModel.tags.count > 0) {
        [self.viewZhuanYe setHidden:NO];
        [self.viewZhuanYe setFrame:CGRectMake(self.imgHead.right + k360Width(180), 0, k360Width(150), k360Width(44))];
        self.viewZhuanYe.centerY = self.imgHead.centerY;
         [self.viewZhuanYe removeAllSubviews];
        
        for (NSDictionary *dicItem in withModel.tags) {
            UIImageView *imgZy = [UIImageView new];
            [imgZy setFrame:CGRectMake(zyLeft, k360Width(4.5), k360Width(35), k360Width(35))];
             [imgZy sd_setImageWithURL:[NSURL URLWithString:dicItem[@"imgUrl"]]];
            [self.viewZhuanYe addSubview:imgZy];
//            NSArray *arrBuffs = dicItem[@"labels"];
//            if (arrBuffs != nil || arrBuffs.count > 0) {
                UIButton *imgZyBuff = [UIButton new];
                [imgZyBuff setFrame:CGRectMake(zyLeft, k360Width(4.5), k360Width(35), k360Width(35))];
                
                [imgZyBuff sd_setBackgroundImageWithURL:[NSURL URLWithString:dicItem[@"label"][@"imgUrl"]] forState:UIControlStateNormal];
                [self.viewZhuanYe addSubview:imgZyBuff];
//            }
            zyLeft = imgZy.right + k360Width(10);
        }
    } else {
        [self.viewZhuanYe setHidden:YES];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
