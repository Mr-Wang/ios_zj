//
//  WY_CloudSignaturePayViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/15.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_CloudSignaturePayViewController.h"
#import "WY_SignViewController.h"
#import "WY_AddressManageViewController.h"

#import "ImageNewsDetailViewController.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WY_CAPaySuccessViewController.h"
#import <WXApi.h>
#import "WY_PayNeedModel.h"
#import "OSSXMLDictionary.h"
#import "WY_CaOnlinePayCallBackModel.h"

#import <AlipaySDK/AlipaySDK.h>
#import "SCAP.h"
#import "CustomAlertView.h"
#import "STRIAPManager.h"


@interface WY_CloudSignaturePayViewController ()
{
}
@property (nonatomic , strong) UIView *viewTop;
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnUp;
@property (nonatomic , strong) UIButton *btnReSign;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic , strong) NSString *mSignUrl;
@property (nonatomic , strong) UIButton *btnYj;
@property (nonatomic , strong) UIButton *btnLq;

@property (nonatomic , strong) UILabel *lblAddressSel;
@property (nonatomic , strong) NSString *payType;//1是微信、2是支付宝
@property (nonatomic , strong) WY_AddressManageModel * selAddress;

@property (nonatomic , strong) UIView *viewSel3Yj;
@property (nonatomic , strong) UIView *viewSel4Lq;
@property (nonatomic , strong) UIView *viewSel5PayType;
@property (nonatomic , strong) UIView *viewSel6Fp;

@property (nonatomic , strong) UILabel *lblMoneySum;
//证书名称
@property (nonatomic , strong) UILabel *lblT3;
//金额、有效期
@property (nonatomic , strong) UILabel *lblT4;
@property (nonatomic , strong) UISwitch * switchFP;
//发票- 是
@property (nonatomic , strong) UIButton *btnFpYes;
//发票 - 否
@property (nonatomic , strong) UIButton *btnFpNo;

@property (nonatomic , strong) NSMutableDictionary *dicSignUpSuccess;


@property (nonatomic , strong) UIButton *btnTFp3;
@property (nonatomic , strong) UILabel *lblTFp2;
@property (nonatomic , strong) UILabel *lblTFp1;
//生成p10;
@property (nonatomic , strong) NSString *pkcs10;
@property (nonatomic , strong) NSString *isIAPPay;
//内购
@property (nonatomic, strong) STRIAPManager *IAPManager;
@end

@implementation WY_CloudSignaturePayViewController
@synthesize viewSel3Yj,viewSel4Lq,viewSel5PayType,viewSel6Fp,btnTFp3,lblTFp2,lblTFp1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"云签章便捷办理";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chenggong) name:@"chenggong" object:nil];
    
    [self makeUI];
    [self bindView];
}
- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    //
    [self initTopView];
    
    //判断开关；
//    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_dictionary_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
//        if (([code integerValue] == 0) && res) {
//            self.isIAPPay = res[@"data"];
//        }
//        [self initMiddleView];
//    } failure:^(NSError *error) {
//        [self.view makeToast:@"请求失败，请稍后再试"];
//
//    }];
    
//    self.isIAPPay = @"1";
//    [self initMiddleView];
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:@"6" forKey:@"codeType"];
    //判断开关；
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_dictionaryGetCode_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            self.isIAPPay = res[@"data"][@"code"];
            [self initMiddleView];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];

    }];
    
}

- (void)initTopView {
    self.viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k375Width(90))];
    [self.viewTop setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    [self.view addSubview:self.viewTop];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(k375Width(40) + k375Width(35), k375Width(16.5), k375Width(30), k375Width(30))];
    UILabel *lbltop1 = [[UILabel alloc] initWithFrame:CGRectMake(0, img1.bottom + k375Width(10), k375Width(70), k375Width(16))];
    lbltop1.centerX = img1.centerX;
    
    UILabel *lblLine1 = [[UILabel alloc] initWithFrame:CGRectMake(lbltop1.right + k375Width(5), img1.bottom - k375Width(5), k375Width(140), k375Width(4))];

    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(lblLine1.right + k375Width(10), k375Width(16.5), k375Width(30), k375Width(30))];
    UILabel *lbltop2 = [[UILabel alloc] initWithFrame:CGRectMake(0, img2.bottom + k375Width(10), k375Width(70), k375Width(16))];
    lbltop2.centerX = img2.centerX;

//    UILabel *lblLine2 = [[UILabel alloc] initWithFrame:CGRectMake(lbltop2.right + k375Width(5), img2.bottom - k375Width(5), k375Width(70), k375Width(4))];

    
//    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(lblLine2.right + k375Width(10), k375Width(16.5), k375Width(30), k375Width(30))];
//    UILabel *lbltop3 = [[UILabel alloc] initWithFrame:CGRectMake(0, img3.bottom + k375Width(10), k375Width(70), k375Width(16))];
//    lbltop3.centerX = img3.centerX;

    

    
    
    [img1 setImage:[UIImage imageNamed:@"0611_ws1"]];
    [img2 setImage:[UIImage imageNamed:@"0611_ws2"]];
//    [img3 setImage:[UIImage imageNamed:@"0611_ws3h"]];
 
    [self.viewTop addSubview:img1];
    [self.viewTop addSubview:img2];
//    [self.viewTop addSubview:img3];
    [self.viewTop addSubview:lbltop1];
    [self.viewTop addSubview:lbltop2];
//    [self.viewTop addSubview:lbltop3];
    [self.viewTop addSubview:lblLine1];
//    [self.viewTop addSubview:lblLine2];
    
    [lbltop1 setTextColor:HEXCOLOR(0x0F6DD2)];
    [lbltop2 setTextColor:HEXCOLOR(0x0F6DD2)];
//    [lbltop3 setTextColor:HEXCOLOR(0x8B8B8B)];
    
    [lbltop1 setTextAlignment:NSTextAlignmentCenter];
    [lbltop2 setTextAlignment:NSTextAlignmentCenter];
//    [lbltop3 setTextAlignment:NSTextAlignmentCenter];
    
    
    [lblLine1 setTextColor:HEXCOLOR(0x8B8B8B)];
//    [lblLine2 setTextColor:HEXCOLOR(0x8B8B8B)];

    [lbltop1 setFont:WY_FONT375Medium(16)];
    [lbltop2 setFont:WY_FONT375Medium(16)];
//    [lbltop3 setFont:WY_FONT375Medium(16)];
    
    [lblLine1 setFont:WY_FONT375Medium(12)];
//    [lblLine2 setFont:WY_FONT375Medium(12)];
    
    
    
    [lbltop1 setText:@"证书信息"];
    [lblLine1 setText:@"••••••••••••••••••••"];
//    [lblLine2 setText:@"••••••••••"];
    [lbltop2 setText:@"订单支付"];
//    [lbltop3 setText:@"订单支付"];
    if (![self.isEdit isEqualToString:@"1"] && ![self.isEdit isEqualToString:@"2"]) {
        [lbltop2 setText:@"订单支付"];
    } else {
        [lbltop2 setText:@"修改订单"];
    }
}

