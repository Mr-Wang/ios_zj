//
//  WY_ZJHomeViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/21.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ZJHomeViewController.h"
#import "SDCycleScrollView.h"
#import "WY_HomeItemView.h"
#import "WY_LoginViewController.h"
#import "WY_AnnouncementView.h"
#import "WY_IndexModel.h"
#import "WY_HomeVideoItemTableViewCell.h"
#import "WY_ReadItemTableViewCell.h"
#import "WY_LearningTrackMainViewController.h"
#import "WY_VideoZoneItemViewController.h"
#import "WY_ReadZoneItemViewController.h"
#import "WY_IDCarSettingViewController.h"
#import "WY_SelectCompanyViewController.h"
#import "WY_VideoDetailsViewController.h"
#import "WY_ReadZoneDetailsViewController.h"
#import "WY_OnlineTrainDetailsViewController.h"
#import "WY_ZJPushMsgViewController.h"
#import "WY_SearchExpertViewController.h"

#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>

#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "WY_BiddingProjectListViewController.h"
#import "WY_MessageModel.h"

#import "WY_TrainDetailsViewController.h"
#import "WY_OnlineTrainDetailsViewController.h"
#import "WY_MyCreditViewController.h"
#import "WY_PerfectInfoViewController.h"
#import "WY_HomeHotCourseView.h"
#import "WY_TrainTabMainViewController.h"
#import "WY_HomeArticleView.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_ReceptionHallViewController.h"
#import "WY_ExpertStatusViewController.h"
#import "WY_HistoryProjMainViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_CAHandleViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>
#import "WY_DocListViewController.h"
#import "WY_CAPaySuccessViewController.h"
#import "WY_HomePageViewController.h"
#import "MS_NavigationController.h"
#import "WY_ConsultingListViewController.h"
#import "WY_AddBankCardViewController.h"

#import "WY_CS_AlertPageViewController.h"
#import "WY_ExpertFeeMainViewController.h"
#import "WY_ExpertEvaluationMainViewController.h"
#import "M13BadgeView.h"
#import "WY_InfoConfirmViewController.h"
#import "WY_UserInfoViewController.h"

@interface WY_ZJHomeViewController ()
{
    NSString *latitude;
    NSString *longitude;
    CGFloat topHeight;
    CGFloat bottomHeight;
    CGFloat beginContentY;          //开始滑动的位置
    
    UIImageView *imgTopBg;  //顶部曲线图片
    UIView *viewItem;   //顶部Items
    UIView *viewAnnouncement;   //公告View
    UIImageView *imgNew;
    WY_AnnouncementView *tempAnnView; //公告滚动View
    WY_HomeVideoItemTableViewCell *vvContentView;
    
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
    UIView *viewTzgg;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) SDCycleScrollView *headerView;
@property (nonatomic, strong) NSMutableArray *arrIcons;
@property (nonatomic, strong) WY_IndexModel *mWY_IndexModel;

@property (nonatomic, strong) WY_UserModel *mUser;
///身份证OCR结果
@property (nonatomic, strong) NSMutableDictionary *dicIDCard;
@property (nonatomic, strong) NSString *isIdCardSuccess;
//是否是注册后补全
@property (nonatomic, strong) NSString *isBuQuan;
@property (nonatomic, strong) WY_HomeItemView *selItem;
@property (nonatomic) NSTimeInterval mUpdateDate;

/// 是否锁定
@property (nonatomic) int isLocked;


@property (nonatomic, strong) UIView *viewGG;
@property (nonatomic, strong) UIImageView *imgGG;
@property (nonatomic, strong) UIButton *btnGGClose;

//热门课程 View
@property (nonatomic, strong) WY_HomeHotCourseView *mWY_HomeHotCourseView;
//法律法规 View
@property (nonatomic, strong) WY_HomeArticleView *mWY_HomeArticleView;

//专家完善信息状态Label
@property (nonatomic, strong) UILabel *lblWanShanState;
@property (nonatomic,strong) AMapLocationManager  *locationManager;

@end

@implementation WY_ZJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //默认是全部
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    [self configCallback];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ExpertIsMind"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self initPush];
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserver:self selector:@selector(initPush) name:@"INITLOGINPUSH" object:nil];
    
    [notifyCenter addObserver:self selector:@selector(pushSetIdcarNotify:) name:@"PUSHSETIDCARNOTIFY" object:nil];
    [notifyCenter addObserver:self selector:@selector(updateFontSizeNotify:) name:@"UPDATEFONTSIZENOTIFY" object:nil];
    
    //    [notifyCenter addObserver:self selector:@selector(pushSetOrgInfoNotify:) name:@"PUSHSETORGINFONOTIFY" object:nil];
    
    [notifyCenter addObserver:self selector:@selector(reLogin) name:NOTIFY_RELOGIN object:nil];
    [notifyCenter addObserver:self selector:@selector(reLoginAA) name:@"NOTIFY_RELOGINAA" object:nil];
    
    [notifyCenter addObserver:self selector:@selector(searLocation) name:@"searLocation" object:nil];
    
    
    
    [self makeUI];
    //    [self performSelector:@selector(bindVip) afterDelay:1];
    
    //        [self pushSetIdcarNotify:nil];
    //    [self pushSetOrgInfoNotify:nil];
    
    //获取字典数据
    [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_dictionary_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
            [userdefA setObject:[res[@"data"] mj_JSONString] forKey:@"ZJ_DIC"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
    }];
    
    
}

//查用户是否已开启定位权限
- (void)searLocation {
    // 判断定位操作是否被允许
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    if (self.mUser.idcardnum.length > 0) {
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        [dicPost setObject:self.mUser.idcardnum forKey:@"idcardnum"];
        [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getZjAddressesStatus_HTTP params:dicPost jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
            if ([code integerValue] == 0) {
                //需要定位
                if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
                    NSLog(@"定位可用");
                    //定位
                    if (self.locationManager == nil) {
                        self.locationManager = [[AMapLocationManager alloc] init];
                        [self.locationManager setDelegate:self];
                        // 带逆地理信息的一次定位（返回坐标和地址信息）
                        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
                        //   定位超时时间，最低2s，此处设置为5s
                        self.locationManager.locationTimeout =5;
                    }
                    [self.locationManager startUpdatingLocation];
                    
                }else {
                    //提示用户无法进行定位操作
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您没有开启定位权限 ,请开启定位" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                            if (@available(iOS 10.0, *)) {
                                [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
                            } else {
                                [[UIApplication sharedApplication] openURL:settingsURL];
                            }
                        }
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"确定");
                        [self searLocation];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            } else {
                //不需要定位
                NSLog(@"不需要定位");
                if (self.locationManager !=nil) {
                    [self.locationManager stopUpdatingLocation];
                }
            }
        } failure:^(NSError *error) {
            //            [self.view makeToast:@"请求失败，请稍后再试"];
        }];
        
    }
}

