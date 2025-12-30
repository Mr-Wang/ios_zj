//
//  WY_LoginViewController.m
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/11.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_LoginViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_LostPwdViewController.h"
#import "WY_UserModel.h"
#import "OSSUtil.h"

#import "LivenessViewController.h"
#import "DetectionViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "YZAuthID.h"
#import "KeyChainStore.h"

@interface WY_LoginViewController ()
@property (nonatomic, strong) UIScrollView *mScrollView;
//登录手机号
@property (nonatomic, strong) UITextField *txtPhoneNumber1;
/// 手机号下线
@property (nonatomic, strong) UIView *viewPhoneLine1;
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


//登录密码
@property (nonatomic, strong) UITextField *txtPwd1;
//注册手机号
@property (nonatomic, strong) UITextField *txtPhoneNumber2;
//注册密码
//@property (nonatomic, strong) UITextField *txtPwd2;
//注册密码再次输入
//@property (nonatomic, strong) UITextField *txtRePwd;
//注册验证码
@property (nonatomic, strong) UITextField *txtYzm;
//学号
//@property (nonatomic, strong) UITextField *txtXueHao;
//发送验证码
@property (nonatomic, strong) UIButton *btnSendYzm;
//记住密码按钮
@property (nonatomic, strong) UIButton *btnSavePwd;
//忘记密码按钮
@property (nonatomic, strong) UIButton *btnLostPwd;
//登录按钮
@property (nonatomic, strong) UIButton *btnLogin;
@property (nonatomic, strong) UIButton *btnTouchIDLogin;

@property (nonatomic, strong) UIButton *btnFaceLogin;
//注册按钮
@property (nonatomic, strong) UIButton *btnRegistered;
@property (nonatomic , assign) BOOL isSelected;/* 是否同意用户协议 */


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
/// 注册Model
@property (nonatomic, strong) WY_UserModel *mWY_UserModel;
@property (nonatomic, strong)NSTimer * yzmTime;
@property (nonatomic) int yzmTimeNum;

@end

@implementation WY_LoginViewController
{
    UIButton *btnLeft;
    UIButton *btnRight;
    UIView *leftView;
    UIView *rightView;
    UIImageView *imgContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    
    //判断是否记住密码 -
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *jzmm = [userDef objectForKey:@"jzmm"];
    if ([jzmm isEqualToString:@"1"]) {
        self.txtPhoneNumber1.text = [userDef objectForKey:@"jzmmphone"];
        self.txtPwd1.text = [userDef objectForKey:@"jzmmpwd"];
        [self.btnSavePwd setSelected:YES];
    }
    [userDef removeObjectForKey:@"userJson"];
          [userDef removeObjectForKey:@"mWY_QuizModelJson"];
         [userDef removeObjectForKey:@"limitTimeStamp"];
         [userDef removeObjectForKey:@"isDuringExam"]; 
         [userDef removeObjectForKey:@"examInfoId"];
    [userDef removeObjectForKey:@"examInfoId1"];
     //搜索历史
     [userDef removeObjectForKey:@"dicSearchHome"];
     [userDef removeObjectForKey:@"dicSearchTraining"];
    [userDef removeObjectForKey:@"PromptDate240605"];

    self.isSelected = [userDef boolForKey:@"XIEYI_isSelected"];
    if (!self.isSelected) {
          self.selectedImg.image = [UIImage imageNamed:@"1012_椭圆形"];
    }else{
          self.selectedImg.image = [UIImage imageNamed:@"1012_用户协议选中"];
    }

     [userDef synchronize];
    [MS_BasicDataController sharedInstance].user = nil;

    if ([self.isreLogin isEqualToString:@"1"]) {
//        [SVProgressHUD showErrorWithStatus:@"您的账号已在其他设备登录，请重新登录"];

        [self.view makeToast:@"您的账号已在其他设备登录，请重新登录"];
    }
    
//    //测试用例-
//    self.txtPhoneNumber1.text = @"13940104171";
//    self.txtPwd1.text = @"qqqq1111..";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (CURRENTVERSION) {
        [self.btnFaceLogin setHidden:NO];
    } else {
        [self.btnFaceLogin setHidden:YES];
    }
    //工信部要求去掉人脸
    [self.btnFaceLogin setHidden:YES];
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
 
    UIImageView *imgBgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + topY)];
    [imgBgTop setImage:[UIImage imageNamed:@"loginbg"]];
    [self.mScrollView addSubview:imgBgTop];
    
    UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, JCNew64 + topY, k360Width(239), k360Width(45))];
    [imgTop setImage:[UIImage imageNamed:@"logintop"]];
    imgTop.centerX = self.mScrollView.centerX;
    [self.mScrollView addSubview:imgTop];
    
    imgContent = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgTop.bottom + k360Width(52) + topY, k360Width(304), k360Width(337))];
    [imgContent setImage:[UIImage imageNamed:@"logincentent"]];
    imgContent.centerX = self.mScrollView.centerX;
    [self.mScrollView addSubview:imgContent];
     
