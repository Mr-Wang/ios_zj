//
//  WY_MyTQListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyTQListViewController.h"
#import "WY_QuestionModel.h"
#import "WY_MyTQListTableViewCell.h"
#import "WY_MesDelViewController.h"
#import "EmptyView.h"
#import "WY_AddTestQuestionsViewController.h"

@interface WY_MyTQListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;


@end

@implementation WY_MyTQListViewController

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


- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    self.idx = index;
    [self.tableView.mj_header beginRefreshing];
    
    self.isFirst = NO;
}
- (void) makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
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
    //如果是企业主
    if ([self.mUser.UserType isEqualToString:@"2"]) {
        [postDic setObject:@"1" forKey:@"isAudit"];
    } else {
        [postDic setObject:@"0" forKey:@"isAudit"];
    }
    [postDic setObject:self.mUser.orgnum forKey:@"orgGuid"];
    // 0 2 4 5 6 7
    
    switch (self.idx) {
        case 0:
            [postDic setObject:@"0" forKey:@"auditStatus"];
            
            break;
        case 1:
            [postDic setObject:@"2" forKey:@"auditStatus"];
            
            break;
        case 2:
            [postDic setObject:@"4" forKey:@"auditStatus"];
            
            break;
        case 3:
            [postDic setObject:@"5" forKey:@"auditStatus"];
            
            break;
        case 4:
            [postDic setObject:@"6" forKey:@"auditStatus"];
            
            break;
        case 5:
            [postDic setObject:@"7" forKey:@"auditStatus"];
            break;
        default:
            break;
    }
    
    [[MS_BasicDataController sharedInstance] postWithURL:gettQuestionList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_QuestionModel class] json:successCallBack[@"data"]];
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
    if ([self.mUser.UserType isEqualToString:@"2"]) {
        [postDic setObject:@"1" forKey:@"isAudit"];
    } else {
        [postDic setObject:@"0" forKey:@"isAudit"];
    }
    [postDic setObject:self.mUser.orgnum forKey:@"orgGuid"];
    // 0 2 4 5 6 7
    
    switch (self.idx) {
        case 0:
            [postDic setObject:@"0" forKey:@"auditStatus"];
            
            break;
        case 1:
            [postDic setObject:@"2" forKey:@"auditStatus"];
            
            break;
        case 2:
            [postDic setObject:@"4" forKey:@"auditStatus"];
            
            break;
        case 3:
            [postDic setObject:@"5" forKey:@"auditStatus"];
            
            break;
        case 4:
            [postDic setObject:@"6" forKey:@"auditStatus"];
            
            break;
        case 5:
            [postDic setObject:@"7" forKey:@"auditStatus"];
            break;
        default:
            break;
    }
    
    [[MS_BasicDataController sharedInstance] postWithURL:gettQuestionList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:[WY_QuestionModel class] json:successCallBack[@"data"]];
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
    
    WY_MyTQListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_MyTQListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_QuestionModel *tempModel = self.arrDataSource[indexPath.row];
    cell.mUser = self.mUser;
    [cell showCellByItem:tempModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //更新已读未读状态； 更新后-进入详情页；* type 1申诉 2整改
    WY_QuestionModel *tempModel = self.arrDataSource[indexPath.row];

    WY_AddTestQuestionsViewController *tempController = [WY_AddTestQuestionsViewController new];
    tempController.mWY_QuestionModel = tempModel;
    tempController.questionType = tempModel.questionType;//@"1";
    
    if ([tempModel.auditStatus isEqualToString:@"6"] || [tempModel.auditStatus isEqualToString:@"7"]) {
        //被拒绝的 编辑 并且是自己出的题目-可以编辑
        if ([self.mUser.UserGuid isEqualToString:tempModel.userGuid]) {
            //编辑
            tempController.isAddType = @"2";
        } else {
            //查看
            tempController.isAddType = @"3";
        }
    } else {
        //当前用户是企业主 -并且审核状态是 待企业主审核的；
        if ([self.mUser.UserType isEqualToString:@"2"] && [tempModel.auditStatus isEqualToString:@"2"]) {
            //审核
            tempController.isAddType = @"4";
        } else {
            //查看
            tempController.isAddType = @"3";
        }
    } 
    [self.navigationController pushViewController:tempController animated:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_MyTQListTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_QuestionModel *tempModel = self.arrDataSource[indexPath.row];
    cell.mUser = self.mUser;
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
        [_tableView registerClass:[WY_MyTQListTableViewCell class] forCellReuseIdentifier:@"WY_MyTQListTableViewCell"];
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
