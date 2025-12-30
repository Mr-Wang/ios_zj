//
//  AppDelegate.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/9/3.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "AppDelegate.h"
#import "MS_NavigationController.h"
#import "MS_TabBarController.h"
#import <WXApi.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MS_WindowTool.h"
#import "WY_OnlineTrainDetailsViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import <UMCommon/UMCommon.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "WY_PushModel.h"
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用

#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"

#import "AvoidCrash.h"
#import "WY_ReShousListModel.h"
#import "LGCheckVersion.h"
#import "LivenessViewController.h"
#import "WY_BiddingProjectListViewController.h"
#import "LivingConfigModel.h"
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#import "WY_PerfectInfoViewController.h"

#import "WY_ExpertStatusViewController.h"
#import <iflyMSC/IFlyMSC.h>
#import "WY_ZJPushMsgViewController.h"
#import "WY_CAOrderMainViewController.h"

#import "WY_PrivacyWindowView.h"
#import "MS_WKwebviewsViewController.h"
#import "SYFloatingView.h"

#import "SJRotationManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>

#endif
/// 使用个推回调时，需要添加"GeTuiSdkDelegate"
/// iOS 10 及以上环境，需要添加 UNUserNotificationCenterDelegate 协议，才能使用 UserNotifications.framework 的回调

@interface AppDelegate ()<UNUserNotificationCenterDelegate,GeTuiSdkDelegate,WXApiDelegate>
@property (nonatomic , strong) MS_BasicDataController *basicData;/* 网络请求 */
@property (nonatomic) BOOL isLaunchedByNotification;
@property (nonatomic, strong) UIButton *timeBtn;
/** s */
@property (nonatomic, assign) NSInteger second;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) int approvalStatusNum;

@property (nonatomic,strong) NSString *jumpToWhere;
@end

@implementation AppDelegate
{
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}

- (void)otherRegister:(UIApplication * _Nonnull)application {
    
    
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    
    [WXApi registerApp:@"wxd2381bec1a8984de" universalLink:@"https://www.capass.cn/Expert/"];
    
    //    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:@"5f34e9afd30932215477ddc4" channel:@"App Store"];
    
    //高德- 不用了
//    [AMapServices sharedServices].apiKey = @"c760dc2cbed88b80d85ba7866e6c6a18";
    
    //Appid是应用的身份信息，具有唯一性，初始化时必须要传入Appid。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5ffaabef"];
    [IFlySpeechUtility createUtility:initString];
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    //配置百度离线人脸识别
    [self configBaiduFace];
    
    //这句代码会让AvoidCrash生效，若没有如下代码，则AvoidCrash就不起作用
    [AvoidCrash becomeEffective];
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}

- (void)initLXY {
    SYFloatingView * floatView = [[SYFloatingView alloc]initWithFrame:CGRectMake(0, JCNew64, k360Width(45), k360Width(55)) delegate:self];
        [self.window addSubview:floatView];
        [floatView floatingViewRoundedRect];
}
-(void)floatingViewDidClickView{
    NSLog(@"点击了浮动按钮");
    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
    wk.titleStr = @"智能客服";
//    @"http://192.168.0.30:8080?type=6";
//    @"https://ai.lnwlzb.com:8888/ai/#/customerHome?type=6";
    wk.webviewURL = @"https://ai.lnwlzb.com:8888/ai/#/customerHome?type=6";
    wk.isLxy = @"1";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
    navi.navigationBarHidden = NO;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.window.rootViewController presentViewController:navi animated:YES completion:nil];
}

- (void)showPrivacyWindow:(UIApplication * _Nonnull)application tab:(MS_TabBarController *)tab {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAPPAgree"] isEqualToString:@"1"]) {
        
        //第三方初始化
        [self otherRegister:application];
    } else  {
        WY_PrivacyWindowView *pwview = [[WY_PrivacyWindowView alloc] initWithFrame:self.window.bounds];
        
        [self.window addSubview:pwview];
        [pwview setDidCloseBtnAction:^{
            NSLog(@"退出APP ");
            exit(0);
        }];
        [pwview setDidStartBtnAction:^{
            [MS_WindowTool chooseRootViewControllerWithWindow:self.window];
            //APP 同意过-  就不再弹出了
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isAPPAgree"];
            
            //第三方初始化
            [self otherRegister:application];
        }];
        
        pwview.didUserAgreementBtnAction = ^{
            MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = @"用户服务协议";
            wk.webviewURL = @"https://www.capass.cn/Avatar/zjapp.pdf";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [tab presentViewController:navi animated:YES completion:nil];
        };
        
        pwview.didPrivacyAgreementBtnAction = ^{
            MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = @"隐私政策";
            wk.webviewURL = @"https://www.capass.cn/Avatar/ysxy.pdf";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [tab presentViewController:navi animated:NO completion:nil];
        };
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    MS_TabBarController *tab = [[MS_TabBarController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = tab;
    
    [self.window makeKeyAndVisible];
    
    NSString *fontShowSizeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"FontShowSize"];
    if (!fontShowSizeStr) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"FontShowSize"];
    }
    // 同步角标数到服务端
