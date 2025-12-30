//
//  WY_QuestionOptionView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuestionOptionView.h"

@implementation WY_QuestionOptionView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        self.userInteractionEnabled = YES;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    [self setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self rounded:k360Width(44/8) width:1 color:HEXCOLOR(0xEEEEEE)];
    self.lblTitle = [UILabel new];
    [self.lblTitle setFont:WY_FONTMedium(16)];
    [self.lblTitle setTextColor:APPTextGayColor];
    [self.lblTitle setLineBreakMode:NSLineBreakByCharWrapping];
    [self.lblTitle setNumberOfLines:0];
    [self addSubview:self.lblTitle];
}
- (void)showCellByItem:(WY_QuestionOptionModel*)withWY_QuestionOptionModel
{
    self.mWY_QuestionOptionModel = withWY_QuestionOptionModel;
    [self.lblTitle setFrame:CGRectMake(k360Width(16), k360Width(0), self.width - k360Width(32), 0)];
    [self.lblTitle setText:[NSString stringWithFormat:@"%@.%@",self.mWY_QuestionOptionModel.optionType,self.mWY_QuestionOptionModel.optionContent]];
    if (self.mWY_QuestionOptionModel.selected) {
        [self.lblTitle setTextColor:MSTHEMEColor];
        [self rounded:k360Width(44/8) width:1 color:MSTHEMEColor];

    } else {
        [self.lblTitle setTextColor:APPTextGayColor];
        [self rounded:k360Width(44/8) width:1 color:HEXCOLOR(0xEEEEEE)];

    }
    [self.lblTitle sizeToFit];
    self.lblTitle.height += k360Width(32);
    self.height = self.lblTitle.bottom ;
}
///判断题
- (void)showPDTCellByItem:(WY_QuestionOptionModel*)withWY_QuestionOptionModel
{
    self.mWY_QuestionOptionModel = withWY_QuestionOptionModel;
    [self.lblTitle setFrame:CGRectMake(k360Width(16), 0, self.width - k360Width(32), 0)];
    [self.lblTitle setText:[NSString stringWithFormat:@"%@",self.mWY_QuestionOptionModel.optionContent]];
    if (self.mWY_QuestionOptionModel.selected) {
        [self.lblTitle setTextColor:MSTHEMEColor];
        [self rounded:k360Width(44/8) width:1 color:MSTHEMEColor];

    } else {
        [self.lblTitle setTextColor:APPTextGayColor];
        [self rounded:k360Width(44/8) width:1 color:HEXCOLOR(0xEEEEEE)];

    }
    [self.lblTitle sizeToFit];
    self.lblTitle.height += k360Width(32);
    self.height = self.lblTitle.bottom;
}
- (void)showReViewCellByStr :(NSString *)withStr {
    [self.lblTitle setFrame:CGRectMake(k360Width(16), 0, self.width - k360Width(32), 0)];
    [self.lblTitle setText:withStr];
    [self.lblTitle setFont:WY_FONTRegular(14)];
    [self.lblTitle setTextColor:[UIColor blackColor]];
    [self.lblTitle sizeToFit];
    self.lblTitle.height += k360Width(32);
    self.height = self.lblTitle.bottom;
}
@end
