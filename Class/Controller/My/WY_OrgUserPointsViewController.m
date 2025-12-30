//
//  WY_OrgUserPointsViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OrgUserPointsViewController.h"
#import "WY_VDListTableViewCell.h"
 #import "EmptyView.h"
#import "WY_PersonalScoreModel.h"

@interface WY_OrgUserPointsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSString *selID;
@property (nonatomic) BOOL isFirst;


@end

@implementation WY_OrgUserPointsViewController

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
     
    - (void) makeUI {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.title = @"企业内人员积分";
        [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
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
         
        [self dataSourceIndex];
    }
    - (void)dataSourceIndex{
        self.currentPage = 1;
 
        [[MS_BasicDataController sharedInstance] postWithURL:getQyryJflb_HTTP params:nil jsonData:nil showProgressView:YES success:^(id successCallBack) {
            
            if (((NSArray *)successCallBack).count > 0) {
 
                self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_PersonalScoreModel class] json:successCallBack];
                 [self.tableView reloadData];

                
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
        
        WY_VDListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_VDListTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
        WY_PersonalScoreModel *tempModel = self.arrDataSource[indexPath.row];
         [cell showOrgIntegralCellByItem:tempModel];
        return cell;
    }

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     }
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        WY_VDListTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        WY_PersonalScoreModel *tempModel = self.arrDataSource[indexPath.row];
        [cell showOrgIntegralCellByItem:tempModel];
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
            [_tableView registerClass:[WY_VDListTableViewCell class] forCellReuseIdentifier:@"WY_VDListTableViewCell"];
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
