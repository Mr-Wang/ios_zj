//
//  WY_SelectInvoiceViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SelectInvoiceViewController.h"
#import "WY_AddressManageViewController.h"
#import "WY_AddressManageModel.h"
#import <AVFoundation/AVFoundation.h>

@interface WY_SelectInvoiceViewController () {
    int lastY;
    int selMailTypeIndex;
        NSString *PicFilePath;
}
@property (nonatomic, strong) UIButton *btnTopLeft;     //公司发票按钮
@property (nonatomic, strong) UIButton *btnTopRight;    //个人发票按钮
@property (nonatomic, strong) UIButton *btnInvoiceType1;    //电子普通
@property (nonatomic, strong) UIButton *btnInvoiceType2;    //纸质普通
@property (nonatomic, strong) UIButton *btnInvoiceType3;    //纸质专票

@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIView *viewLeftInfo;     //公司发票View
@property (nonatomic, strong) UIView *viewRightInfo;    //个人发票View
@property (nonatomic, strong) UIView *viewInvoiceTop;
@property (nonatomic, strong) UIView *viewInvoiceType1;  //电子普通TopView
@property (nonatomic, strong) UIView *viewInvoiceType2;  //纸票TopView
@property (nonatomic, strong) UIView *viewInvoiceAddressType2;  //纸票邮寄隐藏View
@property (nonatomic, strong) UIView *viewMiddle;   //税号-银行账户添加模块 统一；

@property (nonatomic, strong) UIControl *viewBottomType3;  //纸质专票BottomView
@property (nonatomic, strong) UIImageView *imgBottomType3;  //纸质专票的-图片
@property (nonatomic, strong) UIView *viewBottom;   //底部按钮View；
@property (nonatomic, strong) UIButton *btnSaveInvoice; //保存发票按钮
@property (nonatomic, strong) UIButton *btnShareZhuan;  //模板下载按钮；

//公司发票- 电子普通发票txt；
@property (nonatomic, strong) UITextField *txtCompanyName;
@property (nonatomic, strong) UITextField *txtType1Email;
@property (nonatomic, strong) UITextField *txtType1Phone;
@property (nonatomic, strong) UITextField *txtTaxID;
@property (nonatomic, strong) UITextField *txtInvoiceAddress;
@property (nonatomic, strong) UITextField *txtInvoicePhone;
@property (nonatomic, strong) UITextField *txtBank;
@property (nonatomic, strong) UITextField *txtBankNum;
@property (nonatomic, strong) UILabel *lblBottom;

//公司发票- 纸质普通p发票txt；
@property (nonatomic, strong) UIButton *btnMailType;//邮寄类型；
@property (nonatomic, strong) UIButton *btnMailUserName;
@property (nonatomic, strong) UIButton *btnMailUserPhone;
@property (nonatomic, strong) UIButton *btnMailUserAddress;

//个人发票
@property (nonatomic, strong) UITextField *txtGrName;
@property (nonatomic, strong) UITextField *txtGrEmail;
@property (nonatomic, strong) UITextField *txtGrPhone;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong)  WY_AddressManageModel *selAddress;
@property (nonatomic, strong) NSString * zengzhishuiurl;
@end

@implementation WY_SelectInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self bindView];
}
- (void)makeUI {
    self.title = @"发票信息";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    ///加载全部控件
    [self initAllControll];
    [self initOtherViewFrame];
    
}
- (void)initAddBindView {
    self.txtCompanyName.text = self.mUser.DanWeiName;
    self.txtType1Phone.text = self.mUser.LoginID;
    self.txtType1Email.text = self.mUser.EMail;
    self.txtTaxID.text = self.mUser.orgnum;
    self.txtInvoiceAddress.text = self.mUser.address;
    self.txtBank.text = self.mUser.unitbankname;
    self.txtBankNum.text = self.mUser.unitbankcode;
    self.txtGrName.text = self.mUser.realname;
    self.txtGrPhone.text = self.mUser.LoginID;
    self.txtGrEmail.text = self.mUser.EMail;
    //默认选择公司发票
    [self btnTopAction:self.btnTopLeft];

}

