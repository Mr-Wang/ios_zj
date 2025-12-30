//
//  WY_MyBalanceViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/22.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MyBalanceViewController.h"
#import "STRIAPManager.h"
#import "WY_TopUpListViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_BalanceDetailListViewController.h"
#import "WY_TopUpModel.h"
 
@interface WY_MyBalanceViewController ()
@property (nonatomic, strong) UIScrollView *mUIScrollView;
@property (nonatomic, strong) UILabel *lblBalanceTitle;
@property (nonatomic, strong) UILabel *lblBalance;
@property (nonatomic, strong) UILabel *lblUserName;
@property (nonatomic, strong) UIButton *btn158;
@property (nonatomic, strong) UIButton *btn168;
@property (nonatomic, strong) UIButton *btn188;
@property (nonatomic, strong) UIButton *btn198;
@property (nonatomic, strong) UIButton *btn218;
@property (nonatomic, strong) UIButton *btnOhter;
@property (nonatomic, strong) UIView *viewBottom;
@property (nonatomic, strong) UILabel *lblExplanation;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIView *viewHeader;
@property (nonatomic, strong)UILabel *lblTitle;
@property (nonatomic, strong)UIButton *btnMX;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong)UIImageView *topViewBg;
@property (nonatomic, strong)UIButton *btnBack;
@property (nonatomic) int selMoney;
@property (nonatomic, strong) STRIAPManager *IAPManager;
@end

