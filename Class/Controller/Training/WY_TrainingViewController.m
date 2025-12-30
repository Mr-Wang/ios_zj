//
//  WY_TrainingViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_TrainingViewController.h"
#import "SDCycleScrollView.h"
#import "WY_HomeItemView.h"
#import "WY_LoginViewController.h"
#import "WY_AnnouncementView.h"
#import "WY_TrainModel.h"
#import "WY_VideoItemTableViewCell.h"
#import "WY_ReadItemTableViewCell.h"
#import "WY_ReadZoneMainViewController.h"
#import "WY_VideoZoneItemViewController.h"
#import "WY_TrainTabMainViewController.h"
#import "WY_IDCarSettingViewController.h"
#import "WY_SelectCompanyViewController.h"
#import "WY_VideoDetailsViewController.h"
#import "WY_ReadZoneDetailsViewController.h"
#import "WY_NewTraCourseTableViewCell.h"
#import "WY_BoutiqueCourseTableViewCell.h"
#import "WY_RecommendCourseTableViewCell.h"
#import "WY_TrainDetailsViewController.h"
#import "WY_OnlineTrainDetailsViewController.h"
#import "WY_ZJPushMsgViewController.h"
#import "WY_ReShousListModel.h"
#import "WY_SearchTrainingViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_InfoConfirmViewController.h"

@interface WY_TrainingViewController ()
{
    CGFloat topHeight;
    CGFloat bottomHeight;
    CGFloat beginContentY;          //开始滑动的位置
    
    UIImageView *imgTopBg;  //顶部曲线图片
    UIView *viewItem;   //顶部Items
 
    UIView *viewVideo;
    UIView *viewVideoContent;
    UIView *viewRead;
    UIView *viewReadContent;
    UIView *viewWntj;
    UIView *viewWntjContent;
    
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) SDCycleScrollView *headerView;
@property (nonatomic, strong) NSMutableArray *arrIcons;
@property (nonatomic, strong) WY_TrainModel *mWY_TrainModel;
@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray* reShousList;
@end

@implementation WY_TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageItemNum = 10;
    self.currentPage = 1;
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserver:self selector:@selector(updateFontSizeNotify:) name:@"UPDATEFONTSIZENOTIFY" object:nil];
    [self makeUI];
 }
