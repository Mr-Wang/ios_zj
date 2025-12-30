//
//  WY_VDListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/8.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_VDListViewController.h"
#import "WY_InfomationModel.h"
#import "WY_VDListTableViewCell.h"
 #import "EmptyView.h"

@interface WY_VDListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSString *selID;
@property (nonatomic) BOOL isFirst;
@property (nonatomic, strong) UILabel *lblCountNum;
@property (nonatomic, strong) UIButton *btnAllPlay;

@end

@implementation WY_VDListViewController

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
    [notifyCenter removeObserver:self name:@"kAutoPlayNext" object:nil];
    [notifyCenter addObserver:self selector:@selector(kAutoPlayNext) name:@"kAutoPlayNext" object:nil];
}
 
- (void) makeUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.lblCountNum = [UILabel new] ;
    [self.lblCountNum setFrame:CGRectMake(k360Width(16), 0, k360Width(120), k360Width(44))];
    [self.view addSubview:self.lblCountNum];

    self.btnAllPlay = [UIButton new];
    [self.btnAllPlay setFrame:CGRectMake(kScreenWidth - k360Width(16 + 90), 0, k360Width(90), k360Width(30))];
    [self.btnAllPlay setBackgroundColor:HEXCOLOR(0xFbFbFb)];
    [self.btnAllPlay setTitle:@" ▶全部播放" forState:UIControlStateNormal];
    [self.btnAllPlay.titleLabel setFont:[UIFont systemFontOfSize:k360Width(12)]];
    [self.btnAllPlay setTitleColor:HEXCOLOR(0xe32113) forState:UIControlStateNormal];
    [self.view addSubview:self.btnAllPlay];
    [self.btnAllPlay addTarget:self action:@selector(allPlayAction) forControlEvents:UIControlEventTouchUpInside];
    self.btnAllPlay.centerY = self.lblCountNum.centerY;
    
    
    [self.tableView setFrame:CGRectMake(0, k360Width(44), kScreenWidth, kScreenHeight - k360Width(260 + 44))];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = YES;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];

    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];

    
}
- (void)zj_viewWillAppearForIndex:(NSInteger)index {
}
#pragma mark --绑定数据
- (void)bindView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
     
    [self dataSourceIndex];
}
- (void)dataSourceIndex{
    self.currentPage = 1;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage] forKey:@"currentPage"];
    [postDic setObject:self.mWY_InfomationModel.infoid forKey:@"infoId"];
 
    [[MS_BasicDataController sharedInstance] postWithURL:getInformationVideoList_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        if (((NSArray *)successCallBack).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_InfomationModel class] json:successCallBack];
            if (!self.selModel) {
                self.selModel = [self.arrDataSource firstObject];
            }
            if (self.selFirstPlayVideoBlock) {
                self.selFirstPlayVideoBlock(self.selModel);
            }
            NSMutableAttributedString *attStr1= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",self.arrDataSource.count]];
            [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
            [attStr1 setYy_color:HEXCOLOR(0xB69C84)];
            NSMutableAttributedString *attStr2= [[NSMutableAttributedString alloc] initWithString:@" 条视频"];
            [attStr2 setYy_font:WY_FONTRegular(12)];

            [attStr2 setYy_color:APPTextGayColor];
            [attStr1 appendAttributedString:attStr2];
            self.lblCountNum.attributedText = attStr1;

            
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
- (void)allPlayAction{
    //更新播放状态； 更新后-进入详情页；* type 1申诉 2整改
    for (WY_InfomationModel *infoModel in self.arrDataSource) {
        infoModel.isPlay = @"0";
    }
 
    WY_InfomationModel *tempModel = [self.arrDataSource firstObject];
    tempModel.isPlay = @"1";
    self.selModel = tempModel;
    if (self.selPlayVideoBlock) {
        self.selPlayVideoBlock(self.selModel);
    }
    [self.tableView reloadData];
}

/// 自动播放下一个视频
- (void)kAutoPlayNext {
    NSInteger arrIndex = [self.arrDataSource indexOfObject:self.selModel];
    self.selModel.isRead = @"1";
    if (arrIndex + 1 < self.arrDataSource.count) {
        for (WY_InfomationModel *infoModel in self.arrDataSource) {
               infoModel.isPlay = @"0";
           }
        
        self.selModel = self.arrDataSource[arrIndex + 1];
        self.selModel.isPlay = @"1";
        if (self.selPlayVideoBlock) {
            self.selPlayVideoBlock(self.selModel);
        }
        [self.tableView reloadData];
    }
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
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
    if (self.selModel && [self.selModel.videourl isEqualToString:tempModel.videourl]) {
        tempModel.isPlay = @"1";
    }
    [cell showCellByItem:tempModel withInt:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //更新播放状态； 更新后-进入详情页；* type 1申诉 2整改
    for (WY_InfomationModel *infoModel in self.arrDataSource) {
        infoModel.isPlay = @"0";
    }
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
    tempModel.isPlay = @"1";
    self.selModel = tempModel;
    if (self.selPlayVideoBlock) {
        self.selPlayVideoBlock(self.selModel);
    }
    [tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_VDListTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_InfomationModel *tempModel = self.arrDataSource[indexPath.row];
    [cell showCellByItem:tempModel withInt:indexPath.row];
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
