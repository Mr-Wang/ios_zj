//
//  WY_BiddingProjectListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_BiddingProjectListViewController.h"
#import "WY_ExpertModel.h"
#import "WY_BiddingProjectTableViewCell.h"
#import "WY_MesDelViewController.h"
#import "EmptyView.h"
#import "WY_AddTestQuestionsViewController.h"

#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "WY_EvaluationAgencyViewController.h"
#import "MS_RepairShopNavigationViewController.h"
#import "WY_SignViewController.h"
#import "WY_HandleTempCAViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import "WY_AddOnlineLeaveViewController.h"

@interface WY_BiddingProjectListViewController ()<UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,AMapNaviCompositeManagerDelegate>{
    CLLocationManager *locationManager;//定义Manager
    NSString *latitude;
    NSString *longitude;
    
    
    UIView *pdfView;
    UIButton *btnUp;
    UIButton *btnReSign;
    UIButton *btnSubmit;
    NSString *isAgree;
    NSString *isSignText;
    WKWebView *webview;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;

@property (nonatomic, strong) WY_ExpertModel *selExperModel;
@property (nonatomic, strong) AMapNaviCompositeManager *compositeManager;
@property (nonatomic, strong) NSString * mSignUrl;
@property (nonatomic, strong) NSMutableDictionary *signSuccessDic;

@end

@implementation WY_BiddingProjectListViewController

// init
- (AMapNaviCompositeManager *)compositeManager {
    if (!_compositeManager) {
        _compositeManager = [[AMapNaviCompositeManager alloc] init];  // 初始化
        _compositeManager.delegate = self;  // 如果需要使用AMapNaviCompositeManagerDelegate的相关回调（如自定义语音、获取实时位置等），需要设置delegate
    }
    return _compositeManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    
    NSDictionary *dict = @{
      @"coordinates" : @"0,0",
      @"userid" : self.mUser.LoginID,
      @"checkTime" : @"aaaa",
      @"status" : @"2",
      @"msg" : @"aaaa没有获取GPS定位信息"
    };
    [MobClick event:@"signlocation" attributes:dict];
    
    self.pageItemNum = 10;
    self.currentPage = 1;
    latitude = @"0";
    longitude = @"0";
    //初始化未签字状态
    isSignText = @"0";
    
    [self makeUI];
    [self bindView];
    
    
    NSNotificationCenter *notifyHomeSearch = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ExpertSearchNotify" object:nil];

    [notifyHomeSearch addObserver:self selector:@selector(trainSearchNotify:) name:@"ExpertSearchNotify" object:nil];
     
    self.isFirst = YES;
}

- (void)trainSearchNotify:(NSNotification *)notify {
    self.keyword = notify.object;
    [self dataSourceIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
         NSLog(@"定位可用");
        locationManager=[[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            [locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
        [locationManager startUpdatingLocation];//开启定位

    }else {
        [self.navigationController popViewControllerAnimated:YES];
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
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          }]];
        [self presentViewController:alert animated:YES completion:nil];
    }

}
- (void) makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.tableView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = YES;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    
    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];
    
    
}
#pragma mark --绑定数据
- (void)bindView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dataSourceNextPage)];
    
    
}
- (void)dataSourceIndex{
    self.currentPage = 1;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage] forKey:@"currentPage"];
    [postDic setObject:self.mUser.idcardnum forKey:@"zjidcard"];
     if (self.keyword.length > 0) {
         [postDic setObject:self.keyword forKey:@"keyword"];

     } else {
         [postDic setObject:self.nstype forKey:@"key"];

     }
    [[MS_BasicDataController sharedInstance] postWithURL:getBidNoticeList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_ExpertModel class] json:successCallBack[@"data"]];
            //                   [SVProgressHUD showSuccessWithStatus:@"查询成功"];
            if (self.currentPage >=[successCallBack[@"allPageNum"] intValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer resetNoMoreData];
            }
            self.emptyView.hidden = YES;
        } else {
            self.arrDataSource = [NSArray array];
            self.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *failureCallBack) {
        [self.emptyView.contentLabel setText:failureCallBack];
        self.emptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];
    } ErrorInfo:^(NSError *error) {
        [self.emptyView.contentLabel setText:@"网络不给力"];
        self.emptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)dataSourceNextPage {
    /**
     * 视频专区和阅读专区列表
     * isfree 0 免费 1 收费
     * xz 1文章 2视频
     * keyword 关键字搜索
     * categorynum 5大类的编码：5001 法律法规、5002 范本文件、5003 操作务实、5004 案例分析、5005 政策解读
     */
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage + 1] forKey:@"currentPage"];
    //如果是企业主
    [postDic setObject:self.mUser.idcardnum forKey:@"zjidcard"];
    
    if (self.keyword.length > 0) {
        [postDic setObject:self.keyword forKey:@"keyword"];

    } else {
        [postDic setObject:self.nstype forKey:@"key"];

    }
    
    [[MS_BasicDataController sharedInstance] postWithURL:getBidNoticeList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:[WY_ExpertModel class] json:successCallBack[@"data"]];
            self.arrDataSource = [self.arrDataSource arrayByAddingObjectsFromArray:tempArr];
            [self.tableView reloadData];
            self.currentPage++;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.currentPage >= [successCallBack[@"allPageNum"] intValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
    } failure:^(NSString *failureCallBack) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } ErrorInfo:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}
