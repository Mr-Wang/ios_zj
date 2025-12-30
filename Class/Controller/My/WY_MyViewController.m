//
//  WY_MyViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/9/3.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_MyViewController.h"
#import "WY_LoginViewController.h"
#import "WY_MyInfoTableViewCell.h"
#import "WY_MyOtherTableViewCell.h"
//#import "WY_MessageListViewController.h"
#import "WY_UpdatePwdViewController.h"
#import "WY_MyCourseListViewController.h"
#import "WY_MyInvoiceListViewController.h"
#import "WY_AddressManageViewController.h"
#import "WY_MyCollectMainViewController.h"
#import "WY_SettingViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_MyExamViewController.h"
#import "WY_ZJPushMsgViewController.h"
#import "WY_UserInfoViewController.h"
#import "WY_OrgUserPointsViewController.h"
#import "WY_TestQuestionsMainViewController.h"
#import "WY_MyBalanceViewController.h"
#import "WY_MyVipTableViewCell.h"
#import "WY_OpenVipViewController.h"
#import "WY_PerfectInfoViewController.h"
#import "WY_AddBankCardViewController.h"
#import "WY_MyCreditViewController.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "WY_ExpertStatusViewController.h"
#import "WY_ShowPdfViewController.h"
#import "LDImagePicker.h"
#import <AVFoundation/AVFoundation.h>


#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "WY_CAOrderListViewController.h"
#import "WY_CAOrderMainViewController.h"
#import "WY_DocListViewController.h"

#import "WY_ManageViewController.h"
#import "CustomAlertView.h"
#import "WY_NationalNodesViewController.h"

@interface WY_MyViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    WY_MyInfoTableViewCell *cellHeader;
    UIButton *btnMessage;
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
    //管理权限  - 1-全部权限、2-仅查看咨询投诉、3-仅查看抽取状态
    int administrativePermissions;
 }
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *zhuanYeArr;
@property (nonatomic , strong) NSArray *objectArr;
@property (nonatomic , strong) NSArray *objectImgArr;

@property (nonatomic , strong) NSArray *objectArr1;
@property (nonatomic , strong) NSArray *objectImgArr1;

@property (nonatomic , strong) NSArray *objectArr2;
@property (nonatomic , strong) NSArray *objectImgArr2;

@property (nonatomic , strong) NSArray *objectArr3;
@property (nonatomic , strong) NSArray *objectImgArr3;


@property (nonatomic, strong) UIScrollView *mScrollView;

@property (nonatomic, strong) WY_UserModel *mUser;


///身份证OCR结果
@property (nonatomic, strong) NSMutableDictionary *dicIDCard;
@property (nonatomic, strong) NSString *isIdCardSuccess;
//是否是注册后补全
@property (nonatomic, strong) NSString *isBuQuan;

@property (nonatomic, strong) NSLayoutConstraint *height;
@property (nonatomic) int selItemIndex;
@property (nonatomic) int isRenewalFlag;
@end

@implementation WY_MyViewController

- (void)getIntegralInfo {
    self.isRenewalFlag = 0;
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:tempController animated:YES completion:nil];
        return;
    }
    
    self.mUser = [MS_BasicDataController sharedInstance].user;
    [self geetUserInfo];
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.mUser.UserGuid forKey:@"userGuid"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_expertGetExpertTags_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            self.zhuanYeArr = [[NSMutableArray alloc] initWithArray:res[@"data"]];
        }
        NSMutableDictionary *postDic1 = [NSMutableDictionary new];
        [postDic1 setObject:self.mUser.UserGuid forKey:@"userGuid"];
        [postDic1 setObject:self.mUser.idcardnum forKey:@"idCard"];
        [[MS_BasicDataController sharedInstance] postWithReturnCode:expert_getExpertIdentity_HTTP params:postDic1 jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            if ([code integerValue] == 0 ) {
                if (((NSArray *)res[@"data"]).count > 0) {
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:res[@"data"]];
                    for (NSMutableDictionary *dicItem in arr) {
                        if ([dicItem[@"source"] intValue] == 1) {
                            //判断- 如果是续聘专家 - 并且不是续聘完成状态-显示（待续聘），否则不显示
                            if ([dicItem[@"renewalFlag"] intValue] == 1 && [dicItem[@"renewalStatus"] intValue] != 3) {
                                self.isRenewalFlag = 1;
                            } else {
                                self.isRenewalFlag = 0;
                            }
                            break;
                        }
                    }
                }
                
            }
            [self bindView];
        } failure:^(NSError *error) {
            [self bindView];
        }];
        
        
    } failure:^(NSError *error) {
        self.zhuanYeArr = [[NSMutableArray alloc] init];
        NSMutableDictionary *postDic1 = [NSMutableDictionary new];
        [postDic1 setObject:self.mUser.UserGuid forKey:@"userGuid"];
        [postDic1 setObject:self.mUser.idcardnum forKey:@"idCard"];
        [[MS_BasicDataController sharedInstance] postWithReturnCode:expert_getExpertIdentity_HTTP params:postDic1 jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            if ([code integerValue] == 0 ) {
                if (((NSArray *)res[@"data"]).count > 0) {
                }
                
            }
            [self bindView];
        } failure:^(NSError *error) {
            [self bindView];
        }];
    }];
    
    
    
