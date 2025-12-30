//
//  WY_UserInfoViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_UserInfoViewController.h"
#import "WY_CompanyModel.h"

#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import <AVFoundation/AVFoundation.h>
#import "WY_AvoidanceUnitViewController.h"
#import "WY_SignViewController.h"

@interface WY_UserInfoViewController ()<UIImagePickerControllerDelegate>
{
    float lastY;
    int selMailTypeIndex;
    NSString *PicFilePath;
    
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIImageView *imgHead;
@property (nonatomic , strong) UILabel *lblPhone;
@property (nonatomic , strong) UILabel *lblName;
@property (nonatomic , strong) UILabel *lblIdcard;
@property (nonatomic , strong) UILabel *lblIsCPC;   //是否中共党
@property (nonatomic , strong) UILabel *lblIsSign;  //是否已有签字
@property (nonatomic , strong) UILabel *lblEmail;
@property (nonatomic , strong) UILabel *lblWechat;
@property (nonatomic , strong) UILabel *lblCompanyname;
@property (nonatomic , strong) UILabel *lblAddress;
@property (nonatomic , strong) UILabel *lblEnterprise;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_CompanyModel *selWY_CompanyModel;
@property (nonatomic, strong) NSString * mSignUrl;
@property (nonatomic, strong) NSString *isSelIDCard;

///身份证OCR结果
@property (nonatomic, strong) NSMutableDictionary *dicIDCard;
@property (nonatomic, strong) NSString *isIdCardSuccess;

@end

@implementation WY_UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selMailTypeIndex = -1;
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    [self configCallback];
    [self makeUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self bindView];
}

- (void)makeUI {
    self.title = @"个人信息";
    
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.mScrollView];
    
    self.lblName = [UILabel new];
    self.lblEmail = [UILabel new];
    self.lblPhone = [UILabel new];
    self.lblIdcard = [UILabel new];
    self.lblIsCPC = [UILabel new];
    self.lblIsSign = [UILabel new];
    self.lblWechat = [UILabel new];
    self.lblCompanyname = [UILabel new];
    self.lblAddress = [UILabel new];
    self.lblEnterprise = [UILabel new];
    self.imgHead = [UIImageView new];
    
    UIButton *cancleButton = [[UIButton alloc] init];
    cancleButton.frame = CGRectMake(0, 0, 44, 44);
    [cancleButton setTitle:@"保存" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}


