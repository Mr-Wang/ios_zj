//
//  WY_SubmitAlertView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/27.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SubmitAlertView.h"

@implementation WY_SubmitAlertView
{
    UIImageView *imgShiJian;
}

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
    [self setBackgroundColor:MHColorAlpha(0, 0, 0, 0.5)];
    self.viewAlert = [UIView new];
    [self addSubview:self.viewAlert];
    [self.viewAlert setFrame:CGRectMake(0, 0, k360Width(270), k360Width(243))];
    self.viewAlert.centerX = self.centerX;
    self.viewAlert.centerY = self.centerY;
    [self viewShadowCorner:self.viewAlert];
    
    self.progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake((self.viewAlert.width - k360Width(114)) / 2, k360Width(16), k360Width(114), k360Width(114)) pathBackColor:[UIColor lightGrayColor] pathFillColor:HEXCOLOR(0xFA6400) startAngle:90 strokeWidth:10];
    [self.viewAlert addSubview:self.progressView];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewAlert.width, k360Width(44))];
    self.lblTitle.centerY = self.progressView.centerY;
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.lblTitle setNumberOfLines:2];
    [self.viewAlert addSubview:self.lblTitle];
    
    self.lblExamTime = [[UILabel alloc] initWithFrame:CGRectMake((self.viewAlert.width - k360Width(123)) / 2, self.progressView.bottom + k360Width(16), k360Width(123), k360Width(22))];
    [self.lblExamTime setTextAlignment:NSTextAlignmentCenter];
    [self.viewAlert addSubview:self.lblExamTime];
    
    
    imgShiJian = [UIImageView new];
    [imgShiJian setFrame:CGRectMake(self.lblExamTime.left - k360Width(24), 0, k360Width(19), k360Width(19))];
    [imgShiJian setImage:[UIImage imageNamed:@"0227_shijian"]];
    imgShiJian.centerY = self.lblExamTime.centerY;
    [self.viewAlert addSubview:imgShiJian];
    [self.viewAlert addSubview:self.lblExamTime];
    
    
    self.btnNow = [UIButton new];
    [self.btnNow setFrame:CGRectMake(0, self.viewAlert.height - k360Width(51), self.viewAlert.width / 2, k360Width(51))];
    
    [self.btnNow setBackgroundColor:[UIColor whiteColor]];
    [self.btnNow setTitle:@"现在交卷" forState:UIControlStateNormal];
    [self.btnNow setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    
    self.btnCancel = [UIButton new];
    [self.btnCancel setFrame:CGRectMake(self.viewAlert.width / 2, self.viewAlert.height - k360Width(51), self.viewAlert.width / 2, k360Width(51))];
    
    [self.btnCancel setBackgroundColor:MSTHEMEColor];
    [self.btnCancel setTitle:@"继续考试" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.viewAlert addSubview:self.btnNow];
    [self.viewAlert addSubview:self.btnCancel];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.btnNow.top - 1 ,self.viewAlert.width, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.viewAlert addSubview:imgLine];
    
    
    [self setHidden:YES];
    WS(weakSelf)
    [self.btnNow addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        NSLog(@"交卷");
        if (weakSelf.submitBlock) {
            weakSelf.submitBlock();
        }
        [weakSelf hideMyView];

    }];
    
    [self.btnCancel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [weakSelf hideMyView];
    }];
    
}

- (void)showViewByExamTime:(int)withExamTime byCountNum:(int)withCountNum withAnsweredNum:(int)withAnsweredNum
{
    self.examTime = withExamTime;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"未做题"];
    [attStr setYy_font:WY_FONTRegular(14)];
    [attStr setYy_color:APPTextGayColor];
    
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%d题",withCountNum - withAnsweredNum]];
    [attStr1 setYy_font:WY_FONTRegular(16)];
    [attStr1 setYy_color:[UIColor redColor]];
    [attStr appendAttributedString:attStr1];
    
    self.lblTitle.attributedText = attStr;
    [self.lblExamTime setFont:WY_FONTMedium(16)];
    float progressNum = (float)(withAnsweredNum) / (float)(withCountNum);
    
    self.progressView.progress = progressNum;
    self.progressView.showProgressText = NO;
    self.progressView.duration = 1.5;
    self.progressView.prepareToShow = YES;
    
    [self setHidden:NO];
    
    if (self.examTime <= 0) {
        [imgShiJian setHeight:YES];
        self.lblExamTime.left = 0;
        self.lblExamTime.width = self.viewAlert.width;
        self.lblExamTime.text = @"时间到，请立即交卷否则成绩无效！";
        self.btnNow .width = self.viewAlert.width;
        self.btnNow.left = 0;
        [self.btnNow setBackgroundColor:MSTHEMEColor];
        [self.btnNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnCancel setHidden:YES];
         return ;
    }
    self.mNSTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        self.examTime--;
        if (self.examTime < 0) {
            self.examTime = 0;
        }
        NSString *str_minute = [NSString stringWithFormat:@"%02d", (self.examTime % 3600) / 60];
        NSString *str_second = [NSString stringWithFormat:@"%02d", self.examTime % 60];
        self.lblExamTime.text = [NSString stringWithFormat:@"剩余时间 %@:%@",str_minute,str_second];
        if (self.examTime <= 0) {
            [imgShiJian setHeight:YES];
            self.lblExamTime.left = 0;
            self.lblExamTime.width = self.viewAlert.width;
            self.lblExamTime.text = @"时间到，请立即交卷否则成绩无效！";
             self.btnNow .width = self.viewAlert.width;
            self.btnNow.left = 0;
            [self.btnNow setBackgroundColor:MSTHEMEColor];
            [self.btnNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnCancel setHidden:YES];
            [timer invalidate];
            return ;
        }
    } repeats:YES];
    
}

- (void)hideMyView {
    [self setHidden:YES];
    [self.mNSTimer invalidate];
    
}
///给View设置阴影和圆角
- (void)viewShadowCorner:(UIView *)viewInfoTemp {
    viewInfoTemp.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
    viewInfoTemp.layer.shadowOffset = CGSizeMake(5, 5);
    viewInfoTemp.layer.shadowOpacity = 1;
    viewInfoTemp.layer.shadowRadius = 9.0;
    viewInfoTemp.layer.cornerRadius = k360Width(44) / 8;
    [viewInfoTemp setBackgroundColor:[UIColor whiteColor]];
    viewInfoTemp.clipsToBounds = NO;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
