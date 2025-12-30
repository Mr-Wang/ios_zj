//
//  WY_AddBankCardViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/30.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AddBankCardViewController.h"
#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "WY_PickerCity.h"

@interface WY_AddBankCardViewController ()<WYPickerCityDelegate>
{
    int lastY;
    NSDictionary *mprovince;
    NSDictionary *mcity;
    NSDictionary *marea;
}
@property (nonatomic , strong) UIView *viewTop;
@property (nonatomic, strong) UITextField *txtUName;
@property (nonatomic, strong) UITextField *txtBankCardType;
@property (nonatomic, strong) IQTextView *txtBankAddress;
@property (nonatomic, strong) UITextField *txtBankCardNum;
//@property (nonatomic, strong) UITextField *txtPhoneNum;
@property (nonatomic, strong) UIButton *btnAgree;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSMutableDictionary *dicData;
@property (nonatomic, strong) NSMutableDictionary *dicCardData;
@property (nonatomic, strong) NSString *bank_card_number;
@property (nonatomic, strong) NSString *bank_name;

@property (nonatomic ,strong) UIButton *btnSelCity;
@end

@implementation WY_AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行卡信息";
    [self makeUI];
    [self bindView];
    [self dataSource];
}
- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    
    self.viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k375Width(63))];
    [self.viewTop setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    [self.view addSubview:self.viewTop];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(k375Width(75), k375Width(16.5), k375Width(33), k375Width(33))];
    UILabel *lbltop1 = [[UILabel alloc] initWithFrame:CGRectMake(img1.right + k375Width(10), 0, k375Width(200), k375Width(16))];
    [img1 setImage:[UIImage imageNamed:@"0630_banktop"]];
    lbltop1.text = @"请完善本人银行卡信息";
    lbltop1.centerY = img1.centerY;
    
    [self.viewTop addSubview:img1];
    [self.viewTop addSubview:lbltop1];
    
    [lbltop1 setTextColor:HEXCOLOR(0x757575)];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - self.viewTop.bottom - JCNew64 - k360Width(100) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    self.btnAgree = [[UIButton alloc] initWithFrame:CGRectMake(0, self.mScrollView.bottom + k375Width(7), k375Width(200), k375Width(30))];
    [self.btnAgree setImage:[UIImage imageNamed:@"icon_checkbox_s"] forState:UIControlStateNormal];
    [self.btnAgree setImage:[UIImage imageNamed:@"icon_checkbox_lxx"] forState:UIControlStateSelected];
    [self.btnAgree setTitle:@"本人确认信息真实有效" forState:UIControlStateNormal];
    [self.btnAgree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAgree.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    [self.btnAgree addTarget:self action:@selector(btnAgreeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.btnAgree.selected = NO;
    [self.view addSubview:self.btnAgree];
    self.btnAgree.centerX = self.mScrollView.centerX;
    
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.btnAgree.bottom + k375Width(7), k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"保  存" forState:UIControlStateNormal];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    //    [self.btnSubmit addTarget:self action:@selector(VFace) forControlEvents:UIControlEventTouchUpInside];
    //工信部要求去掉人脸
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.btnSubmit];
    
}

