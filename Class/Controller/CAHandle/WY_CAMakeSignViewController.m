//
//  WY_CAMakeSignViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/15.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_CAMakeSignViewController.h"
#import "WY_SignViewController.h"
#import "WY_AddressManageViewController.h"

#import "ImageNewsDetailViewController.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WY_CAPayViewController.h"
#import "WY_CAPaySuccessViewController.h"
#import <WXApi.h>
#import "WY_PayNeedModel.h"
#import "OSSXMLDictionary.h"
#import "WY_CaOnlinePayCallBackModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WY_UpLoadSignPicViewController.h"

@interface WY_CAMakeSignViewController ()
{
}
@property (nonatomic , strong) UIView *viewTop;
//@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) WKWebView *mWebView;
@property (nonatomic , strong) UIButton *btnUp;
@property (nonatomic , strong) UIButton *btnReSign;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic , strong) NSString *mSignUrl;
@property (nonatomic , strong) NSString *mPdfUrl;
@property (nonatomic , strong) NSMutableDictionary *reSignCAInfo;

@property (nonatomic , strong) NSMutableDictionary *dicSignUpSuccess;
@property (nonatomic , strong) UILabel *lblMoney;


@end

@implementation WY_CAMakeSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CA补办";
    [self makeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chenggong) name:@"chenggong" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self bindView];
}
- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    //
    [self initTopView];
    [self initMiddleView];
}

- (void)initTopView {
    self.viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k375Width(90))];
    [self.viewTop setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    [self.view addSubview:self.viewTop];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(k375Width(60), k375Width(16.5), k375Width(30), k375Width(30))];
    UILabel *lbltop1 = [[UILabel alloc] initWithFrame:CGRectMake(0, img1.bottom + k375Width(10), k375Width(70), k375Width(16))];
    lbltop1.centerX = img1.centerX;
    
    UILabel *lblLine1 = [[UILabel alloc] initWithFrame:CGRectMake(lbltop1.right + k375Width(15), img1.bottom - k375Width(5), k375Width(140), k375Width(4))];
    
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(lblLine1.right + k375Width(20), k375Width(16.5), k375Width(30), k375Width(30))];
    UILabel *lbltop2 = [[UILabel alloc] initWithFrame:CGRectMake(0, img2.bottom + k375Width(10), k375Width(70), k375Width(16))];
    lbltop2.centerX = img2.centerX;
    
    
    [img1 setImage:[UIImage imageNamed:@"0611_ws1"]];
    [img2 setImage:[UIImage imageNamed:@"0611_ws2"]];
    
    [self.viewTop addSubview:img1];
    [self.viewTop addSubview:img2];
    [self.viewTop addSubview:lbltop1];
    [self.viewTop addSubview:lbltop2];
    [self.viewTop addSubview:lblLine1];
    
    [lbltop1 setTextColor:HEXCOLOR(0x0F6DD2)];
    [lbltop2 setTextColor:HEXCOLOR(0x0F6DD2)];
    
    [lbltop1 setTextAlignment:NSTextAlignmentCenter];
    [lbltop2 setTextAlignment:NSTextAlignmentCenter];
    
    
    [lblLine1 setTextColor:HEXCOLOR(0x0F6DD2)];
    
    [lbltop1 setFont:WY_FONT375Medium(16)];
    [lbltop2 setFont:WY_FONT375Medium(16)];
    
    [lblLine1 setFont:WY_FONT375Medium(12)];
    
    
    
    [lbltop1 setText:@"补办信息"];
    [lblLine1 setText:@"••••••••••••••••••••"];
    if ([self.isEdit isEqualToString:@"2"]) {
        [lbltop2 setText:@"修改订单"];
    } else {
        [lbltop2 setText:@"签字付款"];
    }
}