#pragma mark - UITableViewDelegate (TableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrDataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    WY_BiddingProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_BiddingProjectTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
    cell.mUser = self.mUser;
    [cell showCellByItem:tempModel];
    cell.btnDecryptBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了签到");
        [weakSelf decryptAction:withModel];
    };
    cell.leavePhoneBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了请假");
        [weakSelf leaveAction:withModel];
    };
    cell.btnNavigationBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了导航");
        AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
         [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:[withModel.latitude floatValue] longitude:[withModel.longitude floatValue]] name:withModel.place POIId:nil];  //传入终点
        [weakSelf.compositeManager presentRoutePlanViewControllerWithOptions:config];

        
//        MS_RepairShopNavigationViewController *navVC = [[MS_RepairShopNavigationViewController alloc]init];
//       navVC.latitude =  withModel.latitude;
//       navVC.longitude =  withModel.longitude;
//       navVC.titleStr = @"导航到集合地点";
//        navVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:navVC animated:YES];

    };
    cell.btnPingJiaBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了评价");
        WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
        WY_EvaluationAgencyViewController *tempController = [WY_EvaluationAgencyViewController new];
        tempController.mWY_ExpertModel = withModel;
        [weakSelf.navigationController pushViewController:tempController animated:YES];

    };
    cell.btnOnlineLeaveBlock = ^(WY_ExpertModel * _Nonnull withModel) {
//        WY_ExpertModel *tempModel = [WY_ExpertModel new];

        //点击了在线请假按钮；
            if (![tempModel.leaveFlag boolValue]) {
                NSLog(@"新增在线请假");
                 WY_AddOnlineLeaveViewController *tempController = [WY_AddOnlineLeaveViewController new];
                 tempController.mWY_ExpertModel = withModel;
                [weakSelf.navigationController pushViewController:tempController animated:YES];

            } else {
                WY_AddOnlineLeaveViewController *tempController = [WY_AddOnlineLeaveViewController new];
                tempController.nsType = @"1";
                tempController.mWY_ExpertModel = withModel;
                [weakSelf.navigationController pushViewController:tempController animated:YES];
                NSLog(@"查看在线请假");
            }
    };
    
    
    cell.btnHandleCABlock = ^(WY_ExpertModel * _Nonnull withModel) {
        weakSelf.selExperModel = withModel;
        if([withModel.isHandleCA isEqualToString:@"1"]) {
            //    点签到 如果没办理云签章 提示办理云签章
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已办理过项目云签章，无需重复办理。" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  _Nonnull action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"继续办理" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  _Nonnull action) {
                [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getCloudSignatureType_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                    
                    if (([code integerValue] == 0) && res) {
                        NSMutableDictionary *dicCloudSignatureType = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                        WY_HandleTempCAViewController *tempController = [WY_HandleTempCAViewController new];
                        tempController.yqztdStr = @"";//[NSString stringWithFormat:@"温馨提示：%@",@"“项目云签章”为仅绑定本次评标项目的“一次性”专家签章，各位专家可自愿申请办理(仅可在本次评标项目中使用，其他项目无法使用)。"];
                        tempController.dicCloudSignatureType = dicCloudSignatureType;
                        tempController.tenderProjectCode = withModel.tenderProjectCode;
                        tempController.pID = withModel.id;
                        tempController.expertId = withModel.expertId;
                        
                        [weakSelf.navigationController pushViewController:tempController animated:YES];
                    } else {
                        
                    }
                }
                failure:^(NSError *error) {
             
                }];
            }]];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        } else {
            [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getCloudSignatureType_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                
                if (([code integerValue] == 0) && res) {
                    NSMutableDictionary *dicCloudSignatureType = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                    WY_HandleTempCAViewController *tempController = [WY_HandleTempCAViewController new];
                    tempController.yqztdStr = @"";//[NSString stringWithFormat:@"温馨提示：%@",@"“项目云签章”为仅绑定本次评标项目的“一次性”专家签章，各位专家可自愿申请办理(仅可在本次评标项目中使用，其他项目无法使用)。"];
                    tempController.dicCloudSignatureType = dicCloudSignatureType;
                    tempController.tenderProjectCode = withModel.tenderProjectCode;
                    tempController.pID = withModel.id;
                    tempController.expertId = withModel.expertId;
                    
                    [weakSelf.navigationController pushViewController:tempController animated:YES];
                } else {
                    
                }
            }
            failure:^(NSError *error) {
         
            }];
        }
        
        
    };
    
    cell.btnMyPingJiaBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了查看我对代理的评价");
        WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
        WY_EvaluationAgencyViewController *tempController = [WY_EvaluationAgencyViewController new];
        tempController.nsType = @"1";
        tempController.mWY_ExpertModel = withModel;
        [weakSelf.navigationController pushViewController:tempController animated:YES];
    };
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //评分暂时加这里
//    WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
//    WY_EvaluationAgencyViewController *tempController = [WY_EvaluationAgencyViewController new];
//    tempController.mWY_ExpertModel = tempModel;
//    [self.navigationController pushViewController:tempController animated:YES];
    
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_BiddingProjectTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
    cell.mUser = self.mUser;
    [cell showCellByItem:tempModel];
    return cell.frame.size.height;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}




- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kHeight((12+20)*2), MSScreenW, kHeight(90)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   // 隐藏系统分割线
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor =MSColor(242, 242, 242);
        _tableView.sectionFooterHeight = 0.01;
        _tableView.sectionHeaderHeight = 0.01;
        [_tableView registerClass:[WY_BiddingProjectTableViewCell class] forCellReuseIdentifier:@"WY_BiddingProjectTableViewCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
           // Fallback on earlier versions
        }
    }
    
    return _tableView;
}


/// 签到
/// @param withModel withModel description
- (void)decryptAction:(WY_ExpertModel *)withModel {
    self.selExperModel = withModel;
    if(![self.selExperModel.isNeedHandleCA isEqualToString:@"1"]) {
        //    点签到 -先判断此项目是否需要办理云签章- 如果不需要办理 直接签到；
        [self decryptionStep1];
    }
    else  {
        //需要办理 -判断
       if(![self.selExperModel.isHandleCA isEqualToString:@"1"]) {
            //  再判断是否已办理云签章 如果没办理云签章 提示办理云签章
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您本次参与评标的项目需要采用电子签名方式。请您先完成项目云签章自主办理，再进行签到，以免影响评标工作。" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self decryptionStep1];
        }
    }
    
//    * 评标通知签到项目信息，1.获取当前位置信息；对接接口比对是否满足签到条件（位置和时间）；2.进行人脸识别认证；3.调用接口签到项目信息，刷新列表；
    
 
}
- (void)decryptionStep1{
    
    if ([latitude intValue] == 0 || [longitude intValue]== 0) {
        
        NSDictionary *dict = @{
          @"coordinates" : @"0,0",
          @"userid" : self.mUser.LoginID,
          @"checkTime" : [NSDate date],
          @"status" : @"2",
          @"msg" : @"没有获取GPS定位信息"
        };
        [MobClick event:@"signlocation" attributes:dict];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"没有获取到您的GPS定位信息，正在重新获取... ，请移动到开阔位置重试" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [locationManager startUpdatingLocation];//开启定位
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
 
    }
    //    * 评标通知签到项目信息，1.获取当前位置信息；对接接口比对是否满足签到条件（位置和时间）；
    //将GPS转成高德坐标
    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]), AMapCoordinateTypeGPS);
    NSLog(@"%.5f,%.5f",amapcoord.longitude,amapcoord.latitude);
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.selExperModel.id forKey:@"id"];
    [dicPost setObject:[NSString stringWithFormat:@"%.5f",amapcoord.longitude] forKey:@"longitude"];
    [dicPost setObject:[NSString stringWithFormat:@"%.5f",amapcoord.latitude] forKey:@"latitude"];
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:expertDistance_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            [weakSelf decryptionStep2];
         } else {
            [weakSelf.view makeToast:res[@"msg"]];
             
             NSDictionary *dict = @{
               @"coordinates" : [NSString stringWithFormat:@"%.5f,%.5f",amapcoord.longitude,amapcoord.latitude],
               @"userid" : self.mUser.LoginID,
               @"checkTime" : [NSDate date],
               @"status" : @"3",
               @"msg" : res[@"msg"]
             };
             [MobClick event:@"signlocation" attributes:dict];
        }
    } failure:^(NSError *error) {
        [weakSelf.view makeToast:@"请求失败，请稍后再试"];
        
    }];

    
}