- (void)dataSource {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getExpertBank_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            self.dicData = res[@"data"];
            //            WY_TestQuestionsMainViewController *tempController = [WY_TestQuestionsMainViewController new];
            //            [self.navigationController pushViewController:tempController animated:YES];
            [self bindDataView];
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"data"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)bindDataView {
    self.txtUName.text = self.mUser.realname;//self.dicData[@"cardholder"];
    [self.txtUName setEnabled:NO];
    if (self.dicData != nil &&  ![self.dicData isEqual:[NSNull null]]) {
        if ([self.dicData[@"bankType"]  isNotBlank]) {
            self.txtBankAddress.text = self.dicData[@"bankType"];
        } else {
            self.txtBankAddress.text = @"";
        }
        
        if ([self.dicData[@"bankName"]  isNotBlank]) {
            self.txtBankCardType.text = self.dicData[@"bankName"];
        } else {
            self.txtBankCardType.text = @"";
        }
        
        if ([self.dicData[@"bankCard"]  isNotBlank]) {
            self.txtBankCardNum.text = self.dicData[@"bankCard"];
        } else {
            self.txtBankCardNum.text = @"";
        }
        
        if ([self.dicData[@"bankAttribution"]  isNotBlank]) {
            [self.btnSelCity setTitle:self.dicData[@"bankAttribution"] forState:UIControlStateNormal];
            [self.btnSelCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        
        
        
        
        /**
         * 开户行bankType
         */
        
        /**
         * 卡类型（建行，招行。。。。）bankName
         */
    }
    
}
- (void)bindView {
    [self.mScrollView removeAllSubviews];
    self.txtUName = [UITextField new];
    self.txtBankAddress = [IQTextView new];
    self.txtBankCardNum = [UITextField new];
    self.txtBankCardType = [UITextField new];
    //    self.txtPhoneNum = [UITextField new];
    
    
    [self initCellTitle:@"持卡人" byUITextField:self.txtUName];
    [self initCellTitle:@"卡   号" byUITextField:self.txtBankCardNum withBlcok:^{
        NSLog(@"点击银行卡号识别");
        [self goBankCarSettingPage];
    }];
    
    self.btnSelCity = [UIButton new];
//    [self.btnSelCity setFrame:CGRectMake(k360Width(16), lastY, kScreenWidth, k360Width(44))];
//    [self.btnSelCity setTitle:@"请选择银行卡归属地" forState:UIControlStateNormal];
//    [self.btnSelCity.titleLabel setFont:WY_FONTRegular(14)];
//    [self.btnSelCity setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [self.btnSelCity setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    [self.btnSelCity addTarget:self action:@selector(btnSelCityAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.mScrollView addSubview:self.btnSelCity];
//    lastY = self.btnSelCity.bottom;
    
    [self initCellTitle:@"银行卡归属地" bySelCity:self.btnSelCity withBlcok:nil];
    [self initCellTitle:@"开户银行名称" byUITextField:self.txtBankCardType];
    
    UILabel *lblTSA = [UILabel new];
    [lblTSA setFrame:CGRectMake(k360Width(16), lastY, kScreenWidth - k360Width(32), k360Width(30))];
    [lblTSA setText:@"例如:(中国工商银行、中国建设银行、华夏银行等)"];
    [lblTSA setTextColor:HEXCOLOR(0xfd6c32)];
    [self.mScrollView addSubview:lblTSA];
    [lblTSA setFont:WY_FONTRegular(12)];
    lastY = lblTSA.bottom;
    [self initCellTitle:@"开户行支行名称：" byUITextView:self.txtBankAddress];
    //    [self initCellTitle:@"手机号" byUITextField:self.txtPhoneNum];
    //    @"例:中国建设银行股份有限公司沈阳和平支行";
    
    UILabel *lblTS = [UILabel new];
    [lblTS setFrame:CGRectMake(k360Width(16), lastY, kScreenWidth - k360Width(32), k360Width(30))];
    [lblTS setText:@"例如:中国建设银行股份有限公司沈阳和平支行"];
    [lblTS setTextColor:HEXCOLOR(0xfd6c32)];
    [lblTS setFont:WY_FONTRegular(12)];
    [self.mScrollView addSubview:lblTS];
    
    lastY = lblTS.bottom;
    
    UILabel *lblTop2TsA = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), lastY, kScreenWidth - k375Width(24), k375Width(55))];
    [lblTop2TsA setNumberOfLines:4];
    [lblTop2TsA setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop2StrA = [[NSMutableAttributedString alloc] initWithString:@"单独维护银行卡信息时保存即可，不必提交专家信息审核，以免给您造成不必要的麻烦。"];
    [attTop2StrA setYy_font:WY_FONTMedium(14)];
    [attTop2StrA setYy_color:[UIColor redColor]];
    lblTop2TsA.attributedText = attTop2StrA;
    [lblTop2TsA setTextAlignment:NSTextAlignmentCenter];
    [lblTop2TsA sizeToFit];
    lblTop2TsA.height += 10;
    [self.mScrollView addSubview:lblTop2TsA];
    lastY = lblTop2TsA.bottom;
    
    [self.mScrollView setContentSize:CGSizeMake(0, lastY + k360Width(16))];
    
    self.txtUName.placeholder = @"请输入持卡人姓名";
    self.txtBankAddress.placeholder = @"请输入开户行支行名称";
    self.txtBankCardNum.placeholder = @"请输入银行卡号";
    [self.txtBankCardNum setKeyboardType:UIKeyboardTypeNumberPad];
    self.txtBankCardType.placeholder = @"输入卡号后自动识别";
    //       self.txtPhoneNum.placeholder = @"请输入银行预留手机号";
    self.txtBankCardNum.delegate = self;
    
    [self.txtBankCardNum addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
}


- (void)goBankCarSettingPage {
    WS(weakSelf);
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard
                                 andImageHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectBankCardFromImage:image successHandler:^(id result) {
            
            
            NSString *titleA = @"";
            NSMutableString *message = [NSMutableString string];
            if([result[@"result"] isKindOfClass:[NSDictionary class]]){
                titleA = @"识别成功";
                if([result[@"result"][@"bank_name"] isNotBlank]){
                    [message appendFormat:@"银行名称: %@\n", result[@"result"][@"bank_name"]];
                }
                if([result[@"result"][@"bank_card_number"] isNotBlank]){
                    [message appendFormat:@"银行卡号: %@", result[@"result"][@"bank_card_number"]];
                }
                
            }else{
                titleA = @"识别失败";
                [message appendFormat:@"%@", result];
            }
            weakSelf.bank_card_number = result[@"result"][@"bank_card_number"];
            weakSelf.bank_card_number = [weakSelf.bank_card_number stringByReplacingOccurrencesOfString:@" " withString:@""]; //[weakSelf.bank_card_number ]
            
            weakSelf.bank_name = result[@"result"][@"bank_name"];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if ([titleA isEqualToString:@"识别成功"]) {
                    UIAlertView *cgAlert = [[UIAlertView alloc] initWithTitle:@"请仔细核对银行卡识别结果" message:message delegate:weakSelf cancelButtonTitle:@"填充后修改" otherButtonTitles:@"正确",nil];
                    cgAlert.tag = 1001;
                    [cgAlert show];
                } else {
                    UIAlertView *cgAlert = [[UIAlertView alloc] initWithTitle:@"识别失败" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    cgAlert.tag = 1002;
                    [cgAlert show];
                }
                return;
                
                //                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleA message:message preferredStyle:UIAlertControllerStyleAlert];
                //                if ([titleA isEqualToString:@"识别成功"]) {
                //                    [alertController addAction:[UIAlertAction actionWithTitle:@"填充信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                //                        self.txtBankCardNum.text = result[@"result"][@"bank_card_number"];
                //                        self.txtBankCardType.text = result[@"result"][@"bank_name"];
                //
                //                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                //                    }]];
                //                }
                //                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //
                //                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                //                }]];
                //                [weakSelf presentViewController:alertController animated:YES completion:nil];
                
            }];
            
        } failHandler:^(NSError *err) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UIAlertView *cgAlert = [[UIAlertView alloc] initWithTitle:@"识别失败" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:nil];
                cgAlert.tag = 1001;
                [cgAlert show];
            }];
        }];
    }];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (alertView.tag == 1001) {
        self.txtBankCardNum.text = self.bank_card_number;
        self.txtBankCardType.text = self.bank_name;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
   if (![string isEqualToString:tem]) {

            return NO;
        }
             return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.txtBankCardNum isEqual:textField]) {
        NSString* str = self.txtBankCardNum.text;
        if (str.length >= 16) {
            [self searcCardNum:str];
        } else {
            //            self.txtBankCardType.text =@"请输入正确银行卡号";
            //            [self.txtBankCardType setTextColor:[UIColor redColor]];
        }
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)withText {
    if ([self.txtBankCardNum isEqual:withText]) {
        NSString* str = self.txtBankCardNum.text;
        if (str.length >= 16) {
            [self searcCardNum:str];
        }
    }
}