- (void)initUpdateBindView {
    //如果修改发票信息- 还是需要初始化发票信息- 然后再覆盖内容
    [self initAddBindView];
    
    if ([self.mWY_SendEnrolmentMessageModel.InvoiceType isEqualToString:@"1"]) {
        //公司
        self.txtCompanyName.text = self.mWY_SendEnrolmentMessageModel.InvoiceName;
        //选择公司
        [self btnTopAction:self.btnTopLeft];

        if ([self.mWY_SendEnrolmentMessageModel.invoiceoftype isEqualToString:@"1"]) {
            //电子普通
            [self btnInvoiceTypeAction:self.btnInvoiceType1];

            self.txtType1Phone.text = self.mWY_SendEnrolmentMessageModel.lxdh;
            self.txtType1Email.text = self.mWY_SendEnrolmentMessageModel.InvoiceEmail;

        } else {
            //纸质普通、纸质专票
            
                    if ([self.mWY_SendEnrolmentMessageModel.invoiceoftype isEqualToString:@"2"]) {
                        [self btnInvoiceTypeAction:self.btnInvoiceType2];

                    }
            if ([self.mWY_SendEnrolmentMessageModel.invoiceoftype isEqualToString:@"3"]) {
                [self btnInvoiceTypeAction:self.btnInvoiceType3];
                               }
            if ([self.mWY_SendEnrolmentMessageModel.islingqu  isEqualToString:@"2"]) {
                //邮寄
                selMailTypeIndex = 0;
                self.selAddress = [WY_AddressManageModel new];
                self.selAddress.Address = self.mWY_SendEnrolmentMessageModel.fpAddress;
                self.selAddress.Mobile = self.mWY_SendEnrolmentMessageModel.fpdh;
                self.selAddress.UserName = self.mWY_SendEnrolmentMessageModel.fpry;
                [self.btnMailUserName setTitle:self.selAddress.UserName forState:UIControlStateNormal];
                [self.btnMailUserPhone setTitle:self.selAddress.Mobile forState:UIControlStateNormal];
                [self.btnMailUserAddress setTitle:self.selAddress.Address forState:UIControlStateNormal];
                [self.btnMailUserName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.btnMailUserPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.btnMailUserAddress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else {
                selMailTypeIndex = 1;
            }
            
            [self.btnMailType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (selMailTypeIndex == 0) {
                [self.btnMailType setTitle:@"邮寄" forState:UIControlStateNormal];

                [self.viewInvoiceAddressType2 setHidden:NO];
                self.viewInvoiceType2.height = self.viewInvoiceAddressType2.bottom;
            } else {
                [self.btnMailType setTitle:@"领取" forState:UIControlStateNormal];
                [self.viewInvoiceAddressType2 setHidden:YES];
                self.viewInvoiceType2.height = k360Width(44);
            }
            if (self.btnInvoiceType2.selected) {
                [self btnInvoiceTypeAction:self.btnInvoiceType2];
            } else {
                [self btnInvoiceTypeAction:self.btnInvoiceType3];
            }
        }
        
        //填充middle
        //税号
        self.txtTaxID.text = self.mWY_SendEnrolmentMessageModel.TaxpayerNo;
        //单位地址
        self.txtInvoiceAddress.text = self.mWY_SendEnrolmentMessageModel.InvoiceAddress;
        //单位电话
        self.txtInvoicePhone.text = self.mWY_SendEnrolmentMessageModel.InvoiceMobile;
        //开户行
        self.txtBank.text = self.mWY_SendEnrolmentMessageModel.InvoiceBankName;
        //银行账号
        self.txtBankNum.text = self.mWY_SendEnrolmentMessageModel.InvoiceBankNo;
    } else {
        //-然后再选择个人发票-填充数据
        [self btnTopAction:self.btnTopRight];
        self.txtGrName.text = self.mWY_SendEnrolmentMessageModel.InvoiceName;
        self.txtGrPhone.text = self.mWY_SendEnrolmentMessageModel.InvoiceMobile;
        self.txtGrEmail.text = self.mWY_SendEnrolmentMessageModel.InvoiceEmail;
        
    }

}

- (void)bindView {
    selMailTypeIndex = -1;
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    NSMutableAttributedString *attArr2 = [[NSMutableAttributedString alloc] initWithString:@"发票需知：\n1.付款后发票纳税人识别号不支持修改，确认后付款。\n2.电子发票可在订单完成后，在我的发票中下载查看。"];
       [attArr2 setYy_font:WY_FONTRegular(14)];
      [attArr2 setYy_color:HEXCOLOR(0x8A8A8A)];
     [attArr2 setYy_lineSpacing:6];
    self.lblBottom.attributedText = attArr2;
    [self.lblBottom setNumberOfLines:0];

    if  (self.invoiceID != nil) {
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        [dicPost setObject:self.invoiceID forKey:@"id"];

        [[MS_BasicDataController sharedInstance] postWithReturnCode:getInvoiceDetail_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
              if ([code integerValue] == 0 ) {
                  self.mWY_SendEnrolmentMessageModel = [WY_SendEnrolmentMessageModel yy_modelWithJSON:res[@"data"]];
                  //+ (NSDictionary *)modelCustomPropertyMapper {
                  //    NSDictionary *dic=@{@"InvoiceEmail" :@"Email",@"InvoiceMobile":@"GMFDH",@"InvoiceAddress":@"XSFDZ",@"InvoiceBankNo":@"XSFYHMC",@"InvoiceBankName":@"XSFYHZH"};
                  //    return dic;
                  //}
                  
                  self.mWY_SendEnrolmentMessageModel.InvoiceEmail = self.mWY_SendEnrolmentMessageModel.Email;
                  self.mWY_SendEnrolmentMessageModel.InvoiceAddress = self.mWY_SendEnrolmentMessageModel.XSFDZ;
                  self.mWY_SendEnrolmentMessageModel.InvoiceBankNo = self.mWY_SendEnrolmentMessageModel.XSFYHMC;
                  self.mWY_SendEnrolmentMessageModel.InvoiceBankName = self.mWY_SendEnrolmentMessageModel.XSFYHZH;
                  
                  
                   [self initUpdateBindView];
                  if (self.mWY_SendEnrolmentMessageModel.PdfUrl.length > 0) {
                      //右上角显示查看发票；
                      UIButton *cancleButton = [[UIButton alloc] init];
                      cancleButton.frame = CGRectMake(0, 0, 44, 44);
                      [cancleButton setTitle:@"查看发票" forState:UIControlStateNormal];
                      [cancleButton.titleLabel setFont:WY_FONTRegular(12)];
                      [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
                      UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
                      self.navigationItem.rightBarButtonItem = rightItem;

                  }
                  if (self.mWY_SendEnrolmentMessageModel.zengzhishuiurl.length > 0) {
                      self.zengzhishuiurl = self.mWY_SendEnrolmentMessageModel.zengzhishuiurl;
                      [self.imgBottomType3 sd_setImageWithURL:[NSURL URLWithString:self.mWY_SendEnrolmentMessageModel.zengzhishuiurl] placeholderImage:[UIImage imageNamed:@"0116nobg"]];
                      [self btnInvoiceTypeAction:self.btnInvoiceType3];
                      [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
                      [self.btnShareZhuan setHidden:YES];
                  }
               } else {
                  [SVProgressHUD showErrorWithStatus:res[@"msg"]];
              }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];


    } else {
                if (self.mWY_SendEnrolmentMessageModel == nil) {
                    [self initAddBindView];
                } else {
                    [self initUpdateBindView];
                }

    }
    
    if (self.isCanSave) {
        //可以编辑保存
        [self.btnSaveInvoice setHidden:NO];
    }else {
        //只能查看
        [self.btnSaveInvoice setHidden:YES];
        [self.btnSaveInvoice setUserInteractionEnabled:NO];
        [self.btnTopLeft setUserInteractionEnabled:NO];
        [self.btnTopRight setUserInteractionEnabled:NO];
        [self.btnMailType setUserInteractionEnabled:NO];
        [self.btnInvoiceType1 setUserInteractionEnabled:NO];
        [self.btnInvoiceType2 setUserInteractionEnabled:NO];
        [self.btnInvoiceType3 setUserInteractionEnabled:NO];
        [self.btnMailUserName setUserInteractionEnabled:NO];
        [self.btnMailUserPhone setUserInteractionEnabled:NO];
        [self.btnMailUserAddress setUserInteractionEnabled:NO];
        [self.txtBank setUserInteractionEnabled:NO];
        [self.txtTaxID setUserInteractionEnabled:NO];
        [self.txtGrName setUserInteractionEnabled:NO];
        [self.txtBankNum setUserInteractionEnabled:NO];
        [self.txtGrEmail setUserInteractionEnabled:NO];
        [self.txtGrPhone setUserInteractionEnabled:NO];
        [self.txtType1Email setUserInteractionEnabled:NO];
        [self.txtType1Phone setUserInteractionEnabled:NO];
        [self.txtCompanyName setUserInteractionEnabled:NO];
        [self.txtInvoicePhone setUserInteractionEnabled:NO];
        [self.txtInvoiceAddress setUserInteractionEnabled:NO];
    }
    
}
- (void)navRightAction{
    NSLog(@"查看发票");
    
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.mWY_SendEnrolmentMessageModel.PdfUrl] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:self.mWY_SendEnrolmentMessageModel.PdfUrl]];
    }
    
 
}

- (void)initAllControll {
    self.mScrollView = [UIScrollView new];
    self.btnTopLeft = [[UIButton alloc] init];
    self.btnTopRight = [[UIButton alloc] init];
    self.btnShareZhuan = [[UIButton alloc] init];
    self.btnSaveInvoice = [[UIButton alloc] init];
    self.btnInvoiceType1 = [[UIButton alloc] init];
    self.btnInvoiceType2 = [[UIButton alloc] init];
    self.btnInvoiceType3 = [[UIButton alloc] init];
    self.viewBottom = [[UIView alloc] init];
    self.viewMiddle = [[UIView alloc] init];
    self.viewLeftInfo = [[UIView alloc] init];
    self.viewRightInfo = [[UIView alloc] init];
    self.viewBottomType3 = [[UIControl alloc] init];
    self.imgBottomType3 = [UIImageView new];
    self.viewInvoiceTop = [[UIView alloc] init];
    self.viewInvoiceType1 = [[UIView alloc] init];
    self.viewInvoiceType2 = [[UIView alloc] init];
    self.viewInvoiceAddressType2 = [[UIView alloc] init];
    self.lblBottom = [[UILabel alloc] init];
    
    self.txtCompanyName = [UITextField new];
    self.txtType1Email = [UITextField new];
    self.txtType1Phone = [UITextField new];
    self.txtTaxID = [UITextField new];
    self.txtInvoiceAddress = [UITextField new];
    self.txtInvoicePhone = [UITextField new];
    self.txtBank = [UITextField new];
    self.txtBankNum = [UITextField new];
    self.txtGrName = [UITextField new];
    self.txtGrEmail = [UITextField new];
    self.txtGrPhone = [UITextField new];
    
    self.txtCompanyName.keyboardType = UIKeyboardTypeDefault;
    self.txtType1Email.keyboardType = UIKeyboardTypeEmailAddress;
    self.txtType1Phone.keyboardType = UIKeyboardTypePhonePad;
    self.txtTaxID.keyboardType = UIKeyboardTypeASCIICapable;
    self.txtInvoiceAddress.keyboardType = UIKeyboardTypeDefault;
    self.txtInvoicePhone.keyboardType = UIKeyboardTypePhonePad;
    self.txtBank.keyboardType = UIKeyboardTypeDefault;
    self.txtBankNum.keyboardType = UIKeyboardTypePhonePad;
    self.txtGrName.keyboardType = UIKeyboardTypeDefault;
    self.txtGrEmail.keyboardType = UIKeyboardTypeEmailAddress;
    self.txtGrPhone.keyboardType = UIKeyboardTypePhonePad;
 
     
    self.btnMailType = [UIButton new];
    self.btnMailUserName = [UIButton new];
    self.btnMailUserPhone = [UIButton new];
    self.btnMailUserAddress = [UIButton new];
    
    
    [self.view addSubview:self.btnTopLeft];
    [self.view addSubview:self.btnTopRight];
    [self.view addSubview:self.btnInvoiceType1];
    [self.view addSubview:self.btnInvoiceType2];
    [self.view addSubview:self.btnInvoiceType3];
    [self.view addSubview:self.mScrollView];
    [self.view addSubview:self.viewBottom];
    [self.mScrollView addSubview:self.viewLeftInfo];
    [self.mScrollView addSubview:self.viewRightInfo];
    
    [self.viewLeftInfo addSubview:self.viewInvoiceTop];
    [self.viewLeftInfo addSubview:self.viewInvoiceType1];
    [self.viewLeftInfo addSubview:self.viewInvoiceType2];
    [self.viewInvoiceType2 addSubview:self.viewInvoiceAddressType2];
    
    [self.viewLeftInfo addSubview:self.viewMiddle];
    
     [self.viewLeftInfo addSubview:self.viewBottomType3];
    [self.viewLeftInfo addSubview:self.imgBottomType3];
    
    [self.mScrollView addSubview:self.lblBottom];
    
    [self.viewBottom addSubview:self.btnShareZhuan];
   [self.viewBottom addSubview:self.btnSaveInvoice];

}
- (void)initOtherViewFrame {
    [self.btnTopLeft setFrame:CGRectMake(0, 0, kScreenWidth / 2 - 1, k360Width(44))];
    [self.btnTopLeft setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(self.btnTopLeft.right, 0, 1, self.btnTopLeft.height)];
    [imgLine setBackgroundColor:MSColor(242, 242, 242)];
    [self.view addSubview:imgLine];
    [self.btnTopRight setFrame:CGRectMake(imgLine.right, 0, kScreenWidth / 2, k360Width(44))];
    [self.btnTopRight setBackgroundColor:[UIColor whiteColor]];
    
    [self.btnTopLeft setTitle:@"公司发票" forState:UIControlStateNormal];
    [self.btnTopRight setTitle:@"个人发票" forState:UIControlStateNormal];
    [self.btnTopLeft.titleLabel setFont:WY_FONTMedium(16)];
    [self.btnTopRight.titleLabel setFont:WY_FONTMedium(16)];
    [self.btnTopLeft setTitleColor:HEXCOLOR(0x909090) forState:UIControlStateNormal];
    [self.btnTopRight setTitleColor:HEXCOLOR(0x909090) forState:UIControlStateNormal];
    [self.btnTopLeft setTitleColor:HEXCOLOR(0x5985C7) forState:UIControlStateSelected];
    [self.btnTopRight setTitleColor:HEXCOLOR(0x5985C7) forState:UIControlStateSelected];
    
    [self.btnTopLeft addTarget:self action:@selector(btnTopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTopRight addTarget:self action:@selector(btnTopAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.btnInvoiceType1 setFrame:CGRectMake(k360Width(16), self.btnTopLeft.bottom + k360Width(16), k360Width(74), k360Width(26))];
    [self.btnInvoiceType2 setFrame:CGRectMake(self.btnInvoiceType1.right + k360Width(16), self.btnTopLeft.bottom + k360Width(16), k360Width(74), k360Width(26))];
    [self.btnInvoiceType3 setFrame:CGRectMake(self.btnInvoiceType2.right + k360Width(16), self.btnTopLeft.bottom + k360Width(16), k360Width(74), k360Width(26))];
    
    [self.btnInvoiceType1 setTitle:@"电子普票" forState:UIControlStateNormal];
    [self.btnInvoiceType2 setTitle:@"纸质普票" forState:UIControlStateNormal];
    [self.btnInvoiceType3 setTitle:@"纸质专票" forState:UIControlStateNormal];
    [self.btnInvoiceType1 addTarget:self action:@selector(btnInvoiceTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnInvoiceType2 addTarget:self action:@selector(btnInvoiceTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnInvoiceType3 addTarget:self action:@selector(btnInvoiceTypeAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.btnInvoiceType1.titleLabel setFont:WY_FONTRegular(14)];
    [self.btnInvoiceType2.titleLabel setFont:WY_FONTRegular(14)];
    [self.btnInvoiceType3.titleLabel setFont:WY_FONTRegular(14)];

    
    [self.btnInvoiceType1 setTitleColor:HEXCOLOR(0x5985C7) forState:UIControlStateNormal];
    [self.btnInvoiceType2 setTitleColor:HEXCOLOR(0x5985C7) forState:UIControlStateNormal];
    [self.btnInvoiceType3 setTitleColor:HEXCOLOR(0x5985C7) forState:UIControlStateNormal];
    [self.btnInvoiceType1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btnInvoiceType2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btnInvoiceType3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
    [self.btnInvoiceType1 rounded:k360Width(44)/4];
    [self.btnInvoiceType2 rounded:k360Width(44)/4];
    [self.btnInvoiceType3 rounded:k360Width(44)/4];
        
    [self.btnTopLeft setSelected:YES];
    [self.btnInvoiceType1 setSelected:YES];
    
    [self.mScrollView setFrame:CGRectMake(0, k360Width(100), kScreenWidth, kScreenHeight - JCNew64 - k360Width(50 + 100)  - JC_TabbarSafeBottomMargin)];
       [self.mScrollView setBackgroundColor:[UIColor clearColor]];
       
    [self.viewBottom setFrame:CGRectMake(0, self.mScrollView.bottom, kScreenWidth, k360Width(50))];
    [self.viewBottom setBackgroundColor:[UIColor whiteColor]];
    [self.btnSaveInvoice setFrame:CGRectMake(k360Width(16), k360Width(3), kScreenWidth - k360Width(32), k360Width(44))];
    [self.btnSaveInvoice setTitle:@"保存发票" forState:UIControlStateNormal];
    [self.btnSaveInvoice setBackgroundColor:MSTHEMEColor];
    [self.btnSaveInvoice rounded:k360Width(44/8)];
    [self.btnSaveInvoice addTarget:self action:@selector(btnSaveInvoiceAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnShareZhuan setFrame:CGRectMake(k360Width(16), k360Width(3), (kScreenWidth - k360Width(16 * 3)) / 2, k360Width(44))];
    [self.btnShareZhuan setTitle:@"增值税专用发票模板下载" forState:UIControlStateNormal];
    [self.btnShareZhuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnShareZhuan setBackgroundColor:HEXCOLOR(0xA6A6A6)];
    [self.btnShareZhuan rounded:k360Width(44/8)];
    [self.btnShareZhuan.titleLabel setFont:WY_FONTRegular(12)];
    [self.btnShareZhuan setHidden:YES];
    
    [self.btnShareZhuan addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSURL *fapiaoUrl = [NSURL URLWithString:@"http://117.78.21.211:8041/tyrz/cash/123456/invoiceFormwork.docx"];
         if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:fapiaoUrl options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:fapiaoUrl];
        }
    }];
    
    
    lastY = 0;
    [self.viewLeftInfo setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(0))];
    
    [self.viewRightInfo setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(44 * 3))];

    [self.viewInvoiceTop setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(44))];
    
    [self.viewInvoiceType1 setFrame:CGRectMake(0, self.viewInvoiceTop.bottom, kScreenWidth, k360Width(88))];
    
    [self.viewInvoiceType2 setFrame:CGRectMake(0, self.viewInvoiceTop.bottom, kScreenWidth, k360Width(44))];
 
    [self.viewMiddle setFrame:CGRectMake(0, self.viewInvoiceType1.bottom, kScreenWidth, k360Width(44 * 5))];
    
    [self.viewBottomType3 setFrame:CGRectMake(0, self.viewMiddle.bottom, kScreenWidth, k360Width(44))];
    [self.imgBottomType3 setFrame:CGRectMake(k360Width(16), self.viewBottomType3.bottom, kScreenWidth - k360Width(32), k360Width(0))];
    
    [self.viewBottomType3 setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblInvoiceTempUrl = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), k360Width(44))];
    lblInvoiceTempUrl.text = @"增值税专用发票地址分享";
    [lblInvoiceTempUrl setFont:WY_FONTMedium(16)];
    [lblInvoiceTempUrl setTextColor:HEXCOLOR(0x5985C7)];
    [self.viewBottomType3 addSubview:lblInvoiceTempUrl];
    UIImageView *imgZhuan = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(34 + 16), k360Width(10), k360Width(22), k360Width(22))];
    [imgZhuan setImage:[UIImage imageNamed:@"fenxiang"]];
    [self.viewBottomType3 addSubview:imgZhuan];
    [self.viewBottomType3 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了转发按钮");
        NSURL *fapiaoUrl = [NSURL URLWithString:@"http://117.78.21.211:8041/tyrz/cash/123456/invoiceFormwork.docx"];
        NSArray*activityItems =@[fapiaoUrl ,@"增值税专用发票模板",[UIImage imageNamed:@"AppIcon"]];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
        //弹出分享的页面
        [self presentViewController:activityVC animated:YES completion:nil];
    }];
    [self.lblBottom setFrame:CGRectMake(k360Width(16), self.viewMiddle.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(200))];
    
    
    
    lastY = 0;
    [self.txtCompanyName setPlaceholder:@"请输入公司名称"];
    [self addItem:@"公司名称：" withRightText:self.txtCompanyName withIsXing:NO withAddView:self.viewInvoiceTop];
    
    lastY = 0;
    [self.txtType1Email setPlaceholder:@"请输入邮箱地址"];
    [self addItem:@"电子邮箱：" withRightText:self.txtType1Email withIsXing:NO withAddView:self.viewInvoiceType1];
    [self.txtType1Phone setPlaceholder:@"请输入联系电话"];
    [self addItem:@"联系电话：" withRightText:self.txtType1Phone withIsXing:NO withAddView:self.viewInvoiceType1];
    lastY = 0;
    [self.txtTaxID setPlaceholder:@"请输入税号"];
    [self addItem:@"税      号：" withRightText:self.txtTaxID withIsXing:NO withAddView:self.viewMiddle];
    
    [self.txtInvoiceAddress setPlaceholder:@"请输入单位地址"];
    [self addItem:@"单位地址：" withRightText:self.txtInvoiceAddress withIsXing:NO withAddView:self.viewMiddle];
    
    [self.txtInvoicePhone setPlaceholder:@"请输入单位电话"];
    [self addItem:@"单位电话：" withRightText:self.txtInvoicePhone withIsXing:NO withAddView:self.viewMiddle];
    
    [self.txtBank setPlaceholder:@"请输入开户行"];
    [self addItem:@"开 户 行：" withRightText:self.txtBank withIsXing:NO withAddView:self.viewMiddle];

    [self.txtBankNum setPlaceholder:@"请输入银行账号"];
    [self addItem:@"银行账号：" withRightText:self.txtBankNum withIsXing:NO withAddView:self.viewMiddle];
    
    
    [self.btnMailType setTitle:@"请选择邮寄方式" forState:UIControlStateNormal];
    [self.btnMailType setTitleColor:HEXCOLOR(0xCCCCCC) forState:UIControlStateNormal];
    
    [self.btnMailUserName addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnMailUserPhone addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];

    [self.btnMailUserAddress addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];

    [self.btnMailType addTarget:self action:@selector(showActionSheetMailType) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMailUserName setTitle:@"请选择邮寄人" forState:UIControlStateNormal];
    [self.btnMailUserPhone setTitle:@"请选择邮寄电话" forState:UIControlStateNormal];
    [self.btnMailUserAddress setTitle:@"请选择邮寄地址" forState:UIControlStateNormal];
    [self.btnMailUserName setTitleColor:HEXCOLOR(0xCCCCCC) forState:UIControlStateNormal];
    [self.btnMailUserPhone setTitleColor:HEXCOLOR(0xCCCCCC) forState:UIControlStateNormal];
    [self.btnMailUserAddress setTitleColor:HEXCOLOR(0xCCCCCC) forState:UIControlStateNormal];

    
    
    
    lastY = 0;
    [self addItem:@"邮寄方式：" withRightBtnText:self.btnMailType withIsXing:NO withAddView:self.viewInvoiceType2];
    [self.viewInvoiceAddressType2 setFrame:CGRectMake(0, k360Width(44), kScreenWidth, k360Width(44 * 3))];
    lastY = 0;
    [self addItem:@"邮 寄 人：" withRightBtnText:self.btnMailUserName withIsXing:NO withAddView:self.viewInvoiceAddressType2];

    [self addItem:@"邮寄电话：" withRightBtnText:self.btnMailUserPhone withIsXing:NO withAddView:self.viewInvoiceAddressType2];

    [self addItem:@"邮寄地址：" withRightBtnText:self.btnMailUserAddress withIsXing:NO withAddView:self.viewInvoiceAddressType2];

    [self.viewInvoiceType2 setHidden:YES];
    [self.viewInvoiceAddressType2 setHidden:YES];
    
    lastY = 0;
    [self.txtGrName setPlaceholder:@"请输入个人姓名"];
    [self addItem:@"个人姓名：" withRightText:self.txtGrName withIsXing:NO withAddView:self.viewRightInfo];
    [self.txtGrEmail setPlaceholder:@"请输入电子邮箱"];
    [self addItem:@"电子邮箱：" withRightText:self.txtGrEmail withIsXing:NO withAddView:self.viewRightInfo];
    [self.txtGrPhone setPlaceholder:@"请输入联系电话"];
    [self addItem:@"联系电话：" withRightText:self.txtGrPhone withIsXing:NO withAddView:self.viewRightInfo];
    
}