//暂时显示
//    [btnMessage setHidden:NO];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_sysGetAdmin params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            //是管理员
            [btnMessage setHidden:NO];
            //管理权限  - 1-全部权限、2-仅查看咨询投诉、3-仅查看抽取状态
            administrativePermissions = [res[@"data"] intValue];
//            administrativePermissions = 2;
        } else {
            //不是管理员
            [btnMessage setHidden:YES];
        }
     } failure:^(NSError *error) {
     }];
    
    
}
- (void)geetUserInfo {
        [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_sysGetInfo_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            if (([code integerValue] == 0 || [code integerValue] == 1) && res) {
                WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
                currentUserModel.token = self.mUser.token;
                [MS_BasicDataController sharedInstance].user = currentUserModel;
                self.mUser = currentUserModel;
             } else {
                [self.view makeToast:res[@"msg"]];
                 NSLog(@"没有登录, 跳转登录页");
                 NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
                 [notifyCenter postNotificationName:NOTIFY_RELOGIN object:nil];

            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"请求失败，请稍后再试"];
            NSLog(@"没有登录, 跳转登录页");
            NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
            [notifyCenter postNotificationName:NOTIFY_RELOGIN object:nil];

        }];
    
}
- (void)bindView {
    
    [cellHeader.imgHead sd_setImageWithURL:[NSURL URLWithString:[self.mUser.avatarPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    int zyLeft = 0;
    int zyHeight = k360Width(45);
    if (self.zhuanYeArr.count > 3) {
        zyHeight = k360Width(85);
    }
    [cellHeader.viewZhuanYe setFrame:CGRectMake(cellHeader.imgHead.right + k360Width(120), 0, k360Width(150), zyHeight)];
    cellHeader.viewZhuanYe.centerY = cellHeader.imgHead.centerY;
     [cellHeader.viewZhuanYe removeAllSubviews];
    
    if (self.zhuanYeArr.count > 0) {
        int i = 0;
        int topY = k360Width(5);
        for (NSDictionary *dicItem in self.zhuanYeArr) {
            if (i == 3) {
                zyLeft = 0;
                topY = k360Width(45);
            }
            UIImageView *imgZy = [UIImageView new];
            [imgZy setFrame:CGRectMake(zyLeft, topY, k360Width(35), k360Width(35))];
             [imgZy sd_setImageWithURL:[NSURL URLWithString:dicItem[@"imgUrl"]]];
            [cellHeader.viewZhuanYe addSubview:imgZy];
//            NSArray *arrBuffs = dicItem[@"labels"];
//            if (arrBuffs != nil || arrBuffs.count > 0) {
                UIButton *imgZyBuff = [UIButton new];
            [imgZyBuff setFrame:CGRectMake(zyLeft, topY, k360Width(35), k360Width(35))];
                
                [imgZyBuff sd_setBackgroundImageWithURL:[NSURL URLWithString:dicItem[@"label"][@"imgUrl"]] forState:UIControlStateNormal];
                [imgZyBuff addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    NSLog(@"点击了图标");
                    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
                   wk.titleStr = @"专家状态图标说明";
                   wk.webviewURL = @"https://www.capass.cn/Avatar/zjzttb.pdf";
                   UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
                   navi.navigationBarHidden = NO;
                   navi.modalPresentationStyle = UIModalPresentationFullScreen;
                   [self presentViewController:navi animated:NO completion:nil];

                }];
//                [imgZyBuff sd_setImageWithURL:[NSURL URLWithString:dicItem[@"labels"][0][@"imgUrl"]]];
                [cellHeader.viewZhuanYe addSubview:imgZyBuff];
//            }
            zyLeft = imgZy.right + k360Width(10);
            i++;
        }
    }
         
    [btnMessage setFrame:CGRectMake(zyLeft, k360Width(4.5), k360Width(35), k360Width(35))];
    [cellHeader.viewZhuanYe addSubview:btnMessage];
   zyLeft = btnMessage.right + k360Width(10);
    
    if (self.mUser.realname.length <= 0) {
        cellHeader.lblNickname.text = @"用户姓名";
    } else {
        cellHeader.lblNickname.text = [NSString stringWithFormat:@"%@",self.mUser.realname];
    }
    //企业主-显示公司名称
    if ([self.mUser.UserType isEqualToString:@"2"]) {
        cellHeader.lblNickname.text = self.mUser.DanWeiName;
    }
    
     cellHeader.lblPhone.text = self.mUser.LoginID;
    
//        [[MS_BasicDataController sharedInstance] postWithURL:getXxJf_HTTP params:nil jsonData:nil showProgressView:YES success:^(id successCallBack) {
//            if (![successCallBack isEqual:[NSNull null]]) {
//                cellHeader.lblxxjf.text = [NSString stringWithFormat:@"%@\n学习积分",successCallBack[@"score"]];
//                cellHeader.lblqyjf.text = [NSString stringWithFormat:@"%@\n企业积分",successCallBack[@"scoreQy"]];
//                cellHeader.lblMyJf.text = [NSString stringWithFormat:@"%@分",successCallBack[@"score"]];
//            } else {
//                cellHeader.lblxxjf.text = [NSString stringWithFormat:@"%@\n学习积分",@"0"];
//                cellHeader.lblqyjf.text = [NSString stringWithFormat:@"%@\n企业积分",@"0"];
//                cellHeader.lblMyJf.text = [NSString stringWithFormat:@"%@分",@"0"];
//    
//            }
//        } failure:^(NSString *failureCallBack) {
//            [SVProgressHUD showErrorWithStatus:failureCallBack];
//        } ErrorInfo:^(NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
//        }];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_evaluate_HTTP params:nil jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if ([res[@"data"][@"examScore"][@"haveTrained"] boolValue]) {
                cellHeader.lblMyJf.text = res[@"data"][@"result"];
            } else {
                cellHeader.lblMyJf.text = @"";
            }
        } else {
            cellHeader.lblMyJf.text = @"";
        }
    } failure:^(NSError *error) {
    }];
    
 
    
        [cellHeader.btnJfgz addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            NSLog(@"点击了考核评价细则");
            MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = @"考核评价细则";
            wk.webviewURL = @"https://www.capass.cn/Avatar/khpjxz.pdf";
            wk.isShare = @"1";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:NO completion:nil];
    
        }];
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView   setContentOffset:CGPointMake(0, 0) animated:YES];
     [self getIntegralInfo];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //默认是全部
     self.view.backgroundColor = [UIColor whiteColor];
    [self configCallback];
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserver:self selector:@selector(updateFontSizeNotify:) name:@"UPDATEFONTSIZENOTIFY" object:nil];
    [self makeUI];
    
}

