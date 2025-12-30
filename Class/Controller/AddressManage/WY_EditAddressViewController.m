//
//  WY_EditAddressViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/10.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_EditAddressViewController.h"
#import "WY_PickerArea.h"
#import "WY_AddressManageModel.h"

@interface WY_EditAddressViewController ()<WYPickerAreaDelegate> {
    float lastY;
    NSDictionary *mprovince;
    NSDictionary *mcity;
    NSDictionary *marea;
}
@property (nonatomic ,strong) UIScrollView *mScrollView;
@property (nonatomic ,strong) UIView *viewBody;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic ,strong) UITextField *txtUser;
@property (nonatomic ,strong) UITextField *txtPhone;
@property (nonatomic ,strong) UIButton *btnSelCity;
@property (nonatomic ,strong) IQTextView *txtAddress;

@property (nonatomic ,strong) UISwitch *swDef;

@end

@implementation WY_EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
    if (self.isEdit) {
        [self bindView];
        
        UIButton *cancleButton = [[UIButton alloc] init];
        cancleButton.frame = CGRectMake(0, 0, 44, 44);
        [cancleButton setTitle:@"删除" forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
        self.navigationItem.rightBarButtonItem = rightItem;

    }
}

- (void)makeUI {
     [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
     [self.view addSubview:self.mScrollView];
 
    lastY = 0;
    
    self.txtUser = [UITextField new];
    self.txtPhone = [UITextField new];
    self.btnSelCity = [UIButton new];
    self.txtAddress = [IQTextView new];
    self.swDef = [UISwitch new];
    self.swDef.onTintColor = MSTHEMEColor;
    
    self.txtPhone.keyboardType = UIKeyboardTypePhonePad;
    
    
    UIImageView *imgLine1 = [UIImageView new];
    UIImageView *imgLine2 = [UIImageView new];
    UIImageView *imgLine3 = [UIImageView new];
    UIImageView *imgLine4 = [UIImageView new];
    UIImageView *imgLine5 = [UIImageView new];
 
    [self.txtUser setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(44))];
    [self.txtPhone setFrame:CGRectMake(0, self.txtUser.bottom, kScreenWidth, k360Width(44))];
    [self.btnSelCity setFrame:CGRectMake(k360Width(16), self.txtPhone.bottom, kScreenWidth, k360Width(44))];
    [self.txtAddress setFrame:CGRectMake(k360Width(16), self.btnSelCity.bottom, kScreenWidth -k360Width(32) , k360Width(80))];
    UILabel *lblAddressTS = [UILabel new];
    [lblAddressTS setFrame:CGRectMake(k360Width(16), self.txtAddress.bottom, kScreenWidth - k360Width(32), k360Width(30))];

    [self.swDef setFrame:CGRectMake(kScreenWidth - k360Width(70), lblAddressTS.bottom, k360Width(80), k360Width(44))];
    
    [self.txtUser setPlaceholder:@"收货人"];
    [self.txtPhone setPlaceholder:@"请输入手机号码"];
    [self.btnSelCity setTitle:@"所在地区" forState:UIControlStateNormal];
    [self.btnSelCity.titleLabel setFont:WY_FONTRegular(14)];
    [self.btnSelCity setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnSelCity setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    [self.btnSelCity addTarget:self action:@selector(btnSelCityAction) forControlEvents:UIControlEventTouchUpInside];
    [self.txtAddress setPlaceholder:@"详细地市：如道路、门牌号、小区、楼栋号、单元室等"];
    [self.txtAddress setFont:WY_FONTRegular(14)];
    
    
    lblAddressTS.text = @"不需要重复填写省市区";
    [lblAddressTS setFont:WY_FONTRegular(12)];
    [lblAddressTS setTextColor:[UIColor redColor]];

    
    UILabel *lblSetDef = [UILabel new];
    [lblSetDef setFrame:CGRectMake(k360Width(16), lblAddressTS.bottom, kScreenWidth - k360Width(32), k360Width(44))];
    lblSetDef.text = @"设置为默认地址";
    [lblSetDef setFont:WY_FONTRegular(14)];
    self.swDef.centerY = lblSetDef.centerY;
    
    [self.mScrollView addSubview:self.txtUser];
    [self.mScrollView addSubview:self.txtPhone];
    [self.mScrollView addSubview:self.btnSelCity];
    [self.mScrollView addSubview:self.txtAddress];
    [self.mScrollView addSubview:lblAddressTS];
    [self.mScrollView addSubview:lblSetDef];
    [self.mScrollView addSubview:self.swDef];
    
                 
    UIView *lv1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(16), k360Width(16))];
    self.txtUser.leftViewMode = UITextFieldViewModeAlways;
    self.txtUser.leftView = lv1;

    UIView *lv2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(16), k360Width(16))];
    self.txtPhone.leftViewMode = UITextFieldViewModeAlways;
    self.txtPhone.leftView = lv2;
 
    
    [imgLine1 setBackgroundColor:APPLineColor];
    [imgLine2 setBackgroundColor:APPLineColor];
    [imgLine3 setBackgroundColor:APPLineColor];
    [imgLine4 setBackgroundColor:APPLineColor];
    [imgLine5 setBackgroundColor:APPLineColor];
 
    [imgLine1 setFrame:CGRectMake(0, self.txtUser.bottom, kScreenWidth, 1)];
    [imgLine2 setFrame:CGRectMake(0, self.txtPhone.bottom, kScreenWidth, 1)];
    [imgLine3 setFrame:CGRectMake(0, self.btnSelCity.bottom, kScreenWidth, 1)];
    [imgLine4 setFrame:CGRectMake(0, lblAddressTS.bottom, kScreenWidth, 1)];
    [imgLine5 setFrame:CGRectMake(0, lblSetDef.bottom, kScreenWidth, 1)];
 
    [self.mScrollView addSubview:imgLine1];
    [self.mScrollView addSubview:imgLine2];
    [self.mScrollView addSubview:imgLine3];
    [self.mScrollView addSubview:imgLine4];
    [self.mScrollView addSubview:imgLine5];
    
    lastY = imgLine5.bottom;
    if (lastY < MSScreenH - JCNew64) {
        self.mScrollView.height = lastY;
    }
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, lastY)];
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), kScreenHeight - k360Width(50) - JCNew64 - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(30), k360Width(40))];
    [btnLeft rounded:k360Width(40/8)];
    [btnLeft setBackgroundColor:MSTHEMEColor];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.isEdit) {
        [btnLeft setTitle:@"保存地址" forState:UIControlStateNormal];
    } else {
        [btnLeft setTitle:@"添加地址" forState:UIControlStateNormal];
    }
     [self.view addSubview:btnLeft];


}
- (void)btnSelCityAction {
    NSLog(@"点击了选择地址按钮");
    [[IQKeyboardManager sharedManager] resignFirstResponder];

    WY_PickerArea *pickerSingle = [[WY_PickerArea alloc]init];
     [pickerSingle setTitle:@"请选择地区"];
     [pickerSingle setContentMode:STPickerContentModeBottom];
    [pickerSingle setSaveHistory:YES];
    [pickerSingle setDelegate:self];
    [pickerSingle show];
}

