//
//  WY_ExpertFeeInfoViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/6.
//  Copyright © 2022 王杨. All rights reserved.
//

#import "WY_ExpertFeeInfoViewController.h"
#import "WY_SettlementRecordViewController.h"
#import "WY_ExpenseObjectionViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_SignViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface WY_ExpertFeeInfoViewController () {
    int lastY;
    int zk1;
    int zk2;
    int zkTop;
    
    
    UIView *pdfView;
    UIButton *btnUp;
    UIButton *btnReSign;
    UIButton *btnSubmit;
    NSString *isAgree;
    NSString *isSignText;
    WKWebView *webview;
}
@property (nonatomic ,strong) UIScrollView *mScrollView;
@property (nonatomic ,strong) UILabel *lblState;
@property (nonatomic ,strong) UILabel *lblMsg;
@property (nonatomic ,strong) NSString *msgStr;
@property (nonatomic ,strong) UIButton *btnSubmit;
@property (nonatomic ,strong) NSMutableDictionary *dicDataSource;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSString * mSignUrl;
@property (nonatomic, strong) NSMutableDictionary *signSuccessDic;
@end

@implementation WY_ExpertFeeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    // Do any additional setup after loading the view.
    [self makeUI];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [self dataSource];
}
- (void)makeUI {
    self.title = @"劳务报酬结算";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"白返回" highImage:@"返回" ];

    
//    UIButton *cancleButton = [[UIButton alloc] init];
//    cancleButton.frame = CGRectMake(0, 0, 44, 44);
//    [cancleButton.titleLabel setFont:WY_FONTMedium(12)];
//    [cancleButton setTitle:@"结算记录" forState:UIControlStateNormal];
//    [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
//    self.navigationItem.rightBarButtonItem = rightItem;

    
    self.mScrollView = [UIScrollView new];
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.mScrollView];
    
    self.lblState = [UILabel new];
    [self.lblState setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(33))];
    [self.lblState setBackgroundColor:HEXCOLOR(0xfef2e7)];
    [self.lblState setTextColor:HEXCOLOR(0xfdad41)];
    [self.lblState setFont:WY_FONTMedium(14)];
    [self.view addSubview:self.lblState];
    
    
    self.lblMsg = [UILabel new];
    [self.view addSubview:self.lblMsg];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"立即结算" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    [self.btnSubmit setHidden:YES];
    
    
}

- (void)dataSource {
    
    
//    self.infoID
    WS(weakSelf)
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.infoID forKey:@"expertId"];
    [postDic setObject:self.nsID forKey:@"id"];

    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getBidEvaluationFeeDetailed_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            NSLog(@"获取数据成功");
            if (![res[@"data"] isEqual:[NSNull null]] && res[@"data"] != nil) {
                self.dicDataSource = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                self.msgStr = res[@"msg"];
                zk1 = 1;
                zk2= 1;
                zkTop = 1;
                [weakSelf bindView];
            } else {
                [SVProgressHUD showErrorWithStatus:@"接口返回错误"];
            }
         }
 
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
     }];

}

- (NSString *)geetDaoZhangType:(NSString *)proStatus {
    
    switch ([proStatus intValue]) {
        case 1:
        {
            return @"已支付";
        }
            break;
        default:
            return @"未支付";
    }
    
}

