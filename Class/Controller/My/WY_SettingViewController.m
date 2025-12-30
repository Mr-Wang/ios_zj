//
//  WY_SettingViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/5.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SettingViewController.h"
#import "WY_LoginViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "KeyChainStore.h"
#import "WY_LXWMViewController.h"
#import "WY_UserLogoutViewController.h"
#import "WY_AboutMyViewController.h"

@interface WY_SettingViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrSource;

@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [MS_BasicDataController sharedInstance].user;

    [self makeUI];
    [self dataBind];
}
- (void)viewWillAppear:(BOOL)animated {
    self.mUser = [MS_BasicDataController sharedInstance].user;
}
- (void)makeUI {
    self.title = @"设置";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];

     [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), kScreenHeight - k360Width(50) - JCNew64 - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(30), k360Width(40))];
    [btnLeft rounded:k360Width(40/8)];
    [btnLeft setBackgroundColor:MSTHEMEColor];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnLeft.titleLabel setFont:WY_FONTRegular(14)];
    [self.view addSubview:btnLeft];

}

- (void)dataBind {
    self.arrSource = [NSMutableArray new];
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    NSMutableDictionary *dic5 = [NSMutableDictionary new];
    NSMutableDictionary *dic6 = [NSMutableDictionary new];
    NSMutableDictionary *dic6A = [NSMutableDictionary new];
    NSMutableDictionary *dic7 = [NSMutableDictionary new];

    [self.arrSource addObject:dic2];
    [self.arrSource addObject:dic1];
//    [self.arrSource addObject:dic2];
//    [self.arrSource addObject:dic3];
//    [self.arrSource addObject:dic4];
//    [self.arrSource addObject:dic5];
//    [self.arrSource addObject:dic6A];
    [self.arrSource addObject:dic6];
    [self.arrSource addObject:dic7];
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat fileSize = [MS_CommonTool folderSizeAtPath:cachPath];
 
    [dic1 setObject:[NSString stringWithFormat:@"%.1fM",fileSize] forKey:@"value"];
    [dic1 setObject:@"清理图片缓存" forKey:@"name"];
//    [dic1 setObject:@"15.80M" forKey:@"value"];
    [dic1 setObject:@"1" forKey:@"typeid"];
    
    [dic2 setObject:@"关于我们" forKey:@"name"];
    [dic2 setObject:@"" forKey:@"value"];
    [dic2 setObject:@"2" forKey:@"typeid"];
    
    [dic3 setObject:@"当前版本" forKey:@"name"];
    
    
    
    [dic3 setObject:[NSString stringWithFormat:@"V%@ b%.1f",[GlobalConfig appVersion],[GlobalConfig appBulidVersion]] forKey:@"value"];
    [dic3 setObject:@"3" forKey:@"typeid"];
    
    [dic4 setObject:@"用户服务协议" forKey:@"name"];
    [dic4 setObject:@"" forKey:@"value"];
    [dic4 setObject:@"4" forKey:@"typeid"];
    
    [dic5 setObject:@"隐私政策" forKey:@"name"];
    [dic5 setObject:@"" forKey:@"value"];
    [dic5 setObject:@"5" forKey:@"typeid"];
     
    [dic6A setObject:@"数字证书服务协议" forKey:@"name"];
    [dic6A setObject:@"" forKey:@"value"];
    [dic6A setObject:@"11" forKey:@"typeid"];
    
    [dic7 setObject:@"申请删除账号" forKey:@"name"];
    [dic7 setObject:@"请谨慎操作" forKey:@"value"];
    [dic7 setObject:@"12" forKey:@"typeid"];
    
    [dic6 setObject:@"字体显示大小" forKey:@"name"];
    NSString *fontShowSizeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"FontShowSize"];
    if (fontShowSizeStr) {
        if ([fontShowSizeStr isEqualToString:@"0"]) {
             [dic6 setObject:@"标准" forKey:@"value"];
        } else if ([fontShowSizeStr isEqualToString:@"30"]) {
             [dic6 setObject:@"大" forKey:@"value"];
        } else if ([fontShowSizeStr isEqualToString:@"60"]) {
             [dic6 setObject:@"特大" forKey:@"value"];
        }
    } else {
        [dic6 setObject:@"标准" forKey:@"value"];
    }
    
    
    [dic6 setObject:@"6" forKey:@"typeid"];

    
    [self.tableView reloadData];
}
- (void)btnLeftAction {
    NSLog(@"点击了退出按钮");
     [[MS_BasicDataController sharedInstance] postWithURL:LOGOUTHTTP params:nil jsonData:nil showProgressView:YES success:^(id successCallBack) {
         NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef removeObjectForKey:@"userJson"];
              [userDef removeObjectForKey:@"mWY_QuizModelJson"];
             [userDef removeObjectForKey:@"limitTimeStamp"];
             [userDef removeObjectForKey:@"isDuringExam"]; 
             [userDef removeObjectForKey:@"examInfoId"];
         [userDef removeObjectForKey:@"examInfoId1"];
         //搜索历史
         [userDef removeObjectForKey:@"dicSearchHome"];
         [userDef removeObjectForKey:@"dicSearchTraining"];
         [userDef removeObjectForKey:@"PromptDate240605"];
         
         [userDef synchronize];
         
         [MS_BasicDataController sharedInstance].user = nil;
         
         self.tabBarController.selectedIndex = 0;

         [self.navigationController popViewControllerAnimated:NO];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFY_RELOGINAA" object:nil];
//        WY_LoginViewController *tempController = [WY_LoginViewController new];
//        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
//        [[self.tabBarController.viewControllers objectAtIndex:0] presentViewController:tempController animated:NO completion:nil];
         
//        [self presentViewController:tempController animated:YES completion:nil];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

}


#pragma mark -- 清除缓存
-(void)clearCacheAction{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat fileSize = [MS_CommonTool folderSizeAtPath:cachPath];
    NSString *message;
    if (fileSize <= 0.01) {
        message = @"无缓存数据，无需清理";
    }else {
        message = [NSString stringWithFormat:@"缓存大小为%.2fMB，确定要清理吗？",fileSize];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self clearCache];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    if (fileSize <= 0.01) {
        [alertController addAction:cancelAction];
    }else{
        [alertController addAction:cancelAction];
        [alertController addAction:doneAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)clearCache {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[MYHUDHelper sharedInstance] tipMessage:@"清除成功"];
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];
            [self dataBind];
        });
    });
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   // 隐藏系统分割线
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor =MSColor(242, 242, 242);
        _tableView.sectionFooterHeight = k360Width(10);
        _tableView.sectionHeaderHeight = 0.01;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultUITableViewCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
           // Fallback on earlier versions
        }
    }
    
    return _tableView;
}


