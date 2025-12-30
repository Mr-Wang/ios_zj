//
//  LicensePlateTextField.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/9/3.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "LicensePlateTextField.h"

@implementation LicensePlateTextField


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubviews];
     }
    
    return self;
}
- (void)addSubviews {
    self.btnS = [[UIButton alloc] initWithFrame:CGRectMake(kWidth(17.5), kHeight(10), kWidth(77.5), kHeight(77.5))];
    self.btnA = [[UIButton alloc] initWithFrame:CGRectMake(self.btnS.right + kWidth(8), kWidth(10), kWidth(77.5), kHeight(77.5))];
    self.btn1 = [[UIButton alloc] initWithFrame:CGRectMake(self.btnA.right + kWidth(22), kWidth(10), kWidth(77.5), kHeight(77.5))];
    self.btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.btn1.right + kWidth(8), kWidth(10), kWidth(77.5), kHeight(77.5))];
    self.btn3 = [[UIButton alloc] initWithFrame:CGRectMake(self.btn2.right + kWidth(8), kWidth(10), kWidth(77.5), kHeight(77.5))];
    self.btn4 = [[UIButton alloc] initWithFrame:CGRectMake(self.btn3.right + kWidth(8), kWidth(10), kWidth(77.5), kHeight(77.5))];
    self.btn5 = [[UIButton alloc] initWithFrame:CGRectMake(self.btn4.right + kWidth(8), kWidth(10), kWidth(77.5), kHeight(77.5))];
    self.btnXin = [[UIButton alloc] initWithFrame:CGRectMake(self.btn5.right + kWidth(8), kWidth(10), kWidth(77.5), kHeight(77.5))];
    self.btnS.tag = 700;
    self.btnA.tag = 701;
    self.btn1.tag = 702;
    self.btn2.tag = 703;
    self.btn3.tag = 704;
    self.btn4.tag = 705;
    self.btn5.tag = 706;
    self.btnXin.tag = 707;
    
    [self initButtonStyle:self.btnS];
    [self initButtonStyle:self.btnA];
    [self initButtonStyle:self.btn1];
    [self initButtonStyle:self.btn2];
    [self initButtonStyle:self.btn3];
    [self initButtonStyle:self.btn4];
    [self initButtonStyle:self.btn5];
    [self initButtonStyle:self.btnXin];
    
    [self addSubview:self.btnS];
    [self addSubview:self.btnA];
    [self addSubview:self.btn1];
    [self addSubview:self.btn2];
    [self addSubview:self.btn3];
    [self addSubview:self.btn4];
    [self addSubview:self.btn5];
    [self addSubview:self.btnXin];
    
    [self btnAction:self.btnS];
    
     [self.btnXin setTitle:@"+" forState:UIControlStateNormal];
}

- (void)initButtonStyle:(UIButton *)btnSender {
    btnSender.layer.borderColor = HEXCOLOR(0xe4e4e4).CGColor;
    btnSender.layer.borderWidth = 1;
    btnSender.layer.masksToBounds = YES;
    btnSender.layer.cornerRadius = btnSender.width / 8;
    [btnSender setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    [btnSender setTitleColor:HEXCOLOR(0xc6a555) forState:UIControlStateSelected];
    [btnSender addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction:(UIButton *)btnSender {
    [self allButtonCancelSelection];
    btnSender.selected = YES;
    btnSender.layer.borderColor = HEXCOLOR(0xc6a555).CGColor;
    
    //判断是否已经输入完整车牌号-
    BOOL isVerification  = YES;
    for (UIButton *btnSender in self.subviews) {
        if ([btnSender isKindOfClass:[UIButton class]]) {
            if (btnSender != self.btnXin && ([btnSender.currentTitle isEqualToString:@""] || btnSender.currentTitle == nil)) {
                isVerification  = NO;
                break;
            }
        }
    }
    
    if (self.selectedButtonAndVerificationBlock) {
        self.selectedButtonAndVerificationBlock(btnSender.tag, isVerification);
    }
}

- (void)allButtonCancelSelection {
    for (UIButton *btnSender in self.subviews) {
        if ([btnSender isKindOfClass:[UIButton class]]) {
            btnSender.layer.borderColor = HEXCOLOR(0xe4e4e4).CGColor;
            btnSender.selected = NO;
        }
    }
}

- (void)addKeysStr:(NSString *)keyStr {
    UIButton *btnS = nil;
    for (UIButton *btnSender in self.subviews) {
        if ([btnSender isKindOfClass:[UIButton class]]) {
            if (btnSender.selected) {
                btnS = btnSender;
                break;
            }
        }
    }
    [btnS setTitle:keyStr forState:UIControlStateNormal];
    if (btnS.tag + 1 < 708) {
        UIButton *nextBtn = [self viewWithTag:btnS.tag + 1];
        [self btnAction:nextBtn];
    }
    
}

- (void)clearKeys {
    UIButton *btnS = nil;
    for (UIButton *btnSender in self.subviews) {
        if ([btnSender isKindOfClass:[UIButton class]]) {
            if (btnSender.selected) {
                btnS = btnSender;
                break;
            }
        }
    }
    if (btnS == self.btnXin) {
        [btnS setTitle:@"+" forState:UIControlStateNormal];
    } else {
        [btnS setTitle:@"" forState:UIControlStateNormal];
    }
    
    if (btnS.tag - 1 >= 700) {
        UIButton *lastBtn = [self viewWithTag:btnS.tag - 1];
        [self btnAction:lastBtn];
    }
    
}

- (NSString *)extractLicensePlate {
    NSString *strLicensePlate = @"";
    for (UIButton *btnSender in self.subviews) {
        if ([btnSender isKindOfClass:[UIButton class]]) {
            if (btnSender != self.btnXin && ![btnSender.currentTitle isEqualToString:@""] && btnSender.currentTitle != nil) {
                strLicensePlate = [strLicensePlate stringByAppendingString:btnSender.currentTitle];
            }
        }
    }
    if (![self.btnXin.currentTitle isEqualToString:@""] && ![self.btnXin.currentTitle isEqualToString:@"+"]) {
        strLicensePlate = [strLicensePlate stringByAppendingString:self.btnXin.currentTitle];
    }
    return strLicensePlate;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
