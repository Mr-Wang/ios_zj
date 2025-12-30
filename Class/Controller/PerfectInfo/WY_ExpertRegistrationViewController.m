//
//  WY_ExpertRegistrationViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ExpertRegistrationViewController.h"
#import "WY_PerfectInfoViewController.h"
#import "WY_ExpertMessageModel.h"
#import "ActionSheetStringPicker.h"
#import "WY_CityModel.h"
#import "WY_SelectJobTitle1ViewController.h"
#import "ActionSheetStringPicker.h"
#import "SLCustomActivity.h"
#import "WY_ExpertStatusViewController.h"

@interface WY_ExpertRegistrationViewController ()
{
    int lastY;
    UIView *viewJobTitle;
    UIView *viewZdhb;
    UIView *viewYDW;
    
    NSString *selCityCode;
    NSString *selCityName;
}
@property (nonatomic , strong) UIView *viewTop;
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic , strong) UITextField *lblzjSex;
@property (nonatomic , strong) UILabel *lblAddress;
@property (nonatomic , strong) UILabel *lblstyleId;
@property (nonatomic , strong) UITextField *txtzjName;
@property (nonatomic , strong) UITextField *txtzjIDCard;
@property (nonatomic , strong) UITextField *txtzjPhone;
@property (nonatomic , strong) UITextField *txtzjBankNum;
 
@property (nonatomic , strong) WY_ExpertMessageModel *mWY_ExpertMessageModel;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic ,strong) NSMutableArray *arrCityByLN;
@end

@implementation WY_ExpertRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请专家资格";
    selCityCode = @"-1";
    [self makeUI];
    [self dataBind];
    [self initData];
    
}

- (void)initData {
 
    [[MS_BasicDataController sharedInstance] getWithReturnCode:jg_regionCityByLN_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 200 && res) {
            self.arrCityByLN =res[@"data"];
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
}
- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF4F5F9)];
     
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"确认申请" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];

}
- (void)viewDidAppear:(BOOL)animated {
}
- (void)viewDidDisappear:(BOOL)animated{
}
- (void)dealloc {
}
- (void)dataBind {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [self bindView];
 }
- (void)bindView {
    [self.mScrollView removeAllSubviews];
    self.txtzjName = [UITextField new];
    self.txtzjIDCard = [UITextField new];
    self.txtzjPhone = [UITextField new];
    self.txtzjBankNum = [UITextField new];
    self.lblzjSex = [UITextField new];
    self.lblAddress = [UILabel new];
    self.lblstyleId = [UILabel new];
 
    self.lblzjSex.text = @"请选择性别";
 
    self.lblAddress.text = @"请选择专家管理属地";
    self.lblstyleId.text = @"请选择推荐来源";
    
    [self initCellTitle:@"专家姓名" byUITextField:self.txtzjName];
    
//     [self initCellTitle:@"专家性别" byUITextField:self.lblzjSex];
     
    
    [self initCellTitle:@"证件号码" byUITextField:self.txtzjIDCard];
    [self initCellTitle:@"手机号" byUITextField:self.txtzjPhone];
 
    [self initCellTitle:@"专家管理属地" byLabel:self.lblAddress isAcc:YES withBlcok:^{
        NSLog(@"选择专家管理属地");
        
        NSMutableArray *cityStrArr = [NSMutableArray new];
        NSMutableArray *cityArr = [NSMutableArray new];
         for (NSDictionary *cityDic in self.arrCityByLN) {
             if (3227 == [[cityDic objectForKey:@"id"] intValue] || 3225 == [[cityDic objectForKey:@"id"] intValue]) {
                 continue;
             }
            [cityStrArr addObject:[cityDic objectForKey:@"name"]];
             [cityArr addObject:cityDic];
        }
        self.arrCityByLN = cityArr;
        
        [ActionSheetStringPicker showPickerWithTitle:@"请选择城市" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.lblAddress.text = selectedValue;
             selCityName = selectedValue;
            selCityCode = self.arrCityByLN[selectedIndex][@"code"];
 
        } cancelBlock:^(ActionSheetStringPicker *picker) {
 
         } origin:self.view];

        
//        if (weakSelf.mWY_ExpertMessageModel.city.length <= 0) {
//            if (weakSelf.mWY_ExpertMessageModel.cityList) {
//                NSMutableArray *cityStrArr = [NSMutableArray new];
//                for (WY_CityModel *cityModel in weakSelf.mWY_ExpertMessageModel.cityList) {
//                    [cityStrArr addObject:cityModel.cityname];
//                }
//
//                [ActionSheetStringPicker showPickerWithTitle:@"请选择专家管理属地" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//                     WY_CityModel *cityModel =  weakSelf.mWY_ExpertMessageModel.cityList[selectedIndex];
//                    weakSelf.mWY_ExpertMessageModel.city = cityModel.cityname;
//                    weakSelf.mWY_ExpertMessageModel.cityCode = cityModel.residentId;
//                    self.lblAddress.text = selectedValue;
//                } cancelBlock:^(ActionSheetStringPicker *picker) {
//
//                } origin:self.view];
//            }
//        } else {
//            [SVProgressHUD showErrorWithStatus:@"地区不得随意修改"];
//        }
    }];
    
    self.txtzjName.text = self.mUser.realname;
    self.txtzjIDCard.text = self.mUser.idcardnum;
    self.txtzjPhone.text = self.mUser.LoginID;
  
    [self.txtzjName setEnabled:NO];
    [self.txtzjIDCard setEnabled:NO];
     [self.txtzjName setTextColor:HEXCOLOR(0xd8d8d8)];
    [self.txtzjIDCard setTextColor:HEXCOLOR(0xd8d8d8)];
    [self.lblzjSex setTextColor:HEXCOLOR(0xd8d8d8)];
    
    [self.txtzjName setFont:WY_FONT375Medium(14)];
    [self.txtzjIDCard setFont:WY_FONT375Medium(14)];
    [self.lblzjSex setFont:WY_FONT375Medium(14)];
    
    NSInteger zjsex =  [self genderOfIDNumber:self.mUser.idcardnum];
    if (zjsex == 2) {
        //女
        self.lblzjSex.text = @"女";

    } else if (zjsex == 1) {
        //男
        self.lblzjSex.text = @"男";
    } else {
        self.lblzjSex.text = @"未知";
    }

    
    [self.txtzjName setUserInteractionEnabled:NO];
    [self.txtzjIDCard setUserInteractionEnabled:NO];
    [self.lblzjSex setUserInteractionEnabled:NO];
 