- (void)initPayTypeView {
    UILabel *lblTPay1 = [UILabel new];
    [lblTPay1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTPay1 setText:@"支付方式"];
    [lblTPay1 setTextColor:HEXCOLOR(0x434343)];
    [lblTPay1 setFont:WY_FONT375Medium(14)];
    [viewSel5PayType addSubview:lblTPay1];
    
    int payLastY = lblTPay1.bottom+k375Width(5);
        //临时加的 苹果支付-
    UIImageView *imgWchatSel1 = [UIImageView new];
        UIControl *colWchat1 = [UIControl new];
        UIImageView *imgWchat1 = [UIImageView new];
        UILabel *lblWchatName1 = [UILabel new];
    
    
    
    UIControl *colWchat = [UIControl new];
    UIImageView *imgWchat = [UIImageView new];
    UIImageView *imgWchatSel = [UIImageView new];
    UILabel *lblWchatName = [UILabel new];
    
    UIControl *colAliPay = [UIControl new];
    UIImageView *imgAliPay = [UIImageView new];
    UIImageView *imgAliPaySel = [UIImageView new];
    UILabel *lblAliPayName = [UILabel new];
    
    
    //如果开开显示苹果支付- 否则关掉
    if ([self.isIAPPay isEqualToString:@"1"]) {
        [colWchat1 setFrame:CGRectMake(k375Width(16), lblTPay1.bottom+k375Width(5), kScreenWidth - k375Width(32), k375Width(44))];
        //    [col1 setBackgroundColor:[UIColor redColor]];
        [viewSel5PayType addSubview:colWchat1];
    
        [imgWchat1 setFrame:CGRectMake(k375Width(16), k375Width(6), k375Width(20), k375Width(20))];
        [imgWchat1 setImage:[UIImage imageNamed:@"applepay"]];
        [colWchat1 addSubview:imgWchat1];
    
        [lblWchatName1 setFrame:CGRectMake(imgWchat1.right + k375Width(10), k375Width(6), k375Width(300), k375Width(20))];
        [lblWchatName1 setText:@"AppStore支付"];
        [lblWchatName1 setFont:WY_FONT375Regular(14)];
        [colWchat1 addSubview:lblWchatName1];
    
        [imgWchatSel1 setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
        [imgWchatSel1 setImage:[UIImage imageNamed:@"0316_sel"]];
        [colWchat1 addSubview:imgWchatSel1];
        payLastY = colWchat1.bottom;
        
        viewSel5PayType.height = colWchat1.bottom + k360Width(5);

        
    } else {
        [colWchat setFrame:CGRectMake(k375Width(16), payLastY, kScreenWidth - k375Width(32), k375Width(44))];
        //    [col1 setBackgroundColor:[UIColor redColor]];
        [viewSel5PayType addSubview:colWchat];
        
        [imgWchat setFrame:CGRectMake(k375Width(16), k375Width(6), k375Width(20), k375Width(20))];
        [imgWchat setImage:[UIImage imageNamed:@"0317wchat"]];
        [colWchat addSubview:imgWchat];
        
        [lblWchatName setFrame:CGRectMake(imgWchat.right + k375Width(10), k375Width(6), k375Width(300), k375Width(20))];
        [lblWchatName setText:@"微信支付"];
        [lblWchatName setFont:WY_FONT375Regular(14)];
        [colWchat addSubview:lblWchatName];
        
        [imgWchatSel setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
        [colWchat addSubview:imgWchatSel];
        
        [colAliPay setFrame:CGRectMake(k375Width(16), colWchat.bottom, kScreenWidth - k375Width(32), k375Width(44))];
        [viewSel5PayType addSubview:colAliPay];
        
        [imgAliPay setFrame:CGRectMake(k375Width(16), k375Width(6), k375Width(20), k375Width(20))];
        [imgAliPay setImage:[UIImage imageNamed:@"0317alipay"]];
        [colAliPay addSubview:imgAliPay];
        
        [lblAliPayName setFrame:CGRectMake(imgAliPay.right + k375Width(10), k375Width(6), k375Width(300), k375Width(20))];
        [lblAliPayName setText:@"支付宝支付"];
        [lblAliPayName setFont:WY_FONT375Regular(14)];
        [colAliPay addSubview:lblAliPayName];
        
        [imgAliPaySel setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
        [imgAliPaySel setImage:[UIImage imageNamed:@"yuan2"]];
        [colAliPay addSubview:imgAliPaySel];
        
        viewSel5PayType.height = colAliPay.bottom + k360Width(5);

    }
    //临时加的 苹果支付-
    
    
    if ([self.isIAPPay isEqualToString:@"1"]) {
        self.payType = @"009";
        [imgWchatSel setImage:[UIImage imageNamed:@"yuan2"]];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",108.00]];
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 元/%@  ",self.dicPostCAInfo[@"dicCAInfo"][@"yxqName"]]];
        [attStr setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStr setYy_color:HEXCOLOR(0xE38D38)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr1 setYy_color:HEXCOLOR(0xE38D38)];
        [attStr2 setYy_font:WY_FONTRegular(14)];
        
        [attStr appendAttributedString:attStr1];
        [attStr appendAttributedString:attStr2];
        if ([self.isEdit isEqualToString:@"2"]) {
            [attStr yy_appendString:@"（已支付）"];
         }
        self.lblMoneySum.attributedText = attStr;

        
    } else {
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[self.dicPostCAInfo[@"dicCAInfo"][@"money"] floatValue]]];
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 元/%@  ",self.dicPostCAInfo[@"dicCAInfo"][@"yxqName"]]];
        [attStr setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStr setYy_color:HEXCOLOR(0xE38D38)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr1 setYy_color:HEXCOLOR(0xE38D38)];
        [attStr2 setYy_font:WY_FONTRegular(14)];
        
        [attStr appendAttributedString:attStr1];
        [attStr appendAttributedString:attStr2];
        if ([self.isEdit isEqualToString:@"2"]) {
            [attStr yy_appendString:@"（已支付）"];
         }
        self.lblMoneySum.attributedText = attStr;

        
        self.payType = @"03";
        [imgWchatSel setImage:[UIImage imageNamed:@"0316_sel"]];
    }
    
    
    
  
    
    [colWchat1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.payType = @"009";
        [imgWchatSel1 setImage:[UIImage imageNamed:@"0316_sel"]];
        [imgWchatSel setImage:[UIImage imageNamed:@"yuan2"]];
        [imgAliPaySel setImage:[UIImage imageNamed:@"yuan2"]];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",108.00]];
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 元/%@  ",self.dicPostCAInfo[@"dicCAInfo"][@"yxqName"]]];
        [attStr setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStr setYy_color:HEXCOLOR(0xE38D38)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr1 setYy_color:HEXCOLOR(0xE38D38)];
        [attStr2 setYy_font:WY_FONTRegular(14)];
        
        [attStr appendAttributedString:attStr1];
        [attStr appendAttributedString:attStr2];
        if ([self.isEdit isEqualToString:@"2"]) {
            [attStr yy_appendString:@"（已支付）"];
         }
        self.lblMoneySum.attributedText = attStr;

        
    }];
    
    [colWchat addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.payType = @"03";
        [imgWchatSel setImage:[UIImage imageNamed:@"0316_sel"]];
        [imgAliPaySel setImage:[UIImage imageNamed:@"yuan2"]];
        [imgWchatSel1 setImage:[UIImage imageNamed:@"yuan2"]];
        
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[self.dicPostCAInfo[@"dicCAInfo"][@"money"] floatValue]]];
         
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 元/%@  ",self.dicPostCAInfo[@"dicCAInfo"][@"yxqName"]]];
        [attStr setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStr setYy_color:HEXCOLOR(0xE38D38)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr1 setYy_color:HEXCOLOR(0xE38D38)];
        [attStr2 setYy_font:WY_FONTRegular(14)];
        
        [attStr appendAttributedString:attStr1];
        [attStr appendAttributedString:attStr2];
        if ([self.isEdit isEqualToString:@"2"]) {
            [attStr yy_appendString:@"（已支付）"];
         }
        self.lblMoneySum.attributedText = attStr;
    }];
    
    [colAliPay addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.payType = @"02";
        [imgWchatSel setImage:[UIImage imageNamed:@"yuan2"]];
        [imgAliPaySel setImage:[UIImage imageNamed:@"0316_sel"]];
        [imgWchatSel1 setImage:[UIImage imageNamed:@"yuan2"]];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[self.dicPostCAInfo[@"dicCAInfo"][@"money"] floatValue]]];
         
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 元/%@  ",self.dicPostCAInfo[@"dicCAInfo"][@"yxqName"]]];
        [attStr setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStr setYy_color:HEXCOLOR(0xE38D38)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr1 setYy_color:HEXCOLOR(0xE38D38)];
        [attStr2 setYy_font:WY_FONTRegular(14)];
        
        [attStr appendAttributedString:attStr1];
        [attStr appendAttributedString:attStr2];
        if ([self.isEdit isEqualToString:@"2"]) {
            [attStr yy_appendString:@"（已支付）"];
         }
        self.lblMoneySum.attributedText = attStr;
    }];

    //如果是被拒后-修改订单- 不显示支付方式模块
    if ([self.isEdit isEqualToString:@"2"]) {
        [viewSel5PayType setHidden:YES];
        [viewSel6Fp setFrame:CGRectMake(0, viewSel5PayType.top, kScreenWidth, k375Width(44))];
    } else {
        [viewSel5PayType setHidden:NO];
        [viewSel6Fp setFrame:CGRectMake(0, viewSel5PayType.bottom + k375Width(5), kScreenWidth, k375Width(44))];
        
    }
}