@implementation WY_MyBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [MS_BasicDataController sharedInstance].user;
 
    [self makeUI];
   
}
- (void)makeUI {
    self.view.backgroundColor = [UIColor whiteColor];

    int topY = MH_APPLICATION_STATUS_BAR_HEIGHT + 3;


    
    self.mUIScrollView = [UIScrollView new];
    [self.mUIScrollView setFrame:CGRectMake(0, -topY, kScreenWidth, kScreenHeight + topY - k360Width(66))];
    self.mUIScrollView.delegate = self;
    [self.view addSubview:self.mUIScrollView];
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), kScreenHeight - k360Width(50), kScreenWidth - k360Width(30), k360Width(40))];
    [btnLeft setTitle:@"立即充值" forState:UIControlStateNormal];
    [btnLeft rounded:k360Width(40/8)];
    [btnLeft setBackgroundColor:MSTHEMEColor];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft.titleLabel setFont:WY_FONTMedium(14)];
    [self.view addSubview:btnLeft];

    
    self.viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(160))];
    self.viewHeader.backgroundColor = MSTHEMEColor;
    UIImageView *imgHeaderViewBG = [[UIImageView alloc] initWithFrame:self.viewHeader.bounds];
    [imgHeaderViewBG setImage:[UIImage imageNamed:@"myinfoTop"]];
    [self.viewHeader addSubview:imgHeaderViewBG];
    [self.mUIScrollView addSubview:self.viewHeader];
    self.topView = [UIView new];
    [self.topView setFrame:CGRectMake(0, -topY, kScreenWidth, JCNew64 + topY)];
    [self.topView setBackgroundColor:[UIColor clearColor]];
    self.topViewBg = [[UIImageView alloc] initWithFrame:self.topView.bounds];
    [self.topViewBg setBackgroundColor:[UIColor whiteColor]];
    self.topViewBg.alpha = 0;
    [self.topView addSubview:self.topViewBg];
    [self.view addSubview:self.topView];
    
    //返回按钮；
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), topY*2 , k360Width(44), k360Width(44))];
    [self.btnBack setImage:[UIImage imageNamed:@"0225_quizback"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.btnBack];
    
    self.btnMX = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(60), topY*2, k360Width(60), k360Width(44))];
    [self.btnMX setTitle:@"明细" forState:UIControlStateNormal];
    [self.btnMX.titleLabel setFont:WY_FONTRegular(14)];
    [self.btnMX addTarget:self action:@selector(btnMXAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.btnMX];

    self.lblTitle = [UILabel new];
    [self.lblTitle setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(30))];
    [self.lblTitle setFont:WY_FONTMedium(16)];
    [self.lblTitle setTextColor:[UIColor whiteColor]];
    [self.lblTitle setText:@"我的余额"];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    self.lblTitle.centerY = self.btnBack.centerY;
    [self.topView addSubview:self.lblTitle];
    
    self.lblBalanceTitle = [UILabel new];
    self.lblBalance = [UILabel new];
    
    [self.lblBalanceTitle setFrame:CGRectMake(k360Width(30), self.topView.bottom + k360Width(12), kScreenWidth - k360Width(60), k360Width(30))];
    [self.lblBalanceTitle setTextColor:[UIColor whiteColor]];
    [self.lblBalanceTitle setFont:WY_FONTRegular(14)];
    self.lblBalanceTitle.text = @"余额：";
    
    [self.lblBalance setFrame:CGRectMake(k360Width(30), self.lblBalanceTitle.bottom + k360Width(12), kScreenWidth - k360Width(60), k360Width(40))];
    [self.lblBalance setTextColor:[UIColor whiteColor]];
    [self.lblBalance setFont:WY_FONTRegular(30)];
    self.lblBalance.text = @"0.00币";
    
    [self.viewHeader addSubview:self.lblBalanceTitle];
    [self.viewHeader addSubview:self.lblBalance];
    self.viewHeader.height = self.lblBalance.bottom + k360Width(10);
    imgHeaderViewBG.height = self.viewHeader.height;
    self.lblUserName = [UILabel new];
    [self.lblUserName setFrame:CGRectMake(k360Width(16), self.viewHeader.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(30))];
    [self.lblUserName setTextColor:APPTextGayColor];
    self.lblUserName.text = [NSString stringWithFormat:@"账户：%@",self.mUser.LoginID];
    [self.lblUserName setFont:WY_FONTRegular(14)];
    [self.mUIScrollView addSubview:self.lblUserName];
    int lastY = self.lblUserName.bottom + k360Width(16);
    self.viewBottom = [UIView new];
    [self.viewBottom setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(100))];
    [self.mUIScrollView addSubview:self.viewBottom];
    
    self.btn158 = [UIButton new];
    self.btn168 = [UIButton new];
    self.btn188 = [UIButton new];
    self.btn198 = [UIButton new];
    self.btn218 = [UIButton new];
    self.btnOhter = [UIButton new];
    
   
    self.btnOhter.tag = 3;
    
    
    
    [self seetBtnTitle:self.btnOhter ByTitle:@"其它"];
    float btnW = (kScreenWidth - k360Width(16*2) - k360Width(10 * 2)) / 3;
    float btnH = k360Width(62);
    
    [self.btn158 setFrame:CGRectMake(k360Width(16), 0, btnW, btnH)];
    [self.btn168 setFrame:CGRectMake(self.btn158.right + k360Width(10), 0, btnW, btnH)];
    [self.btn188 setFrame:CGRectMake(self.btn168.right +k360Width(10), 0, btnW, btnH)];
    
    [self.btn198 setFrame:CGRectMake(k360Width(16), self.btn158.bottom + k360Width(16), btnW, btnH)];
    [self.btn218 setFrame:CGRectMake(self.btn158.right +k360Width(10), self.btn158.bottom + k360Width(16), btnW, btnH)];
    [self.btnOhter setFrame:CGRectMake(self.btn168.right +k360Width(10), self.btn158.bottom + k360Width(16), btnW, btnH)];
    
    
    [self.viewBottom addSubview:self.btn158];
    [self.viewBottom addSubview:self.btn168];
    [self.viewBottom addSubview:self.btn188];
    [self.viewBottom addSubview:self.btn198];
    [self.viewBottom addSubview:self.btn218];
    [self.viewBottom addSubview:self.btnOhter];
        
    //默认选中第一个
     self.lblExplanation = [UILabel new];
    [self.viewBottom addSubview:self.lblExplanation];
    [self.lblExplanation setFrame:CGRectMake(k360Width(16), self.btnOhter.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(80))];
    NSMutableAttributedString *attBtnSelStr = [[NSMutableAttributedString alloc] initWithString:@"说明"];
    [attBtnSelStr setYy_font:WY_FONTMedium(16)];
    [attBtnSelStr setYy_color:[UIColor blackColor]];
    
    NSMutableAttributedString *attBtnSelStr1 = [[NSMutableAttributedString alloc] initWithString:@"\n\n1.充值后可在iOS设备的网联学习APP内使用，与安卓版和网站余额不通用，余额充值不支持发票申请，使用余额支付时可在相应功能页面中开具发票。\n2.充值后没有使用期限，但无法提现、退款或转赠他人。\n3.如遇到无法充值、充值失败等情况，请联系客服咨询。\n4.请在网络条件好的情况下充值，耐心等待充值结果，不要关闭等待界面。 "];
    [attBtnSelStr1 setYy_font:WY_FONTRegular(14)];
    [attBtnSelStr1 setYy_color:APPTextGayColor];
    
    [attBtnSelStr appendAttributedString:attBtnSelStr1];

    
    self.lblExplanation.attributedText = attBtnSelStr;
    self.lblExplanation.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblExplanation.numberOfLines = 0;
    [self.lblExplanation sizeToFit];
    
}
- (void)bindView {
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getAppCoin_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
          if ([code integerValue] == 0) {
//              [SVProgressHUD showSuccessWithStatus:res[@"msg"]];
              NSString *nstotal = @"0";
              if (![res[@"data"] isEqual:[NSNull null]]) {
                  if (![res[@"data"][@"total"] isEqual:[NSNull null]]) {
                      nstotal = res[@"data"][@"total"];
                  }
              }
              self.lblBalance.text = [NSString stringWithFormat:@"%.2f币",[nstotal floatValue]];
             } else {
              [SVProgressHUD showErrorWithStatus:res[@"msg"]];
          }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    //有差额
    if (self.difference > 0 && self.difference != 280) {
        //查询差额临近值；
        [[MS_BasicDataController sharedInstance] postWithURL:appPrice_HTTP params:nil jsonData:nil showProgressView:YES success:^(id successCallBack) {
            
            if (((NSArray *)successCallBack).count > 0) {
                NSArray *arrDataSource = [NSArray yy_modelArrayWithClass:[WY_TopUpModel class] json:successCallBack];
                NSMutableArray *arrPrices = [NSMutableArray new];

                for (WY_TopUpModel *tuModel in arrDataSource) {
                    if ([tuModel.itemValue floatValue] >= self.difference) {
                        [arrPrices addObject:tuModel];
                    }
                }
                
                if (arrPrices.count < 5) {
                    arrPrices = [NSMutableArray new];
                    for (int i = arrDataSource.count - 5 ; i < arrDataSource.count; i ++) {
                        WY_TopUpModel *tuModel = arrDataSource[i];
                        [arrPrices addObject:tuModel];
                    }

                }
                
                WY_TopUpModel *tuModel1 = arrPrices[0];
                WY_TopUpModel *tuModel2 = arrPrices[1];
                WY_TopUpModel *tuModel3 = arrPrices[2];
                WY_TopUpModel *tuModel4 = arrPrices[3];
                WY_TopUpModel *tuModel5 = arrPrices[4];
                
               [self seetBtnTitle:self.btn158 ByTitle:tuModel1.itemValue];
                [self seetBtnTitle:self.btn168 ByTitle:tuModel2.itemValue];
                [self seetBtnTitle:self.btn188 ByTitle:tuModel3.itemValue];
                [self seetBtnTitle:self.btn198 ByTitle:tuModel4.itemValue];
                [self seetBtnTitle:self.btn218 ByTitle:tuModel5.itemValue];
                [self btnPriceAction:self.btn158];

            }
         } failure:^(NSString *failureCallBack) {
         } ErrorInfo:^(NSError *error) {
         }];
    } else {
        //查询默认金额；
        [[MS_BasicDataController sharedInstance] postWithReturnCode:getdefaultPriceList_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                  if ([code integerValue] == 0) {
        if (((NSArray *)res[@"data"]).count > 0) {
            NSArray *arrPrices = [NSArray yy_modelArrayWithClass:[WY_TopUpModel class] json:res[@"data"]];
             WY_TopUpModel *tuModel1 = arrPrices[0];
            WY_TopUpModel *tuModel2 = arrPrices[1];
            WY_TopUpModel *tuModel3 = arrPrices[2];
            WY_TopUpModel *tuModel4 = arrPrices[3];
            WY_TopUpModel *tuModel5 = arrPrices[4];
            
           [self seetBtnTitle:self.btn158 ByTitle:tuModel1.itemValue];
            [self seetBtnTitle:self.btn168 ByTitle:tuModel2.itemValue];
            [self seetBtnTitle:self.btn188 ByTitle:tuModel3.itemValue];
            [self seetBtnTitle:self.btn198 ByTitle:tuModel4.itemValue];
            [self seetBtnTitle:self.btn218 ByTitle:tuModel5.itemValue];
            [self btnPriceAction:self.btn158];

        }
                     } else {
                      [SVProgressHUD showErrorWithStatus:res[@"msg"]];
                  }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
            }];
    }
    self.viewBottom.top = self.lblUserName.bottom + k360Width(16);
    self.viewBottom.height = self.lblExplanation.bottom + k360Width(16);
    [self.mUIScrollView setContentSize:CGSizeMake(kScreenWidth, self.viewBottom.bottom)];
 
}

