//
//  WY_OrderPayViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OrderPayViewController.h"
#import "WY_SignUpDetailsViewController.h"
#import "WY_PayNeedModel.h"
//#import <WXApi.h>
#import "OSSXMLDictionary.h"
#import "WY_CaOnlinePayCallBackModel.h"
#import "WY_SignUpSuccessViewController.h"
#import "WY_MyBalanceViewController.h"
#import "YZAuthID.h"

@interface WY_OrderPayViewController ()
{
    //debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
    UIButton *btnGoInfo;
    
    UIView *pdfView;
    UIButton *btnLeft;
    UIButton *btnRight;
    float colLastY;
    UILabel *lblMoney;
    UIImageView *imgWxSel;
    UIImageView *imgMoneySel;
//    UIControl *colWx;
    UIControl *colModel;
}

@end

@implementation WY_OrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chenggong) name:@"chenggong" object:nil];
    
    [self makeUI];
    [self bindView];
}
- (void)bindView {
    NSString *serviceType = self.mWY_SendEnrolmentMessageModel.serviceType;
    if ([serviceType isEqualToString:@"1"] || [serviceType isEqualToString:@"2"]) {
        //pdfurl
        self.title = @"培训报名用户协议";
        //才 跳转 协议
        pdfView = [UIView new];
        [pdfView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
        [self.view addSubview: pdfView];
        [pdfView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
        
        NSString *pdfurl = [self.dicSignUpSuccess[@"pdfurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfurl]]];
        [pdfView addSubview:webview];
        
        btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, webview.bottom, kScreenWidth / 2, k360Width(50))];
        btnRight = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2, webview.bottom, kScreenWidth / 2, k360Width(50))];
        [btnLeft setTitle:@"拒 绝" forState:UIControlStateNormal];
        [btnRight setTitle:@"同 意" forState:UIControlStateNormal];
        [btnLeft setBackgroundColor:HEXCOLOR(0xFE5238)];
        [btnRight setBackgroundColor:MSTHEMEColor];
        
        [btnLeft.titleLabel setFont:WY_FONTMedium(16)];
        [btnRight.titleLabel setFont:WY_FONTMedium(16)];
        
        [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
 
        [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [pdfView addSubview:btnLeft];
        [pdfView addSubview:btnRight];
        [btnLeft addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            NSLog(@"拒绝");
            NSMutableDictionary *dicPost = [NSMutableDictionary new];
            [dicPost setObject:pdfurl forKey:@"url"];
            [[MS_BasicDataController sharedInstance] postWithReturnCode:deletePDF_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                  [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [self.navigationController popViewControllerAnimated:YES];
            }];

        }];
        
        [btnRight addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            self.title = @"订单支付";
            [pdfView setHidden:YES];
        }];
        
    }
}
- (void)makeUI {
    self.title = @"订单支付";
    [self.view setBackgroundColor:MSColor(242, 242, 242)];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(200))];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblSuccess = [[UILabel alloc] initWithFrame:CGRectMake(0,  k360Width(60), kScreenWidth, k360Width(30))];
    [lblSuccess setFont:WY_FONTMedium(20)];
    [lblSuccess setText:[NSString stringWithFormat:@"￥%@",self.mWY_SendEnrolmentMessageModel.Amount]];
    [lblSuccess setTextAlignment:NSTextAlignmentCenter];
    [view1 addSubview:lblSuccess];
    
    UILabel *lblkName = [[UILabel alloc] initWithFrame:CGRectMake(0,  lblSuccess.bottom + k360Width(5), kScreenWidth, k360Width(50))];
    [lblkName setFont:WY_FONTMedium(14)];
    [lblkName setTextColor:APPTextGayColor];
    [lblkName setText:[NSString stringWithFormat:@"课程名称：%@",self.mWY_TraCourseDetailModel.Title]];
    [lblkName setTextAlignment:NSTextAlignmentCenter];
    [lblkName setNumberOfLines:0];
    [lblkName setLineBreakMode:NSLineBreakByWordWrapping];
    [view1 addSubview:lblkName];
    
    [self.view addSubview:view1];
    UILabel *lblSelPayType = [UILabel new];
    [lblSelPayType setFrame:CGRectMake(k360Width(10), view1.bottom + k360Width(16), kScreenWidth, k360Width(30))];
    [lblSelPayType setText:@"请选择支付方式:"];
    [self.view addSubview: lblSelPayType];
    
    colLastY = lblSelPayType.bottom + k360Width(16);
    
    UILabel *lblWx = [UILabel new];
    lblMoney = [UILabel new];
    
    imgWxSel = [UIImageView new];
    imgMoneySel = [UIImageView new];