//    [self syncBadgeNum:0];
    
    
    //保存当前时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"currentDate"];
    
    // 合规调整 - 首次弹出 用户隐私同意弹窗
    [self showPrivacyWindow:application tab:tab];
    
    
    
 
    // 设置-hud基础样式
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    //    设置UIBarButtonItem和UINavigationBar的默认文字颜色
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:attrs];
    [IQKeyboardManager sharedManager].toolbarTintColor = MSTHEMEColor;
    
    
    [self initLXY];
     return YES;
}

- (void)customLaunchImageView
{
    UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    launchImageView.contentMode = UIViewContentModeScaleAspectFit;
    launchImageView.image = [UIImage imageNamed:@"wel_bg"];
    [launchImageView setBackgroundColor:[UIColor whiteColor]];
    
    [self.window addSubview:launchImageView];
    [self.window bringSubviewToFront:launchImageView];
    [self.window addSubview:self.timeBtn];
    self.second = 5;
    [self.timeBtn setTitle:[NSString stringWithFormat:@"跳过(%lds)", self.second] forState: UIControlStateNormal];
    WS(weakSelf)
    
    [self.timeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        launchImageView.alpha = 0.0;
        launchImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        weakSelf.timeBtn.hidden = YES;
        [weakSelf.timer invalidate];
    }];
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:@"4" forKey:@"type"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getTpUrl_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            WY_ReShousListModel *tempModel = [WY_ReShousListModel modelWithJSON:res[@"data"][0]];
            
            [launchImageView sd_setImageWithURL:[NSURL URLWithString:[tempModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"wel_bg"]];
            
            UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                if (tempModel.infoid.length > 0 && ([tempModel.ishy isEqualToString:@"0"] || [tempModel.ishy isEqualToString:@"3"])) {
                    WY_OnlineTrainDetailsViewController *tempController = [WY_OnlineTrainDetailsViewController new];
                    WY_TrainItemModel *tempModelA = [WY_TrainItemModel new];
                    tempModelA.rowGuid = tempModel.infoid;
                    tempModelA.ishy = tempModel.ishy;
                    tempController.mWY_TrainItemModel = tempModelA;
                    tempController.title = @"在线视频培训";
                    MS_TabBarController * tempTabBarController = (MS_TabBarController *)weakSelf.window.rootViewController; [tempTabBarController.selectedViewController pushViewController:tempController animated:YES];
                    
                    launchImageView.alpha = 0.0;
                    launchImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    weakSelf.timeBtn.hidden = YES;
                    [weakSelf.timer invalidate];
                }
            }];
            [launchImageView setUserInteractionEnabled:YES];
            [launchImageView addGestureRecognizer:tapGest];
            
            [weakSelf.timeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                launchImageView.alpha = 0.0;
                launchImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                weakSelf.timeBtn.hidden = YES;
                [weakSelf.timer invalidate];
            }];
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
                weakSelf.second--;
                [weakSelf.timeBtn setTitle:[NSString stringWithFormat:@"跳过(%lds)", weakSelf.second] forState: UIControlStateNormal];
                if (weakSelf.second <= 1) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:1.2 animations:^{
                            launchImageView.alpha = 0.0;
                            launchImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                            weakSelf.timeBtn.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [launchImageView removeFromSuperview];
                        }];
                    });
                    [timer invalidate];
                }
            } repeats:YES];
        }
    } failure:^(NSError *error) {
        launchImageView.alpha = 0.0;
        launchImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        weakSelf.timeBtn.hidden = YES;
    }];
}

- (UIButton *)timeBtn {
    if (!_timeBtn) {
        CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
        _timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 20 + height, 70, 30)];
        [_timeBtn setTitle:[NSString stringWithFormat:@"跳过(%lds)", self.second] forState: UIControlStateNormal];
        [_timeBtn setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
        _timeBtn.backgroundColor = HEXCOLOR(0xdddddd);
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _timeBtn.layer.masksToBounds = YES;
        _timeBtn.layer.cornerRadius = 5;
    }
    return _timeBtn;
}
- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
    
}

