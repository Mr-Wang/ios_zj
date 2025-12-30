//
//  WY_ChangeBedroomTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/10/26.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_ChangeBedroomTableViewCell.h"

@implementation WY_ChangeBedroomTableViewCell

@synthesize lblName,lblDate,lblTimeNum,viewInfo,viewInfoBg;

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
    
    //消息框
    self.viewInfo = [[UIView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(5), k360Width(335), k360Width(140))];
    [self.contentView addSubview:viewInfo];
    
    viewInfoBg = [[UIImageView alloc]initWithFrame:viewInfo.bounds];
    [viewInfoBg setImage:[UIImage imageNamed:@"矩形D"]];
    [viewInfo addSubview:viewInfoBg];
    
    self.imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(40), k360Width(40))];
    [self.imgHead setImage:[UIImage imageNamed:@"default_head"]];
    [viewInfo addSubview:self.imgHead];
    //同学名称
    self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(self.imgHead.right + k360Width(16), k360Width(16), kScreenWidth - self.imgHead.right, k360Width(20))];
    self.lblName.font = [UIFont systemFontOfSize:14];//默认使用系统的17
    self.lblName.textColor = [UIColor blackColor];//默认使用文本黑色
    self.lblName.textAlignment = NSTextAlignmentLeft;//默认是左对齐
    [viewInfo addSubview:self.lblName];
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(self.lblName.left, self.lblName.bottom , kScreenWidth - self.imgHead.right, k360Width(20))];
    self.lblDate.font = [UIFont systemFontOfSize:14];//默认使用系统的17
    self.lblDate.textColor = [UIColor blackColor];//默认使用文本黑色
    self.lblDate.textAlignment = NSTextAlignmentLeft;//默认是左对齐
    [viewInfo addSubview:self.lblDate];
    
    
    //时间次数
    self.lblTimeNum = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.imgHead.bottom + k360Width(5), k360Width(300), k360Width(20))];
    self.lblTimeNum.font = [UIFont systemFontOfSize:14];//默认使用系统的17
    self.lblTimeNum.textColor = [UIColor darkTextColor];//默认使用文本黑色
    self.lblTimeNum.textAlignment = NSTextAlignmentLeft;//默认是左对齐
     [viewInfo addSubview:self.lblTimeNum];
    
    //时间次数
    self.lblTimeNum2 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.lblTimeNum.bottom, k360Width(300), k360Width(20))];
    self.lblTimeNum2.font = [UIFont systemFontOfSize:14];//默认使用系统的17
    self.lblTimeNum2.textColor = [UIColor darkTextColor];//默认使用文本黑色
    self.lblTimeNum2.textAlignment = NSTextAlignmentLeft;//默认是左对齐
     [viewInfo addSubview:self.lblTimeNum2];
    
    //时间次数
    self.lblTimeNum3 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.lblTimeNum2.bottom, k360Width(300), k360Width(20))];
    self.lblTimeNum3.font = [UIFont systemFontOfSize:14];//默认使用系统的17
    self.lblTimeNum3.textColor = [UIColor darkTextColor];//默认使用文本黑色
    self.lblTimeNum3.textAlignment = NSTextAlignmentLeft;//默认是左对齐
     [viewInfo addSubview:self.lblTimeNum3];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