- (void)initMiddleView {
    
    self.mWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - self.viewTop.bottom - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin - k360Width(44))];
    [self.view addSubview:self.mWebView];
    
    self.lblMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mWebView.bottom, kScreenWidth, k360Width(44))];
    [self.lblMoney setTextColor:[UIColor redColor]];
    [self.lblMoney setFont:WY_FONTMedium(16)];
    [self.lblMoney setHidden:YES];
    [self.view addSubview:self.lblMoney];
    
    self.btnUp = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(16), self.lblMoney.bottom, (kScreenWidth - k375Width(16*3)) / 2, k360Width(44))];
    [self.btnUp setTitle:@"上一步" forState:UIControlStateNormal];
    [self.btnUp.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnUp setBackgroundColor:[UIColor whiteColor]];
    [self.btnUp setTitleColor:HEXCOLOR(0x777777) forState:UIControlStateNormal];
    [self.btnUp rounded:k360Width(44)/8 width:1 color:HEXCOLOR(0x777777)];
    [self.btnUp addTarget:self action:@selector(btnUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnUp];
    
    
    self.btnReSign = [[UIButton alloc] initWithFrame:CGRectMake(self.btnUp.right + k375Width(16), self.lblMoney.bottom, (kScreenWidth - k375Width(16*3)) / 2, k360Width(44))];
    [self.btnReSign setTitle:@"签  名" forState:UIControlStateNormal];
    [self.btnReSign.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnReSign setBackgroundColor:MSTHEMEColor];
    [self.btnReSign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnReSign rounded:k360Width(44)/8];
    [self.btnReSign addTarget:self action:@selector(btnReSignAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnReSign];
    
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(16), self.lblMoney.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    [self.btnSubmit setHidden:YES];
    if ([self.isEdit isEqualToString:@"2"]) {
        [self.btnSubmit setTitle:@"修改订单" forState:UIControlStateNormal];
    } else {
        [self.btnSubmit setTitle:@"付  款" forState:UIControlStateNormal];
    }
}

- (void)bindView {
    [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pdfUrl]]];
    
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
    //    WY_CAPayViewController *tempController = [WY_CAPayViewController new];
    //    [self.navigationController pushViewController:tempController animated:YES];
    //    return;
    
    NSLog(@"点击了签名");
    UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您可选择直接手机端手写签名，您也可以为确保签章的真实性选择上传签名采集表。" preferredStyle:UIAlertControllerStyleAlert];
    [tempAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [tempAlert addAction:[UIAlertAction actionWithTitle:@"本机手写签名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WY_SignViewController *tempController = [WY_SignViewController new];
        tempController.popVCBlock = ^(NSString * _Nonnull picUrl) {
            self.mSignUrl = picUrl;
            [self signBind];
        };
        tempController.modalPresentationStyle = 0;
        [self presentViewController:tempController animated:YES completion:nil];
    }]];
    [tempAlert addAction:[UIAlertAction actionWithTitle:@"上传签名采集表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WY_UpLoadSignPicViewController *tempController = [WY_UpLoadSignPicViewController new];
        tempController.popVCBlock = ^(NSString * _Nonnull picUrl, NSString * _Nonnull pdfUrl) {
            self.mSignUrl = picUrl;
            self.mPdfUrl = pdfUrl;
            [self signBind];
        };
        [self.navigationController pushViewController:tempController animated:YES];
    }]];
    
    [self presentViewController:tempAlert animated:YES completion:nil];
    
    return;
}

