//
//  WY_DocListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_DocListViewController.h"
#import "WY_MessageModel.h"
#import "WY_ZJPushMsgTableViewCell.h"
#import "WY_MesDelViewController.h"
#import "EmptyView.h"
#import "MS_WKwebviewsViewController.h"

@interface WY_DocListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;


@end

@implementation WY_DocListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    self.pageItemNum = 10;
    self.currentPage = 1;
    [self makeUI];
    [self bindView];
    [self dataSourceIndex];
    self.isFirst = YES;
}
  
- (void) makeUI {
    self.title = @"操作手册";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin)];
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
    
 
}
- (void)dataSourceIndex{
    self.currentPage = 1;
    [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_getBookList_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if (((NSArray *)res[@"data"]).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_MessageModel class] json:res[@"data"]];
              self.emptyView.hidden = YES;
        } else {
            self.arrDataSource = [NSArray array];
             self.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [self.emptyView.contentLabel setText:@"网络不给力"];
        self.emptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];

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
    
    WY_ZJPushMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_ZJPushMsgTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_MessageModel *tempModel = self.arrDataSource[indexPath.row];
    [cell showCellDocByItem:tempModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //更新已读未读状态； 更新后-进入详情页；* type 1申诉 2整改
//    WY_MessageModel *tempModel = self.arrDataSource[indexPath.row];
//    WY_MesDelViewController *tempController = [WY_MesDelViewController new];
//    tempController.mWY_MessageModel = tempModel;
//    [self.navigationController pushViewController:tempController animated:YES];
    
    WY_MessageModel *tempModel = self.arrDataSource[indexPath.row];

    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
   wk.isShare = @"1";
   wk.titleStr = tempModel.docTitle;
   wk.webviewURL = tempModel.docUrl;
   UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
   navi.navigationBarHidden = NO;
   navi.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:navi animated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_ZJPushMsgTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_MessageModel *tempModel = self.arrDataSource[indexPath.row];
    [cell showCellDocByItem:tempModel];
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
        [_tableView registerClass:[WY_ZJPushMsgTableViewCell class] forCellReuseIdentifier:@"WY_ZJPushMsgTableViewCell"];
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

@end
