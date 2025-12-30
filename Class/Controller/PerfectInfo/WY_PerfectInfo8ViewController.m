//
//  WY_PerfectInfo8ViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_PerfectInfo8ViewController.h"
#import "WY_selPicView.h"
#import "WY_SelMajorView.h"
#import "ImageNewsDetailViewController.h"
#import "WY_ParamExpertModel.h"
#import "SLCustomActivity.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MS_WKwebviewsViewController.h"

#import "UIBarButtonItem+Extension.h"

@interface WY_PerfectInfo8ViewController ()
{
    int lastY;
    NSString *picType;
    
    UIView *pdfView;
    UIButton *btnLeft;
    UIButton *btnRight;
    NSString *isAgree;
    NSString *titleStr;
}
@property (nonatomic , strong) UIView *viewTop;
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic , strong) UIButton *btnUp;
@property (nonatomic , strong)UIButton *btnAgree;

@property (nonatomic , strong) UILabel *lblzjSex;
@property (nonatomic , strong) UILabel *lblzjCardType;
@property (nonatomic , strong) UITextField *txtzjName;
@property (nonatomic , strong) UITextField *txtzjIDCard;
@property (nonatomic , strong) UITextField *txtzjPhone;
@property (nonatomic , strong) UITextField *txtzjDanWeiName;
@property (nonatomic , strong) UITextField *txtzjBankNum;

//--
@property (nonatomic , strong) UIView *viewTop1;
@property (nonatomic , strong) UIView *viewTop2;
@property (nonatomic , strong) UIView *viewTop3A;
@property (nonatomic , strong) UIView *viewTop4A;
@property (nonatomic , strong) UIView *viewTop3;
@property (nonatomic , strong) UIView *viewTop5;
@property (nonatomic , strong) UIView *viewMiddle;
@property (nonatomic , strong) UIButton *btnIdCardA;
@property (nonatomic , strong) UIButton *btnIdCardAClose;
@property (nonatomic , strong) UIButton *btnIdCardB;
@property (nonatomic , strong) UIButton *btnIdCardBClose;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop2;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop3;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop3A;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop4A;
//续聘
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop5;



/// 社保卡-退休证明
@property (nonatomic , strong) NSMutableArray *arrImgUrls;
@property (nonatomic , strong) NSMutableArray *arrBaoZhengImgUrls;
@property (nonatomic , strong) NSMutableArray *arrBaoZhengAImgUrls;
@property (nonatomic , strong) NSMutableArray *arrXuPinImgUrls;
//调整申报
@property (nonatomic , strong) NSMutableArray *arrTiaoZhengSBImgUrls;
@property (nonatomic , strong) NSMutableArray *arrMajors;
@property (nonatomic , strong) NSString *idcardImgUrlA;
@property (nonatomic , strong) NSString *idcardImgUrlB;
@property (nonatomic , strong) WY_SelMajorView *selSMView;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic) BOOL isSBFirst;

@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic) int alStatus;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic) BOOL canEdit;
@property (nonatomic) BOOL canBFEdit;


/// 用户协议
@property (nonatomic, strong) UILabel *userAgrLab;

/// 用户协议按钮
@property (nonatomic, strong) UIButton *userAgrBtn;

//提交参数封装
@property (nonatomic, strong) WY_ParamExpertModel *mStorageWY_ParamExpertModel;

@end

@implementation WY_PerfectInfo8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (self.approvalStatusNum) {
        case 1:
        case 2:
        case 3:
        case 7:
        {
            self.reason = @"审核中不可修改";
            self.canEdit = NO;
        }
            break;
        case 5:
        {
            self.reason = @"资质不符不可修改";
            self.canEdit = NO;
        }
            break;
        case 101:
        {
            self.reason = @"专家管理属地变更核验中暂不可修改";
            self.canEdit = NO;
        }
            break;
        case 4:
        {
            self.reason = @"审核通过，暂时无法修改信息";
            //            2021-07-20 11:16:13 - 需求 - 审核通过后- 也可以重新修改信息 重新提交审核
            self.canEdit = NO;
            if ((self.isFormal == 1 || self.isFormal == 2)) {
                self.reason = @"可以修改";
                //审核通过后并且是正式专家 - 改成 可以修改了；
                self.canEdit = YES;
                self.canBFEdit = YES;
            }
        }
            break;
        case 0:
        case 6:
        {
            self.canEdit = YES;
        }
            break;
        case 10:{
            self.reason = @"基本信息审核通过，无法修改信息";
            self.canEdit = YES;
            self.canBFEdit = YES;
        }
            break;
        default:
            break;
    }
    
    self.isSBFirst = YES;
    [self makeUI];
    [self bindView];
    
    // 记录暂存数据
    [self recordStaging];
}

/// 记录暂存数据
- (void)recordStaging {
    
    WY_ParamExpertModel *paramModel = [WY_ParamExpertModel new];
    WY_ExpertMessageModel *expModel = self.mStorageWY_ExpertMessageModel;
    
    @try {
        
        if (![self EncapsulationSubmissionParameters:expModel paramModel:paramModel]) {
            return;
        }
        self.mStorageWY_ParamExpertModel = paramModel;
    } @catch (NSException *exception) {
        self.mStorageWY_ParamExpertModel = paramModel;
    }
    
}

- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"白返回" highImage:@"返回" ];
    
    
    self.cancleButton = [[UIButton alloc] init];
    self.cancleButton.frame = CGRectMake(0, 0, 50, 30);
    [self.cancleButton setTitle:@" 下载模板 " forState:UIControlStateNormal];
    [self.cancleButton.titleLabel setFont:WY_FONT375Medium(12)];
    [self.cancleButton setBackgroundColor:[UIColor whiteColor]];
    [self.cancleButton setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [self.cancleButton rounded:8];
    [self.cancleButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k375Width(63))];
    [self.viewTop setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    [self.view addSubview:self.viewTop];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(k375Width(46), k375Width(16.5), k375Width(30), k375Width(30))];
    UILabel *lbltop1 = [[UILabel alloc] initWithFrame:CGRectMake(img1.right + k375Width(5), 0, k375Width(70), k375Width(16))];
    UILabel *lbltop2 = [[UILabel alloc] initWithFrame:CGRectMake(lbltop1.right + k375Width(5), 0, k375Width(70), k375Width(16))];
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(lbltop2.right + k375Width(5), k375Width(16.5), k375Width(30), k375Width(30))];
    [img1 setImage:[UIImage imageNamed:@"0611_ws1"]];
    [img2 setImage:[UIImage imageNamed:@"0611_ws2"]];
    UILabel *lbltop3 = [[UILabel alloc] initWithFrame:CGRectMake(img2.right + k375Width(5), 0, k375Width(70), k375Width(16))];
    
    [self.viewTop addSubview:img1];
    [self.viewTop addSubview:img2];
    [self.viewTop addSubview:lbltop1];
    [self.viewTop addSubview:lbltop2];
    [self.viewTop addSubview:lbltop3];
    
    img2.centerY = img1.centerY;
    lbltop1.centerY = img1.centerY;
    lbltop2.centerY = img1.centerY;
    lbltop3.centerY = img1.centerY;
    
    
    [lbltop1 setTextColor:HEXCOLOR(0x0F6DD2)];
    [lbltop2 setTextColor:HEXCOLOR(0x0F6DD2)];
    [lbltop3 setTextColor:HEXCOLOR(0x0F6DD2)];
    
    [lbltop1 setFont:WY_FONT375Medium(16)];
    [lbltop2 setFont:WY_FONT375Medium(12)];
    [lbltop3 setFont:WY_FONT375Medium(16)];
    
    [lbltop1 setText:@"基础认证"];
    [lbltop2 setText:@"••••••••••"];
    [lbltop3 setText:@"资格认证"];
    
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - self.viewTop.bottom - JCNew64 - k360Width(58) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    self.btnAgree = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(70), self.mScrollView.bottom + k375Width(7), k375Width(30), k375Width(30))];
    [self.btnAgree setImage:[UIImage imageNamed:@"icon_checkbox_s"] forState:UIControlStateNormal];
    [self.btnAgree setImage:[UIImage imageNamed:@"icon_checkbox_lxx"] forState:UIControlStateSelected];
    [self.btnAgree setTitle:@"" forState:UIControlStateNormal];
    [self.btnAgree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAgree.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    [self.btnAgree addTarget:self action:@selector(btnAgreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAgree.titleLabel setFont:WY_FONTMedium(14)];
    
    self.btnAgree.selected = YES;
    [self.view addSubview:self.btnAgree];
    
    [self.userAgrLab setFrame:CGRectMake(self.btnAgree.right, self.btnAgree.top, k360Width(200), self.btnAgree.height)];
    [self.userAgrBtn setFrame:self.userAgrLab.bounds];
    [self.view addSubview:self.userAgrLab];
    [self.userAgrLab addSubview:self.userAgrBtn];
    
    [self.btnAgree setHidden:YES];
    [self.userAgrLab setHidden:YES];
    [self.userAgrBtn setHidden:YES];
    
    
    //    self.btnAgree.centerX = self.mScrollView.centerX;
    
    self.btnUp = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(15), self.mScrollView.bottom + k375Width(7), (kScreenWidth - k375Width(15*3)) / 2, k360Width(44))];
    [self.btnUp setTitle:@"上一步" forState:UIControlStateNormal];
    [self.btnUp setBackgroundColor:MSTHEMEColor];
    [self.btnUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnUp rounded:k360Width(44)/8];
    [self.btnUp.titleLabel setFont:WY_FONTMedium(14)];
    
    [self.btnUp addTarget:self action:@selector(btnUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnUp];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(self.btnUp.right + k375Width(15), self.mScrollView.bottom +  k375Width(7), (kScreenWidth - k375Width(15*3)) / 2, k360Width(44))];
    [self.btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    if (self.approvalStatusNum == 0 ||  self.approvalStatusNum == 6 ||  self.approvalStatusNum == 10|| self.approvalStatusNum == 4) {
        [self.btnSubmit setHidden:NO];
    } else {
        //        [self.btnSubmit setHidden:YES];
        //           self.btnUp.width = kScreenWidth -k375Width(30);
        [self.btnSubmit setBackgroundColor:HEXCOLOR(0xb1b1b1)];
        //        [self.btnSubmit setUserInteractionEnabled:NO];
    }
    [self initScrViews];
}
- (void)backAction {
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"返回后您已经填写的信息将不会被保存，您确定返回吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertControl animated:YES completion:nil];
    
    
}
- (UILabel *)userAgrLab {
    if (!_userAgrLab) {
        _userAgrLab = [[UILabel alloc] init];
        
        NSString *contentStr = @"已阅读并同意";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [str setYy_color:[UIColor blackColor]];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:@"《专家信息修改说明》"];
        [str1 setYy_color:MSTHEMEColor];
        [str appendAttributedString:str1];
        _userAgrLab.attributedText = str;
        _userAgrLab.font = WY_FONTRegular(12);
        _userAgrLab.userInteractionEnabled = YES;
    }
    return _userAgrLab;
}


