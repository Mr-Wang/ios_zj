//
//  WY_ConsultingListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ConsultingListViewController.h"
#import "WY_AExpertQuestionModel.h"
#import "WY_ConsultingTableViewCell.h"
#import "WY_MesDelViewController.h"
#import "EmptyView.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_AddConsultingViewController.h"
#import "WY_InfoConsuItingViewController.h"

@interface WY_ConsultingListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    NSString *selCityCode;
    NSString *selCityName;
    int selStyleId;
    int selReadId;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;

@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnSel1;
@property (nonatomic, strong) UIButton *btnSel2;
@property (nonatomic, strong) UIButton *btnSel3;
@property (nonatomic, strong) UIImageView *imgLineA;


@property (nonatomic ,strong) NSMutableArray *arrZgzs;
@property (nonatomic ,strong) NSMutableArray *arrCityByLN;
@end

@implementation WY_ConsultingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    self.pageItemNum = 10;
    self.currentPage = 1;
    [self makeUI];
    [self initData];
    [self bindView];
    
    self.isFirst = YES;
}
- (void)initData {
 
    [[MS_BasicDataController sharedInstance] getWithReturnCode:jg_regionCityByLN_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 200 && res) {
            self.arrCityByLN =res[@"data"];
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self dataSourceIndex];
}
  
