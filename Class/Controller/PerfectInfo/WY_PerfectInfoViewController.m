//
//  WY_PerfectInfoViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_PerfectInfoViewController.h"
#import "WY_PerfectInfo2ViewController.h"
#import "WY_PerfectInfo3ViewController.h"
#import "WY_PerfectInfo10ViewController.h"
#import "WY_PerfectInfo8ViewController.h"
#import "WY_ExpertMessageModel.h"
#import "ActionSheetStringPicker.h"
#import "WY_CityModel.h"
#import "WY_SelectJobTitle1ViewController.h"
#import "ActionSheetStringPicker.h"
#import "SLCustomActivity.h"
#import "WY_AvoidanceUnitViewController.h"
#import "WY_UpdateZjPhoneViewController.h"
#import "WY_UploadZJCAPhotoViewController.h"
#import "WY_AddBankCardViewController.h"
#import "WY_UpdateZjAddressViewController.h"

@interface WY_PerfectInfoViewController ()
{
    int lastY;
    UIView *viewJobTitle;
    UIView *viewZdhb;
    //专家资格证书
    UIView *viewZjzgzs;
    UIView *viewZjYHK;
    UIView *viewYDW;
}
@property (nonatomic , strong) UIView *viewTop;
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic , strong) UITextField *lblzjSex;
@property (nonatomic , strong) UILabel *lblAddress;
@property (nonatomic , strong) UILabel *lblzjPhone;
@property (nonatomic , strong) UILabel *lblzjYhk;
@property (nonatomic , strong) UILabel *lblstyleId;
@property (nonatomic , strong) UITextField *txtzjName;
@property (nonatomic , strong) UITextField *txtzjIDCard;
@property (nonatomic , strong) UITextField *txtzjDanWeiName;
@property (nonatomic , strong) UITextField *txtzjBankAddress;
@property (nonatomic , strong) UITextField *txtzjBankNum;

@property (nonatomic , strong) NSMutableArray *arrjobTitleList;
@property (nonatomic , strong) NSMutableArray *arrZdhb;
@property (nonatomic , strong) NSMutableArray *arrYdw;
@property (nonatomic , strong) WY_ExpertMessageModel *mWY_ExpertMessageModel;
//暂存数据
@property (nonatomic , strong) WY_ExpertMessageModel *mStorageWY_ExpertMessageModel;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic) int alStatus;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic) BOOL canEdit;
@property (nonatomic, strong) NSString * isNewExpert;
@end

@implementation WY_PerfectInfoViewController

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
            //审核通过后 - 改成 可以修改了；
            self.canEdit = NO;
            if ((self.isFormal == 1 || self.isFormal == 2)) {
                self.reason = @"可以修改";
                //审核通过后并且是正式专家 - 改成 可以修改了；
                self.canEdit = YES;
            }
        }
            break;
        case 10:
        {
            self.reason = @"基本信息审核通过，无法修改信息";
//            2023-03-02 09:48:38 - 补全老专业-原需求只允许补全修改老专业的图片，改为允许修改基本信息，佟：第一页里单位、职称，申请表可以更新
            self.canEdit = YES;
//            self.canEdit = NO;
        }
            break;
        case 0:
        case 6: {
            self.canEdit = YES;
        }
            break;
        default:
            break;
    }
    [self makeUI];
    [self dataBind];
    
    
}

- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    
    
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
    [img2 setImage:[UIImage imageNamed:@"0611_ws2h"]];
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
    [lbltop2 setTextColor:HEXCOLOR(0x8B8B8B)];
    [lbltop3 setTextColor:HEXCOLOR(0x8B8B8B)];
    
    [lbltop1 setFont:WY_FONT375Medium(16)];
    [lbltop2 setFont:WY_FONT375Medium(12)];
    [lbltop3 setFont:WY_FONT375Medium(16)];
    
    [lbltop1 setText:@"基础认证"];
    [lbltop2 setText:@"••••••••••"];
    [lbltop3 setText:@"资格认证"];
    
    
    
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
    
}
- (void)donghua {
    NSLog(@"不能一直");
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
        [self presentViewController:activityVC animated:YES completion:nil];
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

- (void)dataBind {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [postDic setObject:self.source forKey:@"source"];
    NSString *urlStr = expert_getExpertInfo_HTTP;
    
    [[MS_BasicDataController sharedInstance] postWithURL:urlStr params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (successCallBack) {
            self.mWY_ExpertMessageModel = [WY_ExpertMessageModel modelWithJSON:successCallBack];
            self.mStorageWY_ExpertMessageModel = [WY_ExpertMessageModel modelWithJSON:successCallBack];
            self.mWY_ExpertMessageModel.selStyleId  = @"单位推荐";
            self.mStorageWY_ExpertMessageModel.selStyleId  = @"单位推荐";
            [self bindView];
            
            if(!self.canEdit) {
                [self.txtzjName setEnabled:NO];
                [self.txtzjIDCard setEnabled:NO];
                [self.txtzjBankNum setEnabled:NO];
                [self.txtzjBankAddress setEnabled:NO];
                [self.txtzjDanWeiName setEnabled:NO];
            }
        }
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
    
    
    NSMutableDictionary *dicPost1 = [NSMutableDictionary new];
    [dicPost1 setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithURL:zj_expertgetExpertIsNew_HTTP params:dicPost1 jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if ([successCallBack intValue] == 1) {
            //是新入库专家
            self.isNewExpert = @"1";
        } else {
            self.isNewExpert = @"0";
        }
        
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
}
- (void)bindView {
    [self.mScrollView removeAllSubviews];
    self.txtzjName = [UITextField new];
    self.txtzjIDCard = [UITextField new];
    self.lblzjPhone = [UILabel new];
    self.lblzjPhone.text = @"请输入手机号";
    self.lblzjYhk = [UILabel new];
    self.lblzjYhk.text = @"请完善专家银行卡信息";
    self.txtzjDanWeiName = [UITextField new];
    self.txtzjBankAddress = [UITextField new];
    self.txtzjBankNum = [UITextField new];
    self.lblzjSex = [UITextField new];
    self.lblAddress = [UILabel new];
    self.lblstyleId = [UILabel new];
    
    self.lblzjSex.text = @"请选择性别";
    
    self.lblAddress.text = @"请选择专家管理属地";
    self.lblstyleId.text = @"请选择推荐来源";
    
    [self initCellTitle:@"专家姓名" byUITextField:self.txtzjName];
    
    [self initCellTitle:@"专家性别" byUITextField:self.lblzjSex];
    
    
    [self initCellTitle:@"证件号码" byUITextField:self.txtzjIDCard];
    // 正式库专家 可以修改手机号  -
    
    self.lblzjPhone.text = self.mWY_ExpertMessageModel.zjPhone;
    
    [self initCellTitle:@"专家库预留手机号" byLabel:self.lblzjPhone isAcc:YES withBlcok:^{
        NSLog(@"修改手机号");
        if (self.isFormal != 1 && self.isFormal != 2) {
            [SVProgressHUD showErrorWithStatus:@"非正式库专家暂时不能修改专家库预留手机号"];
            return;
        }
        WY_UpdateZjPhoneViewController *tempController = [WY_UpdateZjPhoneViewController new];
        tempController.updateSuccessBlock = ^(NSString * _Nonnull phoneNum) {
            self.lblzjPhone.text = phoneNum;
        };
        [self.navigationController pushViewController:tempController animated:YES];
    }];
    
    WS(weakSelf)
    [self initCellTitle:@"专家管理属地" byLabel:self.lblAddress isAcc:YES withBlcok:^{
        NSLog(@"选择专家管理属地");
        
        if (weakSelf.mWY_ExpertMessageModel.city.length <= 0) {
            if (weakSelf.mWY_ExpertMessageModel.cityList) {
                NSMutableArray *cityStrArr = [NSMutableArray new];
                for (WY_CityModel *cityModel in weakSelf.mWY_ExpertMessageModel.cityList) {
                    [cityStrArr addObject:cityModel.cityname];
                }
                
                [ActionSheetStringPicker showPickerWithTitle:@"请选择专家管理属地" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    WY_CityModel *cityModel =  weakSelf.mWY_ExpertMessageModel.cityList[selectedIndex];
                    weakSelf.mWY_ExpertMessageModel.city = cityModel.cityname;
                    weakSelf.mWY_ExpertMessageModel.cityCode = cityModel.residentId;
                    self.lblAddress.text = selectedValue;
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self.view];
            }
        } else {
            //一直都不让改-从来没放开过，专家管理属地不允许修改！再次确定-张总2021年11月05日08:55:01 说的  专家管理属地不可以自己修改 - 去提建议咨询核实后去发改申请；
//            [SVProgressHUD showErrorWithStatus:@"专家管理属地修改暂未开放"];
//            return;
            //2024-05-22 10:58:49 - 开放功能 打版
            //2023-03-15 10:59:51 - 新增 调整地区申请
            NSLog(@"新增 调整地区申请");
            if (self.isFormal != 1 && self.isFormal != 2) {
                [SVProgressHUD showErrorWithStatus:@"非正式库专家暂时不能修改专家管理属地"];
                return;
            }
            WY_UpdateZjAddressViewController *tempController = [WY_UpdateZjAddressViewController new];
            tempController.cityStr =  self.mWY_ExpertMessageModel.city;
            tempController.cityList = self.mWY_ExpertMessageModel.cityList;
            tempController.aexpertId = self.mWY_ExpertMessageModel.aexpertId;
            tempController.updateSuccessBlock = ^(WY_CityModel * _Nonnull cityModel) {
//                 weakSelf.mWY_ExpertMessageModel.city = cityModel.cityname;
//                weakSelf.mWY_ExpertMessageModel.cityCode = cityModel.residentId;
//                self.lblAddress.text = cityModel.cityname;
            };
            [self.navigationController pushViewController:tempController animated:YES];
        }
    }];
    
  
    self.lblzjYhk.text = @"未完善";
    
    [self initCellTitle:@"专家银行卡" byLabel:self.lblzjYhk isAcc:YES withBlcok:^{
        NSLog(@"选择专家银行卡");
        WY_AddBankCardViewController *tempController = [WY_AddBankCardViewController new];
        tempController.title = @"银行卡信息";
        tempController.selBankResuleBlock = ^(NSString * _Nonnull strResule) {
            if ([strResule isEqualToString:@"1"]) {
                self.lblzjYhk.text = @"已完善";
                [self.lblzjYhk setTextColor:HEXCOLOR(0x00C38A)];
            } else {
                self.lblzjYhk.text = @"未完善";
                [self.lblzjYhk setTextColor:HEXCOLOR(0xEA0000)];
            }
        };
        [self.navigationController pushViewController:tempController animated:YES];
    }];
   
    
    //判断专家是否已绑定银行卡 - 如未绑定 提示去绑定
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getExpertBank_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if (![res[@"data"] isEqual:[NSNull null]]) {
                NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                //银行卡信息 已完善- 则不提示银行内容bankAttributionCode
                if ([dicData[@"bankType"] isNotBlank] && [dicData[@"bankName"] isNotBlank] && [dicData[@"bankCard"] isNotBlank] && [dicData[@"bankAttributionCode"] isNotBlank]) {
                    
                    self.lblzjYhk.text = @"已完善";
                    [self.lblzjYhk setTextColor:HEXCOLOR(0x00C38A)];
                } else {
                    self.lblzjYhk.text = @"未完善";
                    [self.lblzjYhk setTextColor:HEXCOLOR(0xEA0000)];
                }
            } else {
                self.lblzjYhk.text = @"未完善";
                [self.lblzjYhk setTextColor:HEXCOLOR(0xEA0000)];
            }
        } else {
            self.lblzjYhk.text = @"未完善";
            [self.lblzjYhk setTextColor:HEXCOLOR(0xEA0000)];
        }
    } failure:^(NSError *error) {
 
    }];
    
//    if ([self.mWY_ExpertMessageModel.zjBankNum isNotBlank] &&  [self.mWY_ExpertMessageModel.zjBankType isNotBlank] && [self.mWY_ExpertMessageModel.zjBankName isNotBlank]) {
//        self.lblzjYhk.text = @"已完善";
//        [self.lblzjYhk setTextColor:HEXCOLOR(0x00C38A)];
//    } else {
//        self.lblzjYhk.text = @"未完善";
//        [self.lblzjYhk setTextColor:HEXCOLOR(0xEA0000)];
//    }
    
//    [self initCellTitle:@"开户行" byUITextField:self.txtzjBankAddress];
//    [self initCellTitle:@"银行卡号" byUITextField:self.txtzjBankNum];
    
//    [self initCellTitle:@"推荐来源" byLabel:self.lblstyleId isAcc:YES withBlcok:^{
//        NSLog(@"选择推荐来源");
//        //        if (!self.canEdit) {
//        //            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
//        //            [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //            }]];
//        //            [self presentViewController:alertControl animated:YES completion:nil];
//        //            return;
//        //        }
//        //        if (weakSelf.mWY_ExpertMessageModel.styleId.length <= 0) {
//
//        NSMutableArray *cityStrArr = [NSMutableArray new];
//        [cityStrArr addObject:@"自荐"];
//        [cityStrArr addObject:@"单位推荐"];
//        [ActionSheetStringPicker showPickerWithTitle:@"请选择推荐来源" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//            self.lblstyleId.text = selectedValue;
//            weakSelf.mWY_ExpertMessageModel.selStyleId = selectedValue;
//        } cancelBlock:^(ActionSheetStringPicker *picker) {
//
//        } origin:self.view];
//
//        //        } else {
//        //            [SVProgressHUD showErrorWithStatus:@"推荐来源不得随意修改"];
//        //        }
//    }];
    
    [self initCellTitle:@"单位名称" byUITextField:self.txtzjDanWeiName];
    
//    //viewZjYHK 银行卡 -Start
//    viewZjYHK = [[UIView alloc] initWithFrame:CGRectMake(0, lastY +  k360Width(10), kScreenWidth, k360Width(44))];
//    [viewZjYHK setBackgroundColor:[UIColor whiteColor]];
//    UILabel *lblZjYHK = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth, k360Width(44))];
//    lblZjYHK.tag = 1001;
//    NSMutableAttributedString *attStr2xa = [[NSMutableAttributedString alloc] initWithString:@"*"];
//    [attStr2xa setYy_color:[UIColor redColor]];
//
//    NSMutableAttributedString *attStr1xa = [[NSMutableAttributedString alloc] initWithString:@"专家银行卡"];
//    [attStr1xa setYy_font:WY_FONTMedium(14)];
//    [attStr2xa appendAttributedString:attStr1xa];
//    lblZjYHK.attributedText = attStr2xa;
//    [viewZjYHK addSubview:lblZjYHK];
//
//    UIButton *lblZjYHKText = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -  k360Width(296), 0, k360Width(280), k360Width(44))];
//    lblZjYHKText.tag = 1001;
//    [lblZjYHKText setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    //    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
//    //    [attStr setYy_color:[UIColor redColor]];
//    NSMutableAttributedString *attStr1aValue = [[NSMutableAttributedString alloc] initWithString:@"去完善银行卡信息"];
//    [attStr1aValue setYy_font:WY_FONTMedium(14)];
//    [attStr1aValue setYy_color:MSTHEMEColor];
//    //    [attStr appendAttributedString:attStr1];
//    [lblZjYHKText setAttributedTitle:attStr1aValue forState:UIControlStateNormal];
//    [viewZjYHK addSubview:lblZjYHKText];
//    [lblZjYHKText addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//        //@"请上传辽宁省评标专家资格证书"
//        NSLog(@"请完善银行卡信息");
//        //111
//     }];
//
//    [self.mScrollView addSubview:viewZjYHK];
//    lastY =  viewZjYHK.bottom;
//    //viewZjYHK 银行卡 -END
    //专家资格证书 - Start
    viewZjzgzs = [[UIView alloc] initWithFrame:CGRectMake(0, lastY +  k360Width(10), kScreenWidth, k360Width(44))];
    [viewZjzgzs setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblZjzgzs = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth, k360Width(44))];
    lblZjzgzs.tag = 1001;
    NSMutableAttributedString *attStr1x = [[NSMutableAttributedString alloc] initWithString:@"专家资格证书"];
    [attStr1x setYy_font:WY_FONTMedium(14)];
    lblZjzgzs.attributedText = attStr1x;
    [viewZjzgzs addSubview:lblZjzgzs];
    
    UIButton *lblZjzgzsText = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -  k360Width(296), 0, k360Width(280), k360Width(44))];
    lblZjzgzsText.tag = 1001;
    [lblZjzgzsText setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    //    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1Value = [[NSMutableAttributedString alloc] initWithString:@"去完善辽宁省评标专家资格证书"];
    [attStr1Value setYy_font:WY_FONTMedium(14)];
    [attStr1Value setYy_color:MSTHEMEColor];
    //    [attStr appendAttributedString:attStr1];
    [lblZjzgzsText setAttributedTitle:attStr1Value forState:UIControlStateNormal];
    [viewZjzgzs addSubview:lblZjzgzsText];
    [lblZjzgzsText addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //@"请上传辽宁省评标专家资格证书"
        NSLog(@"请上传辽宁省评标专家资格证书")
        WY_UploadZJCAPhotoViewController *tempController = [WY_UploadZJCAPhotoViewController new];
        tempController.mWY_ExpertMessageModel = self.mWY_ExpertMessageModel;
        
        tempController.source= self.source;
        [self.navigationController pushViewController:tempController animated:YES];
    }];
    
    [self.mScrollView addSubview:viewZjzgzs];
    lastY =  viewZjzgzs.bottom;
    //专家资格证书END
    
    self.txtzjBankNum.keyboardType = UIKeyboardTypeNumberPad;
    
    self.txtzjDanWeiName.placeholder = @"若您已退休请输入退休单位名称";
    
    
    viewJobTitle = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(10), kScreenWidth, k360Width(100))];
    [viewJobTitle setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblJobTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth, k360Width(44))];
    lblJobTitle.tag = 1001;
    NSMutableAttributedString *attStrz = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStrz setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1z = [[NSMutableAttributedString alloc] initWithString:@"专业职称"];
    [attStr1z setYy_font:WY_FONTMedium(14)];
    [attStrz appendAttributedString:attStr1z];
    lblJobTitle.attributedText = attStrz;
    [viewJobTitle addSubview:lblJobTitle];
    [self.mScrollView addSubview:viewJobTitle];
    
    
    viewZdhb = [[UIView alloc] initWithFrame:CGRectMake(0, viewJobTitle.bottom + k360Width(10), kScreenWidth, k360Width(100))];
    [viewZdhb setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblZdhb = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth, k360Width(44))];
    lblZdhb.tag = 1001;
    //    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    //    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"主动申请回避单位"];
    [attStr1 setYy_font:WY_FONTMedium(14)];
    //    [attStr appendAttributedString:attStr1];
    lblZdhb.attributedText = attStr1;
    [viewZdhb addSubview:lblZdhb];
    
    UIButton *lblZdhbText = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -  k360Width(96), 0, k360Width(80), k360Width(44))];
    lblZdhbText.tag = 1001;
    [lblZdhbText setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    //    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1a = [[NSMutableAttributedString alloc] initWithString:@"去修改"];
    [attStr1a setYy_font:WY_FONTMedium(14)];
    [attStr1a setYy_color:MSTHEMEColor];
    //    [attStr appendAttributedString:attStr1];
    [lblZdhbText setAttributedTitle:attStr1a forState:UIControlStateNormal];
    [viewZdhb addSubview:lblZdhbText];
    [lblZdhbText addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //进入修改回避单位页面；
        WY_AvoidanceUnitViewController *tempController = [WY_AvoidanceUnitViewController new];
        [self.navigationController pushViewController:tempController animated:YES];
        
    }];
    
    [self.mScrollView addSubview:viewZdhb];
    
    
    
    self.txtzjName.text = self.mWY_ExpertMessageModel.zjName;
    self.txtzjIDCard.text = self.mWY_ExpertMessageModel.zjIdCard;
    //    self.lblzjPhone.text = self.mWY_ExpertMessageModel.zjPhone;
    [self.lblzjPhone setTextColor:[UIColor blackColor]];
    self.txtzjBankAddress.text = self.mWY_ExpertMessageModel.zjBankType;
    self.lblAddress.text = self.mWY_ExpertMessageModel.city;
    self.txtzjBankNum.text = self.mWY_ExpertMessageModel.zjBankNum;
    if (self.mWY_ExpertMessageModel.styleId.length > 0) {
        self.lblstyleId.text = self.mWY_ExpertMessageModel.styleId;
        self.mWY_ExpertMessageModel.selStyleId = self.mWY_ExpertMessageModel.styleId;
    }
    if (self.mWY_ExpertMessageModel.currentCompany.count > 0) {
        
        WY_ZJCompanyModel *tempModel = self.mWY_ExpertMessageModel.currentCompany[0];
        self.txtzjDanWeiName.text = tempModel.companyName;
    }
    if (self.mWY_ExpertMessageModel.zjSex.length <= 0) {
        NSInteger zjsex =  [self genderOfIDNumber:self.mWY_ExpertMessageModel.zjIdCard];
        if (zjsex == 2) {
            //女
            self.lblzjSex.text = @"女";
            
        } else if (zjsex == 1) {
            //男
            self.lblzjSex.text = @"男";
        } else {
            self.lblzjSex.text = @"未知";
        }
    } else {
        self.lblzjSex.text = self.mWY_ExpertMessageModel.zjSex;
        
    }
    
    [self.txtzjName setUserInteractionEnabled:NO];
    [self.txtzjIDCard setUserInteractionEnabled:NO];
    [self.lblzjPhone setUserInteractionEnabled:NO];
    [self.lblzjSex setUserInteractionEnabled:NO];
    
    self.arrjobTitleList =  [[NSMutableArray alloc] initWithArray:self.mWY_ExpertMessageModel.jobTitleList];
    [self initviewJobTitle];
    
    self.arrZdhb = [[NSMutableArray alloc] initWithArray:self.mWY_ExpertMessageModel.voidCompany];
    
    [self initviewZdhb];
    
    
    viewYDW = [[UIView alloc] initWithFrame:CGRectMake(0, viewZdhb.bottom + k375Width(10), kScreenWidth, k375Width(44))];
    [self.mScrollView addSubview:viewYDW];
    self.arrYdw = [[NSMutableArray alloc] initWithArray:self.mWY_ExpertMessageModel.originalCompany];
    [self initviewYDW];
}