- (UIButton *)userAgrBtn {
    if (!_userAgrBtn) {
        _userAgrBtn = [[UIButton alloc] init];
        [_userAgrBtn addTarget:self action:@selector(userAgrBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAgrBtn;
}


#pragma mark --协议文字点击
- (void)userAgrBtnTouchUpInside:(UIButton *)sender {
    
    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
    wk.titleStr = @"专家信息修改说明";
    wk.webviewURL = @"https://www.capass.cn/Avatar/zjxxxgsm.pdf";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
    navi.navigationBarHidden = NO;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
    
}
- (void)bindView {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    
    NSMutableArray *idCardEles = [[NSMutableArray alloc] initWithArray:[self.mWY_ExpertMessageModel.idCardEle componentsSeparatedByString:@","]];
    if (idCardEles.count == 2) {
        self.idcardImgUrlA = idCardEles[0];
        self.idcardImgUrlB = idCardEles[1];
        
        [self.btnIdCardA sd_setImageWithURL:[NSURL URLWithString:self.idcardImgUrlA] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
        [self.btnIdCardAClose setHidden:NO];
        
        [self.btnIdCardB sd_setImageWithURL:[NSURL URLWithString:self.idcardImgUrlB] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
        [self.btnIdCardBClose setHidden:NO];
        
    }
    
    //绑定社保照片；
    self.arrImgUrls = [[NSMutableArray alloc] initWithArray:[self.mWY_ExpertMessageModel.socialSecurityEle componentsSeparatedByString:@","]];
    [self initSheBaoImgs];
    
    
    if ([self.isNewExpert intValue] == 1) {
        //绑定保证书A照片；
        self.arrBaoZhengAImgUrls = [[NSMutableArray alloc] initWithArray:[self.mWY_ExpertMessageModel.inDoor componentsSeparatedByString:@","]];
        [self initBaoZhengAImgs];
    }
    
    if ([self.isRenewalFlag intValue] == 1) {
        //续聘照片；
        self.arrXuPinImgUrls = [[NSMutableArray alloc] initWithArray:[self.mWY_ExpertMessageModel.pendingmentEleNew componentsSeparatedByString:@","]];
        [self initXuPinImgs];
    }
    
    
    if (self.isFormal == 1 || self.isFormal == 2) {
        //调整申报表
        self.arrTiaoZhengSBImgUrls = [[NSMutableArray alloc] initWithArray:[self.mWY_ExpertMessageModel.alterZy componentsSeparatedByString:@","]];
        [self initTiaoZhengSBImgs];
    }
     
    
    //绑定保证书照片；
    self.arrBaoZhengImgUrls = [[NSMutableArray alloc] initWithArray:[self.mWY_ExpertMessageModel.commitmentEleNew componentsSeparatedByString:@","]];
    [self initBaoZhengImgs];
    
    
    //绑定专业
    self.arrMajors = [[NSMutableArray alloc] initWithArray:self.mWY_ExpertMessageModel.expertProfessions];
    
    [self initMajorViews];
}

- (void)initScrViews {
    [self.mScrollView removeAllSubviews];
    
    self.viewTop1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k375Width(180))];
    self.viewTop2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewTop1.bottom + k375Width(10), kScreenWidth, k375Width(150))];
    
    
    self.viewTop3A = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewTop2.bottom + k375Width(10), kScreenWidth, k375Width(150))];
    
    
    int lastJBY =self.viewTop2.bottom + k375Width(10);
    if ([self.isNewExpert intValue] == 1) {
        //需要添加新入库申请表
        [self.viewTop3A setHidden:NO];
        lastJBY =self.viewTop3A.bottom + k375Width(10);
    } else {
        [self.viewTop3A setHidden:YES];
    }
    
    //TODO  从这里加续聘的 VIEW
    self.viewTop5 = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewTop3A.isHidden ? self.viewTop2.bottom + k375Width(10) : self.viewTop3A.bottom + k375Width(10), kScreenWidth, k375Width(150))];
    if([self.isRenewalFlag  isEqualToString:@"1"]) {
        [self.viewTop5 setHidden:NO];
        lastJBY =self.viewTop5.bottom + k375Width(10);
    } else {
        [self.viewTop5 setHidden:YES];
    }
    
    //是正式专家-并且 不是新入库专家和 不是续聘专家- 才显示 专业调整申报表；
        if ((self.isFormal == 1 || self.isFormal == 2) && ![self.isRenewalFlag  isEqualToString:@"1"] && ![self.isNewExpert  isEqualToString:@"1"]) {
               self.viewTop4A = [[UIView alloc] initWithFrame:CGRectMake(0, lastJBY, kScreenWidth, k375Width(150))];
                 self.viewTop3 = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewTop4A.bottom + k375Width(10), kScreenWidth, k375Width(150))];
            [self.viewTop4A setHidden:NO];
    
        } else {
            [self.viewTop4A setHidden:YES];
            self.viewTop3 = [[UIView alloc] initWithFrame:CGRectMake(0, lastJBY , kScreenWidth, k375Width(150))];
        }
    
    
    
    [self.viewTop1 setBackgroundColor:[UIColor whiteColor]];
    [self.viewTop2 setBackgroundColor:[UIColor whiteColor]];
    [self.viewTop3 setBackgroundColor:[UIColor whiteColor]];
    [self.viewTop3A setBackgroundColor:[UIColor whiteColor]];
    [self.viewTop4A setBackgroundColor:[UIColor whiteColor]];
    [self.viewTop5 setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [self.mScrollView addSubview:self.viewTop1];
    [self.mScrollView addSubview:self.viewTop2];
    [self.mScrollView addSubview:self.viewTop3];
    [self.mScrollView addSubview:self.viewTop3A];
    [self.mScrollView addSubview:self.viewTop5];
    [self.mScrollView addSubview:self.viewTop4A];
    
    self.viewMiddle = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewTop3.bottom + k375Width(10), kScreenWidth, k375Width(200))];
    [self.viewMiddle setBackgroundColor:[UIColor whiteColor]];
    [self.mScrollView addSubview:self.viewMiddle];
    
    UILabel *lblTop1Ts = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth, k375Width(44))];
    [lblTop1Ts setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_font:WY_FONTMedium(14)];
    
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"请拍摄并上传您的证件照片"];
    [attStr1 setYy_font:WY_FONTMedium(14)];
    [attStr1 setYy_color:[UIColor blackColor]];
    [attStr appendAttributedString:attStr1];
    lblTop1Ts.attributedText = attStr;
    [self.viewTop1 addSubview:lblTop1Ts];
    
    self.btnIdCardA = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(12), lblTop1Ts.bottom + k375Width(10), k375Width(165), k375Width(115))];
    
    
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
    [self.viewTop1 addSubview:self.btnIdCardB];
    [self.viewTop1 addSubview:self.btnIdCardAClose];
    [self.viewTop1 addSubview:self.btnIdCardBClose];
    
    [self.btnIdCardA setImage:[UIImage imageNamed:@"0616_IDCardB"] forState:UIControlStateNormal];
    [self.btnIdCardB setImage:[UIImage imageNamed:@"0616_IDCardA"] forState:UIControlStateNormal];
    
    [self.btnIdCardA addTarget:self action:@selector(btnIdCardAAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnIdCardB addTarget:self action:@selector(btnIdCardBAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lblTop2Ts = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop2Ts setNumberOfLines:2];
    [lblTop2Ts setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop2Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attTop2Str setYy_font:WY_FONTMedium(14)];
    [attTop2Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop2Str1 = [[NSMutableAttributedString alloc] initWithString:@"请拍摄并上传您的社保证明/退休证(样式见右上角下载模板)"];
    [attTop2Str1 setYy_font:WY_FONTMedium(14)];
    [attTop2Str1 setYy_color:[UIColor blackColor]];
    
    [attTop2Str appendAttributedString:attTop2Str1];
    
    lblTop2Ts.attributedText = attTop2Str;
    
    
    [self.viewTop2 addSubview:lblTop2Ts];
    
    self.scrollViewImgsTop2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop2 addSubview:self.scrollViewImgsTop2];
    
    
    UILabel *lblTop3ATs = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop3ATs setNumberOfLines:2];
    [lblTop3ATs setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop3AStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attTop3AStr setYy_font:WY_FONTMedium(14)];
    [attTop3AStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop3AStr1 = [[NSMutableAttributedString alloc] initWithString:@"请上传新入库评审专家库专家申请表(格式见右上角下载模板)"];
    [attTop3AStr1 setYy_font:WY_FONTMedium(14)];
    [attTop3AStr1 setYy_color:[UIColor blackColor]];
    [attTop3AStr appendAttributedString:attTop3AStr1];
    lblTop3ATs.attributedText = attTop3AStr;
    [self.viewTop3A addSubview:lblTop3ATs];
    self.scrollViewImgsTop3A = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop3A addSubview:self.scrollViewImgsTop3A];
    
    
    UILabel *lblTop5Ts = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop5Ts setNumberOfLines:2];
    [lblTop5Ts setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop5Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attTop5Str setYy_font:WY_FONTMedium(14)];
    [attTop5Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop5Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传辽宁省综合评标专家库续聘专家申请表 (格式见右上角下载模板)"];
    [attTop5Str1 setYy_font:WY_FONTMedium(14)];
    [attTop5Str1 setYy_color:[UIColor blackColor]];
    [attTop5Str appendAttributedString:attTop5Str1];
    lblTop5Ts.attributedText = attTop5Str;
    [self.viewTop5 addSubview:lblTop5Ts];
    self.scrollViewImgsTop5 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop5 addSubview:self.scrollViewImgsTop5];
    
    
    
    
    // 2023-03-02 16:08:27 - 佟哥说 这批已经完事了，后面没用了 不再显示调整申报表 也不再处理相关判断
    /// 2024-06-05 10:49:24 - 佟哥又说， 现在又要开放此功能  - 2024年的- 打开了上传 调整申报表
        UILabel *lblTop4ATs = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
        [lblTop4ATs setNumberOfLines:2];
        [lblTop4ATs setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
        NSMutableAttributedString *attTop4AStr = [[NSMutableAttributedString alloc] initWithString:@""];
        [attTop4AStr setYy_font:WY_FONTMedium(14)];
        [attTop4AStr setYy_color:[UIColor redColor]];
        NSMutableAttributedString *attTop4AStr1 = [[NSMutableAttributedString alloc] initWithString:@"请上传《辽宁省综合评标专家库专家专业调整申报表》（格式见右上角下载模板）（不修改专业可不传此项）"];
        [attTop4AStr1 setYy_font:WY_FONTMedium(14)];
        [attTop4AStr1 setYy_color:[UIColor blackColor]];
        [attTop4AStr appendAttributedString:attTop4AStr1];
        lblTop4ATs.attributedText = attTop4AStr;
        [self.viewTop4A addSubview:lblTop4ATs];
        self.scrollViewImgsTop4A = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
        [self.viewTop4A addSubview:self.scrollViewImgsTop4A];
    //
    
    
    UILabel *lblTop3Ts = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop3Ts setNumberOfLines:2];
    [lblTop3Ts setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop3Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attTop3Str setYy_font:WY_FONTMedium(14)];
    [attTop3Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop3Str1 = [[NSMutableAttributedString alloc] initWithString:@"请下载打印模板，签字并拍照上传承诺书(格式见右上角下载模板)"];
    [attTop3Str1 setYy_font:WY_FONTMedium(14)];
    [attTop3Str1 setYy_color:[UIColor blackColor]];
    
    [attTop3Str appendAttributedString:attTop3Str1];
    
    lblTop3Ts.attributedText = attTop3Str;
    
    
    [self.viewTop3 addSubview:lblTop3Ts];
    
    self.scrollViewImgsTop3 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop3 addSubview:self.scrollViewImgsTop3];
    
    
    
}
- (void) initMajorViews {
    WS(weakSelf)
    [self.viewMiddle removeAllSubviews];
    
    float lastY = 5;
    int i = 0;
    NSMutableArray *addArrMajors = [NSMutableArray new];
    int oldZPIndex = 0;
    int newZPIndex = 0;
    //获取老专业的第一个 （主评专业）索引值
    for (WY_MajorPhotoModel *mpModel in self.arrMajors) {
        if ([mpModel.isOldOrNew isEqualToString:@"1"]) {
            oldZPIndex = [self.arrMajors indexOfObject:mpModel];
            break;
        }
    }
    //获取新专业的第一个 （主评专业）索引值
    for (WY_MajorPhotoModel *mpModel in self.arrMajors) {
        if (![mpModel.isOldOrNew isEqualToString:@"1"]) {
            newZPIndex = [self.arrMajors indexOfObject:mpModel];
            break;
        }
    }
    for (WY_MajorPhotoModel *mpModel in self.arrMajors) {
        //        2022-10-17 17:09:31 - 以下注释-此处无用- 最后已letEdit条件为准
        //        //2021-07-28 11:36:01 - 修改需求-  如果省级审核通过 并且 是正式库专家 - 允许修改专业 ，  不判断 letEdit 条件
        //        if  ((self.isFormal == 1 || self.isFormal == 2) &&  self.approvalStatusNum == 4) {
        //            mpModel.letEdit = @"1";
        //            mpModel.letDel = @"1";
        //        }
        mpModel.oldZPIndex = oldZPIndex;
        mpModel.newZPIndex = newZPIndex;
        
        //新的
        mpModel.jumpToWhere = @"2";
        mpModel.source = self.source;
        WY_SelMajorView *selfMView = [[WY_SelMajorView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k375Width(374))];
        selfMView.reason = self.reason;
        selfMView.canEdit = self.canEdit;
        selfMView.canBFEdit = self.canBFEdit;
        selfMView.jujueContent = self.jujueContent;
        selfMView.rowIndex = i;
        //1是新入库专家
        selfMView.isFormal = self.isFormal;
        mpModel.currentIndex = i +1;
        if ([mpModel.isOldOrNew isEqualToString:@"1"]) {
            //老专业
            [selfMView showOldCellByModel:mpModel];
        } else {
            //新专业
            [selfMView showNewCellByModel:mpModel];
        }
        selfMView.btnDelMajor.tag = i;
        [selfMView.btnDelMajor addTarget:self action:@selector(btnDelMajorAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewMiddle addSubview:selfMView];
        selfMView.selPicItemBlock = ^(int rowIndex, NSMutableArray * _Nonnull arrUrls) {
            [weakSelf jumpToImageDetailPage:rowIndex urls:arrUrls];
        };
        selfMView.addZgzsPicItemBlock = ^(WY_SelMajorView * _Nonnull smView) {
            NSLog(@"点击了添加资格证书图片");
            
            if (!weakSelf.canEdit && !weakSelf.canBFEdit) {
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:weakSelf.reason preferredStyle:UIAlertControllerStyleAlert];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [weakSelf presentViewController:alertControl animated:YES completion:nil];
                return;
            }  else {
                //                    //2021-07-28 11:36:01 - 修改需求-  如果审核通过
                //                    if ((weakSelf.isFormal == 1 || weakSelf.isFormal == 2) && weakSelf.approvalStatusNum ==4) {
                //                    } else {
                if (![smView.mWY_MajorPhotoModel.letEdit isEqual:[NSNull null]] && smView.mWY_MajorPhotoModel.letEdit != nil) {
                    if([smView.mWY_MajorPhotoModel.letEdit intValue] == 0) {
                        [SVProgressHUD showErrorWithStatus:@"当前专业信息不可修改"];
                        return;
                    }
                }
                //                    }
            }
            weakSelf.selSMView = smView;
            picType = @"zgzs";
            [weakSelf navRightAddPhotoAction];
        };
        
        selfMView.addZczsPicItemBlock = ^(WY_SelMajorView * _Nonnull smView) {
            NSLog(@"点击了添加职称证书图片");
            if (!weakSelf.canEdit && !weakSelf.canBFEdit) {
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:weakSelf.reason preferredStyle:UIAlertControllerStyleAlert];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [weakSelf presentViewController:alertControl animated:YES completion:nil];
                return;
            }  else {
                if (![smView.mWY_MajorPhotoModel.letEdit isEqual:[NSNull null]] && smView.mWY_MajorPhotoModel.letEdit != nil) {
                    if([smView.mWY_MajorPhotoModel.letEdit intValue] == 0) {
                        [SVProgressHUD showErrorWithStatus:@"当前专业信息不可修改"];
                        return;
                    }
                }
            }
            
            weakSelf.selSMView = smView;
            picType = @"zczs";
            [weakSelf navRightAddPhotoAction];
        };
        
        selfMView.lblIsZpBlock = ^(WY_SelMajorView * _Nonnull smView) {
            //弹出提示；
            
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请确认此专业是否为主评专业（仅可修改一次）" preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"修改此ID：%d专业为主评",smView.mWY_MajorPhotoModel.id);
                NSLog(@"刷新页面");
                smView.mWY_MajorPhotoModel.mainProfession = 1;
                //                //绑定专业
                [self updateZPNetWorkWith:smView.mWY_MajorPhotoModel];
                
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateZPZYListWith:smView.mWY_MajorPhotoModel];
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertControl animated:YES completion:nil];
        };
        
        lastY = selfMView.bottom;
        i ++;
    }
    [self.arrMajors addObjectsFromArray:addArrMajors];
    self.viewMiddle.height = lastY;
    
    
    UIButton *addMajor = [[UIButton alloc] initWithFrame:CGRectMake(0, lastY + k375Width(12), k375Width(120), k375Width(32))];
    addMajor.centerX = self.viewMiddle.centerX;
    
    [addMajor setTitle:@"添加专业" forState:UIControlStateNormal];
    [addMajor setImage:[UIImage imageNamed:@"0615_AddMj"] forState:UIControlStateNormal];
    [addMajor setTitleColor:HEXCOLOR(0x448eee) forState:UIControlStateNormal];
    [addMajor rounded:k375Width(32/4) width:1 color:HEXCOLOR(0x448eee)];
    [addMajor.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(17)]];
    [addMajor addTarget:self action:@selector(addMajorAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viewMiddle addSubview:addMajor];
    //如果专业是铁路、地铁的- 没有添加按钮
    if ([self.source intValue] >= 2) {
        [addMajor setHidden:YES];
        self.viewMiddle.height = lastY + k375Width(12);
    } else {
        // * 0 全部不可以添加 1 可以全部添加 2 只能添加新专业 3 只能添加老专业
        if([self.mWY_ExpertMessageModel.letAdd intValue] != 0) {
            [addMajor setHidden:NO];
            self.viewMiddle.height = addMajor.bottom + k375Width(12);
        } else {
            [addMajor setHidden:YES];
            self.viewMiddle.height = lastY + k375Width(12);
        }
        
    }
    
    [self.mScrollView setContentSize:CGSizeMake(0, self.viewMiddle.bottom + k375Width(15))];
    
    
    //    [self.mScrollView setContentSize:CGSizeMake(0, self.viewMiddle.bottom + k375Width(15))];
}
- (void)updateZPZYListWith:(WY_MajorPhotoModel *)withModel {
    
    //绑定专业
    
    NSMutableArray *arrOldMP = [NSMutableArray new];
    NSMutableArray *arrNewMP = [NSMutableArray new];
    
    //获取老专业的集合
    for (WY_MajorPhotoModel *mpModel in self.arrMajors) {
        if ([mpModel.isOldOrNew isEqualToString:@"1"]) {
            [arrOldMP addObject:mpModel];
        }
    }
    //获取新专业的集合
    for (WY_MajorPhotoModel *mpModel in self.arrMajors) {
        if (![mpModel.isOldOrNew isEqualToString:@"1"]) {
            [arrNewMP addObject:mpModel];
        }
    }
    
    
    NSMutableArray *arrAlertItemModel;
    NSString *alertStr = @"";
    //如果当前是筛选老专业的主评
    if ([withModel.isOldOrNew isEqualToString:@"1"]) {
        alertStr = @"请选择要设置为主评的老专业";
        arrAlertItemModel = arrOldMP;
    } else {
        alertStr = @"请选择要设置为主评的新专业";
        arrAlertItemModel = arrNewMP;
    }
    
    //修改主评专业提示框
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
    
    for (WY_MajorPhotoModel *mpModel in arrAlertItemModel) {
        [alertControl addAction:[UIAlertAction actionWithTitle:mpModel.beforeProfessionName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (WY_MajorPhotoModel *mpModel1 in arrAlertItemModel) {
                mpModel1.mainProfession = 0;
            }
            mpModel.mainProfession = 1;
            //把主评专业排序到列表第一个 Start
            int i = 0;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (WY_MajorPhotoModel *mpModel2 in self.arrMajors) {
                if ([mpModel2 isEqual:mpModel]) {
                    i++;
                    [array addObject:mpModel2]; // 获取需要顶置的元素
                }
            }
            
            [self.arrMajors removeObjectsInArray:array];// 在原数组移除需要顶置的元素
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)];
            
            [self.arrMajors insertObjects:array atIndexes:indexSet];// 在原数组移除加入顶置的元素
            //把主评专业排序到列表第一个 End
            [self updateZPNetWorkWith:mpModel];
        }]];
    }
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (void)updateZPNetWorkWith:(WY_MajorPhotoModel *)withModel  {
    //调用接口设置主评专业；
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [dicPost setObject:@"1" forKey:@"mainProfession"];
    [dicPost setObject:[NSString stringWithFormat:@"%d",withModel.id] forKey:@"id"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_setMainEvaluationMajor_HTTP params:nil jsonData:[dicPost mj_JSONData] showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        [SVProgressHUD showSuccessWithStatus:@"设置主评成功"];
        [self initMajorViews];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
    
    //    zj_setMainEvaluationMajor_HTTP
    
}

- (void)btnDelMajorAction:(UIButton *)btnSender {
    if (!self.canEdit && !self.canBFEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    [self.arrMajors removeObjectAtIndex:btnSender.tag];
    [self initMajorViews];
    
}

///添加新专业
- (void)addMajorAction {
    if (!self.canEdit && !self.canBFEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    
    UIAlertAction *alertActNew = [UIAlertAction actionWithTitle:@"添加新专业" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pAddZhuanYe:@"0"];
    }];
    
    UIAlertAction *alertAct3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *alertActOld = [UIAlertAction actionWithTitle:@"添加老专业" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pAddZhuanYe:@"1"];
        
        
    }];
    
    UIAlertControllerStyle alertStyle = UIAlertControllerStyleAlert;
    if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        alertStyle = UIAlertControllerStyleAlert;
    } else {
        alertStyle = UIAlertControllerStyleActionSheet;
    }
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:alertStyle];
    
    if([self.mWY_ExpertMessageModel.letAdd intValue] == 1) {
        [alertControl addAction:alertActNew];
        //9是只能添加5个新专业 - 又改回去了
        [alertControl addAction:alertActOld];
    } else if([self.mWY_ExpertMessageModel.letAdd intValue] == 2) {
        [alertControl addAction:alertActNew];
    } else if([self.mWY_ExpertMessageModel.letAdd intValue] == 3) {
        [alertControl addAction:alertActOld];
    }
    
    
    [alertControl addAction:alertAct3];
    
    [self presentViewController:alertControl animated:YES completion:nil];
    
    
}