- (void) addItem:(NSString *)leftStr withRightText:(UITextField *)txtRight withIsXing:(BOOL)isXing withAddView:(UIView *)addView{
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(70), k360Width(44))];
    [lblLeft setFont:WY_FONTRegular(14)];
    [lblLeft setText:leftStr];
    [lblLeft setTextColor:HEXCOLOR(0x7E7E7E)];
    [viewTemp addSubview:lblLeft];
    if (isXing) {
        UILabel *lblXing = [[UILabel alloc] initWithFrame:CGRectMake(lblLeft.right, k360Width(16), k360Width(10), k360Width(10))];
        lblXing.text = @"*";
        [lblXing setTextColor:[UIColor redColor]];
        [lblXing setFont:WY_FONTRegular(14)];
        [viewTemp addSubview:lblXing];
        
    }
    
    [txtRight setFrame:CGRectMake(lblLeft.right + k360Width(40), 0, kScreenWidth - lblLeft.right - k360Width(56), k360Width(44))];
    [txtRight setFont:WY_FONTRegular(14)];
    [viewTemp addSubview:txtRight];
    
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(44) - 1,kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [viewTemp addSubview:imgLine];
    
    [addView addSubview:viewTemp];
    
    lastY = viewTemp.bottom;
}

- (void) addItem:(NSString *)leftStr withRightBtnText:(UIButton *)txtRight withIsXing:(BOOL)isXing  withAddView:(UIView *)addView{
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(70), k360Width(44))];
    [lblLeft setFont:WY_FONTRegular(14)];
    [lblLeft setText:leftStr];
    [lblLeft setTextColor:HEXCOLOR(0x7E7E7E)];
    [viewTemp addSubview:lblLeft];
    if (isXing) {
        UILabel *lblXing = [[UILabel alloc] initWithFrame:CGRectMake(lblLeft.right, k360Width(16), k360Width(10), k360Width(10))];
        lblXing.text = @"*";
        [lblXing setTextColor:[UIColor redColor]];
        [lblXing setFont:WY_FONTRegular(14)];
        [viewTemp addSubview:lblXing];
        
    }
    
    [txtRight setFrame:CGRectMake(lblLeft.right + k360Width(40), 0, kScreenWidth - lblLeft.right - k360Width(56), k360Width(44))];
    [txtRight.titleLabel setFont:WY_FONTRegular(14)];
    [txtRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [viewTemp addSubview:txtRight];
    
//    if ([txtRight isEqual:self.btnSelSex]) {
//        UIImageView *imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(33), k360Width(34/2), k360Width(7), k360Width(10))];
//        [imgAcc setImage:[UIImage imageNamed:@"0210_qianjin"]];
//        //        imgAcc.centerY = viewTemp.centerY;
//        [viewTemp addSubview:imgAcc];
//    }
//
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(43) ,kScreenWidth, k360Width(1))];
    [imgLine setBackgroundColor:APPLineColor];
    [viewTemp addSubview:imgLine];
    
    [addView addSubview:viewTemp];
    lastY = viewTemp.bottom;
}