- (void) tishi1 {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"您的银行卡信息未完善，请您完善银行卡信息"];
    [alertControllerMessageStr setYy_alignment:NSTextAlignmentCenter];
    [alertControllerMessageStr setYy_font:WY_FONT375Medium(12)];
    [alertControllerMessageStr setYy_lineSpacing:1];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [alertController addAction:([UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WY_AddBankCardViewController *tempController = [WY_AddBankCardViewController new];
        tempController.title = @"银行卡信息";
        tempController.selBankResuleBlock = ^(NSString * _Nonnull strResule) {
            if ([strResule isEqualToString:@"1"]) {
                self.lblzjYhk.text = @"已完善";
                [self.lblzjYhk setTextColor:HEXCOLOR(0x00C38A)];
            } else {
                self.lblzjYhk.text = @"未完善";
                [self.lblzjYhk setTextColor:HEXCOLOR(0xEA0000)];
            }
        };
        [self.navigationController pushViewController:tempController animated:YES];
     }])];

    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
     }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (NSInteger)genderOfIDNumber:(NSString *)IDNumber
{
    //  记录校验结果：0未知，1男，2女
    NSInteger result = 0;
    NSString *fontNumer = nil;
    
    if (IDNumber.length == 15)
    { // 15位身份证号码：第15位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(14, 1)];
        
    }else if (IDNumber.length == 18)
    { // 18位身份证号码：第17位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(16, 1)];
    }else
    { //  不是15位也不是18位，则不是正常的身份证号码，直接返回
        return result;
    }
    
    NSInteger genderNumber = [fontNumer integerValue];
    
    if(genderNumber % 2 == 1)
        result = 1;
    
    else if (genderNumber % 2 == 0)
        result = 2;
    return result;
}

