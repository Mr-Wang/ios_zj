//
//  WY_CAOrderListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/18.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_CAOrderListViewController.h"
#import "EmptyView.h"
#import "WY_CompleteStatusModel.h"
#import "WY_CAOrderTableViewCell.h"
#import "WY_MesDelViewController.h"
#import "WY_CAOrderInfoViewController.h"
#import <WXApi.h>
#import "WY_PayNeedModel.h"
#import "OSSXMLDictionary.h"
#import "WY_CaOnlinePayCallBackModel.h"
#import <AlipaySDK/AlipaySDK.h>

@interface WY_CAOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isFirst;
@property (nonatomic , strong) NSMutableDictionary *dicSignUpSuccess;
@property (nonatomic , strong) NSString *payType;//03是微信、02是支付宝
@end

@implementation WY_CAOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    self.pageItemNum = 10;
    self.currentPage = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chenggong) name:@"chenggong" object:nil];
    
    [self makeUI];
    [self bindView];
    
    self.isFirst = YES;
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"白返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
    self.navigationItem.leftBarButtonItem = right;
    
}
- (void)makeUI {
    self.title = @"订单管理";
    [self.view setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin - k360Width(50+16))];
    [self.tableView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
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

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    
    
}
#pragma mark --绑定数据、
- (void)bindView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
    
}
- (void)dataSourceIndex{
    self.currentPage = 1;
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.UserGuid forKey:@"UserGuid"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.pageItemNum] forKey:@"pageItemNum"];
    [postDic setObject:[NSString stringWithFormat:@"%zd",self.currentPage] forKey:@"currentPage"];
    
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_getMyDeal_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        if (((NSArray *)successCallBack[@"data"]).count > 0) {
            self.arrDataSource =  successCallBack[@"data"];//[NSArray yy_modelArrayWithClass:[WY_CompleteStatusModel class] json:successCallBack];
            if (self.currentPage >=[successCallBack[@"allPageNum"] intValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer resetNoMoreData];
            }
            self.emptyView.hidden = YES;
        } else {
            self.arrDataSource = [NSArray array];
            self.emptyView.hidden = NO;
            [self.emptyView.contentLabel setText:@"暂无数据"]; 
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

#pragma mark - UITableViewDelegate (TableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrDataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WY_CAOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_CAOrderTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MSScreenW);
    NSMutableDictionary *tempModel = self.arrDataSource[indexPath.row];
    cell.mUser = self.mUser;
    [cell showCellByItem:tempModel];
    
    [cell.btnDel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了取消订单按钮");
        self.dicSignUpSuccess = tempModel;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否取消订单" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *postDic = [NSMutableDictionary new];
            [postDic setObject:self.dicSignUpSuccess[@"OrderNo"] forKey:@"OrderNo"];
            [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_CAdeleteDD_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                if (([code integerValue] == 0) && res) {
                    [self dataSourceIndex];
                } else {
                    [self.view makeToast:res[@"msg"]];
                }
            } failure:^(NSError *error) {
                [self.view makeToast:@"请求失败，请稍后再试"];
            }];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [cell.btnShouHuo addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了付款、或是收货按钮");
        if ([tempModel[@"orderStatus"] intValue] == 1) {
            //调支付
            self.dicSignUpSuccess = tempModel;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否现在去支付" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定");
                self.payType = @"03";
                [self weiXinPay];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定");
                self.payType = @"02";
                [self weiXinPay];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        } else {
            //调收货
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定");
                NSMutableDictionary *postDic = [NSMutableDictionary new];
                [postDic setObject:self.dicSignUpSuccess[@"OrderNo"] forKey:@"OrderNo"];
                [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_CAreceipt_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                    if (([code integerValue] == 0) && res) {
                        [self dataSourceIndex];
                    } else {
                        [self.view makeToast:res[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [self.view makeToast:@"请求失败，请稍后再试"];
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WY_CAOrderInfoViewController *tempController =[WY_CAOrderInfoViewController new];
    NSMutableDictionary *tempModel = self.arrDataSource[indexPath.row];
    
    tempController.orderID = tempModel[@"OrderNo"];
    
    [self.navigationController pushViewController:tempController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_CAOrderTableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *tempModel = self.arrDataSource[indexPath.row];
    cell.mUser = self.mUser;
    [cell showCellByItem:tempModel];
    return cell.frame.size.height;
    
}


-(CGFloat)tableView:(UITableView *)tableView   heightForHeaderInSection:(NSInteger)section{
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
        [_tableView registerClass:[WY_CAOrderTableViewCell class] forCellReuseIdentifier:@"WY_CAOrderTableViewCell"];
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

- (void)weiXinPay {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [self tongLianPay];
    return;
    NSLog(@"确认支付");
    WY_PayNeedModel *tempPayModel = [WY_PayNeedModel new];
    tempPayModel.orderGuid = self.dicSignUpSuccess[@"OrderGuid"];
    tempPayModel.paymethod = self.payType;
    tempPayModel.body = self.dicSignUpSuccess[@"sqjg"];
    tempPayModel.userGuid =  self.mUser.UserGuid;
    tempPayModel.out_trade_no = self.dicSignUpSuccess[@"OrderNo"];
    
    //       tempPayModel.orderDetailBean = self.mWY_SendEnrolmentMessageModel.toJSONString;
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:onlinepay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if ([res[@"data"][@"responseString"] isEqual:[NSNull null]]) {
                [SVProgressHUD showErrorWithStatus:@"接口数据返回错误-请稍后再试"];
                //                     [btnGoInfo setEnabled:YES];
                
                return ;
            }
            
            WY_CaOnlinePayCallBackModel *tempPayModel = [WY_CaOnlinePayCallBackModel new];
            tempPayModel.OrderGuid = self.dicSignUpSuccess[@"OrderNo"];
            tempPayModel.userGuid =  self.mUser.UserGuid;
            tempPayModel.paymethod = self.payType;
            
//            [[MS_BasicDataController sharedInstance] postWithReturnCode:backonlinepay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
//                if ([code integerValue] == 0 ) {
//                    NSLog(@"回调轮询方法成功");
//                } else {
//                    NSLog(@"回调轮询方法失败");
//                }
//            } failure:^(NSError *error) {
//                NSLog(@"回调轮询方法500错误");
//            }];
            
            NSDictionary *responseStringDic = [NSDictionary oss_dictionaryWithXMLString:res[@"data"][@"responseString"]];
            
            if ([responseStringDic[@"result_code"] isEqualToString:@"FAIL"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseStringDic[@"err_code_des"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            if ([self.payType isEqualToString:@"03"]) {
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = @"wxd2381bec1a8984de";
                req.nonceStr            = responseStringDic[@"nonce_str"];
                req.package             = @"Sign=WXPay";
                req.partnerId           = responseStringDic[@"mch_id"];
                req.timeStamp           = [[NSDate date] timeIntervalSince1970];
                req.prepayId            = responseStringDic[@"prepay_id"];
                
                NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
                [signParams setObject: req.openID        forKey:@"appid"];
                [signParams setObject: req.nonceStr    forKey:@"noncestr"];
                [signParams setObject: req.package      forKey:@"package"];
                [signParams setObject: req.partnerId        forKey:@"partnerid"];
                [signParams setObject: [NSString stringWithFormat:@"%u", (unsigned int)req.timeStamp]   forKey:@"timestamp"];
                [signParams setObject: req.prepayId     forKey:@"prepayid"];
                //生成签名
                NSString *sign  = [self createMd5Sign:signParams];
                req.sign = sign;
                //responseStringDic[@"sign"];
                //                 req.sign = responseStringDic[@"sign"];
                [WXApi sendReq:req completion:^(BOOL success) {
                    if (success) {
                        NSLog(@"成功");
                        
                    } else {
                        NSLog(@"失败");
                    }
                }];
            }else if ([self.payType isEqualToString:@"02"]) {
                //支付宝支付
                [[AlipaySDK defaultService] payOrder:res[@"data"][@"responseString"] fromScheme:@"lnzjfw" callback:^(NSDictionary *resultDic) {
                    NSLog(@"支付宝支付");
                }];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            //                 [btnGoInfo setEnabled:YES];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        //           [btnGoInfo setEnabled:YES];
    }];
}



- (void)tongLianPay {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    NSLog(@"确认支付");
    WY_PayNeedModel *tempPayModel = [WY_PayNeedModel new];
    tempPayModel.orderGuid = self.dicSignUpSuccess[@"OrderGuid"];
    tempPayModel.paymethod = self.payType;
    tempPayModel.body = self.dicSignUpSuccess[@"sqjg"];
    tempPayModel.userGuid =  self.mUser.UserGuid;
    tempPayModel.out_trade_no = self.dicSignUpSuccess[@"OrderNo"];
    if ([self.payType isEqualToString:@"03"]) {
        [self weixinXCXPay:tempPayModel];
        return;
    } else {
        [[MS_BasicDataController sharedInstance] postWithReturnCode:allinPay_HTTP params:nil jsonData:[tempPayModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
            if ([code integerValue] == 0 ) {
                if ([self.payType isEqualToString:@"02"]) {
                    [self aliPayGoByQrCode:res[@"data"][@"responseString"]];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
    }
}

- (void)weixinXCXPay:(WY_PayNeedModel *)tempPayModel {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = @"gh_65f0c33e8486";  //拉起的小程序的username
    launchMiniProgramReq.path = [NSString stringWithFormat:@"pages/pay/pay?orderGuid=%@&out_trade_no=%@&paymethod=%@&userGuid=%@&body=%@&token=%@",tempPayModel.orderGuid,tempPayModel.out_trade_no,tempPayModel.paymethod,self.mUser.UserGuid,tempPayModel.body,self.mUser.token];
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        NSLog(@"成功");
        [self waitingForPayment];
    }];
}

-(void)aliPayGoByQrCode:(NSString *)qrCode {
    // 是否支持支付宝
    //    qrCode = @"https://qr.alipay.com/bax01054bkx6hafqhile00cf";
    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay://"];
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        // 跳转扫一扫
        NSURL * url2 = [NSURL URLWithString:[NSString stringWithFormat:@"alipay://platformapi/startapp?saId=10000007&qrcode=%@",qrCode]];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url2 options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url2];
        }
        [self waitingForPayment];
    } else {
        [SVProgressHUD showErrorWithStatus:@"没有安装支付宝"];
    }
}


- (void)waitingForPayment {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你有一笔支付正在进行中,请稍后再进行新的操作" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"已完成支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        [self chenggong];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)chenggong{
    //              WY_CAPaySuccessViewController *tempController = [WY_CAPaySuccessViewController new];
    //              [self.navigationController pushViewController:tempController animated:YES];
    
    //已支付
    [self dataSourceIndex];
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"MIIEvQIBADANBgkqhkiG9w0BAQEFAA12"];
    //得到MD5 sign签名
    NSString *md5Sign = [contentString md5String]; //[WXUtil md5:contentString];
    
    NSLog(@"MD5签名字符串：%@",contentString);
    return md5Sign;
}

- (void)closeClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
