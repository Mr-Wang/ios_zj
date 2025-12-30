//
//  WY_AddPeoplelViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AddPeoplelViewController.h"
#import "WY_CompanyPersonModel.h"

@interface WY_AddPeoplelViewController () {
    int lastY;
    NSInteger selUserIndex;
    NSInteger selSexIndex;
}
@property (nonatomic, strong) UIScrollView *mScrollview;
@property (nonatomic, strong) UIButton *btnSelStudent;
@property (nonatomic, strong) UIButton *btnSelSex;
@property (nonatomic, strong) UITextField *txtName;
@property (nonatomic, strong) UITextField *txtIdNum;
@property (nonatomic, strong) UITextField *txtPhone;
@property (nonatomic, strong) UITextField *txtDanWei;
@property (nonatomic, strong) UITextField *txtJob;
@property (nonatomic, strong) UITextField *txtWexin;
@property (nonatomic, strong) UITextField *txtEmail;

@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSMutableArray *arrSelUser;
@end

@implementation WY_AddPeoplelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
     selUserIndex = -1;
    selSexIndex = -1;
    [self makeUI];
    [self bindView];
}
- (void)makeUI {
    self.title = @"学员信息";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *cancleButton = [[UIButton alloc] init];
    cancleButton.frame = CGRectMake(0, 0, 44, 44);
    [cancleButton setTitle:@"保存" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.mScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollview];
    lastY = 0;
    self.txtName = [UITextField new];
    self.txtName.placeholder = @"请输入姓名";
    
    
    self.txtIdNum = [UITextField new];
    
    self.txtPhone = [UITextField new];
    self.txtPhone.placeholder = @"请输入电话";
    self.txtPhone.keyboardType = UIKeyboardTypePhonePad;
    
    self.txtDanWei = [UITextField new];
    self.txtDanWei.keyboardType = UIKeyboardTypeDefault;

    self.txtJob = [UITextField new];
    self.txtJob.placeholder = @"请输入职务名称";
    
    self.txtWexin = [UITextField new];
    self.txtWexin.placeholder = @"请输入微信号";
    self.txtWexin.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.txtEmail = [UITextField new];
    self.txtEmail.placeholder = @"请输入电子邮箱";
    self.txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.btnSelStudent = [UIButton new];
    [self.btnSelStudent setTitle:@"请选择企业人员" forState:UIControlStateNormal];
    [self.btnSelStudent setTitleColor:HEXCOLOR(0xCCCCCC) forState:UIControlStateNormal];
    
    [self.btnSelStudent addTarget:self action:@selector(btnSelStudentAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnSelSex = [UIButton new];
    [self.btnSelSex setTitle:@"请选择性别" forState:UIControlStateNormal];
    [self.btnSelSex setTitleColor:HEXCOLOR(0xCCCCCC) forState:UIControlStateNormal];
    [self.btnSelSex addTarget:self action:@selector(showActionSheetSex) forControlEvents:UIControlEventTouchUpInside];
    
    //只能录入自己
    if (self.onlySelf) {
        [self addItem:@"姓      名：" withRightText:self.txtName withIsXing:YES];
        self.txtName.text = self.mUser.realname;
        [self.txtName setUserInteractionEnabled:NO];
        
        self.txtIdNum.text = self.mUser.idcardnum;
        self.txtIdNum.placeholder = @"请输入身份证号";
        [self.txtIdNum setUserInteractionEnabled:NO];
        
        self.txtDanWei.placeholder = @"请输入单位名称";//@"单位名称";
         [self.txtDanWei setUserInteractionEnabled:YES];
        self.txtPhone.text = self.mUser.LoginID;
        
    } else {
        //非企业用户
//        if (self.mUser.orgnum == nil || self.mUser.orgnum.length <= 0) {
            [self addItem:@"姓      名：" withRightText:self.txtName withIsXing:YES];
            self.txtIdNum.placeholder = @"请输入身份证号";
            [self.txtIdNum setUserInteractionEnabled:YES];
            self.txtDanWei.placeholder = @"请输入单位名称";//@"单位名称";
            [self.txtDanWei setUserInteractionEnabled:YES];
        
//        } else {
//            [self addItem:@"姓      名：" withRightBtnText:self.btnSelStudent withIsXing:YES];
//            self.txtIdNum.placeholder = @"请选择人员后自动填充";
//            [self.txtIdNum setUserInteractionEnabled:NO];
//            self.txtDanWei.text = self.mUser.DanWeiName;//@"单位名称";
//            [self.txtDanWei setUserInteractionEnabled:NO];
//        }

    }
    
    
    [self addItem:@"身份证号：" withRightText:self.txtIdNum withIsXing:YES];
    [self addItem:@"性      别：" withRightBtnText:self.btnSelSex withIsXing:YES];
    
    [self addItem:@"电      话：" withRightText:self.txtPhone withIsXing:YES];
    [self addItem:@"所在单位：" withRightText:self.txtDanWei withIsXing:NO];
    [self addItem:@"职务名称：" withRightText:self.txtJob withIsXing:NO];
    [self addItem:@"微 信 号 ：" withRightText:self.txtWexin withIsXing:NO];
    [self addItem:@"电子邮箱：" withRightText:self.txtEmail withIsXing:NO];
     
}
- (void)bindView {
    if (self.selModel != nil) {
        [self.btnSelStudent setTitle:self.selModel.UserName forState:UIControlStateNormal];
        [self.btnSelStudent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnSelStudent removeAllTargets];
        [self.btnSelStudent addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [SVProgressHUD showErrorWithStatus:@"不可修改学员，如需删除，请在列表中左滑操作"];
        }];
        
        self.txtName.text = self.selModel.UserName;
        
        // 1男  0女
        selSexIndex = [self.selModel.sex intValue];
        if (selSexIndex == 1) {
            [self.btnSelSex setTitle:@"男" forState:UIControlStateNormal];
        } else {
            [self.btnSelSex setTitle:@"女" forState:UIControlStateNormal];
        }
        [self.btnSelSex setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.txtIdNum.text = self.selModel.baomingidcard;
        self.txtPhone.text = self.selModel.Phone;
        self.txtJob.text = self.selModel.job;
        self.txtWexin.text = self.selModel.WeiXin;
        self.txtEmail.text = self.selModel.email;
        self.txtDanWei.text = self.selModel.DanWeiName;

    }
}

- (void)btnSelStudentAction{
    NSLog(@"选择企业人员");
    if (self.arrSelUser) {
        [self showActionSheetUsers];
    } else {
        
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        /*
         private String companyId;
         private int currentPage;
         private int pageItemNum;
         private String province;
         private String city;
         private String companyName;
         private String name;
         private String personCondition;
         private String registType;
         private String iszaijian;
         */
        [dicPost setObject:self.mUser.orgnum forKey:@"companyId"];
        [dicPost setObject:@"1" forKey:@"currentPage"];
        [dicPost setObject:@"999" forKey:@"pageItemNum"];
        
        
        [[MS_BasicDataController sharedInstance] postWithReturnCode:getCompanyPersonLists_HTTP params:nil jsonData:[dicPost mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
            if ([code integerValue] == 0 ) {
                self.arrSelUser = [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_CompanyPersonModel class] json:res[@"data"][@"data"]]];
                [self showActionSheetUsers];
            }else {
                [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
        
    }
}
- (void)showActionSheetUsers {
    NSMutableArray *rowsStr = [NSMutableArray new];
    for (WY_CompanyPersonModel *tepModel in self.arrSelUser) {
        [rowsStr addObject:tepModel.name];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"请选择企业人员" rows:rowsStr initialSelection:selUserIndex==-1?0:selUserIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selUserIndex = selectedIndex;
        [self.btnSelStudent setTitle:selectedValue forState:UIControlStateNormal];
        [self.btnSelStudent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        WY_CompanyPersonModel *tepModel = self.arrSelUser[selectedIndex];
        [self.txtIdNum setText:tepModel.idcard];
        if (tepModel.position.length > 0) {
            self.txtJob.text = tepModel.position;
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}
- (void)showActionSheetSex {
    [ActionSheetStringPicker showPickerWithTitle:@"请选择性别" rows:@[@"女",@"男"] initialSelection:selSexIndex==-1?0:selSexIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selSexIndex = selectedIndex;
        [self.btnSelSex setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnSelSex setTitle:selectedValue forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

- (void) addItem:(NSString *)leftStr withRightText:(UITextField *)txtRight withIsXing:(BOOL)isXing {
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(70), k360Width(44))];
    [lblLeft setFont:WY_FONTRegular(14)];
    [lblLeft setText:leftStr];
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
    
    [self.mScrollview addSubview:viewTemp];
    
    lastY = viewTemp.bottom;
}

- (void) addItem:(NSString *)leftStr withRightBtnText:(UIButton *)txtRight withIsXing:(BOOL)isXing {
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(70), k360Width(44))];
    [lblLeft setFont:WY_FONTRegular(14)];
    [lblLeft setText:leftStr];
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
    
    if ([txtRight isEqual:self.btnSelSex]) {
        UIImageView *imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(33), k360Width(34/2), k360Width(7), k360Width(10))];
        [imgAcc setImage:[UIImage imageNamed:@"0210_qianjin"]];
        //        imgAcc.centerY = viewTemp.centerY;
        [viewTemp addSubview:imgAcc];
    }
    
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(44) - 1,kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [viewTemp addSubview:imgLine];
    
    [self.mScrollview addSubview:viewTemp];
    lastY = viewTemp.bottom;
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)navRightAction {
    if ([self isVerification]) {
        if (self.selModel == nil) {
            self.selModel = [WY_TraEnrolPersonModel new];
        }
        
        //如果只能选择自己=
        if (self.onlySelf) {
            self.selModel.UserName = self.txtName.text;

        } else {
            if (self.mUser.orgnum == nil || self.mUser.orgnum.length <= 0) {
                self.selModel.UserName = self.txtName.text;

            } else {
                self.selModel.UserName = self.btnSelStudent.currentTitle;

            }
        }
        if (self.mUser.orgnum == nil || self.mUser.orgnum.length <= 0) {
            self.selModel.isruku = @"否";
        } else {
            self.selModel.isruku = @"是";
        }
        self.selModel.baomingidcard = self.txtIdNum.text;
        // 1男 2 女
        if (selSexIndex == 0) {
            self.selModel.sex = @"2";
        } else {
            self.selModel.sex = @"1";
        }
        self.selModel.Phone = self.txtPhone.text;
        self.selModel.DanWeiName = self.txtDanWei.text;
        
        self.selModel.job = self.txtJob.text;
        self.selModel.WeiXin = self.txtWexin.text;
        self.selModel.email = self.txtEmail.text;
 
        if (self.isAddOrUpdate == 1) {
            if ([self addSuccessBlock]) {
                self.addSuccessBlock(self.selModel);
            }
        } else  if (self.isAddOrUpdate == 2) {
            if ([self updateSuccessBlock]) {
                self.updateSuccessBlock(self.selModel);
            }
        } 
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (BOOL)isVerification {
    
    //非企业用户
//    if (self.mUser.orgnum == nil || self.mUser.orgnum.length <= 0 || self.onlySelf) {
    if (self.onlySelf) {
        if (self.txtName.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:self.txtName.placeholder];
            [self.txtName becomeFirstResponder];
            return NO;
        }
        if (self.txtIdNum.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:self.txtIdNum.placeholder];
            [self.txtIdNum becomeFirstResponder];
            return NO;
        }
//        if (self.txtDanWei.text.length <= 0) {
//            [SVProgressHUD showErrorWithStatus:self.txtDanWei.placeholder];
//            [self.txtDanWei becomeFirstResponder];
//            return NO;
//        }
    } else {
        if (selUserIndex == -1 && self.isAddOrUpdate == 1) {
               [SVProgressHUD showErrorWithStatus:@"请选择企业人员"];
               return NO;
           }
    }
    
    if (selSexIndex == -1 && self.isAddOrUpdate == 1) {
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return NO;
    }
    if (self.txtPhone.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtPhone.placeholder];
        [self.txtPhone becomeFirstResponder];
        return NO;
    }
    
    if (![GlobalConfig isValidateMobile:self.txtPhone.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确电话号"];
        [self.txtPhone becomeFirstResponder];
        return NO;
    }
    return YES;
}
@end
