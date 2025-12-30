//
//  WY_MyBankCardViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyBankCardViewController.h"
#import "WY_CompleteStatusModel.h"
#import "WY_MyBankCardTableViewCell.h"
#import "WY_MesDelViewController.h"
#import "EmptyView.h"
#import "WY_AddTestQuestionsViewController.h"
#import "WY_AddBankCardViewController.h"

@interface WY_MyBankCardViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;


@end

@implementation WY_MyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    self.pageItemNum = 10;
    self.currentPage = 1;
    [self makeUI];
    [self bindView];
     
    self.isFirst = YES;
}
 

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];

}
- (void) makeUI {
     [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k375Width(80) - JC_TabbarSafeBottomMargin)];
    [self.tableView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = YES;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    
    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];
    
    UIButton *addMajor = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.bottom + k375Width(20), k375Width(337), k375Width(40))];
    addMajor.centerX = self.tableView.centerX;
    
    [addMajor setTitle:@"  添加银行卡" forState:UIControlStateNormal];
    [addMajor setImage:[UIImage imageNamed:@"0629_add"] forState:UIControlStateNormal];
    [addMajor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addMajor rounded:k375Width(32/4)];
    [addMajor setBackgroundColor:HEXCOLOR(0x448EEE)];
    [addMajor.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(17)]];
    [addMajor addTarget:self action:@selector(addMajorAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMajor];
    
}
#pragma mark --绑定数据
- (void)bindView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
  
}
- (void)dataSourceIndex{
    self.currentPage = 1;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
     [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    
     [[MS_BasicDataController sharedInstance] postWithURL:expertGetExpertList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        if (((NSArray *)successCallBack).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_CompleteStatusModel class] json:successCallBack];
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
 
#pragma mark - UITableViewDelegate (TableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrDataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WY_MyBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_MyBankCardTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_CompleteStatusModel *tempModel = self.arrDataSource[indexPath.row];
    cell.mUser = self.mUser;
    [cell showCellByItem:tempModel withInt:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_MyBankCardTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_CompleteStatusModel *tempModel = self.arrDataSource[indexPath.row];
    cell.mUser = self.mUser;
    [cell showCellByItem:tempModel withInt:indexPath.row];
    return cell.frame.size.height;
    
}


-(CGFloat)tableView:(UITableView *)tableView   heightForHeaderInSection:(NSInteger)section{
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
        [_tableView registerClass:[WY_MyBankCardTableViewCell class] forCellReuseIdentifier:@"WY_MyBankCardTableViewCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
           // Fallback on earlier versions
        }
    }
    
    return _tableView;
}

- (void)addMajorAction {
    NSLog(@"添加银行卡");
    WY_AddBankCardViewController *tempController = [WY_AddBankCardViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
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