- (NSString *)geetProType:(NSString *)proStatus {
    
    switch ([proStatus intValue]) {
        case 1:
        {
            return @"正常评标";
        }
            break;
        case 2:
        {
            return @"项目复议";
        }
            break;
        default:
            return @"暂无";
    }
    
}
- (NSString *)geetProStatus:(NSString *)proStatus {
    if (![proStatus isNotBlank]) {
        return @"暂无";
    }
//    public String getBidEvaluationText() {
//        if ("1".equals(getBidEvaluationType())) {
//            return "正常评标";
//        } else if ("2".equals(getBidEvaluationType())) {
//            return "项目复议";
//        } else {
//            return "暂无";
//        }
//    }
    
    switch ([proStatus intValue]) {
        case 0:
        {
            return @"暂无";
        }
            break;
        case 1:
        {
            return @"正常评标";
        }
            break;
        case 2:
        {
            return @"项目复议";
        }
            break;
        default:
            return @"暂无";
    }
    
}
- (void)bindView {
    
    NSString *statusStr = @"";
    //0待结算 1已结算 2结算中 3异议中
    switch ([self.dicDataSource[@"clearingStatus"] intValue]) {
        case 0:
        {
            statusStr = @"待结算";
        }
            break;
        case 1:
        {
            statusStr = @"已结算";
        }
            break;
        case 2:
        {
            statusStr = @"结算中";
        }
            break;
        case 3:
        {
            statusStr = @"异议中";
        }
            break;
       
        default:
        {
            statusStr = @"";
        }
            break;
    }
    
    if ([self.dicDataSource[@"clearingStatus"] intValue] == 0) {
        //显示提示文字；
        [self.lblMsg setFrame:CGRectMake(k360Width(16), self.mScrollView.bottom, kScreenWidth - k360Width(32), k360Width(22))];
        [self.lblMsg setFont:WY_FONTMedium(12)];
        [self.lblMsg setNumberOfLines:0];
        [self.lblMsg setLineBreakMode:NSLineBreakByWordWrapping];
        [self.lblMsg setText:self.msgStr];
        [self.lblMsg sizeToFit];
        self.lblMsg.height += 10;
        [self.lblMsg setTextColor:HEXCOLOR(0xb32126)];
        [self.lblMsg setHidden:NO];
        
        self.mScrollView.height = kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin - self.lblMsg.height;
        
        self.lblMsg.top = self.mScrollView.height;
        
        self.btnSubmit.top = self.lblMsg.bottom;
        [self.btnSubmit setHidden:NO];
    } else {
        self.mScrollView.height = kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin;
        [self.lblMsg setHidden:YES];
        [self.btnSubmit setHidden:YES];
    }
    self.lblState.text = [NSString stringWithFormat:@"  当前状态：%@",statusStr];
    
    [self.mScrollView removeAllSubviews];
    UIView *viewTzgg = [[UIView alloc] initWithFrame:CGRectMake(0, self.lblState.bottom + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg];
    [self viewReadInit:viewTzgg withTitleStr:@"项目信息："];
    
    lastY = viewTzgg.bottom;
    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:self.dicDataSource[@"projectDo"][@"tenderProjectName"] isAcc:NO withBlcok:nil];
    
    
    [self  byReturnColCellTitle:@"代理机构：" byLabelStr:self.dicDataSource[@"projectDo"][@"agencyName"] isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"联 系 人 ：" byLabelStr:self.dicDataSource[@"projectDo"][@"contacts"] isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"联系电话：" byLabelStr:self.dicDataSource[@"projectDo"][@"contactPhone"]  isCallAcc:YES withBlcok:^{
        NSLog(@"拨打电话");
        @try {
            if ([self.dicDataSource[@"projectDo"][@"contactPhone"] isNotBlank]) {
                [GlobalConfig makeCall:self.dicDataSource[@"projectDo"][@"contactPhone"]];
            } else {
                [SVProgressHUD showErrorWithStatus:@"没有电话"];
            }
        } @catch (NSException *exception) {
            
        }
    }];
    
    
    [self  byReturnColCellTitle:@"评标开始时间：" byLabelStr:self.dicDataSource[@"startTime"] isAcc:NO withBlcok:nil];
    
    if (zkTop == 2) {
        //展开内容
        [self  byReturnColCellTitle:@"评标类型：" byLabelStr:[self geetProType:self.dicDataSource[@"projectDo"][@"bidEvaluationType"]] isAcc:NO withBlcok:nil];
        NSMutableArray *arrbidSectionDo = [[NSMutableArray alloc]initWithArray:self.dicDataSource[@"bidSectionDo"]];
        [self  byReturnColCellTitle:@"标段信息：" byLabelStr:[NSString stringWithFormat:@"共%ld个标段",arrbidSectionDo.count] isAcc:YES withBlcok:^{
            NSLog(@"标段信息：");
            zk1 = zk1==1?2:1;
            [self bindView];
        }];
        
        if (zk1 == 2) {
            int i = 0;
            for (NSDictionary *dicBd in arrbidSectionDo) {
                [self  byReturnColCellTitle:[NSString stringWithFormat:@"    标段%d：",i+1] byLabelStr:@" " isAcc:NO withBlcok:nil];
                [self  byReturnColCellTitle:@"    标段编号：" byLabelStr:dicBd[@"bidSectionCode"] isAcc:NO withBlcok:nil];
                [self  byReturnColCellTitle:@"    标段名称：" byLabelStr:dicBd[@"bidSectionName"] isAcc:NO withBlcok:nil];
                i ++;
            }
         }
        
//        2023-03-09 09:18:59 佟：那个时长可以先隐藏   通知中都没有 和这个对不上
//        [self  byReturnColCellTitle:@"预计评标时长：" byLabelStr:[NSString stringWithFormat:@"%@小时",self.dicDataSource[@"projectDo"][@"bidEvaluationTime"]] isAcc:NO withBlcok:nil];
//        [self  byReturnColCellTitle:@"预计评标费用：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"projectDo"][@"bidEvaluationMoney"] floatValue]] isAcc:NO withBlcok:nil];
        
        UIButton *btnZk = [UIButton new];
        [btnZk setTitle:@"收起" forState:UIControlStateNormal];
        [btnZk.titleLabel setFont:WY_FONTRegular(14)];
        [btnZk setTitleColor:HEXCOLOR(0x8a8a8a) forState:UIControlStateNormal];
        [btnZk setFrame:CGRectMake(k360Width(16), lastY, kScreenWidth - k360Width(32), k360Width(26))];
        [btnZk setImage:[UIImage imageNamed:@"0506sq"] forState:UIControlStateNormal];
        btnZk.imageView.width = k360Width(15);
        btnZk.imageView.height = k360Width(15);
        
        btnZk.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btnZk setTitleEdgeInsets:UIEdgeInsetsMake(0, - k360Width(30), 0, k360Width(30))];
        [btnZk setImageEdgeInsets:UIEdgeInsetsMake(5, k360Width(30), 5, -k360Width(30))];

        
        [btnZk setBackgroundColor:HEXCOLOR(0xe6e6e6)];
        [btnZk addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            zkTop = 1;
            [self bindView];
        }];
        [self.mScrollView addSubview:btnZk];
        
        lastY = btnZk.bottom;
    } else {
        UIButton *btnZk = [UIButton new];
        [btnZk setTitle:@"展开" forState:UIControlStateNormal];
        [btnZk.titleLabel setFont:WY_FONTRegular(14)];
        [btnZk setTitleColor:HEXCOLOR(0x8a8a8a) forState:UIControlStateNormal];
        [btnZk setFrame:CGRectMake(k360Width(16), lastY, kScreenWidth - k360Width(32), k360Width(26))];
        [btnZk setImage:[UIImage imageNamed:@"0506zk"] forState:UIControlStateNormal];
        btnZk.imageView.width = k360Width(15);
        btnZk.imageView.height = k360Width(15);
        btnZk.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btnZk setTitleEdgeInsets:UIEdgeInsetsMake(0, - k360Width(30), 0, k360Width(30))];
        [btnZk setImageEdgeInsets:UIEdgeInsetsMake(5, k360Width(30), 5, -k360Width(30))];

        
        [btnZk setBackgroundColor:HEXCOLOR(0xe6e6e6)];
        [btnZk addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            zkTop = 2;
            
            [self bindView];
        }];
        [self.mScrollView addSubview:btnZk];
        lastY = btnZk.bottom;
    } 
    
    UIView *viewTzggA = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzggA];
    [self viewReadInit:viewTzggA withTitleStr:@"结算信息："];
    UIButton *btnJfbz = [UIButton new];
    [btnJfbz setTitle:@"计费标准" forState:UIControlStateNormal];
    [btnJfbz setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnJfbz setFrame:CGRectMake(kScreenWidth -  k360Width(116), 0, k360Width(100), k360Width(44))];
    [btnJfbz.titleLabel setFont:WY_FONTMedium(14)];
    [btnJfbz setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [btnJfbz setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"计费标准");
        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
        wk.titleStr = @"计费标准";
        wk.webviewURL = @"https://www.capass.cn/Avatar/expert_fee_rule.pdf";
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
        navi.navigationBarHidden = NO;
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navi animated:NO completion:nil];
    }];
    [viewTzggA addSubview:btnJfbz];
    
    lastY = viewTzggA.bottom;
    [self  byReturnColCellTitle:@"评标结束时间：" byLabelStr:self.dicDataSource[@"endTime"] isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"评标实际时长：" byLabelStr:self.dicDataSource[@"shijiTime"] isAcc:NO withBlcok:nil];