//    if ([self.mWY_SendEnrolmentMessageModel.adviceType isEqualToString:@"1"]) {
        colModel = [self retControlBy:@"余额支付" byLabTitle:lblMoney byImage:[UIImage imageNamed:@"0224_myyue"] imgBaySel:imgMoneySel];
        colModel.selected = YES;

//    } else {
//        colWx = [self retControlBy:@"微信支付" byLabTitle:lblWx byImage:[UIImage imageNamed:@"wx"] imgBaySel:imgWxSel];
//        colWx.selected = YES;
//    }
     
    [imgMoneySel setImage:[UIImage imageNamed:@"yuan2_p"]];
    [imgWxSel setImage:[UIImage imageNamed:@"yuan2"]];

    [colModel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        colWx.selected = NO;
        colModel.selected = YES;
        [imgMoneySel setImage:[UIImage imageNamed:@"yuan2_p"]];
        [imgWxSel setImage:[UIImage imageNamed:@"yuan2"]];

    }];
//    [colWx addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        colWx.selected = YES;
//        colModel.selected = NO;
//        [imgMoneySel setImage:[UIImage imageNamed:@"yuan2"]];
//        [imgWxSel setImage:[UIImage imageNamed:@"yuan2_p"]];
//    }];
    
    btnGoInfo = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), kScreenHeight - JCNew64 - k360Width(54) - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(32), k360Width(44))];
    btnGoInfo.centerX = self.view.centerX;
    [btnGoInfo rounded:k360Width(44/8)];
    [btnGoInfo setTitle:@"确认支付" forState:UIControlStateNormal];
    [btnGoInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnGoInfo setBackgroundColor:MSTHEMEColor];
    [btnGoInfo addTarget:self action:@selector(btnGoInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGoInfo];

    
}

- (UIControl *)retControlBy:(NSString *)titleStr byLabTitle:(UILabel *)withLabTitle byImage:(UIImage *)withImg imgBaySel:(UIImageView *)imgBaySel {
    UIControl *view2 = [[UIControl alloc] initWithFrame:CGRectMake(0, colLastY, kScreenWidth, k360Width(44))];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    UIImageView *imgWx = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(10), k360Width(24), k360Width(24))];
    [imgWx setImage:withImg];
    [view2 addSubview:imgWx];
    
    
    [withLabTitle setFrame:CGRectMake(imgWx.right + k360Width(10),  0, kScreenWidth, k360Width(44))];
    [withLabTitle setFont:[UIFont fontWithName:@"PingFangSC" size:k360Width(14)]];
    [withLabTitle setText:titleStr];
    [withLabTitle setTextAlignment:NSTextAlignmentLeft];
    [view2 addSubview:withLabTitle];

    
    [imgBaySel setFrame:CGRectMake(kScreenWidth - k360Width(34 + 16), k360Width(10), k360Width(24), k360Width(24))];
    [imgBaySel setImage:[UIImage imageNamed:@"yuan2_p"]];
    [view2 addSubview:imgBaySel];
    colLastY = view2.bottom + k360Width(2);
    return view2;
}