- (void)bindVip {
    NSDate * lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"VipGGDate"];
    if (!lastDate) {
        //如果没有弹出过，
        [self initGG];
    }
    
    
}
///加在会员广告；
- (void)initGG {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"VipGGDate"];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    self.viewGG = [UIView new];
    [window addSubview: self.viewGG];
    //    [self.viewGG setHidden:YES];
    [self.viewGG setFrame:window.bounds];
    
    [self.viewGG setBackgroundColor:MHColorFromRGBAlpha(0x000000, 0.5)];
    
    self.btnGGClose = [UIButton new];
    [self.btnGGClose setFrame:CGRectMake(k375Width(18), kScreenHeight - k375Width(330), kScreenWidth - k375Width(34), k375Width(330))];
    [self.btnGGClose setBackgroundImage:[UIImage imageNamed:@"0713_fontsize"] forState:UIControlStateNormal];
    [self.viewGG addSubview:self.btnGGClose];
    [self.btnGGClose addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.viewGG setHidden:YES];
    }];
}


- (void)reLoginAA{
    WY_LoginViewController *tempController = [WY_LoginViewController new];
    tempController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
}
- (void)reLogin {
    [self performSelector:@selector(goLoginViewPage) afterDelay:0.5];
    
}
-(void)goLoginViewPage {
    WY_LoginViewController *tempController = [WY_LoginViewController new];
    tempController.modalPresentationStyle = UIModalPresentationFullScreen;
    tempController.isreLogin = @"1";
    [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [self dataSourceIndex];
    [self zjExpertGetExpertIsMind];
    //    此功能不合规，暂时关闭
    //    [self searLocation];
}

- (void)zjExpertGetExpertIsMind {
    if([MS_BasicDataController sharedInstance].user != nil && self.mUser.idcardnum.length > 0) {
        WS(weakSelf);
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        [dicPost setObject:self.mUser.idcardnum forKey:@"idcard"];
        [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_expert_getExpertIsMind_HTTP params:dicPost jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
            if ([code integerValue] == 0 && res) {
                ///专家- 查询是是不是社会专家，社会紫（超龄）1、社会蓝（甲方）2
                [[NSUserDefaults standardUserDefaults] setInteger:[res[@"data"] intValue] forKey:@"ExpertIsMind"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else {
                //                 [self.view makeToast:res[@"msg"]];
            }
        } failure:^(NSError *error) {
            //         [self.view makeToast:@"请求失败，请稍后再试"];
            
        }];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark --绘制页面
- (void)makeUI {
    //顶部曲面图片
    imgTopBg = [[UIImageView alloc] init];
    [imgTopBg setFrame:CGRectMake(0, JCNew64, kScreenWidth + 2, 128)];
    //    [imgTopBg setImage:[UIImage imageNamed:@"1010_syTop"]];
    [self.view addSubview:imgTopBg];
    //顶部导航栏View；
    UIView *navView = [[UIView alloc] init];
    [navView setFrame:CGRectMake(0, 0, kScreenWidth, JCNew64)];
    [navView setBackgroundColor:HEXCOLOR(0x448EEE)];
    
    //    UIImageView *imgNavBg = [[UIImageView alloc] init];
    //    [imgNavBg setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(50))];
    //    [imgNavBg setImage:[UIImage imageNamed:@"1127_dingbubujing"]];
    //    [navView addSubview:imgNavBg];
    //搜索功能
    
    UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0521_ss"]];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
    loginImgV.center = lv.center;
    [lv addSubview:loginImgV];
    
    UITextField *txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(k375Width(16), MH_APPLICATION_STATUS_BAR_HEIGHT + k360Width(10), k375Width(305), k375Width(25))];
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    txtSearch.leftView = lv;
    [txtSearch setFont:WY_FONTRegular(14)];
    //    [txtSearch setPlaceholder:@"搜索你感兴趣的内容"];
    [txtSearch rounded:k375Width(25 / 8)];
    [txtSearch setBackgroundColor:MSColorA(255, 255, 255, 0.22)];
    [txtSearch setUserInteractionEnabled:NO];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"搜索你的已评标项目"];
    [attStr setYy_color:[UIColor whiteColor]];
    txtSearch.attributedPlaceholder = attStr;
    UIControl *colSearch = [[UIControl alloc] initWithFrame:txtSearch.frame];
    colSearch.tag = 1001;
    [colSearch setBackgroundColor:[UIColor clearColor]];
    [colSearch addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        [self itemBtnAction:sender];
        
    }];
    [navView addSubview:txtSearch];
    [navView addSubview:colSearch];
    
    
    
    //消息功能；
    UIButton *btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(txtSearch.right + k375Width(16), txtSearch.top + k375Width(4), k375Width(22), k375Width(22))];
    [btnMessage setBackgroundImage:[UIImage imageNamed:@"0521消息"] forState:UIControlStateNormal];
    [btnMessage addTarget:self action:@selector(btnMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btnMessage];
    
    
    navView.height = txtSearch.bottom + k360Width(10);
    
    //专家完善信息状态
    self.lblWanShanState = [UILabel new];
    
    self.mScrollView = [[UIScrollView alloc] init];
    [self.mScrollView setFrame:CGRectMake(0, navView.bottom, kScreenWidth, kScreenHeight - MH_APPLICATION_TAB_BAR_HEIGHT - navView.bottom)];
    [self.mScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.mScrollView];
    [self.mScrollView setDelegate:self];
    self.mScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
    [self.view addSubview:navView];
    
    
    // 头视图 banner
    self.headerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(k360Width(16),  k360Width(5), (int)(kScreenWidth - k360Width(32)), k360Width(150))];
    
    self.headerView.autoScrollTimeInterval = 5.0f;
    //    self.headerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.headerView.placeholderImage = [UIImage imageNamed:@"0211_CourseTop"];
    self.headerView.showPageControl = YES;
    [self.headerView rounded:k360Width(40/8)];
    [self.mScrollView addSubview:self.headerView];
    //    [self.headerView setHidden:YES];
    //    UIImageView *headImg = [UIImageView new];
    ////    [headImg setImage:[UIImage imageNamed:@"zjhometop"]];
    //
    //    //    [headImg sd_setImageWithURL:[NSURL URLWithString:@"https://study.capass.cn/Avatar/indextoppic.jpg"]];
    //        [headImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://study.capass.cn/Avatar/indextoppic.jpg"]]]];
    //
    //    [headImg setFrame:CGRectMake(0, 0, kScreenWidth, k375Width(169))];
    //    [self.mScrollView addSubview:headImg];
    
    viewItem = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom, kScreenWidth, k375Width(224))];
    [viewItem setBackgroundColor:[UIColor whiteColor]];
    [self.mScrollView addSubview:viewItem];
    viewTzgg = [[UIView alloc] initWithFrame:CGRectMake(0, viewItem.bottom + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg];
    [self viewReadInit:viewTzgg withTitleStr:@"通知公告"];
    // viewAnnouncement -公告
    viewAnnouncement = [[UIView alloc] initWithFrame:CGRectMake(0, viewTzgg.bottom + k360Width(3) , kScreenWidth, k375Width(44))];
    [viewAnnouncement setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    //    [viewAnnouncement rounded:k360Width(40/8) width:1 color:HEXCOLOR(0xF3F3F3)];
    //    UIImageView *viewAnnouBg = [[UIImageView alloc] initWithFrame:viewAnnouncement.bounds];
    //    [viewAnnouBg setImage:[UIImage imageNamed:@"消息矩形"]];
    tempAnnView = [[WY_AnnouncementView alloc] initWithFrame:viewAnnouncement.bounds];
    
    //    [viewAnnouncement addSubview:viewAnnouBg];
    [viewAnnouncement addSubview:tempAnnView];
    [self.mScrollView addSubview:viewAnnouncement];
    imgNew = [UIImageView new];
    [self.mScrollView addSubview:imgNew];
    // 热门课程
    self.mWY_HomeHotCourseView = [[WY_HomeHotCourseView alloc] initWithFrame:CGRectMake(0, viewAnnouncement.bottom, kScreenWidth, k360Width(195))];
    [self.mScrollView addSubview:self.mWY_HomeHotCourseView];
    
    self.mWY_HomeArticleView = [[WY_HomeArticleView alloc] initWithFrame:CGRectMake(0, self.mWY_HomeHotCourseView.bottom, kScreenWidth, k360Width(195))];
    [self.mScrollView addSubview:self.mWY_HomeArticleView];
    
    
}
//修改了字体
- (void)updateFontSizeNotify:(NSNotification *)notifySender {
    [self.view removeAllSubviews];
    [self makeUI];
    [self dataSourceIndex];
}
#pragma mark --通知消息-进入补充个人信息页面
- (void)pushSetIdcarNotify:(NSNotification *)notifySender {
    self.isBuQuan =@"1";
    self.selItem = nil;
    NSLog(@"通知消息-进入补充信息页面");
    [self performSelector:@selector(buquanIDCard) afterDelay:0.5];
    
    
}
- (void)buquanIDCard {
    //    要去掉百度身份证扫描识别OCR 功能，  改用公司自身 OCR 产品
    [SVProgressHUD showErrorWithStatus:@"请到个人信息页面完善身份证号和姓名"];
    WY_UserInfoViewController *tempController = [WY_UserInfoViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
    return;
    
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    if (self.mUser.idcardnum.length <= 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前用户没有身份证信息，是否现在进行完善身份证信息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:([UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goIDCarSettingPage];
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)goIDCarSettingPage {
    
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
        }
                                                     failHandler:_failHandler];
    }];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
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
        
        [self zjExpertGetExpertIsMind];
        WY_UserModel *tempUser = [WY_UserModel new];
        tempUser.idcardnum = idCardNum;
        tempUser.yhname = pName;
        tempUser.key = idCardNum;
        tempUser.userid = self.mUser.UserGuid;
        [self zhuanJiaLaQuByPost:tempUser];
    }
}
- (void)zhuanJiaLaQuByPost:(WY_UserModel *)tempUser {
    
    //2025-12-04 10:34:48  修改原因-甲方超龄专家被拦住了，修改为：如果是甲方专家- 不限制超龄（不调用 checkinjianguan），可进评标通知功能；
    if (EXPERTISMIND == 2) {
        [self goHomePageItemByIndex:self.selItem];
    }
    
    //    成功后 - 进行人脸识别；
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:checkinjianguan_HTTP params:nil jsonData:[tempUser toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
            currentUserModel.token = self.mUser.token;
            [MS_BasicDataController sharedInstance].user = currentUserModel;
            self.mUser = currentUserModel;
            //-2022-05-30 11:10:59 -add  这里只要code返回0 ，不管是否在库专家-都可以进入评标通知、评标历史列表页中；
            if (self.selItem.tag == 0 || self.selItem.tag == 1) {
                [self goHomePageItemByIndex:self.selItem];
                return;
            }
            //如果是专家- 跳转扫脸
            if  ([currentUserModel.UserType isEqualToString:@"1"]) {
                if (![self.isBuQuan isEqualToString:@"1"]) {
                    [self smrzxxIsBelow];
                } else {
                    [self.view makeToast:@"专家身份信息认证成功"];
                }
            } else {
                if (![self.isBuQuan isEqualToString:@"1"]) {
                    [SVProgressHUD showErrorWithStatus:@"您不是专家无法查看此功能"];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"普通用户身份信息认证成功"];
                }
            }
        } else {
            
            //2023-03-02 13:42:51- 修改需求 - 这里code返回1，需要判断提示中有禁用的，禁用专家放开专家信息功能；
            //2024-02-27 09:22:29 - 修改需求 -这里code返回1，需要判断提示中有禁用的，禁用 和佟哥确认-禁用专家不禁止相关功能 ， 入口全都放开正常进入；
//            if (self.selItem.tag == 4|| self.selItem.tag == 1) {
                if([res[@"msg"] rangeOfString:@"禁用"].length > 0) {
                    [self goHomePageItemByIndex:self.selItem];
//                } else {
//                    [self.view makeToast:res[@"msg"]];
//                }
            } else {
                [self.view makeToast:res[@"msg"]];
            }
             
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
    
}

