//
//  WY_ExamCertificationViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ExamCertificationViewController.h"
#import "WY_CertificationModel.h"
#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>

@interface WY_ExamCertificationViewController ()
{
    int lastY;
    UIView *pdfView;
    UIButton *btnLeft;
    UIButton *btnRight;
    NSString *isAgree;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UITextField *txtName;
@property (nonatomic, strong) UITextField *txtPhone;
@property (nonatomic, strong) UITextField *txtIdCard;
@property (nonatomic, strong) UILabel *lblDanWei;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic , strong) NSString *pdfUrlStr;
@end

@implementation WY_ExamCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self dataBind];
}
- (void)makeUI {
    self.title = @"报名确认";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    self.mScrollView = [UIScrollView new];
    [self.view addSubview:self.mScrollView];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), kScreenHeight - k360Width(50) - JCNew64 - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(30), k360Width(40))];
    [btnLeft setTitle:@"确    定" forState:UIControlStateNormal];
    [btnLeft rounded:k360Width(40/8)];
    [btnLeft setBackgroundColor:MSTHEMEColor];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLeft];
    
}
- (void)dataBind {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    self.txtName = [UITextField new];
    self.txtPhone = [UITextField new];
    self.txtIdCard = [UITextField new];
    self.lblDanWei = [UILabel new];
    
    self.txtName.placeholder = @"请输入您的姓名";
    self.txtIdCard.placeholder = @"请输入有效的考生身份证号";
    
    self.lblDanWei.text = self.mUser.DanWeiName;
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(80))];
    lblTitle.text = @"请确认考生信息";
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:WY_FONTMedium(20)];
    [self.mScrollView addSubview:lblTitle];
    
    lastY = lblTitle.bottom;
    
    [self addItem:@"考生姓名：" withRightTextField:self.txtName];
    [self addItem:@"考生电话：" withRightTextField:self.txtPhone];
    [self addItem:@"考生身份证号：" withRightTextField:self.txtIdCard];
    
    [self addItem:@"考生单位" withRightText:self.lblDanWei];
    
//    if  ([self.mUser.UserType isEqualToString:@"2"]) {
    //这尼玛是企业主
        if  (self.mUser.idcardnum.length <= 0) {
            //如果没有身份证号-  手填姓名和身份证号
        self.txtName.userInteractionEnabled = YES;
        self.txtIdCard.userInteractionEnabled = YES;
        self.txtPhone.userInteractionEnabled = NO;
        self.txtPhone.text = self.mUser.LoginID;
    } else {
        self.txtName.userInteractionEnabled = NO;
        self.txtIdCard.userInteractionEnabled = NO;
        self.txtPhone.userInteractionEnabled = NO;
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        [dicPost setObject:self.mWY_ExamListModel.ClassGuid forKey:@"ClassGuid"];
        [dicPost setObject:self.mUser.idcardnum forKey:@"baomingidcard"];
        
        [[MS_BasicDataController sharedInstance] postWithReturnCode:getrzxx_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            if ([code integerValue] == 0 && res) {
                self.txtIdCard.text = res[@"data"][@"baomingidcard"];
                self.txtPhone.text = res[@"data"][@"Phone"];
                self.txtName.text = res[@"data"][@"UserName"];
                
            } else {
                [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        }];
        
        
    }
    
    
}

- (void)btnIsFace {
    //判断是否已同意协议-
    if (![isAgree isEqualToString:@"1"]) {
        //没有同意过- 提示
        [self bindPDFView];
        return;
    }
    
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    LivingConfigModel* model = [LivingConfigModel sharedInstance];
    [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
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

- (void)btnLeftAction {
    NSLog(@"进入CA人脸识别");
    if (self.txtName.text.length <= 0 ) {
        [SVProgressHUD showErrorWithStatus:self.txtName.placeholder];
        return;
    }
    if (self.txtIdCard.text.length <= 0 ) {
        [SVProgressHUD showErrorWithStatus:self.txtIdCard.placeholder];
        return;
    }
    
    self.pdfUrlStr = @"https://study.capass.cn/Avatar/app_kscn.pdf";
    [self bindPDFView];
    
//    [self btnIsFace];
    

}

- (void)bindPDFView {
    
    NSString *titleStr = self.title;
    
    self.title = @"请阅读并同意服务协议";
    //才 跳转 协议
    pdfView = [UIView new];
    [pdfView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview: pdfView];
    [pdfView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    NSString *pdfurl = [self.pdfUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
        self.title = titleStr;
        isAgree = @"0";
        [pdfView setHidden:YES];
    }];
    
    [btnRight addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.title = titleStr;
        isAgree = @"1";
        [pdfView setHidden:YES];
//      2021-07-27 17:21:36  这块有点不要脸了
//        [self btnIsFace];
        [self submitData:nil];
    }];
    
}
- (void)submitData:(UIImage *)imgFace {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mWY_ExamListModel.ClassGuid forKey:@"ClassGuid"];
    WY_CertificationModel *tempModel = [WY_CertificationModel new];
    tempModel.ClassGuid = self.mWY_ExamListModel.ClassGuid;
    tempModel.sBRIDCard = self.txtIdCard.text;
    tempModel.sBRName = self.txtName.text;
//    tempModel.strData = [self UIImageToBase64Str:imgFace];
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:smrzxx_HTTP params:dicPost jsonData:[tempModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
//            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            [self.view makeToast:@"确认成功"];
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:0] animated:YES]; //跳转
            
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
- (void) addItem:(NSString *)leftStr withRightTextField:(UITextField *)txtRight {
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(270), k360Width(44))];
    [lblLeft setFont:WY_FONTMedium(14)];
    [lblLeft setText:leftStr];
    [viewTemp addSubview:lblLeft];
    
    
    [txtRight setFrame:CGRectMake( kScreenWidth - k360Width(256), 0,  k360Width(240), k360Width(44))];
    [txtRight setFont:WY_FONTRegular(14)];
    [txtRight setTextAlignment:NSTextAlignmentRight];
    [viewTemp addSubview:txtRight];
    
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(44) - 1,kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [viewTemp addSubview:imgLine];
    
    [self.mScrollView addSubview:viewTemp];
    
    lastY = viewTemp.bottom;
}

- (void) addItem:(NSString *)leftStr withRightText:(UILabel *)txtRight {
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(80))];
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(270), k360Width(80))];
    [lblLeft setFont:WY_FONTMedium(14)];
    [lblLeft setText:leftStr];
    [viewTemp addSubview:lblLeft];
    
    [txtRight setFrame:CGRectMake( kScreenWidth - k360Width(256), 0,  k360Width(240), k360Width(80))];
    [txtRight setFont:WY_FONTRegular(14)];
    txtRight.numberOfLines = 2;
    [txtRight setTextAlignment:NSTextAlignmentRight];
    [viewTemp addSubview:txtRight];
    
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(80) - 1,kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [viewTemp addSubview:imgLine];
    
    [self.mScrollView addSubview:viewTemp];
    
    lastY = viewTemp.bottom;
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
