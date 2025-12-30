//
//  WY_CAPaySuccessViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/17.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_CAPaySuccessViewController.h"
#import "WY_CAOrderMainViewController.h"

@interface WY_CAPaySuccessViewController ()

@end

@implementation WY_CAPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付结果";
    
    [self makeUI];
//    [self customBackButton];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"白返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
    self.navigationItem.leftBarButtonItem = right;
}
- (void)viewDidAppear:(BOOL)animated {
    

}
- (void)viewDidDisappear:(BOOL)animated {
    
 
}
// 自定义返回按钮
- (void)customBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:WY_FONTRegular(14)];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 60, 40);
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
    // pop
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];

    UIImageView *imgSuccess = [UIImageView new];
    [imgSuccess setFrame:CGRectMake((kScreenWidth - k360Width(70) )/ 2, k360Width(70), k360Width(70), k360Width(70))];
    [imgSuccess setImage:[UIImage imageNamed:@"0317_success"]];
    [self.view addSubview:imgSuccess];
    
    UILabel *lblName = [UILabel new];
     UILabel *lblOrderMoney = [UILabel new];
    
    UIButton *btnGoOrderList = [UIButton new];
    UIButton *btnGoHomePage = [UIButton new];
    
    [lblName setFrame:CGRectMake(0, imgSuccess.bottom + k360Width(32), kScreenWidth, k360Width(26))];
    [lblName setFont:WY_FONTRegular(22)];
    [lblName setText:@"支付成功"];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    
    [lblOrderMoney setFrame:CGRectMake(0, lblName.bottom + k360Width(32), kScreenWidth, k360Width(44))];
    [lblOrderMoney setNumberOfLines:2];
    
    NSString *orderNo = @"";
    if ([self.caType isEqualToString:@"2"]) {
        //云签章
        orderNo = self.dicSignUpSuccess[@"orderNo"];
    } else{
        //实体CA
        orderNo = self.dicSignUpSuccess[@"orderno"];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单编号：%@\n订单金额：",orderNo]];
    [attStr setYy_color:APPTextGayColor];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元",[self.bodyStr floatValue]]];
    [attStr1 setYy_color:[UIColor redColor]];
    [attStr appendAttributedString:attStr1];
    [attStr setYy_lineSpacing:10];
    [lblOrderMoney setAttributedText:attStr];
    
    [lblOrderMoney sizeToFit];
    
    [lblOrderMoney setCenterX:lblName.centerX];
    
    [btnGoOrderList setFrame:CGRectMake(k360Width(25), kScreenHeight - k360Width(180), kScreenWidth - k360Width(50), k360Width(47))];
    
    [btnGoHomePage setFrame:CGRectMake(k360Width(25), btnGoOrderList.bottom + k360Width(15), kScreenWidth - k360Width(50), k360Width(47))];
    
    [btnGoOrderList setBackgroundColor:MSTHEMEColor];
    
    [btnGoOrderList rounded:k360Width(3)];
    
    [btnGoHomePage setBackgroundColor:[UIColor whiteColor]];
    [btnGoHomePage setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [btnGoHomePage rounded:k360Width(3) width:k360Width(1) color:MSTHEMEColor];
    
    [btnGoOrderList setTitle:@"查看订单" forState:UIControlStateNormal];
    [btnGoHomePage setTitle:@"返回首页" forState:UIControlStateNormal];
    [btnGoOrderList.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k360Width(18)]];
    
    [btnGoHomePage.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k360Width(18)]];
    
    [self.view addSubview:lblName];
     [self.view addSubview:lblOrderMoney];
    
    [self.view addSubview:btnGoOrderList];
    [self.view addSubview:btnGoHomePage];
    
    [btnGoOrderList addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"跳转到订单列表页");
        WY_CAOrderMainViewController *tempController = [WY_CAOrderMainViewController new];
        
        
        if ([self.caType isEqualToString:@"2"]) {
            //云签章
            tempController.selZJIndex = 0;
        } else{
            //实体CA
            tempController.selZJIndex = 1;
        }
        
        NSArray *vcs = self.navigationController.viewControllers;

            NSMutableArray *newVCS = [NSMutableArray array];

            if ([vcs count] > 0) {
                [newVCS addObject:[vcs objectAtIndex:0]];
            }
            tempController.hidesBottomBarWhenPushed = YES;
            [newVCS addObject:tempController];
            [self.navigationController setViewControllers:newVCS animated:YES];
 
     }];
    [btnGoHomePage addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            NSLog(@"回到首页");
            [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)closeClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
