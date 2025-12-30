//
//  WY_ExpertStatusViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/11/3.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ExpertStatusViewController.h"
#import "WY_PerfectListTableViewCell.h"
#import "WY_PerfectInfoViewController.h"
#import "WY_OperationRecordViewController.h"
#import "EmptyView.h"
#import "WY_ZyMoreViewController.h"

@interface WY_ExpertStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *objectArr;
@property (nonatomic , strong) NSMutableArray *arrZyData;

@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_ExpertStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [MS_BasicDataController sharedInstance].user;

    [self makeUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self getWaitExtractProfession];
}

- (void)makeUI {
    self.title = @"专家信息";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(wanShanXinXiGetData)];

    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = NO;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    
    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];

    
    UIButton *cancleButton = [[UIButton alloc] init];
    cancleButton.frame = CGRectMake(0, 0, 44, 44);
    [cancleButton setTitle:@"审核记录" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    
}


#pragma mark - UITableViewDelegate (TableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.objectArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicItem = self.objectArr[indexPath.row];
 
    WY_PerfectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_PerfectListTableViewCell"];

    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    if([dicItem[@"source"] intValue] == 0 || [dicItem[@"source"] intValue] == 1) {
        cell.arrZyData = self.arrZyData;
        [cell showZHCellByItem:dicItem];
        [cell setSelDidMoreBlock:^{
            WY_ZyMoreViewController *tempController = [WY_ZyMoreViewController new];
            [self.navigationController pushViewController:tempController animated:YES];
        }];
        
        [cell setSyncExpertData:^{
            NSLog(@"点击了同步按钮");
            [self syncExpertData];
        }];
        
    } else {
        [cell showCellByItem:dicItem];
    }
    
    return cell;
    
}
- (void)syncExpertData {
    //同步信息成功后 - 刷新接口
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_syncExpertData_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            [self getWaitExtractProfession];
        }else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
 
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接异常"];

    }];
    
}
- (void)getWaitExtractProfession {
    
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getWaitExtractProfession_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            
            self.arrZyData = [[NSMutableArray alloc] initWithArray:res[@"data"]];

            [self wanShanXinXiGetData];
        }else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            
            
        }
 
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接异常"];
        [self.emptyView.contentLabel setFrame:CGRectMake(50, ViewY(self.emptyView.picImgV)+ViewH(self.emptyView.picImgV)+k360Width(10), kScreenWidth-100, 40)];
        [self.emptyView.contentLabel setNumberOfLines:0];
        self.emptyView.contentLabel.text = @"网络连接异常";
        [self.emptyView.contentLabel sizeToFit];
        self.emptyView.contentLabel.height += 20;
        self.emptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];

    }];
}

