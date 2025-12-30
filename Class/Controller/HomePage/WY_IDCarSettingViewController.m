//
//  WY_IDCarSettingViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/21.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_IDCarSettingViewController.h"
#import "WY_SelectCompanyViewController.h"

@interface WY_IDCarSettingViewController ()
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UITextField *txtIDCar;
@property (nonatomic, strong) UITextField *txtName;

@property (nonatomic, strong) WY_UserModel *mUser;
/// 手机号下线
@property (nonatomic, strong) UIView *viewPhoneLine1;
/// 手机号下线
@property (nonatomic, strong) UIView *viewPhoneLine2;
//注册按钮
@property (nonatomic, strong) UIButton *btnRegistered;
@end

@implementation WY_IDCarSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

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

    #pragma mark --绘制页面；
    - (void)makeUI {
        int topY = MH_APPLICATION_STATUS_BAR_HEIGHT;
        self.mScrollView = [[UIScrollView alloc] init];
        [self.mScrollView setFrame:CGRectMake(0, -topY, kScreenWidth, kScreenHeight + topY)];
        [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.mScrollView];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(4), k360Width(16), k360Width(44), k360Width(44))];
           [btnBack setImage:[UIImage imageNamed:@"1012_返回"] forState:UIControlStateNormal];
           [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
           [self.view addSubview:btnBack];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(k360Width(30), k360Width(101), k360Width(140), k360Width(28));
        label.text = @"请完善个人信息";
        label.font = WY_FONTMedium(20);
        label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.87/1.0];
        [self.mScrollView addSubview:label];
        
        [self.txtName setFrame:CGRectMake(k360Width(32), label.bottom + k360Width(64), kScreenWidth - k360Width(64), k360Width(30))];
        
        [self.viewPhoneLine1 setFrame:CGRectMake(self.txtName.left, self.txtName.bottom + k360Width(2), self.txtName.width, 1)];
        
        [self.txtIDCar setFrame:CGRectMake(self.viewPhoneLine1.left, self.viewPhoneLine1.bottom + k360Width(30), self.viewPhoneLine1.width,  k360Width(30))];
        
        [self.viewPhoneLine2 setFrame:CGRectMake(self.txtIDCar.left, self.txtIDCar.bottom + k360Width(2), self.txtIDCar.width, 1)];
        
        [self.mScrollView addSubview:self.txtName];
        [self.mScrollView addSubview:self.viewPhoneLine1];
        [self.mScrollView addSubview:self.txtIDCar];
        [self.mScrollView addSubview:self.viewPhoneLine2];
        
        [self.btnRegistered setFrame:CGRectMake(k360Width(30), kScreenHeight - k360Width(86), kScreenWidth - k360Width(60), k360Width(46))];
        [self.mScrollView addSubview:self.btnRegistered];

    }

- (UITextField *)txtName {
    if (!_txtName) {
        UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phonenumicon"]];
               UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
               loginImgV.center = lv.center;
               [lv addSubview:loginImgV];
        
        _txtName = [[UITextField alloc] init];
        _txtName.leftViewMode = UITextFieldViewModeAlways;
        _txtName.leftView = lv;
        [_txtName setPlaceholder:@"请输入姓名"];
         _txtName.keyboardType = UIKeyboardTypeDefault;
        [_txtName setDelegate:self];
        _txtName.font = WY_FONTRegular(16);

        
    }
    return _txtName;
}

 - (UIView *)viewPhoneLine1 {
     if (!_viewPhoneLine1) {
         _viewPhoneLine1 = [[UIView alloc] init];
         _viewPhoneLine1.backgroundColor =MSColor(238, 238, 238);
     }
     return _viewPhoneLine1;
 }

- (UIView *)viewPhoneLine2 {
    if (!_viewPhoneLine2) {
        _viewPhoneLine2 = [[UIView alloc] init];
        _viewPhoneLine2.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewPhoneLine2;
}
- (UITextField *)txtIDCar {
    if (!_txtIDCar) {
        UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yzmicon"]];
                     UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
                     loginImgV.center = lv.center;
                     [lv addSubview:loginImgV];
        _txtIDCar = [[UITextField alloc] init];
        _txtIDCar.leftViewMode = UITextFieldViewModeAlways;
        _txtIDCar.leftView = lv;
        [_txtIDCar setPlaceholder:@"请输入身份证号"];
                [_txtIDCar setFont:WY_FONTRegular(16)];
                  [_txtIDCar setDelegate:self];
    }
    return _txtIDCar;
}

- (UIButton *)btnRegistered {
    if (!_btnRegistered) {
        _btnRegistered = [[UIButton alloc] init];
        [_btnRegistered.layer setMasksToBounds:YES];
        [_btnRegistered.layer setCornerRadius:6];
        [_btnRegistered addTarget:self action:@selector(btnRegisteredTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRegistered setTitle:@"下一步" forState:UIControlStateNormal];
        _btnRegistered.backgroundColor = MSTHEMEColor;
        [_btnRegistered setTitleColor:[UIColor whiteColor] forState:0];
 
    }
    return _btnRegistered;
}
- (void) btnRegisteredTouchUpInside:(UIButton *)btnSender {
    if (self.txtName.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请您完善个人信息，填写正确的姓名和身份证号码，感谢您的使用和支持。"];
        return;
    }
    if (self.txtIDCar.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请您完善个人信息，填写正确的姓名和身份证号码，感谢您的使用和支持。"];
        return;
    }
    
    self.mUser.idcardnum = self.txtIDCar.text;
    self.mUser.realname = self.txtName.text;
    
    [[MS_BasicDataController sharedInstance] postWithURL:updateUserInfo_HTTP params:nil jsonData:[self.mUser toJSONData] showProgressView:YES success:^(id successCallBack) {
        MSLog(@"设置成功");
        [MS_BasicDataController sharedInstance].user = self.mUser;
        [self goSelectCompanyPage];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    

    
}

- (void) goSelectCompanyPage {
    //企业主-禁止更改公司信息；
     if ([self.mUser.UserType isEqualToString:@"1"] || [self.mUser.UserType isEqualToString:@"2"]) {
        [self btnBackAction];
        return;
    }
    WY_SelectCompanyViewController *tempController = [WY_SelectCompanyViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
}

- (void)btnBackAction {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES]; //跳转

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