//修改了字体
- (void)updateFontSizeNotify:(NSNotification *)notifySender {
    self.tableView = nil;
    
    [self.view removeAllSubviews];
    [self makeUI];
}

- (void)makeUI {
    int topY = MH_APPLICATION_STATUS_BAR_HEIGHT;
    
    cellHeader = [[WY_MyInfoTableViewCell alloc] initWithFrame:CGRectMake(0, -topY, kScreenWidth, k360Width(250) + topY)];
    cellHeader.backgroundColor = MSTHEMEColor;
    
    cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;
    [cellHeader setBtnExitUserAction:^{
        MSLog(@"t退出登录");
        [[MS_BasicDataController sharedInstance] postWithURL:LOGOUTHTTP params:nil jsonData:nil showProgressView:YES success:^(id successCallBack) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userJson"];
            [MS_BasicDataController sharedInstance].user = nil;
            WY_LoginViewController *tempController = [WY_LoginViewController new];
            tempController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:tempController animated:YES completion:nil];
        } failure:^(NSString *failureCallBack) {
            [SVProgressHUD showErrorWithStatus:failureCallBack];
        } ErrorInfo:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        }];
    }];
    [self.view addSubview:cellHeader];
    
    //消息功能；
    btnMessage = [[UIButton alloc] init];