- (void)bindView {
    lastY = 0 ;
    
    [self.mScrollView removeAllSubviews];
    
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:[self.mUser.avatarPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    self.lblPhone.text = self.mUser.LoginID;
    
    self.lblName.text = self.mUser.realname;
    
    self.lblIdcard.text = self.mUser.idcardnum;
    
    if ([self.mUser.partyMember isNotBlank]) {
        if  ([self.mUser.partyMember isEqualToString:@"1"]) {
            self.lblIsCPC.text = @"是";
        } else {
            self.lblIsCPC.text = @"不是";
        }
    } else {
        self.lblIsCPC.text = @"请选择";
    }
    
    if ([self.mUser.userSignature isNotBlank]) {
        self.lblIsSign.text = @"已完善";
    } else {
        self.lblIsSign.text = @"未完善";
    }
    
    
    self.lblEmail.text = self.mUser.EMail;
    
    self.lblWechat.text = self.mUser.weixin;
    
    self.lblCompanyname.text = self.mUser.DanWeiName;
    
    self.lblAddress.text = self.mUser.address;
    switch ([self.mUser.orgtype intValue]) {
        case 1:
        {
            self.lblEnterprise.text = @"招标代理机构";
        }
            break;
        case 2:
        {
            self.lblEnterprise.text = @"投标单位";
        }
            break;
        case 3:
        {
            self.lblEnterprise.text = @"监督管理部门";
        }
            break;
        case 4:
        {
            self.lblEnterprise.text = @"其他";
        }
            break;
            
        default:
            break;
    }
    
    if ([self.mUser.UserType isEqualToString:@"5"]) {
        self.lblEnterprise.text = @"其他";
    }
    [self initCellTitle:@"头像" byImage:self.imgHead isAcc:NO withBlcok:^{
        NSLog(@"点击了头像按钮");
        self.isSelIDCard = @"0";
        [self updateHead];
    }];
    
    [self initCellTitle:@"电话" byLabel:self.lblPhone isAcc:NO withBlcok:^{
        //        [self updatePhone];
    }];
//    [self initCellTitle:@"姓名" byLabel:self.lblName isAcc:self.mUser.realname.length <= 0 withBlcok:^{
//        //        [self updateUserName];
//        //        [self goIDCarSettingPage];
//        //TODO:2025-11-11 17:13:28 -要去掉百度身份证扫描识别OCR 功能，  改用公司自身 OCR 产品
//        self.isSelIDCard = @"1";
//        [self updateHead];
//    }];
    //测试OCR用的
        [self initCellTitle:@"姓名" byLabel:self.lblName isAcc:YES withBlcok:^{
    //        [self updateUserName];
    //        [self goIDCarSettingPage];
            //TODO:2025-11-11 17:13:28 -要去掉百度身份证扫描识别OCR 功能，  改用公司自身 OCR 产品
            self.isSelIDCard = @"1";
            [self updateHead];
        }];
    [self initCellTitle:@"身份证号" byLabel:self.lblIdcard isAcc:self.mUser.idcardnum.length <= 0 withBlcok:^{
        //        [self updateIDCardNum];
        //        [self goIDCarSettingPage];
        //TODO:2025-11-11 17:13:28 -要去掉百度身份证扫描识别OCR 功能，  改用公司自身 OCR 产品
        self.isSelIDCard = @"1";
        [self updateHead];
    }];
    
    [self initCellTitle:@"是否中共党员" byLabel:self.lblIsCPC isAcc:YES withBlcok:^{
        
        UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self tSaveCPC:@"1"];
        }];
        
        
        UIAlertAction *alertAct4 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self tSaveCPC:@"0"];
        }];
        
        
        UIAlertAction *alertAct3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertControllerStyle alertStyle = UIAlertControllerStyleAlert;
        if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
            alertStyle = UIAlertControllerStyleAlert;
        } else {
            alertStyle = UIAlertControllerStyleActionSheet;
        }
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择您是否中共党员" preferredStyle:alertStyle];
        
        [alertControl addAction:alertAct];
        
        [alertControl addAction:alertAct4];
        
        [alertControl addAction:alertAct3];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
        //选择党员
    }];
    //    [self initCellTitle:@"个人签字" byLabel:self.lblIsSign isAcc:YES withBlcok:^{
    //        //选择党员
    //        WY_SignViewController *tempController = [WY_SignViewController new];
    //        tempController.isSaveSign = @"1";
    //        tempController.popVCBlock = ^(NSString * _Nonnull picUrl) {
    //            self.mSignUrl = picUrl;
    //            [self tSaveSignUrl:self.mSignUrl];
    //        };
    //        tempController.modalPresentationStyle = 0;
    //        [self presentViewController:tempController animated:YES completion:nil];
    //
    //    }];
    
    
    //    [self initCellTitle:@"身份证号" byLabel:self.lblIdcard isAcc:YES withBlcok:^{
    //    //        [self updateIDCardNum];
    //            [self goIDCarSettingPage];
    //        }];
    lastY += k360Width(20);
    [self initCellTitle:@"邮箱" byLabel:self.lblEmail isAcc:YES withBlcok:^{
        [self updateEmail];
    }];
    [self initCellTitle:@"微信" byLabel:self.lblWechat isAcc:YES withBlcok:^{
        [self updateWeChat];
    }];
    lastY += k360Width(20);
    //    if  ([self.mUser.UserType isEqualToString:@"1"] || [self.mUser.UserType isEqualToString:@"2"]) {
    //    //这尼玛是企业主
    [self initCellTitle:@"公司名称" byLabel:self.lblCompanyname isAcc:NO withBlcok:^{
    }];
    //    } else {
    //        [self initCellTitle:@"公司名称" byLabel:self.lblCompanyname isAcc:YES withBlcok:^{
    //               [self updateCompanyname];
    //           }];
    //    }
    
    
    //    [self initCellTitle:@"详细地址" byLabel:self.lblAddress isAcc:NO withBlcok:^{
    
    //    }];
    //    if (self.mUser.DanWeiName.length <= 0) {
    //        [self initCellTitle:@"企业性质" byLabel:self.lblEnterprise isAcc:NO withBlcok:^{
    //           }];
    //    } else {
    //        [self initCellTitle:@"企业性质" byLabel:self.lblEnterprise isAcc:YES withBlcok:^{
    //              [self updateEnterprise];
    //          }];
    //    }
    UILabel *lblhbdw =  [UILabel new];
    lblhbdw.text = @"点击查看";
    
    
    [self initCellTitle:@"回避单位" byLabel:lblhbdw isAcc:YES withBlcok:^{
        if (EXPERTISMIND == 1 || EXPERTISMIND == 2) {
            [SVProgressHUD showErrorWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
            return;
        }
        WY_UserModel *tempUser = [WY_UserModel new];
        tempUser.idcardnum = self.mUser.idcardnum;
        tempUser.yhname = self.mUser.realname;
        tempUser.key = self.mUser.idcardnum;
        tempUser.userid = self.mUser.UserGuid;
        [[MS_BasicDataController sharedInstance] postWithReturnCode:checkinjianguan_HTTP params:nil jsonData:[tempUser toJSONData] showProgressView:YES success:^(id res, NSString *code) {
            if (([code integerValue] == 0 || [code integerValue] == 1) && res) {
                WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
                currentUserModel.token = self.mUser.token;
                //如果是专家- 跳转
                if  ([currentUserModel.UserType isEqualToString:@"1"]) {
                    WY_AvoidanceUnitViewController *tempController = [WY_AvoidanceUnitViewController new];
                    [self.navigationController pushViewController:tempController animated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"您不是专家无法查看此功能"];
                }
            } else {
                [self.view makeToast:res[@"msg"]];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"请求失败，请稍后再试"];
            
        }];
        
    }];
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, lastY)];
}