//    [self  byReturnColCellTitle:@"评标费用：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"laborWage"] floatValue]]  isAcc:NO withBlcok:nil];
    //计算补助费用总额
    float bzfeeCount = [self getBzFee:self.dicDataSource];
    [self  byReturnColCellTitle:@"补助费用：" byLabelStr:[NSString stringWithFormat:@"%.2f元",bzfeeCount] isAcc:NO withBlcok:nil];
    
    
    
//    //计算补助费用总额
//    float bzfeeCount = [self getBzFee:self.dicDataSource];
//    [self  byReturnColCellTitle:@"补助费用：" byLabelStr:[NSString stringWithFormat:@"%.2f元",bzfeeCount]  isAcc:NO withBlcok:^{
//        NSLog(@"补助费用");
//        zk2 = zk2==1?2:1;
//        [self bindView];
//    }];
//    if (zk2 == 2) {
//        [self  byReturnColCellTitle:@"    交通补助：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"trafficSubsidy"] floatValue]] isAcc:NO withBlcok:nil];
//        [self  byReturnColCellTitle:@"    负责人补助：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"directorSubsidy"] floatValue]] isAcc:NO withBlcok:nil];
//        [self  byReturnColCellTitle:@"    加班补助：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"workOvertimeSubsidy"] floatValue]] isAcc:NO withBlcok:nil];
//
//    }
    
