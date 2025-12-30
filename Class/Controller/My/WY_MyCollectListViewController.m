//
//  WY_MyCollectListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/4.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyCollectListViewController.h"
#import "WY_InfomationModel.h"
#import "WY_ReadItemTableViewCell.h"
#import "WY_ReadZoneDetailsViewController.h"
#import "EmptyView.h"
#import "WY_VideoItemTableViewCell.h"
#import "WY_VideoDetailsViewController.h"

@interface WY_MyCollectListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;

@end

@implementation WY_MyCollectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    self.pageItemNum = 10;
    self.currentPage = 1;
    [self makeUI];
    [self bindView];
    self.isFirst = YES;
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserver:self selector:@selector(updateCategoryNumNotify:) name:@"updateCategoryNumNotify" object:nil];
 }

- (void )updateCategoryNumNotify:(NSNotification *)notify {
    if (self.idx == 0) {
        self.selCategorynum  =  notify.object;
        [self dataSourceIndex];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.isItemClicked isEqualToString:@"1"]) {
        if (self.idx != 0) {
            [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
        }
        if (!self.selCategorynum) {
               switch (self.idx) {
                   case 0:
                       self.selCategorynum = @"";
                       
                       break;
                   case 1:
                       self.selCategorynum = @"1";
                       
                       break;
                   case 2:
                       self.selCategorynum = @"2";
                       
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
    if (self.idx != 0) {
        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
    }
    if (!self.selCategorynum) {
        switch (self.idx) {
            case 0:
                self.selCategorynum = @"";
                
                break;
            case 1:
                self.selCategorynum = @"1";
                
                break;
            case 2:
                self.selCategorynum = @"2";
                
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
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin - k360Width(52))];
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
    [postDic setObject:self.selCategorynum forKey:@"xz"];
 
    
    [[MS_BasicDataController sharedInstance] postWithURL:getCollect_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
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
         [self.emptyView.contentLabel setText:@"查询失败"];
         self.emptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];
    } ErrorInfo:^(NSError *error) {
         [self.emptyView.contentLabel setText:@"网络不给力"];
         self.emptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)dataSourceNextPage {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage + 1] forKey:@"currentPage"];
    [postDic setObject:@"1" forKey:@"xz"];
    [postDic setObject:self.selCategorynum forKey:@"categorynum"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:getInformationList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:[WY_InfomationModel class] json:successCallBack[@"data"]];
            self.arrDataSource = [self.arrDataSource arrayByAddingObjectsFromArray:tempArr];
            [self.tableView reloadData];
            
            self.currentPage++;
            
        } else {
         }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.currentPage >= [successCallBack[@"allPageNum"] intValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
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
    
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
    tempModel.infodate = tempModel.createtime;
    if ([tempModel.xz isEqualToString:@"1"]) {
        //文章
        WY_ReadItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_ReadItemTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
        [cell showCellByItem:tempModel];
        return cell;
    } else {
        WY_VideoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_VideoItemTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
        WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
        [cell showCellByItem:tempModel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //更新已读未读状态； 更新后-进入详情页；* type 1申诉 2整改
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
    if ([tempModel.xz isEqualToString:@"1"]) {
    WY_ReadZoneDetailsViewController *tempController = [WY_ReadZoneDetailsViewController new];
    tempController.title = @"详情";
    tempController.mWY_InfomationModel = tempModel;
        [self.navigationController pushViewController:tempController animated:YES];        
    } else {
        WY_VideoDetailsViewController *tempController = [WY_VideoDetailsViewController new];
        tempController.mWY_InfomationModel = tempModel;
        [self.navigationController pushViewController:tempController animated:YES];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
    if ([tempModel.xz isEqualToString:@"1"]) {
        WY_ReadItemTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell showCellByItem:tempModel];
    return cell.frame.size.height;
    } else {
        WY_VideoItemTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell showCellByItem:tempModel];
        return cell.frame.size.height;
    }
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
        [_tableView registerClass:[WY_ReadItemTableViewCell class] forCellReuseIdentifier:@"WY_ReadItemTableViewCell"];
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

@end