- (void)searcCardNum:(NSString *)withStr {
    NSLog(@"通过银行卡号查银行信息");
    NSMutableDictionary *postDic =         [[NSMutableDictionary alloc] init];
    [postDic setObject:withStr forKey:@"bankNum"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_expert_bank_getBank_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            self.dicCardData = res[@"data"];
            if (self.dicCardData !=nil && ![self.dicCardData isEqual:[NSNull null]]) {
                self.txtBankCardType.text = self.dicCardData[@"name"];
                [self.txtBankCardType setTextColor:[UIColor blackColor]];
            } else {
                [SVProgressHUD showErrorWithStatus:@"接口返回错误"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            //            self.txtBankCardType.text =@"请输入正确银行卡号";
            //            [self.txtBankCardType setTextColor:[UIColor redColor]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)initCellTitle:(NSString *)titleStr byUITextField:(UITextField *)withText {
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
    lblTitle.attributedText = attStr;
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [withText setTextAlignment:NSTextAlignmentRight];
    withText.placeholder = [NSString stringWithFormat:@"请输入%@",titleStr];
    [withText setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(0), k360Width(250 - 27)  , k360Width(44))];
    [viewTemp addSubview:withText];
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    
}



- (void)initCellTitle:(NSString *)titleStr byUITextField:(UITextField *)withText  withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    [lblTitle setTextColor:[UIColor grayColor]];
    
    
    int accLeft = 0;
    UIImageView *imgAcc;
    imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 10), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
    [imgAcc setImage:[UIImage imageNamed:@"icon_camera"]];
    [viewTemp addSubview:imgAcc];
    accLeft = imgAcc.width + k360Width(5);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attStr appendAttributedString:attStr1];
    lblTitle.attributedText = attStr;
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [withText setTextAlignment:NSTextAlignmentRight];
    withText.placeholder = [NSString stringWithFormat:@"请输入%@",titleStr];
    [withText setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(0), k360Width(250) - accLeft, k360Width(44))];
    [viewTemp addSubview:withText];
    
    imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
    [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (withBlcok) {
            withBlcok();
        }
    }];
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    
}