//    [self  byReturnColCellTitle:@"应发总计：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"preTaxCost"] floatValue]] isAcc:NO withBlcok:nil];
//
//
//    [self  byReturnColCellTitle:@"个税扣除：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"taxes"] floatValue]] isAcc:NO withBlcok:nil];
    
   
//    [self  byReturnColCellTitle:@"完税状态：" byLabelStr:isWanShui isAcc:NO withBlcok:nil];
//    发放方式是平台支付的话- 显示银行名称和银行卡号
//    //非平台发放 隐藏个税扣除 银行名称 银行卡号 应发总计
    if ([self.dicDataSource[@"sendType"]  intValue] != 1) {
        [self  byReturnColCellTitle:@"个税扣除：" byLabelStr:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"taxes"] floatValue]] isAcc:NO withBlcok:nil];
        [self  byReturnColCellTitle:@"银行名称：" byLabelStr:self.dicDataSource[@"expertBankName"] isAcc:NO withBlcok:nil];
        [self  byReturnColCellTitle:@"银行卡号：" byLabelStr:self.dicDataSource[@"expertBankNum"] isAcc:NO withBlcok:nil];
    }
    
//    [self  byReturnColCellTitle:@"到账时间：" byLabelStr:self.dicDataSource[@"payTime"] isAcc:NO withBlcok:nil];
//    [self  byReturnColCellTitle:@"到账状态：" byLabelStr:[self geetDaoZhangType:self.dicDataSource[@"payStatus"]] isAcc:NO withBlcok:nil];

    UIView *viewTzggB1 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzggB1];
    [self viewReadInit:viewTzggB1 withTitleStr:@"发放方式："];
    UIButton *btnPrice1 = [UIButton new];
    [btnPrice1 setTitle:self.dicDataSource[@"sendName"] forState:UIControlStateNormal];
    [btnPrice1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnPrice1 setFrame:CGRectMake(kScreenWidth -  k360Width(316), 0, k360Width(300), k360Width(44))];
    [btnPrice1.titleLabel setFont:WY_FONTMedium(14)];
    [btnPrice1 setTitleColor:HEXCOLOR(0xfb363e) forState:UIControlStateNormal];
    [viewTzggB1 addSubview:btnPrice1];
    
    UIView *viewTzggB = [[UIView alloc] initWithFrame:CGRectMake(0, viewTzggB1.bottom, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzggB];
    [self viewReadInit:viewTzggB withTitleStr:@"应发总计："];
    UIButton *btnPrice = [UIButton new];
    [btnPrice setTitle:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"preTaxCost"] floatValue]] forState:UIControlStateNormal];
    [btnPrice setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnPrice setFrame:CGRectMake(kScreenWidth -  k360Width(116), 0, k360Width(100), k360Width(44))];
    [btnPrice.titleLabel setFont:WY_FONTMedium(14)];
    [btnPrice setTitleColor:HEXCOLOR(0xfb363e) forState:UIControlStateNormal];
    [viewTzggB addSubview:btnPrice];
    
    UIView *viewTzggB2 = [[UIView alloc] initWithFrame:CGRectMake(0, viewTzggB.bottom, kScreenWidth, k360Width(44))];
    //非平台发放 隐藏个税扣除 银行名称 银行卡号 应发总计
    if ([self.dicDataSource[@"sendType"]  intValue] != 1) {
        viewTzggB2.top = viewTzggB1.bottom;
        [viewTzggB setHidden:YES];
    }
    [self.mScrollView addSubview:viewTzggB2];
    [self viewReadInit:viewTzggB2 withTitleStr:@"实发总计："];
    UIButton *btnPrice2 = [UIButton new];
    [btnPrice2 setTitle:[NSString stringWithFormat:@"%.2f元",[self.dicDataSource[@"realityGrantReward"] floatValue]] forState:UIControlStateNormal];
    [btnPrice2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnPrice2 setFrame:CGRectMake(kScreenWidth -  k360Width(116), 0, k360Width(100), k360Width(44))];
    [btnPrice2.titleLabel setFont:WY_FONTMedium(14)];
    [btnPrice2 setTitleColor:HEXCOLOR(0xfb363e) forState:UIControlStateNormal];
    [viewTzggB2 addSubview:btnPrice2];
    
    UIView *viewTzggB2A = [[UIView alloc] initWithFrame:CGRectMake(0, viewTzggB2.bottom, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzggB2A];
    [self viewReadInit:viewTzggB2A withTitleStr:@"发放进度："];
 
    lastY = viewTzggB2A.bottom + k360Width(5);
    //这里加-流程
    NSMutableDictionary *dicItem = [NSMutableDictionary new];
    [dicItem setObject:@"支付状态" forKey:@"name"];
    [dicItem setObject:[self geetDaoZhangType:self.dicDataSource[@"payStatus"]] forKey:@"result"];
    [dicItem setObject:self.dicDataSource[@"payStatus"] forKey:@"state"];
    [self initAddItemByDic:dicItem byNum:0];
    
    NSString *isWanShui = @"未完税";
    if ([self.dicDataSource[@"isPayTaxes"] intValue] == 1) {
        isWanShui = @"已完税";
    }
    NSMutableDictionary *dicItem1 = [NSMutableDictionary new];
    [dicItem1 setObject:@"完税状态" forKey:@"name"];
    [dicItem1 setObject:isWanShui forKey:@"result"];
    [dicItem1 setObject:self.dicDataSource[@"isPayTaxes"] forKey:@"state"];
    [self initAddItemByDic:dicItem1 byNum:1];
    
    UIView *viewTzggC = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzggC];
    [self viewReadInit:viewTzggC withTitleStr:@"相关附件"];
    lastY = viewTzggC.bottom;
    int i = 1;
    for (NSDictionary *fileItem in self.dicDataSource[@"expertAttach"]) {
        UIButton *btnFile = [UIButton new];
        [btnFile setFrame:CGRectMake(k360Width(32), lastY, kScreenWidth - k360Width(32+16), k360Width(30))];
        NSString *fileName = fileItem[@"attachmentName"];
        NSMutableAttributedString *tishiA =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d.  ",i]];
        [tishiA setYy_font:WY_FONTMedium(16)];
        [tishiA setYy_color:[UIColor blackColor]];
        
        NSMutableAttributedString *tishi =  [[NSMutableAttributedString alloc] initWithString:fileName];
       [tishi setYy_font:WY_FONTMedium(14)];
        [tishi yy_setUnderlineStyle:NSUnderlineStyleSingle range:NSMakeRange(0, fileName.length)];
       [tishi setYy_color:MSTHEMEColor];
        [tishiA appendAttributedString:tishi];
        [tishiA yy_setObliqueness:@0.25 range:NSMakeRange(0, tishiA.string.length)];

        [btnFile setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
       [btnFile setAttributedTitle:tishiA forState:UIControlStateNormal];
        [self.mScrollView addSubview:btnFile];
        lastY = btnFile.bottom + k360Width(5);
        i++;
        [btnFile setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            MS_WKwebviewsViewController *tempController = [MS_WKwebviewsViewController new];
            tempController.webviewURL = [fileItem[@"fwurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            tempController.isShare = @"1";
            tempController.titleStr = fileName;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tempController];
            navi.navigationBarHidden = NO;
            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navi animated:NO completion:nil];
        }];
    }
    
    
    UIButton *btnYiyi = [UIButton new];
    NSMutableAttributedString *attYY1 = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：如果您对当前结算有异议，请点击"];
    [attYY1 setYy_font:WY_FONTRegular(12)];
    NSMutableAttributedString *attYY2 = [[NSMutableAttributedString alloc] initWithString:@" 费用异议"];
    [attYY2 setYy_color:MSTHEMEColor];
    [attYY2 setYy_font:WY_FONTMedium(12)];
    [attYY1 appendAttributedString:attYY2];
    [btnYiyi setAttributedTitle:attYY1 forState:UIControlStateNormal];
    [btnYiyi setFrame:CGRectMake( k360Width(16), lastY + k360Width(16), kScreenWidth - k360Width(32), k360Width(44))];
    
    [btnYiyi addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        WY_ExpenseObjectionViewController *tempController = [WY_ExpenseObjectionViewController new];
        tempController.infoID = self.infoID;
        [self.navigationController pushViewController:tempController animated:YES];
    }];
    [self.mScrollView addSubview:btnYiyi];
