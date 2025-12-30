//
//  WY_CAMakeUpViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/15.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_CAMakeUpViewController.h"
#import "WY_SignViewController.h"
#import "WY_AddressManageViewController.h"

#import "ImageNewsDetailViewController.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WY_CAMakeSignViewController.h"
 
@interface WY_CAMakeUpViewController ()
{
    int lastY;
    NSString *picType;
    
    UILabel *lblTLq1;
    UILabel *lblTLqBZ;
    UILabel *lblTLqName;
    UILabel *lblTLqPhone;
    UILabel *lblTLqPhone1;
    UIButton *btnLqPhone;
    UILabel *lblTLqAddress;
    UILabel *lblTLqAddress1;
    UILabel *lblTLqGs;
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
@property (nonatomic , strong) NSString *idcardImgUrlA;
@property (nonatomic , strong) NSString *idcardImgUrlB;

@property (nonatomic , strong) UIButton *btnIdCardA;
@property (nonatomic , strong) UIButton *btnIdCardAClose;
@property (nonatomic , strong) UIButton *btnIdCardB;
@property (nonatomic , strong) UIButton *btnIdCardBClose;

@property (nonatomic , strong) UIControl *colEmail;
@property (nonatomic) BOOL isSBFirst;
//bjca、cfca/  bjcaImage 和 cfcaImage
@property (nonatomic , strong) NSString *exportType;
@property (nonatomic , strong) UIImageView *imgSel1;
@property (nonatomic , strong) UIImageView *imgSel2;
@property (nonatomic , strong) NSString *notCAJG;

@property (nonatomic , strong) UIView *viewReceiveType;
@property (nonatomic , strong) UIButton *btnYj;
@property (nonatomic , strong) UIButton *btnLq;

@property (nonatomic , strong) UIButton *btnSY;
@property (nonatomic , strong) UIButton *btnDL;

@property (nonatomic , strong) UIView *viewBuBanType;
@property (nonatomic , strong) UIButton *btnBB1;
@property (nonatomic , strong) UIButton *btnBB2;

@property (nonatomic , strong) UIView *viewSel3Yj;

@property (nonatomic , strong) UIView *viewSel4ALqCity;
@property (nonatomic , strong) UIView *viewSel4Lq;
@property (nonatomic , strong) UIView *viewSel5PayType;
@property (nonatomic , strong) UIView *viewSel6Fp;

@property (nonatomic , strong) UILabel *lblAddressSel;
@property (nonatomic , strong) NSString *payType;//1是微信、2是支付宝
@property (nonatomic , strong) WY_AddressManageModel * selAddress;

//发票- 是
@property (nonatomic , strong) UIButton *btnFpYes;
//发票 - 否
@property (nonatomic , strong) UIButton *btnFpNo;

@property (nonatomic , strong) UIButton *btnTFp3;
@property (nonatomic , strong) UILabel *lblTFp2;
@property (nonatomic , strong) UILabel *lblTFp1;
@property (nonatomic , strong) UILabel *lblTL2;
@end

@implementation WY_CAMakeUpViewController
@synthesize imgSel1,imgSel2,viewReceiveType,viewSel3Yj,viewSel4Lq,viewSel4ALqCity,viewSel5PayType,viewSel6Fp,btnTFp3,lblTFp2,lblTFp1,viewBuBanType,btnBB1,btnBB2;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CA补办";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notCAJGNotify) name:@"notCAJGNotify" object:nil];
     [self makeUI];
    [self bindView];
    
}
 