//    self.arrjobTitleList =  [[NSMutableArray alloc] initWithArray:self.mWY_ExpertMessageModel.jobTitleList];
//    [self initviewJobTitle];
//
//    self.arrZdhb = [[NSMutableArray alloc] initWithArray:self.mWY_ExpertMessageModel.voidCompany];
//
//    [self initviewZdhb];
//
//
//    viewYDW = [[UIView alloc] initWithFrame:CGRectMake(0, viewZdhb.bottom + k375Width(10), kScreenWidth, k375Width(44))];
//    [self.mScrollView addSubview:viewYDW];
//    self.arrYdw = [[NSMutableArray alloc] initWithArray:self.mWY_ExpertMessageModel.originalCompany];
//    [self initviewYDW];
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
    if (self.txtzjPhone.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtzjPhone.placeholder];
        [self.txtzjPhone becomeFirstResponder];
        return;
    }
    
    if ([selCityCode isEqualToString:@"-1"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择地区"];
         return;
        
    }
    /*
     String name,
                                        @RequestParam String idcard,
                                        @RequestParam String phone,
                                        @RequestParam String regionCode
     */
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.txtzjName.text forKey:@"name"];
    [dicPost setObject:self.txtzjIDCard.text forKey:@"idcard"];
    [dicPost setObject:self.txtzjPhone.text forKey:@"phone"];
    [dicPost setObject:selCityCode forKey:@"regionCode"];
     
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_expertTouristChangeExpert_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            [self.view makeToast:res[@"msg"]];
            WY_ExpertStatusViewController *tempController = [WY_ExpertStatusViewController new];
            [self jumpVC:tempController];
            
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];

    
}
/// 跳转下一页此页消失
/// @param vc 下一页
-(void)jumpVC:(UIViewController *)vc{
    NSArray *vcs = self.navigationController.viewControllers;
    NSMutableArray *newVCS = [NSMutableArray array];
    if ([vcs count] > 0) {

        for (int i=0; i < [vcs count]-1; i++) {

            [newVCS addObject:[vcs objectAtIndex:i]];

        }

    }
    [newVCS addObject:vc];
    [self.navigationController setViewControllers:newVCS animated:YES];

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