- (void)wanShanXinXiGetData {
    //先查这个
//    expert/getWaitExtractProfession
    
    
    
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.mUser.UserGuid forKey:@"userGuid"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:expert_getExpertIdentity_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) { 
            if (((NSArray *)res[@"data"]).count > 0) {
                self.objectArr = [[NSMutableArray alloc] initWithArray:res[@"data"]];
                [self.tableView reloadData];
                 self.emptyView.hidden = YES;
            } else {
                self.objectArr = [NSMutableArray new];
                [self.tableView reloadData];
                 self.emptyView.hidden = NO;
            
            [self.emptyView.contentLabel setFrame:CGRectMake(50, ViewY(self.emptyView.picImgV)+ViewH(self.emptyView.picImgV)+k360Width(10), kScreenWidth-100, 40)];
            [self.emptyView.contentLabel setNumberOfLines:0];
            self.emptyView.contentLabel.text = @"当前账号暂无专家身份信息";
            [self.emptyView.contentLabel sizeToFit];
            self.emptyView.contentLabel.height += 20;
            self.emptyView.hidden = NO;
            }
            
        }else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            
            [self.emptyView.contentLabel setFrame:CGRectMake(50, ViewY(self.emptyView.picImgV)+ViewH(self.emptyView.picImgV)+k360Width(10), kScreenWidth-100, 40)];
            [self.emptyView.contentLabel setNumberOfLines:0];
            self.emptyView.contentLabel.text = res[@"msg"];
            [self.emptyView.contentLabel sizeToFit];
            self.emptyView.contentLabel.height += 20;
            self.emptyView.hidden = NO;
        }
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接异常"];
        [self.emptyView.contentLabel setFrame:CGRectMake(50, ViewY(self.emptyView.picImgV)+ViewH(self.emptyView.picImgV)+k360Width(10), kScreenWidth-100, 40)];
        [self.emptyView.contentLabel setNumberOfLines:0];
        self.emptyView.contentLabel.text = @"网络连接异常";
        [self.emptyView.contentLabel sizeToFit];
        self.emptyView.contentLabel.height += 20;
        self.emptyView.hidden = NO;
        [self.tableView.mj_header endRefreshing];

    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dicItem = self.objectArr[indexPath.row];
    /*
     0   没完善过    可以完善；
     1   待核验 - 不可以完善；
     2   行业监管核验通过；不可以完善；
     3   市发改委核验通过；   不可以完善；
     4   省发改委核验通过；   不可以完善；
     5   资质不符        不可以完善；
     6   资料不全        可以完善；
     7   等同于123， 7是省初级核验通过
     10   部分专业未通过  - 可以完善
     */
    int approvalStatusNum = [dicItem[@"approvalStatus"] intValue];
    int updateCityStatus = [dicItem[@"updateCityStatus"] intValue];
    if ([dicItem[@"updateCityStatus"] isEqual:[NSNull null]]) {
        updateCityStatus = 0;
    }
    NSString *jumpToWhere = dicItem[@"jumpToWhere"];
    NSString *source = dicItem[@"source"];
    
    NSString *cellStr = @"";
    
    switch ([dicItem[@"source"] intValue]) {
        case 0:
        {
            cellStr = @"内部/测试人员完善信息";
        }
            break;
        case 1:
        {
            cellStr = @"综合库专家完善信息";
        }
            break;
        case 2:
        {
            cellStr = @"铁路库专家完善信息";
        }
            break;
        case 3:
        {
            cellStr = @"地铁库专家完善信息";
        }
            break;
        
        default:
            break;
    }
    
    switch (approvalStatusNum) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 10:
        {
//            updateCityStatus  4 6 0 都可以正常提交， 其他显示审核中， 基本信息不可编辑修改
            
            switch (updateCityStatus) {
                case 4:
                case 6:
                case 0:
                    break;
                    
                default:
                {
                    approvalStatusNum = 101;//updateCityStatus;
                }
                    break;
            }
            
            WY_PerfectInfoViewController *tempController = [WY_PerfectInfoViewController new];
            tempController.title = cellStr;
            tempController.approvalStatusNum = approvalStatusNum;
            tempController.jumpToWhere = jumpToWhere;
            tempController.source = source;
            tempController.isFormal = [dicItem[@"isFormal"] intValue];
            tempController.isRenewalFlag = [NSString stringWithFormat:@"%@",dicItem[@"renewalFlag"]];
            
            
            
            if (dicItem[@"approvalInfo"] !=nil && ![dicItem[@"approvalInfo"] isEqual:[NSNull null]]) {
                tempController.jujueContent = dicItem[@"approvalInfo"];
            } else {                
                tempController.jujueContent = @"无";
            }
            
            [self.navigationController pushViewController:tempController animated:YES];
        }
            break;
        default:
        {
            [SVProgressHUD showErrorWithStatus:@"您还不具有完善信息资格"];
        }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dicItem = self.objectArr[indexPath.row];
    WY_PerfectListTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if([dicItem[@"source"] intValue] == 0 || [dicItem[@"source"] intValue] == 1) {
        cell.arrZyData = self.arrZyData;
        [cell showZHCellByItem:dicItem];
    } else {
        [cell showCellByItem:dicItem];
    }
     
    return  cell.height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW,  MSScreenH - JCNew64 - JC_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor =HEXCOLOR(0xEDEDED);
        _tableView.sectionFooterHeight = 0.001;
        _tableView.sectionHeaderHeight = 0.001;
         [_tableView registerClass:[WY_PerfectListTableViewCell class] forCellReuseIdentifier:@"WY_PerfectListTableViewCell"];
    }
    
    return _tableView;
}


- (void)navRightAction {
    NSLog(@"操作记录");
    WY_OperationRecordViewController *tempController = [WY_OperationRecordViewController new];
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