#pragma mark 点击切换公司发票、个人发票按钮
- (void)btnTopAction:(UIButton *)btnSender {
    NSLog(@"点击切换公司发票、个人发票按钮");
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self.viewLeftInfo setHidden:YES];
    [self.viewRightInfo setHidden:YES];
    float fSpace = k360Width(16);
    
    [self.btnInvoiceType1 setHidden:YES];
    [self.btnInvoiceType2 setHidden:YES];
    [self.btnInvoiceType3 setHidden:YES];
    [self btnInvoiceTypeAction:self.btnInvoiceType1];

    [self.btnTopLeft setSelected:NO];
    [self.btnTopRight setSelected:NO];
    
    if ([btnSender isEqual:self.btnTopLeft]) {
        [self.btnTopLeft setSelected:YES];
        [self.btnInvoiceType1 setUserInteractionEnabled:YES];
        [self.btnInvoiceType1 setHidden:NO];
        [self.btnInvoiceType2 setHidden:NO];
        [self.btnInvoiceType3 setHidden:NO];
        [self.viewLeftInfo setHidden:NO];
        self.lblBottom.top = self.viewLeftInfo.bottom + fSpace;
        [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, self.lblBottom.bottom)];
    } else {
        [self.btnTopRight setSelected:YES];
        [self.btnInvoiceType1 setUserInteractionEnabled:NO];
        [self.btnInvoiceType1 setSelected:YES];
        [self.btnInvoiceType1 setHidden:NO];
        
        [self.viewRightInfo setHidden:NO];
        self.lblBottom.top = self.viewRightInfo.bottom + fSpace;
        [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, self.lblBottom.bottom)];
    }
}