- (void)decryptionStep2 {
    //2.PDF协议同意
    //判断是否已同意协议- 没有同意过
    if (![isAgree isEqualToString:@"1"]) {
        //没有同意过- 提示
        [self initPDFData];
        return;
    } else {
        //进行人脸识别认证；
//         [self VFace];
        
        //工信部要求去掉人脸
        [self decryptionStep3];

    }
}

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
- (void)submitData:(UIImage *)imgFace {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.realname forKey:@"name"];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [dicPost setObject:self.mUser.LoginID forKey:@"loginId"];
    [dicPost setObject:[self UIImageToBase64Str:imgFace] forKey:@"base64Str"];
    
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:ZJsmrzxx_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            [self.view makeToast:res[@"msg"]];
            [self decryptionStep3];
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

- (void)decryptionStep3 {
    if (![isSignText isEqualToString:@"1"]) {
        [SVProgressHUD showErrorWithStatus:@"请先签字"];
        return;
    }
    isAgree = @"1";
    [pdfView setHidden:YES];
    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]), AMapCoordinateTypeGPS);
    NSLog(@"latitude:%.5f  , longitude:%.5f",amapcoord.latitude,amapcoord.longitude);

//    3.调用接口签到项目信息，刷新列表；
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.selExperModel.id forKey:@"id"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [postDic setObject:[NSString stringWithFormat:@"%.5f",amapcoord.longitude] forKey:@"longitude"];
    [postDic setObject:[NSString stringWithFormat:@"%.5f",amapcoord.latitude] forKey:@"latitude"];
    
    [postDic setObject:self.signSuccessDic[@"contract"] forKey:@"wordPath"];
    [postDic setObject:self.signSuccessDic[@"tenderProjectCode"] forKey:@"tenderProjectCode"];
    [postDic setObject:self.signSuccessDic[@"drawExportCode"] forKey:@"drawExportCode"];
    
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:expertDecrypt_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
           if ([code integerValue] == 0 && res) {
               [self.view makeToast:res[@"msg"]];
                           [self dataSourceIndex];
               NSDictionary *dict = @{
                 @"coordinates" : [NSString stringWithFormat:@"%.5f,%.5f",amapcoord.longitude,amapcoord.latitude],
                 @"userid" : self.mUser.LoginID,
                 @"checkTime" : [NSDate date],
                 @"status" : @"1",
                 @"msg" : res[@"msg"]
               };
               [MobClick event:@"signlocation" attributes:dict];
            } else {
               [self.view makeToast:res[@"msg"]];
                NSDictionary *dict = @{
                  @"coordinates" : [NSString stringWithFormat:@"%.5f,%.5f",amapcoord.longitude,amapcoord.latitude],
                  @"userid" : self.mUser.LoginID,
                  @"checkTime" : [NSDate date],
                  @"status" : @"4",
                  @"msg" : res[@"msg"]
                };
                [MobClick event:@"signlocation" attributes:dict];
           }
       } failure:^(NSError *error) {
           [self.view makeToast:@"请求失败，请稍后再试"];
           NSDictionary *dict = @{
             @"coordinates" : [NSString stringWithFormat:@"%.5f,%.5f",amapcoord.longitude,amapcoord.latitude],
             @"userid" : self.mUser.LoginID,
             @"checkTime" : [NSDate date],
             @"status" : @"5",
             @"msg" : @"接口报错"
           };
           [MobClick event:@"signlocation" attributes:dict];
       }];
}

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