- (void)initCellTitle:(NSString *)titleStr bySelCity:(UIButton *)withSelCity  withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    [lblTitle setTextColor:[UIColor grayColor]];
    
    
    int accLeft = 0;
    UIImageView *imgAcc;
    imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 10), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
    [imgAcc setImage:[UIImage imageNamed:@"accup"]];
    [viewTemp addSubview:imgAcc];
    accLeft = imgAcc.width + k360Width(5);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attStr appendAttributedString:attStr1];
    lblTitle.attributedText = attStr;
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [withSelCity setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [withSelCity setTitle:[NSString stringWithFormat:@"请选择%@",titleStr] forState:UIControlStateNormal];
    [withSelCity setTitleColor:APPTextGayColor forState:UIControlStateNormal];

    [withSelCity setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(0), k360Width(250) - accLeft, k360Width(44))];
    [viewTemp addSubview:withSelCity];
    
    imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
    [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (withBlcok) {
            withBlcok();
        }
    }];
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    
}

- (void)initCellTitle:(NSString *)titleStr byUITextView:(IQTextView *)withText {
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
    lblTitle.attributedText = attStr;
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [withText setTextAlignment:NSTextAlignmentLeft];
    [withText setFont:WY_FONTRegular(14)];
    withText.placeholder = [NSString stringWithFormat:@"请输入%@",titleStr];
    [withText setFrame:CGRectMake(k360Width(16), lblTitle.bottom, kScreenWidth - k360Width(32)  , k360Width(75))];
    [viewTemp addSubview:withText];
    
    viewTemp.height = withText.bottom + k360Width(5);
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    
}