//    [btnMessage setBackgroundColor:[UIColor redColor]];
    [btnMessage setBackgroundImage:[UIImage imageNamed:@"0510_gly"] forState:UIControlStateNormal];
//    [btnMessage setTitle:@"管理功能" forState:UIControlStateNormal];
    [btnMessage setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnMessage addTarget:self action:@selector(btnMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [cellHeader addSubview:btnMessage];
    [btnMessage setHidden:YES];
    
//    self.objectArr = @[@"身份信息",@"专家信息",@"新机制及国家节点库专家",@"资格证书",@"修改密码"];
//    self.objectImgArr = @[@"0224_Myqianshousaomiao",@"0717_zjxx",@"newjzj",@"1103_zgzs",@"0224_Mymimayimidida"];

    self.objectArr = @[@"身份信息",@"专家信息",@"资格证书",@"修改密码"];
    self.objectImgArr = @[@"0224_Myqianshousaomiao",@"0717_zjxx",@"1103_zgzs",@"0224_Mymimayimidida"];

//    self.objectArr2 = @[@"订单管理",@"地址管理",@"我的考试",@"我的课程",@"我的收藏",@"银行卡",@"我的信用",@"操作手册"];
//    self.objectImgArr2 = @[@"0317_order",@"0316_address",@"0224_Myks",@"0224_Myxuexi",@"0224_Mypingjiayimidida",@"0224_Myyinhangka",@"0703_xyIcon",@"0422_czsc"];
    
    self.objectArr2 = @[@"订单管理",@"地址管理",@"我的考试",@"我的课程",@"我的收藏",@"银行卡",@"操作手册"];
    self.objectImgArr2 = @[@"0317_order",@"0316_address",@"0224_Myks",@"0224_Myxuexi",@"0224_Mypingjiayimidida",@"0224_Myyinhangka",@"0422_czsc"];
  
    self.objectArr3 = @[@"设置"];
    self.objectImgArr3 = @[@"0224_Mysz"];
    
    
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    
}


#pragma mark - UITableViewDelegate (TableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return self.objectArr.count;
    }
    //    else if (section == 1){
    //        return self.objectArr1.count;
    //    }
    else if (section == 1){
        return self.objectArr2.count;
    } else if (section == 2){
        return self.objectArr3.count;
    }else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = @"";
    UIImage *cellImage = nil;
    switch (indexPath.section) {
        case 0:
        {
            cellStr = self.objectArr[indexPath.row];
            cellImage = [UIImage imageNamed:self.objectImgArr[indexPath.row]];
            
        }
            break;
        case 1:
        {
            cellStr = self.objectArr2[indexPath.row];
            cellImage = [UIImage imageNamed:self.objectImgArr2[indexPath.row]];
            
        }
            break;
        case 2:
        {
            cellStr = self.objectArr3[indexPath.row];
            cellImage = [UIImage imageNamed:self.objectImgArr3[indexPath.row]];
            
        }
            break;
            
        default:
            break;
    }
    WY_MyOtherTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"WY_MyOtherTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if ([cellStr isEqualToString:@"专家信息"]) {
        NSMutableAttributedString *cellStrAtt = [[NSMutableAttributedString alloc] initWithString:cellStr];
        NSMutableAttributedString *cellStrAtt1 = [[NSMutableAttributedString alloc] initWithString:@" (待续聘)"];
        [cellStrAtt1 setYy_color:[UIColor redColor]];
        [cellStrAtt1 setYy_alignment:NSTextAlignmentRight];
        if (self.isRenewalFlag == 1) {
            [cellStrAtt appendAttributedString:cellStrAtt1];
        }
        
        cell.titleLab.attributedText = cellStrAtt;
    } else {
        cell.titleLab.text = cellStr;
    }
    
    cell.logoImg.image = cellImage;
    cell.lineView.hidden = NO;
    cell.rImg.hidden = NO;
    [cell.rightLab setHidden:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"个人信息");
                    WY_UserInfoViewController *tempController = [WY_UserInfoViewController new];
                     [self.navigationController pushViewController:tempController animated:YES];
                }
                    break;
                case 1: {
                    NSLog(@"专家信息");
                    
                    if (EXPERTISMIND == 1 || EXPERTISMIND == 2) {
                        [SVProgressHUD showErrorWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
                        return;
                    }
                    
                    self.selItemIndex = 1;
                    [self zjExpertCertification];
                }
                    break;
//                case 2: {
//                    NSLog(@"新机制及国家节点库专家");
//                    
//                    if (EXPERTISMIND == 1 || EXPERTISMIND == 2) {
//                        [SVProgressHUD showErrorWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
//                        return;
//                    }
//                    
//                    self.selItemIndex = 3;
//                    [self zjExpertCertification];
//                }
//                    break;
                case 2: {
                    NSLog(@"资格证书");
                    [self expertPassHttp];                    
                }
                    break;
                case 3:
                {
                    NSLog(@"修改密码");
                    WY_UpdatePwdViewController *tempController = [WY_UpdatePwdViewController new];
                    [self.navigationController pushViewController:tempController animated:YES];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
            //        case 1:
            //        {
            //            switch (indexPath.row) {
//                            case 0:
//                            {
//                                NSLog(@"地址管理");
//                                WY_AddressManageViewController *tempController = [WY_AddressManageViewController new];
//                                tempController.isSel = NO;
//                                [self.navigationController pushViewController:tempController animated:YES];
//                            }
//                                break;
            //                case 1:
            //                {
            //                    NSLog(@"发票管理");
            //                    WY_MyInvoiceListViewController *tempController = [WY_MyInvoiceListViewController new];
            //                    [self.navigationController pushViewController:tempController animated:YES];
            //
            //                }
            //                    break;
            //
            //                default:
            //                    break;
            //            }
            //        }
            //            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"订单管理");
//                    WY_CAOrderListViewController *tempController = [WY_CAOrderListViewController new];
//                    tempController.hidesBottomBarWhenPushed = YES;
//                     [self.navigationController pushViewController:tempController animated:YES];
                    
                    
                    WY_CAOrderMainViewController *tempController = [WY_CAOrderMainViewController new];
                    tempController.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:tempController animated:YES];
                    
                }
                    break;
                case 1:
                {
                    NSLog(@"地址管理");
                    WY_AddressManageViewController *tempController = [WY_AddressManageViewController new];
                    tempController.isSel = NO;
                    [self.navigationController pushViewController:tempController animated:YES];
                }
                    break;
                case 2:
                {
                    NSLog(@"考试");
                    WY_MyExamViewController *tempController = [WY_MyExamViewController new];
                    [self.navigationController pushViewController:tempController animated:YES];
                }
                    break;
                    //                case 1: {
                    //                    NSLog(@"出题");
                    //                    [self goChuTi];
                    //                }
                    //                    break;
                case 3:
                {
                    NSLog(@"课程");
                    WY_MyCourseListViewController *tempController = [WY_MyCourseListViewController new];
                    [self.navigationController pushViewController:tempController animated:YES];
                    
                }
                    break;
                case 4:
                {
                    NSLog(@"收藏");
                    WY_MyCollectMainViewController *tempController = [WY_MyCollectMainViewController new];
                    [self.navigationController pushViewController:tempController animated:YES];
                    
                }
                    break;
                    
