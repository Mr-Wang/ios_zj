//
//  WY_HomePageViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/9/3.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_HomePageViewController.h"
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
#import "WY_SearchHomeViewController.h"
#import "MS_WKwebviewsViewController.h"
#import <StoreKit/StoreKit.h>
#import "WY_InfoConfirmViewController.h"

@interface WY_HomePageViewController ()
{
    CGFloat topHeight;
    CGFloat bottomHeight;
    CGFloat beginContentY;          //开始滑动的位置
    
    UIImageView *imgTopBg;  //顶部曲线图片
    UIView *viewItem;   //顶部Items
    UIView *viewAnnouncement;   //公告View
    WY_AnnouncementView *tempAnnView; //公告滚动View
    
    UIView *viewVideo;
    UIView *viewVideoContent;
    UIView *viewRead;
    UIView *viewReadContent;
    WY_HomeVideoItemTableViewCell *vvContentView;
}

@property (nonatomic, strong) SDCycleScrollView *headerView;
@property (nonatomic, strong) NSMutableArray *arrIcons;
@property (nonatomic, strong) WY_IndexModel *mWY_IndexModel;
@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@end

@implementation WY_HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageItemNum = 10;
    self.currentPage = 1;
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserver:self selector:@selector(updateFontSizeNotify:) name:@"UPDATEFONTSIZENOTIFY" object:nil];
    [self makeUI];
    
    [self dataSourceIndex];
         
}
//修改了字体
- (void)updateFontSizeNotify:(NSNotification *)notifySender {
    [self.view removeAllSubviews];
    [self makeUI];
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
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
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"搜索你感兴趣的内容"];
    [attStr setYy_color:[UIColor whiteColor]];
    txtSearch.attributedPlaceholder = attStr;
    UIControl *colSearch = [[UIControl alloc] initWithFrame:txtSearch.frame];
     [colSearch addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //搜索历史
        WY_SearchHomeViewController *tempController = [WY_SearchHomeViewController new];
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
    self.mScrollView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dataSourceNextPage)];
    [self.view addSubview:navView];
    
    
    
    // 头视图 banner
    self.headerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(k360Width(16),  k360Width(5), (int)(kScreenWidth - k360Width(32)), k360Width(150))];
    self.headerView.autoScrollTimeInterval = 5.0f;
//    self.headerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.headerView.placeholderImage = [UIImage imageNamed:@"0211_CourseTop"];
    [self.headerView rounded:k360Width(40/8)];
    [self.mScrollView addSubview:self.headerView];
    
    // viewAnnouncement -公告
    viewAnnouncement = [[UIView alloc] initWithFrame:CGRectMake(k360Width(13), self.headerView.bottom + k360Width(16), kScreenWidth - k360Width(26), k360Width(40))];
    [viewAnnouncement setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [viewAnnouncement rounded:k360Width(40/8) width:1 color:HEXCOLOR(0xF3F3F3)];
    //    UIImageView *viewAnnouBg = [[UIImageView alloc] initWithFrame:viewAnnouncement.bounds];
    //    [viewAnnouBg setImage:[UIImage imageNamed:@"消息矩形"]];
    tempAnnView = [[WY_AnnouncementView alloc] initWithFrame:viewAnnouncement.bounds];
    //    [viewAnnouncement addSubview:viewAnnouBg];
    [viewAnnouncement addSubview:tempAnnView];
    [self.mScrollView addSubview:viewAnnouncement];
    
    //隐藏了通知公告
    [viewAnnouncement setHidden:YES];

//    viewItem = [[UIView alloc]initWithFrame:CGRectMake(0, viewAnnouncement.bottom + 5, kScreenWidth, k375Width(110))];

    viewItem = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom + k360Width(12), kScreenWidth, k375Width(110))];

    [self.mScrollView addSubview:viewItem];
    
    viewVideo = [[UIView alloc] initWithFrame:CGRectMake(0, viewItem.bottom + 5, kScreenWidth, k360Width(44))];
    viewVideoContent =[[UIView alloc] initWithFrame:CGRectMake(0, viewVideo.bottom, kScreenWidth, k360Width(230))];
    viewRead = [[UIView alloc] initWithFrame:CGRectMake(0, viewVideoContent.bottom + 5, kScreenWidth, k360Width(44))];
    viewReadContent = [[UIView alloc] initWithFrame:CGRectMake(0, viewRead.bottom , kScreenWidth, k360Width(200))];
    [self.mScrollView addSubview:viewVideo];
    [self.mScrollView addSubview:viewVideoContent];
    [self.mScrollView addSubview:viewRead];
    [self.mScrollView addSubview:viewReadContent];
    
    
    
    [self viewReadInit:viewVideo withTitleStr:@"视频专区"];
    
    [self viewReadInit:viewRead withTitleStr:@"阅读专区"];
    
}
 