- (void)initviewJobTitle {
    for (UIView *viewIn in viewJobTitle.subviews) {
        if (viewIn.tag != 1001) {
            [viewIn removeFromSuperview];
        }
    }
    int lastYZdhb = k360Width(44);
    for (WY_ZJCompanyModel *comModel in self.arrjobTitleList) {
        UIView *zdhbViewItem = [[UIView alloc] initWithFrame:CGRectMake(0, lastYZdhb, kScreenWidth, k360Width(44))];
        UIButton *btnDel = [UIButton new];
        [btnDel setFrame:CGRectMake(k360Width(16), k360Width(10), k360Width(22), k360Width(22))];
        [btnDel setImage:[UIImage imageNamed:@"0622_del"] forState:UIControlStateNormal];
        [btnDel setImage:[UIImage imageNamed:@"0622_nodel"] forState:UIControlStateSelected];
        [zdhbViewItem addSubview:btnDel];
        [viewJobTitle addSubview:zdhbViewItem];
        UIButton *lblName = [UIButton new];
        [lblName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [lblName setFrame:CGRectMake(btnDel.right + k360Width(5), 0, kScreenWidth - btnDel.right - k360Width(10), k360Width(44))];
        [lblName setTitle:comModel.jobTitleName forState:UIControlStateNormal];
        [lblName.titleLabel setNumberOfLines:0];
        //        [lblName.titleLabel sizeToFit];
        //        lblName.height += 10;
        
        [lblName layoutIfNeeded]; // need this to update the button's titleLabel's size
        lblName.height = lblName.titleLabel.height + k360Width(16);
        if (lblName.height < k360Width(44)) {
            lblName.height = k360Width(44);
        }
        
        
        [lblName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lblName addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            NSLog(@"点击了选择专业职称");
            if (!self.canEdit) {
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertControl animated:YES completion:nil];
                return;
            }
            WY_SelectJobTitle1ViewController *tempController = [WY_SelectJobTitle1ViewController new];
            tempController.selJobTitleBlock = ^(WY_ZJCompanyModel * _Nonnull selModel) {
                comModel.jobTitleCode = selModel.jobTitleCode;
                comModel.jobTitleName = selModel.jobTitleName;
                [self initviewJobTitle];
            };
            [self.navigationController pushViewController:tempController animated:YES];
            
        }];
        [btnDel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (!self.canEdit) {
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertControl animated:YES completion:nil];
                return;
            }
            [self.arrjobTitleList removeObject:comModel];
            [self initviewJobTitle];
        }];
        [zdhbViewItem addSubview:lblName];
        [btnDel setSelected:NO];
        [lblName setUserInteractionEnabled:YES];
        lastYZdhb = zdhbViewItem.bottom;
    }
    
    UIButton *btnAddZdhb = [[UIButton alloc] initWithFrame:CGRectMake(0, lastYZdhb + k360Width(10), k375Width(130), k375Width(32))];
    btnAddZdhb.centerX = viewJobTitle.centerX;
    
    [btnAddZdhb setTitle:@"新增专业职称" forState:UIControlStateNormal];
    [btnAddZdhb setImage:[UIImage imageNamed:@"0615_AddMj"] forState:UIControlStateNormal];
    [btnAddZdhb setTitleColor:HEXCOLOR(0x448eee) forState:UIControlStateNormal];
    [btnAddZdhb rounded:k375Width(32/4) width:1 color:HEXCOLOR(0x448eee)];
    [btnAddZdhb.titleLabel setFont:WY_FONT375Medium(17)];
    
    [btnAddZdhb addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (!self.canEdit) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertControl animated:YES completion:nil];
            return;
        }
        WY_SelectJobTitle1ViewController *tempController = [WY_SelectJobTitle1ViewController new];
        tempController.selJobTitleBlock = ^(WY_ZJCompanyModel * _Nonnull selModel) {
            selModel.source = self.source;
            [self.arrjobTitleList addObject:selModel];
            [self initviewJobTitle];
        };
        [self.navigationController pushViewController:tempController animated:YES];
    }];
    
    [viewJobTitle addSubview:btnAddZdhb];
    
    viewJobTitle.height = btnAddZdhb.bottom + k375Width(10);
    
    viewZdhb.top = viewJobTitle.bottom + k360Width(10);
    viewYDW.top = viewZdhb.bottom + k360Width(10);
    [self.mScrollView setContentSize:CGSizeMake(0, viewYDW.bottom + k360Width(10))];
    
}