- (void)selectAddress {
    NSLog(@"选择地址页， ");
    WY_AddressManageViewController *tempController = [WY_AddressManageViewController new];
    tempController.title = @"地址管理";
    tempController.isSel = YES;
    tempController.selAddressBlock = ^(WY_AddressManageModel * _Nonnull selModel) {
        self.selAddress = selModel;
        [self.btnMailUserName setTitle:self.selAddress.UserName forState:UIControlStateNormal];
        [self.btnMailUserPhone setTitle:self.selAddress.Mobile forState:UIControlStateNormal];
        [self.btnMailUserAddress setTitle:self.selAddress.Address forState:UIControlStateNormal];
        [self.btnMailUserName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnMailUserPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnMailUserAddress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:tempController animated:YES];
}

#pragma mark 点击切换发票类型按钮
- (void)btnInvoiceTypeAction:(UIButton *)btnSender {
    NSLog(@"点击切换发票类型按钮");
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self.btnInvoiceType1 setSelected:NO];
    [self.btnInvoiceType2 setSelected:NO];
    [self.btnInvoiceType3 setSelected:NO];
    [self.btnInvoiceType1 setBackgroundColor:HEXCOLOR(0xE9F4FD)];
    [self.btnInvoiceType2 setBackgroundColor:HEXCOLOR(0xE9F4FD)];
    [self.btnInvoiceType3 setBackgroundColor:HEXCOLOR(0xE9F4FD)];
    
    
    [self.viewInvoiceType1 setHidden:YES];
    [self.viewInvoiceType2 setHidden:YES];
    [self.viewBottomType3 setHidden:YES];
    [self.imgBottomType3 setHidden:YES];
    [self.btnShareZhuan setHidden:YES];
    
    float fSpace = k360Width(16);
    
    if ([btnSender isEqual:self.btnInvoiceType1]) {
        [self.btnInvoiceType1 setSelected:YES];
        [self.viewInvoiceType1 setHidden:NO];
        self.viewInvoiceType1.top = self.viewInvoiceTop.bottom;
        self.viewMiddle.top = self.viewInvoiceType1.bottom;
        self.viewLeftInfo.height = self.viewMiddle.bottom;
        [self.btnInvoiceType1 setBackgroundColor:HEXCOLOR(0x5985C7)];
        
        self.btnSaveInvoice.width = kScreenWidth - k360Width(32);
        self.btnSaveInvoice.left = k360Width(16);
        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
    } else if ([btnSender isEqual:self.btnInvoiceType2]) {
        [self.btnInvoiceType2 setSelected:YES];
        [self.viewInvoiceType2 setHidden:NO];
        [self.btnInvoiceType2 setBackgroundColor:HEXCOLOR(0x5985C7)];

        self.viewInvoiceType2.top = self.viewInvoiceTop.bottom;
        self.viewMiddle.top = self.viewInvoiceType2.bottom;
        self.viewLeftInfo.height = self.viewMiddle.bottom;
        
        self.btnSaveInvoice.width = kScreenWidth - k360Width(32);
        self.btnSaveInvoice.left = k360Width(16);
        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];

    }  else if ([btnSender isEqual:self.btnInvoiceType3]) {
        [self.viewBottomType3 setHidden:NO];
        [self.imgBottomType3 setHidden:NO];
           [self.btnInvoiceType3 setSelected:YES];
        [self.viewInvoiceType2 setHidden:NO];
        [self.btnInvoiceType3 setBackgroundColor:HEXCOLOR(0x5985C7)];

        [self.btnShareZhuan setHidden:NO];
        self.btnSaveInvoice.width = self.btnShareZhuan.width;
        self.btnSaveInvoice.left = self.btnShareZhuan.right + k360Width(16);
        
        //上传拍照
        //右上角显示上传拍照；
            
        UIButton *cancleButton = [[UIButton alloc] init];
        cancleButton.frame = CGRectMake(0, 0, 44, 44);
        [cancleButton setTitle:@"上传拍照" forState:UIControlStateNormal];
        [cancleButton.titleLabel setFont:WY_FONTRegular(12)];
        [cancleButton addTarget:self action:@selector(navRightAddPhotoAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.navigationItem.rightBarButtonItem.customView setHidden:NO];

        if (self.zengzhishuiurl.length > 0) {
            [self.imgBottomType3 setHeight:kScreenWidth - k360Width(32)];
            self.viewInvoiceType2.top = self.viewInvoiceTop.bottom;
            self.viewMiddle.top = self.viewInvoiceType2.bottom;
            self.viewBottomType3.top = self.viewMiddle.bottom + fSpace;
            self.imgBottomType3.top = self.viewBottomType3.bottom + fSpace;
            self.viewLeftInfo.height = self.imgBottomType3.bottom;
        } else {
            [self.imgBottomType3 setHeight:0];
            self.viewInvoiceType2.top = self.viewInvoiceTop.bottom;
            self.viewMiddle.top = self.viewInvoiceType2.bottom;
            self.viewBottomType3.top = self.viewMiddle.bottom + fSpace;
            self.viewLeftInfo.height = self.viewBottomType3.bottom;
         }
    }
    
    self.lblBottom.top = self.viewLeftInfo.bottom + fSpace;
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, self.lblBottom.bottom)];
    
}
 

