//
//  WY_UpdatePwdViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/10/25.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_UpdatePwdViewController.h"
#import "OSSUtil.h"

@interface WY_UpdatePwdViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *txtOldPwd;
@property (nonatomic, strong) UITextField *txtNewPwd;
@property (nonatomic, strong) UITextField *txtReNewPwd;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_UpdatePwdViewController
@synthesize txtOldPwd,txtNewPwd,txtReNewPwd;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
}
- (void)makeUI {
    
    self.title = @"修改密码";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.width = 10;
    self.txtOldPwd = [[UITextField alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(328), k360Width(41))];
    [txtOldPwd rounded:k360Width(41/8) width:1 color:HEXCOLOR(0xE5E5E5)];
    txtOldPwd.placeholder = @"请输入旧密码";
    [txtOldPwd setFont:[UIFont systemFontOfSize:14]];
    txtOldPwd.secureTextEntry = YES;
    [txtOldPwd setDelegate:self];
    self.txtOldPwd.leftViewMode = UITextFieldViewModeAlways;
    self.txtOldPwd.leftView = leftView;
    [self.view addSubview:txtOldPwd];
    leftView = [[UIView alloc] init];
    leftView.width = 10;
    self.txtNewPwd = [[UITextField alloc] initWithFrame:CGRectMake(k360Width(16), self.txtOldPwd.bottom + k360Width(16), k360Width(328), k360Width(41))];
    [txtNewPwd rounded:k360Width(41/8) width:1 color:HEXCOLOR(0xE5E5E5)];
    txtNewPwd.placeholder = @"请输入新密码";
    [txtNewPwd setFont:[UIFont systemFontOfSize:14]];
    txtNewPwd.secureTextEntry = YES;
    [txtNewPwd setDelegate:self];
    self.txtNewPwd.leftViewMode = UITextFieldViewModeAlways;
    self.txtNewPwd.leftView = leftView;
    [self.view addSubview:txtNewPwd];
    
    UILabel *lblZi = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16) +self.txtNewPwd.bottom, txtNewPwd.width, k360Width(22))];
    [lblZi setTextColor:[UIColor redColor]];
    lblZi.text = @"密码为6-15位数字、字母、符号组合";
    [self.view addSubview:lblZi];
    
    leftView = [[UIView alloc] init];
    leftView.width = 10;
    self.txtReNewPwd = [[UITextField alloc] initWithFrame:CGRectMake(k360Width(16), lblZi.bottom + k360Width(16), k360Width(328), k360Width(41))];
    [txtReNewPwd rounded:k360Width(41/8) width:1 color:HEXCOLOR(0xE5E5E5)];
    txtReNewPwd.placeholder = @"请再次输入新密码";
    [txtReNewPwd setFont:[UIFont systemFontOfSize:14]];
    txtReNewPwd.secureTextEntry = YES;
    [txtReNewPwd setDelegate:self];
    self.txtReNewPwd.leftViewMode = UITextFieldViewModeAlways;
    self.txtReNewPwd.leftView = leftView;
    [self.view addSubview:txtReNewPwd];
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), self.view.height - k360Width(40 + 16) - JCNew64 - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(30), k360Width(40))];
    [btnLeft setTitle:@"确认修改" forState:UIControlStateNormal];
    [btnLeft rounded:k360Width(40/8)];
    [btnLeft setBackgroundColor:MSTHEMEColor];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLeft];

}
- (void)btnLeftAction{
    if ([self isVRegistered]) {
//        UPDATEPASSWORD
        self.mUser.oldPassword = [[OSSUtil sha1WithString:self.txtOldPwd.text] uppercaseString];
        self.mUser.nsnewPassword = [[OSSUtil sha1WithString:self.txtNewPwd.text] uppercaseString] ;
        NSLog(@"%@",[self.mUser toJSONString]);
        [[MS_BasicDataController sharedInstance] postWithURL:UPDATEPASSWORD_HTTP params:nil jsonData:[self.mUser toJSONData] showProgressView:YES success:^(id successCallBack) {
            MSLog(@"修改密码成功");
            [MS_BasicDataController sharedInstance].user = self.mUser;
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];

            //成功后跳转登录方法
            [self btnBackAction];
        } failure:^(NSString *failureCallBack) {
            [SVProgressHUD showErrorWithStatus:failureCallBack];
        } ErrorInfo:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        }];
    }
}
- (void)btnBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --注册验证
- (BOOL)isVRegistered {
    BOOL isV = YES;
    if (self.txtOldPwd.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [self.txtOldPwd becomeFirstResponder];
        return NO;
//        @"/^[a-zA-Z0-9]{6,15}$/"
    }else if (self.txtNewPwd.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码为6-15位数字、字母、符号组合"];
        [self.txtNewPwd becomeFirstResponder];
        return NO;
    } else if (![GlobalConfig isValidatePwd:self.txtNewPwd.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码为6-15位数字、字母、符号组合"];
        [self.txtNewPwd becomeFirstResponder];
        return NO;
    }
    else if (![self.txtNewPwd.text isEqualToString:self.txtReNewPwd.text]) {
        [self.txtReNewPwd becomeFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return NO;
    }
    return isV;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