- (void)initviewZdhb {
    //    viewZdhb.top = viewJobTitle.bottom + k360Width(10);
    //    for (UIView *viewIn in viewZdhb.subviews) {
    //        if (viewIn.tag != 1001) {
    //            [viewIn removeFromSuperview];
    //        }
    //    }
    //    int lastYZdhb = k360Width(44);
    //    for (WY_ZJCompanyModel *comModel in self.arrZdhb) {
    //        UIView *zdhbViewItem = [[UIView alloc] initWithFrame:CGRectMake(0, lastYZdhb, kScreenWidth, k360Width(44))];
    //        UIButton *btnDel = [UIButton new];
    //        [btnDel setFrame:CGRectMake(k360Width(16), k360Width(10), k360Width(22), k360Width(22))];
    //        [btnDel setImage:[UIImage imageNamed:@"0622_del"] forState:UIControlStateNormal];
    //        [btnDel setImage:[UIImage imageNamed:@"0622_nodel"] forState:UIControlStateSelected];
    //        [zdhbViewItem addSubview:btnDel];
    //        [viewZdhb addSubview:zdhbViewItem];
    //        UITextField *lblName = [UITextField new];
    //        [lblName setFrame:CGRectMake(btnDel.right + k360Width(5), 0, kScreenWidth - lblName.right - k360Width(10), k360Width(44))];
    //        lblName.text = comModel.companyName;
    //        lblName.placeholder = @"请输入主动回避单位名称";
    //        [lblName addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
    //            NSLog(@"这里是输入后内容：%@",lblName.text);
    //            comModel.companyName = lblName.text;
    //        }];
    //        [btnDel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
    //            if (!self.canEdit) {
    //                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
    //                [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                }]];
    //                [self presentViewController:alertControl animated:YES completion:nil];
    //                return;
    //            }
    //            if (btnDel.selected) {
    //                NSLog(@"不能删除");
    //                [SVProgressHUD showErrorWithStatus:@"不能删除已设置的回避单位"];
    //                return ;
    //              }
    //            [self.arrZdhb removeObject:comModel];
    //            [self initviewZdhb];
    //        }];
    //
    //        [zdhbViewItem addSubview:lblName];
    //        if ([comModel.isDel isEqualToString:@"1"]) {
    //            [btnDel setSelected:NO];
    //            [lblName setUserInteractionEnabled:YES];
    //        } else {
    //            [btnDel setSelected:YES];
    //            [lblName setUserInteractionEnabled:NO];
    //        }
    //        lastYZdhb = zdhbViewItem.bottom;
    //    }
    //
    //    UIButton *btnAddZdhb = [[UIButton alloc] initWithFrame:CGRectMake(0, lastYZdhb + k360Width(10), k375Width(130), k375Width(32))];
    //    btnAddZdhb.centerX = viewZdhb.centerX;
    //
    //    [btnAddZdhb setTitle:@"新增回避单位" forState:UIControlStateNormal];
    //    [btnAddZdhb setImage:[UIImage imageNamed:@"0615_AddMj"] forState:UIControlStateNormal];
    //    [btnAddZdhb setTitleColor:HEXCOLOR(0x448eee) forState:UIControlStateNormal];
    //    [btnAddZdhb rounded:k375Width(32/4) width:1 color:HEXCOLOR(0x448eee)];
    //    [btnAddZdhb.titleLabel setFont:WY_FONT375Medium(17)];
    //    [btnAddZdhb addTarget:self action:@selector(btnAddZdhbAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [viewZdhb addSubview:btnAddZdhb];
    //
    
    viewZdhb.height = k360Width(44);// btnAddZdhb.bottom + k375Width(10);
    
    
    viewYDW.top = viewZdhb.bottom + k360Width(10);
    [self.mScrollView setContentSize:CGSizeMake(0, viewYDW.bottom + k360Width(10))];
    
}

