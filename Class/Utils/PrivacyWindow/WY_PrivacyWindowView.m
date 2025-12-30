//
//  WY_PrivacyWindowView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/6/17.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_PrivacyWindowView.h"

@implementation WY_PrivacyWindowView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame] ;
    if (self)
    {
        [self makeUI];
    }
    return self ;
}

- (void)makeUI {
    
    [self setBackgroundColor :[UIColor colorWithWhite:0.f alpha:0.9]];
    
    UIView *viewBG = [UIView new];
    [viewBG setFrame:CGRectMake(k360Width(20), k360Width(100), kScreenWidth - k360Width(40), k360Width(416))];
    [viewBG setBackgroundColor:[UIColor whiteColor]];
    [viewBG rounded:10];
    [self addSubview:viewBG];
    viewBG.centerY = self.centerY;
    
    self.lblTitle = [UILabel new];
    [self.lblTitle setFrame:CGRectMake(0, k360Width(10), viewBG.width, k360Width(44))];
    [self.lblTitle setFont:WY_FONT375Medium(18)];
    [self.lblTitle setTextColor:MSTHEMEColor];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [viewBG addSubview:self.lblTitle];

    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, self.lblTitle.bottom, viewBG.width, k360Width(240))];

    self.lblContent = [UILabel new];
    [self.lblContent setFrame:CGRectMake(k360Width(16),k360Width(10), self.mScrollView.width - k360Width(32), k360Width(44))];
    [self.lblContent setFont:WY_FONT375Medium(14)];
    [self.lblContent setNumberOfLines:0];
    [self.lblContent setLineBreakMode:NSLineBreakByWordWrapping];
    NSMutableAttributedString *attS = [[NSMutableAttributedString alloc] initWithString:@"    尊敬的用户，欢迎您使用辽宁专家服务！为切实尊重用户隐私信息的私有性，依据最新的监管要求更新了《用户使用协议》，特别是关于个人隐私信息保护的条款，特向您说明如下：\n    1．用户在注册账号或使用本服务过程中，会收集使用必要的信息；\n    2．基于您的授权，本APP可能会获取您的位置等信息，您有权拒绝或取消授权；\n    3．本APP将采取技术措施和其他必要的有效措施，确保用户隐私信息安全，防止在本服务中收集的用户隐私信息泄露、毁损或丢失。\n    4．本APP承诺未经用户同意不会非法收集、使用、加工、传输用户个人信息，不会非法买卖、提供或者向任何第三方公开、透露个人信息，不会将用户个人隐私信息使用于任何其他用途。\n    5．为了改善本APP技术和服务，向用户提供更好的服务体验，本APP或可会自行收集使用或向第三方提供用户的非个人隐私信息。"];
    [attS setYy_lineSpacing:5];
    [self.lblContent setAttributedText:attS];
    [self.lblContent sizeToFit];
    [self.mScrollView addSubview:self.lblContent];
    [self.mScrollView setContentSize:CGSizeMake(0, self.lblContent.bottom + k360Width(16))];
    
    [viewBG addSubview:self.mScrollView];
     
    
    [self.viewUserAgr addSubview:self.selectedImg];
      [self.selectedImg addSubview:self.selectedBtn];
      [self.viewUserAgr addSubview:self.userAgrLab];
      [self.userAgrLab addSubview:self.userAgrBtn];
    [viewBG addSubview:self.viewUserAgr];
    
    //用户协议View；
    
    [self.selectedImg setFrame:CGRectMake(k360Width(16), k360Width(2), kWidth(15*2), kWidth(15*2))];
    [self.selectedBtn setFrame:self.selectedImg.bounds];
    
    // 用户协议
    [self.userAgrLab setFrame:CGRectMake(self.selectedImg.right + k360Width(5), 0, k360Width(200), k360Width(20))];
    UIButton *btnAgr2 = [UIButton new];
    UIButton *btnAgr3 = [UIButton new];
    [self.viewUserAgr addSubview:btnAgr2];
    [self.viewUserAgr addSubview:btnAgr3];
    [self.userAgrLab sizeToFit];
    
    [btnAgr2 setFrame:CGRectMake(self.userAgrLab.right, 0, k360Width(100), k360Width(20))];
    [btnAgr2 setTitle:@"《隐私政策》" forState:UIControlStateNormal];
    [btnAgr2 setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    btnAgr2.titleLabel.font = WY_FONTRegular(14);
    btnAgr2.userInteractionEnabled = YES;
    [btnAgr2 addTarget:self action:@selector(btnYinsiAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAgr2 sizeToFit];
      
    [btnAgr2 setCenterY:self.userAgrLab.centerY];
    
    // 用户协议按钮
    [self.userAgrBtn setFrame:self.userAgrLab.bounds];
     
  
    [self.viewUserAgr setFrame:CGRectMake(0, self.mScrollView.bottom + k360Width(20), kScreenWidth, k360Width(40))];

    
    self.btnClose = [UIButton new];
    [self.btnClose setFrame:CGRectMake(k360Width(16), self.viewUserAgr.bottom, (viewBG.width - k360Width(32+16)) /2, k360Width(44))];
    [self.btnClose setBackgroundColor:HEXCOLOR(0xBDBDBD)];
    [self.btnClose setTitle:@"暂不使用" forState:UIControlStateNormal];
    [self.btnClose rounded:k360Width(44/8)];
    [viewBG addSubview:self.btnClose];
    
    [self.btnClose setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (self.didCloseBtnAction) {
                self.didCloseBtnAction();
            }
    }];

    self.btnStart = [UIButton new];
    [self.btnStart setFrame:CGRectMake(self.btnClose.right + k360Width(16), self.viewUserAgr.bottom, self.btnClose.width, k360Width(44))];
    [self.btnStart setBackgroundColor:MSTHEMEColor];
    [self.btnStart setTitle:@"同意并继续使用" forState:UIControlStateNormal];
    [self.btnStart rounded:k360Width(44/8)];
    [viewBG addSubview:self.btnStart];
    
    [self.btnStart setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.isSelected) {
            [self setHidden:YES];
            if (self.didStartBtnAction) {
                self.didStartBtnAction();
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请勾选阅读并同意协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }
            
    }];
     
    
    
    self.lblTitle.text = @"用户隐私政策概要";
 }