//    if ([self.dicDataSource[@"clearingStatus"] intValue] != 1) {
        [btnYiyi setHidden:YES];
        [self.mScrollView setContentSize:CGSizeMake(0, btnYiyi.top)];
//    } else {
//        [btnYiyi setHidden:NO];
//        [self.mScrollView setContentSize:CGSizeMake(0, btnYiyi.bottom + k360Width(16))];
//    }
    
}



- (void)initAddItemByDic:(NSDictionary *)withDic byNum:(int)numA {
    UIView *viewT = [UIView new];
    [viewT setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), k360Width(44))];
    [viewT rounded:k360Width(44/8) width:1 color: APPLineColor];
    UILabel *lblNum = [UILabel new];
    UILabel *lblTitle = [UILabel new];
    UILabel *lblState = [UILabel new];
    [lblNum setFrame:CGRectMake(k360Width(10), 0, k360Width(20),k360Width(20))];
    [lblTitle setFrame:CGRectMake(lblNum.right + k360Width(10), 0, k360Width(200), viewT.height)];
    [lblState setFrame:CGRectMake(kScreenWidth -  k360Width(20+ 96), 0, k360Width(80), viewT.height)];
    [lblState setTextAlignment:NSTextAlignmentRight];
    
    [lblNum setCenterY:lblState.centerY];
    [lblNum setText:[NSString stringWithFormat:@"%d",numA+1]];
    [lblNum rounded:k360Width(20/2) width:2 color:HEXCOLOR(0xa6c2fa)];
    [lblNum setBackgroundColor:MSTHEMEColor];
    [lblNum setTextColor:[UIColor whiteColor]];
    [lblNum setFont:WY_FONTMedium(14)];
    [lblNum setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setText:withDic[@"name"]];
    [lblState setText:withDic[@"result"]];
    [lblTitle setFont:WY_FONTRegular(14)];
    [lblState setFont:WY_FONTRegular(14)];
    switch ([withDic[@"state"] intValue]) {
        case 0:
            [lblState setTextColor:HEXCOLOR(0x000000)];
            break;
        case 1:
            [lblState setTextColor:HEXCOLOR(0x00CC66)];
            break;
        case 2:
            [lblState setTextColor:HEXCOLOR(0xc23431)];
            break;
        case 3:
            [lblState setTextColor:HEXCOLOR(0x448eed)];
            break;
        default:
            [lblState setTextColor:HEXCOLOR(0x000000)];
            break;
    }
    
    [viewT addSubview:lblTitle];
    [viewT addSubview:lblNum];
    [viewT addSubview:lblState];
    
    [self.mScrollView addSubview:viewT];
    lastY = viewT.bottom;
}