- (void)configBaiduFace {
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
    NSLog(@"version = %@",[[FaceVerifier sharedInstance] getVersion]);
}

//- (void)configUSharePlatforms
//{
//    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd2381bec1a8984de" appSecret:@"28d1d51ae81ce691a074aca9fce301e1" redirectURL:@"http://mobile.umeng.com/social"];
//
//    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9669fbcace176fd7" appSecret:@"6427bec482fe595fc88fc0edf749327c" redirectURL:@"http://mobile.umeng.com/social"];
//
//}

#pragma mark APNs Register
/**
 *    向APNs注册，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        // 创建category，并注册到通知中心
        [self createCustomNotificationCategory];
        _notificationCenter.delegate = self;
        // 请求推送权限
        [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                // 向APNs注册，获取deviceToken
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
}

/**
 *  主动获取设备通知是否授权(iOS 10+)
 */
- (void)getNotificationSettingStatus {
    [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            NSLog(@"User authed.");
        } else {
            NSLog(@"User denied.");
        }
    }];
}

/*
 *  APNs注册成功回调，将返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //    NSLog(@"Upload deviceToken to CloudPush server.");
    //    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
    //        if (res.success) {
    //            NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
    //        } else {
    //            NSLog(@"Register deviceToken failed, error: %@", res.error);
    //        }
    //    }];
    
    // [3]:向个推服务器注册deviceToken 为了方便开发者，建议使用新方法
    [GeTuiSdk registerDeviceTokenData:deviceToken];
    
}

/*
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *  创建并注册通知category(iOS 10+)
 */
- (void)createCustomNotificationCategory {
    // 自定义`action1`和`action2`
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
    // 创建id为`test_category`的category，并注册两个action到category
    // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:
                                        UNNotificationCategoryOptionCustomDismissAction];
    // 注册category到通知中心
    [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
//- (void)handleiOS10Notification:(UNNotification *)notification {
//    UNNotificationRequest *request = notification.request;
//    UNNotificationContent *content = request.content;
//    NSDictionary *userInfo = content.userInfo;
//    // 通知时间
//    NSDate *noticeDate = notification.date;
//    // 标题
//    NSString *title = content.title;
//    // 副标题
//    NSString *subtitle = content.subtitle;
//    // 内容
//    NSString *body = content.body;
//    // 角标
//    int badge = [content.badge intValue];
//    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
//    NSString *extras = [userInfo valueForKey:@"Extras"];
//    // 通知角标数清0
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    // 同步角标数到服务端
//    [self syncBadgeNum:badge];
//    // 通知打开回执上报
//    [CloudPushSDK sendNotificationAck:userInfo];
//    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
//
//
//
//
//
//
//
//}

/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");


    // 处理iOS 10通知，并上报通知打开回执
//    [self handleiOS10Notification:notification];
    // 通知不弹出
    completionHandler(UNNotificationPresentationOptionNone);
    
    // 通知弹出，且带有声音、内容和角标
    //completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);

    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
    
    //    NSString *userAction = response.actionIdentifier;
    //    // 点击通知打开
    //    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
    //        NSLog(@"User opened the notification.");
    //        // 处理iOS 10通知，并上报通知打开回执
    //        [self handleiOS10Notification:response.notification];
    //    }
    //    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    //    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
    //        NSLog(@"User dismissed the notification.");
    //    }
    //    NSString *customAction1 = @"action1";
    //    NSString *customAction2 = @"action2";
    //    // 点击用户自定义Action1
    //    if ([userAction isEqualToString:customAction1]) {
    //        NSLog(@"User custom action1.");
    //    }
    //
    //    // 点击用户自定义Action2
    //    if ([userAction isEqualToString:customAction2]) {
    //        NSLog(@"User custom action2.");
    //    }
    //    completionHandler();
}