- (void)initMiddleView {
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - self.viewTop.bottom - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    UIView *viewBottom = [UIView new];
    [viewBottom setFrame:CGRectMake(0, self.mScrollView.bottom, kScreenWidth, k360Width(50))];
    [viewBottom setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewBottom];
    self.lblMoneySum = [UILabel new];
    [self.lblMoneySum setFrame:CGRectMake(k360Width(16), 0, k360Width(250), k360Width(50))];
    
    
    [viewBottom addSubview:self.lblMoneySum];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k375Width(78+16), k360Width(5), k375Width(78), k360Width(40))];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:self.btnSubmit];
    
    
    if ([self.isEdit isEqualToString:@"2"]) {
        [self.btnSubmit setTitle:@"修改订单" forState:UIControlStateNormal];
        self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k375Width(88+16), k360Width(5), k375Width(88), k360Width(40))];
    } else {
        [self.btnSubmit setTitle:@"付  款" forState:UIControlStateNormal];
    }
    
    
    UIView *viewSel1 = [UIView new];
    UIView *viewSel2 = [UIView new];
    self.viewSel3Yj = [UIView new];
    self.viewSel4Lq = [UIView new];
    self.viewSel5PayType = [UIView new];
    self.viewSel6Fp = [UIView new];
    
    UILabel *lblT2 = [UILabel new];
    self.lblT3 = [UILabel new];
    self.lblT4 = [UILabel new];
    UILabel *lblGLPTA = [UILabel new];
    UILabel *lblGLPTB = [UILabel new];
    
    [viewSel1 setFrame:CGRectMake(0, k375Width(5), kScreenWidth, k375Width(150))];
    [viewSel1 setBackgroundColor:[UIColor whiteColor]];
    
    [lblT2 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblT2 setText:@"证书信息"];
    [lblT2 setTextColor:HEXCOLOR(0x434343)];
    [lblT2 setFont:WY_FONT375Medium(16)];
    [viewSel1 addSubview:lblT2];
    
    UIImageView *imgukey = [UIImageView new];
    [imgukey setFrame:CGRectMake(viewSel1.width - k360Width(75+16), lblT2.top, k360Width(75), k360Width(75))];
    [imgukey setImage:[UIImage imageNamed:@"0420_cloudsign_sel"]];
    [viewSel1 addSubview:imgukey];
    
    [self.lblT3 setFrame:CGRectMake(k375Width(16),lblT2.bottom + k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [self.lblT3 setTextColor:HEXCOLOR(0x434343)];
    [self.lblT3 setFont:WY_FONT375Medium(16)];
    [viewSel1 addSubview:self.lblT3];
    
    [lblGLPTA setFrame:CGRectMake(k375Width(16), self.lblT3.bottom + k375Width(5), k375Width(80), k375Width(22))];
    [lblGLPTA setText:@"证书厂商："];
    [lblGLPTA setTextColor:HEXCOLOR(0x434343)];
    [lblGLPTA setFont:WY_FONT375Regular(14)];
    [viewSel1 addSubview:lblGLPTA];
    
    [lblGLPTB setFrame:CGRectMake(lblGLPTA.right- k360Width(10), lblGLPTA.top, kScreenWidth - lblGLPTA.right , k360Width(44))];
    [lblGLPTB setText:self.dicPostCAInfo[@"dicCAInfo"][@"caName"]];
//    [lblGLPTB setText:@"辽宁建设工程信息网、辽宁政府采购网、朝阳市公共资源交易平台"];
    [lblGLPTB setFont:WY_FONT375Medium(14)];
    [lblGLPTB setTextColor:HEXCOLOR(0x434343)];
    [lblGLPTB setNumberOfLines:0];
    [lblGLPTB sizeToFit];
    lblGLPTB.height += k360Width(10);
    
    lblGLPTA.centerY = lblGLPTB.centerY;
    [viewSel1 addSubview:lblGLPTB];
    
    
    [self.lblT4 setFrame:CGRectMake(k375Width(16), lblGLPTB.bottom, kScreenWidth - k375Width(10), k375Width(72))];
    [self.lblT4 setNumberOfLines:0];
    [self.lblT4 setTextColor:HEXCOLOR(0x434343)];
    [self.lblT4 setFont:WY_FONT375Regular(14)];
    [viewSel1 addSubview:self.lblT4];
    
    
    [self.lblT3 setText:@"云签章"];
    
    
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金      额：%.2f元\n有 效 期 ：自云签章生成之日起%@内有效（如已经办理，有效期自动累加）",[self.dicPostCAInfo[@"dicCAInfo"][@"money"] floatValue],self.dicPostCAInfo[@"dicCAInfo"][@"yxqName"]]];
    [moneyStr setYy_lineSpacing:5];
    [self.lblT4 setAttributedText:moneyStr];
    
    
    UIButton *btnEdit = [UIButton new];
    [btnEdit setFrame:CGRectMake(k360Width(264), self.lblT4.bottom + k360Width(5), k360Width(85), k360Width(30))];
    [btnEdit rounded:k360Width(30/4)];
    [btnEdit setBackgroundColor:MSTHEMEColor];
    [btnEdit.titleLabel setFont:WY_FONTRegular(12)];
    [btnEdit setTitle:@"重新编辑" forState:UIControlStateNormal];
    [viewSel1 addSubview:btnEdit];

    [btnEdit addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否重新填写证书信息" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            NSArray *pushVCAry=[self.navigationController viewControllers];
            UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-2];
            [self.navigationController popToViewController:popVC animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }];

    viewSel1.height = btnEdit.bottom + k360Width(10);
    //领取方式
    [viewSel2 setFrame:CGRectMake(0, viewSel1.bottom + k375Width(5), kScreenWidth, k375Width(90))];
    [viewSel2 setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lblTL1 = [UILabel new];
    [lblTL1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTL1 setText:@"领取方式"];
    [lblTL1 setTextColor:HEXCOLOR(0x434343)];
    [lblTL1 setFont:WY_FONT375Medium(14)];
    [viewSel2 addSubview:lblTL1];
    
    self.btnYj = [UIButton new];
    self.btnLq = [UIButton new];
    
    [self.btnYj setFrame:CGRectMake(k375Width(32), lblTL1.bottom + k375Width(10), k375Width(150), k375Width(30))];
    
    [self.btnLq setFrame:CGRectMake(self.btnYj.right + k375Width(50), lblTL1.bottom + k375Width(10), k375Width(100), k375Width(30))];
    
    [self.btnYj setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnYj setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnYj setTitle:@"邮寄（顺丰寄付）" forState:UIControlStateNormal];
    [self.btnYj setSelected:YES];
    
    [self.btnYj  setTitleColor:HEXCOLOR(0x434343) forState:UIControlStateNormal];
    [self.btnLq  setTitleColor:HEXCOLOR(0x434343) forState:UIControlStateNormal];
    
    [self.btnYj.titleLabel setFont:WY_FONT375Regular(14)];
    [self.btnLq.titleLabel setFont:WY_FONT375Regular(14)];
    [self.btnYj setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnLq setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnYj setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnLq setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [self.btnLq setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnLq setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnLq setTitle:@"领取" forState:UIControlStateNormal];
    
    [viewSel2 addSubview:self.btnYj];
    [viewSel2 addSubview:self.btnLq];
    
    
    [viewSel3Yj setFrame:CGRectMake(0, viewSel2.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    [viewSel3Yj setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lblTYj1 = [UILabel new];
    [lblTYj1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTYj1 setText:@"收货信息"];
    [lblTYj1 setTextColor:HEXCOLOR(0x434343)];
    [lblTYj1 setFont:WY_FONT375Medium(14)];
    [viewSel3Yj addSubview:lblTYj1];
    UIControl *colAddressSel = [UIControl new];
    [colAddressSel setFrame:CGRectMake(0, lblTYj1.bottom, kScreenWidth, viewSel3Yj.height - lblTYj1.bottom)];
    [viewSel3Yj addSubview:colAddressSel];
    //    [colAddressSel setBackgroundColor:[UIColor yellowColor]];
    self.lblAddressSel = [UILabel new];
    [self.lblAddressSel setFrame:CGRectMake(k375Width(32), 0, kScreenWidth - k375Width(64), colAddressSel.height)];
    [self.lblAddressSel setNumberOfLines:0];
    [self.lblAddressSel setText:@"请选择收货地址"];
    [self.lblAddressSel setTextColor:HEXCOLOR(0x666666)];
    UIImageView *imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), (colAddressSel.height- k360Width(10)) / 2, k360Width(22), k360Width(22))];
    [imgAcc setImage:[UIImage imageNamed:@"accup"]];
    [colAddressSel addSubview:imgAcc];
    
    
    [colAddressSel addSubview:self.lblAddressSel];
    [colAddressSel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        WY_AddressManageViewController *tempController = [WY_AddressManageViewController new];
        tempController.title = @"地址管理";
        tempController.isSel = YES;
        tempController.selAddressBlock = ^(WY_AddressManageModel * _Nonnull selModel) {
            self.selAddress = selModel;
            self.selAddress.addressStr = [NSString stringWithFormat:@"%@%@%@%@",self.selAddress.province,self.selAddress.city,self.selAddress.district,self.selAddress.Address];
            [self.lblAddressSel setTextColor:[UIColor blackColor]];
            NSMutableAttributedString *straddress = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@\n%@",self.selAddress.UserName,self.selAddress.Mobile,self.selAddress.addressStr]];
            [straddress setYy_lineSpacing:5];
            [self.lblAddressSel setAttributedText:straddress];
        };
        [self.navigationController pushViewController:tempController animated:YES];
        
    }];
    
    [viewSel4Lq setFrame:CGRectMake(0, viewSel2.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    [viewSel4Lq setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lblTLq1 = [UILabel new];
    [lblTLq1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTLq1 setText:@"领取："];
    [lblTLq1 setTextColor:HEXCOLOR(0x434343)];
    [lblTLq1 setFont:WY_FONT375Medium(14)];
    [viewSel4Lq addSubview:lblTLq1];
    UILabel *lblTLqBZ = [UILabel new];
    UILabel *lblTLqName = [UILabel new];
    UILabel *lblTLqPhone = [UILabel new];
    UILabel *lblTLqPhone1 = [UILabel new];
    
    UIButton *btnLqPhone = [UIButton new];
    UILabel *lblTLqAddress = [UILabel new];
    UILabel *lblTLqAddress1 = [UILabel new];
    UILabel *lblTLqGs = [UILabel new];
    
    
    
    [lblTLqBZ setFrame:CGRectMake(k375Width(16), lblTLq1.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(50))];
    [lblTLqBZ setNumberOfLines:0];
    [lblTLqBZ setText:self.dicPostCAInfo[@"dicCAInfo"][@"lqbz"]];
    [lblTLqBZ setTextColor:[UIColor blackColor]];
    [lblTLqBZ setFont:WY_FONT375Medium(14)];
    [viewSel4Lq addSubview:lblTLqBZ];
    [lblTLqBZ sizeToFit];
    lblTLqBZ.height += k360Width(12);

    [lblTLqGs setFrame:CGRectMake(k375Width(16), lblTLqBZ.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(22))];
    [lblTLqGs setText:[NSString stringWithFormat:@"联系单位：%@",self.dicPostCAInfo[@"dicCAInfo"][@"lqdw"]]];
    [lblTLqGs setTextColor:HEXCOLOR(0x434343)];
    [lblTLqGs setFont:WY_FONT375Regular(14)];
    [viewSel4Lq addSubview:lblTLqGs];
    
    
    [lblTLqAddress setFrame:CGRectMake(k375Width(16), lblTLqGs.bottom + k375Width(5), k375Width(80), k375Width(22))];
    [lblTLqAddress setText:@"领取地址："];
    [lblTLqAddress setTextColor:HEXCOLOR(0x434343)];
    [lblTLqAddress setFont:WY_FONT375Regular(14)];
    [viewSel4Lq addSubview:lblTLqAddress];
    
    
    [lblTLqAddress1 setFrame:CGRectMake(lblTLqAddress.right- k360Width(10), lblTLqAddress.top, kScreenWidth - lblTLqAddress.right + k360Width(10), k360Width(44))];
    [lblTLqAddress1 setTextColor:HEXCOLOR(0x434343)];
    
    [lblTLqAddress1 setText:self.dicPostCAInfo[@"dicCAInfo"][@"lqdz"]];
    [lblTLqAddress1 setNumberOfLines:0];
    [lblTLqAddress1 sizeToFit];
    lblTLqAddress1.height += k360Width(12);
    [lblTLqAddress1 setFont:WY_FONT375Regular(14)];
    
    lblTLqAddress.centerY = lblTLqAddress1.centerY;
    [viewSel4Lq addSubview:lblTLqAddress1];
    
    
    
    [lblTLqName setFrame:CGRectMake(k375Width(16), lblTLqAddress1.bottom + k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTLqName setText:[NSString stringWithFormat:@"联 系 人 ：%@",self.dicPostCAInfo[@"dicCAInfo"][@"lqlxr"]]];
    [lblTLqName setTextColor:HEXCOLOR(0x434343)];
    [lblTLqName setFont:WY_FONT375Regular(14)];
    [viewSel4Lq addSubview:lblTLqName];
    
    //    [lblTLqPhone setFrame:CGRectMake(k375Width(16), lblTLqName.bottom + k375Width(5), kScreenWidth - k375Width(60), k375Width(44))];
    //    [lblTLqPhone setNumberOfLines:0];
    //    [lblTLqPhone setText:[NSString stringWithFormat:@"联系电话：%@",self.dicPostCAInfo[@"dicCAInfo"][@"lqdh"]]];
    //    [lblTLqPhone setTextColor:HEXCOLOR(0x434343)];
    //    [lblTLqPhone setFont:WY_FONT375Regular(14)];
    //    [viewSel4Lq addSubview:lblTLqPhone];
    
    
    [lblTLqPhone setFrame:CGRectMake(k375Width(16), lblTLqName.bottom + k375Width(5), k375Width(80), k375Width(22))];
    [lblTLqPhone setText:@"联系电话："];
    [lblTLqPhone setTextColor:HEXCOLOR(0x434343)];
    [lblTLqPhone setFont:WY_FONT375Regular(14)];
    [viewSel4Lq addSubview:lblTLqPhone];
    
    NSMutableArray *lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicPostCAInfo[@"dicCAInfo"][@"lqdh"] componentsSeparatedByString:@"，"]];
    NSString *lqdhsStr = [lqdhs componentsJoinedByString:@"\n"];
    
    [lblTLqPhone1 setFrame:CGRectMake(lblTLqPhone.right - k360Width(10), lblTLqPhone.top, kScreenWidth - lblTLqPhone.right - k360Width(52), k360Width(44))];
    [lblTLqPhone1 setTextColor:HEXCOLOR(0x434343)];
    [lblTLqPhone1 setText:lqdhsStr];
    [lblTLqPhone1 setFont:WY_FONT375Regular(14)];
    [lblTLqPhone1 setNumberOfLines:0];
    [lblTLqPhone1 sizeToFit];
    lblTLqPhone1.height += k360Width(12);
    lblTLqPhone.centerY = lblTLqPhone1.centerY;
    [viewSel4Lq addSubview:lblTLqPhone1];
    
    
    
    [btnLqPhone setFrame:CGRectMake(kScreenWidth - k360Width(22+16), lblTLqPhone.top + k375Width(10), k375Width(22), k375Width(22))];
    [btnLqPhone setImage:[UIImage imageNamed:@"0317phone"] forState:UIControlStateNormal];
    [btnLqPhone setCenterY:lblTLqPhone.centerY];
    [viewSel4Lq addSubview:btnLqPhone];
    
    [btnLqPhone setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        NSMutableArray *lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicPostCAInfo[@"dicCAInfo"][@"lqdh"] componentsSeparatedByString:@"，"]];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拨打联系电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *phoneNum in lqdhs) {
            [alertController addAction:[UIAlertAction actionWithTitle:phoneNum style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [GlobalConfig makeCall:phoneNum];
            }]];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
    }];
    
    viewSel4Lq.height = lblTLqPhone.bottom + k360Width(20);
    [viewSel4Lq setHidden:YES];
    
    
    //    领取方式隐藏
        [viewSel2 setHidden:YES];
    //    收货信息隐藏
        [viewSel3Yj setHidden:YES];
        
    
    //支付方式
    [viewSel5PayType setFrame:CGRectMake(0, viewSel1.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    [viewSel5PayType setBackgroundColor:[UIColor whiteColor]];
    [self initPayTypeView];
    
    //发票信息
    [viewSel6Fp setBackgroundColor:[UIColor whiteColor]];
    
    lblTFp1 = [UILabel new];
    [lblTFp1 setFrame:CGRectMake(k375Width(16), 0, kScreenWidth - k375Width(10), k375Width(44))];
    [lblTFp1 setText:@"是否开具电子发票"];
    [lblTFp1 setTextColor:HEXCOLOR(0x434343)];
    [lblTFp1 setFont:WY_FONT375Medium(14)];
    [viewSel6Fp addSubview:lblTFp1];
    
    lblTFp2 = [UILabel new];
    [lblTFp2 setFrame:CGRectMake(k375Width(16), k360Width(44), kScreenWidth - k375Width(32), k375Width(44))];
    [lblTFp2 setText:@"您办理的云签章为您的个人行为，根据《中华人民共和国发票管理办法》第十九、二十条规定，本公司将为您提供增值税电子普通发票，抬头为申请人姓名。增值税电子普通发票法律效力、基本用途、基本使用规定等与增值税普通发票相同，如需纸质普通发票请联系财务024-67793888。"];
    [lblTFp2 setNumberOfLines:0];
    [lblTFp2 setTextColor:[UIColor redColor]];
    [lblTFp2 setFont:WY_FONT375Regular(14)];
    [viewSel6Fp addSubview:lblTFp2];
    [lblTFp2 sizeToFit];
    lblTFp2.height += k360Width(10);

    
    btnTFp3 = [UIButton new];
    [btnTFp3 setFrame:CGRectMake(k375Width(16), lblTFp2.bottom + k360Width(5),  k375Width(90), k375Width(30))];
    [btnTFp3 setTitle:@"发票样式预览" forState:UIControlStateNormal];
    [btnTFp3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTFp3 setFont:WY_FONT375Medium(12)];
    [btnTFp3 setBackgroundColor:MSTHEMEColor];
    [btnTFp3 rounded:k360Width(30/4)];
    [viewSel6Fp addSubview:btnTFp3];

    [btnTFp3 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"发票样式预览功能");
        [self goImageShow:@"http://lnwlzj.capass.cn/lnwlzj/1ac0aab102f247b68eec5e411cbddc13.jpg"];
    }];
 
    
    self.btnFpYes = [UIButton new];
    self.btnFpNo = [UIButton new];
    
    [self.btnFpYes setFrame:CGRectMake(kScreenWidth -  k375Width(110), k375Width(7), k375Width(50), k375Width(30))];
    
    [self.btnFpNo setFrame:CGRectMake(self.btnFpYes.right + k375Width(10), k375Width(7), k375Width(50), k375Width(30))];
    
    [self.btnFpYes setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnFpYes setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnFpYes setTitle:@"是" forState:UIControlStateNormal];
    [self.btnFpYes setSelected:NO];
    
    [self.btnFpYes  setTitleColor:HEXCOLOR(0x434343) forState:UIControlStateNormal];
    [self.btnFpNo  setTitleColor:HEXCOLOR(0x434343) forState:UIControlStateNormal];
    
    [self.btnFpYes.titleLabel setFont:WY_FONT375Regular(14)];
    [self.btnFpNo.titleLabel setFont:WY_FONT375Regular(14)];
    [self.btnFpYes setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnFpNo setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnFpYes setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnFpNo setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [self.btnFpNo setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnFpNo setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnFpNo setTitle:@"否" forState:UIControlStateNormal];
    [self.btnFpNo setSelected:YES];

    [viewSel6Fp addSubview:self.btnFpYes];
    [viewSel6Fp addSubview:self.btnFpNo];
    
    
    [btnTFp3 setHidden:!NO];
    [lblTFp2 setHidden:!NO];

    
    
    [self.btnFpYes addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.btnFpYes setSelected:YES];
        [self.btnFpNo setSelected:NO];
        [btnTFp3 setHidden:NO];
        [lblTFp2 setHidden:NO];
        viewSel6Fp.height = btnTFp3.bottom + k360Width(5);
        [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];

    }];
    
    [self.btnFpNo addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.btnFpYes setSelected:!YES];
        [self.btnFpNo setSelected:!NO];
        [btnTFp3 setHidden:!NO];
        [lblTFp2 setHidden:!NO];
        viewSel6Fp.height = lblTFp1.bottom + k360Width(5);
        [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];

    }];