/// 请假
/// @param withModel withModel description
- (void)leaveAction:(WY_ExpertModel *)withModel {
    
    
//    BindAxb
//    绑定AXB号码前，请先明确您的业务场景中AXB三元组的A角色和B角色。例如，在打车应用场景中，A可以是乘客角色，B是司机角色；房产类业务场景中，A可能是用户，B是房产中介。
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"外呼拨出手机号登记" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"　　辽宁专家服务已为您提供当前号码的加密保护，接听方无法获取您当前的真实手机号码。\n　　请确认下面号码是您本次拨出的手机号码（如使用双卡手机或非专家库注册手机登录APP的请选择或使用当前的外呼手机号码。可以登记非专家库注册的手机号码。）如号码有误请修改后拨打，否则会提示拨打的是空号。"];
    [alertControllerMessageStr setYy_alignment:NSTextAlignmentLeft];
    [alertControllerMessageStr yy_setColor:[UIColor redColor] range:[alertControllerMessageStr.string rangeOfString:@"可以登记非专家库注册的手机号码"]];
    [alertControllerMessageStr setYy_font:WY_FONT375Medium(12)];
    [alertControllerMessageStr setYy_lineSpacing:1];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];

    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入本机号码";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.text = self.mUser.LoginID;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"立即呼叫（加密）" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *alertTxt = alertController.textFields[0].text;
        NSLog(@"邮箱：%@",alertTxt);
        if (alertTxt.length > 0) {
            if (![GlobalConfig isValidateMobile:alertTxt]) {
                [self.view makeToast:@"请输入正确的手机号码" duration:1 position:CSToastPositionCenter];
                [self presentViewController:alertController animated:YES completion:nil];
                return ;
            }
            //这里调 BindAxb 接口
            [self bindAxbWithA:alertTxt withB:withModel.yjphone];
//            [GlobalConfig makeCall:withModel.yjphone];
        }else {
            [self.view makeToast:alertController.textFields[0].placeholder duration:1 position:CSToastPositionCenter];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
        }
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    return;

    
    
    
    
//    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
//    [postDic setObject:withModel.id forKey:@"id"];
//    [[MS_BasicDataController sharedInstance] postWithURL:expertGetLeavePhone_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
//        if (successCallBack) {
//            NSLog(@"电话");
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"请拨打%@请假",successCallBack[@"phone"]] message:successCallBack[@"message"] preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }]];
//            [alertController addAction:([UIAlertAction actionWithTitle:@"请 假" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                 [GlobalConfig makeCall:successCallBack[@"phone"]];
//            }])];
//            [self presentViewController:alertController animated:YES completion:nil];
//
//         }
//     } failure:^(NSString *failureCallBack) {
//     } ErrorInfo:^(NSError *error) {
//     }];
}