#pragma mark SDK Init
- (void)initCloudPush {
    // 正式上线建议关闭
//    [CloudPushSDK turnOnDebug];
    // SDK初始化，手动输出appKey和appSecret
    //    [CloudPushSDK asyncInit:testAppKey appSecret:testAppSecret callback:^(CloudPushCallbackResult *res) {
    //        if (res.success) {
    //            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
    //        } else {
    //            NSLog(@"Push SDK init failed, error: %@", res.error);
    //        }
    //    }];
    
    // SDK初始化，无需输入配置信息
    // 请从控制台下载AliyunEmasServices-Info.plist配置文件，并正确拖入工程
//    [CloudPushSDK autoInit:^(CloudPushCallbackResult *res) {
//        if (res.success) {
//            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
//        } else {
//            NSLog(@"Push SDK init failed, error: %@", res.error);
//        }
//    }];
}
/** 个推 SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:clientId forKey:@"clientId"];
    [userdef synchronize];
}

/** 个推 SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",payloadMsg);
    WY_PushModel *tempModel = [WY_PushModel modelWithJSON:payloadData];
    //     if (offLine) {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"通知消息" message:tempModel.content preferredStyle:UIAlertControllerStyleAlert];
    if (tempModel && ([tempModel.type isEqualToString:@"3"] || [tempModel.type isEqualToString:@"4"]|| [tempModel.type isEqualToString:@"6"]|| [tempModel.type isEqualToString:@"7"])) {
        UIAlertAction * alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:alertCancel];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"查看通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self toMessageInfo:tempModel];
        }];
        [alert addAction:ok];
    } else if (tempModel && [tempModel.type isEqualToString:@"5"]) {
        UIAlertAction * alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:alertCancel];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"完善信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self toMessageInfo:tempModel];
        }];
        [alert addAction:ok];
    } else {
        UIAlertAction * alertCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:alertCancel];
        
    }
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    //    }
}


- (void)toMessageInfo:(WY_PushModel *)mesModel {
    //更新消息状态； 更新后-进入个人考核页；
    MS_TabBarController *tab = self.window.rootViewController;

    if (mesModel && ([mesModel.type isEqualToString:@"3"] || [mesModel.type isEqualToString:@"4"])) {
        if  ([[MS_BasicDataController sharedInstance].user.UserType isEqualToString:@"1"]) {
//            [self VFace];
            //3 是收到评标通知；
            //4 是开始签到；
            NSLog(@"进入功能");
            [self goHomePageItemByIndex];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"您不是专家无法查看此功能"];
        }
    }else if (mesModel && [mesModel.type isEqualToString:@"5"]) {
        NSLog(@"进入完善功能；");

        if  ([[MS_BasicDataController sharedInstance].user.UserType isEqualToString:@"1"]) {
            NSLog(@"进入专家身份列表");
            WY_ExpertStatusViewController *tempController = [WY_ExpertStatusViewController new];
             [tab.selectedViewController pushViewController:tempController animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"您还不是专家，无法查看此功能"];
            
        }
        
    } else if (mesModel && [mesModel.type isEqualToString:@"6"]) {
         WY_ZJPushMsgViewController *tempController = [WY_ZJPushMsgViewController new];
        [tab.selectedViewController pushViewController:tempController animated:YES];
    } else if (mesModel && [mesModel.type isEqualToString:@"7"]) {
        //type=7 跳转到订单列表页
        WY_CAOrderMainViewController *tempController = [WY_CAOrderMainViewController new];
        tempController.selZJIndex = 1;
        tempController.hidesBottomBarWhenPushed = YES;
        [tab.selectedViewController pushViewController:tempController animated:YES];    } else {
            return;
        
            
    }
}
///验证人脸
- (void) VFace {
    //开始人脸识别；
    MS_TabBarController *tab = self.window.rootViewController;
    
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
    [tab.selectedViewController presentViewController:navi animated:NO completion:nil];
    WS(weakSelf);
    lvc.faceSuceessBlock = ^(UIImage *imgFace) {
        //人脸 识别成功后- 调用接口
        //            [weakSelf submitData:imgFace];
        
        [weakSelf performSelectorOnMainThread:@selector(submitData:) withObject:imgFace waitUntilDone:YES];
    };
}

- (void)submitData:(UIImage *)imgFace {
    WY_UserModel *mUser  = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:mUser.realname forKey:@"name"];
    [dicPost setObject:mUser.idcardnum forKey:@"idCard"];
    [dicPost setObject:mUser.LoginID forKey:@"loginId"];
    [dicPost setObject:[self UIImageToBase64Str:imgFace] forKey:@"base64Str"];
    MS_TabBarController *tab = self.window.rootViewController;
    
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:ZJsmrzxx_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        
        if ([code integerValue] == 0 && res) {
            //            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            
            [tab.selectedViewController.view makeToast:res[@"msg"]];
            NSLog(@"进入功能");
            [self goHomePageItemByIndex];
            
        } else {
            if ([code integerValue] == 2)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"比对不一致，请准备以下资料发至lnwlzb@163.com邮箱\n（1、身份证正反面；\n2、近期照片；\n3、超时截图；\n4、姓名及联系方式）。" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"我已了解" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [tab.selectedViewController presentViewController:alertController animated:YES completion:nil];
                return;
            }
            //            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            [tab.selectedViewController.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        [tab.selectedViewController.view makeToast:@"请求失败，请稍后再试"];
        
    }];
}
//待评项目
- (void)goHomePageItemByIndex {
    MS_TabBarController *tab = self.window.rootViewController;
    
    WY_BiddingProjectListViewController *tempController = [WY_BiddingProjectListViewController new];
    tempController.nstype = @"1";
    tempController.title = @"评标通知";
    [tab.selectedViewController pushViewController:tempController animated:YES];
    
}
//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
#pragma mark Notification Open
/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    //    // 取得APNS通知内容
    //    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    // 内容
    //    NSString *content = [aps valueForKey:@"alert"];
    //    // badge数量
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    //    // 播放声音
    //    NSString *sound = [aps valueForKey:@"sound"];
    //    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    //    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    //    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    
    //    // 同步通知角标数到服务端
    //     [self syncBadgeNum:badge];
    //    // 通知打开回执上报
    //    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    //    [CloudPushSDK sendNotificationAck:userInfo];
    
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    self.isLaunchedByNotification = YES;
}

#pragma mark Channel Opened
/**
 *    注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}

/**
 *    推送通道打开回调
 *
 *    @param     notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
    
}

#pragma mark Receive Message
/**
 *    @brief    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

///**
// *    处理到来推送消息
// *
// *    @param     notification
// */
//- (void)onMessageReceived:(NSNotification *)notification {
//    NSLog(@"Receive one message!");
//
//    CCPSysMessage *message = [notification object];
//    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
//    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
//    NSLog(@"Receive message title: %@, content: %@.", title, body);
//
//    //    LZLPushMessage *tempVO = [[LZLPushMessage alloc] init];
//    //    tempVO.messageContent = [NSString stringWithFormat:@"title: %@, content: %@", title, body];
//    //    tempVO.isRead = 0;
//    //
//    //    if(![NSThread isMainThread]) {
//    //        dispatch_async(dispatch_get_main_queue(), ^{
//    //            if(tempVO.messageContent != nil) {
//    //                [self insertPushMessage:tempVO];
//    //            }
//    //        });
//    //    } else {
//    //        if(tempVO.messageContent != nil) {
//    //            [self insertPushMessage:tempVO];
//    //        }
//    //    }
//}


