//
//  WY_UpdateZjPhoneViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/7/23.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_UpdateZjPhoneViewController.h"
#import "MS_WKwebviewsViewController.h"

@interface WY_UpdateZjPhoneViewController ()
{
}
//注册手机号
@property (nonatomic, strong) UITextField *txtPhoneNumber2;
//注册验证码
@property (nonatomic, strong) UITextField *txtYzm;

//发送验证码
@property (nonatomic, strong) UIButton *btnSendYzm;
//注册按钮
@property (nonatomic, strong) UIButton *btnRegistered;


/// 手机号下线
@property (nonatomic, strong) UIView *viewPhoneLine2;
/// 密码下线
@property (nonatomic, strong) UIView *viewPwdLine1;
/// 密码下线
@property (nonatomic, strong) UIView *viewPwdLine2;
/// 验证码下线
@property (nonatomic, strong) UIView *viewYzmLine1;
/// 学号下线
@property (nonatomic, strong) UIView *viewXueHaoLine;
/// 二次密码下线
@property (nonatomic, strong) UIView *viewRePwdLine;

@property (nonatomic, strong) WY_UserModel *mUser;


/// 用户协议View
@property (nonatomic, strong) UIView *viewUserAgr;
/// 选中未选中用户协议图片
@property (nonatomic, strong) UIImageView *selectedImg;

/// 注册协议选中按钮
@property (nonatomic, strong) UIButton *selectedBtn;

/// 用户协议
@property (nonatomic, strong) UILabel *userAgrLab;

/// 用户协议按钮
@property (nonatomic, strong) UIButton *userAgrBtn;
 
@property (nonatomic, strong)NSTimer * yzmTime;
@property (nonatomic) int yzmTimeNum;
@property (nonatomic , assign) BOOL isSelected;/* 是否同意用户协议 */
@property (nonatomic, strong) UIScrollView *mScrollView;
@end

