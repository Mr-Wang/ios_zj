//
//  WY_CloudSignatureOrderInfoViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/15.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_CloudSignatureOrderInfoViewController.h"
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
#import "WY_CAHandleViewController.h"
#import "WY_CAMakeUpViewController.h"
#import "MS_WKwebviewsViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WY_UpdateCloudSignViewController.h"
#import "STRIAPManager.h"

@interface WY_CloudSignatureOrderInfoViewController ()
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
@property (nonatomic , strong) WY_AddressManageModel * selAddress;

@property (nonatomic , strong) UIView *viewSel3Yj;
@property (nonatomic , strong) UIView *viewSel4Lq;
//@property (nonatomic , strong) UIView *viewSel5PayType;

@property (nonatomic , strong) UIView *viewSingInfo;

@property (nonatomic , strong) UIView *viewSel6Fp;
@property (nonatomic , strong) UIView *viewSel6NotFp;

@property (nonatomic , strong) UILabel *lblMoneySum;
//证书名称
@property (nonatomic , strong) UILabel *lblT3;
//金额、有效期
@property (nonatomic , strong) UILabel *lblT4;
//@property (nonatomic , strong) UISwitch * switchFP;
@property (nonatomic , strong) NSMutableDictionary *dicPostCAInfo;
@property (nonatomic ,strong) UIButton *btnRePay;
@property (nonatomic ,strong) UIButton *btnDel;
@property (nonatomic ,strong) UIButton *btnEdit;
//@property (nonatomic ,strong) UIButton *btnShouHuo;
//@property (nonatomic ,strong) UIButton *btnYanQi;

@property (nonatomic , strong) NSString *payType;//03是微信、02是支付宝、009 是苹果支付
@property (nonatomic , strong) NSString *isIAPPay;
@property (nonatomic, strong) STRIAPManager *IAPManager;

@end

@implementation WY_CloudSignatureOrderInfoViewController
@synthesize viewSel3Yj,viewSel4Lq,viewSingInfo,viewSel6Fp,viewSel6NotFp;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    
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
    
//    self.isIAPPay = @"1";
    
    [self makeUI];
    [self dataSource];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chenggong) name:@"chenggong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatechenggong) name:@"updatechenggong" object:nil];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"白返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
    self.navigationItem.leftBarButtonItem = right;
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    
    
}
- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
}