- (void) makeUI {
    selStyleId = -1;
    selReadId = -1;
    selCityCode = @"-1";
    if ([self.nsType isEqualToString:@"2"]) {
        self.title = @"咨询投诉管理";
    } else {
        self.title = @"咨询投诉";
    }
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin - k360Width(50))];
    [self.tableView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = YES;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];

    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];

    self.btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), self.emptyView.bottom + k360Width(5), kScreenWidth - k360Width(30), k360Width(40))];
    [self.btnLeft.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnLeft setTitle:@"新增咨询投诉" forState:UIControlStateNormal];
    [self.btnLeft rounded:k360Width(40/8)];
    [self.btnLeft setBackgroundColor:MSTHEMEColor];
    [self.btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLeft];
    
    
    
    self.btnSel1 = [[UIButton alloc] init];
    self.btnSel1.frame = CGRectMake(0, 0, kScreenWidth /3, 44);
    [self.btnSel1 setTitle:@"选择城市" forState:UIControlStateNormal];
    [self.btnSel1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnSel1 setTitleColor:MSTHEMEColor forState:UIControlStateSelected];

    [self.btnSel1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -k360Width(20), 0, 0)];
    [self.btnSel1 setImage:[UIImage imageNamed:@"0429_down"] forState:UIControlStateNormal];
    [self.btnSel1 setImage:[UIImage imageNamed:@"0429_up"] forState:UIControlStateSelected];
     [self.btnSel1 setImageEdgeInsets:UIEdgeInsetsMake(0, k360Width(90), 0, 0)];
     [self.btnSel1.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSel1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.btnSel1 setSelected:YES];
        NSMutableArray *cityStrArr = [NSMutableArray new];
        [cityStrArr addObject:@"全部城市"];
        for (NSDictionary *cityDic in self.arrCityByLN) {
            [cityStrArr addObject:[cityDic objectForKey:@"name"]];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"请选择城市" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [self.btnSel1 setSelected:NO];
            [self.btnSel1 setTitle:selectedValue forState:UIControlStateNormal];
            selCityName = selectedValue;
            if (selectedIndex == 0) {
                selCityCode = @"-1";
            } else {
                selCityCode = self.arrCityByLN[selectedIndex-1][@"code"];
             }
            [self dataSourceIndex];
         } cancelBlock:^(ActionSheetStringPicker *picker) {
             [self.btnSel1 setSelected:NO];
        } origin:self.view];

    }];
    
    
    self.btnSel2 = [[UIButton alloc] init];
    self.btnSel2.frame = CGRectMake(self.btnSel1.right, 0, kScreenWidth /3, 44);
    [self.btnSel2 setTitle:@"选择类型" forState:UIControlStateNormal];
    [self.btnSel2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnSel2 setTitleColor:MSTHEMEColor forState:UIControlStateSelected];

    [self.btnSel2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -k360Width(20), 0, 0)];
    [self.btnSel2 setImage:[UIImage imageNamed:@"0429_down"] forState:UIControlStateNormal];
    [self.btnSel2 setImage:[UIImage imageNamed:@"0429_up"] forState:UIControlStateSelected];

    [self.btnSel2 setImageEdgeInsets:UIEdgeInsetsMake(0, k360Width(90), 0, 0)];
     [self.btnSel2.titleLabel setFont:WY_FONTMedium(14)];
 
    [self.btnSel2 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.btnSel2 setSelected:YES];
        NSMutableArray *cityStrArr = [NSMutableArray new];
        [cityStrArr addObject:@"全部类型"];
        [cityStrArr addObject:@"咨 询"];
        [cityStrArr addObject:@"投 诉"];
        [cityStrArr addObject:@"建 议"];
        [ActionSheetStringPicker showPickerWithTitle:@"请选择问题类型" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [self.btnSel2 setSelected:NO];
            [self.btnSel2 setTitle:selectedValue forState:UIControlStateNormal];
             selStyleId = selectedIndex;
            [self dataSourceIndex];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            [self.btnSel2 setSelected:NO];
        } origin:self.view];

    }];
    [self.view addSubview:self.btnSel1];
    [self.view addSubview:self.btnSel2];
    
    self.btnSel3 = [[UIButton alloc] init];
    self.btnSel3.frame = CGRectMake(self.btnSel2.right, 0, kScreenWidth /3, 44);
    [self.btnSel3 setTitle:@"回复状态" forState:UIControlStateNormal];
    [self.btnSel3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnSel3 setTitleColor:MSTHEMEColor forState:UIControlStateSelected];

    [self.btnSel3 setTitleEdgeInsets:UIEdgeInsetsMake(0, -k360Width(20), 0, 0)];
    [self.btnSel3 setImage:[UIImage imageNamed:@"0429_down"] forState:UIControlStateNormal];
    [self.btnSel3 setImage:[UIImage imageNamed:@"0429_up"] forState:UIControlStateSelected];

    [self.btnSel3 setImageEdgeInsets:UIEdgeInsetsMake(0, k360Width(90), 0, 0)];
     [self.btnSel3.titleLabel setFont:WY_FONTMedium(14)];
 
    [self.btnSel3 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.btnSel3 setSelected:YES];
        NSMutableArray *cityStrArr = [NSMutableArray new];
        [cityStrArr addObject:@"全部回复"];
        [cityStrArr addObject:@"未回复"];
        [cityStrArr addObject:@"已回复"];
        [ActionSheetStringPicker showPickerWithTitle:@"请选择回复状态" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [self.btnSel3 setSelected:NO];
            [self.btnSel3 setTitle:selectedValue forState:UIControlStateNormal];
            selReadId = selectedIndex;
            [self dataSourceIndex];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            [self.btnSel3 setSelected:NO];
        } origin:self.view];

    }];
    
    [self.view addSubview:self.btnSel3];

    self.imgLineA = [UIImageView new];
    [self.imgLineA setFrame:CGRectMake(0, self.btnSel2.bottom, kScreenWidth, k360Width(1))];
    [self.imgLineA setBackgroundColor:APPLineColor];
    [self.view addSubview:self.imgLineA];
    
    if ([self.nsType isEqualToString:@"1"]) {
        [self.btnLeft setHidden:NO];
        [self.imgLineA setHidden:YES];
        [self.btnSel1 setHidden:YES];
        [self.btnSel2 setHidden:YES];
        [self.btnSel3 setHidden:YES];
        self.tableView.top = 0;
        self.tableView.height = kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin - k360Width(50);
    } else {
        [self.btnLeft setHidden:YES];
        [self.imgLineA setHidden:NO];
        [self.btnSel1 setHidden:NO];
        [self.btnSel2 setHidden:NO];
        [self.btnSel3 setHidden:NO];
        self.tableView.top = k360Width(44);
        self.tableView.height = kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin - k360Width(44);
    }
    
}
#pragma mark --绑定数据
- (void)bindView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dataSourceNextPage)];

 
}
- (void)dataSourceIndex{
    self.currentPage = 1;
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"size"];
    [dicPost setObject:[NSString stringWithFormat:@"%zd",self.currentPage] forKey:@"number"];

    NSString *strUrl = @"";
    if ([self.nsType isEqualToString:@"1"]) {
        NSMutableDictionary *dicPostData = [NSMutableDictionary new];
        [dicPostData setObject:self.mUser.idcardnum forKey:@"expertIdCard"];
        [dicPost setObject:dicPostData forKey:@"data"];
        strUrl = jg_expertQuestionGetMyQuestion_HTTP;
    } else {
        NSMutableDictionary *dicPostData = [NSMutableDictionary new];

        if (selStyleId > 0) {
            [dicPostData setObject:[NSString stringWithFormat:@"%d",selStyleId] forKey:@"qaType"];
        }
        if (selReadId > 0) {
            [dicPostData setObject:[NSString stringWithFormat:@"%d",selReadId-1] forKey:@"isAnswer"];
        }
        
        
        if (![selCityCode isEqualToString:@"-1"]) {
            [dicPostData setObject:selCityCode forKey:@"qaCityCode"];
        }
        [dicPost setObject:dicPostData forKey:@"data"];

        strUrl = jg_expertQuestionGetQuestionForAdmin_HTTP;
    }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:strUrl params:nil jsonData:[dicPost mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 200 && res) {
            if (((NSArray *)res[@"data"][@"list"]).count > 0) {
                self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_AExpertQuestionModel class] json:res[@"data"][@"list"]];
                  self.emptyView.hidden = YES;
            } else {
                self.arrDataSource = [NSArray array];
                 self.emptyView.hidden = NO;
            }
            
            if (self.currentPage >= [res[@"data"][@"totalPage"] intValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer resetNoMoreData];
            }
          } else {
            [self.view makeToast:res[@"message"]];
              [self.emptyView.contentLabel setText:res[@"message"]];
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



- (void)dataSourceNextPage {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"size"];
    [dicPost setObject:[NSString stringWithFormat:@"%zd",self.currentPage+1] forKey:@"number"];

    NSString *strUrl = @"";
    if ([self.nsType isEqualToString:@"1"]) {
        NSMutableDictionary *dicPostData = [NSMutableDictionary new];
        [dicPostData setObject:self.mUser.idcardnum forKey:@"expertIdCard"];
        [dicPost setObject:dicPostData forKey:@"data"];
        strUrl = jg_expertQuestionGetMyQuestion_HTTP;
    } else {
        NSMutableDictionary *dicPostData = [NSMutableDictionary new];

        if (selStyleId > 0) {
            [dicPostData setObject:[NSString stringWithFormat:@"%d",selStyleId] forKey:@"qaType"];
        }
        if (selReadId > 0) {
            [dicPostData setObject:[NSString stringWithFormat:@"%d",selReadId - 1] forKey:@"isAnswer"];
        }
        if (![selCityCode isEqualToString:@"-1"]) {
            [dicPostData setObject:selCityCode forKey:@"qaCityCode"];
        }
        [dicPost setObject:dicPostData forKey:@"data"];

        strUrl = jg_expertQuestionGetQuestionForAdmin_HTTP;
    }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:strUrl params:nil jsonData:[dicPost mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 200 && res) {
            if (((NSArray *)res[@"data"][@"list"]).count > 0) {
                NSArray *tempArr = [NSArray yy_modelArrayWithClass:[WY_AExpertQuestionModel class] json:res[@"data"][@"list"]];
                self.arrDataSource = [self.arrDataSource arrayByAddingObjectsFromArray:tempArr];
                self.currentPage ++;
                   self.emptyView.hidden = YES;
            } else {
                self.arrDataSource = [NSArray array];
                 self.emptyView.hidden = NO;
            }
          } else {
            [self.view makeToast:res[@"message"]];
              self.arrDataSource = [NSArray array];
               self.emptyView.hidden = NO;
        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.currentPage >= [res[@"data"][@"totalPage"] intValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        
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
    
    WY_ConsultingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_ConsultingTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_AExpertQuestionModel *tempModel = self.arrDataSource[indexPath.row];
    [cell showCellDocByItem:tempModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WY_AExpertQuestionModel *tempModel = self.arrDataSource[indexPath.row];

    WY_InfoConsuItingViewController *tempController = [WY_InfoConsuItingViewController new];
    tempController.eqModel = tempModel;
    tempController.nsType = self.nsType;
    [self.navigationController pushViewController:tempController animated:YES];
    
//    WY_AExpertQuestionModel *tempModel = self.arrDataSource[indexPath.row];
//
//    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
//   wk.isShare = @"1";
//   wk.titleStr = tempModel.docTitle;
//   wk.webviewURL = tempModel.docUrl;
//   UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
//   navi.navigationBarHidden = NO;
//   navi.modalPresentationStyle = UIModalPresentationFullScreen;
//   [self presentViewController:navi animated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_ConsultingTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_AExpertQuestionModel *tempModel = self.arrDataSource[indexPath.row];
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
        [_tableView registerClass:[WY_ConsultingTableViewCell class] forCellReuseIdentifier:@"WY_ConsultingTableViewCell"];
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

- (void)btnLeftAction {
    NSLog(@"点击了新增");
    WY_AddConsultingViewController *tempController =  [WY_AddConsultingViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
    
}

@end
