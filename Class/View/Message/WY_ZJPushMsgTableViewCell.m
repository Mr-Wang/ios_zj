//
//  WY_ZJPushMsgTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/10/24.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_ZJPushMsgTableViewCell.h"

@implementation WY_ZJPushMsgTableViewCell
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
    
    //同学名称
    self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(44))];
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

- (void)showCellDocByItem:(WY_MessageModel *)withModel
{
    [self.lblName setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32),k360Width(44))];
    self.lblName.text = withModel.docTitle;
    [self.lblName setNumberOfLines:0];
    [self.lblName setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblName sizeToFit];
    
    [self.lblDate setHidden:YES];
//    [self.lblDate setFrame:CGRectMake(k360Width(16), self.lblName.bottom, kScreenWidth - k360Width(32),k360Width(44))];
//
//    self.lblDate.text = [NSString stringWithFormat:@"电话拨打时间：%@",withModel.cqsj];
    self.imgLine.top = self.lblName.bottom + k360Width(5);
     self.height = self.imgLine.bottom;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
