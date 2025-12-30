//
//  WY_HandleTempCAViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/15.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_HandleTempCAViewController.h"
#import "WY_SignViewController.h"
#import "WY_UpLoadSignPicViewController.h"
#import "WY_AddressManageViewController.h"

#import "ImageNewsDetailViewController.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WY_CloudSignaturePayViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "SCAP.h"
#import "CustomAlertView.h"

@interface WY_HandleTempCAViewController ()
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
@property (nonatomic , strong) UIButton *btnIdCardB;
@property (nonatomic , strong) UIButton *btnIdCardBClose;

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

//生成p10;
@property (nonatomic , strong) NSString *pkcs10;
@property (nonatomic, strong) NSMutableDictionary *dicPostCAInfo;
@end

@implementation WY_HandleTempCAViewController
@synthesize imgSel1,imgSel2,imgSel3A,imgSel4A;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"项目云签章办理";
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
    
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    if (![self.isEdit isEqualToString:@"1"] && ![self.isEdit isEqualToString:@"2"]) {
         
        [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_sysGetInfo_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            if (([code integerValue] == 0 || [code integerValue] == 1) && res) {
                WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
                self.mUser = currentUserModel;
                
                self.txtzjName.text = self.mUser.realname;
                self.txtzjIDCard.text = self.mUser.idcardnum;
                self.txtzjDanWeiName.text = self.mUser.DanWeiName;
                self.txtzjPhone.text = self.mUser.LoginID;
                self.txtzjEmail.text = self.mUser.EMail;
                
                self.userSignUrl = self.mUser.userSignature;//self.dicEditInfo[@"sfzzm"];
//                self.idcardImgUrlB = self.mUser.sfzfm;//self.dicEditInfo[@"sfzfm"];
                 
                
                if (self.userSignUrl != nil && ![self.userSignUrl isEqual:[NSNull null]] && ![self.userSignUrl isEqualToString:@""]) {
                    
                    [self.btnIdCardA sd_setImageWithURL:[NSURL URLWithString:self.userSignUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
                    [self.btnIdCardAClose setHidden:NO];
                    
//                    [self.btnIdCardB sd_setImageWithURL:[NSURL URLWithString:self.idcardImgUrlB] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
//                    [self.btnIdCardBClose setHidden:NO];

                }
                
             } else {
                [self.view makeToast:res[@"msg"]];
                 NSLog(@"没有登录, 跳转登录页");
                 NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
                 [notifyCenter postNotificationName:NOTIFY_RELOGIN object:nil];

            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"请求失败，请稍后再试"];
            NSLog(@"没有登录, 跳转登录页");
            NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
            [notifyCenter postNotificationName:NOTIFY_RELOGIN object:nil];

        }];
    } else {
        self.txtzjName.text = self.dicEditInfo[@"sqrxm"];
        self.txtzjIDCard.text = self.dicEditInfo[@"idcardnum"];
        self.txtzjDanWeiName.text = self.dicEditInfo[@"dwmc"];
        self.txtzjPhone.text = self.dicEditInfo[@"phone"];
        self.txtzjEmail.text = self.dicEditInfo[@"email"];
        self.userSignUrl = self.dicEditInfo[@"sfzzm"];
        self.idcardImgUrlB = self.dicEditInfo[@"sfzfm"];
        [self.btnIdCardA sd_setImageWithURL:[NSURL URLWithString:self.userSignUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
        [self.btnIdCardAClose setHidden:NO];
        
        [self.btnIdCardB sd_setImageWithURL:[NSURL URLWithString:self.idcardImgUrlB] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
        [self.btnIdCardBClose setHidden:NO];
 
        if ([self.dicEditInfo[@"exportType"] isEqualToString:@"bjcaImage"] || [self.dicEditInfo[@"exportType"] isEqualToString:@"bjca"]) {
            //选择的北京CA
            self.exportType = @"bjca";
            [imgSel1 setImage:[UIImage imageNamed:@"yuan2"]];
            [imgSel2 setImage:[UIImage imageNamed:@"0316_sel"]];
            [self.colEmail setHidden:YES];
            self.viewTop1.top = self.colEmail.top;
        } else {
            //选择的CFCA
            [imgSel1 setImage:[UIImage imageNamed:@"0316_sel"]];
            [imgSel2 setImage:[UIImage imageNamed:@"yuan2"]];
            [self.colEmail setHidden:NO];
            self.viewTop1.top = self.colEmail.bottom;
        }
        
        
        
    }
    [self.txtzjName setEnabled:NO];
    [self.txtzjIDCard setEnabled:NO];
    [self.txtzjPhone setEnabled:NO];
    [self.txtzjName setTextColor:HEXCOLOR(0xd8d8d8)];
    [self.txtzjIDCard setTextColor:HEXCOLOR(0xd8d8d8)];
    [self.txtzjPhone setTextColor:HEXCOLOR(0xd8d8d8)];
    
    [self.txtzjName setFont:WY_FONT375Medium(14)];
    [self.txtzjIDCard setFont:WY_FONT375Medium(14)];
    [self.txtzjPhone setFont:WY_FONT375Medium(14)];
    
    
    
    
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
     
//    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - self.viewTop.bottom - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];

    [self.view addSubview:self.mScrollView];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"提  交" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    UILabel *lblT1 = [UILabel new];
    UIView *viewSel1 = [UIView new];
    UIView *viewSel2 = [UIView new];
    UIView *viewSel3 = [UIView new];
    UILabel *lblT2 = [UILabel new];
    UILabel *lblT3 = [UILabel new];
    UILabel *lblT4 = [UILabel new];
    
    [lblT1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(32), k375Width(22))];
//    [lblT1 setText:@"办理专家CA数字证书（UKEY）"];
    
    NSMutableAttributedString *strBl = [[NSMutableAttributedString alloc] initWithString:@"项目云签章"];
    NSMutableAttributedString *strBl1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@",self.yqztdStr]];
//    [strBl1 yy_appendString:self.yqztdStr[@"codeText"]];
    
    
    [strBl setYy_font:WY_FONT375Medium(16)];
    [strBl setYy_color:HEXCOLOR(0x666666)];
    
    [strBl1 setYy_font:WY_FONT375Medium(12)];
    [strBl1 setYy_color:[UIColor redColor]];
//    [strBl appendAttributedString:strBl1];
    
    [lblT1 setAttributedText:strBl];
    [lblT1 setNumberOfLines:0];
    [lblT1 sizeToFit];
//    lblT1.height += k360Width(10);
        lblT1.height = k360Width(50);
    [self.mScrollView addSubview:lblT1];
    
    UIImageView *imgukey = [UIImageView new];
    [imgukey setFrame:CGRectMake(self.mScrollView.width - k360Width(55+16), 0, k360Width(55), k360Width(55))];
    [imgukey setImage:[UIImage imageNamed:@"0420_cloudsign_sel"]];
    [self.mScrollView addSubview:imgukey];

    
    [viewSel1 setFrame:CGRectMake(0, lblT1.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    [viewSel1 setBackgroundColor:[UIColor whiteColor]];
    
    [lblT2 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
//    [lblT2 setText:@"选择CA机构"];
    NSMutableAttributedString *t2Str1 = [[NSMutableAttributedString alloc] initWithString:@"选择云签章机构"];
    NSMutableAttributedString *t2Str2 = [[NSMutableAttributedString alloc] initWithString:@"  以下CA机构，功能相同，请自主选择"];
    [t2Str1 setYy_color:HEXCOLOR(0x434343)];
    [t2Str2 setYy_color:[UIColor redColor]];
    [t2Str1 setYy_font:WY_FONT375Medium(14)];
    [t2Str2 setYy_font:WY_FONT375Medium(12)];
//    不用加这个字了
//    [t2Str1 appendAttributedString:t2Str2];
    [lblT2 setAttributedText:t2Str1];
    [viewSel1 addSubview:lblT2];
    //等有空时把这封装单选控件； 妈的没时间弄 -- 签章服务商单选-Start
    int lastMF = lblT2.bottom + k375Width(5);
    self.arrImgMFs = [NSMutableArray new];
    //签章服务商
    for (NSDictionary *dicManufacturer in self.dicCloudSignatureType[@"manufacturer"]) {
        UIControl *col1 = [UIControl new];
        UIImageView *imgCFCA = [UIImageView new];
        UIImageView *imgSel = [UIImageView new];
        UILabel *lblCFCAName = [UILabel new];
        
        [col1 setFrame:CGRectMake(k375Width(16), lastMF, kScreenWidth - k375Width(32), k375Width(44))];
    //    [col1 setBackgroundColor:[UIColor redColor]];
        [viewSel1 addSubview:col1];
        
        [imgCFCA setFrame:CGRectMake(k375Width(16), k375Width(6), k375Width(20), k375Width(20))];
//        [imgCFCA setImage:[UIImage imageNamed:@"cfcaicon"]];
//        [imgCFCA sd_setImageWithURL:[NSURL URLWithString:dicManufacturer[@"url"]] placeholderImage:[UIImage imageNamed:@"cfcaicon"]];
        [imgCFCA sd_setImageWithURL:[NSURL URLWithString:dicManufacturer[@"url"]]];
        [col1 addSubview:imgCFCA];
        
        [lblCFCAName setFrame:CGRectMake(imgCFCA.right + k375Width(10), k375Width(6), k375Width(300), k375Width(20))];
        [lblCFCAName setText:dicManufacturer[@"codeText"]];
        [lblCFCAName setFont:WY_FONT375Regular(14)];
        [col1 addSubview:lblCFCAName];

        [imgSel setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
        [imgSel setImage:[UIImage imageNamed:@"yuan2"]];
        [col1 addSubview:imgSel];
        imgSel.tag = [dicManufacturer[@"id"] intValue];
        col1.tag = [dicManufacturer[@"id"] intValue];
        
        [self.arrImgMFs addObject:imgSel];
        WS(weakSelf);
        [col1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if ([weakSelf.isEdit isEqualToString:@"1"] || [weakSelf.isEdit isEqualToString:@"2"] || [weakSelf.notCAJG isEqualToString:@"1"]) {
                [SVProgressHUD showErrorWithStatus:@"您的订单已生成，不可修改CA机构"];
                return;
            }
            NSArray *arrmanufacturer = self.dicCloudSignatureType[@"manufacturer"];
            for (int i = 0 ; i < arrmanufacturer.count; i++) {
                NSDictionary *dicItem = arrmanufacturer[i];
                UIImageView *imgSelCurrect = self.arrImgMFs[i];
                UIControl *colSender = sender;
                if ([dicItem[@"id"] intValue] == colSender.tag) {
                    weakSelf.exportType = dicItem[@"code"];
                    weakSelf.exportTypeName = dicItem[@"codeText"];
                    
                    [imgSelCurrect setImage:[UIImage imageNamed:@"0316_sel"]];
                } else {
                    [imgSelCurrect setImage:[UIImage imageNamed:@"yuan2"]];
                }
            }
        }];
        
        lastMF = col1.bottom;
    }
    viewSel1.height = lastMF;
    
    //    设置预选
        if  (self.arrImgMFs.count > 0) {
            UIImageView *imgSelCurrect = self.arrImgMFs[0];
            [imgSelCurrect setImage:[UIImage imageNamed:@"0316_sel"]];
            self.exportType = self.dicCloudSignatureType[@"manufacturer"][0][@"code"];
            self.exportTypeName = self.dicCloudSignatureType[@"manufacturer"][0][@"codeText"];
            
        }
    
    //等有空时把这封装单选控件； 妈的没时间弄 -- 签章服务商单选-End
    
    [viewSel2 setFrame:CGRectMake(0, viewSel1.bottom + k375Width(5), kScreenWidth, k375Width(70))];
    [viewSel2 setBackgroundColor:[UIColor whiteColor]];
    
    [lblT3 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblT3 setText:@"云签章有效期"];
    [lblT3 setTextColor:HEXCOLOR(0x434343)];
    [lblT3 setFont:WY_FONT375Medium(14)];
    [viewSel2 addSubview:lblT3];

   
     //有效期 改成动态获取、
    //等有空时把这封装单选控件； 妈的没时间弄 -- 有效期单选-Start
    
    int lastVP = lblT3.bottom + k375Width(5);
    self.arrImgVPs = [NSMutableArray new];
    //有效期
    for (NSDictionary *dicValidityPeriod in self.dicCloudSignatureType[@"validityPeriod"]) {
        UIControl *col1 = [UIControl new];
        UIImageView *imgCFCA = [UIImageView new];
        UIImageView *imgSel = [UIImageView new];
        UILabel *lblCFCAName = [UILabel new];
        
        [col1 setFrame:CGRectMake(k375Width(16), lastVP, kScreenWidth - k375Width(32), k375Width(44))];
    //    [col1 setBackgroundColor:[UIColor redColor]];
        [viewSel2 addSubview:col1];
        
        [imgCFCA setFrame:CGRectMake(k375Width(16), k375Width(6), k375Width(20), k375Width(20))];
//        [imgCFCA setImage:[UIImage imageNamed:@"cfcaicon"]];
//        [imgCFCA sd_setImageWithURL:[NSURL URLWithString:dicValidityPeriod[@"url"]] placeholderImage:[UIImage imageNamed:@"cfcaicon"]];
        [imgCFCA sd_setImageWithURL:[NSURL URLWithString:dicValidityPeriod[@"url"]]];
        [col1 addSubview:imgCFCA];
        
        [lblCFCAName setFrame:CGRectMake(imgCFCA.right + k375Width(10), k375Width(6), k375Width(300), k375Width(20))];
//        [lblCFCAName setText:dicValidityPeriod[@"codeText"]];
        [lblCFCAName setText:@"当前项目可用"];
        
        [lblCFCAName setFont:WY_FONT375Regular(14)];
        [col1 addSubview:lblCFCAName];

        [imgSel setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
        [imgSel setImage:[UIImage imageNamed:@"yuan2"]];
        [col1 addSubview:imgSel];
        imgSel.tag = [dicValidityPeriod[@"id"] intValue];
        col1.tag = [dicValidityPeriod[@"id"] intValue];
        
        [self.arrImgVPs addObject:imgSel];
        WS(weakSelf);
        [col1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if ([weakSelf.isEdit isEqualToString:@"1"] || [weakSelf.isEdit isEqualToString:@"2"] || [weakSelf.notCAJG isEqualToString:@"1"]) {
                [SVProgressHUD showErrorWithStatus:@"您的订单已生成，不可修改有效期"];
                return;
            }
            NSArray *arrValidityPeriod = self.dicCloudSignatureType[@"validityPeriod"];
            for (int i = 0 ; i < arrValidityPeriod.count; i++) {
                NSDictionary *dicItem = arrValidityPeriod[i];
                UIImageView *imgSelCurrect = self.arrImgVPs[i];
                UIControl *colSender = sender;
                if ([dicItem[@"id"] intValue] == colSender.tag) {
                    weakSelf.exportVPType = dicItem[@"code"];
                    weakSelf.exportVPTypeName = dicItem[@"codeText"];
                    [imgSelCurrect setImage:[UIImage imageNamed:@"0316_sel"]];
                } else {
                    [imgSelCurrect setImage:[UIImage imageNamed:@"yuan2"]];
                }
            }
        }];
        
        lastVP = col1.bottom;
    }
    viewSel2.height = lastVP;
    
//    设置预选
    if  (self.arrImgVPs.count > 0) {
        UIImageView *imgSelCurrect = self.arrImgVPs[0];
        [imgSelCurrect setImage:[UIImage imageNamed:@"0316_sel"]];
        self.exportVPType = self.dicCloudSignatureType[@"validityPeriod"][0][@"code"];
        self.exportVPTypeName = self.dicCloudSignatureType[@"validityPeriod"][0][@"codeText"];
        
    }

    
    //等有空时把这封装单选控件； 妈的没时间弄 -- 有效期单选-End
//    选择专家类型隐藏了
//    [viewSel3 setFrame:CGRectMake(0, viewSel2.bottom + k375Width(5), kScreenWidth, k375Width(70))];
//    [viewSel3 setBackgroundColor:[UIColor whiteColor]];
//
//    [self initZJTypeView:lblT4 viewSel3:viewSel3];
    
 
    
    [self.mScrollView addSubview:viewSel1];
    [self.mScrollView addSubview:viewSel2];
//    [self.mScrollView addSubview:viewSel3];
    
    lastY = viewSel2.bottom + k375Width(10);
    self.txtzjName = [UITextField new];
    self.txtzjIDCard = [UITextField new];
    self.txtzjDanWeiName = [UITextField new];
    self.txtzjDanWeiCity = [UITextField new];
    self.txtzjDanWeiAddress = [UITextField new];
    self.txtzjPhone = [UITextField new];
    self.txtzjEmail = [UITextField new];
    self.txtzjPostCode= [UITextField new];
    
    [self anitCellTitle:@"申请人姓名" byUITextField:self.txtzjName];
    [self anitCellTitle:@"身份证号" byUITextField:self.txtzjIDCard];
    [self anitCellTitle:@"手机号码" byUITextField:self.txtzjPhone];
    [self anitCellTitle:@"单位名称" byUITextField:self.txtzjDanWeiName];
//    [self anitCellTitle:@"通讯地址" byUITextField:self.txtzjDanWeiAddress];
    self.colEmail =  [self anitCellTitle:@"邮箱" byUITextField:self.txtzjEmail];
//    [self anitCellTitle:@"邮政编码" byUITextField:self.txtzjPostCode];
    
    
    self.viewTop1 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k375Width(180 + 30+30))];
    [self.viewTop1 setBackgroundColor:[UIColor whiteColor]];
    [self.mScrollView addSubview:self.viewTop1];
    [self.mScrollView setContentSize:CGSizeMake(0, self.viewTop1.bottom)];
    UILabel *lblTop1Ts = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth, k375Width(44))];
    [lblTop1Ts setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_font:WY_FONTMedium(14)];

    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"个人手写签字（1张）"];
    [attStr1 setYy_font:WY_FONTMedium(14)];
    [attStr1 setYy_color:[UIColor blackColor]];
    [attStr appendAttributedString:attStr1];
    lblTop1Ts.attributedText = attStr;
    [self.viewTop1 addSubview:lblTop1Ts];
    
    self.btnIdCardA = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(12), lblTop1Ts.bottom + k375Width(10), k375Width(115), k375Width(115))];
    
    
    self.btnIdCardAClose = [UIButton new];
    self.btnIdCardBClose = [UIButton new];
    
    [self.btnIdCardAClose setImage:[UIImage imageNamed:@"0615_del"] forState:UIControlStateNormal];
    [self.btnIdCardAClose setFrame:CGRectMake(self.btnIdCardA.right - k375Width(10), self.btnIdCardA.top - k375Width(10), k375Width(20),k375Width(20))];
    [self.btnIdCardAClose setHidden:YES];
    [self.btnIdCardAClose addTarget:self action:@selector(btnIdCardACloseAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnIdCardB = [[UIButton alloc] initWithFrame:CGRectMake(self.btnIdCardA.right + k375Width(24), lblTop1Ts.bottom + k375Width(10), k375Width(165), k375Width(115))];
    
    [self.btnIdCardBClose setImage:[UIImage imageNamed:@"0615_del"] forState:UIControlStateNormal];
    [self.btnIdCardBClose addTarget:self action:@selector(btnIdCardBCloseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnIdCardBClose setFrame:CGRectMake(self.btnIdCardB.right - k375Width(10), self.btnIdCardB.top - k375Width(10), k375Width(20),k375Width(20))];
    [self.btnIdCardBClose setHidden:YES];
    
    [self.viewTop1 addSubview:self.btnIdCardA];
//    [self.viewTop1 addSubview:self.btnIdCardB];
    [self.viewTop1 addSubview:self.btnIdCardAClose];
//    [self.viewTop1 addSubview:self.btnIdCardBClose];
    
    [self.btnIdCardA setImage:[UIImage imageNamed:@"photo_btn01"] forState:UIControlStateNormal];
    [self.btnIdCardB setImage:[UIImage imageNamed:@"0407_renxiang"] forState:UIControlStateNormal];
    
    [self.btnIdCardA addTarget:self action:@selector(btnIdCardAAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnIdCardB addTarget:self action:@selector(btnIdCardBAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnAgree = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), self.btnIdCardB.bottom + k360Width(7), k360Width(30), k360Width(30))];
    [self.btnAgree setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnAgree setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnAgree.titleLabel setFont:WY_FONT375Medium(14)];
    self.lblAgree  = [[UIButton alloc] initWithFrame:CGRectMake(self.btnAgree.right + k360Width(5), self.btnAgree.top, k360Width(250), k360Width(30))];
    [self.lblAgree setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.lblAgree.titleLabel setFont:WY_FONT375Medium(14)];
    NSMutableAttributedString *strAA = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意"];
    NSMutableAttributedString *strBB = [[NSMutableAttributedString alloc] initWithString:@"《安心签平台服务协议》"];
    [strBB setYy_color:MSTHEMEColor];
    [strAA appendAttributedString:strBB];
    [self.lblAgree setAttributedTitle:strAA forState:UIControlStateNormal];
    [self.viewTop1 addSubview:self.btnAgree];
    [self.viewTop1 addSubview:self.lblAgree];
    
    self.lblAgree1  = [[UIButton alloc] initWithFrame:CGRectMake(self.btnAgree.right + k360Width(5), self.lblAgree.bottom, k360Width(350), k360Width(30))];
    [self.lblAgree1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.lblAgree1.titleLabel setFont:WY_FONT375Medium(14)];
    NSMutableAttributedString *strAA1 = [[NSMutableAttributedString alloc] initWithString:@"               "];
    NSMutableAttributedString *strBB1 = [[NSMutableAttributedString alloc] initWithString:@"《CFCA数字证书服务协议》"];
    [strBB1 setYy_color:MSTHEMEColor];
    [strAA1 appendAttributedString:strBB1];
    [self.lblAgree1 setAttributedTitle:strAA1 forState:UIControlStateNormal];
     [self.viewTop1 addSubview:self.lblAgree1];
 
    [self.lblAgree1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
       wk.titleStr = @"CFCA数字证书服务协议";
       wk.webviewURL = @"https://www.capass.cn/Avatar/cfca_cloud.pdf";
       UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
       navi.navigationBarHidden = NO;
       navi.modalPresentationStyle = UIModalPresentationFullScreen;
       [self presentViewController:navi animated:NO completion:nil];

    }];

//    [self.btnAgree setSelected:YES];
    
    [self.btnAgree addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.btnAgree setSelected:!self.btnAgree.selected];
    }];
    
    [self.lblAgree addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
       wk.titleStr = @"安心签平台服务协议";
       wk.webviewURL = @"https://www.capass.cn/Avatar/axq_cloud.pdf";
       UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
       navi.navigationBarHidden = NO;
       navi.modalPresentationStyle = UIModalPresentationFullScreen;
       [self presentViewController:navi animated:NO completion:nil];

    }];
    