@implementation WY_UpdateZjPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [self makeUI];
    
    // Do any additional setup after loading the view.
}
- (void)makeUI {
    self.title = @"修改专家库预留手机号";
    self.mScrollView = [[UIScrollView alloc] init];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.mScrollView];
 
    
    [self.mScrollView addSubview:self.txtPhoneNumber2];
       [self.mScrollView addSubview:self.txtYzm];
    [self.mScrollView addSubview:self.btnSendYzm];
     [self.mScrollView addSubview:self.viewXueHaoLine];
 

    [self.mScrollView addSubview:self.btnRegistered];
    [self.mScrollView addSubview:self.viewPhoneLine2];
    [self.mScrollView addSubview:self.viewPwdLine2];
    [self.mScrollView addSubview:self.viewYzmLine1];
    [self.mScrollView addSubview:self.viewRePwdLine];
     
    [self.txtPhoneNumber2 setFrame:CGRectMake(  k360Width(16), k360Width(30), kScreenWidth - k360Width(32), k360Width(30))];
    
    [self.viewPhoneLine2 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtPhoneNumber2.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
    
    [self.txtYzm setFrame:CGRectMake(self.txtPhoneNumber2.left, self.viewPhoneLine2.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];

    [self.btnSendYzm setFrame:CGRectMake(self.txtYzm.right - k360Width(110), self.viewPhoneLine2.bottom + k360Width(30 + 2), k360Width(110), self.txtPhoneNumber2.height - k360Width(4))];

    [self.viewYzmLine1 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtYzm.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
    [self.selectedImg setFrame:CGRectMake(  k360Width(18), k360Width(2), kWidth(15*2), kWidth(15*2))];
    [self.selectedBtn setFrame:self.selectedImg.bounds];
    
    [self.viewUserAgr addSubview:self.selectedImg];
      [self.selectedImg addSubview:self.selectedBtn];
      [self.viewUserAgr addSubview:self.userAgrLab];
      [self.userAgrLab addSubview:self.userAgrBtn];
   
    
    // 用户协议
    [self.userAgrLab setFrame:CGRectMake(self.selectedImg.right + k360Width(5), 0, k360Width(200), k360Width(20))];
    [self.userAgrLab sizeToFit];
    // 用户协议按钮
    [self.userAgrBtn setFrame:self.userAgrLab.bounds];
    [self.viewUserAgr setFrame:CGRectMake(0, self.viewYzmLine1.bottom + k360Width(40), kScreenWidth, self.txtPhoneNumber2.height + k360Width(16))];
    
    
    [self.mScrollView addSubview:self.viewUserAgr];
    
    
    [self.btnRegistered setFrame:CGRectMake(k360Width(16) , self.viewUserAgr.top + k360Width(50), kScreenWidth - k360Width(32), k360Width(44))];
    [self.btnRegistered addTarget:self action:@selector(btnRegisteredTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
     [self.btnRegistered setTitle:@"修改手机号" forState:UIControlStateNormal];
    [self.mScrollView addSubview:self.btnRegistered];

    
 }
    
- (UITextField *)txtPhoneNumber2 {
    if (!_txtPhoneNumber2) {
        UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phonenumicon"]];
                     UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
                     loginImgV.center = lv.center;
                     [lv addSubview:loginImgV];
        _txtPhoneNumber2 = [[UITextField alloc] init];
        _txtPhoneNumber2.leftViewMode = UITextFieldViewModeAlways;
        _txtPhoneNumber2.leftView = lv;

        [_txtPhoneNumber2 setPlaceholder:@"请输入手机号"];
        _txtPhoneNumber2.keyboardType = UIKeyboardTypeDecimalPad;
         _txtPhoneNumber2.font = WY_FONTRegular(18);

        
    }
    return _txtPhoneNumber2;
}

  

- (UITextField *)txtYzm {
    if (!_txtYzm) {
        UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yzmicon"]];
                     UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
                     loginImgV.center = lv.center;
                     [lv addSubview:loginImgV];
        _txtYzm = [[UITextField alloc] init];
        _txtYzm.leftViewMode = UITextFieldViewModeAlways;
        _txtYzm.leftView = lv;
        [_txtYzm setPlaceholder:@"请输入验证码"];
  [_txtYzm setFont:WY_FONTRegular(18)];
         _txtYzm.keyboardType = UIKeyboardTypeDecimalPad;


        
    }
    return _txtYzm;
}


- (UIButton *)btnSendYzm {
    if (!_btnSendYzm) {
        _btnSendYzm = [[UIButton alloc] init];
        _btnSendYzm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnSendYzm setTitle:@"发送验证码" forState:UIControlStateNormal];
//        [_btnSendYzm setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
        [_btnSendYzm setBackgroundColor:MSTHEMEColor];
        [_btnSendYzm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnSendYzm rounded:8];
        [_btnSendYzm.titleLabel setFont:WY_FONTRegular(16)];
        [_btnSendYzm addTarget:self action:@selector(btnSendYzmTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSendYzm;
}
 
#pragma mark --注册验证
- (BOOL)isVRegistered {
    BOOL isV = YES;
    if (self.txtPhoneNumber2.text.length !=11) {
        return NO;
    }else if (self.txtYzm.text.length < 4) {
           
      return NO;
    }
    return isV;
}

#pragma mark --懒加载
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

- (UILabel *)userAgrLab {
    if (!_userAgrLab) {
        _userAgrLab = [[UILabel alloc] init];
        
        NSString *contentStr = @"已阅读并同意";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [str setYy_color:[UIColor blackColor]];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:@"《专家信息修改说明》"];
         [str1 setYy_color:MSTHEMEColor];
        [str appendAttributedString:str1];
        _userAgrLab.attributedText = str;
        _userAgrLab.font = WY_FONTRegular(12);
        _userAgrLab.userInteractionEnabled = YES;
    }
    return _userAgrLab;
}
 

- (UIView *)viewPhoneLine2 {
    if (!_viewPhoneLine2) {
        _viewPhoneLine2 = [[UIView alloc] init];
        _viewPhoneLine2.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewPhoneLine2;
}
- (UIView *)viewPwdLine1 {
    if (!_viewPwdLine1) {
        _viewPwdLine1 = [[UIView alloc] init];
        _viewPwdLine1.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewPwdLine1;
}
- (UIView *)viewPwdLine2 {
    if (!_viewPwdLine2) {
        _viewPwdLine2 = [[UIView alloc] init];
        _viewPwdLine2.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewPwdLine2;
}
- (UIView *)viewRePwdLine {
    if (!_viewRePwdLine) {
        _viewRePwdLine = [[UIView alloc] init];
        _viewRePwdLine.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewRePwdLine;
}


- (UIView *)viewYzmLine1 {
    if (!_viewYzmLine1) {
        _viewYzmLine1 = [[UIView alloc] init];
        _viewYzmLine1.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewYzmLine1;
}
- (UIView *)viewXueHaoLine {
    if (!_viewXueHaoLine) {
        _viewXueHaoLine = [[UIView alloc] init];
        _viewXueHaoLine.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewXueHaoLine;
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

- (UIButton *)btnRegistered {
    if (!_btnRegistered) {
        _btnRegistered = [[UIButton alloc] init];
        [_btnRegistered.layer setMasksToBounds:YES];
        [_btnRegistered.layer setCornerRadius:6];
        [_btnRegistered addTarget:self action:@selector(btnRegisteredTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRegistered setTitle:@"注册并登录" forState:UIControlStateNormal];
        _btnRegistered.backgroundColor = MSTHEMEColor;
        [_btnRegistered setTitleColor:[UIColor whiteColor] forState:0];
 
    }
    return _btnRegistered;
}


 
 
      
#pragma mark - # 注册并登录按钮点击

//注册
- (void)btnRegisteredTouchUpInside:(UIButton *)sender {
//    [self loginHttp];
    
    if (!self.isSelected) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并点击同意《专家信息修改说明》"];
           return;
    }
    if (![self isVRegistered]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确手机号码和验证码"];
        return;
    }
    MSLog(@"注册");
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.txtPhoneNumber2.text forKey:@"phone"];
    [postDic setObject:self.txtYzm.text forKey:@"yzm"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idcard"];
 
    [[MS_BasicDataController sharedInstance] postWithURL:zj_expertupdatePhone_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"修改成功");
        //注册成功跳转登录方法
        self.updateSuccessBlock(self.txtPhoneNumber2.text);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
}


#pragma mark --注册发送验证码
- (void)btnSendYzmTouchUpInside:(UIButton *)sender {
    MSLog(@"发送验证码");
    
    if (self.txtPhoneNumber2.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
        return;
    }
    
    WY_UserModel *userModel = [WY_UserModel new];
    userModel.yhdh = self.txtPhoneNumber2.text;
    NSLog(@"%@",[userModel toJSONString]);
    [[MS_BasicDataController sharedInstance] postWithURL:zj_expertsendUpdateMessage_HTTP params:nil jsonData:[userModel toJSONData] showProgressView:YES success:^(id successCallBack) {
        
        self.btnSendYzm.enabled=NO;
        [self.btnSendYzm setTitle:@"60秒后可重发" forState:UIControlStateNormal];
        [self.btnSendYzm setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.yzmTimeNum = 60;
        self.yzmTime=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Time) userInfo:nil repeats:YES];

    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

 }


-(void)Time
{
    self.btnSendYzm.enabled=NO;
//    int a=60;
    self.yzmTimeNum--;
    
 
    [self.btnSendYzm setTitle:[NSString stringWithFormat:@"%d秒后可重发",self.yzmTimeNum] forState:UIControlStateNormal];
 
    if (self.yzmTimeNum<=0) {
        [self.yzmTime invalidate];
        self.yzmTime=nil;
 
        [self.btnSendYzm setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.btnSendYzm setBackgroundColor:MSTHEMEColor];
        [self.btnSendYzm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnSendYzm.enabled=YES;
    }
    
}

#pragma mark --协议文字点击
- (void)userAgrBtnTouchUpInside:(UIButton *)sender {
    
     MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
    wk.titleStr = @"专家信息修改说明";
     wk.webviewURL = @"https://www.capass.cn/Avatar/zjxxxgsm.pdf";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
    navi.navigationBarHidden = NO;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
 
}

#pragma mark --协议按钮选中
- (void)selectedBtnTouchUpInside{
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    
    if (self.isSelected) {
        self.isSelected = NO;
         self.selectedImg.image = [UIImage imageNamed:@"1012_椭圆形"];
    }else{
        self.isSelected = YES;
         self.selectedImg.image = [UIImage imageNamed:@"1012_用户协议选中"];
    }
    
    [userdef setBool:self.isSelected forKey:@"XIEYI_isSelected"];
}
@end
