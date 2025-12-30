//
//  WY_SelectJobTitle1ViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SelectJobTitle1ViewController.h"
#import "WY_ZJCompanyModel.h"
#import "WY_MesDelViewController.h"
#import "EmptyView.h"
#import "WY_AddTestQuestionsViewController.h"
#import "WY_SelectJobTitle2ViewController.h"

@interface WY_SelectJobTitle1ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;


@end

@implementation WY_SelectJobTitle1ViewController

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
    self.title = @"请选择职称";
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
  
}
- (void)dataSourceIndex{
    self.currentPage = 1;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
     [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [postDic setObject:@"0" forKey:@"code"];
    
     [[MS_BasicDataController sharedInstance] postWithURL:zj_expert_getJobTitle_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        if (((NSArray *)successCallBack).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_ZJCompanyModel class] json:successCallBack];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_ZJCompanyModel *tempModel = self.arrDataSource[indexPath.row];
    cell.textLabel.text = tempModel.name;
    
    [cell.textLabel setFrame:CGRectMake(k360Width(16), k360Width(10), kScreenWidth - k360Width(32), k360Width(30))];
     [cell.textLabel setNumberOfLines:0];
    [cell.textLabel sizeToFit];
    if ([cell viewWithTag:1034]) {
        UIView * aa =  [cell viewWithTag:1034];
        [aa removeFromSuperview];
    }
    UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,cell.textLabel.bottom + k375Width(10) ,kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    imgLine.tag = 1034;
    [cell addSubview:imgLine];
    return cell;
    
//    [cell.textLabel sizeToFit];
//    UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(43) ,kScreenWidth, 1)];
//    [imgLine setBackgroundColor:APPLineColor];
//    [cell addSubview:imgLine];
//
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WY_ZJCompanyModel *tempModel = self.arrDataSource[indexPath.row];

    WY_SelectJobTitle2ViewController *tempController = [WY_SelectJobTitle2ViewController new];
    tempController.selJobTitleBlock = ^(WY_ZJCompanyModel * _Nonnull selModel) {
        self.selJobTitleBlock(selModel);
    };
    tempController.mModelOne = tempModel;
    [self.navigationController pushViewController:tempController animated:YES];
    
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    [cell.textLabel setFrame:CGRectMake(k360Width(16), k360Width(10), kScreenWidth - k360Width(32), k360Width(30))];
    WY_ZJCompanyModel *tempModel = self.arrDataSource[indexPath.row];
    cell.textLabel.text = tempModel.name;
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel sizeToFit];
    return cell.textLabel.bottom + k375Width(10)+1;
    
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
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
