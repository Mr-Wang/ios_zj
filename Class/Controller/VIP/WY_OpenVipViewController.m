//
//  WY_OpenVipViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/9.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OpenVipViewController.h"
#import "ZJScrollPageView.h"//选择控制器]
#import "WY_OpenVipItemViewController.h"
#import "WY_VipMainModel.h"

@interface WY_OpenVipViewController ()
@property (nonatomic)NSInteger selZJIndex;
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic, weak) ZJScrollPageView *scrollPageView;//选择控制器
@property (nonatomic , strong)  NSArray *titleArr;/* 选择控制器title*/
@property (nonatomic , strong) UILabel *lblPrice;
@property (nonatomic , strong) WY_VipMainModel *mWY_VipMainModel;
@end

@implementation WY_OpenVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

        [self makeUI];
        [self bindView];
     
}
- (void)viewWillAppear:(BOOL)animated {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

}
#pragma mark --绘制页面
- (void)makeUI {
    
           
    self.title = @"会员中心";
    self.titleArr =@[@"普通会员",@"高级会员",@"超级会员"];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self ZJScorollPageUI];//轮播选择控制器
    
    UIImageView *imgBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.scrollPageView.bottom , kScreenWidth, k360Width(42))];
    [imgBottom setImage:[UIImage imageNamed:@"0520vipBottom"]];
    [self.view addSubview:imgBottom];
    self.lblPrice = [UILabel new];
    [self.lblPrice setFrame:CGRectMake(k360Width(10), 0, kScreenWidth , k360Width(40))];
     [imgBottom addSubview:self.lblPrice];
    
 }
 
#pragma mark --绑定数据
- (void)bindView {
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    if (self.mUser.orgnum) {
        [dicPost setObject:self.mUser.orgnum forKey:@"orgnum"];
    }
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getOpenVIPHome_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code intValue] == 0) {
            self.mWY_VipMainModel = [WY_VipMainModel modelWithJSON:res[@"data"]];
            [self showPriceLab:0];

        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];

        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"接口返回错误"];
    }];
}



-(void)ZJScorollPageUI{

    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;

    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    style.titleFont =  WY_FONTRegular(14);
    style.scrollContentView = YES;
 
    // 颜色渐变
//    style.gradualChangeTitleColor = YES;
//    style.scaleTitle = YES;
    style.autoAdjustTitlesWidth = YES;
    style.titleMargin = k360Width(20);
    style.normalTitleColor = MSColor(153, 153, 153);
    style.selectedTitleColor = MSTHEMEColor;
    style.scrollLineColor =MSTHEMEColor;//MSColor(1, 187, 112);
//    style.titleFont = WY_FONTRegular(16);
    style.segmentViewBounces = NO;
    style.contentViewBounces = NO;
    style.segmentHeight = k360Width(52);
    
     
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(42)  - JC_TabbarSafeBottomMargin) segmentStyle:style titles:self.titleArr parentViewController:self delegate:self];
     self.scrollPageView = scrollPageView;
    [self.view addSubview:scrollPageView];
    
    [scrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
 }


#pragma mark - ZJScrollPageViewChildVcDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titleArr.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    if (index > self.titleArr.count-1) {
        index = self.titleArr.count - 1;
    }
    [self showPriceLab:index];
//    return nil;
    self.selZJIndex = index;
     WY_OpenVipItemViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_OpenVipItemViewController *)reuseViewController;
     if (!fourview) {
         fourview = [[WY_OpenVipItemViewController alloc] init];
      }
//     fourview.selDate = self.selDate;
    
     return fourview;
}

- (void)showPriceLab:(int)index {
    if (!self.mWY_VipMainModel) {
        return;
    }
    NSString *yprice = @"";
    NSString *xprice = @"";
    WY_VipItemModel *vipItemModel = [self.mWY_VipMainModel.orderPrice objectAtIndex:index];
    yprice = vipItemModel.newprice;
    xprice = vipItemModel.price;

//    if (index == 0) {
//       } else if (index == 1) {
//        yprice = @"189";
//               xprice = @"155";
//       } else if (index == 2) {
//           yprice = @"389";
//           xprice = @"355";
//       } else {
//           yprice = [NSString stringWithFormat:@"%d",index] ;
//       }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"￥ "];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:yprice];
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:@" 元/年  "];
        NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价:%@/年",xprice]];

    
    [attStr setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
    [attStr setYy_color:HEXCOLOR(0xE38D38)];
    [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
    [attStr1 setYy_color:HEXCOLOR(0xE38D38)];
    [attStr2 setYy_font:WY_FONTRegular(14)];

    [attStr3 setYy_font:WY_FONTRegular(12)];
    [attStr3 setYy_strikethroughStyle:NSUnderlineStyleSingle];
    [attStr3 setYy_strikethroughColor:APPTextGayColor];
    [attStr3 setYy_color:APPTextGayColor];
    
    [attStr appendAttributedString:attStr1];
    [attStr appendAttributedString:attStr2];
    [attStr appendAttributedString:attStr3];
 
    self.lblPrice.attributedText = attStr;
    
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