- (void)bindAxbWithA:(NSString *)withA withB:(NSString *)withB {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:withA forKey:@"callOut"];
    [dicPost setObject:withB forKey:@"callIn"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_HostRecordPhone_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
//            [self.view makeToast:res[@"msg"]];
            [GlobalConfig makeCall:res[@"data"]];
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
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


 - (void)locationManager:(CLLocationManager *)manager

     didUpdateToLocation:(CLLocation *)newLocation

            fromLocation:(CLLocation *)oldLocation {
     
     //latitude和lontitude均为NSString型变量
    
     if (newLocation.coordinate.latitude > 0) {
         //纬度
         latitude = [NSString  stringWithFormat:@"%.5f", newLocation.coordinate.latitude];
         //经度
         longitude = [NSString stringWithFormat:@"%.5f",newLocation.coordinate.longitude];
//         [locationManager stopUpdatingLocation];
      }
     
     
 }

 -(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

 {
     //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
     CLLocation *currentLocation = [locations lastObject];
     CLLocationCoordinate2D coor = currentLocation.coordinate;
     if (coor.latitude > 0) {
         latitude =  [NSString  stringWithFormat:@"%.5f", coor.latitude];
         longitude = [NSString  stringWithFormat:@"%.5f", coor.longitude];
//         [locationManager stopUpdatingLocation];
      }
     
 }

 - (void)locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error {
     
     if (error.code == kCLErrorDenied) {
         
         // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
         NSLog(@"定位出错了");
     }
     
 }

- (void) initPDFData {
//    NSString *pdfurl = @"https://www.capass.cn/Avatar/hbcns.pdf";
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.selExperModel.id forKey:@"id"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idcardnum"];
    [postDic setObject:self.selExperModel.drawExportCode forKey:@"drawExportCode"];
    [[MS_BasicDataController sharedInstance] postWithURL:zj_requestReview_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSString *pdfurl = successCallBack;
         [self bindPDFView:pdfurl];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

    
}

- (void)bindPDFView :(NSString *)pdfurl {
    
    NSString *titleStr = self.title;
    
    self.title = @"请您阅读并签署协议";
    //才 跳转 协议
    pdfView = [UIView new];
    [pdfView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview: pdfView];
    [pdfView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    
    webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50)  - JC_TabbarSafeBottomMargin)];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfurl]]];
    [pdfView addSubview:webview];
    
 
    btnUp = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(16), webview.bottom, (kScreenWidth - k375Width(16*3)) / 2, k360Width(44))];
    [btnUp setTitle:@"取  消" forState:UIControlStateNormal];
    [btnUp.titleLabel setFont:WY_FONTMedium(14)];
    [btnUp setBackgroundColor:[UIColor whiteColor]];
    [btnUp setTitleColor:HEXCOLOR(0x777777) forState:UIControlStateNormal];
    [btnUp rounded:k360Width(44)/8 width:1 color:HEXCOLOR(0x777777)];
 
    
    btnReSign = [[UIButton alloc] initWithFrame:CGRectMake(btnUp.right + k375Width(16), webview.bottom, (kScreenWidth - k375Width(16*3)) / 2, k360Width(44))];
    [btnReSign setTitle:@"签  名" forState:UIControlStateNormal];
    [btnReSign.titleLabel setFont:WY_FONTMedium(14)];
    [btnReSign setBackgroundColor:MSTHEMEColor];
    [btnReSign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReSign rounded:k360Width(44)/8];
 
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(16), webview.bottom, k375Width(326), k360Width(44))];
    [btnSubmit setTitle:@"确  认" forState:UIControlStateNormal];
    [btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [btnSubmit setBackgroundColor:MSTHEMEColor];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit rounded:k360Width(44)/8];
    [btnSubmit setHidden:YES];

    
    
    [pdfView addSubview:btnUp];
    [pdfView addSubview:btnReSign];
    [pdfView addSubview:btnSubmit];
    [btnUp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"拒绝");
        self.title = titleStr;
        isAgree = @"0";
        [pdfView setHidden:YES];
    }];
    
    if ([isSignText isEqualToString:@"1"]) {
         btnUp.width = (kScreenWidth - k375Width(16*4)) / 3;
        btnReSign.width = btnUp.width;
        [btnReSign setTitle:@"重新签名" forState:UIControlStateNormal];
        [btnReSign setBackgroundColor:HEXCOLOR(0xE4E8ED)];
        [btnReSign setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btnSubmit.width = btnUp.width;
        btnReSign.left = btnUp.right + k375Width(16);
        btnSubmit.left = btnReSign.right + k375Width(16);
        [btnSubmit setHidden:NO];
    } else {
        [btnReSign setTitle:@"签  名" forState:UIControlStateNormal];
    }
    
    [btnReSign addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击签字");
        //如果没有签过字 -  判断 用户信息中 是否有签字-
        if (![isSignText isEqualToString:@"1"]) {
//            如果有-直接调用接口签字；
            if ([self.mUser.userSignature isNotBlank]) {
//调用接口签字；
                [self signPDFByUserSignature:self.mUser.userSignature];
            } else {
                //            如果没有- 去签字页保存后-再调用接口签字；
                [self goSignPage];
            }
        } else {
            // 这就是重签- 去签字页保存后-再调用接口签字；
            [self goSignPage];
        }
    }];
    
    
    [btnSubmit addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.title = titleStr;
        
//        [self VFace];
        
        //工信部要求去掉人脸
        [self decryptionStep3];
        
    }];
    
}