//    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(4), k360Width(16), k360Width(44), k360Width(44))];
//    [btnBack setImage:[UIImage imageNamed:@"1012_返回"] forState:UIControlStateNormal];
//    [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnBack];
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(imgContent.left + k360Width(16), imgContent.top + k360Width(15), (imgContent.width - k360Width(32)) / 2, k360Width(44))];
    [btnLeft setTitle:@"登录" forState:UIControlStateNormal];
    [self.mScrollView addSubview:btnLeft];
    
    
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(btnLeft.right , imgContent.top + k360Width(15), (imgContent.width - k360Width(32)) / 2, k360Width(44))];
    [btnRight setTitle:@"注册" forState:UIControlStateNormal];
    [self.mScrollView addSubview:btnRight];
    
    
    [btnLeft addTarget:self action:@selector(btnLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [btnRight addTarget:self action:@selector(btnRegisteredAciotn) forControlEvents:UIControlEventTouchUpInside];
    
    [btnLeft.titleLabel setFont:WY_FONTRegular(12)];
    
    [btnRight.titleLabel setFont:WY_FONTRegular(12)];
    
//     // 下划线
//    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),btnLeft.bottom,kScreenWidth - k360Width(32), 1)];
//    [imgLine setBackgroundColor:APPLineColor];
//    [self.mScrollView addSubview:imgLine];
    
    
    
    NSDictionary *attribtSelDic = @{NSFontAttributeName: WY_FONTMedium(20),NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSDictionary *attribtNoSelDic = @{NSFontAttributeName: WY_FONTMedium(14),NSForegroundColorAttributeName:[UIColor grayColor]};

    
    NSMutableAttributedString *leftBtnNormalStr = [[NSMutableAttributedString alloc]initWithString:@"登录" attributes:attribtNoSelDic];
    
    
    NSMutableAttributedString *rightBtnNormalStr = [[NSMutableAttributedString alloc]initWithString:@"注册" attributes:attribtNoSelDic];

    
    NSMutableAttributedString *leftBtnSelectedStr = [[NSMutableAttributedString alloc]initWithString:@"登录" attributes:attribtSelDic];
    
    
    NSMutableAttributedString *rightBtnSelectedStr = [[NSMutableAttributedString alloc]initWithString:@"注册" attributes:attribtSelDic];

    
    [btnLeft setAttributedTitle:leftBtnNormalStr forState:UIControlStateNormal];
    
    [btnLeft setAttributedTitle:leftBtnSelectedStr forState:UIControlStateSelected];

    [btnRight setAttributedTitle:rightBtnNormalStr forState:UIControlStateNormal];

    [btnRight setAttributedTitle:rightBtnSelectedStr forState:UIControlStateSelected];
    
    [btnLeft setSelected:YES];
    
    //登录View
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, btnLeft.bottom, kScreenWidth, 320)];
    //注册View
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, btnLeft.bottom, kScreenWidth, 320)];
    
    [self.mScrollView addSubview:leftView];
    [self.mScrollView addSubview:rightView];
    
    [rightView setHidden:YES];
    
    [self initLeftView];
    [self initRightView];
    
    [self btnLoginAction];
    
    UIButton *btnBeiAn = [UIButton new];
    [btnBeiAn setFrame:CGRectMake(0, self.mScrollView.height - k360Width(40+16), kScreenWidth, k360Width(40))];
    [btnBeiAn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"辽ICP备18015387号-7A"];
    [attStr setYy_color: [UIColor whiteColor]];
    [attStr setYy_font:WY_FONTRegular(12)];
    [attStr setYy_underlineStyle:NSUnderlineStyleSingle];
    [btnBeiAn setAttributedTitle:attStr forState:UIControlStateNormal];
    [self.mScrollView addSubview:btnBeiAn];
 
    UILabel *lblZhuBan = [UILabel new];
    [lblZhuBan setFrame:CGRectMake(0, self.mScrollView.height - k360Width(70+16), kScreenWidth, k360Width(30))];
    lblZhuBan.text = @"辽宁省发展和改革委员会主办";
    [lblZhuBan setTextAlignment:NSTextAlignmentCenter];
    [lblZhuBan setTextColor:[UIColor whiteColor]];
    [lblZhuBan setFont:WY_FONTRegular(12)];
    [self.mScrollView addSubview:lblZhuBan];
    
    [btnBeiAn setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了备案");
        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
        wk.titleStr = @"备案查询";
        wk.webviewURL = @"https://beian.miit.gov.cn/";
        wk.isShare = @"1";
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
        navi.navigationBarHidden = NO;
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navi animated:NO completion:nil];
        
    }];
}
#pragma mark --加载登录View
- (void) initLeftView {
    
    [leftView addSubview:self.txtPhoneNumber1];
    [leftView addSubview:self.txtPwd1];
    [leftView addSubview:self.btnLogin];
    [leftView addSubview:self.btnTouchIDLogin];
    
    [leftView addSubview:self.btnFaceLogin];
    [self.btnFaceLogin setHidden:YES];
    [leftView addSubview:self.viewPhoneLine1];
    [leftView addSubview:self.viewPwdLine1];
    [leftView addSubview:self.btnLostPwd];
    [leftView addSubview:self.btnSavePwd];
    [leftView addSubview:self.viewUserAgr];

      [self.viewUserAgr addSubview:self.selectedImg];
        [self.selectedImg addSubview:self.selectedBtn];
        [self.viewUserAgr addSubview:self.userAgrLab];
        [self.userAgrLab addSubview:self.userAgrBtn];
     
    
    
//    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(82), 0, k360Width(32), k360Width(2))];
//    [imgLine setBackgroundColor:[UIColor blackColor]];
//    [leftView addSubview:imgLine];
    


    [self.txtPhoneNumber1 setFrame:CGRectMake(imgContent.left + k360Width(16), k360Width(20), imgContent.width - k360Width(32), k360Width(30))];
    
    [self.viewPhoneLine1 setFrame:CGRectMake(self.txtPhoneNumber1.left, self.txtPhoneNumber1.bottom + k360Width(2), self.txtPhoneNumber1.width, 1)];
    
    [self.txtPwd1 setFrame:CGRectMake(imgContent.left + k360Width(16), self.viewPhoneLine1.bottom + k360Width(26), self.txtPhoneNumber1.width, self.txtPhoneNumber1.height)];
    
    [self.viewPwdLine1 setFrame:CGRectMake(self.txtPhoneNumber1.left, self.txtPwd1.bottom + k360Width(2), self.txtPhoneNumber1.width, 1)];

     [self.btnSavePwd setFrame:CGRectMake(self.txtPhoneNumber1.left, self.viewPwdLine1.bottom + k360Width(16), k360Width(140), self.txtPhoneNumber1.height)];

    [self.btnLostPwd setFrame:CGRectMake(self.txtPhoneNumber1.right - k360Width(100), self.viewPwdLine1.bottom + k360Width(16), k360Width(100), self.txtPhoneNumber1.height)];
     [self.btnLostPwd setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //用户协议View；
    
    [self.selectedImg setFrame:CGRectMake(imgContent.left + k360Width(18), k360Width(2), kWidth(15*2), kWidth(15*2))];
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
    btnAgr2.titleLabel.font = WY_FONTRegular(12);
    btnAgr2.userInteractionEnabled = YES;
    [btnAgr2 addTarget:self action:@selector(btnYinsiAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAgr2 sizeToFit];
      
    [btnAgr2 setCenterY:self.userAgrLab.centerY];
    
    // 用户协议按钮
    [self.userAgrBtn setFrame:self.userAgrLab.bounds];
     
  
    [self.viewUserAgr setFrame:CGRectMake(0, self.btnLostPwd.bottom + k360Width(10), kScreenWidth, self.txtPhoneNumber2.height + k360Width(16))];

      [self.btnFaceLogin setFrame:CGRectMake(self.txtPwd1.right - k360Width(60 + 8), self.txtPwd1.top + k360Width(4) , k360Width(60), self.txtPwd1.height - k360Width(8))];

    [self.btnLogin setFrame:CGRectMake(imgContent.left + k360Width(16), self.viewUserAgr.bottom , (imgContent.width) / 2 - k360Width(8), k360Width(46))];
    
    [self.btnTouchIDLogin setFrame:CGRectMake(self.btnLogin.right - k360Width(10), self.viewUserAgr.bottom , (imgContent.width) / 2- k360Width(8), k360Width(46))];

    leftView.height = self.btnLogin.bottom;
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, leftView.bottom)];
     

    
}
#pragma mark --加载注册View
- (void) initRightView {
    
    [rightView addSubview:self.txtPhoneNumber2];
       [rightView addSubview:self.txtYzm];
    [rightView addSubview:self.btnSendYzm];
//    [rightView addSubview:self.txtXueHao];
    [rightView addSubview:self.viewXueHaoLine];
//       [rightView addSubview:self.txtPwd2];
//    [rightView addSubview:self.txtRePwd];
    
    

    [rightView addSubview:self.btnRegistered];
    [rightView addSubview:self.viewPhoneLine2];
    [rightView addSubview:self.viewPwdLine2];
    [rightView addSubview:self.viewYzmLine1];
    [rightView addSubview:self.viewRePwdLine];
    
    
//    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(246), 0, k360Width(32), k360Width(2))];
//    [imgLine setBackgroundColor:[UIColor blackColor]];
//    [rightView addSubview:imgLine];
    
    
    [self.txtPhoneNumber2 setFrame:CGRectMake(imgContent.left + k360Width(16), k360Width(30), imgContent.width - k360Width(32), k360Width(30))];
    
    [self.viewPhoneLine2 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtPhoneNumber2.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
    
    [self.txtYzm setFrame:CGRectMake(self.txtPhoneNumber2.left, self.viewPhoneLine2.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];

    [self.btnSendYzm setFrame:CGRectMake(self.txtYzm.right - k360Width(110), self.viewPhoneLine2.bottom + k360Width(30 + 2), k360Width(110), self.txtPhoneNumber2.height - k360Width(4))];

    [self.viewYzmLine1 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtYzm.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
//
//    [self.txtXueHao setFrame:CGRectMake(self.txtPhoneNumber2.left, self.viewYzmLine1.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];
//
//    [self.viewXueHaoLine setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtXueHao.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
//
//    [self.txtPwd2 setFrame:CGRectMake(k360Width(16), self.viewXueHaoLine.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];
//
//    [self.viewPwdLine2 setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtPwd2.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
//
//    [self.txtRePwd setFrame:CGRectMake(k360Width(16), self.viewPwdLine2.bottom + k360Width(30), self.txtPhoneNumber2.width, self.txtPhoneNumber2.height)];
//
//      [self.viewRePwdLine setFrame:CGRectMake(self.txtPhoneNumber2.left, self.txtRePwd.bottom + k360Width(2), self.txtPhoneNumber2.width, 1)];
 
    
}

#pragma mark --登录按钮点击事件
- (void)btnLoginAction{
    [btnLeft setSelected:YES];
    [btnRight setSelected:NO];
    
    [leftView setHidden:NO];
    [rightView setHidden:YES];
    
    
    MSLog(@"登录按钮点击事件");
   
    [leftView addSubview:self.viewUserAgr];
    [self.viewUserAgr setFrame:CGRectMake(0, self.btnLostPwd.bottom + k360Width(10), kScreenWidth, k360Width(30))];

    [self.btnFaceLogin setFrame:CGRectMake(self.txtPwd1.right - k360Width(60 + 16), self.txtPwd1.top + k360Width(4) , k360Width(60), self.txtPwd1.height - k360Width(8))];

    [self.btnLogin setFrame:CGRectMake(imgContent.left + k360Width(16), self.viewUserAgr.bottom , (imgContent.width) / 2 - k360Width(8), k360Width(46))];
    
    [self.btnTouchIDLogin setFrame:CGRectMake(self.btnLogin.right - k360Width(10), self.viewUserAgr.bottom , (imgContent.width) / 2- k360Width(8), k360Width(46))];

    leftView.height = self.btnLogin.bottom;
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, leftView.bottom)];

    
}

#pragma mark --注册按钮点击事件
- (void)btnRegisteredAciotn{
    [btnLeft setSelected:NO];
       [btnRight setSelected:YES];
    [leftView setHidden:YES];
       [rightView setHidden:NO];
    MSLog(@"注册按钮点击事件");
    
    [rightView addSubview:self.viewUserAgr];
    [self.viewUserAgr setFrame:CGRectMake(0, self.viewYzmLine1.bottom + k360Width(30), kScreenWidth, k360Width(30))];

    [self.btnRegistered setFrame:CGRectMake(imgContent.left + k360Width(16), self.viewUserAgr.bottom + k360Width(16), imgContent.width - k360Width(32), k360Width(46))];
    
    rightView.height = self.btnRegistered.bottom;
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, rightView.bottom + k360Width(32))];

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
#pragma mark --记住密码点击
- (void)btnSavePwdTouchUpInside:(UIButton *)sender {
    NSLog(@"记住密码点击");
    sender.selected = !sender.selected;
}
#pragma mark --忘记密码点击
- (void)btnLostPwdTouchUpInside:(UIButton *)sender {
    MSLog(@"忘记密码点击");
    WY_LostPwdViewController *tempController = [WY_LostPwdViewController new];
    tempController.updatePwdSuccessBlock = ^(NSString * _Nonnull uname, NSString * _Nonnull pwd) {
        NSLog(@"修改密码成功- 调用登录");
        self.txtPhoneNumber1.text = uname;
        self.txtPwd1.text = pwd;
        [self loginBtnTouchUpInside:nil];
    };
    tempController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:tempController animated:YES completion:nil];

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
    [[MS_BasicDataController sharedInstance] postWithURL:ZC_SEND_SHORT_HTTP params:nil jsonData:[userModel toJSONData] showProgressView:YES success:^(id successCallBack) {
        
        self.btnSendYzm.enabled=NO;
        [self.btnSendYzm setTitle:@"60秒后可重发" forState:UIControlStateNormal];
        [self.btnSendYzm setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.yzmTimeNum = 60;
        self.yzmTime=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Time) userInfo:nil repeats:YES];

    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
        if ([failureCallBack rangeOfString:@"已经存在于系统"].length > 0) {
            //跳转到登录
            [self btnLoginAction];
            self.txtPhoneNumber1.text = self.txtPhoneNumber2.text;
            self.txtPwd1.text = @"";
        }
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
    wk.titleStr = @"用户服务协议";
    wk.webviewURL = @"https://www.capass.cn/Avatar/zjapp.pdf";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
    navi.navigationBarHidden = NO;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];