///* 同步通知角标数到服务端 */
//- (void)syncBadgeNum:(NSUInteger)badgeNum {
//    [CloudPushSDK syncBadgeNum:badgeNum withCallback:^(CloudPushCallbackResult *res) {
//        if (res.success) {
//            NSLog(@"Sync badge num: [%lu] success.", (unsigned long)badgeNum);
//        } else {
//            NSLog(@"Sync badge num: [%lu] failed, error: %@", (unsigned long)badgeNum, res.error);
//        }
//    }];
//}


//- (void)configJPush:(NSDictionary*)launchOptions
//{
//    // Required
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    } else {
//        //categories nil
//        [JPUSHService
//         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |
//                                             UIRemoteNotificationTypeAlert)
//
//         // Required
//         categories:nil];
//    }
//
//    //旧版
//    //    [JPUSHService setupWithOption:launchOptions];
//
//
//    [JPUSHService setupWithOption:launchOptions appKey:JPush_KEY
//                          channel:nil apsForProduction:NO];
//
////    //注册自定义消息通知
////    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
////    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
//}


//网络请求
- (MS_BasicDataController *)basicData {
    
    if (!_basicData) {
        
        _basicData = [MS_BasicDataController new];
        
    }
    
    return _basicData;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    [self syncBadgeNum:0];
    
    //保存当前时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"currentDate"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateApp" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getLoction" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPayUserData" object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[LGCheckVersion shareCheckVersion] checkVersion];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"searLocation" object:nil];

//    [self syncBadgeNum:0];
    application.applicationIconBadgeNumber=1;
    application.applicationIconBadgeNumber=0;
    
} 

//当应用程序被用户从远程通知中选择操作时激活。调用该方法处理程序（ iOS(8_0, 10_0）)
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    
}