- (void)goOrgInfoSettingPage {
    WY_SelectCompanyViewController *tempController = [WY_SelectCompanyViewController new];
    [self.tabBarController.selectedViewController pushViewController:tempController animated:NO];
    
}
- (void)viewReadInit:(UIView *)vrView withTitleStr:(NSString *)titleStr{
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [vrView addSubview:viewBlue1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(viewBlue1.right + k360Width(8), k360Width(0), k360Width(64), k360Width(44));
    label.text = titleStr;
    label.font = WY_FONTMedium(16);
    label.textColor = HEXCOLOR(0x448EEE);
    [vrView addSubview:label];
    
    UIButton *btnMore = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(100), 0, k360Width(80), k360Width(44))];
    [btnMore.titleLabel setFont:WY_FONTRegular(12)];
    [btnMore setTitleColor: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5/1.0] forState:UIControlStateNormal];
    [btnMore setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    if ([viewVideo isEqual:vrView]) {
        //视频专区更多按钮、
        [btnMore setTitle:@"查看更多" forState:UIControlStateNormal];

        [btnMore addTarget:self action:@selector(videoMoreAction) forControlEvents:UIControlEventTouchUpInside];
    } else if ([viewRead isEqual:vrView]) {
        //阅读专区更多按钮
        [btnMore setTitle:@"学习轨迹" forState:UIControlStateNormal];

        [btnMore addTarget:self action:@selector(readMoreAction) forControlEvents:UIControlEventTouchUpInside];
        //专家隐藏学习轨迹
//        [btnMore setHidden:YES];
    }
    
    [vrView addSubview:btnMore];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    imgTopBg.alpha = (100 - scrollView.contentOffset.y) / 100;
}

- (void)dataSourceIndex {
    [[MS_BasicDataController sharedInstance] postWithURL:getStudySy_HTTP params:nil jsonData:nil showProgressView:NO success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (successCallBack) {
            self.mWY_IndexModel = [WY_IndexModel modelWithJSON:successCallBack];
            [self bindView];
            [self dataSourceIndex1];
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
- (void)dataSourceIndex1 {
    self.currentPage = 1;
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage] forKey:@"currentPage"];
    [postDic setObject:@"1" forKey:@"xz"];

    [[MS_BasicDataController sharedInstance] postWithURL:getInformationList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (successCallBack) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_InfomationModel class] json:successCallBack[@"data"]];
            [self initYdzqList];
            [self gengxin];
        } else {
            [SVProgressHUD showErrorWithStatus:@"没有查询到数据"];
        }
        if (self.currentPage >=[successCallBack[@"allPageNum"] intValue]) {
            [self.mScrollView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.mScrollView.mj_footer resetNoMoreData];
        }
        [self.mScrollView.mj_header endRefreshing];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
        [self.mScrollView.mj_header endRefreshing];
    } ErrorInfo:^(NSError *error) {
        [self.mScrollView.mj_header endRefreshing];
    }];
    
}
- (void)gengxin {
//    if (__IPHONE_10_3)
//            //一句话实现在App内直接评论了。然而需要注意的是：打开次数一年不能多于3次。（当然开发期间可以无限制弹出，方便测试）
//            [SKStoreReviewController requestReview];
//    else {
////                        [SVProgressHUD showErrorWithStatus:@"版本不支持此方法"];
//    }
}