//                case 5:
//                {
//                    NSLog(@"我的收入");
//                    [self.view makeToast:@"此功能即将上线，敬请期待"];
//
//                }
//                    break;
                case 5:
                {
                    NSLog(@"银行卡");
                    
                    self.selItemIndex = 2;
                    [self zjExpertCertification];
                    
                    
//                    [self.view makeToast:@"此功能即将上线，敬请期待"];
                }
                    break;
                    
//                case 6:
//                {
//                    if  ([[MS_BasicDataController sharedInstance].user.UserType isEqualToString:@"1"]) {
//                        NSLog(@"我的信用");
//                        WY_MyCreditViewController *tempController = [WY_MyCreditViewController new];
//                        [self.navigationController pushViewController:tempController animated:YES];
//                    } else {
//                        [SVProgressHUD showErrorWithStatus:@"您还不是专家，无法查看此功能"];
//                        
//                    }
//                }
//                    break;
                case 6: {
                    WY_DocListViewController *tempController = [WY_DocListViewController new];
                    [self.navigationController pushViewController:tempController animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
//                                    case 0:
//                                    {
//                                        NSLog(@"我的收入");
//                                        [self.view makeToast:@"此功能即将上线，敬请期待"];
//
//                                    }
//                                        break;
//                                    case 1:
//                                    {
//                                        NSLog(@"银行卡");
//                    //                    WY_MyBankCardViewController *tempController = [WY_MyBankCardViewController new];
//                    //                    tempController.title = @"银行卡";
//                    //                    [self.navigationController pushViewController:tempController animated:YES];
//                                        [self.view makeToast:@"此功能即将上线，敬请期待"];
//                                    }
//                                        break;
                    
                    
                case 0:
                {
                    NSLog(@"设置");
                    WY_SettingViewController *tempController = [WY_SettingViewController new];
                    [self.navigationController pushViewController:tempController animated:YES];
                    
                }
                    break;
                    
            }
            
        }
            break;
            
        default:
            break;
    }
}