///判断今天是否进行过人脸识别
- (void)smrzxxIsBelow {
    
    //工信部要求去掉人脸
    if (self.selItem) {
        [self goHomePageItemByIndex:self.selItem];
    }
    return;
    //临时加的 - 正常应去掉
    //#warning 临时加的 - 正常应去掉
    //    //不需要人脸识别
    //    if (self.selItem) {
    //        [self goHomePageItemByIndex:self.selItem];
    //    }
    //    return;
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:bidevaluationSmrzxxIsBelow_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            //不需要人脸识别
            if (self.selItem) {
                [self goHomePageItemByIndex:self.selItem];
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
        //            [weakSelf submitData:imgFace];
        
        [weakSelf performSelectorOnMainThread:@selector(submitData:) withObject:imgFace waitUntilDone:YES];
    };
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.isIdCardSuccess isEqualToString:@"1"]) {
        [self ocrSuccess];
    }
}

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
            if (self.selItem) {
                [self goHomePageItemByIndex:self.selItem];
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
            //            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    imgTopBg.alpha = (100 - scrollView.contentOffset.y) / 100;
}

- (void)dataSourceIndex {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [[MS_BasicDataController sharedInstance] postWithURL:getzjDefaultGetDefault_HTTP params:nil jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (successCallBack) {
            self.mWY_IndexModel = [WY_IndexModel modelWithJSON:successCallBack];
            [self bindView];
            [self dataSourceIndex2];
            // = 1的时候 弹出首页提示框
            if ([self.mWY_IndexModel.isAlert isEqualToString:@"1"] || [self.mWY_IndexModel.isAlert intValue] == 1) {
                [self temporaryPrompt];
            } 
            if (self.mUser.idcardnum != nil && ![self.mUser.idcardnum isEqualToString:@""]) {
                [self geetIsLock:NO];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"没有查询到数据"];
        }
        [self.mScrollView.mj_header endRefreshing];
        
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
        [self.mScrollView.mj_header endRefreshing];
    } ErrorInfo:^(NSError *error) {
        if (error.code == 401) {
            [SVProgressHUD showErrorWithStatus:@"登录失效，请重新登录"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        }
        [self.mScrollView.mj_header endRefreshing];
    }];
}


