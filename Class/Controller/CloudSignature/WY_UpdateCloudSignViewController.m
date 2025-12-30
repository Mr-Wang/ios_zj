//
//  WY_UpdateCloudSignViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/15.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_UpdateCloudSignViewController.h"
#import "WY_SignViewController.h"
#import "WY_UpLoadSignPicViewController.h"
#import "WY_AddressManageViewController.h"

#import "ImageNewsDetailViewController.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WY_CloudSignaturePayViewController.h"
#import "MS_WKwebviewsViewController.h"

@interface WY_UpdateCloudSignViewController ()
{
    int lastY;
    NSString *picType;
}
@property (nonatomic , strong) UIView *viewTop;
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic , strong) UITextField *lblzjSex;
@property (nonatomic , strong) UILabel *lblAddress;
@property (nonatomic , strong) UILabel *lblstyleId;
@property (nonatomic , strong) UITextField *txtzjName;
@property (nonatomic , strong) UITextField *txtzjDanWeiName;
@property (nonatomic , strong) UITextField *txtzjDanWeiCity;
@property (nonatomic , strong) UITextField *txtzjDanWeiAddress;
@property (nonatomic , strong) UITextField *txtzjIDCard;
@property (nonatomic , strong) UITextField *txtzjPhone;
@property (nonatomic , strong) UITextField *txtzjEmail;
@property (nonatomic , strong) UITextField *txtzjPostCode;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic , strong) UIView *viewTop1;
@property (nonatomic , strong) NSString *userSignUrl;
@property (nonatomic , strong) NSString *idcardImgUrlB;

@property (nonatomic , strong) UIButton *btnIdCardA;
@property (nonatomic , strong) UIButton *btnIdCardAClose;

@property (nonatomic , strong) UIControl *colEmail;
@property (nonatomic) BOOL isSBFirst;
//bjca、cfca/  bjcaImage 和 cfcaImage
@property (nonatomic , strong) NSString *exportType;
//有效期Code
@property (nonatomic , strong) NSString *exportVPType;

@property (nonatomic , strong) NSString *exportTypeName;
//有效期Code
@property (nonatomic , strong) NSString *exportVPTypeName;

@property (nonatomic , strong) NSString *zjType;
@property (nonatomic , strong) NSMutableArray *arrImgMFs;//服务商选中组；
@property (nonatomic , strong) NSMutableArray *arrImgVPs;//有效期选中组；
@property (nonatomic , strong) UIImageView *imgSel1;
@property (nonatomic , strong) UIImageView *imgSel2;
@property (nonatomic , strong) UIImageView *imgSel3A;
@property (nonatomic , strong) UIImageView *imgSel4A;
@property (nonatomic , strong) NSString *notCAJG;

@property (nonatomic , strong) UIButton *btnAgree;
@property (nonatomic , strong) UIButton *lblAgree;
@property (nonatomic , strong) UIButton *lblAgree1;
@end

@implementation WY_UpdateCloudSignViewController
@synthesize imgSel1,imgSel2,imgSel3A,imgSel4A;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改签名";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notCAJGNotify) name:@"notCAJGNotify" object:nil];

    
    
    [self makeUI];
    [self bindView];
}
 
