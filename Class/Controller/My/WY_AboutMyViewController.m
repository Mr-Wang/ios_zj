//
//  WY_AboutMyViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2024/1/12.
//  Copyright © 2024 王杨. All rights reserved.
//
#import "WY_AboutMyViewController.h"
#import "WY_LoginViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "KeyChainStore.h"
#import "WY_LXWMViewController.h"
#import "WY_LXWM2ViewController.h"
#import "WY_UserLogoutViewController.h"

@interface WY_AboutMyViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrSource;

@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_AboutMyViewController

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
    self.title = @"关于我们";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, k360Width(40), k360Width(100), k360Width(100))];
    [imgLogo setImage:[UIImage imageNamed:@"LaunchScreenlogo"]];
    [self.view addSubview:imgLogo];
    [imgLogo setCenterX:self.view.centerX];
    
    UILabel *lblAPPName = [UILabel new];
    [lblAPPName setFrame:CGRectMake(0, imgLogo.bottom + k360Width(32), kScreenWidth, k360Width(25))];
    [lblAPPName setFont:WY_FONTMedium(24)];
    [lblAPPName setTextAlignment:NSTextAlignmentCenter];
    [lblAPPName setText:@"辽宁专家服务"];
    [lblAPPName setTextColor:[UIColor blackColor]];
    [self.view addSubview:lblAPPName];
    
     [self.tableView setFrame:CGRectMake(0, lblAPPName.bottom + k360Width(62), kScreenWidth, kScreenHeight - lblAPPName.bottom -  k360Width(62))];
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
     

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
    NSMutableDictionary *dic8 = [NSMutableDictionary new];
    NSMutableDictionary *dic9 = [NSMutableDictionary new];
    
 
    [self.arrSource addObject:dic2];
    [self.arrSource addObject:dic3];
    [self.arrSource addObject:dic4];
    [self.arrSource addObject:dic5];
    [self.arrSource addObject:dic6A];
    [self.arrSource addObject:dic7];
    [self.arrSource addObject:dic8];
    [self.arrSource addObject:dic9];
    
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat fileSize = [MS_CommonTool folderSizeAtPath:cachPath];
 
    [dic1 setObject:[NSString stringWithFormat:@"%.1fM",fileSize] forKey:@"value"];
    [dic1 setObject:@"清理图片缓存" forKey:@"name"];
//    [dic1 setObject:@"15.80M" forKey:@"value"];
    [dic1 setObject:@"1" forKey:@"typeid"];
    
    [dic2 setObject:@"联系我们" forKey:@"name"];
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
    
    [dic7 setObject:@"ICP备案号" forKey:@"name"];
    [dic7 setObject:@"辽ICP备18015387号-7A" forKey:@"value"];
    [dic7 setObject:@"13" forKey:@"typeid"];
    
    [dic8 setObject:@"主办单位" forKey:@"name"];
    [dic8 setObject:@"辽宁省发展和改革委员会" forKey:@"value"];
    [dic8 setObject:@"3" forKey:@"typeid"];
    
    [dic9 setObject:@"“指尖上的形式主义”" forKey:@"name"];
    [dic9 setObject:@"投诉举报入口" forKey:@"value"];
    [dic9 setObject:@"14" forKey:@"typeid"];
    
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
        _tableView.backgroundColor =HEXCOLOR(0xFAFAFA);
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
    return self.arrSource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
            WY_LXWMViewController *tempCongtroller = [WY_LXWMViewController new];
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
        case 13 : {
            NSLog(@"点击了备案");
            MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = @"备案查询";
            wk.webviewURL = @"https://beian.miit.gov.cn/";
            wk.isShare = @"1";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:NO completion:nil];
        }
            break;
        case 14:
        {
            NSLog(@"进入指尖上的形式主义");
            WY_LXWM2ViewController *tempCongtroller = [WY_LXWM2ViewController new];
            [self.navigationController pushViewController:tempCongtroller animated:YES];
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