- (float)getBzFee:(NSDictionary *)bzDic {
    float bzFee = 0;
    @try {
        float fy1 = [bzDic[@"trafficSubsidy"] floatValue];
        float fy2 = [bzDic[@"workOvertimeSubsidy"] floatValue];
        float fy3 = [bzDic[@"directorSubsidy"] floatValue];
        bzFee = fy1 + fy2 + fy3;
        return bzFee;
        
    } @catch (NSException *exception) {
        NSLog(@"费用转换报错");
        return bzFee;
    } @finally {
        
    }
}


- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isCallAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    @try {
        if  (![withLabelStr isNotBlank]) {
            withLabelStr = @"暂无";
        }
    } @catch (NSException *exception) {
        withLabelStr = @"暂无";
    }
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [lblTitle sizeToFit];
    if (lblTitle.height < k360Width(22)) {
        lblTitle.height = k360Width(22);
    }
    int accLeft = 0;
    UIImageView *imgAcc;
     if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(self.mScrollView.width - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"0317phone"]];
        [viewTemp addSubview:imgAcc];
 
        accLeft = imgAcc.width + k360Width(5);
    }
    
    UILabel *withLabel = [UILabel new];
    
    [withLabel setFrame:CGRectMake(lblTitle.right, 0, viewTemp.width - lblTitle.right - k360Width(16) - accLeft, k360Width(22))];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextColor:HEXCOLOR(0x666666)];
    [withLabel setFont:WY_FONTRegular(14)];
    withLabel.text = withLabelStr;
    [withLabel sizeToFit];
    if (withLabel.height < k360Width(22)) {
        withLabel.height = k360Width(22);
    }
    
    viewTemp.height = withLabel.bottom;
    [viewTemp addSubview:withLabel];
    
    if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
         [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    lastY = viewTemp.bottom;
    return viewTemp;
}

- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    @try {
        if  (![withLabelStr isNotBlank]) {
            withLabelStr = @"暂无";
        }
    } @catch (NSException *exception) {
        withLabelStr = @"暂无";
    }
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [lblTitle sizeToFit];
    if (lblTitle.height < k360Width(22)) {
        lblTitle.height = k360Width(22);
    }
    int accLeft = 0;
    UIImageView *imgAcc;
    UILabel *lblCk;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(self.mScrollView.width - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        lblCk = [UILabel new];
        [lblCk setFrame:CGRectMake(imgAcc.left - k360Width(25), k360Width(44 - 10) / 2, k360Width(30), k360Width(22))];
        [lblCk setText:@"查看"];
        [lblCk setTextAlignment:NSTextAlignmentRight];
        [lblCk setFont:WY_FONTRegular(12)];
        [lblCk setTextColor:APPTextGayColor];
        [viewTemp addSubview:lblCk];
        
        accLeft = imgAcc.width + lblCk.width + k360Width(5);
    }
    
    UILabel *withLabel = [UILabel new];
    
    [withLabel setFrame:CGRectMake(lblTitle.right, 0, viewTemp.width - lblTitle.right - k360Width(16) - accLeft, k360Width(22))];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextColor:HEXCOLOR(0x666666)];
    [withLabel setFont:WY_FONTRegular(14)];
    withLabel.text = withLabelStr;
    [withLabel sizeToFit];
    if (withLabel.height < k360Width(22)) {
        withLabel.height = k360Width(22);
    }
    
    viewTemp.height = withLabel.bottom;
    [viewTemp addSubview:withLabel];
    
    if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        lblCk.centerY = imgAcc.centerY;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    lastY = viewTemp.bottom;
    return viewTemp;
}

- (void)viewReadInit:(UIView *)vrView withTitleStr:(NSString *)titleStr{
    [vrView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [vrView addSubview:viewBlue1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(viewBlue1.right + k360Width(8), k360Width(0), k360Width(264), k360Width(44));
    label.text = titleStr;
    label.font = WY_FONTMedium(16);
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8/1.0];
    [vrView addSubview:label];
    
}

- (void)btnSubmitAction {
    NSLog(@"点击了提交按钮");
    [self initPDFData];
    
}
 
- (void)navRightAction {
    NSLog(@"结算记录");
    WY_SettlementRecordViewController *tempController = [WY_SettlementRecordViewController new];
    tempController.infoID = self.infoID;
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


- (void) initPDFData {
//    NSString *pdfurl = @"https://www.capass.cn/Avatar/hbcns.pdf";
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.infoID forKey:@"expertId"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idcardnum"];
     [[MS_BasicDataController sharedInstance] postWithURL:zj_tradingNotSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSString *pdfurl = successCallBack;
         [self bindPDFView:pdfurl];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

    
}

- (void)bindPDFView :(NSString *)pdfurl {
    
    NSString *titleStr = self.title;
    
    self.title = @"请您阅读并签署协议";
    //才 跳转 协议
    pdfView = [UIView new];
    [pdfView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview: pdfView];
    [pdfView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    
    webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50)  - JC_TabbarSafeBottomMargin)];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfurl]]];
    [pdfView addSubview:webview];
    
 
    btnUp = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(16), webview.bottom, (kScreenWidth - k375Width(16*3)) / 2, k360Width(44))];
    [btnUp setTitle:@"取  消" forState:UIControlStateNormal];
    [btnUp.titleLabel setFont:WY_FONTMedium(14)];
    [btnUp setBackgroundColor:[UIColor whiteColor]];
    [btnUp setTitleColor:HEXCOLOR(0x777777) forState:UIControlStateNormal];
    [btnUp rounded:k360Width(44)/8 width:1 color:HEXCOLOR(0x777777)];
 
    
    btnReSign = [[UIButton alloc] initWithFrame:CGRectMake(btnUp.right + k375Width(16), webview.bottom, (kScreenWidth - k375Width(16*3)) / 2, k360Width(44))];
    [btnReSign setTitle:@"签  名" forState:UIControlStateNormal];
    [btnReSign.titleLabel setFont:WY_FONTMedium(14)];
    [btnReSign setBackgroundColor:MSTHEMEColor];
    [btnReSign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReSign rounded:k360Width(44)/8];
 
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(16), webview.bottom, k375Width(326), k360Width(44))];
    [btnSubmit setTitle:@"确  认" forState:UIControlStateNormal];
    [btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [btnSubmit setBackgroundColor:MSTHEMEColor];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit rounded:k360Width(44)/8];
    [btnSubmit setHidden:YES];

    
    
    [pdfView addSubview:btnUp];
    [pdfView addSubview:btnReSign];
    [pdfView addSubview:btnSubmit];
    [btnUp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"拒绝");
        //这里调取消结算接口
        [self cancelSignature];
        self.title = titleStr;
        isAgree = @"0";
        [pdfView setHidden:YES];
    }];
    
    if ([isSignText isEqualToString:@"1"]) {
         btnUp.width = (kScreenWidth - k375Width(16*4)) / 3;
        btnReSign.width = btnUp.width;
        [btnReSign setTitle:@"重新签名" forState:UIControlStateNormal];
        [btnReSign setBackgroundColor:HEXCOLOR(0xE4E8ED)];
        [btnReSign setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btnSubmit.width = btnUp.width;
        btnReSign.left = btnUp.right + k375Width(16);
        btnSubmit.left = btnReSign.right + k375Width(16);
        [btnSubmit setHidden:NO];
    } else {
        [btnReSign setTitle:@"签  名" forState:UIControlStateNormal];
    }
    
    [btnReSign addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击签字");
        //如果没有签过字 -  判断 用户信息中 是否有签字-
        if (![isSignText isEqualToString:@"1"]) {
//            如果有-直接调用接口签字；
            if ([self.mUser.userSignature isNotBlank]) {
//调用接口签字；
                [self signPDFByUserSignature:self.mUser.userSignature];
            } else {
                //            如果没有- 去签字页保存后-再调用接口签字；
                [self goSignPage];
            }
        } else {
            // 这就是重签- 去签字页保存后-再调用接口签字；
            [self goSignPage];
        }
    }];
    
    
    [btnSubmit addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.title = titleStr;
        
//        [self VFace];
        
        //工信部要求去掉人脸
        [self decryptionStep3];
        
    }];
    
}