- (void)initviewYDW {
    [viewYDW setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblZdhb = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth, k360Width(44))];
    lblZdhb.tag = 1001;
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"原单位"];
    [attStr1 setYy_font:WY_FONTMedium(14)];
    lblZdhb.attributedText = attStr1;
    [viewYDW addSubview:lblZdhb];
    int lastYZdhb = k360Width(44);
    
    for (WY_ZJCompanyModel *comModel in self.arrYdw) {
        UILabel *lblDanWeiName = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), lastYZdhb, kScreenWidth - k360Width(32), k360Width(30))];
        lblDanWeiName.numberOfLines = 0;
        lblDanWeiName.lineBreakMode = NSLineBreakByWordWrapping;
        lblDanWeiName.text = comModel.companyName;
        [lblDanWeiName sizeToFit];
        [viewYDW addSubview:lblDanWeiName];
        lastYZdhb = lblDanWeiName.bottom + k360Width(10);
    }
    
    viewYDW.height = lastYZdhb;
    [self.mScrollView setContentSize:CGSizeMake(0, viewYDW.bottom + k360Width(10))];
}

- (void)btnAddZdhbAction:(UIButton *)btnSender {
    if (!self.canEdit) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    WY_ZJCompanyModel *comModel = [WY_ZJCompanyModel new];
    comModel.companyName = @"";
    comModel.isDel = @"1";
    [self.arrZdhb addObject:comModel];
    [self initviewZdhb];
}

