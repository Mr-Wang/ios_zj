//
//  WY_UpdateZjAddressViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/7/23.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_UpdateZjAddressViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_selPicView.h"
#import "WY_ProfessionModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageNewsDetailViewController.h"
#import "SLCustomActivity.h"
#import "MSAlertController.h"
#import "WY_OperationRecordViewController.h"

@interface WY_UpdateZjAddressViewController ()
{
    int lastY;
    int picIndex;
}
//注册按钮
@property (nonatomic, strong) UIButton *btnRegistered;
/// 验证码下线
@property (nonatomic, strong) UIView *viewYzmLine1;

@property (nonatomic, strong) WY_UserModel *mUser;


/// 用户协议View
@property (nonatomic, strong) UIView *viewUserAgr;
/// 选中未选中用户协议图片
@property (nonatomic, strong) UIImageView *selectedImg;

/// 注册协议选中按钮
@property (nonatomic, strong) UIButton *selectedBtn;

/// 用户协议
@property (nonatomic, strong) UILabel *userAgrLab;

/// 用户协议按钮
@property (nonatomic, strong) UIButton *userAgrBtn;
 
@property (nonatomic, strong)NSTimer * yzmTime;
@property (nonatomic) int yzmTimeNum;
@property (nonatomic , assign) BOOL isSelected;/* 是否同意用户协议 */
@property (nonatomic, strong) UIScrollView *mScrollView;

@property (nonatomic, strong) UIScrollView *scrollViewZgzs2;
@property (nonatomic ,strong) NSMutableArray *arrZgzs2;
@property (nonatomic ,strong) NSString * qualificationEleId2;
//详情页数据
@property (nonatomic ,strong) NSMutableDictionary *dicDataGG;

@end

@implementation WY_UpdateZjAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    
    // Do any additional setup after loading the view.
    
    UIButton *cancleButton = [[UIButton alloc] init];
    cancleButton.frame = CGRectMake(0, 0, 44, 44);
    [cancleButton setTitle:@"核验记录" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self dataSource];
}

- (void)dataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [postDic setObject:self.aexpertId forKey:@"id"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_updateDetail_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        self.dicDataGG = successCallBack;
        self.selCityModel = [WY_CityModel new];
        self.selCityModel.cityname = successCallBack[@"cityName"];
        self.selCityModel.residentId = successCallBack[@"cityCode"];
        /*
         "lsh": 6,
                 "citycode": "210500",
                 "cityname": "本溪市",
                 "residentId": "0414",
                 "supervisecode": "10162"
         */
        [self makeUI];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

    
    
}