- (void)goSignPage {
    WY_SignViewController *tempController = [WY_SignViewController new];
    tempController.isSaveSign = @"1";
    tempController.popVCBlock = ^(NSString * _Nonnull picUrl) {
        self.mSignUrl = picUrl;
        [self tSaveSignUrl:self.mSignUrl];
    };
    tempController.modalPresentationStyle = 0;
    [self presentViewController:tempController animated:YES completion:nil];

}

- (void) tSaveSignUrl:(NSString *)signUrl {
    NSLog(@"保存签字图片");
//    /huiyuanUser/getUserSignature    参数userGui会员id   signature  签字地址    idcardbum身份证号
//    zj_getUserSignature_HTTP
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
     [dicPost setObject:signUrl forKey:@"signature"];
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_getUserSignature_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id successCallBack) {
        MSLog(@"设置成功");
         self.mUser.userSignature = signUrl;
        [self signPDFByUserSignature:self.mUser.userSignature];

    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
}
//签字并刷新PDF
- (void)signPDFByUserSignature:(NSString *)userSignature {
    
    //btn 显示重签
    
    
    //调用接口- 刷新PDF
//    NSString *pdfurl = @"https://www.capass.cn/Avatar/hbcns.pdf";

    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.infoID forKey:@"expertId"];
    [postDic setObject:self.nsID forKey:@"id"];
    [postDic setObject:self.mUser.idcardnum forKey:@"idcardnum"];
    [postDic setObject:userSignature forKey:@"userSignature"];
 
    [[MS_BasicDataController sharedInstance] postWithURL:zj_tradingSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        self.signSuccessDic = [[NSMutableDictionary alloc] initWithDictionary:successCallBack];
        NSString *pdfurl = self.signSuccessDic[@"tradingFile"];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfurl]]];
        
        btnUp.width = (kScreenWidth - k375Width(16*4)) / 3;
       btnReSign.width = btnUp.width;
       [btnReSign setTitle:@"重新签名" forState:UIControlStateNormal];
       [btnReSign setBackgroundColor:HEXCOLOR(0xE4E8ED)];
       [btnReSign setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
       btnSubmit.width = btnUp.width;
       btnReSign.left = btnUp.right + k375Width(16);
       btnSubmit.left = btnReSign.right + k375Width(16);
       [btnSubmit setHidden:NO];
        isSignText  = @"1";
        
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
}


- (void)decryptionStep3 {
    if (![isSignText isEqualToString:@"1"]) {
        [SVProgressHUD showErrorWithStatus:@"请先签字"];
        return;
    }
    isAgree = @"1";
    [pdfView setHidden:YES];
 
    //    3.调用接口签到项目信息，刷新列表；
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
 
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
    [postDic setObject:self.nsID forKey:@"id"];

    [postDic setObject:self.signSuccessDic[@"wordPath"] forKey:@"wordPath"];
 
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_tradingSignatureConfirm_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
           if ([code integerValue] == 0 && res) {
               [self.view makeToast:res[@"msg"]];
                           [self dataSource];

            } else {
               [self.view makeToast:res[@"msg"]];
           }
       } failure:^(NSError *error) {
           [self.view makeToast:@"请求失败，请稍后再试"];
           
       }];
}

- (void)cancelSignature {
    //取消结算
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.infoID forKey:@"expertId"];
    [[MS_BasicDataController sharedInstance] postWithURL:zj_tradingCancelSignature_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
    } failure:^(NSString *failureCallBack) {
     } ErrorInfo:^(NSError *error) {
     }];
}

- (void)backAction {
    [self cancelSignature];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
