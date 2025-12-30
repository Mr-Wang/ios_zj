//
//  WY_CAPdfViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/15.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_CAPdfViewController.h"
#import "WY_SignViewController.h"
#import "WY_AddressManageViewController.h"

#import "ImageNewsDetailViewController.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WY_CAPayViewController.h"
#import "WY_UpLoadSignPicViewController.h"

@interface WY_CAPdfViewController ()
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
@end

@implementation WY_CAPdfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CA便捷办理";
    [self makeUI];
    
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
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(k375Width(40), k375Width(16.5), k375Width(30), k375Width(30))];
    UILabel *lbltop1 = [[UILabel alloc] initWithFrame:CGRectMake(0, img1.bottom + k375Width(10), k375Width(70), k375Width(16))];
    lbltop1.centerX = img1.centerX;
    
    UILabel *lblLine1 = [[UILabel alloc] initWithFrame:CGRectMake(lbltop1.right + k375Width(5), img1.bottom - k375Width(5), k375Width(70), k375Width(4))];

    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(lblLine1.right + k375Width(10), k375Width(16.5), k375Width(30), k375Width(30))];
    UILabel *lbltop2 = [[UILabel alloc] initWithFrame:CGRectMake(0, img2.bottom + k375Width(10), k375Width(70), k375Width(16))];
    lbltop2.centerX = img2.centerX;

    UILabel *lblLine2 = [[UILabel alloc] initWithFrame:CGRectMake(lbltop2.right + k375Width(5), img2.bottom - k375Width(5), k375Width(70), k375Width(4))];

    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(lblLine2.right + k375Width(10), k375Width(16.5), k375Width(30), k375Width(30))];
    UILabel *lbltop3 = [[UILabel alloc] initWithFrame:CGRectMake(0, img3.bottom + k375Width(10), k375Width(70), k375Width(16))];
    lbltop3.centerX = img3.centerX;

    

    
    
    [img1 setImage:[UIImage imageNamed:@"0611_ws1"]];
    [img2 setImage:[UIImage imageNamed:@"0611_ws2"]];
    [img3 setImage:[UIImage imageNamed:@"0611_ws3h"]];
 
    [self.viewTop addSubview:img1];
    [self.viewTop addSubview:img2];
    [self.viewTop addSubview:img3];
    [self.viewTop addSubview:lbltop1];
    [self.viewTop addSubview:lbltop2];
    [self.viewTop addSubview:lbltop3];
    [self.viewTop addSubview:lblLine1];
    [self.viewTop addSubview:lblLine2];
    
    [lbltop1 setTextColor:HEXCOLOR(0x0F6DD2)];
    [lbltop2 setTextColor:HEXCOLOR(0x0F6DD2)];
    [lbltop3 setTextColor:HEXCOLOR(0x8B8B8B)];
    
    [lbltop1 setTextAlignment:NSTextAlignmentCenter];
    [lbltop2 setTextAlignment:NSTextAlignmentCenter];
    [lbltop3 setTextAlignment:NSTextAlignmentCenter];
    
    
    [lblLine1 setTextColor:HEXCOLOR(0x0F6DD2)];
    [lblLine2 setTextColor:HEXCOLOR(0x8B8B8B)];

    [lbltop1 setFont:WY_FONT375Medium(16)];
    [lbltop2 setFont:WY_FONT375Medium(16)];
    [lbltop3 setFont:WY_FONT375Medium(16)];
    
    [lblLine1 setFont:WY_FONT375Medium(12)];
    [lblLine2 setFont:WY_FONT375Medium(12)];
    
    
    
    [lbltop1 setText:@"证书信息"];
    [lblLine1 setText:@"••••••••••"];
    [lblLine2 setText:@"••••••••••"];
    [lbltop2 setText:@"申请书"];
    if (![self.isEdit isEqualToString:@"1"] && ![self.isEdit isEqualToString:@"2"]) {
        [lbltop3 setText:@"订单支付"];
    } else {
        [lbltop3 setText:@"修改订单"];
    }
}

- (void)initMiddleView {
    
    self.mWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - self.viewTop.bottom - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mWebView];
    
    
     
    self.btnUp = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(16), self.mWebView.bottom, (kScreenWidth - k375Width(16*3)) / 2, k360Width(44))];
    [self.btnUp setTitle:@"上一步" forState:UIControlStateNormal];
    [self.btnUp.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnUp setBackgroundColor:[UIColor whiteColor]];
    [self.btnUp setTitleColor:HEXCOLOR(0x777777) forState:UIControlStateNormal];
    [self.btnUp rounded:k360Width(44)/8 width:1 color:HEXCOLOR(0x777777)];
    [self.btnUp addTarget:self action:@selector(btnUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnUp];

    
    self.btnReSign = [[UIButton alloc] initWithFrame:CGRectMake(self.btnUp.right + k375Width(16), self.mWebView.bottom, (kScreenWidth - k375Width(16*3)) / 2, k360Width(44))];
    [self.btnReSign setTitle:@"签  名" forState:UIControlStateNormal];
    [self.btnReSign.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnReSign setBackgroundColor:MSTHEMEColor];
    [self.btnReSign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnReSign rounded:k360Width(44)/8];
    [self.btnReSign addTarget:self action:@selector(btnReSignAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnReSign];

    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(16), self.mWebView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    [self.btnSubmit setHidden:YES];
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

    if ([[self.dicPostCAInfo objectForKey:@"exportType"] isEqualToString:@"bjca"] || [[self.dicPostCAInfo objectForKey:@"exportType"] isEqualToString:@"bjcaImage"]) {
        [self.dicPostCAInfo setObject:@"bjcaImage" forKey:@"exportType"];
    } else {
        [self.dicPostCAInfo setObject:@"cfcaImage" forKey:@"exportType"];
    }
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_caRequestCa_HTTP params:nil jsonData:[self.dicPostCAInfo mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            self.pdfUrl = res[@"data"][@"sqs"];
//            self.dicCAInfo = [NSMutableDictionary new];
            self.reSignCAInfo = res[@"data"];
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
    
    WY_CAPayViewController *tempController = [WY_CAPayViewController new];
    tempController.dicPostCAInfo = self.dicPostCAInfo;
    if ([self.isEdit isEqualToString:@"1"] || [self.isEdit isEqualToString:@"2"]) {
        tempController.isEdit = self.isEdit;
        tempController.dicEditInfo = self.dicEditInfo;
    }
    [self.navigationController pushViewController:tempController animated:YES];
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