/// 获取是否锁定
- (void)geetIsLock:(BOOL)isCheck {
    //判断是否登录
    if([MS_BasicDataController sharedInstance].user != nil) {
        self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
        [[MS_BasicDataController sharedInstance] postWithReturnCode:expertIsLocked_HTTP params:@{@"idCard":self.mUser.idcardnum} jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
            NSLog(@"%@",code);
            
            self.isLocked = [res[@"data"][@"state"] intValue];
            if (isCheck) {
                // 是点击- 评标通知； - 判断锁定状态；如果data=0 不是专家、1正常、2锁定
                if (self.isLocked == 2){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"评标通知功能已锁定" message:res[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"我已了解" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [GlobalConfig makeCall:res[@"data"][@"phone"]];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                } else {
                    WY_UserModel *tempUser = [WY_UserModel new];
                    tempUser.idcardnum = self.mUser.idcardnum;
                    tempUser.yhname = self.mUser.realname;
                    tempUser.key = self.mUser.idcardnum;
                    tempUser.userid = self.mUser.UserGuid;
                    [self zhuanJiaLaQuByPost:tempUser];
                    
                }
            } else {
                //是首页加载后调用；判断状态； 如果data=0 不是专家、1正常、2锁定
                WY_HomeItemView *aBtTbtz = nil;
                for (WY_HomeItemView *aBt in [viewItem subviews]) {
                    if ([aBt isKindOfClass:[WY_HomeItemView class]]) {
                        aBtTbtz = aBt;
                        break;
                    }
                }
                if (self.isLocked == 2){
                    [aBtTbtz.imgIcon setImage:[UIImage imageNamed:@"zj_item1A"]];
                } else {
                    [aBtTbtz.imgIcon setImage:[UIImage imageNamed:@"zj_item1"]];
                }
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"获取专家锁定信息接口错误"];
        }];
        
        
    }
}

- (void)gotoTrainDetailsPage:(WY_TrainItemModel *)tempModel {
    if ([tempModel.categoryCode isEqualToString:@"A01"] || [tempModel.categoryCode isEqualToString:@"A02"] || [tempModel.categoryCode isEqualToString:@"A03"] || [tempModel.categoryCode isEqualToString:@"A04"] || [tempModel.categoryCode isEqualToString:@"A05"]) {
        WY_TrainDetailsViewController *tempController = [WY_TrainDetailsViewController new];
        tempController.title = @"课程详情";
        tempController.mWY_TrainItemModel = tempModel;
        [self.navigationController pushViewController:tempController animated:YES];
        
    } else {
        NSString *titleStr= @"";
        if ([tempModel.categoryCode isEqualToString:@"A06"]) {
            titleStr = @"录播课程";
        } else {
            titleStr = @"在线直播课程";
        }
        WY_OnlineTrainDetailsViewController *tempController = [WY_OnlineTrainDetailsViewController new];
        tempController.title = titleStr;
        tempController.mWY_TrainItemModel = tempModel;
        [self.navigationController pushViewController:tempController animated:YES];
    }
    
}