- (void)signBind {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    [self.dicPostCAInfo setObject:[self.mSignUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"signature"];
    
    [self.dicPostCAInfo setObject:[self.mPdfUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ymcjb"];
    
    [self.dicPostCAInfo setObject:self.mUser.UserGuid forKey:@"userGuid"];
    [self.dicPostCAInfo setObject:@"cabbImage" forKey:@"exportType"];
    if ([self.isEdit isEqualToString:@"1"] || [self.isEdit isEqualToString:@"2"]) {
        [self.dicPostCAInfo setObject:self.dicEditInfo[@"sqId"] forKey:@"id"];
    }
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_caRequestBB_HTTP params:nil jsonData:[self.dicPostCAInfo mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            self.pdfUrl = res[@"data"][@"sqs"];
            //            self.dicCAInfo = [NSMutableDictionary new];
            self.reSignCAInfo = res[@"data"];
            [self.dicPostCAInfo setObject:res[@"data"][@"id"] forKey:@"id"];
            
            NSMutableAttributedString *attMoney = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"补办金额：%.2f元",[self.reSignCAInfo[@"money"] floatValue]]];
            [attMoney setYy_color:[UIColor redColor]];
            if ([self.isEdit isEqualToString:@"2"]) {
                NSMutableAttributedString *attMoneyA = [[NSMutableAttributedString alloc] initWithString:@"（已支付）"];
                [attMoneyA setYy_color:APPBlackColor];
                [attMoney appendAttributedString:attMoneyA];
            }
            [self.lblMoney setAttributedText:attMoney];
            [self.lblMoney setTextAlignment:NSTextAlignmentCenter];
            [self.lblMoney setHidden:NO];
            [self bindView];
            
            self.btnUp.width = (kScreenWidth - k375Width(16*4)) / 3;
            self.btnReSign.width = self.btnUp.width;
            [self.btnReSign setTitle:@"重新签名" forState:UIControlStateNormal];
            [self.btnReSign setBackgroundColor:HEXCOLOR(0xE4E8ED)];
            [self.btnReSign setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            self.btnSubmit.width = self.btnUp.width;
            self.btnReSign.left = self.btnUp.right + k375Width(16);
            self.btnSubmit.left = self.btnReSign.right + k375Width(16);
            [self.btnSubmit setHidden:NO];
            
        } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
}

- (void)btnSubmitAction {
    NSLog(@"点击了提交订单");
    [self.dicPostCAInfo setObject:self.reSignCAInfo forKey:@"dicCAInfo"];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] initWithDictionary:self.dicPostCAInfo[@"dicCAInfo"]];
    
    [postDic setObject:self.dicEditInfo[@"dqsj"] forKey:@"dqsj"];
    
    if (![self.dicPostCAInfo[@"zddid"] isEqual:[NSNull null]]) {
        [postDic setObject:self.dicPostCAInfo[@"zddid"] forKey:@"ddId"];
        
    }
    if ([self.isEdit isEqualToString:@"1"] || [self.isEdit isEqual:@"2"]) {
        [postDic setObject:@"0" forKey:@"status"];
        [postDic setObject:self.dicEditInfo[@"OrderNo"] forKey:@"ddId"];
    }
    //上个接口没有返回fhcityCode - 手动加一下
    [postDic setObject:self.dicPostCAInfo[@"fhcityCode"] forKey:@"fhcityCode"];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_createBBDD_HTTP params:nil jsonData:[postDic mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"notCAJGNotify" object:nil];
            
            if (![self.isEdit isEqualToString:@"2"]) {
                [self.dicPostCAInfo setObject:res[@"data"][@"orderno"] forKey:@"zddid"];
                NSLog(@"支付成功 - 后调取支付");
                NSLog(@"选择了微信支付");
                self.dicSignUpSuccess = res[@"data"];
                [self weiXinPay];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"重新提交申请成功，请等待审核" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确定");
                    NSArray *pushVCAry=[self.navigationController viewControllers];
                    UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-4];
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

- (void)weiXinPay {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [self tongLianPay];
    return;
    NSLog(@"确认支付");
    WY_PayNeedModel *tempPayModel = [WY_PayNeedModel new];
    tempPayModel.orderGuid = self.dicSignUpSuccess[@"orderguid"];
    //       tempPayModel.cost = self.mWY_SendEnrolmentMessageModel.Amount;
    tempPayModel.paymethod = self.payType;
    tempPayModel.body = self.dicPostCAInfo[@"dicCAInfo"][@"sqjg"];
    tempPayModel.userGuid =  self.mUser.UserGuid;
    tempPayModel.out_trade_no = self.dicSignUpSuccess[@"orderno"];
    
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
            tempPayModel.OrderGuid = self.dicSignUpSuccess[@"orderno"];
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
    tempPayModel.orderGuid = self.dicSignUpSuccess[@"orderguid"];
    tempPayModel.paymethod = self.payType;
    tempPayModel.body = self.dicPostCAInfo[@"dicCAInfo"][@"sqjg"];
    tempPayModel.userGuid =  self.mUser.UserGuid;
    tempPayModel.out_trade_no = self.dicSignUpSuccess[@"orderno"];
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
            [[UIApplication sharedApplication] openURL: url2];
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
    tempController.caType = @"1";
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
    [postDic setObject:self.dicSignUpSuccess[@"orderNo"] forKey:@"OrderNo"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getMyDealInfo_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
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
    
    //    [self.navigationController pushViewController:tempController animated:YES];
    
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
