//
//  WY_TestQuestionsMainViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_TestQuestionsMainViewController.h"
#import "WY_AddTestQuestionsViewController.h"
#import "WY_MyTQMainViewController.h"

@interface WY_TestQuestionsMainViewController ()

@end

@implementation WY_TestQuestionsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}

- (void)makeUI {
    self.title = @"选择题型";
    
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    UIView *viewBg = [UIView new];
    [viewBg setBackgroundColor:[UIColor whiteColor]];
    [viewBg setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(100))];
    [self.view addSubview:viewBg];
    
    UIButton *leftBtn = [UIButton new];
    UIButton *rightBtn = [UIButton new];
    [leftBtn setFrame:CGRectMake(k360Width(16), k360Width(16), (kScreenWidth - k360Width(16 * 3)) / 2, (kScreenWidth - k360Width(16 * 3)) / 2)];
    [rightBtn setFrame:CGRectMake(leftBtn.right + k360Width(16), k360Width(16), (kScreenWidth - k360Width(16 * 3)) / 2, (kScreenWidth - k360Width(16 * 3)) / 2)];
    [viewBg addSubview:leftBtn];
    [viewBg addSubview:rightBtn];
    
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"0414_ct1"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"0414_ct2"] forState:UIControlStateNormal];
    
    [leftBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"单选");
        WY_AddTestQuestionsViewController *tempController = [WY_AddTestQuestionsViewController new];
        tempController.questionType = @"1";
        tempController.isAddType = @"1";
        [self.navigationController pushViewController:tempController animated:YES];
    }];
    [rightBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"多选");
        WY_AddTestQuestionsViewController *tempController = [WY_AddTestQuestionsViewController new];
        tempController.questionType = @"2";
        tempController.isAddType = @"1";
        [self.navigationController pushViewController:tempController animated:YES];
    }];
    
    UIButton *cancleButton = [[UIButton alloc] init];
    cancleButton.frame = CGRectMake(0, 0, 44, 44);
    [cancleButton setTitle:@"我的题目" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    viewBg.height = leftBtn.bottom + k360Width(16);
    
}
- (void)navRightAction {
    NSLog(@"我的题目");
    WY_MyTQMainViewController *tempController = [WY_MyTQMainViewController new];
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

@end