//验证专家信息总步骤-
- (void)zjExpertCertification {
    /*
        1. 判断用户是否有身份证、姓名
            否：去身份证Ocr实名
        2.如果-UserType 已经是1，说明登录后就已判断此用户是专家 - 直接进行 -扫脸认证判断
        3.此用户在当前登录时不是专家- 需求拉取监管网-判断是否是专家
        4. 判断今天是否已经验证过人脸；
            否：验证人脸对比；
        5.进入具体功能
     */
    if (self.mUser.idcardnum.length <= 0 || self.mUser.realname.length <= 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前用户没有身份证信息，是否现在进行完善身份证信息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:([UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goIDCarSettingPage];
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        //如果-UserType 已经是1，说明登录后就已判断此用户是专家 - 直接进行 -扫脸认证判断
//        if  ([self.mUser.UserType isEqualToString:@"1"]) {
//              [self smrzxxIsBelow];
            //工信部要求去掉人脸
//            NSLog(@"进入功能");
//            [self goHomePageItemByIndex:self.selItemIndex];

//        } else {
            //否则 此用户在当前登录时不是专家- 需求拉取监管网-判断是否是专家
            WY_UserModel *tempUser = [WY_UserModel new];
            tempUser.idcardnum = self.mUser.idcardnum;
            tempUser.yhname = self.mUser.realname;
            tempUser.key = self.mUser.idcardnum;
            tempUser.userid = self.mUser.UserGuid;
            [self zhuanJiaLaQuByPost:tempUser];

//        }
    }
}
//专家生成并打开证书
- (void)expertPassHttp {
    
     //专家生成并打开证书
    /*
     1.判断是否是专家
     2.判断专家是否已通过考试
     3.判断专家是否已完善信息
     4.判断是否已生成过证书-
     1.已生成过 - 直接打开展示
     2.未生成过- 传照片后展示；
     */
    
    if  ([[MS_BasicDataController sharedInstance].user.UserType isEqualToString:@"1"]) {
        //模拟走到 4.1
        NSMutableDictionary *postDic = [NSMutableDictionary new];
        [postDic setObject:self.mUser.UserGuid forKey:@"UserGuid"];
        [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
        [[MS_BasicDataController sharedInstance] postWithReturnCode:wl_addQuestion_getZJStatus_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            if ([code integerValue] == 0 ) {
                NSString *picUrl = res[@"data"][@"certUrl"];
                NSLog(@"picUrl：%@",picUrl);
                WY_ShowPdfViewController *tempController = [WY_ShowPdfViewController new];
                tempController.titleStr = @"资格证书";
                tempController.webviewURL = [picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
                tempController.yuanWebviewURL = picUrl;
                [self.navigationController pushViewController:tempController animated:YES];
                
                
            } else if ([code integerValue] == 2 ) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您可以生成证书了，请您上传证书证件照" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [alertController addAction:([UIAlertAction actionWithTitle:@"拍照上传证书证件照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
                    //读取设备授权状态
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        [SVProgressHUD showInfoWithStatus:@"应用相机权限受限,请在设置中启用"];
                        [SVProgressHUD dismissWithDelay:1.5];
                        return;
                    }
                    
                    LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
                    imagePicker.delegate = self;
                    [imagePicker showImagePickerWithType:0 InViewController:self Scale:1.2];
                    self.height.constant = 180*1.2;
                    
                }])];
                [alertController addAction:([UIAlertAction actionWithTitle:@"相册选择证书证件照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
                    imagePicker.delegate = self;
                    [imagePicker showImagePickerWithType:1 InViewController:self Scale:1.2];
                    self.height.constant = 180*1.2;
                    
                }])];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else {
                [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"暂无数据"];
        }];
        
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您不是专家无法查看此功能"];
    }
    
}

