//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by 丁宗凯 on 16/6/22.
//  Copyright © 2016年 dzk. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIView+SDAutoLayout.h"

#define AlertViewJianGe 19.5
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width            // 屏幕宽
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height          // 屏幕高
#define SCREEN_PRESENT [[UIScreen mainScreen] bounds].size.width/375.0  // 屏幕宽高比例
#define DarkGrayColor [UIColor colorWithRGB:0x333333]     // 深灰色
#define WhiteColor  [UIColor whiteColor]                  // 白色
#define LightGrayColor [UIColor colorWithRGB:0x999999]    // 浅灰色

#define cornerRadiusView(View, Radius) \
\
[View.layer setCornerRadius:(Radius)];           \
[View.layer setMasksToBounds:YES]

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ColorAlphe(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@implementation CustomAlertView

-(instancetype)initWithAlertViewHeight:(CGFloat)height withImage:(UIImage *)withImage
{
    self=[super init];
    if (self) {
        if (self.bGView==nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.5;
       
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            self.bGView =view;
        }
        
        self.frame = CGRectMake(k360Width(32),k360Width(100),kScreenWidth - k360Width(64),k360Width(450));
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        //中间弹框的view
        UIView *popView = [[UIView alloc] initWithFrame:self.bounds];
        popView.backgroundColor = [UIColor whiteColor];
        cornerRadiusView(popView, 5);
        [self addSubview:popView];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"请确认专家资格证书证件照，确认后将无法修改";
        lab.textColor = [UIColor redColor];
        lab.font = WY_FONT375Medium(16);
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setNumberOfLines:2];
        [popView addSubview:lab];
        [lab setFrame:CGRectMake(k360Width(15), k360Width(15), popView.width - k360Width(30), k360Width(60))];
//        lab.sd_layout.leftSpaceToView(popView,15).rightSpaceToView(popView,15).topSpaceToView(popView,15).heightIs(60);
        
        UIImageView *meetImage =[[UIImageView alloc] init];
        meetImage.image = withImage;
        [popView addSubview:meetImage];
//        [meetImage setFrame:CGRectMake(k360Width(32), lab.bottom + k360Width(10), popView.width - k360Width(64), k360Width(250))];
        meetImage.top = lab.bottom + k360Width(5);
        meetImage.width = k360Width(200);//withImage.size.width / 15;
        meetImage.height = k360Width(240);//withImage.size.height / 15;
        meetImage.centerX = lab.centerX;
         UIButton *calendarBtn = [UIButton new];
        calendarBtn.tag =100;
        calendarBtn.backgroundColor = MSTHEMEColor;
        [popView addSubview:calendarBtn];
        calendarBtn.sd_layout.leftSpaceToView(popView,10).rightSpaceToView(popView,10).topSpaceToView(meetImage,25).heightIs(50);
        [calendarBtn setTitle:@"确定上传" forState:UIControlStateNormal];
        [calendarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        calendarBtn.layer.shadowOffset =  CGSizeMake(1, 1);
        calendarBtn.layer.shadowOpacity = 0.8;
        calendarBtn.layer.shadowColor =  MSTHEMEColor.CGColor;
        calendarBtn.layer.cornerRadius= 5;
        [calendarBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *knowBtn = [UIButton new];
        knowBtn.backgroundColor = WhiteColor;
        [popView addSubview:knowBtn];
        knowBtn.tag =101;
        knowBtn.sd_layout.leftSpaceToView(popView,10).rightSpaceToView(popView,10).topSpaceToView(calendarBtn,10).heightIs(50);
        [knowBtn setTitle:@"取消" forState:UIControlStateNormal];
        [knowBtn.titleLabel setFont:WY_FONT375Medium(14)];
        [knowBtn setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
        [knowBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self show:YES];

    }
    return self;
}



-(instancetype)initWithAlertViewHeight:(CGFloat)height withImage:(NSString *)withImage withTitle:(NSString *)titleStr
{
    self=[super init];
    if (self) {
        if (self.bGView==nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.5;
       
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            self.bGView =view;
        }
        
        self.frame = CGRectMake(k360Width(32),k360Width(100),kScreenWidth - k360Width(64),k360Width(450));
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        //中间弹框的view
        UIView *popView = [[UIView alloc] initWithFrame:self.bounds];
        popView.backgroundColor = [UIColor whiteColor];
        cornerRadiusView(popView, 5);
        [self addSubview:popView];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = titleStr;
        lab.textColor = [UIColor redColor];
        lab.font = WY_FONT375Medium(16);
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setNumberOfLines:0];
        [lab setLineBreakMode:NSLineBreakByWordWrapping];
        [popView addSubview:lab];
        [lab setFrame:CGRectMake(k360Width(15), k360Width(15), popView.width - k360Width(30), k360Width(60))];
//        lab.sd_layout.leftSpaceToView(popView,15).rightSpaceToView(popView,15).topSpaceToView(popView,15).heightIs(60);
        [lab sizeToFit];
        lab.height += 10;
        UIImageView *meetImage =[[UIImageView alloc] init];
        [meetImage sd_setImageWithURL:[NSURL URLWithString:withImage]];
        
//        meetImage.image = withImage;
        [popView addSubview:meetImage];
//        [meetImage setFrame:CGRectMake(k360Width(32), lab.bottom + k360Width(10), popView.width - k360Width(64), k360Width(250))];
        meetImage.top = lab.bottom + k360Width(5);
        meetImage.width = k360Width(200);//withImage.size.width / 15;
        meetImage.height = k360Width(200);//withImage.size.height / 15;
        meetImage.centerX = lab.centerX;
         UIButton *calendarBtn = [UIButton new];
        calendarBtn.tag =100;
        calendarBtn.backgroundColor = MSTHEMEColor;
        [popView addSubview:calendarBtn];
        calendarBtn.sd_layout.leftSpaceToView(popView,10).rightSpaceToView(popView,10).topSpaceToView(meetImage,25).heightIs(50);
        [calendarBtn setTitle:@"确  定" forState:UIControlStateNormal];
        [calendarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        calendarBtn.layer.shadowOffset =  CGSizeMake(1, 1);
        calendarBtn.layer.shadowOpacity = 0.8;
        calendarBtn.layer.shadowColor =  MSTHEMEColor.CGColor;
        calendarBtn.layer.cornerRadius= 5;
        [calendarBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *knowBtn = [UIButton new];
        knowBtn.backgroundColor = WhiteColor;
        [popView addSubview:knowBtn];
        knowBtn.tag =101;
        knowBtn.sd_layout.leftSpaceToView(popView,10).rightSpaceToView(popView,10).topSpaceToView(calendarBtn,10).heightIs(50);
        [knowBtn setTitle:@"重新编辑" forState:UIControlStateNormal];
        [knowBtn.titleLabel setFont:WY_FONT375Medium(14)];
        [knowBtn setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
        [knowBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self show:YES];

    }
    return self;
}

-(void)buttonClick:(UIButton*)button
{
    [self hide:YES];
    if (self.ButtonClick) {
        self.ButtonClick(button);
    }
}
- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak CustomAlertView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bGView != nil) {
        __weak CustomAlertView *weakSelf = self;
        
        [UIView animateWithDuration:animated ?0.3: 0 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1,1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: animated ?0.3: 0 animations:^{
                weakSelf.transform = CGAffineTransformScale(weakSelf.transform,0.2,0.2);
            } completion:^(BOOL finished) {
                [weakSelf.bGView removeFromSuperview];
                [weakSelf removeFromSuperview];
                weakSelf.bGView=nil;
            }];
        }];
    }
    
}

@end