- (void)pAddZhuanYe:(NSString *)isOldOrNew {
    int majorsCount = 0;
    for (WY_MajorPhotoModel *mpModel in self.arrMajors) {
        if ([mpModel.isOldOrNew isEqualToString:isOldOrNew]) {
            majorsCount ++;
        }
    }
    if ([isOldOrNew isEqualToString:@"1"]) {
        if (majorsCount >= 3) {
            [SVProgressHUD showErrorWithStatus:@"最多增加3个老专业"];
            return;
        }
    } else {
        if (majorsCount >= 5) {
            [SVProgressHUD showErrorWithStatus:@"最多增加5个新专业"];
            return;
        }
    }
    
    WY_MajorPhotoModel *tempModel1 = [WY_MajorPhotoModel new];
    tempModel1.letDel = @"1";
    tempModel1.letEdit = @"1";
    tempModel1.expertWarehousing = @"0";
    tempModel1.isOldOrNew = isOldOrNew;
    if (majorsCount == 0) {
        tempModel1.mainProfession = 1;
    }
    [self.arrMajors addObject:tempModel1];
    [self initMajorViews];
}
/// 初始化设备Imgs
- (void)initSheBaoImgs {
    [self.scrollViewImgsTop2 removeAllSubviews];
    
    float lastX = k375Width(12);
    int i = 0;
    for (NSString *imgUrl in self.arrImgUrls) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop2 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnDelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        i ++;
    }
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addSheBaoPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewImgsTop2 addSubview:tempBtnAdd];
    
    [self.scrollViewImgsTop2 setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
}