- (void)showActionSheetMailType {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [ActionSheetStringPicker showPickerWithTitle:@"请选择邮寄方式" rows:@[@"邮寄",@"领取"] initialSelection:selMailTypeIndex==-1?0:selMailTypeIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //由于疫情防控，暂停现场业务办理 - 不可以选择领取
        if (selectedIndex == 1) {
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
        }
        selMailTypeIndex = selectedIndex;
        [self.btnMailType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnMailType setTitle:selectedValue forState:UIControlStateNormal];
        if (selectedIndex == 0) {
            [self.viewInvoiceAddressType2 setHidden:NO];
            self.viewInvoiceType2.height = self.viewInvoiceAddressType2.bottom;
        } else {
            [self.viewInvoiceAddressType2 setHidden:YES];
            self.viewInvoiceType2.height = k360Width(44);
        }
        if (self.btnInvoiceType2.selected) {
            [self btnInvoiceTypeAction:self.btnInvoiceType2];
        } else {
            [self btnInvoiceTypeAction:self.btnInvoiceType3];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

#pragma mark --保存发票按钮 -
- (void)btnSaveInvoiceAction {
    self.mWY_SendEnrolmentMessageModel = [WY_SendEnrolmentMessageModel new];
    
    if (self.btnTopLeft.selected && [self verificationLeft]) {
        //公司
        self.mWY_SendEnrolmentMessageModel.InvoiceType = @"1";
        self.mWY_SendEnrolmentMessageModel.InvoiceName =  self.txtCompanyName.text;

        if (self.btnInvoiceType1.selected) {
            //电子普通
            self.mWY_SendEnrolmentMessageModel.invoiceoftype = @"1";
            self.mWY_SendEnrolmentMessageModel.lxdh = self.txtType1Phone.text;
            self.mWY_SendEnrolmentMessageModel.InvoiceEmail = self.txtType1Email.text;
        } else {
            if (self.btnInvoiceType2.selected) {
                //纸质普通
                self.mWY_SendEnrolmentMessageModel.invoiceoftype = @"2";
            } else if (self.btnInvoiceType3.selected) {
                //纸质专票
                self.mWY_SendEnrolmentMessageModel.invoiceoftype = @"3";
//                self.mWY_SendEnrolmentMessageModel.zengzhishuiurl = @"http://117.78.21.211:8041/tyrz/cash/123456/invoiceFormwork.docx";
                if (self.zengzhishuiurl.length > 0) {
                    self.mWY_SendEnrolmentMessageModel.zengzhishuiurl = self.zengzhishuiurl;
                }
            }
            if (selMailTypeIndex == 0) {
                //邮寄
                self.mWY_SendEnrolmentMessageModel.islingqu = @"2";
                self.mWY_SendEnrolmentMessageModel.fpAddress = self.selAddress.Address;
                self.mWY_SendEnrolmentMessageModel.fpdh = self.selAddress.Mobile;
                self.mWY_SendEnrolmentMessageModel.fpry = self.selAddress.UserName;
            } else {
                self.mWY_SendEnrolmentMessageModel.islingqu = @"1";
            }
            
        }
        //填充middle
        //税号
        self.mWY_SendEnrolmentMessageModel.TaxpayerNo = self.txtTaxID.text;
        //单位地址
        self.mWY_SendEnrolmentMessageModel.InvoiceAddress = self.txtInvoiceAddress.text;
        //单位电话
        self.mWY_SendEnrolmentMessageModel.InvoiceMobile = self.txtInvoicePhone.text;
        //开户行
        self.mWY_SendEnrolmentMessageModel.InvoiceBankName = self.txtBank.text;
        //银行账号
        self.mWY_SendEnrolmentMessageModel.InvoiceBankNo = self.txtBankNum.text;
        //发送
         [self sendSaveInvoice];
        return;
       }
       
       if (self.btnTopRight.selected && [self verificationRight]) {
           //个人
           self.mWY_SendEnrolmentMessageModel.InvoiceType = @"2";
           self.mWY_SendEnrolmentMessageModel.invoiceoftype = @"1";
           self.mWY_SendEnrolmentMessageModel.InvoiceName = self.txtGrName.text;
           self.mWY_SendEnrolmentMessageModel.InvoiceMobile = self.txtGrPhone.text;
           self.mWY_SendEnrolmentMessageModel.InvoiceEmail = self.txtGrEmail.text;
           [self sendSaveInvoice];
           //发送
           return;
        }
}

- (void)sendSaveInvoice {
    //咨询类别 -1线上咨询 。2线下支付
    if ([self.adviceType isEqualToString:@"2"]) {
        if (self.saveInvoiceBlock) {
            self.saveInvoiceBlock(self.mWY_SendEnrolmentMessageModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        //1线上咨询 - 线上付款提示
        UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于苹果公司收取31.3%手续费，本次开具的发票金额为付款金额的68.7%，请您知悉！" preferredStyle:UIAlertControllerStyleAlert];
         [tempAlert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.saveInvoiceBlock) {
                   self.saveInvoiceBlock(self.mWY_SendEnrolmentMessageModel);
                   [self.navigationController popViewControllerAnimated:YES];
               }
            
        }]];
        [self presentViewController:tempAlert animated:YES completion:nil];

    }

    
   
}

- (BOOL)verificationLeft {
    if (self.txtCompanyName.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtCompanyName.placeholder];
        [self.txtCompanyName becomeFirstResponder];
        return NO;
    }
    if (self.btnInvoiceType1.selected && ![self verificationType1]) {
        return NO;
    }
       if (self.btnInvoiceType2.selected && ![self verificationType2]) {
               return NO;
       }
    if (self.btnInvoiceType3.selected && ![self verificationType3]) {
            return NO;
    }
    
    if (![self verificationMiddle]) {
        return NO;
    }
    
    return YES;
}
- (BOOL)verificationRight {
    if (self.txtGrName.text.length <= 0) {
           [SVProgressHUD showErrorWithStatus:self.txtGrName.placeholder];
           [self.txtGrName becomeFirstResponder];
           return NO;
       }
    if (self.txtGrEmail.text.length <= 0) {
              [SVProgressHUD showErrorWithStatus:self.txtGrEmail.placeholder];
              [self.txtGrEmail becomeFirstResponder];
              return NO;
          }
    if (self.txtGrPhone.text.length <= 0) {
              [SVProgressHUD showErrorWithStatus:self.txtGrPhone.placeholder];
              [self.txtGrPhone becomeFirstResponder];
              return NO;
          }
    return YES;
}

- (BOOL)verificationType1 {
    if (self.txtType1Email.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtType1Email.placeholder];
        [self.txtType1Email becomeFirstResponder];
        return NO;
    }
    if (self.txtType1Phone.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtType1Phone.placeholder];
        [self.txtType1Phone becomeFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)verificationType2 {
    if (selMailTypeIndex == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择邮寄方式"];
        return NO;
    }
    if (selMailTypeIndex == 0) {
        if (self.selAddress == nil) {
            [SVProgressHUD showErrorWithStatus:@"请选择邮寄人"];
            return NO;

        }
    }
    return YES;
}
- (BOOL)verificationType3 {
    if (selMailTypeIndex == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择邮寄方式"];
        return NO;
    }
    if (selMailTypeIndex == 0) {
        if (self.selAddress == nil) {
            [SVProgressHUD showErrorWithStatus:@"请选择邮寄人"];
            return NO;

        }
    }
    return YES;
}

- (BOOL)verificationMiddle {
    if (self.txtTaxID.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtTaxID.placeholder];
        [self.txtTaxID becomeFirstResponder];
        return NO;
    }
    if (self.txtCompanyName.text.length <= 0) {
           [SVProgressHUD showErrorWithStatus:self.txtCompanyName.placeholder];
           [self.txtCompanyName becomeFirstResponder];
           return NO;
       }
    
    if (self.btnInvoiceType3.selected) {

        if (self.txtInvoicePhone.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:self.txtInvoicePhone.placeholder];
            [self.txtInvoicePhone becomeFirstResponder];
            return NO;
        }
        
        if (self.txtInvoiceAddress.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:self.txtInvoiceAddress.placeholder];
            [self.txtInvoiceAddress becomeFirstResponder];
            return NO;
        }
        if (self.txtBank.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:self.txtBank.placeholder];
            [self.txtBank becomeFirstResponder];
            return NO;
        }
        if (self.txtBankNum.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:self.txtBankNum.placeholder];
            [self.txtBankNum becomeFirstResponder];
            return NO;
        }
    }
    
    return YES;
}
- (void)navRightAddPhotoAction {
    //上传照片
    NSLog(@"上传照片");
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
        //读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [SVProgressHUD showInfoWithStatus:@"应用相机权限受限,请在设置中启用"];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }

        [self takePhoto];
        
    }];
    
    UIAlertAction *alertAct3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *alertAct4 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        
    }
}
//打开本地相册
-(void)LocalPhoto

{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //设置选择后的图片可被编辑
    
    picker.allowsEditing = YES;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}


//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
//        CGSize imagesize = image.size;
////        imagesize.height = image.size.height/10.0;
////        imagesize.width = image.size.width/10.0;
//        imagesize.height = 91;
//        imagesize.width = kScreenWidth/2.0-64;
//
//        //对图片大小进行压缩--
//        image = [self imageWithImage:image scaledToSize:imagesize];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        NSData *data;
        
//        if (UIImagePNGRepresentation(image) == nil)
//        {
//            data = UIImageJPEGRepresentation(image, 0.00001);
//        }
//        else{
//            data = UIImagePNGRepresentation(image);
//            
//        }
        data = UIImageJPEGRepresentation(image, 0.1);
        
        //上传图片
        NSString *str= [GlobalConfig getAbsoluteUrl:uploadInvoice_HTTP];            
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
                self.zengzhishuiurl =picUrl;
                [self.imgBottomType3 setImage:image];
                [self btnInvoiceTypeAction:self.btnInvoiceType3];
                
 
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                [SVProgressHUD ms_dismiss];
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
            }];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
