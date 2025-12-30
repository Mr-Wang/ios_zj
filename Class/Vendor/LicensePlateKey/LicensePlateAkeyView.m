//
//  LicensePlateAkeyView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/9/3.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "LicensePlateAkeyView.h"

@implementation LicensePlateAkeyView
{
    UIView *viewKeys;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubviews];
    }
    
    return self;
}
- (void)addSubviews {
    
    
    //添加分割线
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kHeight(2))];
    [imgLine setBackgroundColor:HEXCOLOR(0xe4e4e4)];
    [self addSubview:imgLine];
    
    UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(kWidth(5), kHeight(10), kWidth(90), kHeight(44))];
    [btnClear setTitle:@"清除" forState:UIControlStateNormal];
    [btnClear setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnClear addTarget:self action:@selector(btnClearAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnClear.titleLabel setFont:[UIFont systemFontOfSize:14]];
    UIButton *btnDetermine = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - kWidth(95), kHeight(10), kWidth(90), kHeight(44))];
    [btnDetermine setTitle:@"完成" forState:UIControlStateNormal];
    [btnDetermine setTitleColor:HEXCOLOR(0xc6a555) forState:UIControlStateNormal];
    [btnDetermine addTarget:self action:@selector(btnDetermineAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnDetermine.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:btnClear];
    [self addSubview:btnDetermine];
    
    
    viewKeys = [[UIView alloc] initWithFrame:CGRectMake(0, btnDetermine.bottom+   kWidth(10), kScreenWidth, kHeight(450))];
    [self addSubview:viewKeys];
    
    [self initViewKeysBy:lpkProvince];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(kWidth(35*2), viewKeys.bottom + kWidth(10), MSScreenW - kWidth(35*2) *2, kWidth(48*2))];
    [self.btnSubmit setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.cornerRadius = 6.0f;
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:0];
    self.btnSubmit.titleLabel.font = WY_FONTRegular(16);
    [self.btnSubmit setBackgroundColor:[UIColor lightGrayColor]];
    [self.btnSubmit setEnabled:NO];
    [self addSubview:self.btnSubmit];
}
- (void)initViewKeysBy:(LicensePlatekeyType)keysType {
    
    for (UIView *viewS in [viewKeys subviews]) {
        [viewS removeFromSuperview];
    }
    
    if(keysType == lpkProvince) {
        self.arrStr = [[NSMutableArray alloc] initWithObjects:@"湘",@"京",@"津",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"渝",@"藏",@"陕",@"甘",@"青",@"宁",@"新",@"港",@"澳",@"台",@"使", nil];

    } else{
        self.arrStr = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"",@"警",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"港",@"澳",@"军",@"领", nil];

    }
    
    float Start_X  = kWidth(15);           // 第一个按钮的X坐标
    float Start_Y = kWidth(15);       // 第一个按钮的Y坐标
    float  Width_Space= kWidth(15);     // 2个按钮之间的横间距
    float  Height_Space =kWidth(15);// 竖间距
    float  Button_Height =kWidth(50);// 高
    float  Button_Width =kWidth(90);// 宽
    
    for (int i =0; i < self.arrStr.count; i ++) {
        NSInteger index = i % 7;
        NSInteger page = i / 7;
        // 圆角按钮
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        [aBt setTitle:self.arrStr[i] forState:UIControlStateNormal];
        aBt.layer.borderColor = HEXCOLOR(0xe4e4e4).CGColor;
        aBt.layer.borderWidth = 1;
//        aBt.layer.masksToBounds = YES;
//        aBt.layer.cornerRadius = aBt.width / 8;
        [aBt setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        aBt.tag = i;
        [aBt addTarget:self action:@selector(keyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewKeys addSubview:aBt];
        if ([self.arrStr[i] isEqualToString:@""]) {
            [aBt setHidden:YES];
        }
    }
}
- (void)keyBtnAction:(UIButton *)btnSender {
    NSString *keyBtnStr = self.arrStr[btnSender.tag];
    NSLog(@"选择了：%@",keyBtnStr);
    
    if  (self.selectedKeyBlock) {
        self.selectedKeyBlock(keyBtnStr);
    }
}
- (void)btnClearAction:(UIButton *)btnSender {
    NSLog(@"点击了消除");
    if(self.clearBlock) {
        self.clearBlock();
    }
}
- (void)btnDetermineAction:(UIButton *)btnSender {
    NSLog(@"点击了确定");
    [self setHidden:YES];
}

- (void)btnSubmitAction:(UIButton *)btnSender {
    NSLog(@"点击了完成- 提取车牌号");
    if (self.btnSubmitBlock) {
        self.btnSubmitBlock();
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