//    UILabel *lblTS = [UILabel new];
//    [self.viewTop1 addSubview:lblTS];
//    [lblTS setFrame:CGRectMake(k360Width(16), self.lblAgree.bottom, kScreenWidth - k360Width(32), k360Width(30))];
//    [lblTS setText:@"特别说明：为了提供更好数据共享服务，压缩办理流程、时限，减少材料重复提供，加强个人信息保密，各位专家可根据各主管部门的电子化要求，自愿选择此便捷渠道申请办理互联互通专家（CA）数字证书（可互联互通辽宁建设工程信息网及辽宁政府采购网）"];
//    [lblTS setFont:WY_FONT375Regular(12)];
//    [lblTS setNumberOfLines:0];
//    [lblTS sizeToFit];
//    [lblTS setTextColor:[UIColor redColor]];
//    lblTS.height += k360Width(10);
//    self.viewTop1.height = lblTS.bottom + k360Width(5);
//    [self.mScrollView setContentSize:CGSizeMake(0, self.viewTop1.bottom)];
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


- (void)btnSubmitAction {
    NSLog(@"点击了提交订单");
    if (!self.btnAgree.selected) {
        [SVProgressHUD showErrorWithStatus:@"请您阅读并同意《安心签平台服务协议》和《CFCA数字证书服务协议》"];
        return;
    }
    if (self.txtzjDanWeiName.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtzjDanWeiName.placeholder];
        [self.txtzjDanWeiName becomeFirstResponder];
        return;
    }
