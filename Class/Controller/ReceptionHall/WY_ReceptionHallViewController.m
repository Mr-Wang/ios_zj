//
//  WY_ReceptionHallViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/9/24.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ReceptionHallViewController.h"
#import "WY_BiddingProjectTableViewCell.h"
#import "EmptyView.h"
@interface WY_ReceptionHallViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WY_ReceptionHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];

      self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
}

- (void)dataSourceIndex{
    [self.tableView.mj_header endRefreshing];

}
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];

}
- (void) makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.tableView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = NO;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    
    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        [_tableView registerClass:[WY_BiddingProjectTableViewCell class] forCellReuseIdentifier:@"WY_BiddingProjectTableViewCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
           // Fallback on earlier versions
        }

     }
    
    return _tableView;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
        WY_BiddingProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_BiddingProjectTableViewCell"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
 

@end
