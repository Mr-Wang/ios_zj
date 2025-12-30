//
//  WY_ExpertFeeListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/6.
//  Copyright © 2022 王杨. All rights reserved.
//

#import "WY_ExpertFeeListViewController.h"
#import "WY_ExpertFeeModel.h"
#import "WY_ExpertFeeListTableViewCell.h"
#import "WY_TrainDetailsViewController.h"
#import "EmptyView.h"
#import "WY_OnlineTrainDetailsViewController.h"
#import "WY_ExpertFeeInfoViewController.h"

@interface WY_ExpertFeeListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;

@end

@implementation WY_ExpertFeeListViewController

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
    if ([self.isItemClicked isEqualToString:@"1"]) {
        //        clearingStatus    结算状态  0待结算  1已结算  2结算中
        
        if (!self.selCategorynum) {
            switch (self.idx) {
                case 0:
                    //                    全部 ""
                    self.selCategorynum = @"";
                    
                    break;
                case 1:
                    //                    待结算 0
                    self.selCategorynum = @"0";
                    
                    break;
                case 2:
                    //                    结算中 1
                    self.selCategorynum = @"2";
                    
                    break;
                case 3:
                    //                    已完成 2
                    self.selCategorynum = @"1";
                    
                    break;
                case 4:
                    //  异议
                    self.selCategorynum = @"3";
                    break;
                default:
                    break;
            }
        }
        [self.tableView.mj_header beginRefreshing];
    }
}
- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    self.idx = index;
    
    if (!self.selCategorynum) {
        switch (self.idx) {
            case 0:
                //                    全部 ""
                self.selCategorynum = @"";
                
                break;
            case 1:
                //                    待结算 0
                self.selCategorynum = @"0";
                
                break;
            case 2:
                //                    结算中 1
                self.selCategorynum = @"2";
                
                break;
            case 3:
                //                    已完成 2
                self.selCategorynum = @"1";
                
                break;
            case 4:
                //  异议
                self.selCategorynum = @"3";
                break;
            default:
                break;
        }
    }
    [self.tableView.mj_header beginRefreshing];
    
    self.isFirst = NO;
}

- (void) makeUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - k360Width(52) - JCNew64 - JC_TabbarSafeBottomMargin )];
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
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dataSourceNextPage)];
    
}


- (void)dataSourceIndex{
    self.currentPage = 1;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage] forKey:@"currentPage"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idcardnum"];
    [postDic setObject:self.selCategorynum forKey:@"clearingStatus"];
    //    [postDic setObject:@"1" forKey:@"xz"];
    //        if (self.keyword) {
    //            [postDic setObject:self.keyword forKey:@"keyword"];
    //            [postDic setObject:@"4" forKey:@"type"];
    //
    //        } else {
    //    [postDic setObject:self.selCategorynum forKey:@"type"];
    //        }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getBidEvaluationFeeList_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if (((NSArray *)res[@"data"][@"data"]).count > 0) {
                self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_ExpertFeeModel class] json:res[@"data"][@"data"]];
                for (WY_ExpertFeeModel *tempModel in self.arrDataSource) {
                    tempModel.msg = res[@"msg"];
                }
                
                //                   [SVProgressHUD showSuccessWithStatus:@"查询成功"];
                [self.tableView reloadData];
                if (self.currentPage >=[res[@"data"][@"allPageNum"] intValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
                self.emptyView.hidden = YES;
            } else {
                self.arrDataSource = [NSArray array];
                self.emptyView.hidden = NO;
            }
        } else {
            self.emptyView.hidden = NO;
            [self.emptyView.contentLabel setText:@"查询失败"];
            
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.emptyView.hidden = NO;
        [self.emptyView.contentLabel setText:@"网络不给力"];
    }];
}
- (void)dataSourceNextPage {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage + 1] forKey:@"currentPage"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idcardnum"];
    [postDic setObject:self.selCategorynum forKey:@"clearingStatus"];
    //    [postDic setObject:@"1" forKey:@"xz"];
    //    if (self.keyword) {
    //            [postDic setObject:self.keyword forKey:@"keyword"];
    //        [postDic setObject:@"4" forKey:@"type"];
    //
    //        } else {
    //    [postDic setObject:self.selCategorynum forKey:@"type"];
    //        }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getBidEvaluationFeeList_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            NSLog(@"获取数据成功");
            if (((NSArray *)res[@"data"][@"data"]).count > 0) {
                NSArray *tempArr = [NSArray yy_modelArrayWithClass:[WY_ExpertFeeModel class] json:res[@"data"][@"data"]];
                self.arrDataSource = [self.arrDataSource arrayByAddingObjectsFromArray:tempArr];
                for (WY_ExpertFeeModel *tempModel in self.arrDataSource) {
                    tempModel.msg = res[@"msg"];
                }
                [self.tableView reloadData];
                self.currentPage++;
            }
            if (self.currentPage >= [res[@"data"][@"allPageNum"] intValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
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
    
    WY_ExpertFeeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_ExpertFeeListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_ExpertFeeModel *tempModel = self.arrDataSource[indexPath.row];
    [cell showCellByItem:tempModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //更新已读未读状态； 更新后-进入详情页；* type 1申诉 2整改
    WY_ExpertFeeModel *tempModel = self.arrDataSource[indexPath.row];
    WY_ExpertFeeInfoViewController *tempController = [WY_ExpertFeeInfoViewController new];
    tempController.infoID = tempModel.expertId;
    tempController.nsID = tempModel.id;
    [self.navigationController pushViewController:tempController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_ExpertFeeListTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_ExpertFeeModel *tempModel = self.arrDataSource[indexPath.row];
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
        
        [_tableView registerClass:[WY_ExpertFeeListTableViewCell class] forCellReuseIdentifier:@"WY_ExpertFeeListTableViewCell"];
        _tableView.sectionHeaderHeight = 0.01;
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