//iOS 7+  //不论是前台还是后台只要有远程推送都会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    NSLog(@"========================前台后台都会调用");
    
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    self.isLaunchedByNotification = YES;
    /*
     建议使用该方法，还有一个作用。根据苹果给出的文档，系统给出30s的时间对推送的消息进行处理，此后就会运行CompletionHandler程序块。
     在处理这类推送消息（即程序被启动后接收到推送消息）的时候，通常会遇到这样的问题，
     就是当前的推送消息是当前程序正在前台运行时接收到的，还是说是程序在后台运行，用户点击系统消息通知栏对应项进入程序时而接收到的？这个其实很简单，用下面的代码就可以解决：
     */
    
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"active");
        //程序当前正处于前台
        
        /*关于userInfo的结构，参照苹果的官方结构：
         {
         "aps" : {
         "alert" : "You got your emails.",
         "badge" : 9,
         "sound" : "bingbong.aiff"
         "acme1" : "bar",
         "acme2" : 42
         }
         即key aps对应了有一个字典，里面是该次推送消息的具体信息。具体跟我们注册的推送类型有关。另外剩下的一些key就是用户自定义的了。
         */
        
    }
    else if(application.applicationState == UIApplicationStateInactive)
    {
        NSLog(@"inactive");
        //程序处于后台
        
    }
    
}


//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", userInfo);
//
//    //把角标设位置为0
//    //    UIApplication *application = [UIApplication sharedApplication];
//    //    [application setApplicationIconBadgeNumber:unreadCount];
//
//    application.applicationIconBadgeNumber = 0;
//
//    [JPUSHService setBadge:0];
//}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//
//
//    // Required
//    [JPUSHService registerDeviceToken:deviceToken];
//
//    //    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
//}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
////    [self checkNotifiWithDic:userInfo];
//    // IOS 7 Support Required
//    [JPUSHService handleRemoteNotification:userInfo];
//
//    [self checkNotifiWithDic:userInfo];
//
//
//
//    completionHandler(UIBackgroundFetchResultNewData);
//}

- (void)checkNotifiWithDic:(NSDictionary *)launchOptions {
    
    
    //判断是否超时
    NSDate * lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"];
    
    //如果时间为空或者超过3秒则忽略
    if (!lastDate || [[NSDate date] timeIntervalSinceDate:lastDate] > 3) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lotType" object:nil];
    });
    
}
//// 注册deviceToken失败
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
//    //    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
//    NSLog(@"error -- %@",error);
//}



-(BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chenggong" object:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付宝支付结果" message:resultDic[@"memo"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        return YES;
    } else {
        [WXApi handleOpenURL:url delegate:self];
        return YES;
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chenggong" object:nil];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付宝支付结果" message:resultDic[@"memo"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        return YES;
    } else {
        [WXApi handleOpenURL:url delegate:self];
        return YES;
    }
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
//    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
//    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"chenggong" object:nil];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付宝支付结果" message:resultDic[@"memo"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            return YES;
        } else {
            [WXApi handleOpenURL:url delegate:self];
        }
         return YES;
    

//    return YES;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [SJRotationManager supportedInterfaceOrientationsForWindow:window];
//    return UIInterfaceOrientationMaskAll;
}
 

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = @"发送媒体消息结果";
    }
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"恭喜您，支付成功!";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chenggong" object:nil];

//                [MYNotificationCenter postNotificationName:@"weixinPaystatusSuccess" object:nil userInfo:@{@"status":@"success"}];
                
                break;
            }
            case WXErrCodeUserCancel:{
                strMsg = @"已取消支付!";
//                [MYNotificationCenter postNotificationName:@"weixinPaystatusSuccess" object:nil userInfo:@{@"status":@"cancle"}];
                break;
            }
            default:{
                
                strMsg = [NSString stringWithFormat:@"支付失败 !"];
//                [MYNotificationCenter postNotificationName:@"weixinPaystatusSuccess" object:nil userInfo:@{@"status":@"cancle"}];
                break;
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}


@end

#pragma mark -


#warning Configuring rotation control. 请配置旋转控制!

@implementation UIViewController (RotationControl)
///
/// 控制器是否可以旋转
///
- (BOOL)shouldAutorotate {
    return NO;
}

///
/// 控制器旋转支持的方向
///
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     // 如果self不支持旋转, 返回仅支持竖屏
    if ( self.shouldAutorotate == NO ) {
         return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end


@implementation UITabBarController (RotationControl)
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
@end

@implementation UINavigationController (RotationControl)
- (BOOL)shouldAutorotate {
//    return self.topViewController.shouldAutorotate;
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end