/// 出题
- (void)goChuTi {
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.mUser.orgnum forKey:@"orgnum"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:dlPerson_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            WY_TestQuestionsMainViewController *tempController = [WY_TestQuestionsMainViewController new];
            [self.navigationController pushViewController:tempController animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"data"]];
        }
    } failure:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"接口请求失败"];
        WY_TestQuestionsMainViewController *tempController = [WY_TestQuestionsMainViewController new];
        [self.navigationController pushViewController:tempController animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  k360Width(50);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 ||section == 1 ||section == 2 || section == 3) {
        return 10;
    } else {
        return 0.01;
    }
}
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cellHeader.bottom, MSScreenW,  MSScreenH - MH_APPLICATION_TAB_BAR_HEIGHT - cellHeader.bottom) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor =HEXCOLOR(0xEDEDED);
        _tableView.sectionFooterHeight = 0.001;
        _tableView.sectionHeaderHeight = 0.001;
        
        
        [_tableView registerClass:[WY_MyInfoTableViewCell class] forCellReuseIdentifier:@"WY_MyInfoTableViewCell"];
        [_tableView registerClass:[WY_MyOtherTableViewCell class] forCellReuseIdentifier:@"WY_MyOtherTableViewCell"];
        [_tableView registerClass:[WY_MyVipTableViewCell class] forCellReuseIdentifier:@"WY_MyVipTableViewCell"];
        
        
        
    }
    
    return _tableView;
}


#pragma mark --消息按钮点击事件
- (void)btnMessageAction {
    NSLog(@"点击了消息按钮");
    WY_ManageViewController *tempController = [WY_ManageViewController new];
    tempController.administrativePermissions = administrativePermissions;
    [self.navigationController pushViewController:tempController animated:YES];
//    WY_ZJPushMsgViewController *tempController = [WY_ZJPushMsgViewController new];
//    [self.navigationController pushViewController:tempController animated:YES];
}


//身份证OCR识别
- (void)goIDCarSettingPage {
    //    要去掉百度身份证扫描识别OCR 功能，  改用公司自身 OCR 产品
    [SVProgressHUD showErrorWithStatus:@"请到个人信息页面完善身份证号和姓名"];
    WY_UserInfoViewController *tempController = [WY_UserInfoViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
    return;
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
    [self.tabBarController.selectedViewController presentViewController:vc animated:YES completion:nil];
    
    //    WY_IDCarSettingViewController *tempController = [WY_IDCarSettingViewController new];
    //    [self.tabBarController.selectedViewController pushViewController:tempController animated:NO];
    
}


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
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.isIdCardSuccess isEqualToString:@"1"]) {
        [self ocrSuccess];
    }
}

- (void)ocrSuccess {
    //如果不是首次注册补全信息- 是人脸识别 -并成功后进入功能；
    if (![self.isBuQuan isEqualToString:@"1"]) {
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
        WY_UserModel *tempUser = [WY_UserModel new];
        tempUser.idcardnum = idCardNum;
        tempUser.yhname = pName;
        tempUser.key = idCardNum;
        tempUser.userid = self.mUser.UserGuid;
        [self zhuanJiaLaQuByPost:tempUser];
    }
}
  
