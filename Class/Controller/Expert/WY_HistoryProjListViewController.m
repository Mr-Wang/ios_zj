//
//  WY_HistoryProjListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_HistoryProjListViewController.h"
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
#import "WY_NewEvaluationAgencyViewController.h"
#import "WY_AgentToMeEvaViewController.h"
#import "MS_RepairShopNavigationViewController.h"

@interface WY_HistoryProjListViewController ()<UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,AMapNaviCompositeManagerDelegate>{
    CLLocationManager *locationManager;//定义Manager
    NSString *latitude;
    NSString *longitude;
    
    
    UIView *pdfView;
    UIButton *btnLeft;
    UIButton *btnRight;
    NSString *isAgree;
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


@end

@implementation WY_HistoryProjListViewController

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
    self.nstype = @"2";
    self.pageItemNum = 10;
    self.currentPage = 1;
    [self makeUI];
    [self bindView];
    
    
    NSNotificationCenter *notifyHomeSearch = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ExpertSearchNotify" object:nil];

    [notifyHomeSearch addObserver:self selector:@selector(trainSearchNotify:) name:@"ExpertSearchNotify" object:nil];
    
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        locationManager=[[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            [locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
        [locationManager startUpdatingLocation];//开启定位
        
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    self.isFirst = YES;
}


- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    self.idx = index;
     [self.tableView.mj_header beginRefreshing];

}

- (void)trainSearchNotify:(NSNotification *)notify {
    self.keyword = notify.object;
    [self dataSourceIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];

}
- (void) makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin - k360Width(50))];
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
         [postDic setObject:@"2" forKey:@"key"];
         self.idx  = 2;
     } else {
         //key  3是有评价的列表 2 历史项目、
         if (self.idx == 0) {
             [postDic setObject:@"3" forKey:@"key"];
         } else {
             [postDic setObject:@"2" forKey:@"key"];
         }
     }
    switch (self.idx) {
        case 0:
        { 
            [postDic setObject:@"" forKey:@"beRated"];
            [postDic setObject:@"" forKey:@"isReconsider"];
        }
            break;
        case 1:
        {
            [postDic setObject:@"1" forKey:@"beRated"];
            [postDic setObject:@"" forKey:@"isReconsider"];
        }
            break;
        case 2:
        {
            [postDic setObject:@"" forKey:@"beRated"];
            [postDic setObject:@"" forKey:@"isReconsider"];
        }
            break;
         
        default:
            break;
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
        [postDic setObject:@"2" forKey:@"key"];
        self.idx  = 2;
    } else {
        //key 2 历史项目、 3是有评价的列表
        if (self.idx == 0) {
            [postDic setObject:@"3" forKey:@"key"];
        } else {
            [postDic setObject:@"2" forKey:@"key"];
        }

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
    
    WY_BiddingProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_BiddingProjectTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
    tempModel.typeID =  self.idx;
    cell.mUser = self.mUser;
    [cell showCellLSByItem:tempModel];
    cell.btnDecryptBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了签到");
        [self decryptAction:withModel];
    };
    cell.leavePhoneBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了请假");
        [self leaveAction:withModel];
    };
    cell.btnNavigationBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了导航");
//        AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
//         [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:[@"41.776552" floatValue] longitude:[@"123.434516" floatValue]] name:withModel.place POIId:nil];  //传入终点
//        [self.compositeManager presentRoutePlanViewControllerWithOptions:config];

