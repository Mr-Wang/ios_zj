//
//  WY_OtherPointsDeductedListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2023/2/8.
//  Copyright © 2023 王杨. All rights reserved.
//

#import "WY_OtherPointsDeductedListViewController.h"
#import "EmptyView.h"
#import "WY_ExpertModel.h"
#import "WY_BonusPointsTableViewCell.h"
#import "IWPictureModel.h"
#import "ImageNewsDetailViewController.h"
#import "MS_WKwebviewsViewController.h"

@interface WY_OtherPointsDeductedListViewController ()
@property (nonatomic, strong) UILabel *lblTopTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@end

@implementation WY_OtherPointsDeductedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
    [self bindView];
    [self dataSourceIndex];
    
}
- (void) makeUI {
    self.title = @"其他扣分";
//    self.lblTopTitle = [UILabel new];
//    [self.lblTopTitle setFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), k360Width(44))];
//    self.lblTopTitle.text = [NSString stringWithFormat:@"其他扣分：%@分",self.bonusPoints];
//    [self.view addSubview:self.lblTopTitle];
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [self.view addSubview:viewBlue1];
    self.lblTopTitle = [UILabel new];
    [self.lblTopTitle setFrame:CGRectMake(viewBlue1.right + 8, 0, self.view.width - k360Width(32), k360Width(44))];
    [self.lblTopTitle setFont:WY_FONTMedium(14)];
    self.lblTopTitle.text = [NSString stringWithFormat:@"其他扣分：%@分",self.bonusPoints];
    [self.view addSubview:self.lblTopTitle];
     
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    [self.tableView setFrame:CGRectMake(0, self.lblTopTitle.bottom, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin - self.lblTopTitle.bottom)];
    [self.tableView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = YES;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    
    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];
    
 
}
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark --绑定数据
- (void)bindView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
 
    
}
- (void)dataSourceIndex{
     NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    //奖励加分列表
    [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_getOtherPoints_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        NSLog(@"获取数据成功");
        if (((NSArray *)res[@"data"]).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_ExpertModel class] json:res[@"data"]];
            self.emptyView.hidden = YES;
        } else {
            self.arrDataSource = [NSArray array];
            self.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
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
    
    WY_BonusPointsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_BonusPointsTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
     cell.mUser = self.mUser;
    [cell showCellOPByItem:tempModel];
    cell.btnImageShowBlock = ^(NSString * _Nonnull withUrl) {
        
        if ([withUrl rangeOfString:@".pdf"].length > 0) { 
            MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
            wk.titleStr = @"查看附件";
            wk.webviewURL = withUrl;
            wk.isShare = @"1";
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:NO completion:nil];
        } else {
            IWPictureModel* picModel  = [IWPictureModel new];
            picModel.nsbmiddle_pic = withUrl;
            picModel.nsoriginal_pic = withUrl;
            ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
            indvController.mIWPictureModel = picModel;
            indvController.picArr = @[picModel];
            [self.navigationController pushViewController:indvController animated:YES];
        }
        
       
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //评分暂时加这里
//    WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
//    WY_EvaluationAgencyViewController *tempController = [WY_EvaluationAgencyViewController new];
//    tempController.mWY_ExpertModel = tempModel;
//    [self.navigationController pushViewController:tempController animated:YES];
    
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_BonusPointsTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_ExpertModel *tempModel = self.arrDataSource[indexPath.row];
     cell.mUser = self.mUser;
    [cell showCellOPByItem:tempModel];
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
        [_tableView registerClass:[WY_BonusPointsTableViewCell class] forCellReuseIdentifier:@"WY_BonusPointsTableViewCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
           // Fallback on earlier versions
        }
    }
    
    return _tableView;
}

 

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
  
@end