- (void)initCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel isAcc:(BOOL)isAcc   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setTextColor:[UIColor grayColor]];
    
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attStr appendAttributedString:attStr1];
    lblTitle.attributedText = attStr;
    
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
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextAlignment:NSTextAlignmentRight];
    [withLabel setFont:WY_FONTRegular(14)];
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
            if (!self.canEdit && ![withLabel isEqual:self.lblzjPhone] && ![withLabel isEqual:self.lblzjYhk] && ![withLabel isEqual:self.lblAddress]) {
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:self.reason preferredStyle:UIAlertControllerStyleAlert];
                [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertControl animated:YES completion:nil];
                return;
            }
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
    if ([withText isEqual:self.txtzjBankAddress] || [withText isEqual:self.txtzjBankNum]) {
        //如果是银行开户行，和银行卡号- 不是必填项， 去掉*
        lblTitle.attributedText = attStr1;
    } else {
        lblTitle.attributedText = attStr;
    }
    
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [withText setTextAlignment:NSTextAlignmentRight];
    withText.placeholder = [NSString stringWithFormat:@"请输入%@",titleStr];
    [withText setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(0), k360Width(250 - 27)  , k360Width(44))];
    [withText setFont:WY_FONTRegular(14)];
    [viewTemp addSubview:withText];
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    
}