#pragma mark --绑定视图数据
- (void)bindView {
    //清空viewItem显示
    [viewItem removeAllSubviews];
    
    
    
    
    //填充ViewItem数据
    self.arrIcons = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    NSMutableDictionary *dic5 = [NSMutableDictionary new];
    NSMutableDictionary *dic6 = [NSMutableDictionary new];
    NSMutableDictionary *dic7 = [NSMutableDictionary new];
    
    
    [self.arrIcons addObject:dic1];
    [self.arrIcons addObject:dic3];
    [self.arrIcons addObject:dic4];
    [self.arrIcons addObject:dic5];
    [self.arrIcons addObject:dic6];
    [self.arrIcons addObject:dic7];
    
    if (self.isLocked == 2){
        [dic1 setObject:[UIImage imageNamed:@"zj_item1A"] forKey:@"img"];
    } else {
        [dic1 setObject:[UIImage imageNamed:@"zj_item1"] forKey:@"img"];
    }
    [dic3 setObject:[UIImage imageNamed:@"zj_item3"] forKey:@"img"];
    [dic4 setObject:[UIImage imageNamed:@"zj_item4A"] forKey:@"img"];
    
    [dic1 setObject:@"评标通知" forKey:@"title"];
    [dic3 setObject:@"专家评价" forKey:@"title"];
    [dic4 setObject:@"CA便捷办理" forKey:@"title"];
    
    
    [dic5 setObject:[UIImage imageNamed:@"zj_item5A"] forKey:@"img"];
    [dic6 setObject:[UIImage imageNamed:@"zj_item6"] forKey:@"img"];
    [dic7 setObject:[UIImage imageNamed:@"zj_item7A"] forKey:@"img"];
    
    [dic5 setObject:@"劳务报酬结算" forKey:@"title"];
    [dic6 setObject:@"专家信息" forKey:@"title"];
    [dic7 setObject:@"咨询投诉" forKey:@"title"];
    
    
    
    float Start_X  = k360Width(5);           // 第一个按钮的X坐标
    float Start_Y = k360Width(10);       // 第一个按钮的Y坐标
    float  Width_Space = 0;//k360Width(5);     // 2个按钮之间的横间距
    float  Height_Space = k360Width(1);// 竖间距
    float  Button_Height = k375Width(100);// 高
    float  Button_Width = (kScreenWidth - k360Width(10)) / 3; //k360Width(44);// 宽
    WY_HomeItemView *zjpjBtn = nil;
    //取出专家评价； -
    for (int i =0; i < self.arrIcons.count; i ++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        // 圆角按钮
        WY_HomeItemView *aBt = [[WY_HomeItemView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
        //               [aBt setBackgroundColor:[UIColor redColor]];
        NSMutableDictionary *dic = self.arrIcons[i];
        [aBt bindViewWith:dic[@"img"] titleStr:dic[@"title"]];
        //        if (i==5) {
        //            [aBt.lblTitle setFont:WY_FONTMedium(18)];
        //            [aBt.lblTitle setTextColor:HEXCOLOR(0xdc001d)];
        //        }
        if ([dic[@"title"] isEqualToString:@"专家评价"]) {
            zjpjBtn = aBt;
        }
        aBt.tag = i;
        [aBt addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewItem addSubview:aBt];
    }
    
    //获取专家评价未读数-  如果大于0 显示未读数
    
    [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_getExpertEvaluateUnReadCount_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if (![res[@"data"] isEqual:[NSNull null]]) {
                if ([res[@"data"] intValue] > 0) {
                    //                    M13BadgeView *badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 24.0, 24.0)];
                    //                    badgeView.text = res[@"data"];
                    //                    [zjpjBtn addSubview:badgeView];
                    
                    UIView * badgeSuperView = [[UIView alloc] initWithFrame:zjpjBtn.imgIcon.frame];
                    [badgeSuperView setUserInteractionEnabled:NO];
                    [zjpjBtn addSubview:badgeSuperView];
                    [badgeSuperView setBackgroundColor:[UIColor clearColor]];
                    M13BadgeView *badgeView = [[M13BadgeView alloc] init];
                    badgeSuperView.left = zjpjBtn.imgIcon.right;
                    badgeSuperView.top = zjpjBtn.imgIcon.top + k360Width(10);
                    badgeView.text = [NSString stringWithFormat:@"%@",res[@"data"]];
                    [badgeSuperView addSubview:badgeView];
                    
                }
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    //加载热门课程 -
    [self.mWY_HomeHotCourseView showBindView:self.mWY_IndexModel];
    WS(weakSelf)
    //点击Item
    [self.mWY_HomeHotCourseView setDidItemBlock:^(WY_TrainItemModel * _Nonnull withModel) {
        //判断登录状态
        if([MS_BasicDataController sharedInstance].user == nil) {
            WY_LoginViewController *tempController = [WY_LoginViewController new];
            tempController.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
            return;
        }
        [weakSelf gotoTrainDetailsPage:withModel];
    }];
    //点击更多
    [self.mWY_HomeHotCourseView setDidMoreBlock:^{
        
        //判断登录状态
        if([MS_BasicDataController sharedInstance].user == nil) {
            WY_LoginViewController *tempController = [WY_LoginViewController new];
            tempController.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
            return;
        }
        
        WY_TrainTabMainViewController *tempController = [WY_TrainTabMainViewController new];
        tempController.selZJIndex = 3;
        [weakSelf.navigationController pushViewController:tempController animated:YES];
        
    }];
    [self.mWY_HomeHotCourseView setDidUpdateHeightBlock:^{
        weakSelf.mWY_HomeArticleView.top = weakSelf.mWY_HomeHotCourseView.bottom + k360Width(5);
        [weakSelf.mScrollView setContentSize:CGSizeMake(kScreenWidth, weakSelf.mWY_HomeArticleView.bottom + k360Width(5))];
        
    }];
    
    self.mWY_HomeArticleView.top = self.mWY_HomeHotCourseView.bottom + k360Width(5);
    [self.mWY_HomeArticleView showBindView:self.mWY_IndexModel];
    
    [self.mWY_HomeArticleView setDidItemBlock:^(WY_InfomationModel * _Nonnull withModel) {
        //判断登录状态
        if([MS_BasicDataController sharedInstance].user == nil) {
            WY_LoginViewController *tempController = [WY_LoginViewController new];
            tempController.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
            return;
        }
        WY_ReadZoneDetailsViewController *tempController = [WY_ReadZoneDetailsViewController new];
        tempController.title = @"详情";
        tempController.mWY_InfomationModel = withModel;
        [weakSelf.navigationController pushViewController:tempController animated:YES];
    }];
    
    [self.mWY_HomeArticleView setDidMoreBlock:^{
        //这里改成跳转到学习主页-  阅读专区位置；
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        UITabBarController *tab = window.rootViewController;
        [tab setSelectedIndex:1];
        
        MS_NavigationController *aaNav = tab.selectedViewController;
        WY_HomePageViewController *aa = aaNav.topViewController;
        [aa.mScrollView setContentOffset:CGPointMake(0,k360Width(550)) animated:YES];
        
        
        
        //        WY_ReadZoneItemViewController *tempController = [WY_ReadZoneItemViewController new];
        //        tempController.idx = 0;
        //        tempController.isItemClicked = @"1";
        //        tempController.title = @"法律法规";
        //        [weakSelf.navigationController pushViewController:tempController animated:YES];
    }];
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, self.mWY_HomeArticleView.bottom + k360Width(5))];
    
}

- (void)temporaryPrompt {
    NSLog(@"临时弹出提示");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *dateString = [formatter stringFromDate: [NSDate date]];
    NSLog(@"当前日期：%@",dateString);
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSString *PromptDate =  [userdef objectForKey:@"PromptDate240605"];
    if (PromptDate) {
        if ([PromptDate isEqualToString:dateString]) {
            NSLog(@"今天已经打开过提示，不弹出了");
            return;
        }
    }
    //    如果用户没有设置身份证- 不提示银行卡信息 、 仅弹出应用正常提示
    if (![self.mUser.idcardnum isNotBlank]) {
        [self tishi2Ortishi3];
        return;
    }
    
    //判断专家是否已绑定银行卡 - 如未绑定 提示去绑定
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getExpertBank_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if (![res[@"data"] isEqual:[NSNull null]]) {
                NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                //银行卡信息 已完善- 则不提示银行内容bankAttributionCode
                if ([dicData[@"bankType"] isNotBlank] && [dicData[@"bankName"] isNotBlank] && [dicData[@"bankCard"] isNotBlank] && [dicData[@"bankAttributionCode"] isNotBlank]) {
                    [self tishi2Ortishi3];
                } else {
                    [self tishi1];
                }
            } else {
                [self tishi1];
            }
        } else {
            [self tishi1];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void) tishi1 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *dateString = [formatter stringFromDate: [NSDate date]];
    NSLog(@"当前日期：%@",dateString);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"您的银行卡信息未完善，请您完善银行卡信息"];
    [alertControllerMessageStr setYy_alignment:NSTextAlignmentCenter];
    [alertControllerMessageStr setYy_font:WY_FONT375Medium(12)];
    [alertControllerMessageStr setYy_lineSpacing:1];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [alertController addAction:([UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //规则 一天弹一回
        NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
        [userdefA setObject:dateString forKey:@"PromptDate240605"];
        WY_AddBankCardViewController *tempController = [WY_AddBankCardViewController new];
        [self.navigationController pushViewController:tempController animated:YES];
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //规则 一天弹一回
        NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
        [userdefA setObject:dateString forKey:@"PromptDate240605"];
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void) tishi2Ortishi3 {
    //判断专家是否已上传承诺书
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getCityExportUpd_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if (![res[@"data"] isEqual:[NSNull null]]) {
                NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                //承诺书已完善- 则不弹出提示tishi3
                //不是专家  = isaexpertIdNull
                // 有承诺书 = iscommitmentEleNewNull
                BOOL isaexpertIdNull = dicData[@"isTooltip"] == nil || [dicData[@"isTooltip"] isEqual:[NSNull null]] ||  [dicData[@"isTooltip"]  intValue] == 0;
                     if (isaexpertIdNull) {
                    [self tishi2];
                } else {
                    [self tishi3:dicData];
                }
            } else {
                [self tishi2];
            }
        } else {
            [self tishi2];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void) tishi2 {
    return;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *dateString = [formatter stringFromDate: [NSDate date]];
    NSLog(@"当前日期：%@",dateString);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"即日起，各评标专家在使用辽宁专家服务APP签到时，请认真阅读“评标专家告知承诺函”内容，同意并签署告知承诺函后再进行评标工作。" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"      即日起，各评标专家在使用辽宁专家服务APP签到时，请认真阅读“评标专家告知承诺函”内容，同意并签署告知承诺函后再进行评标工作。"];
    [alertControllerMessageStr setYy_alignment:NSTextAlignmentLeft];
    [alertControllerMessageStr setYy_font:WY_FONT375Medium(12)];
    [alertControllerMessageStr setYy_lineSpacing:1];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [alertController addAction:([UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //规则 一天弹一回
        NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
        [userdefA setObject:dateString forKey:@"PromptDate240605"];
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void) tishi3:(NSMutableDictionary *)dicData {
    WS(weakSelf)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *dateString = [formatter stringFromDate: [NSDate date]];
    NSLog(@"当前日期：%@",dateString);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:dicData[@"tooltipConcent"]];
    [alertControllerMessageStr setYy_alignment:NSTextAlignmentLeft];
    [alertControllerMessageStr setYy_font:WY_FONT375Medium(12)];
    [alertControllerMessageStr setYy_lineSpacing:1];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
//    jumpType 跳转类型0 单个确认按钮 "我知道了"   1 “取消、确定”、确认后跳转至 专家信息页， 2  “取消、确定”、确认后跳转至webview 页
    if([dicData[@"jumpType"] intValue] == 0) {
        [alertController addAction:([UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //规则 一天弹一回
            NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
            [userdefA setObject:dateString forKey:@"PromptDate240605"];
        }])];
    } else if([dicData[@"jumpType"] intValue] == 1) {
        [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //规则 一天弹一回
            NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
            [userdefA setObject:dateString forKey:@"PromptDate240605"];
            WY_ExpertStatusViewController *tempController = [WY_ExpertStatusViewController new];
            [self.navigationController pushViewController:tempController animated:YES];
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //规则 一天弹一回
            NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
            [userdefA setObject:dateString forKey:@"PromptDate240605"];
        }])];
    }  else if([dicData[@"jumpType"] intValue] == 2) {
//        jumpUrl 跳转网址
        [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //规则 一天弹一回
            NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
            [userdefA setObject:dateString forKey:@"PromptDate240605"];
            MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = dicData[@"jumpTitle"];
            wk.ishy = @"";
            wk.webviewURL = dicData[@"jumpUrl"];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:navi animated:NO completion:nil];
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //规则 一天弹一回
            NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
            [userdefA setObject:dateString forKey:@"PromptDate240605"];
        }])];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)dataSourceIndex2 {
    [[MS_BasicDataController sharedInstance] postWithURL:getStudySy_HTTP params:nil jsonData:nil showProgressView:NO success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (successCallBack) {
            WY_IndexModel *ggIndexModel = [WY_IndexModel modelWithJSON:successCallBack];
            
            NSMutableArray *arrAnnStrs = [[NSMutableArray alloc] init];
            for (WY_InfomationModel *annModel in ggIndexModel.webdbInformationTztgList) {
                [arrAnnStrs addObject:annModel.title];
            }
            //滚动公告内容 绑定：
            [tempAnnView setDelegate:self];
            [tempAnnView titleArr:arrAnnStrs];
            
            [imgNew setFrame:CGRectMake(kScreenWidth - k360Width(100), viewAnnouncement.top, k360Width(80), k360Width(30))];
            [imgNew setBackgroundColor:[UIColor clearColor]];
            [self.mScrollView addSubview:imgNew];
            //填充滚动条图片url 模拟
            
            NSMutableArray *arrImageUrl = [[NSMutableArray alloc] init];
            for (WY_ReShousListModel *rslModel in ggIndexModel.reShousList) {
                [arrImageUrl addObject:rslModel.url];
            }
            
            self.headerView.imageURLStringsGroup = arrImageUrl;
            //是否自动滚动- 接口控制
            if ([ggIndexModel.isAutoScroll isEqualToString:@"2"]) {
                self.headerView.autoScroll = NO;
            }
            
            WS(weakSelf)
            [self.headerView setClickItemOperationBlock:^(NSInteger currentIndex) {
                WY_ReShousListModel *rslModel = ggIndexModel.reShousList[currentIndex];
                NSLog(@"点击了ishy：%@",rslModel.ishy);
                if (rslModel.infoid.length > 0 && ([rslModel.ishy isEqualToString:@"0"] || [rslModel.ishy isEqualToString:@"3"])) {
                    WY_OnlineTrainDetailsViewController *tempController = [WY_OnlineTrainDetailsViewController new];
                    WY_TrainItemModel *tempModel = [WY_TrainItemModel new];
                    tempModel.rowGuid = rslModel.infoid;
                    tempModel.ishy = rslModel.ishy;
                    tempController.mWY_TrainItemModel = tempModel;
                    tempController.title = @"在线视频培训";
                    [weakSelf.navigationController pushViewController:tempController animated:YES];
                    return;
                }
                if ([rslModel.ishy isEqualToString:@"100"] || [rslModel.ishy isEqualToString:@"101"]) {
                    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
                    wk.titleStr = rslModel.title;
                    wk.ishy = rslModel.ishy;
                    wk.webviewURL = rslModel.infoid;
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
                    navi.navigationBarHidden = NO;
                    navi.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:navi animated:NO completion:nil];
                    return;
                }
                if ([rslModel.ishy isEqualToString:@"cns"]) {
                    WY_InfoConfirmViewController *tempController = [WY_InfoConfirmViewController new];
                    [self.navigationController pushViewController:tempController animated:YES];
                    return;
                }
            }];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"没有查询到数据"];
        }
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
        [self.mScrollView.mj_header endRefreshing];
    } ErrorInfo:^(NSError *error) {
        if (error.code == 401) {
            [SVProgressHUD showErrorWithStatus:@"登录失效，请重新登录"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        }
        [self.mScrollView.mj_header endRefreshing];
    }];
    
}