-(void)notCAJGNotify{
    self.notCAJG = @"1";
}
- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    //
//    [self initTopView];
    [self initMiddleView];
}
- (void)bindView {
    self.userSignUrl = self.dicEditInfo[@"signature"];
    if (self.userSignUrl != nil && ![self.userSignUrl isEqual:[NSNull null]] && ![self.userSignUrl isEqualToString:@""]) {
       
       [self.btnIdCardA sd_setImageWithURL:[NSURL URLWithString:self.userSignUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
       [self.btnIdCardAClose setHidden:NO];
        
   }
    
    
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
    [img2 setImage:[UIImage imageNamed:@"0611_ws2h"]];
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
    [lbltop2 setTextColor:HEXCOLOR(0x8B8B8B)];
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

- (void)initZJTypeView:(UILabel *)lblT4 viewSel3:(UIView *)viewSel3 {
    [lblT4 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblT4 setText:@"选择专家类型"];
    [lblT4 setTextColor:HEXCOLOR(0x434343)];
    [lblT4 setFont:WY_FONT375Medium(14)];
    [viewSel3 addSubview:lblT4];
    
    UIControl *col1 = [UIControl new];
    imgSel3A = [UIImageView new];
    UILabel *lblCFCAName = [UILabel new];
    
    [col1 setFrame:CGRectMake(k375Width(16), lblT4.bottom+k375Width(5), kScreenWidth - k375Width(32), k375Width(44))];
//    [col1 setBackgroundColor:[UIColor redColor]];
    [viewSel3 addSubview:col1];
     
    
    [lblCFCAName setFrame:CGRectMake(k375Width(10),k375Width(6), k375Width(300), k375Width(20))];
    [lblCFCAName setNumberOfLines:0];
    NSMutableAttributedString *att1A = [[NSMutableAttributedString alloc] initWithString:@"评标专家（或招标人评委）"];
    [att1A setYy_font:WY_FONT375Medium(14)];
    [att1A setYy_color:[UIColor blackColor]];
     
    [lblCFCAName setAttributedText:att1A];
    [col1 addSubview:lblCFCAName];
 
    [imgSel3A setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
    [imgSel3A setImage:[UIImage imageNamed:@"0316_sel"]];
    [imgSel3A setCenterY:lblCFCAName.centerY];
    [col1 addSubview:imgSel3A];
}

- (void)initMiddleView {
     
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"确定修改" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    
    self.viewTop1 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k375Width(180 + 30))];
    [self.viewTop1 setBackgroundColor:[UIColor whiteColor]];
    [self.mScrollView addSubview:self.viewTop1];
    [self.mScrollView setContentSize:CGSizeMake(0, self.viewTop1.bottom)];
    
//    UILabel *lblTiShi = [UILabel new];
//    [lblTiShi setFrame:CGRectMake(k360Width(16), k360Width(0), kScreenWidth - k360Width(32), k360Width(44))];
//
//    NSMutableAttributedString *attTop1Strxxx = [[NSMutableAttributedString alloc] initWithString:@"*"];
//    [attTop1Strxxx setYy_font:WY_FONTMedium(14)];
//    [attTop1Strxxx setYy_color:[UIColor redColor]];
//    NSMutableAttributedString *attTop1Str1xxx = [[NSMutableAttributedString alloc] initWithString:@"该签字内容将生成电子印鉴，存储至云签章系统，请确保签字内容清晰准确。本次修改即时生效，修改后将使用本次修改的签章样式，已经签章完成的项目，签章样式不会随本次修改变更。"];
//    [attTop1Str1xxx setYy_font:WY_FONTMedium(14)];
//    [attTop1Str1xxx setYy_color:[UIColor blackColor]];
//    [attTop1Strxxx appendAttributedString:attTop1Str1xxx];
//    [lblTiShi setAttributedText:attTop1Strxxx];
//    [lblTiShi setNumberOfLines:0];
//    [lblTiShi setLineBreakMode:NSLineBreakByWordWrapping];
//
//    [self.viewTop1 addSubview:lblTiShi];
    
//    float btnW = kScreenWidth - k375Width(12*2);
    
    self.btnIdCardA = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(12), k375Width(16), k375Width(115), k375Width(115))];
     
    self.btnIdCardAClose = [UIButton new];
    
    [self.btnIdCardAClose setImage:[UIImage imageNamed:@"0615_del"] forState:UIControlStateNormal];
    [self.btnIdCardAClose setFrame:CGRectMake(self.btnIdCardA.right - k375Width(10), self.btnIdCardA.top - k375Width(10), k375Width(20),k375Width(20))];
    [self.btnIdCardAClose setHidden:YES];
    [self.btnIdCardAClose addTarget:self action:@selector(btnIdCardACloseAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewTop1 addSubview:self.btnIdCardA];
    [self.viewTop1 addSubview:self.btnIdCardAClose];
    
    [self.btnIdCardA setImage:[UIImage imageNamed:@"photo_btn01"] forState:UIControlStateNormal];
 
    [self.btnIdCardA addTarget:self action:@selector(btnIdCardAAction) forControlEvents:UIControlEventTouchUpInside];
 
    
    
//    self.btnAgree = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), self.btnIdCardA.bottom + k360Width(7), k360Width(30), k360Width(30))];
//    [self.btnAgree setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
//    [self.btnAgree setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
//    [self.btnAgree.titleLabel setFont:WY_FONT375Medium(14)];
//    self.lblAgree  = [[UIButton alloc] initWithFrame:CGRectMake(self.btnAgree.right + k360Width(5), self.btnAgree.top, k360Width(250), k360Width(30))];
//    [self.lblAgree setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [self.lblAgree.titleLabel setFont:WY_FONT375Medium(14)];
//    NSMutableAttributedString *strAA = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意"];
//    NSMutableAttributedString *strBB = [[NSMutableAttributedString alloc] initWithString:@"《云签章服务协议》"];
//    [strBB setYy_color:MSTHEMEColor];
//    [strAA appendAttributedString:strBB];
//    [self.lblAgree setAttributedTitle:strAA forState:UIControlStateNormal];
//    [self.viewTop1 addSubview:self.btnAgree];
//    [self.viewTop1 addSubview:self.lblAgree];
//
//
//    [self.btnAgree addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        [self.btnAgree setSelected:!self.btnAgree.selected];
//    }];
//
//    [self.lblAgree addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
//       wk.titleStr = @"云签章服务协议";
//       wk.webviewURL = @"https://lnwlzj.capass.cn/lnwlzj/%E6%95%B0%E5%AD%97%E8%AF%81%E4%B9%A6%E6%9C%8D%E5%8A%A1%E5%8D%8F%E8%AE%AE%EF%BC%88BJCA%E5%8F%8ACFCA%EF%BC%89(1).pdf";
//       UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
//       navi.navigationBarHidden = NO;
//       navi.modalPresentationStyle = UIModalPresentationFullScreen;
//       [self presentViewController:navi animated:NO completion:nil];
//
//    }];
    
    UILabel *lblTS = [UILabel new];
    [self.viewTop1 addSubview:lblTS];
    [lblTS setFrame:CGRectMake(k360Width(16), self.btnIdCardA.bottom, kScreenWidth - k360Width(32), k360Width(30))];
    [lblTS setText:@"特别说明：该签字内容将生成电子印鉴，存储至云签章系统，请确保签字内容清晰准确。本次修改即时生效，修改后将使用本次修改的签章样式，已经签章完成的项目，签章样式不会随本次修改变更。"];
    [lblTS setFont:WY_FONT375Regular(12)];
    [lblTS setNumberOfLines:0];
    [lblTS sizeToFit];
    [lblTS setTextColor:[UIColor redColor]];
    lblTS.height += k360Width(10);
    self.viewTop1.height = lblTS.bottom + k360Width(5);
    [self.mScrollView setContentSize:CGSizeMake(0, self.viewTop1.bottom)];
}


- (UIControl *)anitCellTitle:(NSString *)titleStr byUITextField:(UITextField *)withText {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    [lblTitle setTextColor:[UIColor grayColor]];

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attStr appendAttributedString:attStr1];
//    if ([withText isEqual:self.txtzjBankAddress] || [withText isEqual:self.txtzjBankNum]) {
//        //如果是银行开户行，和银行卡号- 不是必填项， 去掉*
//        lblTitle.attributedText = attStr1;
//    } else {
        lblTitle.attributedText = attStr;
//    }
    
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [withText setTextAlignment:NSTextAlignmentRight];
    withText.placeholder = [NSString stringWithFormat:@"请输入%@",titleStr];
    [withText setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(0), k360Width(250 - 16)  , k360Width(44))];
    [withText setFont:WY_FONTRegular(14)];
     [viewTemp addSubview:withText];
     
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    return  viewTemp;
}