/// 初始化调整申报Imgs
- (void)initTiaoZhengSBImgs {
    [self.scrollViewImgsTop4A removeAllSubviews];
    WS(weakSelf)
    float lastX = k375Width(12);
    int i = 0;
    if (self.arrTiaoZhengSBImgUrls.count > 0) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:self.arrTiaoZhengSBImgUrls[0] ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop4A addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnTiaoZhengSBImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnTiaoZhengSBDelAction:) forControlEvents:UIControlEventTouchUpInside];
        lastX = tempBtn.right;
    } else {
        WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
        [tempBtnAdd.btnImg addTarget:self action:@selector(addTiaoZhengSBPicAction) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewImgsTop4A addSubview:tempBtnAdd];
        lastX = tempBtnAdd.right;
    }
    UIButton *btnDownMuBan = [UIButton new];
    [btnDownMuBan setHidden:YES];
    [btnDownMuBan setFrame:CGRectMake(lastX + k360Width(16), k360Width(100-40) /2, k360Width(100), k360Width(40))];
    [btnDownMuBan rounded:k360Width(40/8)];
    [btnDownMuBan setBackgroundColor:MSTHEMEColor];
    [btnDownMuBan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDownMuBan setTitle:@"下载模板" forState:UIControlStateNormal];
    [btnDownMuBan addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"分享");
        
        NSURL *shareUrl = [NSURL URLWithString:@"https://study.capass.cn/Avatar/newcommitmentEle.pdf"];
        NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
        NSArray*activityItems =@[shareUrl,@"评标专家真实性承诺及签字.pdf",dateImg];
        
        SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:@"使用浏览器打开" withActivityImage:dateImg withUrl:shareUrl withType:@"CustomActivity" withShareContext:activityItems];
        NSArray *activities = @[customActivit];
        
        UIActivityViewController *activityVC = nil;
        if  (MH_iOS13_VERSTION_LATER) {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
        } else {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        }
        //        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
        //         activityVC.excludedActivityTypes = @[];
        activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
        //弹出分享的页面
        [weakSelf presentViewController:activityVC animated:YES completion:nil];
        // 分享后回调
        
        activityVC.completionWithItemsHandler= ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray*_Nullable returnedItems,NSError*_Nullable activityError) {
            
            if(completed) {
                
                NSLog(@"completed");
                
                //分享成功
                
            }else {
                
                NSLog(@"cancled");
                
                //分享取消
                
            }
            
        };
        
    }];
    [weakSelf.scrollViewImgsTop4A addSubview:btnDownMuBan];
    
}

