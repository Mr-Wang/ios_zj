//
//  WY_OTDMessageBoardViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OTDMessageBoardViewController.h"
#import "WY_GuestBookModel.h"
#import "WY_OTDMessageTableViewCell.h"
#import "EmptyView.h"
#import "WY_LoginViewController.h"

@interface WY_OTDMessageBoardViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSTimer *mNSTimer;

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;


@end

@implementation WY_OTDMessageBoardViewController

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
- (void) viewWillAppear:(BOOL)animated {
    //30秒刷新一次留言板
    if (mNSTimer) {
        [mNSTimer invalidate];
        mNSTimer = nil;
    }
    mNSTimer = [NSTimer scheduledTimerWithTimeInterval:30 block:^(NSTimer * _Nonnull timer) {
        if (self.arrDataSource > 0) {
            [self dataSourceIndex];
        }
    } repeats:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (mNSTimer) {
        [mNSTimer invalidate];
    }
}
 - (void)dealloc {
     [mNSTimer invalidate];
 }
 
- (void)zj_viewWillAppearForIndex:(NSInteger)index {
//    self.idx = index;
     [self.tableView.mj_header beginRefreshing];
    
    self.isFirst = NO;
}
- (void) makeUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64  - k360Width(244 + 50) - JC_TabbarSafeBottomMargin)];
    [self.tableView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.tableView.bounds];
    self.emptyView.hidden = YES;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];

    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.tableView addSubview:self.emptyView];

    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.tableView.bottom,kScreenWidth - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.view addSubview:imgLine];

    UITextField *txtSend = [[UITextField alloc] init];
    [txtSend setFrame:CGRectMake(k360Width(16), self.tableView.bottom + k360Width(10), kScreenWidth - k360Width(32), k360Width(30))];
    txtSend.placeholder = @"请在这里留言";
     UIView *lv1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(16), k360Width(16))];
    txtSend.leftViewMode = UITextFieldViewModeAlways;
    txtSend.leftView = lv1;

    [txtSend setUserInteractionEnabled:NO];
    [txtSend setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    [txtSend rounded:k360Width(30 / 8)];
    [self.view addSubview:txtSend];
    
    UIControl *colSend = [UIControl new];
    [colSend setBackgroundColor:[UIColor clearColor]];
    [colSend setFrame:txtSend.frame];
    [self.view addSubview:colSend];
    [colSend addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了留言功能");
        [self sendMessageAlert];
    }];
    
    
}


///提交留言
- (void)sendMessageAlert {
    //判断登录状态
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"留言板" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请在这里输入内容";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *alertTxt = alertController.textFields[0].text;
        NSLog(@"微信：%@",alertTxt);
        if (alertTxt.length > 0) {
            [self sendMessageByStr:alertTxt];
        }else {
            [self.view makeToast:alertController.textFields[0].placeholder duration:1 position:CSToastPositionCenter];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
        }
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)sendMessageByStr :(NSString *)messageStr {
    WY_GuestBookModel *mesModel = [WY_GuestBookModel new];
    mesModel.classGuid = self.mWY_TraCourseDetailModel.ClassGuid;
    mesModel.content = messageStr;
    mesModel.idcardnum = self.mUser.idcardnum;
    mesModel.danWeiName = self.mUser.DanWeiName;
    mesModel.phone = self.mUser.LoginID;
    mesModel.name = self.mUser.realname;
     
    [[MS_BasicDataController sharedInstance] postWithURL:insetTTrainmessage_HTTP params:nil jsonData:[mesModel toJSONData] showProgressView:YES success:^(id successCallBack) {
        MSLog(@"添加留言成功");
        [self dataSourceIndex];
     } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

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
     [postDic setObject:self.mWY_TraCourseDetailModel.ClassGuid forKey:@"classGuid"];
     [postDic setObject:self.mUser.idcardnum forKey:@"idcardnum"];

    
    [[MS_BasicDataController sharedInstance] postWithURL:getTrainmessage_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_GuestBookModel class] json:successCallBack[@"data"]];
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
     NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage + 1] forKey:@"currentPage"];
    [postDic setObject:self.mWY_TraCourseDetailModel.ClassGuid forKey:@"classGuid"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idcardnum"];

    [[MS_BasicDataController sharedInstance] postWithURL:getTrainmessage_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:[WY_GuestBookModel class] json:successCallBack[@"data"]];
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
    
    WY_OTDMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_OTDMessageTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    WY_GuestBookModel *tempModel = self.arrDataSource[indexPath.row];
    [cell showCellByItem:tempModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_OTDMessageTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    WY_GuestBookModel *tempModel = self.arrDataSource[indexPath.row];
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
        [_tableView registerClass:[WY_OTDMessageTableViewCell class] forCellReuseIdentifier:@"WY_OTDMessageTableViewCell"];
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