- (void)dataSourceNextPage {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage + 1] forKey:@"currentPage"];
    [postDic setObject:@"1" forKey:@"xz"];

    [[MS_BasicDataController sharedInstance] postWithURL:getInformationList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:[WY_InfomationModel class] json:successCallBack[@"data"]];
            self.arrDataSource = [self.arrDataSource arrayByAddingObjectsFromArray:tempArr];
            [self initYdzqList];
            self.currentPage++;
        } else {
            [SVProgressHUD showErrorWithStatus:@"没有查询到数据"];
        }
        [self.mScrollView.mj_header endRefreshing];
        [self.mScrollView.mj_footer endRefreshing];
        
        if (self.currentPage >= [successCallBack[@"allPageNum"] intValue]) {
            [self.mScrollView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.mScrollView.mj_footer resetNoMoreData];
        }
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
        [self.mScrollView.mj_header endRefreshing];
        [self.mScrollView.mj_footer endRefreshing];
        
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        [self.mScrollView.mj_header endRefreshing];
        [self.mScrollView.mj_footer endRefreshing];
        
    }];
    
    
}

#pragma mark --绑定视图数据
- (void)bindView {
    //清空viewItem显示
    [viewItem removeAllSubviews];
    //清空- 视频专区模块内容；
    [viewVideoContent removeAllSubviews];
    
    
    //填充滚动条图片url 模拟
    
    NSMutableArray *arrImageUrl = [[NSMutableArray alloc] init];
    for (WY_ReShousListModel *rslModel in self.mWY_IndexModel.reShousList) {
        [arrImageUrl addObject:rslModel.url];
    }
    
    self.headerView.imageURLStringsGroup = arrImageUrl;
    if ([self.mWY_IndexModel.isAutoScroll isEqualToString:@"2"]) {
        self.headerView.autoScroll = NO;
    }
    WS(weakSelf)
    [self.headerView setClickItemOperationBlock:^(NSInteger currentIndex) {
        WY_ReShousListModel *rslModel = weakSelf.mWY_IndexModel.reShousList[currentIndex];
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
    
    //填充ViewItem数据
    self.arrIcons = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    NSMutableDictionary *dic5 = [NSMutableDictionary new];
    
    [self.arrIcons addObject:dic1];
    [self.arrIcons addObject:dic2];
    [self.arrIcons addObject:dic3];
    [self.arrIcons addObject:dic4];
    [self.arrIcons addObject:dic5];
    
    [dic1 setObject:[UIImage imageNamed:@"1127_flfg"] forKey:@"img"];
    [dic2 setObject:[UIImage imageNamed:@"1127_zcjd"] forKey:@"img"];
    [dic3 setObject:[UIImage imageNamed:@"1127_czws"] forKey:@"img"];
    [dic4 setObject:[UIImage imageNamed:@"1127_alfx"] forKey:@"img"];
    [dic5 setObject:[UIImage imageNamed:@"1127_fbwj"] forKey:@"img"];
    
    [dic1 setObject:@"法律法规" forKey:@"title"];
    [dic2 setObject:@"政策发布" forKey:@"title"];
    [dic3 setObject:@"理论务实" forKey:@"title"];
    [dic4 setObject:@"案例分析" forKey:@"title"];
    [dic5 setObject:@"电子招投标" forKey:@"title"];
    
    float Start_X  = k360Width(5);           // 第一个按钮的X坐标
    float Start_Y = k360Width(16);       // 第一个按钮的Y坐标
    float  Width_Space = 0;//k360Width(5);     // 2个按钮之间的横间距
    float  Height_Space = k360Width(8);// 竖间距
    float  Button_Height = k375Width(100);// 高
    float  Button_Width = (kScreenWidth - k360Width(10)) / 5; //k360Width(44);// 宽
    
    for (int i =0; i < self.arrIcons.count; i ++) {
        NSInteger index = i % 5;
        NSInteger page = i / 5;
        // 圆角按钮
        WY_HomeItemView *aBt = [[WY_HomeItemView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
        //               [aBt setBackgroundColor:[UIColor redColor]];
        NSMutableDictionary *dic = self.arrIcons[i];
        [aBt bindViewWith:dic[@"img"] titleStr:dic[@"title"]];
        aBt.tag = i;
        [aBt addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewItem addSubview:aBt];
    }
    NSMutableArray *arrAnnStrs = [[NSMutableArray alloc] init];
    for (WY_InfomationModel *annModel in self.mWY_IndexModel.webdbInformationTztgList) {
        [arrAnnStrs addObject:annModel.title];
    }
    //滚动公告内容 绑定：
    [tempAnnView setDelegate:self];
    [tempAnnView titleArr:arrAnnStrs];
    
    
    //视频专区数据绑定
    vvContentView = [[WY_HomeVideoItemTableViewCell alloc] initWithFrame:viewVideoContent.bounds];
    [viewVideoContent addSubview:vvContentView];
    [vvContentView showCellByItem:self.mWY_IndexModel.webdbInformationVideoList];
    [vvContentView.headerView setClickItemOperationBlock:^(NSInteger currentIndex) {
        [self viewVideoAction:currentIndex];
    }];
     [vvContentView.colSender addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
         [self viewVideoAction:vvContentView.currentSelIndex];
    }];
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, viewReadContent.bottom + k360Width(16))];
    
}
- (void)initYdzqList{
    //清空- 阅读专区模块内容；
    [viewReadContent removeAllSubviews];
    int lastY = 0;
    for (int i = 0 ; i < self.arrDataSource.count ; i ++) {
        WY_InfomationModel *ydzqModel = self.arrDataSource[i];
        WY_ReadItemTableViewCell *readItemView = [[WY_ReadItemTableViewCell alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(93))];
        [readItemView showCellByItem:ydzqModel];
        readItemView.colSender.tag = i;
        [readItemView.colSender addTarget:self action:@selector(readViewItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewReadContent addSubview:readItemView];
        lastY = readItemView.bottom;
    }
    viewReadContent.height = lastY;
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, viewReadContent.bottom + k360Width(16))];
}

