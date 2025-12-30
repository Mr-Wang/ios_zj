//
//  WY_VideoZoneItemViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_VideoZoneItemViewController.h"
#import "WY_InfomationModel.h"
#import "WY_VideoItemTableViewCell.h"
#import "WY_VideoDetailsViewController.h"
#import "EmptyView.h"

@interface WY_VideoZoneItemViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic , strong) NSString *videoReadStatus;
@property (nonatomic , strong) UIButton *cancleButton;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;

@end

@implementation WY_VideoZoneItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    self.pageItemNum = 10;
    self.currentPage = 1;
    [self makeUI];
    [self bindView];
    self.isFirst = YES;
    
    NSNotificationCenter *notifyHomeSearch = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HomeSearchnNotify" object:nil];

    [notifyHomeSearch addObserver:self selector:@selector(homeSearchNotify:) name:@"HomeSearchnNotify" object:nil];
    
}
- (void)homeSearchNotify:(NSNotification *)notify {
    self.keyword = notify.object;
    [self dataSourceIndex];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

}
- (void) makeUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin - k360Width(52))];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = YES;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];

    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];

    self.cancleButton = [[UIButton alloc] init];
self.cancleButton.frame = CGRectMake(0, 0, 44, 44);
[self.cancleButton setTitle:@"全部视频" forState:UIControlStateNormal];
[self.cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancleButton];
self.navigationItem.rightBarButtonItem = rightItem;

}
- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    self.tableView.height = kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin;
    [self.tableView.mj_header beginRefreshing];

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
    [postDic setObject:@"2" forKey:@"xz"];
    if (self.keyword) {
        [postDic setObject:self.keyword forKey:@"keyword"];
    } else {
        [postDic setObject:@"0" forKey:@"isfree"];
    }
    
    //1 已读  0 未读
    if (self.videoReadStatus) {
        [postDic setObject:self.videoReadStatus forKey:@"videoReadStatus"];
    }
    
    [[MS_BasicDataController sharedInstance] postWithURL:getInformationList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_InfomationModel class] json:successCallBack[@"data"]];
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
    [postDic setObject:@"2" forKey:@"xz"];
    if (self.keyword) {
        [postDic setObject:self.keyword forKey:@"keyword"];
    } else {
        [postDic setObject:@"0" forKey:@"isfree"];
    }
    
    [[MS_BasicDataController sharedInstance] postWithURL:getInformationList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:[WY_InfomationModel class] json:successCallBack[@"data"]];
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
    
    WY_VideoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_VideoItemTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
    [cell showCellByItem:tempModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //更新已读未读状态； 更新后-进入详情页；* type 1申诉 2整改
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
    WY_VideoDetailsViewController *tempController = [WY_VideoDetailsViewController new];
    tempController.mWY_InfomationModel = tempModel;
    [self.navigationController pushViewController:tempController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_VideoItemTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
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
        [_tableView registerClass:[WY_VideoItemTableViewCell class] forCellReuseIdentifier:@"WY_VideoItemTableViewCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
           // Fallback on earlier versions
        }
    }
    
    return _tableView;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)navRightAction{
    NSLog(@"");
        [ActionSheetStringPicker showPickerWithTitle:@"请选择学习轨迹" rows:@[@"全部视频",@"已学视频",@"未学视频"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
             [self.cancleButton setTitle:selectedValue forState:UIControlStateNormal];
            if (selectedIndex == 0) {
                self.videoReadStatus = nil;
            }else if (selectedIndex == 1) {
                self.videoReadStatus = @"1";
            }else if (selectedIndex == 2) {
                self.videoReadStatus = @"0";
            }
            [self dataSourceIndex];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];

}

@end
