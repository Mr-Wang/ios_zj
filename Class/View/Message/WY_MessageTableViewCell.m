//
//  WY_MessageTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/10/24.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_MessageTableViewCell.h"

@implementation WY_MessageTableViewCell
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
    [self setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    //消息框
    self.viewInfo = [[UIView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(5), k360Width(335), k360Width(91))];
    [self.contentView addSubview:viewInfo];
    
    viewInfoBg = [[UIImageView alloc]initWithFrame:viewInfo.bounds];
    [viewInfoBg setImage:[UIImage imageNamed:@"信息矩形"]];
    [viewInfo addSubview:viewInfoBg];
    UIImageView *imgLd = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(12), k360Width(16), k360Width(20))];
    [imgLd setImage:[UIImage imageNamed:@"ring"]];
    [viewInfo addSubview:imgLd];
    
    //同学名称
    self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(32 + 16), 0, k360Width(300), k360Width(44))];
    self.lblName.font = [UIFont boldSystemFontOfSize:14];//默认使用系统的17
    self.lblName.textColor = [UIColor blackColor];//默认使用文本黑色
    self.lblName.textAlignment = NSTextAlignmentLeft;//默认是左对齐
    [viewInfo addSubview:self.lblName];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, k360Width(44), viewInfo.width -1, 1)];
    [imgLine setBackgroundColor:MSColor(242, 242, 242)];
     [viewInfo addSubview:imgLine];
    
    
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(150+40), 0, k360Width(150), k360Width(44))];
    self.lblDate.font = [UIFont systemFontOfSize:14];//默认使用系统的17
    self.lblDate.textColor = [UIColor blackColor];//默认使用文本黑色
    self.lblDate.textAlignment = NSTextAlignmentRight;//默认是左对齐
    [viewInfo addSubview:self.lblDate];
    
    
    //时间次数
    self.lblTimeNum = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.lblName.bottom, k360Width(300), k360Width(30 + 16))];
    self.lblTimeNum.font = [UIFont systemFontOfSize:14];//默认使用系统的17
    self.lblTimeNum.textColor = [UIColor darkTextColor];//默认使用文本黑色
    self.lblTimeNum.textAlignment = NSTextAlignmentLeft;//默认是左对齐
    [self.lblTimeNum setNumberOfLines:0];
    [self.lblTimeNum setLineBreakMode:NSLineBreakByWordWrapping];
    [viewInfo addSubview:self.lblTimeNum];
}

- (void)showCellByItem:(WY_MessageModel *)withModel
{
    self.lblName.text = withModel.title;
    self.lblTimeNum.text = withModel.content;
    self.lblDate.text = withModel.tssj;
    self.viewInfo.height = self.lblTimeNum.bottom + k360Width(16);
    self.height = self.viewInfo.bottom + k360Width(8);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