/// 初始化保证书Imgs
- (void)initBaoZhengAImgs {
    [self.scrollViewImgsTop3A removeAllSubviews];
    WS(weakSelf)
    float lastX = k375Width(12);
    int i = 0;
    if (self.arrBaoZhengAImgUrls.count > 0) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:self.arrBaoZhengAImgUrls[0] ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop3A addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnBaoZhengAImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnBaoZhengADelAction:) forControlEvents:UIControlEventTouchUpInside];
        lastX = tempBtn.right;
    } else {
        WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
        [tempBtnAdd.btnImg addTarget:self action:@selector(addBaoZhengAPicAction) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewImgsTop3A addSubview:tempBtnAdd];
        lastX = tempBtnAdd.right;
    }
    UIButton *btnDownMuBan = [UIButton new];
    [btnDownMuBan setHidden:YES];
    [btnDownMuBan setFrame:CGRectMake(lastX + k360Width(16), k360Width(100-40) /2, k360Width(100), k360Width(40))];
    [btnDownMuBan rounded:k360Width(40/8)];
    [btnDownMuBan setBackgroundColor:MSTHEMEColor];
    [btnDownMuBan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDownMuBan setTitle:@"下载模板" forState:UIControlStateNormal];
    [btnDownMuBan addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"分享");
        
        NSURL *shareUrl = [NSURL URLWithString:@"https://study.capass.cn/Avatar/newcommitmentEle.pdf"];
        NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
        NSArray*activityItems =@[shareUrl,@"评标专家真实性承诺及签字.pdf",dateImg];
        
        SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:@"使用浏览器打开" withActivityImage:dateImg withUrl:shareUrl withType:@"CustomActivity" withShareContext:activityItems];
        NSArray *activities = @[customActivit];
        
        UIActivityViewController *activityVC = nil;
        if  (MH_iOS13_VERSTION_LATER) {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
        } else {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        }
        //        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
        //         activityVC.excludedActivityTypes = @[];
        activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
        //弹出分享的页面
        [weakSelf presentViewController:activityVC animated:YES completion:nil];
        // 分享后回调
        
        activityVC.completionWithItemsHandler= ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray*_Nullable returnedItems,NSError*_Nullable activityError) {
            
            if(completed) {
                
                NSLog(@"completed");
                
                //分享成功
                
            }else {
                
                NSLog(@"cancled");
                
                //分享取消
                
            }
            
        };
        
    }];
    [weakSelf.scrollViewImgsTop3A addSubview:btnDownMuBan];
    
}

/// 初始化续聘附件
- (void)initXuPinImgs {
    [self.scrollViewImgsTop5 removeAllSubviews];
    WS(weakSelf)
    float lastX = k375Width(12);
    int i = 0;
    if (self.arrXuPinImgUrls.count > 0) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:self.arrXuPinImgUrls[0] ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop5 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnXuPinImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnXuPinDelAction:) forControlEvents:UIControlEventTouchUpInside];
        lastX = tempBtn.right;
    } else {
        WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
        [tempBtnAdd.btnImg addTarget:self action:@selector(addXuPinPicAction) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewImgsTop5 addSubview:tempBtnAdd];
        lastX = tempBtnAdd.right;
    }
}



/// 初始化保证书Imgs
- (void)initBaoZhengImgs {
    [self.scrollViewImgsTop3 removeAllSubviews];
    WS(weakSelf)
    float lastX = k375Width(12);
    int i = 0;

    for (NSString *imgUrl in self.arrBaoZhengImgUrls) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop3 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnBaoZhengImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnBaoZhengDelAction:) forControlEvents:UIControlEventTouchUpInside];
        lastX = tempBtn.right;
    }
        WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
        [tempBtnAdd.btnImg addTarget:self action:@selector(addBaoZhengPicAction) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewImgsTop3 addSubview:tempBtnAdd];
        lastX = tempBtnAdd.right;
    
    UIButton *btnDownMuBan = [UIButton new];
    [btnDownMuBan setHidden:YES];
    [btnDownMuBan setFrame:CGRectMake(lastX + k360Width(16), k360Width(100-40) /2, k360Width(100), k360Width(40))];
    [btnDownMuBan rounded:k360Width(40/8)];
    [btnDownMuBan setBackgroundColor:MSTHEMEColor];
    [btnDownMuBan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDownMuBan setTitle:@"下载模板" forState:UIControlStateNormal];
    [btnDownMuBan addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"分享");
        
        NSURL *shareUrl = [NSURL URLWithString:@"https://study.capass.cn/Avatar/newcommitmentEle.pdf"];
        NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
        NSArray*activityItems =@[shareUrl,@"评标专家真实性承诺及签字.pdf",dateImg];
        
        SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:@"使用浏览器打开" withActivityImage:dateImg withUrl:shareUrl withType:@"CustomActivity" withShareContext:activityItems];
        NSArray *activities = @[customActivit];
        
        UIActivityViewController *activityVC = nil;
        if  (MH_iOS13_VERSTION_LATER) {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
        } else {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        }
        
        
        activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
        //弹出分享的页面
        [weakSelf presentViewController:activityVC animated:YES completion:nil];
        // 分享后回调
        
        activityVC.completionWithItemsHandler= ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray*_Nullable returnedItems,NSError*_Nullable activityError) {
            
            if(completed) {
                
                NSLog(@"completed");
                
                //分享成功
                
            }else {
                
                NSLog(@"cancled");
                
                //分享取消
                
            }
            
        };
        
    }];
    [weakSelf.scrollViewImgsTop3 addSubview:btnDownMuBan];
    
}

- (void)addSheBaoPicAction {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    
    //添加社保-图片；
    picType = @"3";
    [self navRightAddPhotoAction];
}
- (void)addBaoZhengPicAction {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    
    //添加社保-图片；
    picType = @"baozheng";
    [self navRightAddPhotoAction];
}
- (void)addBaoZhengAPicAction {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    
    //添加社保-图片；
    picType = @"baozhengA";
    [self navRightAddPhotoAction];
}

- (void)addXuPinPicAction {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    
    //添加续聘-图片；
    picType = @"xupin";
    [self navRightAddPhotoAction];
}


- (void)addTiaoZhengSBPicAction {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    
    //添加社保-图片；
    picType = @"tiaozhengSB";
    [self navRightAddPhotoAction];
}

- (void)btnIdCardAAction {
    //添加身份证A面；
    if (self.idcardImgUrlA.length > 0) {
        [self goImageShow:self.idcardImgUrlA];
    } else {
        if (!self.canEdit) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertControl animated:YES completion:nil];
            return;
        }
        picType = @"1";
        [self navRightAddPhotoAction];
    }
}
- (void)btnIdCardACloseAction {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    
    //删除身份证A面；
    [self.btnIdCardAClose setHidden:YES];
    self.idcardImgUrlA = @"";
    [self.btnIdCardA setImage:[UIImage imageNamed:@"0616_IDCardB"] forState:UIControlStateNormal];
    
}
- (void)btnIdCardBCloseAction {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    
    //删除身份证A面；
    [self.btnIdCardBClose setHidden:YES];
    self.idcardImgUrlB = @"";
    [self.btnIdCardB setImage:[UIImage imageNamed:@"0616_IDCardA"] forState:UIControlStateNormal];
}



- (void)btnIdCardBAction {
    //添加身份证B面；
    if (self.idcardImgUrlB.length > 0) {
        [self goImageShow:self.idcardImgUrlB];
    } else {
        if (!self.canEdit) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertControl animated:YES completion:nil];
            return;
        }
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

- (void)btnImgAction:(UIButton *)btnSender {
    //打开图片；
    NSMutableArray *urls = self.arrImgUrls;
    int atIndex = btnSender.tag;
    [self jumpToImageDetailPage:atIndex urls:urls];
}
- (void)btnBaoZhengImgAction:(UIButton *)btnSender {
    NSMutableArray *urls = self.arrBaoZhengImgUrls;
    int atIndex = btnSender.tag;
    [self jumpToImageDetailPage:atIndex urls:urls];
}