//    self.switchFP = [UISwitch new];
//    [self.switchFP setFrame:CGRectMake(kScreenWidth - k375Width(60), 0, k375Width(40), k375Width(44))];
//    self.switchFP.centerY = lblTFp1.centerY;
//    [viewSel6Fp addSubview:self.switchFP];
    
    
    
    viewSel6Fp.height = lblTFp1.bottom + k360Width(5);
    
    [self.mScrollView addSubview:viewSel1];
    [self.mScrollView addSubview:viewSel2];
    [self.mScrollView addSubview:viewSel3Yj];
    [self.mScrollView addSubview:viewSel4Lq];
    [self.mScrollView addSubview:viewSel5PayType];
    [self.mScrollView addSubview:viewSel6Fp];
    
    [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
    [self.btnYj addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [viewSel3Yj setHidden:NO];
        [viewSel4Lq setHidden:YES];
        [self.btnYj setSelected:YES];
        [self.btnLq setSelected:NO];
        viewSel5PayType.top = viewSel3Yj.bottom + k375Width(5);
        [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
        if ([self.isEdit isEqualToString:@"2"]) {
            viewSel6Fp.top = viewSel5PayType.top;
        } else {
            viewSel6Fp.top = viewSel5PayType.bottom + k375Width(5);
        }
    }];
    
    [self.btnLq addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //疫情字典ID 11
        NSDictionary *dicZj = [WY_WLTools zjDicGetById:11];
        if (dicZj != nil) {
            if ([dicZj[@"code"] intValue] == 1) {
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:dicZj[@"codeText"] preferredStyle:UIAlertControllerStyleAlert];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self.navigationController presentViewController:alertControl animated:YES completion:nil];
                return;
            }
        }
        [viewSel3Yj setHidden:!NO];
        [viewSel4Lq setHidden:!YES];
        [self.btnYj setSelected:!YES];
        [self.btnLq setSelected:!NO];
        
        viewSel5PayType.top = viewSel4Lq.bottom + k375Width(5);