-(void)notCAJGNotify {
    self.notCAJG = @"1";
}
- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    //
    [self initTopView];
    [self initMiddleView];
    [self initBuBanType];
    [self initWayType];
}
- (void)bindView {
    
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
        self.txtzjName.text = self.dicEditInfo[@"sqrxm"];
        self.txtzjIDCard.text = self.dicEditInfo[@"idcardnum"];
        self.txtzjDanWeiName.text = self.dicEditInfo[@"dwmc"];
        self.txtzjPhone.text = self.dicEditInfo[@"phone"];
        self.txtzjEmail.text = self.dicEditInfo[@"email"];
        self.idcardImgUrlA = self.dicEditInfo[@"sfzzm"];
        self.idcardImgUrlB = self.dicEditInfo[@"sfzfm"];
//        if(self.idcardImgUrlA) {
//            [self.btnIdCardA sd_setImageWithURL:[NSURL URLWithString:self.idcardImgUrlA] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
//            [self.btnIdCardAClose setHidden:NO];
//
//            [self.btnIdCardB sd_setImageWithURL:[NSURL URLWithString:self.idcardImgUrlB] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
//            [self.btnIdCardBClose setHidden:NO];
//        }
       
 
        if ([self.dicEditInfo[@"exportType"] isEqualToString:@"bjcaImage"] || [self.dicEditInfo[@"exportType"] isEqualToString:@"bjca"]) {
            //选择的北京CA
            self.exportType = @"bjca";
            [imgSel1 setImage:[UIImage imageNamed:@"yuan2"]];
            [imgSel2 setImage:[UIImage imageNamed:@"0316_sel"]];
            [self.colEmail setHidden:YES];
            self.viewBuBanType.top = self.colEmail.top + k360Width(5);
        } else {
            //选择的CFCA
            [imgSel1 setImage:[UIImage imageNamed:@"0316_sel"]];
            [imgSel2 setImage:[UIImage imageNamed:@"yuan2"]];
            [self.colEmail setHidden:NO];
            self.viewBuBanType.top = self.colEmail.bottom + k360Width(5);
        }
        
        [self.btnFpYes setSelected:[self.dicEditInfo[@"isInvoice"] intValue] == 1];
        [self.btnFpNo setSelected:[self.dicEditInfo[@"isInvoice"] intValue] != 1];
        
        
        //改收货方式
        if ([self.dicEditInfo[@"islingqu"] intValue] == 1) {
            //领取
            [viewSel3Yj setHidden:!NO];
            [viewSel4Lq setHidden:!YES];
            self.lblTL2.text = @"领取城市";
            [viewSel4ALqCity setHidden:!YES];
            [self.btnYj setSelected:!YES];
            [self.btnLq setSelected:!NO];
            viewSel4Lq.top =  viewSel4ALqCity.bottom + k375Width(5);
            viewSel5PayType.top = viewSel4Lq.bottom + k375Width(5);
            
            if ([self.isEdit isEqualToString:@"2"]) {
                viewSel6Fp.top = viewSel5PayType.top;
                [viewSel5PayType setHidden:YES];
            } else {
                [viewSel5PayType setHidden:NO];
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
            //显示发货城市选择-
            [viewSel4ALqCity setHidden:NO];
            viewSel3Yj.top = viewSel4ALqCity.bottom + k375Width(5);
            self.lblTL2.text = @"发货城市";
            viewSel5PayType.top = viewSel3Yj.bottom + k375Width(5);
            
            
            if ([self.isEdit isEqualToString:@"2"]) {
                viewSel6Fp.top = viewSel5PayType.top;
                [viewSel5PayType setHidden:YES];
            } else {
                [viewSel5PayType setHidden:NO];
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
    
    [self.txtzjName setEnabled:NO];
    [self.txtzjIDCard setEnabled:NO];
    [self.txtzjPhone setEnabled:NO];
    [self.txtzjName setTextColor:HEXCOLOR(0xd8d8d8)];
    [self.txtzjIDCard setTextColor:HEXCOLOR(0xd8d8d8)];
    [self.txtzjPhone setTextColor:HEXCOLOR(0xd8d8d8)];
    [self.txtzjName setFont:WY_FONT375Medium(14)];
    [self.txtzjIDCard setFont:WY_FONT375Medium(14)];
    [self.txtzjPhone setFont:WY_FONT375Medium(14)];
    
    [self.txtzjDanWeiName setEnabled:NO];
    [self.txtzjEmail setEnabled:NO];
     [self.txtzjDanWeiName setTextColor:HEXCOLOR(0xd8d8d8)];
     [self.txtzjEmail setTextColor:HEXCOLOR(0xd8d8d8)];
    [self.txtzjDanWeiName setFont:WY_FONT375Medium(14)];
    [self.txtzjEmail setFont:WY_FONT375Medium(14)];

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
    [img2 setImage:[UIImage imageNamed:@"0611_ws2h"]];
 
    [self.viewTop addSubview:img1];
    [self.viewTop addSubview:img2];
     [self.viewTop addSubview:lbltop1];
    [self.viewTop addSubview:lbltop2];
     [self.viewTop addSubview:lblLine1];
 
    [lbltop1 setTextColor:HEXCOLOR(0x0F6DD2)];
    [lbltop2 setTextColor:HEXCOLOR(0x8B8B8B)];
 
    [lbltop1 setTextAlignment:NSTextAlignmentCenter];
    [lbltop2 setTextAlignment:NSTextAlignmentCenter];
 
    
    [lblLine1 setTextColor:HEXCOLOR(0x8B8B8B)];
 
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

- (void)lqDataBind {
    if (self.btnSY.selected) {
        [lblTLqBZ setText:self.dicEditInfo[@"lqbz2"]];
        [lblTLqGs setText:[NSString stringWithFormat:@"联系单位：%@",self.dicEditInfo[@"lqdw2"]]];
        [lblTLqAddress setText:@"领取地址："];
        [lblTLqAddress1 setText:self.dicEditInfo[@"lqdz2"]];
        [lblTLqName setText:[NSString stringWithFormat:@"联 系 人 ：%@",self.dicEditInfo[@"lqlxr2"]]];
        [lblTLqPhone setText:@"联系电话："];
        NSMutableArray *lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicEditInfo[@"lqdh2"] componentsSeparatedByString:@"，"]];
        NSString *lqdhsStr = [lqdhs componentsJoinedByString:@"\n"];
        [lblTLqPhone1 setText:lqdhsStr];
    } else {
        [lblTLqBZ setText:self.dicEditInfo[@"lqbz1"]];
        [lblTLqGs setText:[NSString stringWithFormat:@"联系单位：%@",self.dicEditInfo[@"lqdw1"]]];
        [lblTLqAddress setText:@"领取地址："];
        [lblTLqAddress1 setText:self.dicEditInfo[@"lqdz1"]];
        [lblTLqName setText:[NSString stringWithFormat:@"联 系 人 ：%@",self.dicEditInfo[@"lqlxr1"]]];
        [lblTLqPhone setText:@"联系电话："];
        NSMutableArray *lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicEditInfo[@"lqdh1"] componentsSeparatedByString:@"，"]];
        NSString *lqdhsStr = [lqdhs componentsJoinedByString:@"\n"];
        [lblTLqPhone1 setText:lqdhsStr];
    }
    
    [lblTLqBZ setFrame:CGRectMake(k375Width(16), lblTLq1.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(50))];
    [lblTLqBZ setNumberOfLines:0];
    [lblTLqBZ setTextColor:[UIColor blackColor]];
    [lblTLqBZ setFont:WY_FONT375Medium(14)];
    [lblTLqBZ sizeToFit];
    lblTLqBZ.height += k360Width(12);
    
    [lblTLqGs setFrame:CGRectMake(k375Width(16), lblTLqBZ.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(22))];
    [lblTLqGs setTextColor:HEXCOLOR(0x434343)];
    [lblTLqGs setFont:WY_FONT375Regular(14)];
    
    [lblTLqAddress setFrame:CGRectMake(k375Width(16), lblTLqGs.bottom + k375Width(5), k375Width(80), k375Width(22))];
    
    [lblTLqAddress setTextColor:HEXCOLOR(0x434343)];
    [lblTLqAddress setFont:WY_FONT375Regular(14)];
    
    
    
    [lblTLqAddress1 setFrame:CGRectMake(lblTLqAddress.right- k360Width(10), lblTLqAddress.top, kScreenWidth - lblTLqAddress.right + k360Width(10), k360Width(44))];
    [lblTLqAddress1 setTextColor:HEXCOLOR(0x434343)];
    
    
    [lblTLqAddress1 setNumberOfLines:0];
    [lblTLqAddress1 sizeToFit];
    lblTLqAddress1.height += k360Width(12);
    [lblTLqAddress1 setFont:WY_FONT375Regular(14)];
    
    lblTLqAddress.centerY = lblTLqAddress1.centerY;
    
    
    
    
    [lblTLqName setFrame:CGRectMake(k375Width(16), lblTLqAddress1.bottom + k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTLqName setTextColor:HEXCOLOR(0x434343)];
    [lblTLqName setFont:WY_FONT375Regular(14)];
    
    
    [lblTLqPhone setFrame:CGRectMake(k375Width(16), lblTLqName.bottom + k375Width(5), k375Width(80), k375Width(22))];
    
    [lblTLqPhone setTextColor:HEXCOLOR(0x434343)];
    [lblTLqPhone setFont:WY_FONT375Regular(14)];
    
    
    
    [lblTLqPhone1 setFrame:CGRectMake(lblTLqPhone.right - k360Width(10), lblTLqPhone.top, kScreenWidth - lblTLqPhone.right - k360Width(52), k360Width(44))];
    [lblTLqPhone1 setTextColor:HEXCOLOR(0x434343)];
    
    [lblTLqPhone1 setFont:WY_FONT375Regular(14)];
    [lblTLqPhone1 setNumberOfLines:0];
    [lblTLqPhone1 sizeToFit];
    lblTLqPhone1.height += k360Width(12);
    lblTLqPhone.centerY = lblTLqPhone1.centerY;
    
    
    
    [btnLqPhone setFrame:CGRectMake(kScreenWidth - k360Width(22+16), lblTLqPhone.top + k375Width(10), k375Width(22), k375Width(22))];
    [btnLqPhone setImage:[UIImage imageNamed:@"0317phone"] forState:UIControlStateNormal];
    [btnLqPhone setCenterY:lblTLqPhone.centerY];
}


- (void)initMiddleView {
    
    
    //默认选择CFCA
    self.exportType = @"cfca";
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - self.viewTop.bottom - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    UILabel *lblT1 = [UILabel new];
    UIView *viewSel1 = [UIView new];
    UIView *viewSel2 = [UIView new];
    UILabel *lblT2 = [UILabel new];
    UILabel *lblT3 = [UILabel new];
    
    [lblT1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblT1 setText:@"补办专家CA数字证书（UKEY）"];
    [lblT1 setTextColor:HEXCOLOR(0x666666)];
    [lblT1 setFont:WY_FONT375Medium(16)];
    [self.mScrollView addSubview:lblT1];
    
    [viewSel1 setFrame:CGRectMake(0, lblT1.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    [viewSel1 setBackgroundColor:[UIColor whiteColor]];
    
    [lblT2 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblT2 setText:@"CA机构"];
    [lblT2 setTextColor:HEXCOLOR(0x434343)];
    [lblT2 setFont:WY_FONT375Medium(14)];
    [viewSel1 addSubview:lblT2];

    UIControl *col1 = [UIControl new];
    UIImageView *imgCFCA = [UIImageView new];
    imgSel1 = [UIImageView new];
    UILabel *lblCFCAName = [UILabel new];
    
    [col1 setFrame:CGRectMake(k375Width(16), lblT2.bottom+k375Width(5), kScreenWidth - k375Width(32), k375Width(44))];
//    [col1 setBackgroundColor:[UIColor redColor]];
    [viewSel1 addSubview:col1];
    
    [imgCFCA setFrame:CGRectMake(k375Width(16), k375Width(6), k375Width(20), k375Width(20))];
    [imgCFCA setImage:[UIImage imageNamed:@"cfcaicon"]];
    [col1 addSubview:imgCFCA];
    
    [lblCFCAName setFrame:CGRectMake(imgCFCA.right + k375Width(10), k375Width(6), k375Width(300), k375Width(20))];
    [lblCFCAName setText:@"中国金融认证中心（CFCA）"];
    [lblCFCAName setFont:WY_FONT375Regular(14)];
    [col1 addSubview:lblCFCAName];

    [imgSel1 setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
    [imgSel1 setImage:[UIImage imageNamed:@"0316_sel"]];
    [col1 addSubview:imgSel1];

    
    UIControl *col2 = [UIControl new];
    UIImageView *imgBJCA = [UIImageView new];
    imgSel2 = [UIImageView new];
    UILabel *lblBJCAName = [UILabel new];
    
    [col2 setFrame:CGRectMake(k375Width(16), col1.bottom, kScreenWidth - k375Width(32), k375Width(44))];
    [viewSel1 addSubview:col2];
    
    [imgBJCA setFrame:CGRectMake(k375Width(16), k375Width(6), k375Width(20), k375Width(20))];
    [imgBJCA setImage:[UIImage imageNamed:@"bjcaicon"]];
    [col2 addSubview:imgBJCA];
    
    [lblBJCAName setFrame:CGRectMake(imgBJCA.right + k375Width(10), k375Width(6), k375Width(300), k375Width(20))];
    [lblBJCAName setText:@"北京数字认证股份有限公司（BJCA）"];
    [lblBJCAName setFont:WY_FONT375Regular(14)];
    [col2 addSubview:lblBJCAName];

    [imgSel2 setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
    [imgSel2 setImage:[UIImage imageNamed:@"yuan2"]];
    [col2 addSubview:imgSel2];
     
    if ([self.dicEditInfo[@"exportType"] isEqualToString:@"bjcaImage"] || [self.dicEditInfo[@"exportType"] isEqualToString:@"bjca"]) {        
        [col1 setHidden:YES];
        col2.top = col1.top;
    } else {
        [col2 setHidden:YES];
    }
    [viewSel1 setHeight:k360Width(76)];
    [viewSel2 setFrame:CGRectMake(0, viewSel1.bottom + k375Width(5), kScreenWidth, k375Width(70))];
    [viewSel2 setBackgroundColor:[UIColor whiteColor]];
    
    [lblT3 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblT3 setText:@"证书有效期至"];
    [lblT3 setTextColor:HEXCOLOR(0x434343)];
    [lblT3 setFont:WY_FONT375Medium(14)];
    [viewSel2 addSubview:lblT3];
 
    UIControl *col3 = [UIControl new];
    UIImageView *imgYXQ = [UIImageView new];
    UIImageView *imgSel3 = [UIImageView new];
    UILabel *lblYXQName = [UILabel new];
    
    [col3 setFrame:CGRectMake(k375Width(16), lblT3.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(44))];
    [viewSel2 addSubview:col3];
    
    [imgYXQ setFrame:CGRectMake(k375Width(16), k375Width(6), k375Width(20), k375Width(20))];
    [imgYXQ setImage:[UIImage imageNamed:@"0317_yxq"]];
    [col3 addSubview:imgYXQ];
    
    NSMutableAttributedString *yxqStr = [[NSMutableAttributedString alloc] init];
    if ([self.dicEditInfo[@"dqsj"] isEqual:[NSNull null]]) {
        [yxqStr yy_appendString:@"无到期时间"];
    } else {
        NSDate *dateYxq = [NSDate dateWithString:self.dicEditInfo[@"dqsj"] format:@"yyyy-MM-dd HH:mm:ss" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        
        NSDate*dateB = [NSDate date];

        NSComparisonResult result = [dateYxq compare:dateB];

        if (result == NSOrderedDescending) {
            [yxqStr yy_appendString:[NSString stringWithFormat:@"%@(已过期)",self.dicEditInfo[@"dqsj"]]];
            [yxqStr setYy_color:[UIColor redColor]];
        }
        else if(result ==NSOrderedAscending){

            //没过指定时间 没过期
            [yxqStr yy_appendString:self.dicEditInfo[@"dqsj"]];
        } else {
            [yxqStr yy_appendString:self.dicEditInfo[@"dqsj"]];
        }
    }
     
    
    [lblYXQName setFrame:CGRectMake(imgYXQ.right + k375Width(10), k375Width(6), k375Width(300), k375Width(20))];
    [lblYXQName setText:self.dicEditInfo[@"dqsj"]];
    [lblYXQName setFont:WY_FONT375Regular(14)];
    [col3 addSubview:lblYXQName];

    [imgSel3 setFrame:CGRectMake(kScreenWidth - k375Width(52), k375Width(6), k375Width(20), k375Width(20))];
    [imgSel3 setImage:[UIImage imageNamed:@"0316_sel"]];
    [col3 addSubview:imgSel3];

    
    
    [self.mScrollView addSubview:viewSel1];
    [self.mScrollView addSubview:viewSel2];
    
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
    
    
 }
///加载收货方式模块
- (void)initWayType {
    
    viewReceiveType = [UIView new];
     self.viewSel3Yj = [UIView new];
    self.viewSel4Lq = [UIView new];
    self.viewSel4ALqCity = [UIView new];
    self.viewSel5PayType = [UIView new];
    self.viewSel6Fp = [UIView new];
    //领取方式
    [viewReceiveType setFrame:CGRectMake(0, viewBuBanType.bottom + k375Width(5), kScreenWidth, k375Width(90))];
    [viewReceiveType setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lblTL1 = [UILabel new];
    [lblTL1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTL1 setText:@"领取方式"];
    [lblTL1 setTextColor:HEXCOLOR(0x434343)];
    [lblTL1 setFont:WY_FONT375Medium(14)];
    [viewReceiveType addSubview:lblTL1];
    
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
    
    [viewReceiveType addSubview:self.btnYj];
    [viewReceiveType addSubview:self.btnLq];
    
    
    [viewSel3Yj setFrame:CGRectMake(0, viewReceiveType.bottom + k375Width(5), kScreenWidth, k375Width(120))];
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
    
    [viewSel4ALqCity setFrame:CGRectMake(0, viewReceiveType.bottom + k375Width(5), kScreenWidth, k375Width(90))];
     [viewSel4ALqCity setBackgroundColor:[UIColor whiteColor]];

    
    self.lblTL2 = [UILabel new];
    [self.lblTL2 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [self.lblTL2 setText:@"发货城市"];
    [self.lblTL2 setTextColor:HEXCOLOR(0x434343)];
    [self.lblTL2 setFont:WY_FONT375Medium(14)];
    [viewSel4ALqCity addSubview:self.lblTL2];
    
    self.btnSY = [UIButton new];
    self.btnDL = [UIButton new];
    
    [self.btnSY setFrame:CGRectMake(k375Width(32), lblTL1.bottom + k375Width(10), k375Width(150), k375Width(30))];
    
    [self.btnDL setFrame:CGRectMake(self.btnSY.right + k375Width(50), lblTL1.bottom + k375Width(10), k375Width(100), k375Width(30))];
    
    [self.btnSY setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnSY setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnSY setTitle:@"沈阳市" forState:UIControlStateNormal];
    [self.btnSY setSelected:YES];
    
    [self.btnSY  setTitleColor:HEXCOLOR(0x434343) forState:UIControlStateNormal];
    [self.btnDL  setTitleColor:HEXCOLOR(0x434343) forState:UIControlStateNormal];
    
    [self.btnSY.titleLabel setFont:WY_FONT375Regular(14)];
    [self.btnDL.titleLabel setFont:WY_FONT375Regular(14)];
    [self.btnSY setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnDL setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnSY setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnDL setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [self.btnDL setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnDL setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnDL setTitle:@"大连市" forState:UIControlStateNormal];
    
    [viewSel4ALqCity addSubview:self.btnSY];
    [viewSel4ALqCity addSubview:self.btnDL];
     
    
    [viewSel4Lq setFrame:CGRectMake(0, viewSel4ALqCity.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    [viewSel4Lq setBackgroundColor:[UIColor whiteColor]];
    
    
    lblTLq1 = [UILabel new];
    [lblTLq1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTLq1 setText:@"领取："];
    [lblTLq1 setTextColor:HEXCOLOR(0x434343)];
    [lblTLq1 setFont:WY_FONT375Medium(14)];
    [viewSel4Lq addSubview:lblTLq1];
    lblTLqBZ = [UILabel new];
    lblTLqName = [UILabel new];
    lblTLqPhone = [UILabel new];
    lblTLqPhone1 = [UILabel new];
    
    btnLqPhone = [UIButton new];
    lblTLqAddress = [UILabel new];
    lblTLqAddress1 = [UILabel new];
    lblTLqGs = [UILabel new];
    
    
    
    [lblTLqBZ setFrame:CGRectMake(k375Width(16), lblTLq1.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(50))];
    [lblTLqBZ setNumberOfLines:0];
    [lblTLqBZ setText:self.dicEditInfo[@"lqbz"]];
    [lblTLqBZ setTextColor:[UIColor blackColor]];
    [lblTLqBZ setFont:WY_FONT375Medium(14)];
    [viewSel4Lq addSubview:lblTLqBZ];
    [lblTLqBZ sizeToFit];
    lblTLqBZ.height += k360Width(12);

    [lblTLqGs setFrame:CGRectMake(k375Width(16), lblTLqBZ.bottom + k375Width(5), kScreenWidth - k375Width(32), k375Width(22))];
    [lblTLqGs setText:[NSString stringWithFormat:@"联系单位：%@",self.dicEditInfo[@"lqdw"]]];
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
    
    [lblTLqAddress1 setText:self.dicEditInfo[@"lqdz"]];
    [lblTLqAddress1 setNumberOfLines:0];
    [lblTLqAddress1 sizeToFit];
    lblTLqAddress1.height += k360Width(12);
    [lblTLqAddress1 setFont:WY_FONT375Regular(14)];
    
    lblTLqAddress.centerY = lblTLqAddress1.centerY;
    [viewSel4Lq addSubview:lblTLqAddress1];
    
    
    
    [lblTLqName setFrame:CGRectMake(k375Width(16), lblTLqAddress1.bottom + k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTLqName setText:[NSString stringWithFormat:@"联 系 人 ：%@",self.dicEditInfo[@"lqlxr"]]];
    [lblTLqName setTextColor:HEXCOLOR(0x434343)];
    [lblTLqName setFont:WY_FONT375Regular(14)];
    [viewSel4Lq addSubview:lblTLqName];
    
    //    [lblTLqPhone setFrame:CGRectMake(k375Width(16), lblTLqName.bottom + k375Width(5), kScreenWidth - k375Width(60), k375Width(44))];
    //    [lblTLqPhone setNumberOfLines:0];
    //    [lblTLqPhone setText:[NSString stringWithFormat:@"联系电话：%@",self.dicEditInfo[@"lqdh"]]];
    //    [lblTLqPhone setTextColor:HEXCOLOR(0x434343)];
    //    [lblTLqPhone setFont:WY_FONT375Regular(14)];
    //    [viewSel4Lq addSubview:lblTLqPhone];
    
    
    [lblTLqPhone setFrame:CGRectMake(k375Width(16), lblTLqName.bottom + k375Width(5), k375Width(80), k375Width(22))];
    [lblTLqPhone setText:@"联系电话："];
    [lblTLqPhone setTextColor:HEXCOLOR(0x434343)];
    [lblTLqPhone setFont:WY_FONT375Regular(14)];
    [viewSel4Lq addSubview:lblTLqPhone];
    
    NSMutableArray *lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicEditInfo[@"lqdh"] componentsSeparatedByString:@"，"]];
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
    
    [self lqDataBind];
    
    [btnLqPhone setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
//        NSMutableArray *lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicEditInfo[@"lqdh"] componentsSeparatedByString:@"，"]];
        
        NSMutableArray *lqdhs = nil;
        if(self.btnSY.selected) {
            lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicEditInfo[@"lqdh2"] componentsSeparatedByString:@"，"]];
        } else {
            lqdhs = [[NSMutableArray alloc] initWithArray:[self.dicEditInfo[@"lqdh1"] componentsSeparatedByString:@"，"]];
        }
        
        
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
    //显示发货城市选择-
    [viewSel4ALqCity setHidden:NO];
    viewSel3Yj.top = viewSel4ALqCity.bottom + k375Width(5);
 
    
    
    //支付方式
    [viewSel5PayType setFrame:CGRectMake(0, viewSel3Yj.bottom + k375Width(5), kScreenWidth, k375Width(120))];
    [viewSel5PayType setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lblTPay1 = [UILabel new];
    [lblTPay1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTPay1 setText:@"支付方式"];
    [lblTPay1 setTextColor:HEXCOLOR(0x434343)];
    [lblTPay1 setFont:WY_FONT375Medium(14)];
    [viewSel5PayType addSubview:lblTPay1];
    
    UIControl *colWchat = [UIControl new];
    UIImageView *imgWchat = [UIImageView new];
    UIImageView *imgWchatSel = [UIImageView new];
    UILabel *lblWchatName = [UILabel new];
    
    [colWchat setFrame:CGRectMake(k375Width(16), lblTPay1.bottom+k375Width(5), kScreenWidth - k375Width(32), k375Width(44))];
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
    [imgWchatSel setImage:[UIImage imageNamed:@"0316_sel"]];
    self.payType = @"03";
    [colWchat addSubview:imgWchatSel];
    
    
    UIControl *colAliPay = [UIControl new];
    UIImageView *imgAliPay = [UIImageView new];
    UIImageView *imgAliPaySel = [UIImageView new];
    UILabel *lblAliPayName = [UILabel new];
    
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
 
    [colWchat addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.payType = @"03";
        [imgWchatSel setImage:[UIImage imageNamed:@"0316_sel"]];
        [imgAliPaySel setImage:[UIImage imageNamed:@"yuan2"]];
        
    }];
    
    [colAliPay addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.payType = @"02";
        
        [imgWchatSel setImage:[UIImage imageNamed:@"yuan2"]];
        [imgAliPaySel setImage:[UIImage imageNamed:@"0316_sel"]];
    }];
    
    //支付宝支付方式- 暂时隐藏；
//    [colAliPay setHidden:YES];
    viewSel5PayType.height = colAliPay.bottom + k360Width(5);
    
    //发票信息
    [viewSel6Fp setFrame:CGRectMake(0, viewSel5PayType.bottom + k375Width(5), kScreenWidth, k375Width(44))];
    if ([self.isEdit isEqualToString:@"2"]) {
        viewSel6Fp.top = viewSel5PayType.top;
        [viewSel5PayType setHidden:YES];
    } else {
        [viewSel5PayType setHidden:NO];
        viewSel6Fp.top = viewSel5PayType.bottom + k375Width(5);
    }
    [viewSel6Fp setBackgroundColor:[UIColor whiteColor]];
    
    lblTFp1 = [UILabel new];
    [lblTFp1 setFrame:CGRectMake(k375Width(16), 0, kScreenWidth - k375Width(10), k375Width(44))];
    [lblTFp1 setText:@"是否开具电子发票"];
    [lblTFp1 setTextColor:HEXCOLOR(0x434343)];
    [lblTFp1 setFont:WY_FONT375Medium(14)];
    [viewSel6Fp addSubview:lblTFp1];
    
    lblTFp2 = [UILabel new];
    [lblTFp2 setFrame:CGRectMake(k375Width(16), k360Width(44), kScreenWidth - k375Width(32), k375Width(44))];
    [lblTFp2 setText:@"您办理的专家数字证书(CA) 为您的个人行为，根据《中华人民共和国发票管理办法》第十九、二十条规定，本公司将为您提供增值税电子普通发票，抬头为申请人姓名。增值税电子普通发票法律效力、基本用途、基本使用规定等与增值税普通发票相同，如需纸质普通发票请联系财务024- -67793888。"];
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
        [self goImageShow:@"http://lnwlzj.capass.cn/lnwlzj/a81f9a91948049c49a6016c586e77942.jpg"];
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
    
//    [self.mScrollView addSubview:viewSel1];
    [self.mScrollView addSubview:viewReceiveType];
    [self.mScrollView addSubview:viewSel3Yj];
    [self.mScrollView addSubview:viewSel4Lq];
    [self.mScrollView addSubview:viewSel4ALqCity];
    [self.mScrollView addSubview:viewSel5PayType];
    [self.mScrollView addSubview:viewSel6Fp];
    
    [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
    [self.btnYj addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [viewSel3Yj setHidden:NO];
        [viewSel4Lq setHidden:YES];
        [self.btnYj setSelected:YES];
        [self.btnLq setSelected:NO];
        
        //显示发货城市选择-
        [viewSel4ALqCity setHidden:NO];
        viewSel3Yj.top = viewSel4ALqCity.bottom + k375Width(5);
        self.lblTL2.text = @"发货城市";
        viewSel5PayType.top = viewSel3Yj.bottom + k375Width(5);
        
        if ([self.isEdit isEqualToString:@"2"]) {
            viewSel6Fp.top = viewSel5PayType.top;
            [viewSel5PayType setHidden:YES];
        } else {
            [viewSel5PayType setHidden:NO];
            viewSel6Fp.top = viewSel5PayType.bottom + k375Width(5);
        }
        [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
        
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
        [viewSel4ALqCity setHidden:!YES];
        [self.btnYj setSelected:!YES];
        [self.btnLq setSelected:!NO];
        viewSel4Lq.top =  viewSel4ALqCity.bottom + k375Width(5);
        viewSel5PayType.top = viewSel4Lq.bottom + k375Width(5);
        self.lblTL2.text = @"领取城市";
        
        if ([self.isEdit isEqualToString:@"2"]) {
            viewSel6Fp.top = viewSel5PayType.top;
            [viewSel5PayType setHidden:YES];
        } else {
            [viewSel5PayType setHidden:NO];
            viewSel6Fp.top = viewSel5PayType.bottom + k375Width(5);
        }
        [self.mScrollView setContentSize:CGSizeMake(0, viewSel6Fp.bottom + k375Width(16)) ];
        
    }];

    
    [self.btnSY addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.btnSY setSelected:YES];
        [self.btnDL setSelected:!YES];
        [self lqDataBind];
    }];
    [self.btnDL addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.btnSY setSelected:!YES];
        [self.btnDL setSelected:YES];
        [self lqDataBind];
    }];
    
}
///加载补办类型
- (void)initBuBanType {
    viewBuBanType = [UIView new];
    //补办类型
    if ([self.dicEditInfo[@"exportType"] isEqualToString:@"bjcaImage"] || [self.dicEditInfo[@"exportType"] isEqualToString:@"bjca"]) {
        //选择的北京CA
        [viewBuBanType setFrame:CGRectMake(0, self.colEmail.top + k375Width(5), kScreenWidth, k375Width(90))];

    } else {
        //选择的CFCA
       [viewBuBanType setFrame:CGRectMake(0, self.colEmail.bottom + k375Width(5), kScreenWidth, k375Width(90))];
    }
    
    [viewBuBanType setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lblTL1 = [UILabel new];
    [lblTL1 setFrame:CGRectMake(k375Width(16), k375Width(5), kScreenWidth - k375Width(10), k375Width(22))];
    [lblTL1 setText:@"补办类型"];
    [lblTL1 setTextColor:HEXCOLOR(0x434343)];
    [lblTL1 setFont:WY_FONT375Medium(14)];
    [viewBuBanType addSubview:lblTL1];
    
    self.btnBB1 = [UIButton new];
    self.btnBB2 = [UIButton new];
    
    [self.btnBB1 setFrame:CGRectMake(k375Width(32), lblTL1.bottom + k375Width(10), k375Width(150), k375Width(30))];
    
    [self.btnBB2 setFrame:CGRectMake(self.btnBB1.right + k375Width(50), lblTL1.bottom + k375Width(10), k375Width(100), k375Width(30))];
    
    [self.btnBB1 setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnBB1 setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnBB1 setTitle:@"介质丢失" forState:UIControlStateNormal];
    [self.btnBB1 setSelected:YES];
    
    [self.btnBB1  setTitleColor:HEXCOLOR(0x434343) forState:UIControlStateNormal];
    [self.btnBB2  setTitleColor:HEXCOLOR(0x434343) forState:UIControlStateNormal];
    
    [self.btnBB1.titleLabel setFont:WY_FONT375Regular(14)];
    [self.btnBB2.titleLabel setFont:WY_FONT375Regular(14)];
    [self.btnBB1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnBB2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnBB1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnBB2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [self.btnBB2 setImage:[UIImage imageNamed:@"yuan2"] forState:UIControlStateNormal];
    [self.btnBB2 setImage:[UIImage imageNamed:@"0316_sel"] forState:UIControlStateSelected];
    [self.btnBB2 setTitle:@"介质损坏" forState:UIControlStateNormal];
    
    [viewBuBanType addSubview:self.btnBB1];
    [viewBuBanType addSubview:self.btnBB2];
    [self.mScrollView addSubview:viewBuBanType];
    
    [self.btnBB1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
         [self.btnBB1 setSelected:YES];
        [self.btnBB2 setSelected:NO];
     }];
    
    [self.btnBB2 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
         [self.btnBB1 setSelected:!YES];
        [self.btnBB2 setSelected:!NO];
    }];

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
    if (self.txtzjDanWeiName.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtzjDanWeiName.placeholder];
        [self.txtzjDanWeiName becomeFirstResponder];
        return;
    }
    if (self.txtzjPhone.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtzjPhone.placeholder];
        [self.txtzjPhone becomeFirstResponder];
        return;
    }
    if ([self.exportType isEqualToString:@"cfca"] && self.txtzjEmail.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtzjEmail.placeholder];
        [self.txtzjEmail becomeFirstResponder];
        return;
    }
    if ([self.exportType isEqualToString:@"cfca"] && ![GlobalConfig isValidateEmail:self.txtzjEmail.text]) {
        [SVProgressHUD showErrorWithStatus:@"邮箱格式不正确"];
        [self.txtzjEmail becomeFirstResponder];
        return;
    }
      /*
       {
           "dwmc": "铁岭市国土资源调查规划局",
           "email": "943334315@qq.com",
           "exportType": "cabb",
           "idcardnum": "210105199409111919",
           "phone": "18341359697",
           "sqrxm": "张庆东",
           "bbType":2,
           "shfs":1,
           "shrxm":"张芷维",
           "shrdz":"15902490120",
           "shrdh":"铁西广场"
       }
       */
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.txtzjPhone.text forKey:@"phone"];
    [postDic setObject:self.txtzjName.text forKey:@"sqrxm"];
    [postDic setObject:self.txtzjIDCard.text forKey:@"idcardnum"];
    [postDic setObject:self.txtzjDanWeiName.text forKey:@"dwmc"];
    [postDic setObject:self.txtzjEmail.text forKey:@"email"];
    [postDic setObject:@"cabb" forKey:@"exportType"];
    if (self.btnBB1.selected) {
        [postDic setObject:@"1" forKey:@"bbType"];
    } else {
        [postDic setObject:@"2" forKey:@"bbType"];
    }
    [postDic setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"userguid"];
    [postDic setObject:self.dicEditInfo[@"caType"] forKey:@"caType"];

    if (self.btnSY.selected) {
        //沈阳
        [postDic setObject:@"0024" forKey:@"cityCode"];
        [postDic setObject:@"0024" forKey:@"fhcityCode"];
    } else {
        //大连
        [postDic setObject:@"0411" forKey:@"cityCode"];
        [postDic setObject:@"0411" forKey:@"fhcityCode"];
    }
    
    //收货方式1领取、2邮寄
    if (self.btnYj.selected) {
        if (!self.selAddress) {
            //如果是邮寄， 并没有选择收货人信息的话 ，弹出提示；
            [SVProgressHUD showErrorWithStatus:@"请选择收货人地址"];
            return;
        }
        //邮寄
        [postDic setObject:@"2" forKey:@"shfs"];
        //收货人姓名
        [postDic setObject:self.selAddress.UserName forKey:@"shrxm"];
        //收货人电话
        [postDic setObject:self.selAddress.Mobile forKey:@"shrdh"];
        //收货人省
        [postDic setObject:self.selAddress.ProvinceCode forKey:@"provinceCode"];
        //收货人市
        [postDic setObject:self.selAddress.CityCode forKey:@"cityCode"];
        //收货人区
        [postDic setObject:self.selAddress.CountryCode forKey:@"countryCode"];
        //收货人地址
        [postDic setObject:self.selAddress.addressStr forKey:@"shrdz"];
        
    } else {
        //领取
        [postDic setObject:@"1" forKey:@"shfs"];
        //收货人姓名
        [postDic setObject:@"" forKey:@"shrxm"];
        //收货人电话
        [postDic setObject:@"" forKey:@"shrdh"];
        //收货人省
        [postDic setObject:@"" forKey:@"provinceCode"];
        //收货人市
//        [postDic setObject:@"" forKey:@"cityCode"];
        //收货人区
        [postDic setObject:@"" forKey:@"countryCode"];
        //收货人地址
        [postDic setObject:@"" forKey:@"shrdz"];
        
       
    }
    
    //是否开具发票 0否  1是
    if (self.btnFpYes.selected) {
        [postDic setObject:@"1" forKey:@"isInvoice"];
    } else {
        [postDic setObject:@"0" forKey:@"isInvoice"];
    }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_createBB_HTTP params:nil jsonData:[postDic mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            
            WY_CAMakeSignViewController *tempController = [WY_CAMakeSignViewController new];
            tempController.payType = self.payType;
            tempController.isEdit = self.isEdit;
            tempController.dicEditInfo = self.dicEditInfo;
            //身份证正反面
            [postDic setObject:self.idcardImgUrlA forKey:@"sfzzm"];
            [postDic setObject:self.idcardImgUrlB forKey:@"sfzfm"];
            tempController.dicPostCAInfo = postDic;
            tempController.pdfUrl = res[@"data"];
            [self.navigationController pushViewController:tempController animated:YES];

         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
    
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
    //添加身份证A面；
    if (self.idcardImgUrlA.length > 0) {
        [self goImageShow:self.idcardImgUrlA];
    } else {
        picType = @"1";
        [self navRightAddPhotoAction];
    }
}
- (void)btnIdCardACloseAction {
    //删除身份证A面；
    [self.btnIdCardAClose setHidden:YES];
    self.idcardImgUrlA = @"";
    [self.btnIdCardA setImage:[UIImage imageNamed:@"0407_guohui"] forState:UIControlStateNormal];
    
}
- (void)btnIdCardBCloseAction {
    //删除身份证A面；
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
    
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
//    {
//
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
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
        if ([picType isEqualToString:@"1"]) {
            //身份证正面；
            self.idcardImgUrlA = picUrl;
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
@end