- (void)btnSubmitAction {
    NSLog(@"点击了提交订单");
    //    if (self.txtzjBankNum.text.length <= 0) {
    //        [SVProgressHUD showErrorWithStatus:self.txtzjBankNum.placeholder];
    //        [self.txtzjBankNum becomeFirstResponder];
    //        return;
    //    }
    if (self.lblzjPhone.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请设置专家库预留手机号"];
        return;
    }
    
    if (!self.mWY_ExpertMessageModel.cityCode) {
        [SVProgressHUD showErrorWithStatus:@"请选择专家管理属地"];
        return;
    }
//    推荐来源不显示- 并传参写死是-单位推荐了 - 2021-11-05  佟哥确定的
    self.mWY_ExpertMessageModel.selStyleId  = @"单位推荐";
//    if (!self.mWY_ExpertMessageModel.selStyleId) {
//        [SVProgressHUD showErrorWithStatus:@"请选择推荐来源"];
//        return;
//    }
    //    if (self.txtzjBankAddress.text.length <= 0) {
    //        [SVProgressHUD showErrorWithStatus:self.txtzjBankAddress.placeholder];
    //        [self.txtzjBankAddress becomeFirstResponder];
    //        return;
    //    }
    if (self.txtzjDanWeiName.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtzjDanWeiName.placeholder];
        [self.txtzjDanWeiName becomeFirstResponder];
        return;
    }
    
    if (self.arrjobTitleList.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择专业职称"];
        return;
    }
    
    if ([self.lblzjYhk.text isEqualToString: @"未完善"]) {
        [self tishi1];
        return;
    }
    
    for (WY_ZJCompanyModel *tempModel in self.arrjobTitleList) {
        int i =0;
        for (WY_ZJCompanyModel *tempModelA in self.arrjobTitleList) {
            if ([tempModel.jobTitleCode isEqualToString:tempModelA.jobTitleCode]) {
                i++;
            }
        }
        if (i >= 2) {
            [SVProgressHUD showErrorWithStatus:@"请删除重复专业职称"];
            return;
        }
        
    }
    
    self.mWY_ExpertMessageModel.jobTitleList = self.arrjobTitleList;
    
    
    /* 修改需求---2021-07-23 11:31:06 这里不传回避单位了 */
    //    self.mWY_ExpertMessageModel.voidCompany = self.arrZdhb;
    
    //    for (WY_ZJCompanyModel *cjCoModel in self.mWY_ExpertMessageModel.voidCompany) {
    //       if ([cjCoModel.companyName isEqualToString:@""]) {
    //             [SVProgressHUD showErrorWithStatus:@"请在主动回避单位中填写内容"];
    //             return;
    //
    //        }
    //    }
    
    //    if (self.mWY_ExpertMessageModel.voidCompany.count <= 0) {
    //        [SVProgressHUD showErrorWithStatus:@"请添加主动回避单位"];
    //        return;
    //    }
    
    //    for (WY_ZJCompanyModel *tempModel in self.mWY_ExpertMessageModel.voidCompany) {
    //        int i =0;
    //        for (WY_ZJCompanyModel *tempModelA in self.mWY_ExpertMessageModel.voidCompany) {
    //            if ([tempModel.companyName isEqualToString:tempModelA.companyName]) {
    //                i++;
    //            }
    //        }
    //        if (i >= 2) {
    //            [SVProgressHUD showErrorWithStatus:@"请删除重复回避单位"];
    //            return;
    //        }
    //
    //    }
    
    self.mWY_ExpertMessageModel.zjSex = self.lblzjSex.text;
//    2022-03-03 10:21:10 zjBankNum和zjBankType在expert/updateZjData接口就不传了@城南旧酒@
//    self.mWY_ExpertMessageModel.zjBankType = self.txtzjBankAddress.text;
//    self.mWY_ExpertMessageModel.zjBankNum = self.txtzjBankNum.text;
    self.mWY_ExpertMessageModel.zjOriginalCompany = self.txtzjDanWeiName.text;
    
    //进到下一页的时候- 把cityCode存到userdef 里 ， 获取专业的时候需要用
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:self.mWY_ExpertMessageModel.cityCode forKey:@"EMM_cityCode"];
    
    
    //1是原来的 2是新的
    if ([self.jumpToWhere intValue] == 1 && [self.source intValue] == 1) {
        WY_PerfectInfo2ViewController *tempController = [WY_PerfectInfo2ViewController new];
        tempController.title = self.title;
        tempController.approvalStatusNum = self.approvalStatusNum;
        tempController.source = self.source;
        tempController.mWY_ExpertMessageModel = self.mWY_ExpertMessageModel;
        [self.navigationController pushViewController:tempController animated:YES];
    }
    else  if ([self.jumpToWhere intValue] == 10 ) {
        WY_PerfectInfo10ViewController *tempController = [WY_PerfectInfo10ViewController new];
        tempController.title = self.title;
        tempController.approvalStatusNum = self.approvalStatusNum;
        tempController.source = self.source;
        tempController.mWY_ExpertMessageModel = self.mWY_ExpertMessageModel;
        [self.navigationController pushViewController:tempController animated:YES];
    }
    else  if ([self.jumpToWhere intValue] == 8 ) {
        WY_PerfectInfo8ViewController *tempController = [WY_PerfectInfo8ViewController new];
        tempController.title = self.title;
        tempController.isNewExpert = self.isNewExpert;
        //模拟续聘专家
        tempController.isRenewalFlag = self.isRenewalFlag;
        tempController.approvalStatusNum = self.approvalStatusNum;
        tempController.source = self.source;
        tempController.mWY_ExpertMessageModel = self.mWY_ExpertMessageModel;
        tempController.mStorageWY_ExpertMessageModel = self.mStorageWY_ExpertMessageModel;
        
        
        tempController.jumpToWhere = self.jumpToWhere;
        tempController.jujueContent = self.jujueContent;
        tempController.isFormal = self.isFormal;
        [self.navigationController pushViewController:tempController animated:YES];
    }
    
    else{
        WY_PerfectInfo3ViewController *tempController = [WY_PerfectInfo3ViewController new];
        tempController.title = self.title;
        tempController.approvalStatusNum = self.approvalStatusNum;
        tempController.source = self.source;
        tempController.mWY_ExpertMessageModel = self.mWY_ExpertMessageModel;
        tempController.jumpToWhere = self.jumpToWhere;
        [self.navigationController pushViewController:tempController animated:YES];
        
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

@end