#pragma mark --懒加载


- (UILabel *)userAgrLab {
    if (!_userAgrLab) {
        _userAgrLab = [[UILabel alloc] init];
        
        NSString *contentStr = @"已阅读并同意";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [str setYy_color:[UIColor blackColor]];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:@"《用户服务协议》"];
          [str1 setYy_color:MSTHEMEColor];
         _userAgrLab.attributedText = str;
        _userAgrLab.font = WY_FONTRegular(14);
        _userAgrLab.userInteractionEnabled = YES;
    }
    return _userAgrLab;
}

- (UIImageView *)selectedImg {
    if (!_selectedImg) {
        _selectedImg = [[UIImageView alloc] init];
        _selectedImg.image = [UIImage imageNamed:@"1012_椭圆形"];
        _selectedImg.userInteractionEnabled = YES;
    }
    return _selectedImg;
}

- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [[UIButton alloc] init];
        [_selectedBtn addTarget:self action:@selector(selectedBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        self.isSelected = NO;
    }
    return _selectedBtn;
}

- (UIView *)viewUserAgr {
    if (!_viewUserAgr) {
        _viewUserAgr = [[UIView alloc] init];
     }
    return _viewUserAgr;
}


- (UIButton *)userAgrBtn {
    if (!_userAgrBtn) {
        _userAgrBtn = [[UIButton alloc] init];
        [_userAgrBtn addTarget:self action:@selector(userAgrBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAgrBtn;
}


#pragma mark --隐私政策协议点击


#pragma mark --协议文字点击
- (void)userAgrBtnTouchUpInside:(UIButton *)sender {
    
//     MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
//    wk.titleStr = @"用户服务协议";
//    wk.webviewURL = @"https://www.capass.cn/Avatar/zjapp.pdf";
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
//    navi.navigationBarHidden = NO;
//    navi.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:navi animated:YES completion:nil];

    if (self.didUserAgreementBtnAction) {
        self.didUserAgreementBtnAction();
    }
}
 
- (void)btnYinsiAction:(UIButton *)sender {
//   MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
//  wk.titleStr = @"隐私政策";
//   wk.webviewURL = @"https://www.capass.cn/Avatar/ysxy.pdf";
//  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
//  navi.navigationBarHidden = NO;
//  navi.modalPresentationStyle = UIModalPresentationFullScreen;
//  [self presentViewController:navi animated:NO completion:nil];
    if (self.didPrivacyAgreementBtnAction) {
        self.didPrivacyAgreementBtnAction();
    }
}


#pragma mark --协议按钮选中
- (void)selectedBtnTouchUpInside{
//    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    
    if (self.isSelected) {
        self.isSelected = NO;
         self.selectedImg.image = [UIImage imageNamed:@"1012_椭圆形"];
    }else{
        self.isSelected = YES;
         self.selectedImg.image = [UIImage imageNamed:@"1012_用户协议选中"];
    }
    
//    [userdef setBool:self.isSelected forKey:@"XIEYI_isSelected"];
}
@end