- (void) tSaveCPC:(NSString *) isCPC {
    NSLog(@"保存CPC");
    //    /huiyuanUser/getUserSignature    参数userGui会员id   signature  签字地址    idcardbum身份证号
    //    zj_getUserSignature_HTTP
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:isCPC forKey:@"partyMember"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_getUserSignature_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"设置成功");
        self.mUser.partyMember = isCPC;
        if ([self.mUser.partyMember isNotBlank]) {
            if  ([self.mUser.partyMember isEqualToString:@"1"]) {
                self.lblIsCPC.text = @"是";
            } else {
                self.lblIsCPC.text = @"否";
            }
        } else {
            self.lblIsCPC.text = @"请选择";
        }
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
    
}
- (void) tSaveSignUrl:(NSString *)signUrl {
    NSLog(@"保存签字图片");
    //    /huiyuanUser/getUserSignature    参数userGui会员id   signature  签字地址    idcardbum身份证号
    //    zj_getUserSignature_HTTP
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:signUrl forKey:@"signature"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_getUserSignature_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"设置成功");
        self.mUser.userSignature = signUrl;
        if ([self.mUser.userSignature isNotBlank]) {
            self.lblIsSign.text = @"已完善";
        } else {
            self.lblIsSign.text = @"未完善";
        }
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
}
///修改头像
- (void) updateHead {
    NSString *titleStr = @"";
    if([self.isSelIDCard isEqualToString:@"1"]) {
        NSLog(@"上传身份证照片");
        titleStr = @"上传身份证照片";
    } else {
        NSLog(@"修改头像");
        titleStr = @"修改头像";
    }
    
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
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:titleStr message:nil preferredStyle:alertStyle];
    
    [alertControl addAction:alertAct];
    
    [alertControl addAction:alertAct4];
    
    [alertControl addAction:alertAct3];
    
    [self presentViewController:alertControl animated:YES completion:nil];
    
    
}
///修改电话号码
- (void)updatePhone {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改电话号码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入电话号码";
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.text = self.mUser.MobilePhone;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *alertTxt = alertController.textFields[0].text;
        NSLog(@"电话号码：%@",alertTxt);
        if (alertTxt.length > 0) {
            if (![GlobalConfig isValidateMobile:alertTxt]) {
                [self.view makeToast:@"请输入正确电话号码"  duration:1 position:CSToastPositionCenter];
                [self presentViewController:alertController animated:YES completion:nil];
                
                return ;
            }
            self.mUser.MobilePhone = alertTxt;
            [self bindView];
        }else {
            [self.view makeToast:alertController.textFields[0].placeholder duration:1 position:CSToastPositionCenter];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
            
            
        }
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
///修改姓名
- (void)updateUserName {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改姓名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入姓名";
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.text = self.mUser.realname;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *alertTxt = alertController.textFields[0].text;
        NSLog(@"姓名：%@",alertTxt);
        if (alertTxt.length > 0) {
            self.mUser.realname = alertTxt;
            [self bindView];
        }else {
            [self.view makeToast:alertController.textFields[0].placeholder duration:1 position:CSToastPositionCenter];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
            
        }
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
///修改身份证号
- (void)updateIDCardNum {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改身份证号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入身份证号";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.text = self.mUser.idcardnum;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *alertTxt = alertController.textFields[0].text;
        NSLog(@"身份证号：%@",alertTxt);
        if (alertTxt.length > 0) {
            if (![GlobalConfig isValidateIDCard:alertTxt]) {
                [self.view makeToast:@"请输入有效身份证号"  duration:1 position:CSToastPositionCenter];
                [self presentViewController:alertController animated:YES completion:nil];
                
                return ;
            }
            self.mUser.idcardnum = alertTxt;
            [self bindView];
        }else {
            [self.view makeToast:alertController.textFields[0].placeholder duration:1 position:CSToastPositionCenter];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
            
        }
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///修改邮箱
- (void)updateEmail {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改邮箱" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入邮箱";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.text = self.mUser.EMail;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *alertTxt = alertController.textFields[0].text;
        NSLog(@"邮箱：%@",alertTxt);
        if (alertTxt.length > 0) {
            if (![GlobalConfig isValidateEmail:alertTxt]) {
                [self.view makeToast:@"请输入有效的邮箱" duration:1 position:CSToastPositionCenter];
                [self presentViewController:alertController animated:YES completion:nil];
                return ;
            }
            self.mUser.EMail = alertTxt;
            [self bindView];
        }else {
            [self.view makeToast:alertController.textFields[0].placeholder duration:1 position:CSToastPositionCenter];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
        }
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///修改微信
- (void)updateWeChat {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改微信" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入微信";
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.text = self.mUser.weixin;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *alertTxt = alertController.textFields[0].text;
        NSLog(@"微信：%@",alertTxt);
        if (alertTxt.length > 0) {
            self.mUser.weixin = alertTxt;
            [self bindView];
        }else {
            [self.view makeToast:alertController.textFields[0].placeholder duration:1 position:CSToastPositionCenter];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
            
        }
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)updateCompanyname {
    NSLog(@"修改公司名称");
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"cardID"];
    [postDic setObject:@"1" forKey:@"currentPage"];
    [postDic setObject:@"100" forKey:@"pageItemNum"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:getCompanyListByID_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"查询成功");
        self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_CompanyModel class] json:successCallBack[@"data"]];
        if (self.arrDataSource.count == 0) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"1、请您再次检查身份证输入是否正确。\n2、请您再次确认您单位或人员是否在诚信库中。\n3、请您再次确认网联平台与信息管理中统一社会信用代码是否一致。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:okA];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return ;
        }
        NSMutableArray *arrGsNames = [NSMutableArray new];
        for (WY_CompanyModel *cModel in self.arrDataSource) {
            [arrGsNames addObject:cModel.companyName];
        }
        [ActionSheetStringPicker showPickerWithTitle:@"请选择公司" rows:arrGsNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.selWY_CompanyModel = self.arrDataSource[selectedIndex];
            self.mUser.orgnum = self.selWY_CompanyModel.unitorgnum;
            self.mUser.DanWeiName = self.selWY_CompanyModel.companyName;
            [self bindView];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
        
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
}

- (void)updateEnterprise {
    NSLog(@"修改企业性质");
    [ActionSheetStringPicker showPickerWithTitle:@"请选择企业性质" rows:@[@"招标代理机构",@"投标单位",@"监督管理部门",@"其他"] initialSelection:selMailTypeIndex==-1?0:selMailTypeIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selMailTypeIndex = selectedIndex;
        self.mUser.orgtype = [NSString stringWithFormat:@"%d",selectedIndex+1];
        [self bindView];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
    
}

- (void)initCellTitle:(NSString *)titleStr byImage:(UIImageView *)withImg isAcc:(BOOL)isAcc   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(80))];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:[UIColor grayColor]];
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    
    
    [withImg setFrame:CGRectMake(viewTemp.width - k360Width(66 + 16), k360Width(16), k360Width(66), k360Width(66))];
    withImg.centerY = viewTemp.centerY;
    [viewTemp addSubview:withImg];
    
    viewTemp.height = withImg.bottom + k360Width(16);
    
    lblTitle.centerY = viewTemp.centerY;
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (withBlcok) {
            withBlcok();
        }
    }];
    lastY = viewTemp.bottom;
}