//        MS_RepairShopNavigationViewController *navVC = [[MS_RepairShopNavigationViewController alloc]init];
//       navVC.latitude = @"41.776552";//model.repairFactoryLatitude;
//       navVC.longitude = @"123.434516";// model.repairFactoryLongitude;
//       navVC.titleStr = @"导航";
//        navVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:navVC animated:YES];

    };
    cell.btnPingJiaBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了评价");
        WY_NewEvaluationAgencyViewController *tempController = [WY_NewEvaluationAgencyViewController new];
        tempController.mWY_ExpertModel = withModel;
        [self.navigationController pushViewController:tempController animated:YES];

    };
    cell.btnMyPingJiaBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        NSLog(@"点击了查看我对代理的评价");
        WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
        WY_NewEvaluationAgencyViewController *tempController = [WY_NewEvaluationAgencyViewController new];
        tempController.nsType = @"1";
        tempController.mWY_ExpertModel = withModel;
        [self.navigationController pushViewController:tempController animated:YES];
    };
    cell.btnDLPingJiaBlock = ^(WY_ExpertModel * _Nonnull withModel) {
        WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];

        WY_AgentToMeEvaViewController *tempController = [WY_AgentToMeEvaViewController new];
       tempController.mWY_ExpertModel = withModel;
       [self.navigationController pushViewController:tempController animated:YES];

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
    tempModel.typeID =  self.idx;
    cell.mUser = self.mUser;
    [cell showCellLSByItem:tempModel];
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
//    * 评标通知签到项目信息，1.获取当前位置信息；对接接口比对是否满足签到条件（位置和时间）；2.进行人脸识别认证；3.调用接口签到项目信息，刷新列表；
    [self decryptionStep1];
 
}
- (void)decryptionStep1{
    //    * 评标通知签到项目信息，1.获取当前位置信息；对接接口比对是否满足签到条件（位置和时间）；
    //将GPS转成高德坐标
    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]), AMapCoordinateTypeGPS);
    NSLog(@"latitude:%.5f  , longitude:%.5f",amapcoord.latitude,amapcoord.longitude);
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.selExperModel.id forKey:@"id"];
    [dicPost setObject:[NSString stringWithFormat:@"%.5f",amapcoord.longitude] forKey:@"longitude"];
    [dicPost setObject:[NSString stringWithFormat:@"%.5f",amapcoord.latitude] forKey:@"latitude"];
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:expertDistance_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            [self.view makeToast:res[@"msg"]];
            [self decryptionStep2];
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];

    
}

- (void)decryptionStep2 {
    //2.PDF协议同意
    //判断是否已同意协议- 没有同意过
    if (![isAgree isEqualToString:@"1"]) {
        //没有同意过- 提示
        [self bindPDFView];
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
    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]), AMapCoordinateTypeGPS);
    NSLog(@"latitude:%.5f  , longitude:%.5f",amapcoord.latitude,amapcoord.longitude);

//    3.调用接口签到项目信息，刷新列表；
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.selExperModel.id forKey:@"id"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [postDic setObject:[NSString stringWithFormat:@"%.5f",amapcoord.longitude] forKey:@"longitude"];
    [postDic setObject:[NSString stringWithFormat:@"%.5f",amapcoord.latitude] forKey:@"latitude"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:expertDecrypt_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
           if ([code integerValue] == 0 && res) {
               [self.view makeToast:res[@"msg"]];
                           [self dataSourceIndex];

            } else {
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

/// 请假
/// @param withModel withModel description
- (void)leaveAction:(WY_ExpertModel *)withModel {
    [GlobalConfig makeCall:withModel.yjphone];
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
         [locationManager stopUpdatingLocation];
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
         [locationManager stopUpdatingLocation];
      }
     
 }

 - (void)locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error {
     
     if (error.code == kCLErrorDenied) {
         
         // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
         NSLog(@"定位出错了");
     }
     
 }


- (void)bindPDFView {
    
    NSString *titleStr = self.title;
    
    self.title = @"请您阅读并同意服务协议";
    //才 跳转 协议
    pdfView = [UIView new];
    [pdfView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview: pdfView];
    [pdfView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    NSString *pdfurl = @"https://www.capass.cn/Avatar/hbcns.pdf";
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50)  - JC_TabbarSafeBottomMargin)];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfurl]]];
    [pdfView addSubview:webview];
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, webview.bottom, kScreenWidth / 2, k360Width(50))];
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2, webview.bottom, kScreenWidth / 2, k360Width(50))];
    [btnLeft setTitle:@"拒 绝" forState:UIControlStateNormal];
    [btnRight setTitle:@"同 意" forState:UIControlStateNormal];
    [btnLeft setBackgroundColor:HEXCOLOR(0xFE5238)];
    [btnRight setBackgroundColor:MSTHEMEColor];
    
    [btnLeft.titleLabel setFont:WY_FONTMedium(16)];
    [btnRight.titleLabel setFont:WY_FONTMedium(16)];
    
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [pdfView addSubview:btnLeft];
    [pdfView addSubview:btnRight];
    [btnLeft addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"拒绝");
        self.title = titleStr;
        isAgree = @"0";
        [pdfView setHidden:YES];
    }];
    
    [btnRight addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.title = titleStr;
        isAgree = @"1";
        [pdfView setHidden:YES];

        
        //        [self VFace];
        //工信部要求去掉人脸
        [self decryptionStep3];
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