//        viewSel6Fp.top = viewSel5PayType.bottom + k375Width(5);
        if ([self.isEdit isEqualToString:@"2"]) {
            viewSel6Fp.top = viewSel5PayType.top;
        } else {
            viewSel6Fp.top = viewSel5PayType.bottom + k375Width(5);
        }
        [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
        
    }];
}

- (void)bindView {
    if(self.dicPostCAInfo) {
        float tempMoney = 0;
        if ([self.isIAPPay isEqualToString:@"1"]) {
            tempMoney = 108.00;
        } else {
            tempMoney =[self.dicPostCAInfo[@"dicCAInfo"][@"money"] floatValue];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",tempMoney]];
        
         
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 元/%@  ",self.dicPostCAInfo[@"dicCAInfo"][@"yxqName"]]];
        [attStr setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStr setYy_color:HEXCOLOR(0xE38D38)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr1 setYy_color:HEXCOLOR(0xE38D38)];
        [attStr2 setYy_font:WY_FONTRegular(14)];
        
        [attStr appendAttributedString:attStr1];
        [attStr appendAttributedString:attStr2];
        if ([self.isEdit isEqualToString:@"2"]) {
            [attStr yy_appendString:@"（已支付）"];
         }
        self.lblMoneySum.attributedText = attStr;
        
    }
    
    if ([self.isEdit isEqual:@"1"] || [self.isEdit isEqual:@"2"]) {
        //改发票状态
//        [self.switchFP setOn:[self.dicEditInfo[@"isInvoice"] intValue] == 1];
        
        [self.btnFpYes setSelected:[self.dicEditInfo[@"isInvoice"] intValue] == 1];
        [self.btnFpNo setSelected:[self.dicEditInfo[@"isInvoice"] intValue] != 1];
        
        //改收货方式
        if ([self.dicEditInfo[@"islingqu"] intValue] == 1) {
            //领取
            [viewSel3Yj setHidden:!NO];
            [viewSel4Lq setHidden:!YES];
            [self.btnYj setSelected:!YES];
            [self.btnLq setSelected:!NO];
            
            viewSel5PayType.top = viewSel4Lq.bottom + k375Width(5);
             if ([self.isEdit isEqualToString:@"2"]) {
                viewSel6Fp.top = viewSel5PayType.top;
            } else {
                viewSel6Fp.top = viewSel5PayType.bottom + k375Width(5);
            }
            self.selAddress = nil;
            [self.lblAddressSel setText:@"请选择收货地址"];
            [self.lblAddressSel setTextColor:HEXCOLOR(0x666666)];
        } else {
            self.selAddress = [WY_AddressManageModel new];
            self.selAddress.UserName = self.dicEditInfo[@"shrxm"];
            self.selAddress.Mobile = self.dicEditInfo[@"shrdh"];
            self.selAddress.addressStr = self.dicEditInfo[@"shrdz"];
            self.selAddress.postCode = self.dicEditInfo[@"provinceCode"];
            self.selAddress.CityCode = self.dicEditInfo[@"cityCode"];
            self.selAddress.CountryCode = self.dicEditInfo[@"countryCode"];
            
            [viewSel3Yj setHidden:NO];
            [viewSel4Lq setHidden:YES];
            [self.btnYj setSelected:YES];
            [self.btnLq setSelected:NO];
            viewSel5PayType.top = viewSel3Yj.bottom + k375Width(5);
            if ([self.isEdit isEqualToString:@"2"]) {
                viewSel6Fp.top = viewSel5PayType.top;
            } else {
                viewSel6Fp.top = viewSel5PayType.bottom + k375Width(5);
            }
            [self.lblAddressSel setTextColor:[UIColor blackColor]];
            NSMutableAttributedString *straddress = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@\n%@",self.selAddress.UserName,self.selAddress.Mobile,self.selAddress.addressStr]];
            [straddress setYy_lineSpacing:5];
            [self.lblAddressSel setAttributedText:straddress];
        }
        if (self.btnFpYes.selected) {
            [self.btnFpYes setSelected:YES];
            [self.btnFpNo setSelected:NO];
            [btnTFp3 setHidden:NO];
            [lblTFp2 setHidden:NO];
            viewSel6Fp.height = btnTFp3.bottom + k360Width(5);
            [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
        } else {
            [self.btnFpYes setSelected:!YES];
            [self.btnFpNo setSelected:!NO];
            [btnTFp3 setHidden:!NO];
            [lblTFp2 setHidden:!NO];
            viewSel6Fp.height = lblTFp1.bottom + k360Width(5);
            [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
        }
    }
}

- (void)makeUIAAA {
    
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    
    //模拟两个功能1.微信支付、 2.手写签字；
    UIButton *btnWChatPay = [UIButton new];
    UIButton *btnSign = [UIButton new];
    UIButton *btnAddress = [UIButton new];
    
    [btnWChatPay setTitle:@"微信支付" forState:UIControlStateNormal];
    [btnSign setTitle:@"手写签字" forState:UIControlStateNormal];
    [btnAddress setTitle:@"选择地址" forState:UIControlStateNormal];
    
    [btnWChatPay setFrame:CGRectMake(k360Width(32), JCNew64 + k360Width(60), k360Width(160), k360Width(34))];
    
    [btnSign setFrame:CGRectMake(k360Width(32), btnWChatPay.bottom + k360Width(60), k360Width(160), k360Width(34))];
    
    [btnAddress setFrame:CGRectMake(k360Width(32), btnSign.bottom + k360Width(60), k360Width(160), k360Width(34))];
    
    [btnWChatPay setBackgroundColor:[UIColor grayColor]];
    [btnSign setBackgroundColor:[UIColor greenColor]];
    
    [btnAddress setBackgroundColor:[UIColor greenColor]];
    
    [btnWChatPay addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了微信支付");
    }];
    
    [btnSign addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了签名");
        WY_SignViewController *tempController = [WY_SignViewController new];
        tempController.modalPresentationStyle = 0;
        [self presentViewController:tempController animated:YES completion:nil];
        
    }];
    [btnAddress addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了签名");
        WY_AddressManageViewController *tempController = [WY_AddressManageViewController new];
        tempController.title = @"地址管理";
        tempController.isSel = YES;
        tempController.selAddressBlock = ^(WY_AddressManageModel * _Nonnull selModel) {
            //            self.selAddress = selModel;
            //            [self.btnMailUserName setTitle:self.selAddress.UserName forState:UIControlStateNormal];
            //            [self.btnMailUserPhone setTitle:self.selAddress.Mobile forState:UIControlStateNormal];
            //            [self.btnMailUserAddress setTitle:self.selAddress.Address forState:UIControlStateNormal];
            //            [self.btnMailUserName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [self.btnMailUserPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [self.btnMailUserAddress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:tempController animated:YES];
        
        
    }];
    
    
    [self.view addSubview:btnWChatPay];
    [self.view addSubview:btnSign];
    [self.view addSubview:btnAddress];
    
    
    
    
}

- (void)btnUpAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnReSignAction {
    NSLog(@"点击了签名");
    WY_SignViewController *tempController = [WY_SignViewController new];
    tempController.popVCBlock = ^(NSString * _Nonnull picUrl) {
        self.mSignUrl = picUrl;
        self.btnUp.width = (kScreenWidth - k375Width(16*4)) / 3;
        self.btnReSign.width = self.btnUp.width;
        [self.btnReSign setTitle:@"重新签名" forState:UIControlStateNormal];
        [self.btnReSign setBackgroundColor:HEXCOLOR(0xE4E8ED)];
        [self.btnReSign setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        self.btnSubmit.width = self.btnUp.width;
        self.btnReSign.left = self.btnUp.right + k375Width(16);
        self.btnSubmit.left = self.btnReSign.right + k375Width(16);
        [self.btnSubmit setHidden:NO];
        
    };
    tempController.modalPresentationStyle = 0;
    [self presentViewController:tempController animated:YES completion:nil];
    
}

- (NSString *)creatP10 {
//    UITextField *pinText = (UITextField*)[alertView textFieldAtIndex:0];
    NSString *base64P10 = nil;
    CFCACertType certType = CFCA_CERT_SM2;
    BOOL isDoubleCert = YES;
    long lResult = [[SCAP sharedSCAP] generateP10:certType
                                     isDoubleCert:isDoubleCert
                                          pinCode:@"111111"
                                            p10:&base64P10];
    if (lResult == 0) {
        return base64P10;
    } else {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"产生密钥对失败: %2x", (unsigned int)lResult]];
        return  nil;
    }
}
- (void)btnSubmitAction {
    NSLog(@"点击了提交订单");
    
    // -在这之前还得弹个签字确认框；
    CustomAlertView *alert = [[CustomAlertView alloc] initWithAlertViewHeight:k360Width(400) withImage:self.dicPostCAInfo[@"dicCAInfo"][@"signature"] withTitle:@"请再次确认您本次提交办理的“云签章”适用于辽宁省工程建设项目数字化开标评标系统，且签字完整清晰。"];
    
    alert.ButtonClick = ^void(UIButton*button){
        NSLog(@"%ld",(long)button.tag);
        
        if (button.tag==100) {
            //look  rili
            
            [self submitFrom];
        } else {
            NSArray *pushVCAry=[self.navigationController viewControllers];
            UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-2];
            [self.navigationController popToViewController:popVC animated:YES];
        }
    };
    
    
    
}

