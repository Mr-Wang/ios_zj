//
//  WY_LostPwdViewController.m
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/14.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_LostPwdViewController.h"
#import "OSSUtil.h"

@interface WY_LostPwdViewController ()
{
    UIView *rightView;
}
@property (nonatomic, strong) UIScrollView *mScrollView;

//登录手机号
 /// 手机号下线
@property (nonatomic, strong) UIView *viewPhoneLine2;
 /// 密码下线
@property (nonatomic, strong) UIView *viewPwdLine2;
/// 验证码下线
@property (nonatomic, strong) UIView *viewYzmLine1;
/// 二次密码下线
@property (nonatomic, strong) UIView *viewRePwdLine;
//注册手机号
@property (nonatomic, strong) UITextField *txtPhoneNumber2;
//注册密码
@property (nonatomic, strong) UITextField *txtPwd2;
//注册密码再次输入
@property (nonatomic, strong) UITextField *txtRePwd;
//注册验证码
@property (nonatomic, strong) UITextField *txtYzm;
//发送验证码
@property (nonatomic, strong) UIButton *btnSendYzm;
//注册按钮
@property (nonatomic, strong) UIButton *btnRegistered;
//验证码Timer
@property (nonatomic, strong)NSTimer * yzmTime;
//验证码时间
@property (nonatomic) int yzmTimeNum;
@end

@implementation WY_LostPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    
}
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -- 页面布局
- (void)makeUI{
     int topY = MH_APPLICATION_STATUS_BAR_HEIGHT; 
    self.mScrollView = [[UIScrollView alloc] init];
       [self.mScrollView setFrame:CGRectMake(0, topY, kScreenWidth, kScreenHeight)];
       [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
       [self.view addSubview:self.mScrollView];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(4), k360Width(16), k360Width(44), k360Width(44))];
    [btnBack setImage:[UIImage imageNamed:@"1012_返回"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];

    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(100), kScreenWidth / 2, k360Width(33))];
    [lbl1 setText:@"忘记登录密码"];
    [lbl1 setFont:[UIFont fontWithName:@"PingFang SC" size:20]];
    [self.mScrollView addSubview:lbl1];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), lbl1.bottom, kScreenWidth / 2, k360Width(33))];
    [lbl2 setText:@"请输入手机号进行找回"];
    [lbl2 setFont:[UIFont fontWithName:@"PingFang SC" size:12]];
    [self.mScrollView addSubview:lbl2];
     
    
    //注册View
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, lbl2.bottom, kScreenWidth, 320)];
    
    [self.mScrollView addSubview:rightView];
    
    [self initRightView];

    
}

