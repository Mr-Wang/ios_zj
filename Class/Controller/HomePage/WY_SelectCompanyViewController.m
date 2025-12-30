//
//  WY_SelectCompanyViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/3.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SelectCompanyViewController.h"
#import "WY_CompanyModel.h"
#import "WY_IDCarSettingViewController.h"
@interface WY_SelectCompanyViewController ()

@property (nonatomic, strong) UIScrollView *mScrollView;
//注册按钮
@property (nonatomic, strong) UIButton *btnRegistered;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) WY_CompanyModel *mSelWY_CompanyModel;
@property (nonatomic, strong) NSArray *arrDataSource;
@end

@implementation WY_SelectCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

      [self makeUI];
    [self bindView];
    }
    -(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        self.navigationController.navigationBar.hidden = YES;
    }

    -(void)viewWillDisappear:(BOOL)animated{
        [super viewWillDisappear:animated];
        self.navigationController.navigationBar.hidden = NO;
    }

    #pragma mark --绘制页面；
    - (void)makeUI {
        int topY = MH_APPLICATION_STATUS_BAR_HEIGHT;

        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(4), k360Width(16), k360Width(44), k360Width(44))];
           [btnBack setImage:[UIImage imageNamed:@"1012_返回"] forState:UIControlStateNormal];
           [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
           [self.view addSubview:btnBack];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(k360Width(30), -topY + k360Width(101), k360Width(140), k360Width(28));
        label.text = @"请选择公司";
        label.font = WY_FONTMedium(20);
        label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.87/1.0];
        [self.view addSubview:label];
        
        self.mScrollView = [[UIScrollView alloc] init];
        [self.mScrollView setFrame:CGRectMake(0, label.bottom, kScreenWidth, kScreenHeight - label.bottom - 46)];
        [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.mScrollView];
        
        [self.btnRegistered setFrame:CGRectMake(k360Width(30), kScreenHeight - k360Width(86), kScreenWidth - k360Width(60), k360Width(46))];
        [self.view addSubview:self.btnRegistered];

    }

- (void)bindView {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"cardID"];
    [postDic setObject:@"1" forKey:@"currentPage"];
    [postDic setObject:@"100" forKey:@"pageItemNum"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:getCompanyListByID_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
           MSLog(@"查询成功");
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_CompanyModel class] json:successCallBack[@"data"]];
        if (self.arrDataSource.count == 0) {
             UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"1、请您再次检查身份证输入是否正确。\n2、请您再次确认您单位或人员是否在诚信库中。\n3、请您再次确认网联平台与信息管理中统一社会信用代码是否一致。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self btnBackAction];
                
             }];
            [alert addAction:ok];
            UIAlertAction * okA = [UIAlertAction actionWithTitle:@"上一步" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           
                           [self goIDCarSetPage];
                           
                        }];
                       [alert addAction:okA];
                       
             [self presentViewController:alert animated:YES completion:nil];

            return ;
        }
        int lastY = k360Width(64);
        int i = 0;
        for (WY_CompanyModel *cModel in self.arrDataSource) {
            UIButton *btnSel = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), lastY, kScreenWidth - k360Width(32), k360Width(30))];
             [btnSel setImage:[UIImage imageNamed:@"icon_checkbox_s"] forState:UIControlStateNormal];
            [btnSel setImage:[UIImage imageNamed:@"icon_checkbox_lxx"] forState:UIControlStateSelected];
            [btnSel setTitleEdgeInsets:UIEdgeInsetsMake(0, k360Width(10), 0, 0)];
            [btnSel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnSel.titleLabel setFont:WY_FONTMedium(14)];
//               [btnSel.titleLabel setNumberOfLines:0];
            [btnSel addTarget:self action:@selector(btnSelAction:) forControlEvents:UIControlEventTouchUpInside];
               [btnSel.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
//               [btnSel.titleLabel setAdjustsFontSizeToFitWidth:YES];
//               [btnSel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btnSel.tag = i;
            [btnSel setTitle:cModel.companyName forState:UIControlStateNormal];
            
            [self.mScrollView addSubview:btnSel];
            lastY = btnSel.bottom + k360Width(10);
            i ++;
        }
    } failure:^(NSString *failureCallBack) {
           [SVProgressHUD showErrorWithStatus:failureCallBack];
       } ErrorInfo:^(NSError *error) {
           [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
       }];
}
-(void)btnSelAction:(UIButton * )btnSender {
    for (UIButton *btnItem in self.mScrollView.subviews) {
        if ([btnItem isKindOfClass:[UIButton class]]) {
            btnItem.selected = NO;
        }
    }
    btnSender.selected = YES;
   self.mSelWY_CompanyModel =  [self.arrDataSource objectAtIndex:btnSender.tag];
    
    
}
- (UIButton *)btnRegistered {
    if (!_btnRegistered) {
        _btnRegistered = [[UIButton alloc] init];
        [_btnRegistered.layer setMasksToBounds:YES];
        [_btnRegistered.layer setCornerRadius:6];
        [_btnRegistered addTarget:self action:@selector(btnRegisteredTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRegistered setTitle:@"下一步" forState:UIControlStateNormal];
        _btnRegistered.backgroundColor = MSTHEMEColor;
        [_btnRegistered setTitleColor:[UIColor whiteColor] forState:0];
 
    }
    return _btnRegistered;
}


- (void) btnRegisteredTouchUpInside:(UIButton *)btnSender {
   
    if (self.mSelWY_CompanyModel == nil) {
        [SVProgressHUD showWithStatus:@"您的单位已在诚信库中，请您正确选择您所属的企业，感谢您的使用和支持。"];
        return;
    }
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.LoginID forKey:@"loginId"];
    [dicPost setObject:self.mSelWY_CompanyModel.unitorgnum forKey:@"orgnum"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:updateDanWeiInfo_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"设置成功");
        self.mUser.orgnum = self.mSelWY_CompanyModel.unitorgnum;
        self.mUser.DanWeiName = self.mSelWY_CompanyModel.companyName;
        [MS_BasicDataController sharedInstance].user = self.mUser;
        [self btnBackAction];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    

    
}

- (void)goIDCarSetPage{
    //回到设置身份证页
    
    UIViewController *target = nil;

     for (UIViewController * controller in self.navigationController.viewControllers) { //遍历

         if ([controller isKindOfClass:[WY_IDCarSettingViewController class]]) { //这里判断是否为你想要跳转的页面
             target = controller;
             break;
         }
     }
     if (target) {
         [self.navigationController popToViewController:target animated:YES]; //跳转
     } else {
         WY_IDCarSettingViewController *tempController = [WY_IDCarSettingViewController new];
         [self.navigationController pushViewController:tempController animated:YES];
     }
}

- (void)btnBackAction {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES]; //跳转

//    //回到主页；
//    [self.navigationController popViewControllerAnimated:YES];
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