- (void)btnGoInfoAction {
//    [self chenggong];
//    return;
    
//    if (colWx.selected) {
//        //微信支付
////        [self weiXinPay];
//    } else {
        //余额支付
        NSLog(@"余额- 是否充足判断");
            [[MS_BasicDataController sharedInstance] postWithReturnCode:getAppCoin_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                  if ([code integerValue] == 0) {
        //              [SVProgressHUD showSuccessWithStatus:res[@"msg"]];
                      NSString *nstotal = @"0";
                      if (![res[@"data"] isEqual:[NSNull null]]) {
                          if (![res[@"data"][@"total"] isEqual:[NSNull null]]) {
                              nstotal = res[@"data"][@"total"];
                          }
                      }
                      if ([nstotal floatValue] < [self.mWY_SendEnrolmentMessageModel.Amount floatValue]) {
                          float difference = abs([nstotal floatValue] - [self.mWY_SendEnrolmentMessageModel.Amount floatValue]);
                          //余额不足
                              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前余额不足，是否去充值?" preferredStyle:UIAlertControllerStyleAlert];
                          [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                     
                                 }])];
                          [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                              WY_MyBalanceViewController *tempController = [WY_MyBalanceViewController new];
                              tempController.difference = difference;
                              [self.navigationController pushViewController:tempController animated:YES];

                          }])];
                          [self presentViewController:alertController animated:YES completion:nil];

                      } else {
                          //余额支付
                          NSString *msgStr = [NSString stringWithFormat:@"确定用余额支付吗？当前余额：%.2f",[nstotal floatValue]];
                              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
                          [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                     
                                 }])];
                          [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                        [self authVerification];

                          }])];
                          [self presentViewController:alertController animated:YES completion:nil];

                      }
                     } else {
                      [SVProgressHUD showErrorWithStatus:res[@"msg"]];
                  }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
            }];
 
//    }
     
}
#pragma mark - 验证TouchID/FaceID
- (void)authVerification {
    
    YZAuthID *authID = [[YZAuthID alloc] init];
    
    [authID yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
        
        if (state == YZAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            NSLog(@"对不起，当前设备不支持指纹/面容ID");
//            [SVProgressHUD showErrorWithStatus:@"对不起，当前设备不支持指纹/面容ID"];
             [self yuePay];
        } else if(state == YZAuthIDStateFail) { // 认证失败
            NSLog(@"指纹/面容ID不正确，认证失败");
            [SVProgressHUD showErrorWithStatus:@"指纹/面容ID不正确，认证失败"];
        } else if(state == YZAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            NSLog(@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码");
            [SVProgressHUD showErrorWithStatus:@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码"];
        } else if (state == YZAuthIDStateSuccess) { // TouchID/FaceID验证成功
            NSLog(@"认证成功！");
            [self yuePay];
        }
        
    }];
}
- (void)yuePay {
    NSLog(@"余额支付");
    [btnGoInfo setEnabled:NO];
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.dicSignUpSuccess[@"orderId"] forKey:@"orderNo"];
    [postDic setObject:self.mWY_TraCourseDetailModel.ClassGuid forKey:@"ClassGuid"];
    [postDic setObject:self.mWY_TraCourseDetailModel.Title forKey:@"detailText"];
 
       [[MS_BasicDataController sharedInstance] postWithReturnCode:appCoinpay_HTTP params:postDic jsonData:[self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans yy_modelToJSONData] showProgressView:YES success:^(id res, NSString *code) {
             if ([code integerValue] == 0 ) {
//                   [self chenggong];
                 
                 WY_SignUpSuccessViewController *tempController = [WY_SignUpSuccessViewController new];
                 tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
                 tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
                 tempController.dicSignUpSuccess = self.dicSignUpSuccess;
                 tempController.paymethod = @"04";
                 [self jumpVC:tempController];
                 
             } else {
                 [SVProgressHUD showErrorWithStatus:res[@"msg"]];
                 [btnGoInfo setEnabled:YES];
             }
       } failure:^(NSError *error) {
           [SVProgressHUD showErrorWithStatus:@"网络不给力"];
           [btnGoInfo setEnabled:YES];
       }];

}