- (void)initCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel isAcc:(BOOL)isAcc   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:[UIColor grayColor]];
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
    
    
    [withLabel setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(16), k360Width(250) - accLeft, k360Width(44))];
    [withLabel setFont:WY_FONTRegular(14)];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextAlignment:NSTextAlignmentRight];
    [withLabel sizeToFit];
    withLabel.left = kScreenWidth - withLabel.width - k360Width(16) - accLeft;
    if (withLabel.height < k360Width(12)) {
        withLabel.height = k360Width(12);
    }
    
    viewTemp.height = withLabel.bottom + k360Width(16);
    [viewTemp addSubview:withLabel];
    
    lblTitle.height = viewTemp.height;
    if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    
}

/// 保存
- (void)navRightAction{
    NSLog(@"保存");
    
    if (self.selWY_CompanyModel != nil) {
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        [dicPost setObject:self.mUser.LoginID forKey:@"loginId"];
        [dicPost setObject:self.selWY_CompanyModel.unitorgnum forKey:@"orgnum"];
        
        [[MS_BasicDataController sharedInstance] postWithURL:updateDanWeiInfo_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id successCallBack) {
            MSLog(@"设置成功");
            self.mUser.orgnum = self.selWY_CompanyModel.unitorgnum;
            self.mUser.DanWeiName = self.selWY_CompanyModel.companyName;
        } failure:^(NSString *failureCallBack) {
            [SVProgressHUD showErrorWithStatus:failureCallBack];
        } ErrorInfo:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        }];
    }
    
    
    if ([self.mUser.idcardnum isEqualToString:[MS_BasicDataController sharedInstance].user.idcardnum]) {
        self.mUser.idcardnum = nil;
    }
    [[MS_BasicDataController sharedInstance] postWithURL:updateUserInfo_HTTP params:nil jsonData:[self.mUser toJSONData] showProgressView:YES success:^(id successCallBack) {
        MSLog(@"设置成功");
        if (!self.mUser.idcardnum) {
            self.mUser.idcardnum = [MS_BasicDataController sharedInstance].user.idcardnum;
        }
        [MS_BasicDataController sharedInstance].user = self.mUser;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
    
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
        picker.allowsEditing = ![self.isSelIDCard isEqualToString:@"1"];
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
    
    picker.allowsEditing = ![self.isSelIDCard isEqualToString:@"1"];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (void)uploadUserIDCardImg:(NSDictionary * _Nonnull)info picker:(UIImagePickerController * _Nonnull)picker type:(NSString *)type {
    //上传身份证图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.1);
        NSString *str=[GlobalConfig getAbsoluteUrl:EuploadFile_HTTP];
        
        NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
        
        [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
        
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
        
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        [mgr POST:str parameters:dicPost headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
            [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
            
            NSString *picUrl = json[@"data"];
            //            NSString *picUrl = @"https://lnwlzj.capass.cn/lnwlzj/d548da8b56de4d4a8d508a8bab2a2966.jpg";
            //           NSString *picUrl = @"https://lnwlzj.capass.cn/lnwlzj/58a9cded50df42ec94d03bffabf6320a.jpg";
            //            NSString *picUrl =@"https://lnwlzj.capass.cn/lnwlzj/bf686e0ba6974b32b5d5c81a7773726b.jpg";
            
            // json[@"data"];
            NSMutableDictionary *postDic = [NSMutableDictionary new];
            [postDic setObject:picUrl forKey:@"idCardImg"];
            [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_recognition_idcard_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                [SVProgressHUD ms_dismiss];
                if([res[@"code"] intValue] == 200) {
                    NSString *idCardNum = res[@"data"][@"idCard"];
                    NSString *pName = res[@"data"][@"name"];
                    
                    if (idCardNum.length <= 0 || pName.length <= 0 ) {
                        [SVProgressHUD showErrorWithStatus:@"身份证信息识别错误"];
                        return;
                    }
                    
                    if(![GlobalConfig validateIDCardNumber:idCardNum]) {
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"未识别到有效身份证信息：%@",idCardNum]];
                        return;
                    }
                    self.mUser.realname = pName;
                    self.mUser.idcardnum = idCardNum;
                    [self bindView];
                    [SVProgressHUD showSuccessWithStatus:@"身份证信息识别成功"];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"身份证信息识别错误"];
                }
                
                
            } failure:^(NSError *error) {
                [SVProgressHUD ms_dismiss];
                [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
            }];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD ms_dismiss];
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }];
        
        
        
        //                   [mgr POST:str parameters:dicPost constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //                        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        //                       [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
        //                   } progress:^(NSProgress * _Nonnull uploadProgress) {
        //
        //                   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
        //                       [SVProgressHUD ms_dismiss];
        //
        //                       [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        //                        NSDictionary *dic=json;
        //                       WY_UserModel *tempUser = [WY_UserModel modelWithJSON:dic[@"data"]];
        //                        WY_UserModel *loadHeadUser = [MS_BasicDataController sharedInstance].user;
        //                       loadHeadUser.avatarPath = tempUser.avatarPath;
        //                       [MS_BasicDataController sharedInstance].user = loadHeadUser;
        //                       self.mUser.avatarPath = tempUser.avatarPath;
        //                       [self.imgHead setImage:image];
        //                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //                       [SVProgressHUD ms_dismiss];
        //                       [SVProgressHUD showErrorWithStatus:@"上传失败"];
        //                   }];
        
        
        //        //图片保存的路径
        //
        //        //这里将图片放在沙盒的documents文件夹中
        //
        //        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //
        //        //文件管理器
        //
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //
        //        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        //
        //
        //
        //        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        //
        //        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/wxImage.png"] contents:data attributes:nil];
        //
        //
        //        //得到选择后沙盒中图片的完整路径
        //        PicFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, @"/wxImage.png"];
        //
        //        NSLog(@"%@",PicFilePath);
        //
        //        //   背景图
        //        NSArray* PicPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString* PicDocumentsDirectory = [PicPaths objectAtIndex:0];
        //        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        //
        //                NSString* PicFullPathToFile = [PicDocumentsDirectory stringByAppendingPathComponent:imageName];
        //
        //                NSString *str=[NSString stringWithFormat:@"%@%@",BASE_IP,UPLOADTP_HTTP];
        //
        //                NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
        //
        //                [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
        //
        //                NSMutableURLRequest *PicRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:str parameters:dicPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        #pragma mark   //添加转圈
        //                    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
        //
        //                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:PicFullPathToFile] name:@"file" fileName:imageName mimeType:@"image/png" error:nil];
        //                } error:nil];
        //                [PicRequest setValue:[MS_BasicDataController sharedInstance].user.token forHTTPHeaderField:@"token"];
        //                [PicRequest setValue:[MS_BasicDataController sharedInstance].user.UserGuid forHTTPHeaderField:@"UserGuid"];
        //
        //                AFURLSessionManager *PicManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        //                //        NSProgress *PicProgress = nil;
        //
        //                NSURLSessionUploadTask *PicUploadTask = [PicManager uploadTaskWithStreamedRequest:PicRequest progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        //                    [SVProgressHUD ms_dismiss];
        //                    if (error) {
        //                         [SVProgressHUD showErrorWithStatus:@"上传失败"];
        //                    } else {
        //                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        //                        NSDictionary *dic=responseObject;
        //                        WY_UserModel *tempUser = [WY_UserModel modelWithJSON:dic[@"data"]];
        //                         WY_UserModel *loadHeadUser = [MS_BasicDataController sharedInstance].user;
        //                        loadHeadUser.avatarPath = tempUser.avatarPath;
        //                        [MS_BasicDataController sharedInstance].user = loadHeadUser;
        //                        self.mUser.avatarPath = tempUser.avatarPath;
        //                        [self.imgHead setImage:image];
        //                    }
        //                }];
        //                [PicUploadTask resume];
    }
}
- (void)uploadUserHead:(NSDictionary * _Nonnull)info picker:(UIImagePickerController * _Nonnull)picker type:(NSString *)type {
    
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        //        CGSize imagesize = image.size;
        ////        imagesize.height = image.size.height/10.0;
        ////        imagesize.width = image.size.width/10.0;
        //        imagesize.height = 91;
        //        imagesize.width = kScreenWidth/2.0-64;
        
        //        //对图片大小进行压缩--
        //        image = [self imageWithImage:image scaledToSize:imagesize];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.1);
        NSString *str=[GlobalConfig getAbsoluteUrl:UPLOADTP_HTTP];
        
        NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
        
        [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
        
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
        
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        [mgr POST:str parameters:dicPost headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
            [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD ms_dismiss];
            
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            NSDictionary *dic=responseObject;
            WY_UserModel *tempUser = [WY_UserModel modelWithJSON:dic[@"data"]];
            WY_UserModel *loadHeadUser = [MS_BasicDataController sharedInstance].user;
            loadHeadUser.avatarPath = tempUser.avatarPath;
            [MS_BasicDataController sharedInstance].user = loadHeadUser;
            self.mUser.avatarPath = tempUser.avatarPath;
            [self.imgHead setImage:image];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD ms_dismiss];
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }];
        
        
        
        //                   [mgr POST:str parameters:dicPost constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //                        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        //                       [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
        //                   } progress:^(NSProgress * _Nonnull uploadProgress) {
        //
        //                   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
        //                       [SVProgressHUD ms_dismiss];
        //
        //                       [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        //                        NSDictionary *dic=json;
        //                       WY_UserModel *tempUser = [WY_UserModel modelWithJSON:dic[@"data"]];
        //                        WY_UserModel *loadHeadUser = [MS_BasicDataController sharedInstance].user;
        //                       loadHeadUser.avatarPath = tempUser.avatarPath;
        //                       [MS_BasicDataController sharedInstance].user = loadHeadUser;
        //                       self.mUser.avatarPath = tempUser.avatarPath;
        //                       [self.imgHead setImage:image];
        //                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //                       [SVProgressHUD ms_dismiss];
        //                       [SVProgressHUD showErrorWithStatus:@"上传失败"];
        //                   }];
        
        
        //        //图片保存的路径
        //
        //        //这里将图片放在沙盒的documents文件夹中
        //
        //        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //
        //        //文件管理器
        //
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //
        //        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        //
        //
        //
        //        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        //
        //        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/wxImage.png"] contents:data attributes:nil];
        //
        //
        //        //得到选择后沙盒中图片的完整路径
        //        PicFilePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, @"/wxImage.png"];
        //
        //        NSLog(@"%@",PicFilePath);
        //
        //        //   背景图
        //        NSArray* PicPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString* PicDocumentsDirectory = [PicPaths objectAtIndex:0];
        //        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        //
        //                NSString* PicFullPathToFile = [PicDocumentsDirectory stringByAppendingPathComponent:imageName];
        //
        //                NSString *str=[NSString stringWithFormat:@"%@%@",BASE_IP,UPLOADTP_HTTP];
        //
        //                NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
        //
        //                [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
        //
        //                NSMutableURLRequest *PicRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:str parameters:dicPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        #pragma mark   //添加转圈
        //                    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
        //
        //                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:PicFullPathToFile] name:@"file" fileName:imageName mimeType:@"image/png" error:nil];
        //                } error:nil];
        //                [PicRequest setValue:[MS_BasicDataController sharedInstance].user.token forHTTPHeaderField:@"token"];
        //                [PicRequest setValue:[MS_BasicDataController sharedInstance].user.UserGuid forHTTPHeaderField:@"UserGuid"];
        //
        //                AFURLSessionManager *PicManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        //                //        NSProgress *PicProgress = nil;
        //
        //                NSURLSessionUploadTask *PicUploadTask = [PicManager uploadTaskWithStreamedRequest:PicRequest progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        //                    [SVProgressHUD ms_dismiss];
        //                    if (error) {
        //                         [SVProgressHUD showErrorWithStatus:@"上传失败"];
        //                    } else {
        //                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        //                        NSDictionary *dic=responseObject;
        //                        WY_UserModel *tempUser = [WY_UserModel modelWithJSON:dic[@"data"]];
        //                         WY_UserModel *loadHeadUser = [MS_BasicDataController sharedInstance].user;
        //                        loadHeadUser.avatarPath = tempUser.avatarPath;
        //                        [MS_BasicDataController sharedInstance].user = loadHeadUser;
        //                        self.mUser.avatarPath = tempUser.avatarPath;
        //                        [self.imgHead setImage:image];
        //                    }
        //                }];
        //                [PicUploadTask resume];
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if([self.isSelIDCard isEqualToString:@"1"]) {
        NSLog(@"上传身份证照片");
        [self uploadUserIDCardImg:info picker:picker type:type];
    } else {
        NSLog(@"修改头像");
        [self uploadUserHead:info picker:picker type:type];
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

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        self.isIdCardSuccess = @"1";
        self.dicIDCard = result;
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别成功" message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        self.isIdCardSuccess = @"2";
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}