#pragma mark --公告Item点击事件
- (void)Announcement:(NSInteger )idx {
    NSLog(@"点击了公告：%ld",(long)idx);
    WY_ReadZoneItemViewController *tempController = [WY_ReadZoneItemViewController new];
    tempController.idx = 66;
    tempController.isItemClicked = @"1";
    tempController.title = @"通知公告";
    [self.navigationController pushViewController:tempController animated:YES];
    
}

#pragma mark --消息按钮点击事件
- (void)btnMessageAction {
    NSLog(@"点击了消息按钮");
    WY_ZJPushMsgViewController *tempController = [WY_ZJPushMsgViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
}

#pragma mark --icon按钮点击事件；
- (void)CABanLi {
    WY_CS_AlertPageViewController *tempController = [WY_CS_AlertPageViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
    
}

-(void)itemBtnAction:(WY_HomeItemView *)sender {
    //判断是否登录
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
        return;
    }
    
    //不是注册后
    self.isBuQuan = @"2";
    self.selItem = sender;
    
    //2024-04-11 20:42:27 劳务报酬结算 不做身份限定- 不调checkinjianguan -对齐尼玛颗粒度
    if (self.selItem.tag == 3) {
        [self goHomePageItemByIndex:self.selItem];
        return;
    }
    
    
    ///专家- 查询是是不是社会专家，社会紫（超龄）1、社会蓝（甲方）2
    if (sender.tag == 5) {
        NSLog(@"咨询投诉");
        if (EXPERTISMIND == 1 || EXPERTISMIND == 2) {
            [SVProgressHUD showErrorWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
            return;
        }
    }
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    if (self.mUser.idcardnum.length <= 0 || self.mUser.realname.length <= 0) {
        
        if (sender.tag == 5) {
            [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_sysGetAdmin params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                if ([code integerValue] == 0 ) {
                    //是管理员
                    WY_ConsultingListViewController *tempController = [WY_ConsultingListViewController new];
                    tempController.nsType = @"2";
                    [self.navigationController pushViewController:tempController animated:YES];
                } else {
                    [self buquanIDCard];
                }
            } failure:^(NSError *error) {
            }];
        } else {
            [self buquanIDCard];
        }
        
    } else {
        if (sender.tag == 0) {
           [self geetIsLock:YES];
            return;
        }
        if (sender.tag == 2 || sender.tag == 5) {
            
            //咨询投诉
            if (sender.tag == 5) {
                [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_sysGetAdmin params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                    if ([code integerValue] == 0 ) {
                        //是管理员
                        WY_ConsultingListViewController *tempController = [WY_ConsultingListViewController new];
                        tempController.nsType = @"2";
                        [self.navigationController pushViewController:tempController animated:YES];
                    } else {
                        //否则 此用户在当前登录时不是专家- 需求拉取监管网-判断是否是专家
                        WY_UserModel *tempUser = [WY_UserModel new];
                        tempUser.idcardnum = self.mUser.idcardnum;
                        tempUser.yhname = self.mUser.realname;
                        tempUser.key = self.mUser.idcardnum;
                        tempUser.userid = self.mUser.UserGuid;
                        [self zhuanJiaLaQuByPost:tempUser];
                    }
                } failure:^(NSError *error) {
                }];
                
            } else {
                //CA办理
                [self smrzxxIsBelow];
            }
            
            
            return;
        }
        if (sender.tag == 1 || sender.tag == 2 || sender.tag == 3 || sender.tag == 4 || sender.tag == 1001) {
            //专家信息（社会专家不让进）、
            if (sender.tag == 4) {
                if (EXPERTISMIND == 1 || EXPERTISMIND == 2) {
                    [SVProgressHUD showErrorWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
                    return;
                }
            }
            //如果-UserType 已经是1，说明登录后就已判断此用户是专家 - 直接进行 -扫脸认证判断
            //            if  ([self.mUser.UserType isEqualToString:@"1"]) {
            //                  [self smrzxxIsBelow];
            //            } else {
            //                if (EXPERTISMIND == 2) {
            //                    [self smrzxxIsBelow];
            //                    return;
            //                }
            
            //否则 此用户在当前登录时不是专家- 需求拉取监管网-判断是否是专家
            WY_UserModel *tempUser = [WY_UserModel new];
            tempUser.idcardnum = self.mUser.idcardnum;
            tempUser.yhname = self.mUser.realname;
            tempUser.key = self.mUser.idcardnum;
            tempUser.userid = self.mUser.UserGuid;
            [self zhuanJiaLaQuByPost:tempUser];
            //            }
        }
    }
    
    //    [self goIDCarSettingPage];
    
    return;
    
    
}
//待评项目
- (void)goHomePageItemByIndex:(WY_HomeItemView *)sender {
    
    if ([sender isKindOfClass:[WY_HomeItemView class]]) {
        
        if (sender.tag == 0 || sender.tag == 1) {
            //评标专家和历史项目
            //            WY_BiddingProjectListViewController *tempController = [WY_BiddingProjectListViewController new];
            //            tempController.nstype = [NSString stringWithFormat:@"%d",sender.tag+1];
            //            tempController.title = sender.lblTitle.text;
            //            [self.navigationController pushViewController:tempController animated:YES];
            
            if (sender.tag == 0) {
                //判断专家是否已绑定银行卡 - 如未绑定 提示去绑定
                NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
                [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
                [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getExpertBank_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                    if ([code integerValue] == 0 ) {
                        
                        if (![res[@"data"] isEqual:[NSNull null]]) {
                            NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                            //银行卡信息 已完善- 则不提示银行内容
                            if ([dicData[@"bankType"] isNotBlank] && [dicData[@"bankName"] isNotBlank] && [dicData[@"bankCard"] isNotBlank] && [dicData[@"bankAttributionCode"] isNotBlank]) {
                                WY_BiddingProjectListViewController *tempController = [WY_BiddingProjectListViewController new];
                                tempController.nstype = [NSString stringWithFormat:@"%d",sender.tag+1];
                                tempController.title = sender.lblTitle.text;
                                [self.navigationController pushViewController:tempController animated:YES];
                            } else {
                                [self tishi1];
                            }
                        } else {
                            [self tishi1];
                        }
                    } else {
                        [self tishi1];
                    }
                } failure:^(NSError *error) {
                    
                }];
                
                
            } else if (sender.tag == 1) {
                //原 -历史项目 - 改成专家评价
                WY_ExpertEvaluationMainViewController *tempController = [WY_ExpertEvaluationMainViewController new];
                
                //                WY_HistoryProjMainViewController *tempController = [WY_HistoryProjMainViewController new];
                //                 tempController.title = sender.lblTitle.text;
                [self.navigationController pushViewController:tempController animated:YES];
            }
            
            
            return;
        } else {
            if (sender.tag == 2) {
                //CA办理
                [self CABanLi];
                return;
            }
            if (sender.tag == 3) {
                //信用中心
                NSLog(@"劳务报酬结算");
                WY_ExpertFeeMainViewController *tempController = [WY_ExpertFeeMainViewController new];
                [self.navigationController pushViewController:tempController animated:YES];
                
                //                WY_MyCreditViewController *tempController = [WY_MyCreditViewController new];
                //                [self.navigationController pushViewController:tempController animated:YES];
                return;
            }
            if (sender.tag == 4) {
                //完善专家信息
                if (EXPERTISMIND == 1 || EXPERTISMIND == 2) {
                    [SVProgressHUD showErrorWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
                    return;
                }
                WY_ExpertStatusViewController *tempController = [WY_ExpertStatusViewController new];
                [self.navigationController pushViewController:tempController animated:YES];
            }
            if (sender.tag == 5) {
                NSLog(@"咨询投诉");
                if (EXPERTISMIND == 1 || EXPERTISMIND == 2) {
                    [SVProgressHUD showErrorWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
                    return;
                }
                //获取当前用户是否是管理员
                [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_sysGetAdmin params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                    if ([code integerValue] == 0 ) {
                        //是管理员
                        WY_ConsultingListViewController *tempController = [WY_ConsultingListViewController new];
                        tempController.nsType = @"2";
                        [self.navigationController pushViewController:tempController animated:YES];
                    } else {
                        //不是管理员
                        WY_ConsultingListViewController *tempController = [WY_ConsultingListViewController new];
                        tempController.nsType = @"1";
                        [self.navigationController pushViewController:tempController animated:YES];
                    }
                } failure:^(NSError *error) {
                }];
                
                return;
            }
            return;
        }
    } else {
        //搜索历史
        WY_SearchExpertViewController *tempController = [WY_SearchExpertViewController new];
        [self.navigationController pushViewController:tempController animated:YES];
    }
}


/**设置推送*/
- (void)initPush{
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    if(self.mUser != nil) {
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        NSString *clientId =  [userdef objectForKey:@"clientId"];
        if (clientId !=nil && ![clientId isEqualToString:@""]) {
            NSLog(@"clientId:%@",clientId);
            WY_MessageModel *pushModel = [WY_MessageModel new];
            pushModel.m_user_phone = self.mUser.LoginID;
            pushModel.m_client_id = clientId;
            pushModel.m_app_id = @"1";
            pushModel.m_equ_id = @"";
            pushModel.m_equipment_flag = @"6";
            [[MS_BasicDataController sharedInstance] postWithURL:ADDPUSHCLIENTEQUIPMENT params:nil jsonData:[pushModel toJSONData] showProgressView:NO success:^(id successCallBack) {
                NSLog(@"绑定PushID成功");
            } failure:^(NSString *failureCallBack) {
                [SVProgressHUD showErrorWithStatus:failureCallBack];
            } ErrorInfo:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
            }];
        }
    }
}

- (void)viewReadInit:(UIView *)vrView withTitleStr:(NSString *)titleStr{
    [vrView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [vrView addSubview:viewBlue1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(viewBlue1.right + k360Width(8), k360Width(0), k360Width(64), k360Width(44));
    label.text = titleStr;
    label.font = WY_FONTMedium(16);
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8/1.0];
    [vrView addSubview:label];
    
}

//定位相关

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    //维度
    latitude = [NSString  stringWithFormat:@"%.5f", location.coordinate.latitude];
    //经度
    longitude = [NSString stringWithFormat:@"%.5f",location.coordinate.longitude];
    NSLog(@"当前定位：latitude：%@，longitude：%@",latitude,longitude);
    
    //    [self toServiceSendLocation];
    //
    if (self.mUpdateDate == 0) {
        self.mUpdateDate = [[NSDate date] timeIntervalSince1970];
        [self toServiceSendLocation];
        return;
    }
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    if ((timeInterval - self.mUpdateDate) > 60) {
        self.mUpdateDate = [[NSDate date] timeIntervalSince1970];
        [self toServiceSendLocation];
        return;
    }
}

/**
 向服务器发送有开标的专家的用户位置
 */
- (void) toServiceSendLocation {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idcardnum"];
    [dicPost setObject:self.mUser.UserGuid forKey:@"UserGuid"];
    [dicPost setObject:longitude forKey:@"placeLongitude"];
    [dicPost setObject:latitude forKey:@"placeLatitude"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getZjAddresses_HTTP params:nil jsonData:[dicPost mj_JSONData] showProgressView:NO success:^(id res, NSString *code) {
        NSLog(@"返回啥啊:%@",res);
        if ([code integerValue] == 0) {
            
        } else {
            //不需要定位
            NSLog(@"不需要定位");
            if (self.locationManager !=nil) {
                [self.locationManager stopUpdatingLocation];
            }
        }
    } failure:^(NSError *error) {
        //        [self.view makeToast:@"请求失败，请稍后再试"];
    }];
    
}

@end