//- (void)weiXinPay {
//    NSLog(@"确认支付");
//    [btnGoInfo setEnabled:NO];
//       WY_PayNeedModel *tempPayModel = [WY_PayNeedModel new];
//       tempPayModel.orderGuid = self.dicSignUpSuccess[@"orderGuid"];
//       tempPayModel.cost = self.mWY_SendEnrolmentMessageModel.Amount;
//       tempPayModel.paymethod = @"03";
//       tempPayModel.body = self.mWY_TraCourseDetailModel.Title;
//       tempPayModel.out_trade_no = self.dicSignUpSuccess[@"orderId"];
//       tempPayModel.orderDetailBean = self.mWY_SendEnrolmentMessageModel.toJSONString;
//
//       [[MS_BasicDataController sharedInstance] postWithReturnCode:onlinepay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
//             if ([code integerValue] == 0 ) {
//                  if ([res[@"data"][@"responseString"] isEqual:[NSNull null]]) {
//                      [SVProgressHUD showErrorWithStatus:@"接口数据返回错误-请稍后再试"];
//                     [btnGoInfo setEnabled:YES];
//
//                     return ;
//                 }
//                 NSDictionary *responseStringDic = [NSDictionary oss_dictionaryWithXMLString:res[@"data"][@"responseString"]];
//
//                 PayReq* req             = [[PayReq alloc] init];
//                 req.openID              = @"wxd2381bec1a8984de";
//                 req.nonceStr            = responseStringDic[@"nonce_str"];
//                 req.package             = @"Sign=WXPay";
//                 req.partnerId           = responseStringDic[@"mch_id"];
//                 req.timeStamp           = [[NSDate date] timeIntervalSince1970];
//                 req.prepayId            = responseStringDic[@"prepay_id"];
//
//                 NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
//                 [signParams setObject: req.openID        forKey:@"appid"];
//                 [signParams setObject: req.nonceStr    forKey:@"noncestr"];
//                 [signParams setObject: req.package      forKey:@"package"];
//                 [signParams setObject: req.partnerId        forKey:@"partnerid"];
//                 [signParams setObject: [NSString stringWithFormat:@"%u", (unsigned int)req.timeStamp]   forKey:@"timestamp"];
//                 [signParams setObject: req.prepayId     forKey:@"prepayid"];
//                 //生成签名
//                 NSString *sign  = [self createMd5Sign:signParams];
//                 req.sign = sign;
//
//                 [WXApi sendReq:req completion:^(BOOL success) {
//                     if (success) {
//                         NSLog(@"成功");
//                         [self chenggong];
//                     } else {
//                         NSLog(@"失败");
//                     }
//                 }];
//
//             } else {
//                 [SVProgressHUD showErrorWithStatus:res[@"msg"]];
//                 [btnGoInfo setEnabled:YES];
//             }
//       } failure:^(NSError *error) {
//           [SVProgressHUD showErrorWithStatus:@"网络不给力"];
//           [btnGoInfo setEnabled:YES];
//       }];
//}
-(void)chenggong{
//
    WY_CaOnlinePayCallBackModel *tempPayModel = [WY_CaOnlinePayCallBackModel new];
    tempPayModel.isca = @"2";
    tempPayModel.OrderGuid = self.dicSignUpSuccess[@"orderId"];
    tempPayModel.traEnrolPersonBeans = self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans;
//    if (colWx.selected) {
//    tempPayModel.paymethod = @"03";
//    } else {
    tempPayModel.paymethod = @"04";
//    }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:backonlinepay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
          if ([code integerValue] == 0 ) {
               WY_SignUpSuccessViewController *tempController = [WY_SignUpSuccessViewController new];
               tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
               tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
               tempController.dicSignUpSuccess = self.dicSignUpSuccess;
              tempController.paymethod = @"03";
               [self jumpVC:tempController];

          } else {
              [SVProgressHUD showErrorWithStatus:res[@"msg"]];
          }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
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

/// 跳转下一页此页消失
/// @param vc 下一页
-(void)jumpVC:(UIViewController *)vc{
    NSArray *vcs = self.navigationController.viewControllers;
    NSMutableArray *newVCS = [NSMutableArray array];
    if ([vcs count] > 0) {

        for (int i=0; i < [vcs count]-1; i++) {

            [newVCS addObject:[vcs objectAtIndex:i]];

        }

    }
    [newVCS addObject:vc];
    [self.navigationController setViewControllers:newVCS animated:YES];

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