- (void)btnSubmitAction {
    NSLog(@"点击了提交订单");
     
    //验证- 身份证；
    if (self.userSignUrl.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传用户签名"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.userSignUrl forKey:@"signature"];
    [postDic setObject:self.dicEditInfo[@"orderNo"] forKey:@"orderNo"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_updateSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            [self.view makeToast:res[@"msg"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updatechenggong" object:nil];

            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
//    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_caCreateCa_HTTP params:nil jsonData:[postDic mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
//        if (([code integerValue] == 0) && res) {
//
//            WY_CAPdfViewController *tempController = [WY_CAPdfViewController new];
//            if ([self.isEdit isEqualToString:@"1"] || [self.isEdit isEqualToString:@"2"]) {
//                tempController.isEdit = self.isEdit;
//                tempController.dicEditInfo = self.dicEditInfo;
//            }
//            //身份证正反面
//            [postDic setObject:self.userSignUrl forKey:@"sfzzm"];
//            [postDic setObject:self.idcardImgUrlB forKey:@"sfzfm"];
//
//            tempController.dicPostCAInfo = postDic;
//            tempController.pdfUrl = res[@"data"];
//            [self.navigationController pushViewController:tempController animated:YES];
//
//        } else if ([code integerValue] == 10) {
//            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:res[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消办理" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }]];
//            [alertControl addAction:[UIAlertAction actionWithTitle:@"继续办理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                WY_CAPdfViewController *tempController = [WY_CAPdfViewController new];
//                if ([self.isEdit isEqualToString:@"1"] || [self.isEdit isEqualToString:@"2"]) {
//                    tempController.isEdit = self.isEdit;
//                    tempController.dicEditInfo = self.dicEditInfo;
//                }
//                //身份证正反面
//                [postDic setObject:self.userSignUrl forKey:@"sfzzm"];
//                [postDic setObject:self.idcardImgUrlB forKey:@"sfzfm"];
//                tempController.dicPostCAInfo = postDic;
//                tempController.pdfUrl = res[@"data"];
//                [self.navigationController pushViewController:tempController animated:YES];
//
//            }]];
//             [self presentViewController:alertControl animated:YES completion:nil];
//
//        }else {
//            [self.view makeToast:res[@"msg"]];
//        }
//    } failure:^(NSError *error) {
//        [self.view makeToast:@"请求失败，请稍后再试"];
//
//    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)btnIdCardAAction {
    //添加用户签名；
    if (self.userSignUrl.length > 0) {
        [self goImageShow:self.userSignUrl];
    } else {
        [self btnReSignAction];
//        picType = @"1";
//        [self navRightAddPhotoAction];
    }
}
- (void)btnIdCardACloseAction {
    //删除用户签名；
    [self.btnIdCardAClose setHidden:YES];
    self.userSignUrl = @"";
    [self.btnIdCardA setImage:[UIImage imageNamed:@"photo_btn01"] forState:UIControlStateNormal];
    
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

- (void)navRightAddPhotoAction {
    //上传照片
    NSLog(@"上传照片");
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"扫描拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
        //读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [SVProgressHUD showInfoWithStatus:@"应用相机权限受限,请在设置中启用"];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        
        if (self.isSBFirst) {
            [self firstAlert];
            self.isSBFirst = NO;
        } else  {
            [self takePhoto];
        }
    }];
    
    UIAlertAction *alertAct3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *alertAct4 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LocalPhoto];
        
        
    }];
    
    UIAlertControllerStyle alertStyle = UIAlertControllerStyleAlert;
    if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        alertStyle = UIAlertControllerStyleAlert;
    } else {
        alertStyle = UIAlertControllerStyleActionSheet;
    }
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:alertStyle];
    
    [alertControl addAction:alertAct];
    
    [alertControl addAction:alertAct4];
    
    [alertControl addAction:alertAct3];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}