- (void)jumpToImageDetailPage:(int)atIndex urls:(NSMutableArray *)urls {
    NSMutableArray *picModels = [NSMutableArray new];
    for (NSString *imgUrl in urls) {
        IWPictureModel* picModel  = [IWPictureModel new];
        picModel.nsbmiddle_pic = imgUrl;
        picModel.nsoriginal_pic = imgUrl;
        [picModels addObject:picModel];
    }
    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
    indvController.mIWPictureModel = [picModels objectAtIndex:atIndex];
    indvController.picArr = picModels;
    [self.navigationController pushViewController:indvController animated:YES];
}

- (void)btnBaoZhengAImgAction:(UIButton *)btnSender {
    //打开图片；
    NSMutableArray *urls = self.arrBaoZhengAImgUrls;
    int atIndex = btnSender.tag;
    [self jumpToImageDetailPage:atIndex urls:urls];
}
- (void)btnXuPinImgAction:(UIButton *)btnSender {
    //打开图片；
    NSMutableArray *urls = self.arrXuPinImgUrls;
    int atIndex = btnSender.tag;
    [self jumpToImageDetailPage:atIndex urls:urls];
}
- (void)btnTiaoZhengSBImgAction:(UIButton *)btnSender {
    //打开图片；
    NSMutableArray *urls = self.arrTiaoZhengSBImgUrls;
    int atIndex = btnSender.tag;
    [self jumpToImageDetailPage:atIndex urls:urls];
}

- (void)btnDelAction:(UIButton *)btnSender {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    //删除图片
    [self.arrImgUrls removeObjectAtIndex:btnSender.tag];
    [self initSheBaoImgs];
}
- (void)btnBaoZhengDelAction:(UIButton *)btnSender {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    //删除图片
    [self.arrBaoZhengImgUrls removeObjectAtIndex:btnSender.tag];
    [self initBaoZhengImgs];
}
- (void)btnBaoZhengADelAction:(UIButton *)btnSender {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    //删除图片
    [self.arrBaoZhengAImgUrls removeObjectAtIndex:btnSender.tag];
    [self initBaoZhengAImgs];
}
- (void)btnXuPinDelAction:(UIButton *)btnSender {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    //删除图片
    [self.arrXuPinImgUrls removeObjectAtIndex:btnSender.tag];
    [self initXuPinImgs];
}
- (void)btnTiaoZhengSBDelAction:(UIButton *)btnSender {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    //删除图片
    [self.arrTiaoZhengSBImgUrls removeObjectAtIndex:btnSender.tag];
    [self initTiaoZhengSBImgs];
}
- (void)btnUpAction {
    NSLog(@"点击了上一步按钮");
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"返回后您已经填写的信息将不会被保存，您确定返回吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertControl animated:YES completion:nil];
    
}

- (void)btnAgreeAction:(UIButton *)btnSender {
    btnSender.selected = !btnSender.selected;
}
- (void)submitInfo {
    [self bindPDFView];
}

- (void)bindPDFView {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAAAction) image:@"白返回" highImage:@"返回" ];
    WS(weakSelf)
    [self.cancleButton setHidden:YES];
    titleStr = self.title;
    self.title = @"请阅读并同意服务协议";
    if  (pdfView == nil) {
        //才 跳转 协议
        pdfView = [UIView new];
        [pdfView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
        [self.view addSubview: pdfView];
        [pdfView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
        
        NSString *pdfurl = @"https://www.capass.cn/Avatar/zjxxxgsm.pdf";
        
        WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfurl]]];
        [pdfView addSubview:webview];
        
        btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, webview.bottom, kScreenWidth *1/3, k360Width(50))];
        btnRight = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth *1/3, webview.bottom, kScreenWidth *2/3, k360Width(50))];
        [btnLeft setTitle:@"拒 绝" forState:UIControlStateNormal];
        [btnRight setTitle:@"已阅读并同意" forState:UIControlStateNormal];
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
            weakSelf.title = titleStr;
            isAgree = @"0";
            [pdfView setHidden:YES];
            [weakSelf.cancleButton setHidden:NO];
            
            weakSelf.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"白返回" highImage:@"返回" ];
            
        }];
        
        [btnRight addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            weakSelf.title = titleStr;
            isAgree = @"1";
            [pdfView setHidden:YES];
            [weakSelf.cancleButton setHidden:NO];
            [weakSelf submitInfo1];
            weakSelf.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"白返回" highImage:@"返回" ];
            
        }];
    } else {
        [pdfView setHidden:NO];
    }
}
- (void)backAAAction{
    NSLog(@"拒绝");
    self.title = titleStr;
    isAgree = @"0";
    [pdfView setHidden:YES];
    [self.cancleButton setHidden:NO];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"白返回" highImage:@"返回" ];
}


/// 封装提交参数
/// @param expModel 输入参数
/// @param paramModel 输出参数
- (BOOL)EncapsulationSubmissionParameters:(WY_ExpertMessageModel *)expModel paramModel:(WY_ParamExpertModel *)paramModel {
    paramModel.userGuid = self.mUser.UserGuid;
    paramModel.zjCardNum =expModel.zjIdCard;
    paramModel.zjBankNum = expModel.zjBankNum;
    paramModel.zjBankType = expModel.zjBankType;
    paramModel.zjName = expModel.zjName;
    paramModel.zjPhone = expModel.zjPhone;
    
    paramModel.professionState = expModel.professionState;
    
    //专家管理属地传递；
    paramModel.cityCode = expModel.cityCode;
    paramModel.city = expModel.city;
    paramModel.zjSex = expModel.zjSex;
    paramModel.styleId = expModel.selStyleId;
    if (expModel.secre) {
        paramModel.secre = expModel.secre;
    }
    paramModel.source = self.source;
    
    if ((self.isFormal == 1 || self.isFormal == 2)) {
        paramModel.isFormal = [NSString stringWithFormat:@"%d",self.isFormal];
    } else {
        paramModel.isFormal = @"0";
    }
    
    paramModel.idCardPhotos = [NSString stringWithFormat:@"%@,%@",self.idcardImgUrlA,self.idcardImgUrlB];
    paramModel.sbTxCardPhotos = [self.arrImgUrls componentsJoinedByString:@","];
    paramModel.commitmentEleNew = [self.arrBaoZhengImgUrls componentsJoinedByString:@","];
    if ([self.isNewExpert intValue] == 1) {
        paramModel.inDoor = [self.arrBaoZhengAImgUrls componentsJoinedByString:@","];
    }
    //是续聘专家 传续聘附件
    if ([self.isRenewalFlag intValue] == 1) {
        paramModel.pendingmentEleNew = [self.arrXuPinImgUrls componentsJoinedByString:@","];
    }
    
    
    //调整申报
    paramModel.alterZy = [self.arrTiaoZhengSBImgUrls componentsJoinedByString:@","];
    
    NSMutableArray *zjCompanyList = [[NSMutableArray alloc] init];
    
    NSMutableArray *majorPhotoBeanList = [[NSMutableArray alloc] init];
    
    //添加-现单位
    //原-现单位；
    NSString *yXdwStr = @"";
    //改过后-现单位；
    NSString *updateXdwStr = expModel.zjOriginalCompany;
    
    if (expModel.currentCompany.count > 0) {
        WY_ZJCompanyModel *tempModel = expModel.currentCompany[0];
        yXdwStr = tempModel.companyName;
    }
    //如果 原-现单位是空；- 参数放到现单位；
    if ([yXdwStr isEqualToString:@""]) {
        WY_ZJCompanyModel *tempModel = [WY_ZJCompanyModel new];
        tempModel.zjCompanyName = updateXdwStr;
        tempModel.zjCompanyType = @"1";
        [zjCompanyList addObject:tempModel];
    } else {
        //如果和原来的现单位一样- 就放到现单位里；
        if ([updateXdwStr isEqualToString:yXdwStr]) {
            WY_ZJCompanyModel *tempModel = [WY_ZJCompanyModel new];
            tempModel.zjCompanyName = updateXdwStr;
            tempModel.zjCompanyType = @"1";
            [zjCompanyList addObject:tempModel];
        } else {
            //如果和原来的现单位不一样。 把原来的放到原单位里；
            WY_ZJCompanyModel *tempModel = [WY_ZJCompanyModel new];
            tempModel.zjCompanyName = updateXdwStr;
            tempModel.zjCompanyType = @"1";
            
            WY_ZJCompanyModel *tempModelA = [WY_ZJCompanyModel new];
            tempModelA.zjCompanyName = yXdwStr;
            tempModelA.zjCompanyType = @"0";
            [zjCompanyList addObject:tempModel];
            [zjCompanyList addObject:tempModelA];
        }
    }
    
    //添加原单位‘
    for (WY_ZJCompanyModel *tempModel in expModel.originalCompany) {
        tempModel.zjCompanyType = @"0";
        tempModel.zjCompanyName = tempModel.companyName;
        [zjCompanyList addObject:tempModel];
    }
    
    //添加回避单位-
    for (WY_ZJCompanyModel *tempModel in expModel.voidCompany) {
        if ([tempModel.isDel isEqualToString:@"1"]) {
            //如果是新增的 回避单位 - 才添加
            tempModel.zjCompanyType = @"2";
            tempModel.zjCompanyName = tempModel.companyName;
            [zjCompanyList addObject:tempModel];
            
        }
    }
    
    
    //添加专业 ；
    for (WY_MajorPhotoModel *majModel in self.arrMajors) {
        WY_MajorPhotoModel *postModel = [WY_MajorPhotoModel new];
        
        if (![majModel.isOldOrNew isEqualToString:@"1"]) {
            postModel.professionName = majModel.professionNameThird;
            postModel.professionId = majModel.professionCodeThird;
            //老专业新增的时候 这个字段为 0 新专业为1
            postModel.professionState = @"0";
        } else {
            postModel.professionName = majModel.professionNameSecond;
            postModel.professionId = majModel.professionCodeSecond;
            postModel.professionState = @"1";
        }
        postModel.hyPhotos  = majModel.qualificationEleId;
        postModel.zmPhotos  = majModel.jobEleid;
        postModel.mainProfession = majModel.mainProfession;
        
        if (majModel.beforeProfessionName != nil && ![majModel.beforeProfessionName isEqual:[NSNull null]]) {
            postModel.beforeProfession  = majModel.beforeProfession;
            postModel.beforeProfessionName  = majModel.beforeProfessionName;
        }
        
        if (postModel.hyPhotos==nil) {
            postModel.hyPhotos = @"";
        }
        if (postModel.zmPhotos==nil) {
            postModel.zmPhotos = @"";
        }
        
        postModel.majorType = majModel.professionState;
        postModel.oldProfessionCode = majModel.oldProfessionCode;
        postModel.isOldOrNew = majModel.isOldOrNew;
        postModel.source = self.source;
        //新版提交- 需要修改此审核字段-
        if  ([majModel.expertWarehousing intValue] == 2 || [majModel.expertWarehousing intValue] == 1) {
            postModel.expertWarehousing = @"0";
        } else {
            postModel.expertWarehousing = majModel.expertWarehousing;
        }
        [majorPhotoBeanList addObject:postModel];
    }
    
    for (WY_MajorPhotoModel *postModel in majorPhotoBeanList) {
        int i = 0;
        for (WY_MajorPhotoModel *postModel1 in majorPhotoBeanList) {
            if ([postModel.professionId isEqualToString:postModel1.professionId]) {
                i++;
            }
        }
        if (i >= 2) {
            [SVProgressHUD showErrorWithStatus:@"请修改或删除重复添加的专业"];
            paramModel = nil;
            return NO;
        }
    }
    paramModel.zjCompanyList = zjCompanyList;
    paramModel.jobTitleList =  expModel.jobTitleList;
    paramModel.majorPhotoBeanList = majorPhotoBeanList;
    return YES;
}

