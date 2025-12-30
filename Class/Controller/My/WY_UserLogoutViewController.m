//
//  WY_UserLogoutViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/6/18.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_UserLogoutViewController.h"

@interface WY_UserLogoutViewController ()
@property (nonatomic, strong) UIScrollView *mScrollView;

//登录手机号
 /// 手机号下线
@property (nonatomic, strong) UIView *viewPhoneLine2;
/// 验证码下线
@property (nonatomic, strong) UIView *viewYzmLine1;
//注册手机号
@property (nonatomic, strong) UITextField *txtPhoneNumber2;

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

@property (nonatomic, strong) UILabel *lblTiShi;
@property (nonatomic, strong) UIButton *lblTiShi2;
@property (nonatomic, strong) UILabel *lblPhoneTS;
@property (nonatomic, strong) UILabel *lblCodeTS;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_UserLogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [MS_BasicDataController sharedInstance].user;

    [self makeUI];
}
- (void)makeUI {
    
    self.title = @"申请删除账号";
    self.mScrollView = [[UIScrollView alloc] init];
       [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64)];
       [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
       [self.view addSubview:self.mScrollView];
    

    
    self.lblTiShi = [UILabel new];
    [self.lblTiShi setFrame:CGRectMake(k360Width(15), k360Width(20), kScreenWidth - k360Width(32), k360Width(100))];
    [self.lblTiShi setNumberOfLines:0];
    [self.lblTiShi setLineBreakMode:NSLineBreakByWordWrapping];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"    您正在申请注销账号，注销后您原账号中的身份信息，课程学习进程、模考分数等全部历史信息将被清空且无法找回。请确保您账号中所有功能进程已完结且无纠纷，且您无法在一个月内重新注册账号，请谨慎操作！"];
    
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"\n\n验证手机号码"];

    [attStr setYy_font:WY_FONTMedium(14)];
    
    
    [attStr1 setYy_font:WY_FONTMedium(18)];
    [attStr appendAttributedString:attStr1];
    [attStr setYy_lineSpacing:5];
    
    [self.lblTiShi setAttributedText:attStr];
    [self.mScrollView addSubview:self.lblTiShi];
    [self.lblTiShi sizeToFit];
    
    
    [self.mScrollView addSubview:self.txtPhoneNumber2];
    [self.mScrollView addSubview:self.txtYzm];
    [self.mScrollView addSubview:self.btnSendYzm];
    
    

    [self.mScrollView addSubview:self.btnRegistered];
    [self.mScrollView addSubview:self.viewPhoneLine2];
    [self.mScrollView addSubview:self.viewYzmLine1];
 
    self.lblPhoneTS = [UILabel new];
    self.lblCodeTS = [UILabel new];
    [self.lblPhoneTS setFrame:CGRectMake(k360Width(16), self.lblTiShi.bottom +  k360Width(20), k360Width(80), k360Width(30))];
    [self.lblPhoneTS setText:@"当前号码"];
    [self.lblPhoneTS setTextColor:APPBlackColor];
    [self.mScrollView addSubview:self.lblPhoneTS];

    

    
    [self.txtPhoneNumber2 setFrame:CGRectMake(self.lblPhoneTS.right, self.lblTiShi.bottom +  k360Width(20), kScreenWidth - self.lblPhoneTS.right - k360Width(16), k360Width(30))];
    
    [self.viewPhoneLine2 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtPhoneNumber2.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
    
    self.lblCodeTS = [UILabel new];
    self.lblCodeTS = [UILabel new];
    [self.lblCodeTS setFrame:CGRectMake(k360Width(16), self.viewPhoneLine2.bottom + k360Width(30), k360Width(80), k360Width(30))];
    [self.lblCodeTS setText:@"验证码"];
    [self.lblCodeTS setTextColor:APPBlackColor];
    
    [self.mScrollView addSubview:self.lblCodeTS];
    
    [self.txtYzm setFrame:CGRectMake(self.txtPhoneNumber2.left, self.viewPhoneLine2.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];
    
    [self.btnSendYzm setFrame:CGRectMake(kScreenWidth - k360Width(110), self.viewPhoneLine2.bottom + k360Width(30 + 2), k360Width(110-16), self.txtPhoneNumber2.height - k360Width(4))];
    
    [self.viewYzmLine1 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtYzm.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
  
    self.lblTiShi2 = [UIButton new];
    [self.lblTiShi2 setFrame:CGRectMake(k360Width(16), self.viewYzmLine1.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(60))];
    
    NSMutableAttributedString *attStrA1 = [[NSMutableAttributedString alloc] initWithString:@"若当前号码已经不用或丢失，您可拨打"];
    
    NSMutableAttributedString *attStrA2 = [[NSMutableAttributedString alloc] initWithString:@" 024-86082777 "];
    
    NSMutableAttributedString *attStrA3 = [[NSMutableAttributedString alloc] initWithString:@"客服热线进行咨询"];
    
    [attStrA2 setYy_color:MSTHEMEColor];
    [attStrA1 setYy_color:APPBlackColor];
    [attStrA3 setYy_color:APPBlackColor];
    
    [attStrA1 appendAttributedString:attStrA2];
    [attStrA1 appendAttributedString:attStrA3];
    [attStrA1 setYy_font:WY_FONTMedium(12)];
    [self.lblTiShi2 setAttributedTitle:attStrA1 forState:UIControlStateNormal];
    [self.mScrollView addSubview:self.lblTiShi2];
    [self.lblTiShi2.titleLabel setNumberOfLines:0];
    [self.lblTiShi2.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblTiShi2 setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.lblTiShi2 setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [GlobalConfig makeCall:@"13644978185"];
    }];
//    [self.lblTiShi2 sizeToFit];
    
    [self.btnRegistered setFrame:CGRectMake(k360Width(16), self.lblTiShi2.bottom + k360Width(40), kScreenWidth - k360Width(32), k360Width(46))];
    
     
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, self.btnRegistered.bottom + k360Width(32))];
 
    self.txtPhoneNumber2.text = self.mUser.LoginID;
    [self.txtPhoneNumber2 setUserInteractionEnabled:NO];
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
 
        [_txtPhoneNumber2 setDelegate:self];
        _txtPhoneNumber2.font = WY_FONTRegular(16);

        
    }
    return _txtPhoneNumber2;
}
 
 