/// 检查监管网是否有专家信息
/// @param tempUser 专家参数
- (void)zhuanJiaLaQuByPost:(WY_UserModel *)tempUser {
    //    成功后 - 进行人脸识别；
    WS(weakSelf);
    if(self.selItemIndex == 2) {
        //不用判断是否是专家- 有身份证就可以进入银行卡完善
        WY_AddBankCardViewController *tempController = [WY_AddBankCardViewController new];
        tempController.title = @"银行卡信息";
        [self.navigationController pushViewController:tempController animated:YES];
        return;
    }
    [[MS_BasicDataController sharedInstance] postWithReturnCode:checkinjianguan_HTTP params:nil jsonData:[tempUser toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
            currentUserModel.token = self.mUser.token;
            //如果是专家- 跳转扫脸
            if  ([currentUserModel.UserType isEqualToString:@"1"]) {
                [MS_BasicDataController sharedInstance].user = currentUserModel;
                self.mUser = currentUserModel;
//                 [self smrzxxIsBelow];
                //工信部要求去掉人脸
                NSLog(@"进入功能");
                [self goHomePageItemByIndex:self.selItemIndex];

            } else {
                if (![self.isBuQuan isEqualToString:@"1"]) {
                    [SVProgressHUD showErrorWithStatus:@"您不是专家无法查看此功能"];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"普通用户身份信息认证成功"];
                }
            }
        } else {
            //2023-03-02 13:42:51- 修改需求 - 禁用专家放开专家信息功能；
//            if (self.selItemIndex == 1) {
                if([res[@"msg"] rangeOfString:@"禁用"].length > 0) {
                    [self goHomePageItemByIndex:self.selItemIndex];
                } else {
                    [self.view makeToast:res[@"msg"]];
                }
//            } else {
//                [self.view makeToast:res[@"msg"]];
//            }
            
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
    }];
}
///判断今天是否进行过人脸识别
- (void)smrzxxIsBelow {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
     [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:bidevaluationSmrzxxIsBelow_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
              //不需要人脸识别
              if (self.selItemIndex > 0) {
                  [self goHomePageItemByIndex:self.selItemIndex];
              }
        } else {
            //需要人脸识别
            [self VFace];
        }
    } failure:^(NSError *error) {
         [self.view makeToast:@"请求失败，请稍后再试"];
    }];

}
///验证人脸
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
//人脸 识别成功后- 调用接口
- (void)submitData:(UIImage *)imgFace {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.realname forKey:@"name"];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [dicPost setObject:self.mUser.LoginID forKey:@"loginId"];
    [dicPost setObject:[self UIImageToBase64Str:imgFace] forKey:@"base64Str"];
    
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:ZJsmrzxx_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
         if ([code integerValue] == 0 && res) {
            //            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            [self.view makeToast:res[@"msg"]];
            NSLog(@"进入功能");
             if (self.selItemIndex > 0) {
                 [self goHomePageItemByIndex:self.selItemIndex];
             }
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
//进入具体功能
- (void)goHomePageItemByIndex:(int )withIndex {
    if (withIndex == 1) {
        WY_ExpertStatusViewController *tempController = [WY_ExpertStatusViewController new];
        [self.navigationController pushViewController:tempController animated:YES];
        return;
    } else if (withIndex == 2) {
        //不用判断是否是专家- 有身份证就可以进入银行卡完善
        WY_AddBankCardViewController *tempController = [WY_AddBankCardViewController new];
        tempController.title = @"银行卡信息";
        [self.navigationController pushViewController:tempController animated:YES];
        return;
    } else if (withIndex == 3) {
        //不用判断是否是专家- 有身份证就可以进入银行卡完善
        WY_NationalNodesViewController *tempController = [WY_NationalNodesViewController new];
        tempController.title = @"新机制及国家节点库专家";
        [self.navigationController pushViewController:tempController animated:YES];
        return;
    }
}
 

- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker{
    
}
- (void)zjCertUpLoad:(UIImage *)editedImage {
    NSData *data;
    data = UIImageJPEGRepresentation(editedImage, 0.1);
    //上传图片
    NSString *str= [GlobalConfig getAbsoluteUrl:wl_tExamScore_CreateZJcert_HTTP];
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
    [dicPost setObject:[MS_BasicDataController sharedInstance].user.idcardnum forKey:@"idCard"];
    [dicPost setObject:@"" forKey:@"description"];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:str parameters:dicPost headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
        [SVProgressHUD ms_dismiss];
        
        if ([json[@"code"] integerValue] == 0 ) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
            NSString *picUrl = json[@"data"];
            NSLog(@"picUrl：%@",picUrl);
            WY_ShowPdfViewController *tempController = [WY_ShowPdfViewController new];
            tempController.isYuLan = @"1";
            tempController.titleStr = @"资格证书";
            tempController.webviewURL = [picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
            tempController.yuanWebviewURL = picUrl;
            [self.navigationController pushViewController:tempController animated:YES];
            
        } else {
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD ms_dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
}

- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage{
    self.height.constant = editedImage.size.height/editedImage.size.width*180;
    //    self.imgeView.image = editedImage;
    CustomAlertView *alert = [[CustomAlertView alloc] initWithAlertViewHeight:k360Width(400) withImage:editedImage];
    
    alert.ButtonClick = ^void(UIButton*button){
        NSLog(@"%ld",(long)button.tag);
        
        if (button.tag==100) {
            //look  rili
            [self zjCertUpLoad:editedImage];
        }
    };
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