- (void)pickerArea:(WY_PickerArea *)pickerArea province:(nonnull NSDictionary *)province city:(nonnull NSDictionary *)city area:(nonnull NSDictionary *)area {
    NSLog(@"%@",city);
    mcity = city;
    marea = area;
    mprovince = province;
    [self.btnSelCity setTitle:[NSString stringWithFormat:@"%@ %@ %@",province[@"text"],city[@"text"],area[@"text"]] forState:UIControlStateNormal];
    [self.btnSelCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (void)bindView {
    self.txtAddress.text = self.mEditModel.Address;
    self.txtUser.text = self.mEditModel.UserName;
    self.txtPhone.text = self.mEditModel.Mobile;
    [self.btnSelCity setTitle:[NSString stringWithFormat:@"%@ %@ %@",self.mEditModel.province,self.mEditModel.city,self.mEditModel.district] forState:UIControlStateNormal];
    [self.btnSelCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([self.mEditModel.IsDefault isEqualToString:@"1"]) {
        [self.swDef setOn:YES];
    } else {
        [self.swDef setOn:NO];
    }
 
}

- (void)navRightAction{
    NSLog(@"点击了删除按钮");
            
    UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"您确定要删除该地址吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [tempAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [tempAlert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self delAddressPost];
    }]];
    [self presentViewController:tempAlert animated:YES completion:nil];

    
}
- (void)delAddressPost {
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:deleteAddress_HTTP params:nil jsonData:[self.mEditModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
                    [SVProgressHUD showSuccessWithStatus:res[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];


}
- (void)btnLeftAction {
    NSLog(@"点击了保存按钮");
    [[IQKeyboardManager sharedManager] resignFirstResponder];

    if (self.txtUser.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtUser.placeholder];
        return;
    }
    if (self.txtPhone.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtPhone.placeholder];
        return;
    }
    if (![GlobalConfig isValidateMobile:self.txtPhone.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号码"];
        return;
    }
    if (self.txtAddress.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtAddress.placeholder];
        return;
    }
   
    WY_AddressManageModel *tempAddress = [WY_AddressManageModel new];

    NSString *urlStr;
    if (self.isEdit) {
        //编辑
        urlStr = updateUserAddress_HTTP;
        tempAddress.RowGuid = self.mEditModel.RowGuid;
        tempAddress.CityCode = self.mEditModel.CityCode;
        tempAddress.postCode = self.mEditModel.postCode;
        tempAddress.TownCode = self.mEditModel.TownCode;
        tempAddress.CountryCode = self.mEditModel.CountryCode;
        tempAddress.ProvinceCode = self.mEditModel.ProvinceCode;
    } else {
        //添加
        if (mprovince == nil) {
               [SVProgressHUD showErrorWithStatus:@"请选择地址"];
               return;
           }
        urlStr = addUserAddress_HTTP;
    }
    if (mprovince != nil) {
        tempAddress.city = mcity[@"text"];
        tempAddress.province = mprovince[@"text"];
        tempAddress.district = marea[@"text"];
        
        tempAddress.CityCode = mcity[@"id"];
        tempAddress.ProvinceCode = mprovince[@"id"];
        tempAddress.CountryCode = marea[@"id"];

//        tempAddress.TownCode = self.mEditModel.TownCode;
//        tempAddress.CountryCode = self.mEditModel.CountryCode;

    }
    tempAddress.Address = self.txtAddress.text;
    tempAddress.CGRUserGuid = self.mUser.UserGuid;
    tempAddress.UserName = self.txtUser.text;
    tempAddress.Mobile = self.txtPhone.text;
    
    if (self.swDef.on) {
        tempAddress.IsDefault = @"1";
    } else {
        tempAddress.IsDefault = @"0";
    }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:urlStr params:nil jsonData:[tempAddress toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
                    [SVProgressHUD showSuccessWithStatus:res[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
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

@end