#pragma mark - UITableViewDelegate (TableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrSource.count) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"使用Touch ID登录";
        [cell.textLabel setFont:WY_FONTRegular(14)];
        UISwitch *swiTouch = [UISwitch new];
        [swiTouch setFrame:CGRectMake(kScreenWidth - k360Width(60), k360Width(6), k360Width(50), k360Width(30))];
        [swiTouch setTintColor:MSTHEMEColor];
        [cell.contentView addSubview:swiTouch];
        swiTouch.tag = 932;
        [swiTouch addTarget:self action:@selector(swiTouchAction:) forControlEvents:UIControlEventValueChanged];
        
        NSString *isTouchLogin = [KeyChainStore load:@"isTouchLogin"];
        NSString *isTouchLogin_LoginID = [KeyChainStore load:@"isTouchLogin_LoginID"];
        
        if ([isTouchLogin isEqualToString:@"1"] && [isTouchLogin_LoginID isEqualToString:self.mUser.LoginID]) {
            swiTouch.on = YES;
        } else {
            swiTouch.on = NO;
        }
        return cell;
    }
    NSMutableDictionary *dicItem = self.arrSource[indexPath.row];
    
     UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
     cell.backgroundColor = [UIColor clearColor];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([dicItem[@"typeid"] isEqualToString:@"3"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
     cell.textLabel.text = dicItem[@"name"];
     cell.detailTextLabel.text = dicItem[@"value"];
    
     [cell.detailTextLabel setFont:WY_FONTRegular(14)];
    [cell.textLabel setFont:WY_FONTRegular(14)];
    [cell.detailTextLabel setFont:WY_FONTRegular(14)];
     UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(44) - 2,kScreenWidth,2)];
     [imgLine setBackgroundColor:APPLineColor];
     [cell addSubview:imgLine];
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dicItem = self.arrSource[indexPath.row];
    NSLog(@"点击了按钮：%@",dicItem[@"typeid"]);
    switch ([dicItem[@"typeid"] intValue]) {
        case 1:
            {
                //清理图片缓存
                [self clearCacheAction];
            }
            break;
        case 2:
        {
//            [GlobalConfig makeCall:@"4001257788"];
            NSLog(@"进入关于我们");
//            WY_LXWMViewController *tempCongtroller = [WY_LXWMViewController new];
//            [self.navigationController pushViewController:tempCongtroller animated:YES];
            WY_AboutMyViewController *tempCongtroller = [WY_AboutMyViewController new];
            [self.navigationController pushViewController:tempCongtroller animated:YES];
        }
            break;
        case 4:
        {
             MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = @"用户服务协议";
            wk.webviewURL = @"https://www.capass.cn/Avatar/zjapp.pdf";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:NO completion:nil];

        }
            break;
        case 11:
        {
             MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = @"数字证书服务协议（BJCA及CFCA）";
            wk.webviewURL = @"https://lnwlzj.capass.cn/lnwlzj/%E6%95%B0%E5%AD%97%E8%AF%81%E4%B9%A6%E6%9C%8D%E5%8A%A1%E5%8D%8F%E8%AE%AE%EF%BC%88BJCA%E5%8F%8ACFCA%EF%BC%89(1).pdf";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:NO completion:nil];

        }
            break;
        case 12 : {
            WY_UserLogoutViewController *tempController = [WY_UserLogoutViewController new];
            [self.navigationController pushViewController:tempController animated:YES];
            
        }
            break;
        case 5:
        {
             MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = @"隐私政策";
            wk.webviewURL = @"https://www.capass.cn/Avatar/ysxy.pdf";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:NO completion:nil];

        }
            break;
        case 6: {
            NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择字体显示大小" preferredStyle:UIAlertControllerStyleAlert];
            @weakify(self)
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"标准" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"FontShowSize"];
                [self dataBind];
                [notifyCenter postNotificationName:@"UPDATEFONTSIZENOTIFY" object:nil];
                
            }];
            UIAlertAction *done1Action = [UIAlertAction actionWithTitle:@"大" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:@"30" forKey:@"FontShowSize"];
                [self dataBind];
                [notifyCenter postNotificationName:@"UPDATEFONTSIZENOTIFY" object:nil];

            }];
            UIAlertAction *done2Action = [UIAlertAction actionWithTitle:@"特大" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:@"60" forKey:@"FontShowSize"];
                [self dataBind];
                [notifyCenter postNotificationName:@"UPDATEFONTSIZENOTIFY" object:nil];

            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:doneAction];
            [alertController addAction:done1Action];
            [alertController addAction:done2Action];
            [alertController addAction:cancelAction];

             [self presentViewController:alertController animated:YES completion:nil];

        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return k360Width(44);
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)swiTouchAction:(UISwitch *)swiSender {
    if (swiSender.on) {
        [KeyChainStore save:@"isTouchLogin" data:@"1"];
        [KeyChainStore save:@"isTouchLogin_LoginID" data:self.mUser.LoginID];
        [KeyChainStore save:@"isTouchLogin_LoginPWD" data:self.mUser.PassWD];
        [SVProgressHUD showSuccessWithStatus:@"今后可以使用Touch ID登录了"];
     } else {
        [KeyChainStore save:@"isTouchLogin" data:@"0"];
    }
}
@end