- (void)btnMXAction{
    NSLog(@"点击了 明细");
    WY_BalanceDetailListViewController *tempController = [WY_BalanceDetailListViewController new];
    tempController.title = @"余额明细";
    [self.navigationController pushViewController:tempController animated:YES];
}
- (void)seetBtnTitle:(UIButton *)withBtn ByTitle:(NSString *)titleStr {
    NSString *priceStr = titleStr;
    [withBtn addTarget:self action:@selector(btnPriceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([priceStr isEqualToString:@"其它"]) {
        [withBtn setTitle:priceStr forState:UIControlStateNormal];
        [withBtn setTitleColor:APPTextGayColor forState:UIControlStateNormal];
        [withBtn setTitleColor:HEXCOLOR(0xDD352A) forState:UIControlStateSelected];
        [withBtn.titleLabel setFont:WY_FONTRegular(16)];
        [withBtn rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xC9C8CE)];

        return;
    }
    withBtn.tag = [titleStr intValue];
    NSMutableAttributedString *attBtnStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"币%@",priceStr]];
    [attBtnStr setYy_font:WY_FONTRegular(16)];
    [attBtnStr setYy_color:HEXCOLOR(0xDD352A)];
    
    NSMutableAttributedString *attBtnStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n￥%@",priceStr]];
    [attBtnStr1 setYy_font:WY_FONTRegular(14)];
    [attBtnStr1 setYy_color:APPTextGayColor];
    
    [attBtnStr appendAttributedString:attBtnStr1];
    
    
    NSMutableAttributedString *attBtnSelStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"币%@",priceStr]];
    [attBtnSelStr setYy_font:WY_FONTMedium(16)];
    [attBtnSelStr setYy_color:HEXCOLOR(0xDD352A)];
    
    NSMutableAttributedString *attBtnSelStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n￥%@",priceStr]];
    [attBtnSelStr1 setYy_font:WY_FONTRegular(14)];
    [attBtnSelStr1 setYy_color:APPTextGayColor];
    
    [attBtnSelStr appendAttributedString:attBtnSelStr1];

    [withBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [withBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [withBtn.titleLabel setNumberOfLines:2];
    [withBtn setAttributedTitle:attBtnStr forState:UIControlStateNormal];
    [withBtn setAttributedTitle:attBtnSelStr forState:UIControlStateSelected];
    [withBtn rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xC9C8CE)];
}
- (void)btnPriceAction:(UIButton *)btnSender {
    if (btnSender.tag == 3) {
        NSLog(@"跳转值充值列表");
        WY_TopUpListViewController *tempController = [WY_TopUpListViewController new];
        tempController.title = @"充值";
        [self.navigationController pushViewController:tempController animated:YES];
        return;
    }
    [self.btn158 setSelected:NO];
    [self.btn168 setSelected:NO];
    [self.btn188 setSelected:NO];
    [self.btn198 setSelected:NO];
    [self.btn218 setSelected:NO];
    [self.btnOhter setSelected:NO];
    [self.btn158 rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xC9C8CE)];
    [self.btn168 rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xC9C8CE)];
    [self.btn188 rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xC9C8CE)];
    [self.btn198 rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xC9C8CE)];
    [self.btn218 rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xC9C8CE)];
    [self.btnOhter rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xC9C8CE)];
 
    [btnSender setSelected:YES];
    [btnSender rounded:k360Width(72/8) width:1 color:HEXCOLOR(0xDD352A)];
    self.selMoney = btnSender.tag;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
     [self bindView];
 }

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.topViewBg.alpha =1 - (50 - scrollView.contentOffset.y) / 50;
    if (self.topViewBg.alpha > 0) {
        [self.lblTitle setTextColor:HEXCOLOR(0x333539)];
        self.lblTitle.alpha =1 - (50 - scrollView.contentOffset.y) / 50;
        
        [self.btnMX setTitleColor:HEXCOLOR(0x333539) forState:UIControlStateNormal];
        self.btnMX.alpha =1 - (50 - scrollView.contentOffset.y) / 50;

        [self.btnBack setImage:[UIImage imageNamed:@"0225_quizback_black"] forState:UIControlStateNormal];
        self.btnBack.alpha =1 - (50 - scrollView.contentOffset.y) / 50;


    } else {
        [self.lblTitle setTextColor:[UIColor whiteColor]];
        self.lblTitle.alpha =1;
        [self.btnMX setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnMX.alpha =1;
        [self.btnBack setImage:[UIImage imageNamed:@"0225_quizback"] forState:UIControlStateNormal];
        self.btnBack.alpha =1;

    }
}