- (void)initMiddleView {
    [self.mScrollView removeAllSubviews];
    
    //    UIView *viewBottom = [UIView new];
    //    [viewBottom setFrame:CGRectMake(0, self.mScrollView.bottom, kScreenWidth, k360Width(50))];
    //    [viewBottom setBackgroundColor:[UIColor whiteColor]];
    //    [self.view addSubview:viewBottom];
    //    self.lblMoneySum = [UILabel new];
    //    [self.lblMoneySum setFrame:CGRectMake(k360Width(16), 0, k360Width(150), k360Width(50))];
    //
    //
    //    [viewBottom addSubview:self.lblMoneySum];
    //
    //    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k375Width(78+16), k360Width(5), k375Width(78), k360Width(40))];
    //    [self.btnSubmit setTitle:@"付款" forState:UIControlStateNormal];
    //    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    //    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    //    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.btnSubmit rounded:k360Width(44)/8];
    //    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    //    [viewBottom addSubview:self.btnSubmit];
    
    UIView *viewSel1 = [UIView new];
    //    UIView *viewSel2 = [UIView new];
    self.viewSel3Yj = [UIView new];
    self.viewSel4Lq = [UIView new];
    //    self.viewSel5PayType = [UIView new];
    self.viewSingInfo = [UIView new];
    self.viewSel6Fp = [UIView new];
    self.viewSel6NotFp = [UIView new];
    
    UILabel *lblT2 = [UILabel new];
    self.lblT3 = [UILabel new];
    self.lblT4 = [UILabel new];
    UILabel *lblGLPTA = [UILabel new];
    UILabel *lblGLPTB = [UILabel new];
    
    [viewSel1 setFrame:CGRectMake(0, k375Width(5), kScreenWidth, k375Width(150))];
    [viewSel1 setBackgroundColor:[UIColor whiteColor]];
    
    [lblT2 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblT2 setText:@"订单信息"];
    [lblT2 setTextColor:HEXCOLOR(0x666666)];
    [lblT2 setFont:WY_FONT375Medium(14)];
    [viewSel1 addSubview:lblT2];
    
    [self.lblT3 setFrame:CGRectMake(k375Width(16),lblT2.bottom + k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [self.lblT3 setTextColor:[UIColor blackColor]];
    [self.lblT3 setFont:WY_FONT375Medium(16)];
    [viewSel1 addSubview:self.lblT3];
    
    UIImageView *imgukey = [UIImageView new];
    [imgukey setFrame:CGRectMake(viewSel1.width - k360Width(55+16), lblT2.top, k360Width(55), k360Width(55))];
    [imgukey setImage:[UIImage imageNamed:@"0420_cloudsign_sel"]];
    [viewSel1 addSubview:imgukey];
    
    float btomY = self.lblT3.bottom + k375Width(5);
    if ([self.dicPostCAInfo[@"orderNo"] isNotBlank]) {
        [lblGLPTA setFrame:CGRectMake(k375Width(16), self.lblT3.bottom + k375Width(5), k375Width(80), k375Width(22))];
        [lblGLPTA setText:@"订单编号："];
        [lblGLPTA setTextColor:HEXCOLOR(0x666666)];
        [lblGLPTA setFont:WY_FONT375Medium(14)];
        [viewSel1 addSubview:lblGLPTA];
        
        [lblGLPTB setFrame:CGRectMake(lblGLPTA.right- k360Width(10), lblGLPTA.top, kScreenWidth - lblGLPTA.right , k360Width(44))];
        [lblGLPTB setText:self.dicPostCAInfo[@"orderNo"]];
        //    [lblGLPTB setText:@"辽宁建设工程信息网、辽宁政府采购网、朝阳市公共资源交易平台"];
        [lblGLPTB setTextColor:HEXCOLOR(0x666666)];
        [lblGLPTB setFont:WY_FONT375Medium(14)];
        [lblGLPTB setNumberOfLines:0];
        [lblGLPTB sizeToFit];
        lblGLPTB.height += k360Width(10);
        
        lblGLPTA.centerY = lblGLPTB.centerY;
        [viewSel1 addSubview:lblGLPTB];
        btomY = lblGLPTB.bottom;
    }
    
    
    
    [self.lblT4 setFrame:CGRectMake(k375Width(16), btomY, kScreenWidth - k375Width(32), k375Width(44))];
    [self.lblT4 setNumberOfLines:0];
    [self.lblT4 setTextColor:HEXCOLOR(0x666666)];
    [self.lblT4 setFont:WY_FONT375Medium(14)];
    
    [viewSel1 addSubview:self.lblT4];
    
    
    [self.lblT3 setText:self.dicPostCAInfo[@"productDescription"]];
    NSString *yxqStr =  yxqStr = [NSString stringWithFormat:@"有 效 期 ：自数字证书(CA)制作之日起%@内有效",self.dicPostCAInfo[@"validityPeriod"]];
    
    
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金      额：%.2f元\n%@\n订单日期：%@\n订单状态：",[self.dicPostCAInfo[@"totalPrice"] floatValue],yxqStr,self.dicPostCAInfo[@"createTime"]]];
    
    
    NSString *statusTitle = @"";
    UIColor *statusColor = HEXCOLOR(0xEA0000);
    //status  0待审核 、1 审核通过、2 审核未通过、
    //    orderStatus  1待支付 、2已支付、3 已发货 4 已领取
    
    switch ([self.dicPostCAInfo[@"orderStatus"] intValue]) {
        case 1:
        {
            statusTitle = @"待支付";
            statusColor = HEXCOLOR(0xEA0000);
            
        }
            break;
        case 2:
        {
            // 1待支付 、2（邮寄-待发货）（领取-待领取）、3 已发货 4 已领取
            statusTitle = @"已支付";
            statusColor = HEXCOLOR(0x666666);
        }
            break;
        case 3:
        {
            // 如果是邮寄 - 显示已发货、
            statusTitle = @"已发货";
            statusColor = HEXCOLOR(0x06C06F);
            
        }
            break;
        case 4:
        {
            //如果是领取- 显示已领取
            statusTitle = @"已领取";
            statusColor = HEXCOLOR(0x06C06F);
            
        }
            break;
        case 5:
        {
            statusTitle = @"已取消";
            statusColor = HEXCOLOR(0x1F1F24);
            
        }
            break;
        default:
            break;
    }
    
    NSMutableAttributedString *attC2Str = [[NSMutableAttributedString alloc] initWithString:statusTitle];
    [attC2Str setYy_color:statusColor];
    
    NSMutableAttributedString *attC3Str = [[NSMutableAttributedString alloc] initWithString:@"\n审核状态："];
    NSString *statusSHTitle = @"";
    UIColor *statusSHColor = HEXCOLOR(0xEA0000);
    //status  0待审核 、1 审核通过、2 审核未通过、
    switch ([self.dicPostCAInfo[@"status"] intValue]) {
        case 0:
        {
            statusSHTitle = @"待审核";
            statusSHColor = HEXCOLOR(0xff9600);
        }
            break;
        case 1:
        {
            statusSHTitle = @"审核通过";
            statusSHColor = HEXCOLOR(0x06C06F);
        }
            break;
        case 2:
        {
            statusSHTitle = @"审核未通过";
            statusSHColor = HEXCOLOR(0xEA0000);
            
        }
            break;
            
        default:
            break;
    }
    
    
    NSMutableAttributedString *attC4Str = [[NSMutableAttributedString alloc] initWithString:statusSHTitle];
    //判断状态颜色；
    [attC4Str setYy_color:statusSHColor];
    
    NSMutableAttributedString *attC4AStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n退回原因：%@",self.dicPostCAInfo[@"reason"]]];
    if ([self.dicPostCAInfo[@"status"] intValue] == 2) {
        [attC4Str appendAttributedString:attC4AStr];
    }
    
    NSMutableAttributedString *attC2AStr = [[NSMutableAttributedString alloc] initWithString:@"\n*数字证书(CA)审核自支付成功之日起24小时内审核，请随时关注数字证书(CA)审核状态。审核状态为待审核或审核未通过状态无法制作证书且不能领取。"];
    [attC2AStr setYy_color:[UIColor redColor]];
    
    
    [moneyStr appendAttributedString:attC2Str];
    //    if ([self.dicPostCAInfo[@"orderStatus"] intValue] != 1) {
    //        [moneyStr appendAttributedString:attC3Str];
    //        [moneyStr appendAttributedString:attC4Str];
    //        [moneyStr appendAttributedString:attC2AStr];
    //    }
    
    [moneyStr setYy_lineSpacing:5];
    [self.lblT4 setAttributedText:moneyStr];
    [self.lblT4 sizeToFit];
    self.lblT4.height += k360Width(12);
    
    
    self.btnRePay = [UIButton new];
    //判断是否显示按钮
    [self.btnRePay setFrame:CGRectMake(k360Width(359), self.lblT4.bottom + k360Width(5), k360Width(85), k360Width(30))];
    [self.btnRePay rounded:k360Width(30/4)];
    [self.btnRePay setBackgroundColor:MSTHEMEColor];
    [self.btnRePay.titleLabel setFont:WY_FONTRegular(12)];
    [self.btnRePay setHidden:NO];
    [viewSel1 addSubview:self.btnRePay];
    
    self.btnDel = [UIButton new];
    //判断是否显示按钮
    [self.btnDel setFrame:CGRectMake(k360Width(359-95 - 95), self.lblT4.bottom + k360Width(5), k360Width(85), k360Width(30))];
    [self.btnDel rounded:k360Width(30/4)];
    [self.btnDel setBackgroundColor:MSTHEMEColor];
    [self.btnDel.titleLabel setFont:WY_FONTRegular(12)];
    [self.btnDel setHidden:YES];
    [viewSel1 addSubview:self.btnDel];
    
    self.btnEdit = [UIButton new];
    //判断是否显示按钮
    [self.btnEdit setFrame:CGRectMake(k360Width(264-95 - 95), self.lblT4.bottom + k360Width(5), k360Width(85), k360Width(30))];
    [self.btnEdit rounded:k360Width(30/4)];
    [self.btnEdit setBackgroundColor:MSTHEMEColor];
    [self.btnEdit.titleLabel setFont:WY_FONTRegular(12)];
    [self.btnEdit setHidden:YES];
    [viewSel1 addSubview:self.btnEdit];
    //
# warning 注释打开可用
    if ([self.dicPostCAInfo[@"orderStatus"] intValue] == 1 && ![self.dicPostCAInfo[@"signCertificateSerial"] isNotBlank]) {
        
        [self.btnDel setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.btnDel setBackgroundColor:[UIColor whiteColor]];
        [self.btnDel setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [self.btnDel rounded:k360Width(30/4) width:k360Width(1) color:HEXCOLOR(0x9f9f9f)];
        
        [self.btnDel setHidden:NO];
        
        //        [self.btnEdit setTitle:@"修改签名" forState:UIControlStateNormal];
        //        [self.btnEdit setHidden:NO];
        self.btnRePay.left = self.btnDel.right + k360Width(10);
        //        self.btnEdit.left = self.btnDel.right + k360Width(10);
        
        [self.btnDel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            NSLog(@"点击了取消订单按钮");
            UIAlertController *alertA = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否取消订单" preferredStyle:UIAlertControllerStyleAlert];
            [alertA addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary *postDic = [NSMutableDictionary new];
                [postDic setObject:self.dicPostCAInfo[@"orderNo"] forKey:@"orderNo"];
                [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_cancelCloudSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                    if (([code integerValue] == 0) && res) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [self.view makeToast:res[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [self.view makeToast:@"请求失败，请稍后再试"];
                }];
                
            }]];
            [alertA addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertA animated:YES completion:nil];
            
        }];
        //修改订单
        //        [self.btnEdit addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //            //申请
        //            NSString *alertStr = @"是否重新填写证书信息";
        //            //补办  -
        //            if ([self.dicPostCAInfo[@"handleType"] intValue] == 2) {
        //                alertStr = @"是否重新填写证书补办申请";
        //            }
        //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        //            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //                NSLog(@"确定");
        //
        //                if ([self.dicPostCAInfo[@"handleType"] intValue] == 2) {
        //                    WY_CAMakeUpViewController *tempController = [WY_CAMakeUpViewController new];
        //                    tempController.isEdit = @"1";
        //                    tempController.dicEditInfo = self.dicPostCAInfo;
        //                    [self.navigationController pushViewController:tempController animated:YES];
        //                } else {
        //                    WY_CAHandleViewController *tempController = [WY_CAHandleViewController new];
        //                    tempController.isEdit = @"1";
        //                    tempController.dicEditInfo = self.dicPostCAInfo;
        //                    [self.navigationController pushViewController:tempController animated:YES];
        //
        //                }
        //            }]];
        //            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        //
        //            [self presentViewController:alert animated:YES completion:nil];
        //
        //        }];
        
        //待支付
        [self.btnRePay setTitle:@"去支付" forState:UIControlStateNormal];
        [self.btnRePay setBackgroundColor:HEXCOLOR(0x63ce90)];
        viewSel1.height = self.btnRePay.bottom + k360Width(10);
        [self.btnRePay addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否现在去支付" preferredStyle:UIAlertControllerStyleAlert];
            if ([self.isIAPPay isEqualToString:@"1"]) {
                [alert addAction:[UIAlertAction actionWithTitle:@"AppStore支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确定");
                    self.payType = @"009";
                    WY_PayNeedModel *tempPayModel = [WY_PayNeedModel new];
                    tempPayModel.orderGuid = self.dicPostCAInfo[@"orderGuid"];
                     tempPayModel.paymethod = self.payType;
                    tempPayModel.body = self.dicPostCAInfo[@"productDescription"];
                    tempPayModel.userGuid =  self.mUser.UserGuid;
                    tempPayModel.out_trade_no = self.dicPostCAInfo[@"orderNo"];
                    [self iapNeedPay:tempPayModel];
                }]];
            } else {
                [alert addAction:[UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确定");
                    self.payType = @"03";
                    [self weiXinPay];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确定");
                    self.payType = @"02";
                    [self weiXinPay];
                }]];
            }
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
        [self.btnRePay setHidden:NO];
    } else {
        //2023-12-14 10:04:11 - 修改签名功能隐藏- 罗欣桐说的 start
        [self.btnEdit setHidden:YES];
        viewSel1.height = self.btnEdit.top;
        [self.btnRePay setHidden:YES];
        //2023-12-14 10:04:11 - 修改签名功能隐藏- 罗欣桐说的 end
        
//        [self.btnEdit setTitle:@"修改签名" forState:UIControlStateNormal];
//        [self.btnEdit setHidden:NO];
//        self.btnEdit.left = self.btnDel.right + k360Width(10);
//        [self.btnEdit addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            NSLog(@"点击了修改签名按钮");
//            WY_UpdateCloudSignViewController *tempController = [WY_UpdateCloudSignViewController new];
//            tempController.dicEditInfo = self.dicPostCAInfo;
//            [self.navigationController pushViewController:tempController animated:YES];
//        }];
//        viewSel1.height = self.btnEdit.bottom + k360Width(10);
//        [self.btnRePay setHidden:YES];
    }
    
    //    if ([self.dicPostCAInfo[@"islingqu"] intValue] == 1) {
    //        //        lqfsStr = @"领取";
    //        [viewSel4Lq setFrame:CGRectMake(0, viewSel1.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    //        [viewSel4Lq setBackgroundColor:[UIColor whiteColor]];
    //
    //        UILabel *lblTLq1 = [UILabel new];
    //        [lblTLq1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    //        [lblTLq1 setText:@"领取："];
    //        [lblTLq1 setTextColor:HEXCOLOR(0x666666)];
    //        [lblTLq1 setFont:WY_FONT375Medium(14)];
    //        [viewSel4Lq addSubview:lblTLq1];
    //        UILabel *lblTLqBZ = [UILabel new];
    //        UILabel *lblTLqName = [UILabel new];
    //        UILabel *lblTLqPhone = [UILabel new];
    //        UILabel *lblTLqPhone1 = [UILabel new];
    //
    //        UIButton *btnLqPhone = [UIButton new];
    //        UILabel *lblTLqAddress = [UILabel new];
    //        UILabel *lblTLqAddress1 = [UILabel new];
    //        UILabel *lblTLqGs = [UILabel new];
    //
    //
    //
    //        [lblTLqBZ setFrame:CGRectMake(k375Width(16), lblTLq1.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(50))];
    //        [lblTLqBZ setNumberOfLines:0];
    //        [lblTLqBZ setText:self.dicPostCAInfo[@"lqbz"]];
    //        [lblTLqBZ setTextColor:[UIColor blackColor]];
    //        [lblTLqBZ setFont:WY_FONT375Medium(14)];
    //        [viewSel4Lq addSubview:lblTLqBZ];
    //        [lblTLqBZ sizeToFit];
    //        lblTLqBZ.height += k360Width(12);
    //
    //        [lblTLqGs setFrame:CGRectMake(k375Width(16), lblTLqBZ.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(22))];
    //        [lblTLqGs setText:[NSString stringWithFormat:@"联系单位：%@",self.dicPostCAInfo[@"lqdw"]]];
    //        [lblTLqGs setTextColor:HEXCOLOR(0x666666)];
    //        [lblTLqGs setFont:WY_FONT375Medium(14)];
    //
    //        [viewSel4Lq addSubview:lblTLqGs];
    //
    //
    //        [lblTLqAddress setFrame:CGRectMake(k375Width(16), lblTLqGs.bottom + k375Width(5), k375Width(80), k375Width(22))];
    //        [lblTLqAddress setText:@"领取地址："];
    //        [lblTLqAddress setTextColor:HEXCOLOR(0x666666)];
    //        [lblTLqAddress setFont:WY_FONT375Medium(14)];
    //        [viewSel4Lq addSubview:lblTLqAddress];
    //
    //
    //        [lblTLqAddress1 setFrame:CGRectMake(lblTLqAddress.right- k360Width(10), lblTLqAddress.top, kScreenWidth - lblTLqAddress.right + k360Width(10), k360Width(44))];
    //        [lblTLqAddress1 setTextColor:HEXCOLOR(0x666666)];
    //
    //        [lblTLqAddress1 setText:self.dicPostCAInfo[@"lqdz"]];
    //        [lblTLqAddress1 setNumberOfLines:0];
    //        [lblTLqAddress1 sizeToFit];
    //        lblTLqAddress1.height += k360Width(12);
    //        [lblTLqAddress1 setFont:WY_FONT375Medium(14)];
    //
    //        lblTLqAddress.centerY = lblTLqAddress1.centerY;
    //        [viewSel4Lq addSubview:lblTLqAddress1];
    //
    //
    //        UIButton *btnCopyKDDH = [UIButton new];
    //        [btnCopyKDDH setFrame:CGRectMake(kScreenWidth - k360Width(45+16), lblTLqAddress1.top + k360Width(20), k360Width(45), k360Width(23))];
    //        [btnCopyKDDH rounded:k360Width(23/4)];
    //        [btnCopyKDDH setBackgroundColor:HEXCOLOR(0xDCEBFE)];
    //        [btnCopyKDDH setTitleColor:HEXCOLOR(0x448EEE) forState:UIControlStateNormal];
    //        [btnCopyKDDH.titleLabel setFont:WY_FONTRegular(12)];
    //        [btnCopyKDDH setTitle:@"复制" forState:UIControlStateNormal];
    ////        btnCopyKDDH.centerY = lblTLqAddress1.centerY;
    //        [viewSel4Lq addSubview:btnCopyKDDH];
    //
    //        [btnCopyKDDH addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
    //            NSLog(@"复制 领取地址");
    //            [GlobalConfig paste:self.dicPostCAInfo[@"lqdz"]];
    //            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    //        }];
    //
    //
    //
    //        [lblTLqName setFrame:CGRectMake(k375Width(16), lblTLqAddress1.bottom + k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    //        [lblTLqName setText:[NSString stringWithFormat:@"联 系 人 ：%@",self.dicPostCAInfo[@"lqlxr"]]];
    //        [lblTLqName setTextColor:HEXCOLOR(0x666666)];
    //        [lblTLqName setFont:WY_FONT375Medium(14)];
    //        [viewSel4Lq addSubview:lblTLqName];
    //
    //        [lblTLqPhone setFrame:CGRectMake(k375Width(16), lblTLqName.bottom + k375Width(5), k375Width(80), k375Width(22))];
    //        [lblTLqPhone setText:@"联系电话："];
    //        [lblTLqPhone setTextColor:HEXCOLOR(0x666666)];
    //        [lblTLqPhone setFont:WY_FONT375Medium(14)];
    //        [viewSel4Lq addSubview:lblTLqPhone];
    //
    //        NSMutableArray *lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicPostCAInfo[@"lqdh"] componentsSeparatedByString:@"，"]];
    //        NSString *lqdhsStr = [lqdhs componentsJoinedByString:@"\n"];
    //
    //        [lblTLqPhone1 setFrame:CGRectMake(lblTLqPhone.right - k360Width(10), lblTLqPhone.top, kScreenWidth - lblTLqPhone.right - k360Width(52), k360Width(44))];
    //        [lblTLqPhone1 setTextColor:HEXCOLOR(0x666666)];
    //        [lblTLqPhone1 setText:lqdhsStr];
    //        [lblTLqPhone1 setFont:WY_FONT375Medium(14)];
    //        [lblTLqPhone1 setNumberOfLines:0];
    //        [lblTLqPhone1 sizeToFit];
    //        lblTLqPhone1.height += k360Width(12);
    //        lblTLqPhone.centerY = lblTLqPhone1.centerY;
    //        [viewSel4Lq addSubview:lblTLqPhone1];
    //
    //
    //
    //        [btnLqPhone setFrame:CGRectMake(kScreenWidth - k360Width(22+16), lblTLqPhone.top + k375Width(10), k375Width(22), k375Width(22))];
    //        [btnLqPhone setImage:[UIImage imageNamed:@"0317phone"] forState:UIControlStateNormal];
    //        [btnLqPhone setCenterY:lblTLqPhone.centerY];
    //        [viewSel4Lq addSubview:btnLqPhone];
    //
    //        [btnLqPhone setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
    //
    //            NSMutableArray *lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicPostCAInfo[@"lqdh"] componentsSeparatedByString:@"，"]];
    //
    //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拨打联系电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //            for (NSString *phoneNum in lqdhs) {
    //                [alertController addAction:[UIAlertAction actionWithTitle:phoneNum style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                    [GlobalConfig makeCall:phoneNum];
    //                }]];
    //            }
    //            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //            }]];
    //            [self presentViewController:alertController animated:YES completion:nil];
    //
    //        }];
    //
    //# warning 注释打开可用
    //        //        2021-03-22 15:33:03（需求确认修改、删除掉确认收货按钮）
    //        //        //审核通过 - 如果是领取 - 并且是已发货状态 - 显示确认收货按钮；
    //        //        if ([self.dicPostCAInfo[@"status"] intValue] == 1 && [self.dicPostCAInfo[@"orderStatus"] intValue] == 3) {
    //        //            self.btnShouHuo = [UIButton new];
    //        //            //判断是否显示按钮
    //        //            [self.btnShouHuo setFrame:CGRectMake(k360Width(264), lblTLqPhone.bottom + k360Width(5), k360Width(85), k360Width(30))];
    //        //            [self.btnShouHuo rounded:k360Width(30/4)];
    //        //            [self.btnShouHuo setBackgroundColor:MSTHEMEColor];
    //        //            [self.btnShouHuo.titleLabel setFont:WY_FONTRegular(12)];
    //        //            [self.btnShouHuo setTitle:@"确认收货" forState:UIControlStateNormal];
    //        //            [self.btnShouHuo setHidden:NO];
    //        //            [viewSel4Lq addSubview:self.btnShouHuo];
    //        //            viewSel4Lq.height = self.btnShouHuo.bottom + k360Width(20);
    //        //        [self.btnShouHuo addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
    //        //            NSLog(@"点击了收货按钮");
    //        //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
    //        //            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        //                NSLog(@"确定");
    //        //                NSMutableDictionary *postDic = [NSMutableDictionary new];
    //        //                [postDic setObject:self.orderID forKey:@"orderNo"];
    //        //                [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_CAreceipt_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
    //        //                    if (([code integerValue] == 0) && res) {
    //        //                         [self dataSource];
    //        //                     } else {
    //        //                        [self.view makeToast:res[@"msg"]];
    //        //                    }
    //        //                } failure:^(NSError *error) {
    //        //                    [self.view makeToast:@"请求失败，请稍后再试"];
    //        //                }];
    //        //             }]];
    //        //            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //        //
    //        //            [self presentViewController:alert animated:YES completion:nil];
    //        //
    //        //        }];
    //        //        } else {
    //        viewSel4Lq.height = lblTLqPhone.bottom + k360Width(20);
    //        //        }
    //
    //        //发票信息
    //        [viewSel6Fp setFrame:CGRectMake(0, viewSel4Lq.bottom + k375Width(5), kScreenWidth, k375Width(44))];
    //
    //        [viewSel6NotFp setFrame:CGRectMake(0, viewSel4Lq.bottom + k375Width(5), kScreenWidth, k375Width(44))];
    //
    //
    //    } else {
    //        [viewSel3Yj setFrame:CGRectMake(0, viewSel1.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    //        [viewSel3Yj setBackgroundColor:[UIColor whiteColor]];
    //
    //
    //        UILabel *lblTYj1 = [UILabel new];
    //        [lblTYj1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    //        [lblTYj1 setText:@"收货信息"];
    //        [lblTYj1 setTextColor:HEXCOLOR(0x666666)];
    //        [lblTYj1 setFont:WY_FONT375Medium(14)];
    //        [viewSel3Yj addSubview:lblTYj1];
    //        UIControl *colAddressSel = [UIControl new];
    //        [colAddressSel setFrame:CGRectMake(0, lblTYj1.bottom + k360Width(5), kScreenWidth, viewSel3Yj.height - lblTYj1.bottom)];
    //        [viewSel3Yj addSubview:colAddressSel];
    //        //    [colAddressSel setBackgroundColor:[UIColor yellowColor]];
    //        self.lblAddressSel = [UILabel new];
    //        [self.lblAddressSel setFrame:CGRectMake(k375Width(16), 0, kScreenWidth - k375Width(32), colAddressSel.height)];
    //        [self.lblAddressSel setTextColor:HEXCOLOR(0x666666)];
    //        [self.lblAddressSel setFont:WY_FONT375Medium(14)];
    //
    //        [self.lblAddressSel setNumberOfLines:0];
    //        //    [self.lblAddressSel setText:@"请选择收货地址"];
    //
    //        [self.lblAddressSel setTextColor:[UIColor blackColor]];
    //        NSMutableAttributedString *straddress = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收货方式：邮寄（顺丰寄付）\n收 件 人 ：%@   \n收货电话：%@\n收货地址：%@",self.dicPostCAInfo[@"shrxm"],self.dicPostCAInfo[@"shrdh"],self.dicPostCAInfo[@"shrdz"]]];
    //
    //        [self.lblAddressSel setTextColor:HEXCOLOR(0x666666)];
    //
    //        [colAddressSel addSubview:self.lblAddressSel];
    //
    //# warning 注释打开可用
    //        //判断 已发货 后 才有 快递单号；
    //        if ([self.dicPostCAInfo[@"orderStatus"] intValue]== 3) {
    //            NSMutableAttributedString *straddress1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n快递名称：%@\n快递单号：%@",self.dicPostCAInfo[@"kdmc"],self.dicPostCAInfo[@"kddh"]]];
    //            [straddress appendAttributedString:straddress1];
    //        }
    //        [straddress setYy_lineSpacing:5];
    //        [self.lblAddressSel setAttributedText:straddress];
    //        [self.lblAddressSel sizeToFit];
    //        self.lblAddressSel.height += k360Width(10);
    //
    //        colAddressSel.height = self.lblAddressSel.bottom;
    //
    //        if ([self.dicPostCAInfo[@"orderStatus"] intValue]== 3) {
    //            UIButton *btnCopyKDDH = [UIButton new];
    //            [btnCopyKDDH setFrame:CGRectMake(kScreenWidth - k360Width(45+16), self.lblAddressSel.bottom - k360Width(28), k360Width(45), k360Width(23))];
    //            [btnCopyKDDH rounded:k360Width(23/4)];
    //            [btnCopyKDDH setBackgroundColor:HEXCOLOR(0xDCEBFE)];
    //            [btnCopyKDDH setTitleColor:HEXCOLOR(0x448EEE) forState:UIControlStateNormal];
    //            [btnCopyKDDH.titleLabel setFont:WY_FONTRegular(12)];
    //            [btnCopyKDDH setTitle:@"复制" forState:UIControlStateNormal];
    //            [colAddressSel addSubview:btnCopyKDDH];
    //
    //            [btnCopyKDDH addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
    //                NSLog(@"复制 快递单号");
    //                [GlobalConfig paste:self.dicPostCAInfo[@"kddh"]];
    //                [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    //            }];
    //        }
    //
    //        viewSel3Yj.height = colAddressSel.bottom + k360Width(5);
    //
    //        //支付方式
    //        [viewSel6Fp setFrame:CGRectMake(0, viewSel3Yj.bottom + k375Width(5), kScreenWidth, k375Width(44))];
    //
    //        [viewSel6NotFp setFrame:CGRectMake(0, viewSel3Yj.bottom + k375Width(5), kScreenWidth, k375Width(44))];
    //
    //
    //    }
    
    
    [viewSingInfo setFrame:CGRectMake(0, viewSel1.bottom + k375Width(5), kScreenWidth, k375Width(44))];
    [viewSingInfo setBackgroundColor:[UIColor whiteColor]];
    //如果已支付-显示证书信息
    if ([self.dicPostCAInfo[@"orderStatus"] intValue] == 2) {
        [viewSingInfo setHidden:NO];
        
        UILabel *lblSingInfo = [UILabel new];
        [lblSingInfo setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(32), k375Width(22))];
        [lblSingInfo setTextColor:HEXCOLOR(0x666666)];
        [lblSingInfo setFont:WY_FONT375Medium(14)];
        
        NSMutableAttributedString *attSingInfo1 = [[NSMutableAttributedString alloc] initWithString:@"证书信息\n"];
        
        
        if ([self.dicPostCAInfo[@"signCertificateSerial"] isNotBlank] && ![self.dicPostCAInfo[@"signCertificateSerial"] isEqual:[NSNull null]]) {
            NSString *caStatus = @"已生效";
            
            NSMutableAttributedString *yxqStr = [[NSMutableAttributedString alloc] init];
            if ([self.dicPostCAInfo[@"expireDate"] isEqual:[NSNull null]]) {
                [yxqStr yy_appendString:@"无到期时间"];
                caStatus = @"无到期时间";
            } else {
                NSDate *dateYxq = [NSDate dateWithString:self.dicPostCAInfo[@"expireDate"] format:@"yyyy-MM-dd HH:mm:ss" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                
                NSDate*dateB = [NSDate date];
                
                NSComparisonResult result = [dateB compare:dateYxq];
                
                if (result == NSOrderedDescending) {
                    caStatus = @"已过期";
                    [yxqStr yy_appendString:[NSString stringWithFormat:@"%@(已过期)",self.dicPostCAInfo[@"expireDate"]]];
                    [yxqStr setYy_color:[UIColor redColor]];
                }
                else if(result ==NSOrderedAscending){
                    
                    //没过指定时间 没过期
                    [yxqStr yy_appendString:self.dicPostCAInfo[@"expireDate"]];
                } else {
                    [yxqStr yy_appendString:self.dicPostCAInfo[@"expireDate"]];
                }
            }
            
            NSMutableAttributedString *attSingInfo2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"证书序号：%@\n证书状态：%@\n证书厂商：%@\n有效期至：",self.dicPostCAInfo[@"signCertificateSerial"] ,caStatus,self.dicPostCAInfo[@"manufacturer"]]];
            [attSingInfo2 appendAttributedString:yxqStr];
            [attSingInfo1 appendAttributedString:attSingInfo2];
            
            
        } else {
            NSString *yxqStr = [NSString stringWithFormat:@"有 效 期 ：自数字证书(CA)制作之日起%@内有效",self.dicPostCAInfo[@"validityPeriod"]];
            
            NSMutableAttributedString *attSingInfo2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"证书序号：%@\n证书状态：未生效\n证书厂商：%@\n%@",@"暂无",self.dicPostCAInfo[@"manufacturer"],yxqStr]];
            [attSingInfo1 appendAttributedString:attSingInfo2];
        }
        [attSingInfo1 setYy_lineSpacing:5];
        [lblSingInfo setAttributedText:attSingInfo1];
        [viewSingInfo addSubview:lblSingInfo];
        [lblSingInfo setNumberOfLines:0];
        [lblSingInfo sizeToFit];
        lblSingInfo.height += k360Width(10);
        viewSingInfo.height = lblSingInfo.bottom + k360Width(16);
        
    } else {
        [viewSingInfo setHidden:YES];
        viewSingInfo.height = 0;
    }
    
    //发票信息
    [viewSel6Fp setFrame:CGRectMake(0, viewSingInfo.bottom + k375Width(5), kScreenWidth, k375Width(44))];
    
    [viewSel6NotFp setFrame:CGRectMake(0, viewSingInfo.bottom + k375Width(5), kScreenWidth, k375Width(44))];
    
    [viewSel6Fp setBackgroundColor:[UIColor whiteColor]];
    [viewSel6NotFp setBackgroundColor:[UIColor whiteColor]];
    
    
    
    UILabel *lblTFp1 = [UILabel new];
    [lblTFp1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTFp1 setText:@"发票信息"];
    [lblTFp1 setTextColor:HEXCOLOR(0x666666)];
    [lblTFp1 setFont:WY_FONT375Medium(14)];
    [viewSel6Fp addSubview:lblTFp1];
    
    UILabel *lblNotTFp1 = [UILabel new];
    [lblNotTFp1 setFrame:CGRectMake(k375Width(16), 0, kScreenWidth - k375Width(10), k375Width(44))];
    [lblNotTFp1 setText:@"是否开具发票：否"];
    [lblNotTFp1 setTextColor:HEXCOLOR(0x666666)];
    [lblNotTFp1 setFont:WY_FONT375Medium(14)];
    [viewSel6NotFp addSubview:lblNotTFp1];
    
    
    
    //电子发票图片
    UIImageView *imgDzfq = [UIImageView new];
    [imgDzfq setImage:[UIImage imageNamed:@"icon_dzfp"]];
    [imgDzfq setFrame:CGRectMake(kScreenWidth - k360Width(48+16), lblTFp1.bottom + k360Width(5), k360Width(48), k360Width(35))];
    [viewSel6Fp addSubview:imgDzfq];
    [imgDzfq setHidden:YES];
    
    UILabel *lblTFp2 = [UILabel new];
    [lblTFp2 setFrame:CGRectMake(k375Width(16), lblTFp1.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(22))];
    [lblTFp2 setTextColor:HEXCOLOR(0x666666)];
    [lblTFp2 setFont:WY_FONT375Medium(14)];
    
    NSString *fpztStr = @"未开票";
    if  (self.dicPostCAInfo[@"invoiceUrl"] != nil && ![self.dicPostCAInfo[@"invoiceUrl"] isEqual:[NSNull null]] && ![self.dicPostCAInfo[@"invoiceUrl"] isEqualToString:@""]) {
        fpztStr = @"已开票";
        [imgDzfq setHidden:NO];
    }
    NSMutableAttributedString *attFpStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"发票抬头：%@\n发票金额：%.2f元\n开票状态：%@",self.dicPostCAInfo[@"userName"],[self.dicPostCAInfo[@"totalPrice"] floatValue],fpztStr]];
    
    NSMutableAttributedString *attFpStr2 = [[NSMutableAttributedString alloc] initWithString:@"\n*云签章证书生成后24小时自动开具发票，开具后在此处下载"];
    [attFpStr2 setYy_color:APPRedColor];
    [attFpStr1 appendAttributedString:attFpStr2];
    [attFpStr1 setYy_lineSpacing:5];
    
    [lblTFp2 setAttributedText:attFpStr1];
    [viewSel6Fp addSubview:lblTFp2];
    [lblTFp2 setNumberOfLines:0];
    [lblTFp2 sizeToFit];
    lblTFp2.height += k360Width(10);
