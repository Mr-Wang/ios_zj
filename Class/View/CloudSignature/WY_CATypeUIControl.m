//
//  WY_CATypeUIControl.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/20.
//  Copyright © 2022 王杨. All rights reserved.
//

#import "WY_CATypeUIControl.h"

@implementation WY_CATypeUIControl


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
    self.imgSel = [UIImageView new];
    self.imgInfo = [UIImageView new];
    self.imgStatus = [UIImageView new];
    self.lblInfo = [UILabel new];
    
    [self.imgStatus setFrame:CGRectMake(0, 0, k375Width(55), k375Width(55))];
    [self.imgSel setFrame:CGRectMake(self.width - k375Width(43), 0, k375Width(43), k375Width(43))];
    [self.imgSel setImage:[UIImage imageNamed:@"0420_sel_right"]];
    
    [self.imgInfo setFrame:CGRectMake((self.width-k375Width(100)) / 2, (self.width-k375Width(100)) / 2, k375Width(100), k375Width(100))];
     
    
    [self.lblInfo setFrame:CGRectMake(0, self.imgInfo.bottom, self.width, k360Width(22))];
    [self.lblInfo setTextAlignment:NSTextAlignmentCenter];
    [self.lblInfo setFont:WY_FONTMedium(14)];
    [self addSubview:self.imgSel];
    [self addSubview:self.imgInfo];
    [self addSubview:self.imgStatus];
    [self addSubview:self.lblInfo];
}
- (void)updateViewStatus { 
    //CA状态  0 无 1 已办理、2已过期
    switch (self.caStatus) {
        case 0:
        {
            [self.imgStatus setHidden:YES];
        }
            break;
        case 1:
        {
            [self.imgStatus setImage:[UIImage imageNamed:@"0420_yes"]];
            [self.imgStatus setHidden:NO];
        }
            break;
        case 2:
        {
            [self.imgStatus setImage:[UIImage imageNamed:@"0420_out"]];
            [self.imgStatus setHidden:NO];
        }
            break;
        default:
            break;
    }
    
    if (self.selected) {
        [self.imgInfo setImage:[UIImage imageNamed:self.imgUrl_Sel]];
        [self.lblInfo setTextColor:MSTHEMEColor];
        [self rounded:self.width/16 width:1 color:HEXCOLOR(0x3677e9)];
        [self.imgSel setHidden:NO];
    } else {
        [self.imgInfo setImage:[UIImage imageNamed:self.imgUrl]];
        [self.lblInfo setTextColor:HEXCOLOR(0x747474)];
        [self rounded:self.width/16 width:1 color:HEXCOLOR(0x878787)];
        [self.imgSel setHidden:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