- (void)submitInfo1 {
    WY_ParamExpertModel *paramModel = [WY_ParamExpertModel new];
    WY_ExpertMessageModel *expModel = self.mWY_ExpertMessageModel;
     
    if (![self EncapsulationSubmissionParameters:expModel paramModel:paramModel]) {
        return;
    }
    
    NSLog(@"JSON:%@",[paramModel toJSONString]);
    
    [[MS_BasicDataController sharedInstance] postWithURL:updateZjData_HTTP params:nil jsonData:[paramModel toJSONData] showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSString *failureCallBack) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:failureCallBack preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];        
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
}

- (void)btnSubmitAction {
    NSLog(@"点击了提交订单");
    
    if (!self.canEdit && !self.canBFEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    if (!self.btnAgree.selected) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并点击同意《专家信息修改说明》"];
        return;
    }
    //    if (self.approvalStatusNum == 0 || self.approvalStatusNum == 4 || self.approvalStatusNum == 6) {
    //
    //    } else {
    //        [SVProgressHUD showErrorWithStatus:@"当前信息正在审核中，不可修改"];
    //        return;
    //    }
    
    if ([self validateForm]) {
        if (self.approvalStatusNum == 4) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"当前信息已审核通过，请您确认是否修改信息，再次提交，等待审核。\n【特别提醒】仅确认或修改主评专业操作的专家，请勿重复提交修改信息，取消返回即可" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self submitInfo];
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alertControl animated:YES completion:nil];
        } else if (self.approvalStatusNum == 10) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您有部分未通过审核的专业，请确认是否都已修改完成" preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self submitInfo];
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alertControl animated:YES completion:nil];
        } else {
            [self submitInfo];
        }
        
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (BOOL)validateForm {
    
    //验证- 身份证；
    if (self.idcardImgUrlA.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传证件照（正面）"];
        return NO;
    }
    if (self.idcardImgUrlB.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传证件照（反面）"];
        return NO;
    }
    //验证 社保；
    if (self.arrImgUrls.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传社保证明/退休证"];
        return NO;
    }
    //验证 保证书A；
    if (self.arrBaoZhengAImgUrls.count <= 0 && [self.isNewExpert intValue] == 1) {
        [SVProgressHUD showErrorWithStatus:@"请上传新入库申请表"];
        return NO;
    }
    //验证 续聘申请表；
    if (self.arrXuPinImgUrls.count <= 0 && [self.isRenewalFlag intValue] == 1) {
        [SVProgressHUD showErrorWithStatus:@"请上传续聘专家申请表"];
        return NO;
    }
    //验证 保证书；
    if (self.arrBaoZhengImgUrls.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传承诺书"];
        return NO;
    }
    
    
    //验证  专业；
    int majorsCount = 0;
    int newmajorsCount = 0;
    for (WY_MajorPhotoModel *mpModel in self.arrMajors) {
        if ([mpModel.isOldOrNew isEqualToString:@"1"]) {
            majorsCount ++;
        } else {
            newmajorsCount ++;
        }
    }
    //如果专业是铁路、地铁的- 没有添加按钮
    if ([self.source intValue] >= 2) {
        if (newmajorsCount <= 0) {
            [SVProgressHUD showErrorWithStatus:@"没有选择专业无法提交"];
            return NO;
        }
    } else {
        
        if([self.mWY_ExpertMessageModel.letAdd intValue] == 1) {
            if (majorsCount <= 0 || newmajorsCount <= 0) {
                [SVProgressHUD showErrorWithStatus:@"请至少选择一个老专业和一个新专业"];
                return NO;
            }
        } else if([self.mWY_ExpertMessageModel.letAdd intValue] == 2) {
            if (newmajorsCount <= 0) {
                [SVProgressHUD showErrorWithStatus:@"请至少选择一个新专业"];
                return NO;
            }
        } else if([self.mWY_ExpertMessageModel.letAdd intValue] == 3) {
            if (majorsCount <= 0) {
                [SVProgressHUD showErrorWithStatus:@"请至少选择一个老专业"];
                return NO;
            }
        }
        
    }
    int i = 0;
    for (WY_MajorPhotoModel *majModel in self.arrMajors) {
        if (majModel.professionCodeThird.length <=0 && [majModel.isOldOrNew isEqualToString:@"0"]) {
            NSString *msgStr = [NSString stringWithFormat:@"请选择第%d个专业的类别",majModel.currentIndex];
            [SVProgressHUD showErrorWithStatus:msgStr];
            return NO;
        }
        if (majModel.professionCodeSecond.length <=0 && [majModel.isOldOrNew isEqualToString:@"1"]) {
            NSString *msgStr = [NSString stringWithFormat:@"请选择第%d个专业的类别",majModel.currentIndex];
            [SVProgressHUD showErrorWithStatus:msgStr];
            return NO;
        }
        //如果审核已通过- 不验证图片非空；
        if ([majModel.expertWarehousing intValue] != 1) {
            if (majModel.jobEleid.length <=0) {
                NSString *msgStr = [NSString stringWithFormat:@"请完善第%d个专业的职称证明",majModel.currentIndex];
                [SVProgressHUD showErrorWithStatus:msgStr];
                return NO;
            }
            if (majModel.qualificationEleId.length <=0) {
                NSString *msgStr = [NSString stringWithFormat:@"请完善第%d个专业的资格（注册证）或者技术能力证明",majModel.currentIndex];
                [SVProgressHUD showErrorWithStatus:msgStr];
                return NO;
            }
        }
        i++;
    }
    
    
    WY_ParamExpertModel *paramModel = [WY_ParamExpertModel new];
    WY_ExpertMessageModel *expModel = self.mWY_ExpertMessageModel;
    
    if (![self EncapsulationSubmissionParameters:expModel paramModel:paramModel]) {
        return NO;
    }
    //TODO： 2025 年 10 月 29 日 09:50:19 新增专家续聘功能- 增加逻辑判断- 续聘和新入库专家，都不显示调整申报表，并且不做调整申报表非空判断，除此外原逻辑保留
    //如果不是新入库专家 - 才会判断是否上传 调整申报表
    if ([self.isNewExpert intValue] != 1 && [self.isRenewalFlag intValue] != 1) {
        ///TODO：2023-03-02 16:08:27 - 佟哥说 这批已经完事了，后面没用了 不再显示调整申报表 也不再处理相关判断
        ///TODO： 2024-06-05 10:49:24 - 佟哥又说， 现在又要开放此功能  - 2024年的- 打开了上传 调整申报表
        //    如果专业有改变 - 并且没有上传 调整申报表时 - 做非空提示；
        //    验证 调整申报表；
        if (self.arrTiaoZhengSBImgUrls.count <= 0) {
            //如果专业有改变 - 并且没有上传 调整申报表时 - 做非空提示；
            NSString * zyparamModel_JSONStr  = [paramModel.majorPhotoBeanList yy_modelToJSONString];
            NSString * zymStorageWY_ParamExpertModel_JsonStr  = [self.mStorageWY_ParamExpertModel.majorPhotoBeanList yy_modelToJSONString];
            NSLog(@"zyparamModel_JSONStr:%@",zyparamModel_JSONStr);
            NSLog(@"zymStorageWY_ParamExpertModel_JsonStr:%@",zymStorageWY_ParamExpertModel_JsonStr);
            //    提交时和暂存数据比对 - 如果有专业修改- 提示
            if (![zymStorageWY_ParamExpertModel_JsonStr isEqualToString:zyparamModel_JSONStr]) {
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"您已修改过专业，请上传《辽宁省综合评标专家库专家专业调整申报表》。" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertControl animated:YES completion:nil];
                
                return NO;
            }
        }
    }
    
    NSString * paramModel_JSONStr  = [paramModel toJSONString];
    NSString * mStorageWY_ParamExpertModel_JsonStr  = [self.mStorageWY_ParamExpertModel toJSONString];    
    NSLog(@"paramModel_JSON:%@",paramModel_JSONStr);
    NSLog(@"mStorageWY_ParamExpertModel_Json:%@",mStorageWY_ParamExpertModel_JsonStr);
    //    提交时和暂存数据比对 - 如果没有任何修改- 提示
    if ([mStorageWY_ParamExpertModel_JsonStr isEqualToString:paramModel_JSONStr]) {
        //    if ([self.mStorageWY_ParamExpertModel isEqual:paramModel]) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"您未修改任何信息或修改的信息无需核验，请勿重复提交审核。" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

- (void) firstAlert {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请把所要拍摄的材料放置在与拍摄背景有明显区别的环境下，如果识别不准确可点击手动拍照" preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"开始识别" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
    
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
    WS(weakSelf)
    OP_CameraViewController *tempController = [OP_CameraViewController new];
    tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
        [weakSelf uploadImage:imgEdit];
    };
    [self.navigationController pushViewController:tempController animated:YES];
    
    //    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    //    {
    //
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //        picker.delegate = self;
    //        //设置拍照后的图片可被编辑
    //        picker.allowsEditing = YES;
    //        picker.sourceType = sourceType;
    //        picker.modalPresentationStyle = UIModalPresentationFullScreen;
    //        [self presentViewController:picker animated:YES completion:nil];
    //    }else
    //    {
    //
    //    }
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
        //                self.zengzhishuiurl =picUrl;
        //                [self.imgBottomType3 setImage:image];
        //                [self btnInvoiceTypeAction:self.btnInvoiceType3];
        
        if ([picType isEqualToString:@"3"]) {
            //设备添加图片成功；
            [self.arrImgUrls addObject:picUrl];
            [self initSheBaoImgs];
        } else if ([picType isEqualToString:@"baozheng"]) {
            //设备添加图片成功；
            [self.arrBaoZhengImgUrls addObject:picUrl];
            [self initBaoZhengImgs];
        } else if ([picType isEqualToString:@"baozhengA"]) {
            //设备添加图片成功；
            [self.arrBaoZhengAImgUrls addObject:picUrl];
            [self initBaoZhengAImgs];
        } else if ([picType isEqualToString:@"xupin"]) {
            //续聘添加图片成功；
            [self.arrXuPinImgUrls addObject:picUrl];
            [self initXuPinImgs];
        }
        else if ([picType isEqualToString:@"tiaozhengSB"]) {
            //设备添加图片成功；
            [self.arrTiaoZhengSBImgUrls addObject:picUrl];
            [self initTiaoZhengSBImgs];
        }
        else  if ([picType isEqualToString:@"1"]) {
            //身份证正面；
            self.idcardImgUrlA = picUrl;
            [self.btnIdCardA setImage:image forState:UIControlStateNormal];
            [self.btnIdCardAClose setHidden:NO];
            
        } else  if ([picType isEqualToString:@"2"]) {
            //身份证反面；
            self.idcardImgUrlB = picUrl;
            [self.btnIdCardB setImage:image forState:UIControlStateNormal];
            [self.btnIdCardBClose setHidden:NO];
        } else  if ([picType isEqualToString:@"zgzs"]) {
            [self.selSMView.arrZgzs addObject:picUrl];
            self.selSMView.mWY_MajorPhotoModel.qualificationEleId = [self.selSMView.arrZgzs componentsJoinedByString:@","];
            [self.selSMView initZgzsImgs];
        } else  if ([picType isEqualToString:@"zczs"]) {
            [self.selSMView.arrZczs addObject:picUrl];
            self.selSMView.mWY_MajorPhotoModel.jobEleid = [self.selSMView.arrZczs componentsJoinedByString:@","];
            [self.selSMView initZczsImgs];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD ms_dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    WS(weakSelf)
    
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
            [weakSelf uploadImage:imgEdit];
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

- (void)donghua {
    //    NSLog(@"不能一直");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.alStatus == 0) {
            self.cancleButton.alpha -= 0.03;
        } else {
            self.cancleButton.alpha += 0.03;
        }
        
        if (self.cancleButton.alpha <= 0) {
            self.alStatus = 1;
        }
        if (self.cancleButton.alpha >= 1) {
            self.alStatus = 0;
        }
    });
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 block:^(NSTimer * _Nonnull timer) {
        [self donghua];
    } repeats:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)done{
    WS(weakSelf)
    [ActionSheetStringPicker showPickerWithTitle:@"模板下载" rows:@[@"辽宁省综合评标专家库专家申报表",@"能力水平证明（模板）",@"承诺书（模板）",@"社保及退休证样式（参考）",@"辽宁省综合评标专家库专家专业调整申报表",@"辽宁省综合评标专家库续聘专家申请表 "] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSString *shareUrlStr =@"";
        if (selectedIndex == 0) {
            shareUrlStr = @"https://study.capass.cn/Avatar/%EF%BC%88%E6%96%B0%E5%85%A5%E5%BA%93%EF%BC%89%E8%AF%84%E5%AE%A1%E4%B8%93%E5%AE%B6%E5%BA%93%E4%B8%93%E5%AE%B6%E7%94%B3%E6%8A%A5%E8%A1%A8.doc";
            
        } else if (selectedIndex == 1) {
            shareUrlStr = @"https://study.capass.cn/Avatar/%E8%AF%84%E6%A0%87%E4%B8%93%E5%AE%B6%E8%83%BD%E5%8A%9B%E6%B0%B4%E5%B9%B3%E8%AF%81%E6%98%8E%EF%BC%88%E6%A8%A1%E7%89%88%EF%BC%89.docx";
            
        }else if (selectedIndex == 2) {
            shareUrlStr = @"https://study.capass.cn/Avatar/newcommitmentEle.pdf";
        }  else if (selectedIndex == 3) {
            shareUrlStr = @"https://study.capass.cn/Avatar/%E7%A4%BE%E4%BF%9D%E5%8F%8A%E9%80%80%E4%BC%91%E8%AF%81%E6%A0%B7%E5%BC%8F%EF%BC%88%E5%8F%82%E8%80%83%EF%BC%89.pdf";
            
        }  else if (selectedIndex == 3) {
            shareUrlStr = @"https://study.capass.cn/Avatar/%E7%A4%BE%E4%BF%9D%E5%8F%8A%E9%80%80%E4%BC%91%E8%AF%81%E6%A0%B7%E5%BC%8F%EF%BC%88%E5%8F%82%E8%80%83%EF%BC%89.pdf";
            
        }else if (selectedIndex == 4) {
            shareUrlStr = @"https://study.capass.cn/Avatar/%E8%BE%BD%E5%AE%81%E7%9C%81%E7%BB%BC%E5%90%88%E8%AF%84%E6%A0%87%E4%B8%93%E5%AE%B6%E5%BA%93%E4%B8%93%E5%AE%B6%E4%B8%93%E4%B8%9A%E8%B0%83%E6%95%B4%E7%94%B3%E6%8A%A5%E8%A1%A8.docx";
        }else if (selectedIndex == 5) {
            shareUrlStr = @"https://study.capass.cn/Avatar/%E8%BE%BD%E5%AE%81%E7%9C%81%E7%BB%BC%E5%90%88%E8%AF%84%E6%A0%87%E4%B8%93%E5%AE%B6%E5%BA%93%E7%BB%AD%E8%81%98%E4%B8%93%E5%AE%B6%E7%94%B3%E8%AF%B7%E8%A1%A8.doc";
        }

        NSURL *shareUrl = [NSURL URLWithString:shareUrlStr];
        NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
        NSArray*activityItems =@[shareUrl,selectedValue,dateImg];
        
        SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:@"使用浏览器打开" withActivityImage:dateImg withUrl:shareUrl withType:@"CustomActivity" withShareContext:activityItems];
        NSArray *activities = @[customActivit];
        
        UIActivityViewController *activityVC = nil;
        if  (MH_iOS13_VERSTION_LATER) {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
        } else {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        }
        
        activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
        //弹出分享的页面
        [weakSelf presentViewController:activityVC animated:YES completion:nil];
        // 分享后回调
        
        activityVC.completionWithItemsHandler= ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray*_Nullable returnedItems,NSError*_Nullable activityError) {
            
            if(completed) {
                
                NSLog(@"completed");
                
                //分享成功
                
            }else {
                
                NSLog(@"cancled");
                
                //分享取消
                
            }
            
        };
        
        
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

@end