# warning 注释打开可用
    
    if  (self.dicPostCAInfo[@"invoiceUrl"] != nil && ![self.dicPostCAInfo[@"invoiceUrl"] isEqual:[NSNull null]] && ![self.dicPostCAInfo[@"invoiceUrl"] isEqualToString:@""]) {
        UIButton *btnFpShow = [UIButton new];
        [btnFpShow setFrame:CGRectMake(k360Width(264), lblTFp2.bottom + k360Width(5), k360Width(85), k360Width(30))];
        [btnFpShow rounded:k360Width(30/4)];
        [btnFpShow setBackgroundColor:MSTHEMEColor];
        [btnFpShow.titleLabel setFont:WY_FONTRegular(12)];
        [btnFpShow setTitle:@"查看发票" forState:UIControlStateNormal];
        [btnFpShow addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.dicPostCAInfo[@"invoiceUrl"]] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString:self.dicPostCAInfo[@"invoiceUrl"]]];
            }
            
        }];
        [viewSel6Fp addSubview:btnFpShow];
        viewSel6Fp.height = btnFpShow.bottom + k360Width(16);
    } else {
        viewSel6Fp.height = lblTFp2.bottom + k360Width(16);
    }
    
    [self.mScrollView addSubview:viewSel1];
    [self.mScrollView addSubview:viewSel3Yj];
    [self.mScrollView addSubview:viewSel4Lq];
    [self.mScrollView addSubview:viewSingInfo];
    [self.mScrollView addSubview:viewSel6Fp];
    [self.mScrollView addSubview:viewSel6NotFp];
    
    
    
    //是否开发票字段 =  没申请开发票 不显示发票模块
    if ([self.dicPostCAInfo[@"invoice"] floatValue] == 1) {
        [viewSel6Fp setHidden:NO];
        [viewSel6NotFp setHidden:YES];
        [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
    } else {
        [viewSel6Fp setHidden:YES];
        [viewSel6NotFp setHidden:NO];
        [self.mScrollView setContentSize:CGSizeMake(0, viewSel6NotFp.bottom + k375Width(16)) ];
    }
}
- (void)dataSource {
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.orderID forKey:@"orderNo"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getCloudSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            self.dicPostCAInfo = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
            [self bindView];
        } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
}
- (void)bindView {
    
    [self initMiddleView];
}
- (void)btnUpAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnSubmitAction {
    NSLog(@"点击了提交订单");
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)weiXinPay {
    [self tongLianPay];
    return;
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    NSLog(@"确认支付");
    WY_PayNeedModel *tempPayModel = [WY_PayNeedModel new];
    tempPayModel.orderGuid = self.dicPostCAInfo[@"orderGuid"];
    //       tempPayModel.cost = self.mWY_SendEnrolmentMessageModel.Amount;
    tempPayModel.paymethod = self.payType;
    tempPayModel.body = self.dicPostCAInfo[@"productDescription"];
    tempPayModel.userGuid =  self.mUser.UserGuid;
    tempPayModel.out_trade_no = self.dicPostCAInfo[@"orderNo"];
    
    //       tempPayModel.orderDetailBean = self.mWY_SendEnrolmentMessageModel.toJSONString;
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:onlinepay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if ([res[@"data"][@"responseString"] isEqual:[NSNull null]]) {
                [SVProgressHUD showErrorWithStatus:@"接口数据返回错误-请稍后再试"];
                //                     [btnGoInfo setEnabled:YES];
                
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
            tempPayModel.OrderGuid = self.dicPostCAInfo[@"orderNo"];
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
                //responseStringDic[@"sign"];
                //                 req.sign = responseStringDic[@"sign"];
                [WXApi sendReq:req completion:^(BOOL success) {
                    if (success) {
                        NSLog(@"成功");
                        
                    } else {
                        NSLog(@"失败");
                    }
                }];
            }else if ([self.payType isEqualToString:@"02"]) {
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
    tempPayModel.orderGuid = self.dicPostCAInfo[@"orderGuid"];
    tempPayModel.paymethod = self.payType;
    tempPayModel.body = self.dicPostCAInfo[@"productDescription"];
    tempPayModel.userGuid =  self.mUser.UserGuid;
    tempPayModel.out_trade_no = self.dicPostCAInfo[@"orderNo"];
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
- (void)updatechenggong {
    [self dataSource];
}
-(void)chenggong{
    //    [self dataSource];
    //   改成 返回上一页了 苹果系统待支付状态点击修改申请，可以返回界面修改，最后点击修改申请，点击确定，还在这个界面，能否直接跳至订单管理界面，直接看到审核状态是待审核。
    
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.dicPostCAInfo[@"orderNo"] forKey:@"orderNo"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getCloudSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            NSMutableDictionary *dicOrder = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
            if ([dicOrder[@"orderStatus"] intValue] == 2) {
                //已支付
                [self.navigationController popViewControllerAnimated:YES];
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
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
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

- (void)closeClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//苹果支付
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
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    
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
@end