//修改了字体
- (void)updateFontSizeNotify:(NSNotification *)notifySender {
    [self.view removeAllSubviews];
    [self makeUI];
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self dataSourceIndex];
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
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"搜索你感兴趣的内容"];
    [attStr setYy_color:[UIColor whiteColor]];
    txtSearch.attributedPlaceholder = attStr;
    [txtSearch rounded:k375Width(25 / 8)];
    [txtSearch setBackgroundColor:MSColorA(255, 255, 255, 0.22)];
        [txtSearch setUserInteractionEnabled:NO];
    UIControl *colSearch = [[UIControl alloc] initWithFrame:txtSearch.frame];
    [colSearch setBackgroundColor:[UIColor clearColor]];
    [colSearch addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //搜索历史
        WY_SearchTrainingViewController *tempController = [WY_SearchTrainingViewController new];
        [self.navigationController pushViewController:tempController animated:YES];

    }];
    [navView addSubview:txtSearch];
    [navView addSubview:colSearch];
    
    
    //消息功能；
    UIButton *btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(txtSearch.right + k375Width(16), txtSearch.top + k375Width(4), k375Width(22), k375Width(22))];
    [btnMessage setBackgroundImage:[UIImage imageNamed:@"0521消息"] forState:UIControlStateNormal];
    [btnMessage addTarget:self action:@selector(btnMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btnMessage];
    
    
    navView.height = txtSearch.bottom + k360Width(10);
    
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
    [self.headerView rounded:k360Width(40/8)];
    [self.mScrollView addSubview:self.headerView];
     
    
    viewItem = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom + 5, kScreenWidth, k360Width(110))];
    
    [self.mScrollView addSubview:viewItem];
    
    viewVideo = [[UIView alloc] initWithFrame:CGRectMake(0, viewItem.bottom + 5, kScreenWidth, k360Width(44))];
    viewVideoContent =[[UIView alloc] initWithFrame:CGRectMake(0, viewVideo.bottom, kScreenWidth, k360Width(200))];
    viewRead = [[UIView alloc] initWithFrame:CGRectMake(0, viewVideoContent.bottom + 5, kScreenWidth, k360Width(44))];
    viewReadContent = [[UIView alloc] initWithFrame:CGRectMake(0, viewRead.bottom , kScreenWidth, k360Width(200))];
    
    viewWntj = [[UIView alloc] initWithFrame:CGRectMake(0, viewReadContent.bottom + 5, kScreenWidth, k360Width(44))];
    viewWntjContent = [[UIView alloc] initWithFrame:CGRectMake(0, viewWntj.bottom , kScreenWidth, k360Width(200))];
    
   
    
    [self.mScrollView addSubview:viewVideo];
    [self.mScrollView addSubview:viewVideoContent];
    [self.mScrollView addSubview:viewRead];
    [self.mScrollView addSubview:viewReadContent];
    
    [self.mScrollView addSubview:viewWntj];
    [self.mScrollView addSubview:viewWntjContent];
    
    
    
    [self viewReadInit:viewVideo withTitleStr:@"最新课程通知"];
    
    [self viewReadInit:viewRead withTitleStr:@"精品培训"];
    
    [self viewReadInit:viewWntj withTitleStr:@"热门课程"];

}
 
 
- (void)viewReadInit:(UIView *)vrView withTitleStr:(NSString *)titleStr{
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [vrView addSubview:viewBlue1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(viewBlue1.right + k360Width(8), k360Width(0), k360Width(264), k360Width(44));
    label.text = titleStr;
    label.font = WY_FONTMedium(16);
    label.textColor = HEXCOLOR(0x448EEE);
    [vrView addSubview:label];
    
 }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    imgTopBg.alpha = (100 - scrollView.contentOffset.y) / 100;
}

- (void)dataSourceIndex {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:@"2" forKey:@"type"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getTpUrl_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
           if ([code integerValue] == 0 && res) {
               self.reShousList = [NSArray yy_modelArrayWithClass:[WY_ReShousListModel class] json:res[@"data"]];
               [self initTopHead];
            } else {
               [SVProgressHUD showErrorWithStatus:res[@"msg"]];
           }
       } failure:^(NSError *error) { 
       }];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getTraEnrolHome_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 1 && res) {
            self.mWY_TrainModel = [WY_TrainModel modelWithJSON:res[@"data"]];
            [self bindView];
            
         } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
        [self.mScrollView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        [self.mScrollView.mj_header endRefreshing];

    }];
     
}