- (void)btnAgreeAction:(UIButton *)btnSender {
    btnSender.selected = !btnSender.selected;
}
- (void)btnSubmitAction {
    NSLog(@"点击了完成");
    if (!self.btnAgree.selected) {
        [SVProgressHUD showErrorWithStatus:@"请勾选确认信息真实有效"];
        return;
    }
    if (![self.txtUName.text isNotBlank]) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人姓名"];
        [self.txtUName setEnabled:YES];
        return;
    }
    if (![self.txtBankCardNum.text isNotBlank]) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return;
    }
    if (self.dicData != nil &&  ![self.dicData isEqual:[NSNull null]]) {
        if (![mcity[@"text"] isNotBlank] && ![self.dicData[@"bankAttribution"]  isNotBlank]) {
                [SVProgressHUD showErrorWithStatus:@"请选择银行卡归属地"];
                return;
        }
    } else {
        if (![mcity[@"text"] isNotBlank]) {
            [SVProgressHUD showErrorWithStatus:@"请选择银行卡归属地"];
            return;
        }
    }
    if (![self.txtBankCardType.text isNotBlank]) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行名称"];
        return;
    }
    if (![self.txtBankAddress.text isNotBlank]) {
        [SVProgressHUD showErrorWithStatus:@"请输入开户行"];
        return;
    }
    //     银行卡名称验证接口仅作为添加辅助 - 不作为校验功能
    [self submitData];
    //    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    //    [postDic setObject:self.txtBankCardNum.text forKey:@"bankNum"];
    //    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_expert_bank_getBank_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
    //        if ([code integerValue] == 0 ) {
    //            self.dicCardData = res[@"data"];
    //            if (self.dicCardData !=nil && ![self.dicCardData isEqual:[NSNull null]]) {
    //                [self submitData];
    //            } else {
    //                [SVProgressHUD showErrorWithStatus:@"接口返回错误"];
    //            }
    //        } else {
    //            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
    //        }
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    
}
- (void)submitData {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"expertIdCard"];
    [postDic setObject:self.txtUName.text forKey:@"cardholder"];
    
    NSString *bankCardNum = [self.txtBankCardNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    [postDic setObject:bankCardNum forKey:@"bankCard"];
    [postDic setObject:self.txtBankCardType.text forKey:@"bankName"];
    [postDic setObject:self.txtBankAddress.text forKey:@"bankType"];     
    if (![mcity[@"text"] isNotBlank]) {
        [postDic setObject:self.dicData[@"bankAttributionCode"] forKey:@"bankAttributionCode"];
        [postDic setObject:self.dicData[@"bankAttribution"] forKey:@"bankAttribution"];
    } else {
        [postDic setObject:mcity[@"id"] forKey:@"bankAttributionCode"];
        [postDic setObject:[NSString stringWithFormat:@"%@ %@",mprovince[@"text"],mcity[@"text"]] forKey:@"bankAttribution"];
    }
    
    
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_perfectBank_HTTP params:nil jsonData:[postDic mj_JSONData] showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            if  ([self selBankResuleBlock])
            {
                self.selBankResuleBlock(@"1");
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if  ([self selBankResuleBlock])
            {
                self.selBankResuleBlock(@"0");
            }
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        
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
- (void) VFace {
    //开始人脸识别；
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
        [weakSelf performSelectorOnMainThread:@selector(submitData:) withObject:imgFace waitUntilDone:YES];
    };
}
- (void)submitData:(UIImage *)imgFace {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.realname forKey:@"name"];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [dicPost setObject:self.mUser.LoginID forKey:@"loginId"];
    [dicPost setObject:[self UIImageToBase64Str:imgFace] forKey:@"base64Str"];
    
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:ZJsmrzxx_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            [self.view makeToast:res[@"msg"]];
            [self btnSubmitAction];
        } else {
            if ([code integerValue] == 2)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"比对不一致，请准备以下资料发至lnwlzb@163.com邮箱\n（1、身份证正反面；\n2、近期照片；\n3、超时截图；\n4、姓名及联系方式）。" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"我已了解" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
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


- (void)btnSelCityAction {
    NSLog(@"点击了选择地址按钮");
    [[IQKeyboardManager sharedManager] resignFirstResponder];

    WY_PickerCity *pickerSingle = [[WY_PickerCity alloc]init];
     [pickerSingle setTitle:@"请选择地区"];
     [pickerSingle setContentMode:STPickerContentModeBottom];
    [pickerSingle setSaveHistory:YES];
    [pickerSingle setDelegate:self];
    [pickerSingle show];
}

- (void)pickerArea:(WY_PickerCity *)pickerArea province:(nonnull NSDictionary *)province city:(nonnull NSDictionary *)city {
    NSLog(@"%@",city);
    mcity = city;
    mprovince = province;
    [self.btnSelCity setTitle:[NSString stringWithFormat:@"%@ %@",province[@"text"],city[@"text"]] forState:UIControlStateNormal];
    [self.btnSelCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
@end
