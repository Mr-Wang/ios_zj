//
//  WY_MyCreditViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/7/3.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyCreditViewController.h"
#import "EmptyView.h"
#import "WY_MyCreditTableViewCell.h"
#import "WY_CreditMianModel.h"

@interface WY_MyCreditViewController ()
{
    UIView *viewTop;
}
@property (nonatomic, strong) UIView *viewBanner;
@property (nonatomic, strong) UILabel *lblB0;
@property (nonatomic, strong) UILabel *lblB6;
@property (nonatomic, strong) UILabel *lblB1;
@property (nonatomic, strong) UILabel *lblB2;
@property (nonatomic, strong) UILabel *lblB3;
@property (nonatomic, strong) UILabel *lblB4;
@property (nonatomic, strong) UILabel *lblB5;
@property (nonatomic, strong) UILabel *lblLine1;
@property (nonatomic, strong) UILabel *lblLine2;
@property (nonatomic, strong) UILabel *lblLine3;
@property (nonatomic, strong) UILabel *lblLine4;
@property (nonatomic, strong) UIImageView *imgLevel;
@property (nonatomic, strong) UILabel *lblStatus;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) WY_CreditMianModel *mWY_CreditMianModel;
@end

@implementation WY_MyCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
//    [self bindView];
}
- (void)makeUI {
    self.title = @"我的信用";
    [self.view setBackgroundColor:HEXCOLOR(0xfafafa)];
    
    viewTop = [UIView new];
    int topY = MH_APPLICATION_STATUS_BAR_HEIGHT;
    [viewTop setFrame:CGRectMake(0, -topY, kScreenHeight, JCNew64 + topY + k360Width(200))];
    [viewTop setBackgroundColor:MSTHEMEColor];
    [self.view addSubview:viewTop];
    
    UIButton * btnBack = [UIButton new];
    [btnBack setFrame:CGRectMake(k360Width(0), MH_APPLICATION_STATUS_BAR_HEIGHT + k360Width(20), k360Width(44), k360Width(44))];
    [btnBack setImage:[UIImage imageNamed:@"0703_back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:btnBack];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(0, MH_APPLICATION_STATUS_BAR_HEIGHT + k360Width(20), kScreenWidth, k360Width(44))];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setText:@"我的信用"];
    [lblTitle setFont:WY_FONTMedium(16)];
    [viewTop addSubview:lblTitle];
    
    
    
    self.viewBanner = [UIView new];
    [self.viewBanner setFrame:CGRectMake(k360Width(10), 0, kScreenWidth - k360Width(10), k375Width(115))];
    [self.view addSubview:self.viewBanner];
    
    UIImageView *imgBannerBG = [[UIImageView alloc] initWithFrame:self.viewBanner.bounds];
    [imgBannerBG setImage:[UIImage imageNamed:@"0703_xybg"]];
    [self.viewBanner addSubview:imgBannerBG];

    self.lblB0 = [UILabel new];

    self.lblB1 = [UILabel new];
    self.lblB2 = [UILabel new];
    self.lblB3 = [UILabel new];
    self.lblB4 = [UILabel new];
    self.lblB5 = [UILabel new];
    self.lblB6 = [UILabel new];

    self.lblLine1 = [UILabel new];
    self.lblLine2 = [UILabel new];
    self.lblLine3 = [UILabel new];
    self.lblLine4 = [UILabel new];
    
    [self.viewBanner addSubview:self.lblB1];
    [self.viewBanner addSubview:self.lblB2];
    [self.viewBanner addSubview:self.lblB3];
    [self.viewBanner addSubview:self.lblB4];
    [self.viewBanner addSubview:self.lblB5];
    [self.viewBanner addSubview:self.lblB0];
    [self.viewBanner addSubview:self.lblB6];
    [self.viewBanner addSubview:self.lblLine1];
    [self.viewBanner addSubview:self.lblLine2];
    [self.viewBanner addSubview:self.lblLine3];
    [self.viewBanner addSubview:self.lblLine4];
    
    [self.lblB0 setFrame:CGRectMake(0, 0, k360Width(107), self.viewBanner.height)];

    
    [self.lblB1 setFrame:CGRectMake(self.lblB0.right, 0, (self.viewBanner.width - k360Width(107)) / 3 - k360Width(2), self.viewBanner.height/2)];

    [self.lblB2 setFrame:CGRectMake(self.lblB1.right, 0, (self.viewBanner.width - k360Width(107)) / 3 - k360Width(2), self.viewBanner.height/2)];
       
    [self.lblB3 setFrame:CGRectMake(self.lblB2.right, 0, (self.viewBanner.width - k360Width(107)) / 3 - k360Width(2), self.viewBanner.height/2)];
       
    [self.lblB4 setFrame:CGRectMake(self.lblB0.right, self.viewBanner.height/2, (self.viewBanner.width - k360Width(107)) / 3 - k360Width(2), self.viewBanner.height/2)];

    [self.lblB5 setFrame:CGRectMake(self.lblB4.right, self.viewBanner.height/2, (self.viewBanner.width - k360Width(107)) / 3 - k360Width(2), self.viewBanner.height/2)];

    [self.lblB6 setFrame:CGRectMake(self.lblB5.right, self.viewBanner.height/2, (self.viewBanner.width - k360Width(107)) / 3 - k360Width(2), self.viewBanner.height/2)];

    [self.lblB0 setNumberOfLines:0];
    [self.lblB1 setNumberOfLines:0];
    [self.lblB2 setNumberOfLines:0];
    [self.lblB3 setNumberOfLines:0];
    [self.lblB4 setNumberOfLines:0];
    [self.lblB5 setNumberOfLines:0];
    [self.lblB6 setNumberOfLines:0];
    
    [self.lblB0 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblB1 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblB2 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblB3 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblB4 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblB5 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblB6 setLineBreakMode:NSLineBreakByWordWrapping];
    
    
    [self.lblLine1 setFrame:CGRectMake(self.lblB0.right, 2, 1, self.viewBanner.height-4)];
    [self.lblLine1 setBackgroundColor:APPLineColor];
    [self.lblLine2 setFrame:CGRectMake(self.lblB1.right, 2, 1, self.viewBanner.height-4)];
    [self.lblLine2 setBackgroundColor:APPLineColor];
    [self.lblLine3 setFrame:CGRectMake(self.lblB2.right, 2, 1, self.viewBanner.height-4)];
    [self.lblLine3 setBackgroundColor:APPLineColor];
    [self.lblLine4 setFrame:CGRectMake(self.lblB0.right, self.viewBanner.height/2, self.viewBanner.width - self.lblB0.right, 1)];
    [self.lblLine4 setBackgroundColor:APPLineColor];

//    self.lblLine1.centerY = self.lblB1.centerY;
//    self.lblLine2.centerY = self.lblB1.centerY;
//    self.lblLine3.centerY = self.lblB1.centerY;
//    self.lblLine4.centerY = self.lblB1.centerY;

    self.imgLevel = [UIImageView new];
    self.lblStatus = [UILabel new];
    
    [viewTop addSubview:self.imgLevel];
    [viewTop addSubview:self.lblStatus];
    
    [self.imgLevel setFrame:CGRectMake(k375Width(40), lblTitle.bottom + k375Width(30), k375Width(30),k375Width(30))];
    [self.lblStatus setFrame:CGRectMake(self.imgLevel.right + k375Width(25), self.imgLevel.top - k360Width(10), k375Width(250), k375Width(40))];
//    [self.lblStatus setFrame:CGRectMake(k375Width(20), self.imgLevel.top - k360Width(10), kScreenWidth - k360Width(40), k375Width(40))];
    self.lblStatus.centerY = self.imgLevel.centerY;
    [self.lblStatus setTextColor:[UIColor whiteColor]];
    
    [self.lblB1 setTextAlignment:NSTextAlignmentCenter];
    [self.lblB2 setTextAlignment:NSTextAlignmentCenter];
    [self.lblB3 setTextAlignment:NSTextAlignmentCenter];
    [self.lblB4 setTextAlignment:NSTextAlignmentCenter];
    [self.lblB5 setTextAlignment:NSTextAlignmentCenter];
    [self.lblB0 setTextAlignment:NSTextAlignmentCenter];
    [self.lblB6 setTextAlignment:NSTextAlignmentCenter];
    
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    
    viewTop.height = self.lblStatus.bottom + k360Width(60);

    self.viewBanner.top = viewTop.bottom - k375Width(44);

    
    [self.tableView setFrame:CGRectMake(0, self.viewBanner.bottom + k375Width(16), kScreenWidth, kScreenHeight - self.viewBanner.bottom - k375Width(16))];
       [self.tableView setBackgroundColor:[UIColor whiteColor]];
       [self.view addSubview:self.tableView];
       
       self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
       self.emptyView.hidden = YES;
       [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
       self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];

       [self.emptyView.contentLabel setText:@"暂无数据"];
       [self.tableView addSubview:self.emptyView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];

}
 
- (void)bindView {
    if(self.mWY_CreditMianModel.evaluationFee == nil) {
        self.mWY_CreditMianModel.evaluationFee = @"0";
    }
    NSMutableAttributedString *att0 = [[NSMutableAttributedString alloc] initWithString:self.mWY_CreditMianModel.evaluationFee];
    NSMutableAttributedString *att0A = [[NSMutableAttributedString alloc] initWithString:@"元\n\n评审费收入"];
    [att0 setYy_font: WY_FONTMedium(22)];
    [att0 setYy_color:HEXCOLOR(0xFF8330)];
    [att0A setYy_color:HEXCOLOR(0x777676)];
    [att0A setYy_font: WY_FONTRegular(14)];
    [att0 appendAttributedString:att0A];
    self.lblB0.attributedText = att0;
    
    NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:self.mWY_CreditMianModel.criticism];
    NSMutableAttributedString *att1A = [[NSMutableAttributedString alloc] initWithString:@"\n正常评标"];
    [att1 setYy_font: WY_FONTMedium(22)];
    [att1 setYy_color:HEXCOLOR(0xFF8330)];
    [att1A setYy_color:HEXCOLOR(0x777676)];
    [att1A setYy_font: WY_FONTRegular(14)];

    [att1 appendAttributedString:att1A];
    self.lblB1.attributedText = att1;
    
    NSMutableAttributedString *att2 = [[NSMutableAttributedString alloc] initWithString:self.mWY_CreditMianModel.substitute];//beLate
    NSMutableAttributedString *att2A = [[NSMutableAttributedString alloc] initWithString:@"\n替补参加"];//@"\n\n迟 到"
    [att2 setYy_font: WY_FONTMedium(22)];
    [att2 setYy_color:HEXCOLOR(0xFF8330)];
    [att2A setYy_color:HEXCOLOR(0x777676)];
    [att2A setYy_font: WY_FONTRegular(14)];
    [att2 appendAttributedString:att2A];
    self.lblB2.attributedText = att2;
    
    NSMutableAttributedString *att3 = [[NSMutableAttributedString alloc] initWithString:self.mWY_CreditMianModel.leave];
    NSMutableAttributedString *att3A = [[NSMutableAttributedString alloc] initWithString:@"\n请 假"];
    [att3 setYy_font: WY_FONTMedium(22)];
    [att3 setYy_color:HEXCOLOR(0xFF8330)];
    [att3A setYy_color:HEXCOLOR(0x777676)];
    [att3A setYy_font: WY_FONTRegular(14)];
    [att3 appendAttributedString:att3A];
    self.lblB3.attributedText = att3;
    
    NSMutableAttributedString *att4 = [[NSMutableAttributedString alloc] initWithString:self.mWY_CreditMianModel.beLate];
    NSMutableAttributedString *att4A = [[NSMutableAttributedString alloc] initWithString:@"\n迟 到"];
    [att4 setYy_font: WY_FONTMedium(22)];
    [att4 setYy_color:HEXCOLOR(0xFF8330)];
    [att4A setYy_color:HEXCOLOR(0x777676)];
    [att4A setYy_font: WY_FONTRegular(14)];
    [att4 appendAttributedString:att4A];
    self.lblB4.attributedText = att4;
    
    NSMutableAttributedString *att5 = [[NSMutableAttributedString alloc] initWithString:self.mWY_CreditMianModel.substitute];
    NSMutableAttributedString *att5A = [[NSMutableAttributedString alloc] initWithString:@"\n旷 评"];
    [att5 setYy_font: WY_FONTMedium(22)];
    [att5 setYy_color:HEXCOLOR(0xFF8330)];
    [att5A setYy_color:HEXCOLOR(0x777676)];
    [att5A setYy_font: WY_FONTRegular(14)];
    [att5 appendAttributedString:att5A];
    self.lblB5.attributedText = att5;
    
    NSMutableAttributedString *att6 = [[NSMutableAttributedString alloc] initWithString:self.mWY_CreditMianModel.violation];
    NSMutableAttributedString *att6A = [[NSMutableAttributedString alloc] initWithString:@"\n违规/投诉"];
    [att6 setYy_font: WY_FONTMedium(22)];
    [att6 setYy_color:HEXCOLOR(0xFF8330)];
    [att6A setYy_color:HEXCOLOR(0x777676)];
    [att6A setYy_font: WY_FONTRegular(14)];
    [att6 appendAttributedString:att6A];
    self.lblB6.attributedText = att6;
    
    [self.imgLevel setImage:[UIImage imageNamed:@"0703_x0"]];
    //隐藏了等级 只显示文字
//    [self.imgLevel setHidden:YES];
    
    [self.lblStatus setNumberOfLines:2];
    self.lblStatus.text = self.mWY_CreditMianModel.message; //@"2020年度 您的信用等级为中级，继续加油吧";
}

- (void)dataSourceIndex{
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
          [[MS_BasicDataController sharedInstance] postWithReturnCode:expertGetExpertPenalty_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            if ([code integerValue] == 0 && res) {
                self.mWY_CreditMianModel = [WY_CreditMianModel modelWithJSON:res[@"data"]];
                self.arrDataSource = self.mWY_CreditMianModel.infoList;
                [self bindView];
               if (self.arrDataSource.count > 0) {
                                [self.tableView reloadData];
                               self.emptyView.hidden = YES;
                          } else {
                              self.arrDataSource = [NSArray array];
                                self.emptyView.hidden = NO;
                          }
                [self.tableView.mj_header endRefreshing];

           } else {
                [self.emptyView.contentLabel setText:res[@"msg"]];
                self.emptyView.hidden = NO;
               [self.tableView.mj_header endRefreshing];
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
    
    WY_MyCreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_MyCreditTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_CreditItemModel *tempModel = self.arrDataSource[indexPath.row];
    [cell showCellByItem:tempModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入详情页；
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_MyCreditTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_CreditItemModel *tempModel = self.arrDataSource[indexPath.row];
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
        [_tableView registerClass:[WY_MyCreditTableViewCell class] forCellReuseIdentifier:@"WY_MyCreditTableViewCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
           // Fallback on earlier versions
        }
    } 
    return _tableView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    self.navigationController.navigationBar.hidden = YES;
 }

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)btnBackAction {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
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