#pragma mark --视频Item点击
- (void)viewVideoAction :(NSInteger)currentIndex{
    NSLog(@"点击了视频Item");
    WY_InfomationModel *videlModel = self.mWY_IndexModel.webdbInformationVideoList[currentIndex];
    NSLog(@"点击了：%@",videlModel.title);
    WY_VideoDetailsViewController *tempController = [WY_VideoDetailsViewController new];
    tempController.mWY_InfomationModel = videlModel;
    [self.navigationController pushViewController:tempController animated:YES];
    
    
    
}
#pragma mark --阅读文章Item点击
- (void)readViewItemAction:(UIControl *)colSender {
    WY_InfomationModel *ydzqModel = self.arrDataSource[colSender.tag];
    NSLog(@"点击了：%@",ydzqModel.title);
    WY_ReadZoneDetailsViewController *tempController = [WY_ReadZoneDetailsViewController new];
    tempController.title = @"详情";
    tempController.mWY_InfomationModel = ydzqModel;
    [self.navigationController pushViewController:tempController animated:YES];
    
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

/// 视频专区按钮点击
- (void) videoMoreAction {
    WY_VideoZoneItemViewController *tempController = [WY_VideoZoneItemViewController new];
    tempController.title = @"视频专区";
    [self.navigationController pushViewController:tempController animated:YES];
}
///阅读专区按钮点击
- (void)readMoreAction{
    //判断登录状态
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil]; 
        return;
    }
    WY_LearningTrackMainViewController *tempController = [WY_LearningTrackMainViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
}
#pragma mark --icon按钮点击事件；
-(void)itemBtnAction:(WY_HomeItemView *)sender {
    //判断是否登录
    
//        if([MS_BasicDataController sharedInstance].user == nil) {
//                WY_LoginViewController *tempController = [WY_LoginViewController new];
//                 [self.navigationController pushViewController:tempController animated:YES];
//            return;
//        }
    WY_ReadZoneItemViewController *tempController = [WY_ReadZoneItemViewController new];
    tempController.idx = sender.tag;
    tempController.isItemClicked = @"1";
    tempController.title = sender.lblTitle.text;
    [self.navigationController pushViewController:tempController animated:YES];
    
}

@end