//    wk.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:wk animated:YES completion:nil];
 //    self.bigbgview.hidden = NO;
    
}

#pragma mark --数字证书服务协议点击
- (void)btnFuwuAction:(UIButton *)sender {
    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
   wk.titleStr = @"数字证书服务协议";
   wk.webviewURL = @"https://lnwlzj.capass.cn/lnwlzj/%E6%95%B0%E5%AD%97%E8%AF%81%E4%B9%A6%E6%9C%8D%E5%8A%A1%E5%8D%8F%E8%AE%AE%EF%BC%88BJCA%E5%8F%8ACFCA%EF%BC%89(1).pdf";
   UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
   navi.navigationBarHidden = NO;
   navi.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:navi animated:NO completion:nil];
}
 
#pragma mark --隐私政策协议点击
- (void)btnYinsiAction:(UIButton *)sender {
    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
   wk.titleStr = @"隐私政策";
    wk.webviewURL = @"https://www.capass.cn/Avatar/ysxy.pdf";
   UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
   navi.navigationBarHidden = NO;
   navi.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:navi animated:NO completion:nil];
}
- (UITextField *)txtPhoneNumber1 {
    if (!_txtPhoneNumber1) {
        UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phonenumicon"]];
               UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
               loginImgV.center = lv.center;
               [lv addSubview:loginImgV];
        
        _txtPhoneNumber1 = [[UITextField alloc] init];
        _txtPhoneNumber1.leftViewMode = UITextFieldViewModeAlways;
        _txtPhoneNumber1.leftView = lv;
        [_txtPhoneNumber1 setPlaceholder:@"请输入手机号"];
         _txtPhoneNumber1.keyboardType = UIKeyboardTypeDecimalPad;
        [_txtPhoneNumber1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        [_txtPhoneNumber1 setDelegate:self];
        _txtPhoneNumber1.font = WY_FONTRegular(18);

        
    }
    return _txtPhoneNumber1;
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
        [_txtPhoneNumber2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        [_txtPhoneNumber2 setDelegate:self];
        _txtPhoneNumber2.font = WY_FONTRegular(18);

        
    }
    return _txtPhoneNumber2;
}


- (UITextField *)txtPwd1 {
    if (!_txtPwd1) {
        UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwdicon"]];
                     UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
                     loginImgV.center = lv.center;
                     [lv addSubview:loginImgV];
        _txtPwd1 = [[UITextField alloc] init];
        _txtPwd1.leftViewMode = UITextFieldViewModeAlways;
        _txtPwd1.leftView = lv;
        [_txtPwd1 setPlaceholder:@"请输入密码"];

                [_txtPwd1 setFont:WY_FONTRegular(18)];
                [_txtPwd1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                _txtPwd1.secureTextEntry = YES;
                [_txtPwd1 setDelegate:self];


        
    }
    return _txtPwd1;
}

//- (UITextField *)txtPwd2 {
//    if (!_txtPwd2) {
//        _txtPwd2 = [[UITextField alloc] init];
//        [_txtPwd2 setPlaceholder:@"请输入密码"];
//
//                [_txtPwd2 setFont:WY_FONTRegular(18)];
//                [_txtPwd2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//                _txtPwd2.secureTextEntry = YES;
//                [_txtPwd2 setDelegate:self];
//
//
//
//    }
//    return _txtPwd2;
//}
//
//- (UITextField *)txtXueHao {
//    if (!_txtXueHao) {
//        _txtXueHao = [[UITextField alloc] init];
//        [_txtXueHao setPlaceholder:@"请输入学号"];
//
//                [_txtXueHao setFont:WY_FONTRegular(18)];
//                [_txtXueHao addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//                [_txtXueHao setDelegate:self];
//        _txtXueHao.keyboardType = UIKeyboardTypeASCIICapable;
//
//    }
//    return _txtXueHao;
//}
//
//- (UITextField *)txtRePwd {
//    if (!_txtRePwd) {
//        _txtRePwd = [[UITextField alloc] init];
//        [_txtRePwd setPlaceholder:@"再次请输入密码"];
//
//                [_txtRePwd setFont:WY_FONTRegular(18)];
//                [_txtRePwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//                _txtRePwd.secureTextEntry = YES;
//                [_txtRePwd setDelegate:self];
//
//
//
//    }
//    return _txtRePwd;
//}
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
                [_txtYzm addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                 [_txtYzm setDelegate:self];
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

- (void) textFieldDidChange:(id) sender {
    
//        if (self.txtPhoneNumber1.text.length ==11 && self.txtPwd1.text.length>=6) {
////            self.btnLogin.backgroundColor = MSColorA(1, 187, 112, 1);
//            [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"1012_dengrukuang"] forState:UIControlStateNormal];
//            self.btnLogin.userInteractionEnabled = YES;
//        }else{
//            [self.btnLogin setBackgroundImage:nil forState:UIControlStateNormal];
//              self.btnLogin.backgroundColor = MSColorA(153, 153, 153, 0.5);
//            self.btnLogin.userInteractionEnabled = NO;
//
//        }
//
//    if ([self isVRegistered]) {
//        [self.btnRegistered setBackgroundImage:[UIImage imageNamed:@"1012_dengrukuang"] forState:UIControlStateNormal];
//        self.btnRegistered.userInteractionEnabled = YES;
//
//    } else {
//        [self.btnRegistered setBackgroundImage:nil forState:UIControlStateNormal];
//          self.btnRegistered.backgroundColor = MSColorA(153, 153, 153, 0.5);
//        self.btnRegistered.userInteractionEnabled = NO;
//
//    }
    
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
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:@"《用户服务协议》"];
         [str1 setYy_color:MSTHEMEColor];
        [str appendAttributedString:str1];
        _userAgrLab.attributedText = str;
        _userAgrLab.font = WY_FONTRegular(12);
        _userAgrLab.userInteractionEnabled = YES;
    }
    return _userAgrLab;
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
- (UIButton *)btnLostPwd {
    if (!_btnLostPwd) {
        _btnLostPwd = [[UIButton alloc] init];
        _btnLostPwd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btnLostPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_btnLostPwd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnLostPwd.titleLabel setFont:WY_FONTRegular(12)];
        [_btnLostPwd addTarget:self action:@selector(btnLostPwdTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLostPwd;
}
- (UIButton *)btnSavePwd {
    if (!_btnSavePwd) {
        _btnSavePwd = [[UIButton alloc] init];
        _btnSavePwd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
         [_btnSavePwd setImage:[UIImage imageNamed:@"icon_checkbox_s"] forState:UIControlStateNormal];
        [_btnSavePwd setImage:[UIImage imageNamed:@"icon_checkbox_lxx"] forState:UIControlStateSelected];
        [_btnSavePwd setTitleEdgeInsets:UIEdgeInsetsMake(0, k360Width(10), 0, 0)];
        [_btnSavePwd setTitle:@"记住密码" forState:UIControlStateNormal];
        [_btnSavePwd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnSavePwd.titleLabel setFont:WY_FONTRegular(12)];
        [_btnSavePwd addTarget:self action:@selector(btnSavePwdTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSavePwd;
}


- (UIButton *)btnFaceLogin {
    if (!_btnFaceLogin) {
        _btnFaceLogin = [[UIButton alloc] init];
        [_btnFaceLogin.layer setMasksToBounds:YES];
        [_btnFaceLogin.layer setCornerRadius:6];
        [_btnFaceLogin addTarget:self action:@selector(faceLoginBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btnFaceLogin setTitle:@"扫脸登录" forState:UIControlStateNormal];
        [_btnFaceLogin.titleLabel setFont:WY_FONTRegular(12)];
        _btnFaceLogin.backgroundColor = MSTHEMEColor;
        [_btnFaceLogin setTitleColor:[UIColor whiteColor] forState:0];
 
    }
    return _btnFaceLogin;
}
- (UIButton *)btnLogin {
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc] init];
        [_btnLogin.layer setMasksToBounds:YES];
        [_btnLogin.layer setCornerRadius:6];
        [_btnLogin addTarget:self action:@selector(loginBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btnLogin setBackgroundImage:[UIImage imageNamed:@"1021loginpwd"] forState:UIControlStateNormal];
//        [_btnLogin setTitle:@"密码登录" forState:UIControlStateNormal];
//        [_btnLogin.titleLabel setFont:WY_FONTRegular(18)];
//        _btnLogin.backgroundColor = MSTHEMEColor;
//        [_btnLogin setTitleColor:[UIColor whiteColor] forState:0];
 
    }
    return _btnLogin;
}
- (UIButton *)btnTouchIDLogin {
    if (!_btnTouchIDLogin) {
        _btnTouchIDLogin = [[UIButton alloc] init];
        [_btnTouchIDLogin.layer setMasksToBounds:YES];
        [_btnTouchIDLogin.layer setCornerRadius:6];
        [_btnTouchIDLogin addTarget:self action:@selector(btnTouchIDLoginTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        if (IS_IPhoneX_All) {
            [_btnTouchIDLogin setBackgroundImage:[UIImage imageNamed:@"1021loginfaceid"] forState:UIControlStateNormal];
        } else {
            [_btnTouchIDLogin setBackgroundImage:[UIImage imageNamed:@"1021logintouchid"] forState:UIControlStateNormal];

        }
//        [_btnTouchIDLogin setTitle:@"TouchID登录" forState:UIControlStateNormal];
//        [_btnTouchIDLogin.titleLabel setFont:WY_FONTRegular(18)];
//        _btnTouchIDLogin.backgroundColor = MSTHEMEColor;
//        [_btnTouchIDLogin setTitleColor:[UIColor whiteColor] forState:0];
 
    }
    return _btnTouchIDLogin;
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



- (void)submitData:(UIImage *)imgFace {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.txtPhoneNumber1.text forKey:@"username"];
    [dicPost setObject:[self UIImageToBase64Str:imgFace] forKey:@"base64Str"];
    
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:faceLogin_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
 
                   MSLog(@"登录成功");
                   //注册成功跳转登录方法
                   WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
                   NSLog(@"currentUserModel:%@",[currentUserModel toJSONString]);
                    [MS_BasicDataController sharedInstance].user = currentUserModel;
                   //通知注册推送；
                   NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
                   [notifyCenter postNotificationName:@"INITLOGINPUSH" object:nil];
                    [self loginToView];
        } else {
            //            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
}


//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

#pragma mark - # 扫脸登录按钮点击
//登录
- (void)faceLoginBtnTouchUpInside:(UIButton *)sender {
if (self.txtPhoneNumber1.text.length <=0 ) {
    [SVProgressHUD showErrorWithStatus:self.txtPhoneNumber1.placeholder];
    return;
}
    MSLog(@"进行扫脸");
    [self VFace];
 }

///验证人脸
- (void) VFace {
    //开始人脸识别；
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
//    LivenessViewController* lvc = [[LivenessViewController alloc] init];
//    LivingConfigModel* model = [LivingConfigModel sharedInstance];
//    [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    
    DetectionViewController* lvc = [[DetectionViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:NO completion:nil];
    WS(weakSelf);
    lvc.faceSuceessBlock = ^(UIImage *imgFace) {
        //人脸 识别成功后- 调用接口
        //            [weakSelf submitData:imgFace];
        
        [weakSelf performSelectorOnMainThread:@selector(submitData:) withObject:imgFace waitUntilDone:YES];
    };
}
#pragma mark - # 登录按钮点击
- (void)loginAction:(NSMutableDictionary *)postDic {
    if (!self.isSelected) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并同意《用户服务协议》《隐私政策》"];
           return;
    }
    
    [[MS_BasicDataController sharedInstance] postWithURL:LOGINHTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        
        //如果记住密码按钮选中 - 保存；
        if (self.btnSavePwd.selected) {
            [userdef setObject:@"1" forKey:@"jzmm"];
            [userdef setObject:self.txtPhoneNumber1.text forKey:@"jzmmphone"];
            [userdef setObject:self.txtPwd1.text forKey:@"jzmmpwd"];
            
        } else {
            [userdef setObject:@"0" forKey:@"jzmm"];
        }
        
        MSLog(@"登录成功");
        //注册成功跳转登录方法
        WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:successCallBack];
        NSLog(@"currentUserModel:%@",[currentUserModel toJSONString]);
        [MS_BasicDataController sharedInstance].user = currentUserModel;
        //通知注册推送；
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter postNotificationName:@"INITLOGINPUSH" object:nil];
        
        //注册按钮选中- 此为注册按钮点击登录功能；弹出提示；
        if(btnRight.selected) {
            [self registerLoginToView];
        }else {
            [self loginToView];
        }
        
        //        [self btnBackAction];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
}

//登录
- (void)loginBtnTouchUpInside:(UIButton *)sender {
//    [self loginHttp];
    
    MSLog(@"登录");
    if (self.txtPhoneNumber1.text.length <=0 ) {
        [SVProgressHUD showErrorWithStatus:self.txtPhoneNumber1.placeholder];
        return;
    }
    if (self.txtPwd1.text.length <=0 ) {
        [SVProgressHUD showErrorWithStatus:self.txtPwd1.placeholder];
        return;
    }
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.txtPhoneNumber1.text forKey:@"username"];
    [postDic setObject:[[OSSUtil sha1WithString:self.txtPwd1.text] uppercaseString] forKey:@"password"];
    [self loginAction:postDic];
}

- (void)btnTouchIDLoginTouchUpInside:(UIButton *)sender {
    if (!self.isSelected) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并同意《用户服务协议》《隐私政策》"];
           return;
    }
    
    NSString *isTouchLogin = [KeyChainStore load:@"isTouchLogin"];
    if (![isTouchLogin isEqualToString:@"1"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Touch ID登录未开启" message:@"请使用密码登录后 在\"我的\"->\"设置\" 中开启Touch ID登录" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     }]];
     [self presentViewController:alertController animated:YES completion:nil];
 
        return;
    }
    [self authVerification];
}

#pragma mark - 验证TouchID/FaceID
- (void)authVerification {
    
    YZAuthID *authID = [[YZAuthID alloc] init];
    NSString *isTouchLogin = [KeyChainStore load:@"isTouchLogin"];
    
    NSString *isTouchLogin_LoginID = [KeyChainStore load:@"isTouchLogin_LoginID"];
    NSString *isTouchLogin_LoginPWD = [KeyChainStore load:@"isTouchLogin_LoginPWD"];

    NSString *describeStr = @"";
    if(IS_IPhoneX_All){
        //是iphonex 以上
        describeStr = [NSString stringWithFormat:@"现在可以使用面容登录账号%@",isTouchLogin_LoginID];
    } else {
        describeStr = [NSString stringWithFormat:@"现在可以使用指纹登录账号%@",isTouchLogin_LoginID];
    }
    [authID yz_showAuthIDWithDescribe:describeStr block:^(YZAuthIDState state, NSError *error) {
        
        if (state == YZAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            NSLog(@"对不起，当前设备不支持指纹/面容ID");
            [SVProgressHUD showErrorWithStatus:@"对不起，当前设备不支持指纹/面容ID"];
         } else if(state == YZAuthIDStateFail) { // 认证失败
            NSLog(@"指纹/面容ID不正确，认证失败");
            [SVProgressHUD showErrorWithStatus:@"指纹/面容ID不正确，认证失败"];
        } else if(state == YZAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            NSLog(@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码");
            [SVProgressHUD showErrorWithStatus:@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码"];
        } else if (state == YZAuthIDStateSuccess) { // TouchID/FaceID验证成功
            NSLog(@"认证成功！");
            NSMutableDictionary *postDic = [NSMutableDictionary new];
            [postDic setObject:isTouchLogin_LoginID forKey:@"username"];
            [postDic setObject:isTouchLogin_LoginPWD forKey:@"password"];
            [self loginAction:postDic];
        }
        
    }];
}


/// 登录成功后操作
- (void)loginToView {
    WY_UserModel *currentUserModel = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    if (currentUserModel.idcardnum != nil && currentUserModel.idcardnum.length > 0) {
        
//        if (currentUserModel.orgnum.length <= 0) {
//            //没有公司信息- 去补充公司信息；
//            NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
//            [notifyCenter postNotificationName:@"PUSHSETORGINFONOTIFY" object:nil];
//
//        }
        
        //有身份证
        [self btnBackAction];
        
    } else {
        //没有身份证- 去填写身份证信息；
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter postNotificationName:@"PUSHSETIDCARNOTIFY" object:nil];
        [self btnBackAction];
    }
}

/// 注册成功后- 登录成功后操作
- (void)registerLoginToView {
    NSString *strMes = [NSString stringWithFormat:@"您的用户初始密码为 %@",self.txtPwd1.text];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:strMes preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //切换到登录按钮- 去登录；
//        [self btnLoginAction];
//        [self loginToView];
//    }]];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loginToView];
    }])];
    [self presentViewController:alertController animated:YES completion:nil];

}
#pragma mark - # 注册并登录按钮点击

//注册
- (void)btnRegisteredTouchUpInside:(UIButton *)sender {
//    [self loginHttp];
    
    if (!self.isSelected) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并同意《用户服务协议》《隐私政策》"];
           return;
    }
    if (![self isVRegistered]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确手机号码和验证码"];
        return;
    }
    MSLog(@"注册");
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.txtPhoneNumber2.text forKey:@"LoginID"];
    [postDic setObject:[[OSSUtil sha1WithString:[NSString stringWithFormat:@"%@@wl",[self.txtPhoneNumber2.text substringFromIndex:5] ]] uppercaseString] forKey:@"password"];
    [postDic setObject:self.txtYzm.text forKey:@"yzm"];
    [[MS_BasicDataController sharedInstance] postWithURL:ZC_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"注册成功");
        //注册成功跳转登录方法
        self.txtPhoneNumber1.text = self.txtPhoneNumber2.text;
        //这里判断是否记住密码
        self.txtPwd1.text = [NSString stringWithFormat:@"%@@wl",[self.txtPhoneNumber2.text substringFromIndex:5]];
        
        [self loginBtnTouchUpInside:nil];
        
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
