//
//  WY_selPicView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_selPicView.h"

@implementation WY_selPicView


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
    self.btnImg = [UIButton new];
    [self addSubview:self.btnImg];
    [self.btnImg setFrame:CGRectMake(0, k375Width(10), self.width-k375Width(10), self.height - k375Width(10))];
    [self.btnImg rounded:k375Width(44/8)];
    
    self.btnDel = [UIButton new];
    [self addSubview:self.btnDel];
    [self.btnDel setImage:[UIImage imageNamed:@"0615_del"] forState:UIControlStateNormal];
    [self.btnDel setFrame:CGRectMake(self.btnImg.right - k375Width(10), self.btnImg.top - k375Width(10), k375Width(20),k375Width(20))];
    
}

- (void)showCellByImgUrl:(NSString *)withImgUrl ByIsDel:(BOOL) isDel {
    UIImage *placeholderImage = [UIImage imageNamed:@"photo_btn01"];
    if (isDel) {
        [self.btnDel setHidden:NO];
        placeholderImage = [UIImage imageNamed:@"1107load"];
    } else {
        [self.btnDel setHidden:YES];
        placeholderImage = [UIImage imageNamed:@"photo_btn01"];
    }
     
     
    [self.btnImg sd_setBackgroundImageWithURL:[NSURL URLWithString:[withImgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:placeholderImage];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