- (void)btnLeftAction{
    NSLog(@"立即充值");
    
     [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];

    if (!_IAPManager) {
           _IAPManager = [STRIAPManager shareSIAPManager];
       }
       // iTunesConnect 苹果后台配置的产品ID
    NSString *purchID = [NSString stringWithFormat:@"com.lnwl.Learn%d",self.selMoney];
       [_IAPManager startPurchWithID:purchID completeHandle:^(SIAPPurchType type,NSData *data) {
           [SVProgressHUD ms_dismiss];

       //请求事务回调类型，返回的数据
            switch (type) {
                   case SIAPPurchSuccess:
                       NSLog(@"购买成功");
//                    [SVProgressHUD showSuccessWithStatus:@"购买成功"];
//                    self.lblBalance.text = @"6.00币";
                    NSLog(@"本地验证购买成功-");
                       break;
                   case SIAPPurchFailed:
                       [SVProgressHUD showErrorWithStatus:@"购买失败"];
                       break;
                   case SIAPPurchCancle:
                    [SVProgressHUD showErrorWithStatus:@"您已取消购买"];

                       break;
                   case SIAPPurchVerFailed:
                    [SVProgressHUD showErrorWithStatus:@"订单校验失败"];

                       break;
                   case SIAPPurchVerSuccess:
                {
                    NSLog(@"订单校验成功");
                                       [SVProgressHUD showSuccessWithStatus:@"购买成功"];
                                       NSString * strPrice  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       self.lblBalance.text = [NSString stringWithFormat:@"%.2f币",[strPrice floatValue]];
                }
                       break;
                   case SIAPPurchNotArrow:
                    [SVProgressHUD showErrorWithStatus:@"不允许程序内付费"];

                       break;
                    case SIAPPurchNotCommodity:
                    [SVProgressHUD showErrorWithStatus:@"没有此商品"];

                    break;
                   default:
                       break;
               }
       }];
    
 }

 
- (void)btnBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