//    if (self.txtzjDanWeiAddress.text.length <= 0) {
//        [SVProgressHUD showErrorWithStatus:self.txtzjDanWeiAddress.placeholder];
//        [self.txtzjDanWeiAddress becomeFirstResponder];
//        return;
//    }
    if (self.txtzjPhone.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtzjPhone.placeholder];
        [self.txtzjPhone becomeFirstResponder];
        return;
    }
    if (self.txtzjEmail.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtzjEmail.placeholder];
        [self.txtzjEmail becomeFirstResponder];
        return;
    }
    if ( ![GlobalConfig isValidateEmail:self.txtzjEmail.text]) {
        [SVProgressHUD showErrorWithStatus:@"邮箱格式不正确"];
        [self.txtzjEmail becomeFirstResponder];
        return;
    }
     
    //验证- 身份证；
    if (self.userSignUrl.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传用户签名"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.exportType forKey:@"manufacturer"];
    [postDic setObject:self.exportVPType forKey:@"validityPeriod"];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getCloudSignaturePrice_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            
            NSMutableDictionary *postDic = [NSMutableDictionary new];
            
            
            
            NSMutableDictionary *dicCAInfo = [NSMutableDictionary new];
            [postDic setObject:dicCAInfo forKey:@"dicCAInfo"];
            
            [dicCAInfo setObject:res[@"data"] forKey:@"money"];
            [dicCAInfo setObject:self.exportTypeName forKey:@"caName"];
            [dicCAInfo setObject:self.exportVPTypeName forKey:@"yxqName"];
            [dicCAInfo setObject:self.exportType forKey:@"manufacturer"];
            [dicCAInfo setObject:self.exportVPType forKey:@"validityPeriod"];
            
            [dicCAInfo setObject:self.txtzjPhone.text forKey:@"phoneNumber"];
            [dicCAInfo setObject:self.txtzjName.text forKey:@"userName"];
             [dicCAInfo setObject:self.txtzjIDCard.text forKey:@"identification"];
            [dicCAInfo setObject:self.txtzjDanWeiName.text forKey:@"companyName"];
            [dicCAInfo setObject:self.txtzjEmail.text forKey:@"email"];
             [dicCAInfo setObject:self.exportType forKey:@"exportType"];
           [dicCAInfo setObject:self.userSignUrl forKey:@"signature"];
            
            self.dicPostCAInfo =postDic;
            [self btnSubmitActionA];
//            WY_CloudSignaturePayViewController *tempController = [WY_CloudSignaturePayViewController new];
//            tempController.dicPostCAInfo = postDic;
//            if ([self.isEdit isEqualToString:@"1"] || [self.isEdit isEqualToString:@"2"]) {
//                tempController.isEdit = self.isEdit;
//                tempController.dicEditInfo = self.dicEditInfo;
//            }
//            [self.navigationController pushViewController:tempController animated:YES];
             

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
- (void)btnIdCardBCloseAction {
    //删除用户签名；
    [self.btnIdCardBClose setHidden:YES];
    self.idcardImgUrlB = @"";
    [self.btnIdCardB setImage:[UIImage imageNamed:@"0407_renxiang"] forState:UIControlStateNormal];
}



- (void)btnIdCardBAction {
    //添加身份证B面；
    if (self.idcardImgUrlB.length > 0) {
        [self goImageShow:self.idcardImgUrlB];
    } else {
        picType = @"2";
        [self navRightAddPhotoAction];
    }
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
            
        } else  if ([picType isEqualToString:@"2"]) {
            //身份证反面；
            self.idcardImgUrlB = picUrl;
            [self.btnIdCardB setImage:image forState:UIControlStateNormal];
            [self.btnIdCardBClose setHidden:NO];
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


/*提交按钮点击后事件*/

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
- (void)btnSubmitActionA {
    NSLog(@"点击了提交订单");
    
    // -在这之前还得弹个签字确认框；
    CustomAlertView *alert = [[CustomAlertView alloc] initWithAlertViewHeight:k360Width(400) withImage:self.dicPostCAInfo[@"dicCAInfo"][@"signature"] withTitle:@"请再次确认您本次提交办理的“云签章”适用于辽宁省工程建设项目数字化开标评标系统，且签字完整清晰。"];
    
    alert.ButtonClick = ^void(UIButton*button){
        NSLog(@"%ld",(long)button.tag);
        if (button.tag==100) {
            //look  rili
            [self submitFrom];
        } else {

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
//    if (self.btnFpYes.selected) {
//        [postDic setObject:@"1" forKey:@"invoice"];
//    } else {
//        [postDic setObject:@"2" forKey:@"invoice"];
//    }
    
    [postDic setObject:self.pkcs10 forKey:@"pkcs10"];
    
    [postDic setObject:self.pID forKey:@"id"];
    //增加个expertId - 刘林说的
    [postDic setObject:self.expertId forKey:@"expertId"];
    
//    zj_handleCloudSignature_HTTP
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_handleProjectCloudSignature_HTTP params:nil jsonData:[postDic mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"项目云签章申请成功，请前往使用" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    return;
}

@end