- (UITextField *)txtYzm {
    if (!_txtYzm) {
        _txtYzm = [[UITextField alloc] init];
                [_txtYzm setFont:WY_FONTRegular(16)];
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


- (UIView *)viewPhoneLine2 {
    if (!_viewPhoneLine2) {
        _viewPhoneLine2 = [[UIView alloc] init];
        _viewPhoneLine2.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewPhoneLine2;
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
        [_btnRegistered setTitle:@"申请删除账号" forState:UIControlStateNormal];
        _btnRegistered.backgroundColor = HEXCOLOR(0xdd2c33);
        [_btnRegistered setTitleColor:[UIColor whiteColor] forState:0];
 
    }
    return _btnRegistered;
}


 
#pragma mark - # 修改并登录按钮点击

- (void)btnRegisteredTouchUpInside:(UIButton *)sender {
//    [self loginHttp];
    MSLog(@"申请删除账号");
    if ([self isVRegistered]) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"警告" message:@"确认申请删除当前账户" preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self delUserLogout];
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertControl animated:YES completion:nil];

    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确验证码"];
    }
 }


- (void)delUserLogout {
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    
    [dicPost setObject:self.txtYzm.text forKey:@"yzm"];
    [dicPost setObject:self.mUser.LoginID forKey:@"loginID"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_userlogout_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id successCallBack) {
 
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"申请删除账号成功，请耐心等待审核，客服人员会在15个工作日内与您联系确认删除账号，或者您也可主动联系我们帮助您快速审核 024-86082777" preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
         }]];
        [self presentViewController:alertControl animated:YES completion:nil];

    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