- (void)goSignPage {
    WY_SignViewController *tempController = [WY_SignViewController new];
    tempController.isSaveSign = @"1";
    tempController.popVCBlock = ^(NSString * _Nonnull picUrl) {
        self.mSignUrl = picUrl;
        [self tSaveSignUrl:self.mSignUrl];
    };
    tempController.modalPresentationStyle = 0;
    [self presentViewController:tempController animated:YES completion:nil];

}

- (void) tSaveSignUrl:(NSString *)signUrl {
    NSLog(@"保存签字图片");
//    /huiyuanUser/getUserSignature    参数userGui会员id   signature  签字地址    idcardbum身份证号
//    zj_getUserSignature_HTTP
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
     [dicPost setObject:signUrl forKey:@"signature"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_getUserSignature_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"设置成功");
         self.mUser.userSignature = signUrl;
        [self signPDFByUserSignature:self.mUser.userSignature];

    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
}
//签字并刷新PDF
- (void)signPDFByUserSignature:(NSString *)userSignature {
    
    //btn 显示重签
    
    
    //调用接口- 刷新PDF
//    NSString *pdfurl = @"https://www.capass.cn/Avatar/hbcns.pdf";

    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.selExperModel.id forKey:@"id"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idcardnum"];
    [postDic setObject:userSignature forKey:@"userSignature"];
    [postDic setObject:self.selExperModel.drawExportCode forKey:@"drawExportCode"];

    [[MS_BasicDataController sharedInstance] postWithURL:zj_requestReviewSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        self.signSuccessDic = [[NSMutableDictionary alloc] initWithDictionary:successCallBack];
        NSString *pdfurl = self.signSuccessDic[@"agreement"];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfurl]]];
        
        btnUp.width = (kScreenWidth - k375Width(16*4)) / 3;
       btnReSign.width = btnUp.width;
       [btnReSign setTitle:@"重新签名" forState:UIControlStateNormal];
       [btnReSign setBackgroundColor:HEXCOLOR(0xE4E8ED)];
       [btnReSign setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
       btnSubmit.width = btnUp.width;
       btnReSign.left = btnUp.right + k375Width(16);
       btnSubmit.left = btnReSign.right + k375Width(16);
       [btnSubmit setHidden:NO];
        isSignText  = @"1";
        
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
}

#pragma mark - AMapNaviCompositeManagerDelegate

// 发生错误时,会调用代理的此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager error:(NSError *)error {
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

// 算路成功后的回调函数,路径规划页面的算路、导航页面的重算等成功后均会调用此方法
- (void)compositeManagerOnCalculateRouteSuccess:(AMapNaviCompositeManager *)compositeManager {
    NSLog(@"onCalculateRouteSuccess,%ld",(long)compositeManager.naviRouteID);
}

// 算路失败后的回调函数,路径规划页面的算路、导航页面的重算等失败后均会调用此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"onCalculateRouteFailure error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

// 开始导航的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"didStartNavi,%ld",(long)naviMode);
}

// 当前位置更新回调
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager updateNaviLocation:(AMapNaviLocation *)naviLocation {
    NSLog(@"updateNaviLocation,%@",naviLocation);
}

// 导航到达目的地后的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didArrivedDestination:(AMapNaviMode)naviMode {
    NSLog(@"didArrivedDestination,%ld",(long)naviMode);
}
@end

