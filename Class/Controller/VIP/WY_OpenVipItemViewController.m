//
//  WY_OpenVipItemViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OpenVipItemViewController.h"
#import "MS_WKwebviewsViewController.h"

@interface WY_OpenVipItemViewController ()
@property (nonatomic) BOOL isFirst;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) UIScrollView * mScrollView;
@property (nonatomic, strong)UIImageView * imgBg;
@end

@implementation WY_OpenVipItemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
     [self makeUI];
    self.isFirst = YES;
}

- (void) makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(92) - JC_TabbarSafeBottomMargin)];
    self.imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(468))];
    [self.mScrollView addSubview:self.imgBg];
    [self.mScrollView setContentSize:CGSizeMake(0, self.imgBg.bottom)];
    [self.view addSubview:self.mScrollView];
    UIButton *btnCk = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(244), 0, k360Width(155), k360Width(40))];
    [btnCk setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnCk setTitle:@"查看会员权益>" forState:UIControlStateNormal];
    [btnCk.titleLabel setFont:WY_FONTRegular(12)];
    [btnCk setTitleColor:HEXCOLOR(0x5EA6E9) forState:UIControlStateNormal];
    [btnCk addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了查看会员权益");
         MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
        wk.titleStr = @"会员权益";
        wk.webviewURL = @"https://www.capass.cn/Avatar/xx_vipBook.pdf";
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
        navi.navigationBarHidden = NO;
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navi animated:NO completion:nil];

    }];
    [self.view addSubview:btnCk];
}
#pragma mark --绑定数据
- (void)bindView {
    if (self.idx == 0) {
            [self.imgBg setImage:[UIImage imageNamed:@"0520vip01"]];
    } else if (self.idx == 1) {
            [self.imgBg setImage:[UIImage imageNamed:@"0520vip02"]];
    } else {
            [self.imgBg setImage:[UIImage imageNamed:@"0520vip03"]];
    }
    
    
}

 

- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    self.idx = index;
    [self bindView];

    self.isFirst = NO;
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