#pragma mark --加载找回密码View
- (void) initRightView {
    
    [rightView addSubview:self.txtPhoneNumber2];
    [rightView addSubview:self.txtYzm];
    [rightView addSubview:self.btnSendYzm];
    [rightView addSubview:self.txtPwd2];
    [rightView addSubview:self.txtRePwd];
    
    

    [rightView addSubview:self.btnRegistered];
    [rightView addSubview:self.viewPhoneLine2];
    [rightView addSubview:self.viewPwdLine2];
    [rightView addSubview:self.viewYzmLine1];
    [rightView addSubview:self.viewRePwdLine];
     
    
    [self.txtPhoneNumber2 setFrame:CGRectMake(k360Width(16), k360Width(59), kScreenWidth - k360Width(32), k360Width(30))];
    
    [self.viewPhoneLine2 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtPhoneNumber2.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
    
    [self.txtYzm setFrame:CGRectMake(self.txtPhoneNumber2.left, self.viewPhoneLine2.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];
    
    [self.btnSendYzm setFrame:CGRectMake(kScreenWidth - k360Width(110), self.viewPhoneLine2.bottom + k360Width(30 + 2), k360Width(110-16), self.txtPhoneNumber2.height - k360Width(4))];
    
    [self.viewYzmLine1 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtYzm.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
 
    [self.txtPwd2 setFrame:CGRectMake(k360Width(16), self.viewYzmLine1.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];
    
    [self.viewPwdLine2 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtPwd2.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];

    [self.txtRePwd setFrame:CGRectMake(k360Width(16), self.viewPwdLine2.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];
      
    [self.viewRePwdLine setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtRePwd.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
    
    [self.btnRegistered setFrame:CGRectMake(k360Width(16), self.viewRePwdLine.bottom + k360Width(40), kScreenWidth - k360Width(32), k360Width(46))];
    
    rightView.height = self.btnRegistered.bottom;
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, rightView.bottom + k360Width(32))];
 
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
    [[MS_BasicDataController sharedInstance] postWithURL:LOSTPWD_SEND_SHORT_HTTP params:nil jsonData:[userModel toJSONData] showProgressView:YES success:^(id successCallBack) {
        
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
        [self.btnSendYzm setTitleColor:MSColor(51, 51, 51) forState:UIControlStateNormal];
        self.btnSendYzm.enabled=YES;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --懒加载

- (UITextField *)txtPhoneNumber2 {
    if (!_txtPhoneNumber2) {
        _txtPhoneNumber2 = [[UITextField alloc] init];
        [_txtPhoneNumber2 setPlaceholder:@"请输入手机号"];
        _txtPhoneNumber2.keyboardType = UIKeyboardTypeDecimalPad;
        [_txtPhoneNumber2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        [_txtPhoneNumber2 setDelegate:self];
        _txtPhoneNumber2.font = WY_FONTRegular(16);

        
    }
    return _txtPhoneNumber2;
}

- (UITextField *)txtPwd2 {
    if (!_txtPwd2) {
        _txtPwd2 = [[UITextField alloc] init];
        [_txtPwd2 setPlaceholder:@"密码为6-15位数字、字母、符号组合"];

                [_txtPwd2 setFont:WY_FONTRegular(16)];
                [_txtPwd2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                _txtPwd2.secureTextEntry = YES;
                [_txtPwd2 setDelegate:self];


        
    }
    return _txtPwd2;
}
 
- (UITextField *)txtRePwd {
    if (!_txtRePwd) {
        _txtRePwd = [[UITextField alloc] init];
        [_txtRePwd setPlaceholder:@"请再次请输入密码"];

                [_txtRePwd setFont:WY_FONTRegular(16)];
                [_txtRePwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                _txtRePwd.secureTextEntry = YES;
                [_txtRePwd setDelegate:self];


        
    }
    return _txtRePwd;
}
- (UITextField *)txtYzm {
    if (!_txtYzm) {
        _txtYzm = [[UITextField alloc] init];
        [_txtYzm setPlaceholder:@"请输入验证码"];

                [_txtYzm setFont:WY_FONTRegular(16)];
                [_txtYzm addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                 [_txtYzm setDelegate:self];
        _txtYzm.keyboardType = UIKeyboardTypeDecimalPad;

        
    }
    return _txtYzm;
}

- (UIButton *)btnSendYzm {
    if (!_btnSendYzm) {
        _btnSendYzm = [[UIButton alloc] init];
        [_btnSendYzm setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnSendYzm.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_btnSendYzm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnSendYzm setBackgroundColor:MSTHEMEColor];
        [_btnSendYzm rounded:15];
        [_btnSendYzm addTarget:self action:@selector(btnSendYzmTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSendYzm;
}


- (void) textFieldDidChange:(id) sender {
    
       if ([self isVRegistered]) {
           
               [self.btnRegistered setBackgroundImage:[UIImage imageNamed:@"1012_dengrukuang"] forState:UIControlStateNormal];
               self.btnRegistered.userInteractionEnabled = YES;

           } else {
               [self.btnRegistered setBackgroundImage:nil forState:UIControlStateNormal];
                 self.btnRegistered.backgroundColor = MSColorA(153, 153, 153, 0.5);
               self.btnRegistered.userInteractionEnabled = NO;

           }
    
}


#pragma mark --注册验证
- (BOOL)isVRegistered {
    BOOL isV = YES;
    if (self.txtPhoneNumber2.text.length !=11) {
        return NO;
    }else if (self.txtPwd2.text.length < 6) {
        return NO;
        
    }else if (![self.txtPwd2.text isEqualToString:self.txtRePwd.text]) {
        return NO;
      
    }else if (self.txtYzm.text.length < 4) {
           
      return NO;
    }
    return isV;
}


- (UIView *)viewPhoneLine2 {
    if (!_viewPhoneLine2) {
        _viewPhoneLine2 = [[UIView alloc] init];
        _viewPhoneLine2.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewPhoneLine2;
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
 
 
- (UIButton *)btnRegistered {
    if (!_btnRegistered) {
        _btnRegistered = [[UIButton alloc] init];
        [_btnRegistered.layer setMasksToBounds:YES];
        [_btnRegistered.layer setCornerRadius:6];
        [_btnRegistered addTarget:self action:@selector(btnRegisteredTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRegistered setTitle:@"修改并登录" forState:UIControlStateNormal];
        _btnRegistered.backgroundColor = MSColorA(153, 153, 153, 0.5);
        [_btnRegistered setTitleColor:[UIColor whiteColor] forState:0];
        _btnRegistered.userInteractionEnabled = NO;

    }
    return _btnRegistered;
}


 
#pragma mark - # 修改并登录按钮点击

- (void)btnRegisteredTouchUpInside:(UIButton *)sender {
//    [self loginHttp];
    MSLog(@"修改密码 并登陆")
     if (![GlobalConfig isValidatePwd:self.txtPwd2.text]) {
         [SVProgressHUD showErrorWithStatus:@"密码为6-15位数字、字母、符号组合"];
         [self.txtPwd2 becomeFirstResponder];
         return;
     }
       WY_UserModel *userModel = [WY_UserModel new];
       userModel.yhdh = self.txtPhoneNumber2.text;
        userModel.PassWD = [[OSSUtil sha1WithString:self.txtPwd2.text] uppercaseString] ;
       userModel.yzm = self.txtYzm.text;
       NSLog(@"%@",[userModel toJSONString]);
       [[MS_BasicDataController sharedInstance] postWithURL:RESETPWD_HTTP params:nil jsonData:[userModel toJSONData] showProgressView:YES success:^(id successCallBack) {
           MSLog(@"修改密码成功");
           //成功后跳转登录方法
           [self btnBackAction];
           //发送修改密码成功block
           if (self.updatePwdSuccessBlock) {
             self.updatePwdSuccessBlock(self.txtPhoneNumber2.text,self.txtPwd2.text);
           }
           
       } failure:^(NSString *failureCallBack) {
           [SVProgressHUD showErrorWithStatus:failureCallBack];
       } ErrorInfo:^(NSError *error) {
           [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
       }];
}



- (void)btnBackAction {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)shouldAutorotate {
     return NO;
}
///
/// 控制器旋转支持的方向
///
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
 }
@end