- (void)makeUI {
    self.title = @"专家管理属地变更";
    self.mScrollView = [[UIScrollView alloc] init];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.mScrollView];
 
    self.scrollViewZgzs2 = [UIScrollView new];
    
    UILabel *lblYAddress = [UILabel new];
    UILabel *lblNAddress = [UILabel new];
    lblNAddress.text = @"请选择管理属地";
    
    lastY = k360Width(16);
    WS(weakSelf)
    
    lblYAddress.text = self.cityStr;
    [self initCellTitle:@"原专家管理属地：" byLabel:lblYAddress isAcc:NO withBlcok:nil];
    if (![self.dicDataGG isEqual:[NSNull null]]) {
        lblNAddress.text = self.dicDataGG[@"cityName"];
    }
        
    [self initCellTitle:@"拟申请变更后管理属地：" byLabel:lblNAddress isAcc:YES withBlcok:^{
        if (weakSelf.cityList) {
            NSMutableArray *cityStrArr = [NSMutableArray new];
            for (WY_CityModel *cityModel in weakSelf.cityList) {
                [cityStrArr addObject:cityModel.cityname];
            }
            [ActionSheetStringPicker showPickerWithTitle:@"请选择管理属地" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                self.selCityModel =  weakSelf.cityList[selectedIndex];
                lblNAddress.text = self.selCityModel.cityname;
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }
    }];
    lastY+=1;
    if (![self.dicDataGG isEqual:[NSNull null]]) {
        UILabel *lblStatus = [UILabel new];
        lblStatus.text = @"审核中";
//        6未通过   1原市级审核中  2新市级审核中  3省级审核中  4省级核验通过
        if (![self.dicDataGG[@"status"] isEqual:[NSNull null]]) {
            switch ([self.dicDataGG[@"status"] intValue]) {
                case 6:
                    {
                        lblStatus.text = @"审核拒绝";
                        [lblStatus setTextColor:HEXCOLOR(0x000000)];
                        [self.btnRegistered setHidden:NO];
                        [self.viewUserAgr setHidden:NO];
                    }
                    break;
                case 1:
                {
                    lblStatus.text = @"原市级审核中";
                    [lblStatus setTextColor:HEXCOLOR(0xFFA360)];
                    [self.btnRegistered setHidden:YES];
                    [self.viewUserAgr setHidden:YES];
                }
                break;
                case 2:
                {
                    lblStatus.text = @"新市级审核中";
                    [lblStatus setTextColor:HEXCOLOR(0xFFA360)];
                    [self.btnRegistered setHidden:YES];
                    [self.viewUserAgr setHidden:YES];
                }
                break;
                case 3:
                    {
                        lblStatus.text = @"省级审核中";
                        [lblStatus setTextColor:HEXCOLOR(0xFFA360)];
                        [self.btnRegistered setHidden:YES];
                        [self.viewUserAgr setHidden:YES];
                    }
                    break;
                case 4:
                    {
                        lblStatus.text = @"审核通过";
                        [lblStatus setTextColor:HEXCOLOR(0xFFFFFF)];
                        [self.btnRegistered setHidden:NO];
                        [self.viewUserAgr setHidden:NO];
                        
                    }
                    break;
                    
                default:
                    break;
            }
            [self initCellTitle:@"核验状态：" byLabel:lblStatus isAcc:NO withBlcok:nil];
        }
        
        self.qualificationEleId2 = self.dicDataGG[@"picUrl"];
    }
    
    [self.mScrollView addSubview:self.viewYzmLine1];
    
    
    UILabel *lblZMCL2 = [UILabel new];
    [lblZMCL2 setFrame:CGRectMake(k360Width(15), lastY + k360Width(5), kScreenWidth - k360Width(60+ 30 + 10), k360Width(50))];
    [lblZMCL2 setNumberOfLines:2];
    [lblZMCL2 setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop2Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attTop2Str setYy_font:WY_FONTMedium(14)];
    [attTop2Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop2Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传《辽宁省综合评标专家库专家管理属地变更申请表》（最多1张）："];
    [attTop2Str1 setYy_font:WY_FONTMedium(14)];
    [attTop2Str1 setYy_color:[UIColor blackColor]];
    [attTop2Str appendAttributedString:attTop2Str1];
    
    lblZMCL2.attributedText = attTop2Str;
    
    [self.mScrollView addSubview:lblZMCL2];
    lastY = lblZMCL2.bottom;
    
    UIButton *btnDownMuBan = [UIButton new];
    [btnDownMuBan setFrame:CGRectMake(lblZMCL2.right + k360Width(10), lblZMCL2.top + k360Width(12), k360Width(60), k360Width(26))];
    [btnDownMuBan rounded:k360Width(40/8)];
    [btnDownMuBan setBackgroundColor:MSTHEMEColor];
    [btnDownMuBan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDownMuBan.titleLabel setFont:WY_FONTMedium(12)];
    [btnDownMuBan setTitle:@"下载模板" forState:UIControlStateNormal];
    [btnDownMuBan addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"分享");
        
        NSURL *shareUrl = [NSURL URLWithString:@"https://www.capass.cn/Avatar/dqsqb.pdf"];
        NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
        NSArray*activityItems =@[shareUrl,@"辽宁省综合评标专家库专家管理属地调整变更申请表.pdf",dateImg];
        //
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
        
    }];
    [self.mScrollView addSubview:btnDownMuBan];


    
    [self.scrollViewZgzs2 setFrame:CGRectMake(k360Width(0), lblZMCL2.bottom  + k360Width(5), kScreenWidth - k360Width(0), k375Width(120))];
    if (self.qualificationEleId2 == nil || [self.qualificationEleId2 isEqual:[NSNull null]] || [self.qualificationEleId2 isEqualToString:@""]) {
        self.arrZgzs2 = [[NSMutableArray alloc] init];
    } else {
        self.arrZgzs2 = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId2 componentsSeparatedByString:@","]];
    }
    
    [self initZgzs2Imgs];
    [self.mScrollView addSubview:self.scrollViewZgzs2];
    lastY = self.scrollViewZgzs2.bottom;
    
    
    UILabel *lblTop2TsA = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), lastY, kScreenWidth - k375Width(24), k375Width(55))];
    [lblTop2TsA setNumberOfLines:4];
    [lblTop2TsA setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop2StrA = [[NSMutableAttributedString alloc] initWithString:@"单独维护专家管理属地信息时保存即可，不必提交专家信息审核，以免给您造成不必要的麻烦。"];
    [attTop2StrA setYy_font:WY_FONTMedium(14)];
    [attTop2StrA setYy_color:[UIColor redColor]];
    lblTop2TsA.attributedText = attTop2StrA;
    [lblTop2TsA setTextAlignment:NSTextAlignmentCenter];
    [lblTop2TsA sizeToFit];
    lblTop2TsA.height += 10;
     [self.mScrollView addSubview:lblTop2TsA];
    lastY = lblTop2TsA.bottom;
    
 
    [self.viewYzmLine1 setFrame:CGRectMake(k360Width(16), lastY + k360Width(2), kScreenWidth - k360Width(32), 1)];
    
    [self.selectedImg setFrame:CGRectMake(  k360Width(18), k360Width(2), kWidth(15*2), kWidth(15*2))];
    [self.selectedBtn setFrame:self.selectedImg.bounds];
    
    [self.viewUserAgr addSubview:self.selectedImg];
      [self.selectedImg addSubview:self.selectedBtn];
      [self.viewUserAgr addSubview:self.userAgrLab];
      [self.userAgrLab addSubview:self.userAgrBtn];
   
    
    // 用户协议
    [self.userAgrLab setFrame:CGRectMake(self.selectedImg.right + k360Width(5), 0, k360Width(200), k360Width(20))];
    [self.userAgrLab sizeToFit];
    // 用户协议按钮
    [self.userAgrBtn setFrame:self.userAgrLab.bounds];
    [self.viewUserAgr setFrame:CGRectMake(0, self.viewYzmLine1.bottom + k360Width(40), kScreenWidth, k360Width(30 + 16))];
    
    
    [self.mScrollView addSubview:self.viewUserAgr];
    
    
    [self.btnRegistered setFrame:CGRectMake(k360Width(16) , self.viewUserAgr.top + k360Width(50), kScreenWidth - k360Width(32), k360Width(44))];
    [self.btnRegistered addTarget:self action:@selector(btnRegisteredTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
     [self.btnRegistered setTitle:@"修改管理属地" forState:UIControlStateNormal];
    [self.mScrollView addSubview:self.btnRegistered];

    
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
    
    if ([titleStr isEqualToString:@"核验状态："]) {
        lblTitle.attributedText = attStr1;
    } else {
        lblTitle.attributedText = attStr;
    }
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
  
#pragma mark --懒加载
- (UIImageView *)selectedImg {
    if (!_selectedImg) {
        _selectedImg = [[UIImageView alloc] init];
        _selectedImg.image = [UIImage imageNamed:@"1012_椭圆形"];
        _selectedImg.userInteractionEnabled = YES;
    }
    return _selectedImg;
}

- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [[UIButton alloc] init];
        [_selectedBtn addTarget:self action:@selector(selectedBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        self.isSelected = NO;
    }
    return _selectedBtn;
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

- (UIButton *)btnRegistered {
    if (!_btnRegistered) {
        _btnRegistered = [[UIButton alloc] init];
        [_btnRegistered.layer setMasksToBounds:YES];
        [_btnRegistered.layer setCornerRadius:6];
        [_btnRegistered addTarget:self action:@selector(btnRegisteredTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRegistered setTitle:@"修改评标地区" forState:UIControlStateNormal];
        _btnRegistered.backgroundColor = MSTHEMEColor;
        [_btnRegistered setTitleColor:[UIColor whiteColor] forState:0];
 
    }
    return _btnRegistered;
}


 
 
      
#pragma mark - # 注册并登录按钮点击

//注册
- (void)btnRegisteredTouchUpInside:(UIButton *)sender {
//    [self loginHttp];
    
    if (self.selCityModel == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择拟申请变更后管理属地"];
        return;
    }
    if ([self.selCityModel.cityname isEqualToString:self.cityStr]) {
        [SVProgressHUD showErrorWithStatus:@"与原管理属地相同，无法提交"];
        return;
    }
    if (self.arrZgzs2.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传辽宁省综合评标专家库专家管理属地调整变更申请表"];
        return;
    }
    if (!self.isSelected) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并点击同意《专家信息修改说明》"];
           return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.selCityModel.cityname forKey:@"cityName"];
    [postDic setObject:self.selCityModel.residentId forKey:@"cityCode"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [postDic setObject:self.qualificationEleId2 forKey:@"picUrl"];
    [postDic setObject:self.aexpertId forKey:@"id"];
    [[MS_BasicDataController sharedInstance] postWithURL:zj_updateCity_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"修改成功");
        [SVProgressHUD showSuccessWithStatus:@"修改管理属地成功"];
        NSArray *pushVCAry=[self.navigationController viewControllers];
        UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-3];
        [self.navigationController popToViewController:popVC animated:YES];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
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

#pragma mark --协议按钮选中
- (void)selectedBtnTouchUpInside{
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    
    if (self.isSelected) {
        self.isSelected = NO;
         self.selectedImg.image = [UIImage imageNamed:@"1012_椭圆形"];
    }else{
        self.isSelected = YES;
         self.selectedImg.image = [UIImage imageNamed:@"1012_用户协议选中"];
    }
    
    [userdef setBool:self.isSelected forKey:@"XIEYI_isSelected"];
}


- (void)addZgzs2PicAction {
    //添加资格证书图片；
    picIndex = 2;
    if (self.arrZgzs2.count >=1) {
        UIAlertView *alertAction = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加一张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertAction show];
        return;
    }
//    if (self.addZgzsPicItemBlock) {
//        self.addZgzsPicItemBlock(self);
//    }
    
    NSLog(@"上传照片");
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
    
    UIAlertAction *alertAct4 = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

- (void)initZgzs2Imgs {
    [self.scrollViewZgzs2 removeAllSubviews];
    
    float lastX = k375Width(12);
     int i = 0;
    for (NSString *imgUrl in self.arrZgzs2) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewZgzs2 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnZgzs2ImgAction:) forControlEvents:UIControlEventTouchUpInside];

        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnZgzs2DelAction:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
    
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addZgzs2PicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewZgzs2 addSubview:tempBtnAdd];
    
    [self.scrollViewZgzs2 setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
}



- (void)btnZgzs2ImgAction:(UIButton *)btnSender {
    //打开图片；
//    if (self.selPicItemBlock) {
//        self.selPicItemBlock(btnSender.tag, self.arrZgzs);
//    }
    
    NSMutableArray *picModels = [NSMutableArray new];
    for (NSString *imgUrl in self.arrZgzs2) {
        IWPictureModel* picModel  = [IWPictureModel new];
        picModel.nsbmiddle_pic = imgUrl;
        picModel.nsoriginal_pic = imgUrl;
        [picModels addObject:picModel];
    }
    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
    indvController.mIWPictureModel = [picModels objectAtIndex:btnSender.tag];
    indvController.picArr = picModels;
    [self.navigationController pushViewController:indvController animated:YES];
    
}
 
- (void)btnZgzs2DelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrZgzs2 removeObjectAtIndex:btnSender.tag];
    self.qualificationEleId2 = [self.arrZgzs2 componentsJoinedByString:@","];

    [self initZgzs2Imgs];
}

/// 初始化资格证书Imgs
- (void)initZgzs2ImgsShow {
    [self.scrollViewZgzs2 removeAllSubviews];
    
    float lastX = k375Width(12);
     int i = 0;
    for (NSString *imgUrl in self.arrZgzs2) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewZgzs2 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnZgzs2ImgAction:) forControlEvents:UIControlEventTouchUpInside];

        [tempBtn.btnDel setHidden:YES];
        i++;
    }
     
    [self.scrollViewZgzs2 setContentSize:CGSizeMake(lastX + k375Width(20), 0)];
}


- (void)navRightAction {
    NSLog(@"操作记录");
    WY_OperationRecordViewController *tempController = [WY_OperationRecordViewController new];
    tempController.nsType = @"2";
    tempController.aexpertId = self.aexpertId;
    [self.navigationController pushViewController:tempController animated:YES];
}



- (UIView *)viewYzmLine1 {
    if (!_viewYzmLine1) {
        _viewYzmLine1 = [[UIView alloc] init];
        _viewYzmLine1.backgroundColor =MSColor(238, 238, 238);
    }
    return _viewYzmLine1;
}

- (UIView *)viewUserAgr {
    if (!_viewUserAgr) {
        _viewUserAgr = [[UIView alloc] init];
     }
    return _viewUserAgr;
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
//        if (picIndex == 1) {
//            [self.arrZgzs addObject:picUrl];
//            self.qualificationEleId = [self.arrZgzs componentsJoinedByString:@","];
//            [self initZgzsImgs];
//
//        } else {
            [self.arrZgzs2 addObject:picUrl];
            self.qualificationEleId2 = [self.arrZgzs2 componentsJoinedByString:@","];
            [self initZgzs2Imgs];
            
//        }
        
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
         [self uploadImage:image];
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
 
@end
