//
//  WY_HomeItemView.m
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/10.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_HomeItemView.h"

@implementation WY_HomeItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, k360Width(2), k375Width(66), k375Width(71))];
    [self addSubview:_imgIcon];
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imgIcon.bottom, self.width, k360Width(16))];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
     [self.lblTitle setFont:WY_FONTMedium(14)];
    [self.lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
    self.imgIcon.centerX = self.lblTitle.centerX;
    [self addSubview:self.lblTitle];
}

- (void)bindViewWith:(UIImage *)image titleStr:(NSString *)titleStr {
    [self.imgIcon setImage:image];
    [self.lblTitle setText:titleStr];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