- (void)initTopHead {
    //填充滚动条图片url 模拟
       
       NSMutableArray *arrImageUrl = [[NSMutableArray alloc] init];
       for (WY_ReShousListModel *rslModel in self.reShousList) {
           [arrImageUrl addObject:rslModel.url];
       }
       
       self.headerView.imageURLStringsGroup = arrImageUrl;
  
       WS(weakSelf)
       [self.headerView setClickItemOperationBlock:^(NSInteger currentIndex) {
           WY_ReShousListModel *rslModel = weakSelf.reShousList[currentIndex];
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
}

#pragma mark --绑定视图数据
- (void)bindView {
    //清空viewItem显示
    [viewItem removeAllSubviews];
    //清空- 视频专区模块内容；
    [viewVideoContent removeAllSubviews];
    
    
//    //填充滚动条图片url 模拟
//    NSMutableArray *arrImageUrl = [[NSMutableArray alloc] init];
//    [arrImageUrl addObject:[UIImage imageNamed:@"0211_CourseTop"]];
//    self.headerView.localizationImageNamesGroup = arrImageUrl;
//    WS(weakSelf)
//    [self.headerView setClickItemOperationBlock:^(NSInteger currentIndex) {
//
//     }];
    
    //填充ViewItem数据
    self.arrIcons = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    NSMutableDictionary *dic5 = [NSMutableDictionary new];
    
    [self.arrIcons addObject:dic1];
//    [self.arrIcons addObject:dic2];
    [self.arrIcons addObject:dic3];
    [self.arrIcons addObject:dic4];
    [self.arrIcons addObject:dic5];
    
    [dic1 setObject:[UIImage imageNamed:@"0210_mfpx"] forKey:@"img"];
//    [dic2 setObject:[UIImage imageNamed:@"0210_jpjz"] forKey:@"img"];
    [dic3 setObject:[UIImage imageNamed:@"0210_zxzb"] forKey:@"img"];
    [dic4 setObject:[UIImage imageNamed:@"0210_jxlx"] forKey:@"img"];
    [dic5 setObject:[UIImage imageNamed:@"0210_qb"] forKey:@"img"];
    
    [dic1 setObject:@"免费培训" forKey:@"title"];
//    [dic2 setObject:@"付费课程" forKey:@"title"];
    [dic3 setObject:@"在线培训" forKey:@"title"];
    [dic4 setObject:@"录播课程" forKey:@"title"];
    [dic5 setObject:@"全部" forKey:@"title"];
    
    float Start_X  = k360Width(5);           // 第一个按钮的X坐标
    float Start_Y = k360Width(16);       // 第一个按钮的Y坐标
    float  Width_Space = 0;//k360Width(5);     // 2个按钮之间的横间距
    float  Height_Space = k360Width(8);// 竖间距
    float  Button_Height = k360Width(66);// 高
    float  Button_Width = (kScreenWidth - k360Width(10)) / 4; //k360Width(44);// 宽
    
    for (int i =0; i < self.arrIcons.count; i ++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        // 圆角按钮
        WY_HomeItemView *aBt = [[WY_HomeItemView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
        //               [aBt setBackgroundColor:[UIColor redColor]];
        NSMutableDictionary *dic = self.arrIcons[i];
        [aBt bindViewWith:dic[@"img"] titleStr:dic[@"title"]];
        aBt.tag = i;
        [aBt addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewItem addSubview:aBt];
    }
 
 
    //最新课程通知数据绑定
    [self initNewTraCourseList];
    //加载精品培训模块
    [self initBoutiqueCourseList];
    ///加载热门课程模块
    [self initRecommendCourseList];
    
    
    viewRead.top = viewVideoContent.bottom;
    viewReadContent.top =viewRead.bottom;
    viewWntj.top = viewReadContent.bottom;
    viewWntjContent.top =viewWntj.bottom;
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, viewWntjContent.bottom)];
}
///加载最新课程通知模块
- (void)initNewTraCourseList {
        //清空- 阅读专区模块内容；
        [viewVideoContent removeAllSubviews];
        int lastY = k360Width(16);
    for (int i = 0 ; i < self.mWY_TrainModel.nsnewTraCourseList.count ; i ++) {
        WY_TrainItemModel *ydzqModel = self.mWY_TrainModel.nsnewTraCourseList[i];
            WY_NewTraCourseTableViewCell *readItemView = [[WY_NewTraCourseTableViewCell alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(120))];
        
        
            [readItemView showCellByItem:ydzqModel withNum:i];
            readItemView.colSender.tag = i;
            [readItemView.colSender addTarget:self action:@selector(newTraCourseItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [viewVideoContent addSubview:readItemView];
            lastY = readItemView.bottom + k360Width(16);
        }
        viewVideoContent.height = lastY;
 }

///加载精品培训模块
- (void)initBoutiqueCourseList {
    float Start_X  = k375Width(16);           // 第一个按钮的X坐标
       float Start_Y = k375Width(16);       // 第一个按钮的Y坐标
       float  Width_Space =  k375Width(16);     // 2个按钮之间的横间距
       float  Height_Space = k375Width(16);// 竖间距
       float  Button_Height = k375Width(133);// 高
       float  Button_Width = (kScreenWidth - k375Width(16*3)) / 2;
       
    //清空- 阅读专区模块内容；
    [viewReadContent removeAllSubviews];
    int lastY = 0;
       for (int i =0; i < self.mWY_TrainModel.bestTraCourseList.count; i ++) {
           NSInteger index = i % 2;
           NSInteger page = i / 2;
           // 圆角按钮
           WY_BoutiqueCourseTableViewCell *aBt = [[WY_BoutiqueCourseTableViewCell alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
            aBt.colSender.tag = i;
           [aBt showCellByItem:self.mWY_TrainModel.bestTraCourseList[i]];
           [aBt.colSender addTarget:self action:@selector(boutiqueCourseItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
           [viewReadContent addSubview:aBt];
             lastY = aBt.bottom;
       }
    viewReadContent.height = lastY + k360Width(16);
}

- (void)initRecommendCourseList {
    //清空- 阅读专区模块内容；
           [viewWntjContent removeAllSubviews];
           int lastY = k360Width(16);
       for (int i = 0 ; i < self.mWY_TrainModel.askTraCourseList.count ; i ++) {
           WY_TrainItemModel *ydzqModel = self.mWY_TrainModel.askTraCourseList[i];
               WY_RecommendCourseTableViewCell *readItemView = [[WY_RecommendCourseTableViewCell alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(200))];
               [readItemView showCellByItem:ydzqModel];
               readItemView.colSender.tag = i;
               [readItemView.colSender addTarget:self action:@selector(recommendCourseItemAction:) forControlEvents:UIControlEventTouchUpInside];
               [viewWntjContent addSubview:readItemView];
               lastY = readItemView.bottom + k360Width(10);
           }
           viewWntjContent.height = lastY;    
}

#pragma mark --阅读文章Item点击
- (void)newTraCourseItemAction:(UIControl *)colSender {
    WY_TrainItemModel *ydzqModel = self.mWY_TrainModel.nsnewTraCourseList[colSender.tag];
    NSLog(@"点击了：%@",ydzqModel.Title);
    [self gotoTrainDetailsPage:ydzqModel];
}


 #pragma mark --热门课程Item点击
 - (void)recommendCourseItemAction:(UIControl *)colSender {
     WY_TrainItemModel *ydzqModel = self.mWY_TrainModel.askTraCourseList[colSender.tag];
      NSLog(@"点击了：%@",ydzqModel.Title);
     [self gotoTrainDetailsPage:ydzqModel];
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

#pragma mark --消息按钮点击事件
- (void)btnMessageAction {
    NSLog(@"点击了消息按钮");
    WY_ZJPushMsgViewController *tempController = [WY_ZJPushMsgViewController new];
    [self.navigationController pushViewController:tempController animated:YES];

}

///精品培训模块点击事件
- (void)boutiqueCourseItemBtnAction:(UIControl*)colSender {
    WY_TrainItemModel *ydzqModel = self.mWY_TrainModel.bestTraCourseList[colSender.tag];
    NSLog(@"点击了：%@",ydzqModel.Title);
    [self gotoTrainDetailsPage:ydzqModel];
}
#pragma mark --icon按钮点击事件；
-(void)itemBtnAction:(WY_HomeItemView *)sender {
    //判断是否登录
    
    //    if([MS_BasicDataController sharedInstance].user == nil) {
    //            WY_LoginViewController *tempController = [WY_LoginViewController new];
    //             [self.navigationController pushViewController:tempController animated:YES];
    //        return;
    //    }
    WY_TrainTabMainViewController *tempController = [WY_TrainTabMainViewController new];
    tempController.selZJIndex = sender.tag;
     [self.navigationController pushViewController:tempController animated:YES];
    
}

@end