- (void)submitFrom {
    self.pkcs10 = [self creatP10];
    if (self.pkcs10) {
        NSLog(@"self.pkcs10:%@",self.pkcs10);
    }
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] initWithDictionary:self.dicPostCAInfo[@"dicCAInfo"]];
    //是否开具发票 2否  1是
    if (self.btnFpYes.selected) {
        [postDic setObject:@"1" forKey:@"invoice"];
    } else {
        [postDic setObject:@"2" forKey:@"invoice"];
    }
    
    [postDic setObject:self.pkcs10 forKey:@"pkcs10"];
    
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_handleCloudSignature_HTTP params:nil jsonData:[postDic mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            [self.dicPostCAInfo setObject:res[@"data"][@"orderNo"] forKey:@"zddid"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"notCAJGNotify" object:nil];
            if (![self.isEdit isEqualToString:@"2"]) {
                NSLog(@"支付成功 - 后调取支付");
                self.dicSignUpSuccess = res[@"data"];
                [self weiXinAndAliPay];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"重新提交申请成功，请等待审核" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确定");
                    NSArray *pushVCAry=[self.navigationController viewControllers];
                    UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-5];
                    [self.navigationController popToViewController:popVC animated:YES];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    return;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)weiXinAndAliPay {
    [self tongLianPay];
    return;
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    NSLog(@"确认支付");
    WY_PayNeedModel *tempPayModel = [WY_PayNeedModel new];
    tempPayModel.orderGuid = self.dicSignUpSuccess[@"orderGuid"];
     tempPayModel.paymethod = self.payType;
    tempPayModel.body = self.dicSignUpSuccess[@"productDescription"];
    tempPayModel.userGuid =  self.mUser.UserGuid;
    tempPayModel.out_trade_no = self.dicSignUpSuccess[@"orderNo"];
     
    [[MS_BasicDataController sharedInstance] postWithReturnCode:onlinepay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if ([res[@"data"][@"responseString"] isEqual:[NSNull null]]) {
                [SVProgressHUD showErrorWithStatus:@"接口数据返回错误-请稍后再试"];
 
                return ;
            }
            NSDictionary *responseStringDic = [NSDictionary oss_dictionaryWithXMLString:res[@"data"][@"responseString"]];
            if ([responseStringDic[@"result_code"] isEqualToString:@"FAIL"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseStringDic[@"err_code_des"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            WY_CaOnlinePayCallBackModel *tempPayModel = [WY_CaOnlinePayCallBackModel new];
            tempPayModel.OrderGuid = self.dicSignUpSuccess[@"orderNo"];
            tempPayModel.userGuid =  self.mUser.UserGuid;
            tempPayModel.paymethod = self.payType;
            
//            [[MS_BasicDataController sharedInstance] postWithReturnCode:backonlinepay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
//                if ([code integerValue] == 0 ) {
//                    NSLog(@"回调轮询方法成功");
//                } else {
//                    NSLog(@"回调轮询方法失败");
//                }
//            } failure:^(NSError *error) {
//                NSLog(@"回调轮询方法500错误");
//            }];
            
            if ([self.payType isEqualToString:@"03"]) {
                //微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = @"wxd2381bec1a8984de";
                req.nonceStr            = responseStringDic[@"nonce_str"];
                req.package             = @"Sign=WXPay";
                req.partnerId           = responseStringDic[@"mch_id"];
                req.timeStamp           = [[NSDate date] timeIntervalSince1970];
                req.prepayId            = responseStringDic[@"prepay_id"];
                NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
                [signParams setObject: req.openID        forKey:@"appid"];
                [signParams setObject: req.nonceStr    forKey:@"noncestr"];
                [signParams setObject: req.package      forKey:@"package"];
                [signParams setObject: req.partnerId        forKey:@"partnerid"];
                [signParams setObject: [NSString stringWithFormat:@"%u", (unsigned int)req.timeStamp]   forKey:@"timestamp"];
                [signParams setObject: req.prepayId     forKey:@"prepayid"];
                //生成签名
                NSString *sign  = [self createMd5Sign:signParams];
                req.sign = sign;
 
                [WXApi sendReq:req completion:^(BOOL success) {
                    if (success) {
                        NSLog(@"成功");
                        
                    } else {
                        NSLog(@"失败");
                    }
                }];

            } else if ([self.payType isEqualToString:@"02"]) {
                //支付宝支付
                [[AlipaySDK defaultService] payOrder:res[@"data"][@"responseString"] fromScheme:@"lnzjfw" callback:^(NSDictionary *resultDic) {
                    NSLog(@"支付宝支付");
                }];
             }
            
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            //                 [btnGoInfo setEnabled:YES];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        //           [btnGoInfo setEnabled:YES];
    }];
}
 
- (void)tongLianPay {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    NSLog(@"确认支付");
     WY_PayNeedModel *tempPayModel = [WY_PayNeedModel new];
    tempPayModel.orderGuid = self.dicSignUpSuccess[@"orderGuid"];
     tempPayModel.paymethod = self.payType;
    tempPayModel.body = self.dicSignUpSuccess[@"productDescription"];
    tempPayModel.userGuid =  self.mUser.UserGuid;
    tempPayModel.out_trade_no = self.dicSignUpSuccess[@"orderNo"];
    
    if ([self.payType isEqualToString:@"009"]) {
        //苹果内购支付
        [self iapNeedPay:tempPayModel];
        return;
    }
    if ([self.payType isEqualToString:@"03"]) {
        [self weixinXCXPay:tempPayModel];
        return;
    } else {
        [[MS_BasicDataController sharedInstance] postWithReturnCode:allinPay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
            if ([code integerValue] == 0 ) {
                if ([self.payType isEqualToString:@"02"]) {
                    [self aliPayGoByQrCode:res[@"data"][@"responseString"]];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
    }
}

- (void)iapNeedPay:(WY_PayNeedModel *)tempPayModel {
    if (![self.mUser.LoginID isEqualToString:@"13940104171"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"系统错误，无法充值，请联系客服 024-86786677" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"拨打客服电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [GlobalConfig makeCall:@"024-86786677"];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [SVProgressHUD showWithStatus:@"苹果支付中" maskType:SVProgressHUDMaskTypeClear];
    
    if (!_IAPManager) {
        _IAPManager = [STRIAPManager shareSIAPManager];
    }
    _IAPManager.tempPayModel = tempPayModel;
    // iTunesConnect 苹果后台配置的产品ID
    NSString *purchID = @"com.lnwl.Expert6";
    [_IAPManager startPurchWithID:purchID completeHandle:^(SIAPPurchType type,NSData *data) {
        [SVProgressHUD ms_dismiss];
        
        //请求事务回调类型，返回的数据
        switch (type) {
            case SIAPPurchSuccess:
                NSLog(@"购买成功");
                //                    [SVProgressHUD showSuccessWithStatus:@"购买成功"];
                //                    self.lblBalance.text = @"6.00币";
                NSLog(@"本地验证购买成功-");
                break;
            case SIAPPurchFailed:
                [SVProgressHUD showErrorWithStatus:@"购买失败"];
                break;
            case SIAPPurchCancle:
                [SVProgressHUD showErrorWithStatus:@"您已取消购买"];
                
                break;
            case SIAPPurchVerFailed:
                [SVProgressHUD showErrorWithStatus:@"订单校验失败"];
                
                break;
            case SIAPPurchVerSuccess:
            {
                NSLog(@"订单校验成功");
                [SVProgressHUD showSuccessWithStatus:@"购买成功"];
//                NSString * strPrice  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                self.lblBalance.text = [NSString stringWithFormat:@"%.2f币",[strPrice floatValue]];
                
                NSLog(@"支付成功后检查支付状态");
                [self waitingForPayment];
            }
                break;
            case SIAPPurchNotArrow:
                [SVProgressHUD showErrorWithStatus:@"不允许程序内付费"];
                
                break;
            case SIAPPurchNotCommodity:
                [SVProgressHUD showErrorWithStatus:@"没有此商品"];
                
                break;
            default:
                break;
        }
    }];
    
    
    
//    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//    launchMiniProgramReq.userName = @"gh_65f0c33e8486";  //拉起的小程序的username
//    launchMiniProgramReq.path = [NSString stringWithFormat:@"pages/pay/pay?orderGuid=%@&out_trade_no=%@&paymethod=%@&userGuid=%@&body=%@&token=%@",tempPayModel.orderGuid,tempPayModel.out_trade_no,tempPayModel.paymethod,self.mUser.UserGuid,tempPayModel.body,self.mUser.token];
//    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
//    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
//        NSLog(@"成功");
//        [self waitingForPayment];
//    }];
}
- (void)weixinXCXPay:(WY_PayNeedModel *)tempPayModel {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = @"gh_65f0c33e8486";  //拉起的小程序的username
    launchMiniProgramReq.path = [NSString stringWithFormat:@"pages/pay/pay?orderGuid=%@&out_trade_no=%@&paymethod=%@&userGuid=%@&body=%@&token=%@",tempPayModel.orderGuid,tempPayModel.out_trade_no,tempPayModel.paymethod,self.mUser.UserGuid,tempPayModel.body,self.mUser.token];
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        NSLog(@"成功");
        [self waitingForPayment];
    }];
}

-(void)aliPayGoByQrCode:(NSString *)qrCode {
    // 是否支持支付宝
//    qrCode = @"https://qr.alipay.com/bax01054bkx6hafqhile00cf";
        NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay://"];
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
             // 跳转扫一扫
             NSURL * url2 = [NSURL URLWithString:[NSString stringWithFormat:@"alipay://platformapi/startapp?saId=10000007&qrcode=%@",qrCode]];
 
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url2 options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url2];
            }
            
            [self waitingForPayment];
        } else {
            [SVProgressHUD showErrorWithStatus:@"没有安装支付宝"];
        }
}


- (void)waitingForPayment {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你有一笔支付正在进行中,请稍后再进行新的操作" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"已完成支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        [self chenggong];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)gtPaySuccessPage {
    WY_CAPaySuccessViewController *tempController = [WY_CAPaySuccessViewController new];
    tempController.dicSignUpSuccess = self.dicSignUpSuccess;
    tempController.bodyStr = self.dicPostCAInfo[@"dicCAInfo"][@"money"];
    tempController.caType = @"2";
    NSArray *vcs = self.navigationController.viewControllers;
    
    NSMutableArray *newVCS = [NSMutableArray array];
    
    if ([vcs count] > 0) {
        [newVCS addObject:[vcs objectAtIndex:0]];
    }
    tempController.hidesBottomBarWhenPushed = YES;
    [newVCS addObject:tempController];
    [self.navigationController setViewControllers:newVCS animated:YES];
}

-(void)chenggong{
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.dicSignUpSuccess[@"orderNo"] forKey:@"orderNo"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getCloudSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            NSMutableDictionary *dicOrder = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
            if ([dicOrder[@"orderStatus"] intValue] == 2) {
                //已支付
                [self gtPaySuccessPage];
            } else {
                [SVProgressHUD showErrorWithStatus:@"未查询到您订单的支付状态，请前往订单列表页查询"];
            }
        } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];

    
     
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"])
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"MIIEvQIBADANBgkqhkiG9w0BAQEFAA12"];
    //得到MD5 sign签名
    NSString *md5Sign = [contentString md5String]; //[WXUtil md5:contentString];
    
    NSLog(@"MD5签名字符串：%@",contentString);
    return md5Sign;
}

- (void)goImageShow:(NSString *)strUrl {
    //打开图片；
    NSMutableArray *picModels = [NSMutableArray new];
    //       for (NSString *imgUrl in self.arrImgUrls) {
    IWPictureModel* picModel  = [IWPictureModel new];
    picModel.nsbmiddle_pic = strUrl;
    picModel.nsoriginal_pic = strUrl;
    [picModels addObject:picModel];
    //       }
    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
    indvController.mIWPictureModel = [picModels objectAtIndex:0];
    indvController.picArr = picModels;
    [self.navigationController pushViewController:indvController animated:YES];
    
}


@end
