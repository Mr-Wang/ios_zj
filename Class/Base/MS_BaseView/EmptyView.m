
//
//  EmptyView.m
//  MigratoryBirds
//
//  Created by 许春娜 on 2018/8/22.
//  Copyright © 2018年 Doj. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    self.picImgV = [UIImageView new];
    self.contentLabel = [UILabel new];
    
    [self.picImgV setImage:[UIImage imageNamed:@""]];
    
    [self.contentLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.contentLabel setFont:YF_CustomFont(14)];
    [self.contentLabel setTextColor:MSColor(153,153,153)];
    [self.contentLabel setText:@""];
    [self.contentLabel setNumberOfLines:0];
    
    [self addSubview:self.picImgV];
    [self addSubview:self.contentLabel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *img = self.picImgSize;
    [self.picImgV setFrame:CGRectMake((kScreenWidth-img.size.width)/2.0, k360Width(80), img.size.width, img.size.height)];
    self.picImgV.centerY = self.centerY - k360Width(50);
    CGSize size = [GlobalConfig getAdjustHeightOfContent:self.contentLabel.text width:kScreenWidth-100 fontSize:14];
    [self.contentLabel setFrame:CGRectMake(50, ViewY(self.picImgV)+ViewH(self.picImgV)+k360Width(10), kScreenWidth-100, size.height)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