- (void)goIDCarSettingPage {
    
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont
                                 andImageHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id result){
            _successHandler(result);
            // 这里可以存入相册
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
        }
                                                     failHandler:_failHandler];
    }];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
    //    WY_IDCarSettingViewController *tempController = [WY_IDCarSettingViewController new];
    //    [self.tabBarController.selectedViewController pushViewController:tempController animated:NO];
    
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.isIdCardSuccess isEqualToString:@"1"]) {
        [self ocrSuccess];
    }
}

- (void)ocrSuccess {
    //如果不是首次注册补全信息- 是人脸识别 -并成功后进入功能；
    __block    NSString *idCardNum = @"";
    __block    NSString *pName = @"";
    NSDictionary *result =  self.dicIDCard;
    if(result[@"words_result"]){
        if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
            [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                    if ([key isEqualToString:@"姓名"]) {
                        pName = [NSString stringWithFormat:@"%@",obj[@"words"]];
                    }
                    if ([key isEqualToString:@"公民身份号码"]) {
                        idCardNum = [NSString stringWithFormat:@"%@",obj[@"words"]];
                    }
                }
                
            }];
        }
    }
    
    if (idCardNum.length <= 0 || pName.length <= 0 ) {
        [SVProgressHUD showErrorWithStatus:@"身份证信息识别错误"];
        return;
    }
    
    self.mUser.realname = pName;
    self.mUser.idcardnum = idCardNum;
    
    [self bindView];
    
    //       WY_UserModel *tempUser = [WY_UserModel new];
    //        tempUser.idcardnum = idCardNum;
    //        tempUser.yhname = pName;
    //        tempUser.key = idCardNum;
    //        tempUser.userid = self.mUser.UserGuid;
    //        [self zhuanJiaLaQuByPost:tempUser];
    
}
@end