//开始拍照
-(void)takePhoto
{
    
    OP_CameraViewController *tempController = [OP_CameraViewController new];
    tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
        [self uploadImage:imgEdit];
    };
    [self.navigationController pushViewController:tempController animated:YES];
 }
//打开本地相册
-(void)LocalPhoto

{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    //设置右侧取消按钮的字体颜色
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
    picker.navigationBar.tintColor = [UIColor redColor];
    picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    picker.navigationBar.topItem.rightBarButtonItem.tintColor = [UIColor blackColor];
 
    
}



- (void)uploadImage:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    //上传图片
    NSString * str = [GlobalConfig getAbsoluteUrl:EuploadFile_HTTP];
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
    [dicPost setObject:@"" forKey:@"description"];
    
    
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr POST:str parameters:dicPost headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
        [SVProgressHUD ms_dismiss];
        
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        NSString *picUrl = json[@"data"];
        if ([picType isEqualToString:@"1"]) {
            //身份证正面；
            self.userSignUrl = picUrl;
            [self.btnIdCardA setImage:image forState:UIControlStateNormal];
            [self.btnIdCardAClose setHidden:NO];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD ms_dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [picker dismissViewControllerAnimated:YES completion:nil];
        OP_ImageShowViewController *tempController = [OP_ImageShowViewController new];
        tempController.imgA = image;
        tempController.imgB = image;
        tempController.nsType = @"1";
        tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
            [self uploadImage:imgEdit];
        };
        [self.navigationController pushViewController:tempController animated:NO];
        return;
        
        //关闭相册界面
        
    }
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) firstAlert {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请把所要拍摄的材料放置在与拍摄背景有明显区别的环境下，如果识别不准确可点击手动拍照" preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"开始识别" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }]];
     [self presentViewController:alertControl animated:YES completion:nil];
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
            self.userSignUrl = picUrl;
            [self signBind];
        };
        tempController.modalPresentationStyle = 0;
        [self presentViewController:tempController animated:YES completion:nil];
    }]];
    [tempAlert addAction:[UIAlertAction actionWithTitle:@"上传签名采集表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WY_UpLoadSignPicViewController *tempController = [WY_UpLoadSignPicViewController new];
        tempController.popVCBlock = ^(NSString * _Nonnull picUrl, NSString * _Nonnull pdfUrl) {
            self.userSignUrl = picUrl;
//            self.mPdfUrl = pdfUrl;
            [self signBind];
        };
        [self.navigationController pushViewController:tempController animated:YES];
    }]];
    
    [self presentViewController:tempAlert animated:YES completion:nil];

    return;
    

}

- (void)signBind {
//    self.userSignUrl = picUrl;
//    [self.btnIdCardA setImage:image forState:UIControlStateNormal];
    [self.btnIdCardA sd_setImageWithURL:[NSURL URLWithString:self.userSignUrl] forState:UIControlStateNormal];
    [self.btnIdCardAClose setHidden:NO];
}
@end
