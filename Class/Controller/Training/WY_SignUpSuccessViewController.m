//
//  WY_SignUpSuccessViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/19.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SignUpSuccessViewController.h"
#import "WY_SignUpDetailsViewController.h"

@interface WY_SignUpSuccessViewController ()

@end

@implementation WY_SignUpSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}
- (void)makeUI {
    self.title = @"报名结果";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgSuccess = [[UIImageView alloc] initWithFrame:CGRectMake(0, k360Width(60), k360Width(68), k360Width(68))];
    imgSuccess.centerX = self.view.centerX;
    [imgSuccess setImage:[UIImage imageNamed:@"chenggong"]];
    [self.view addSubview:imgSuccess];
    
    UILabel *lblSuccess = [[UILabel alloc] initWithFrame:CGRectMake(0, imgSuccess.bottom + k360Width(20), kScreenWidth, k360Width(30))];
    [lblSuccess setFont:WY_FONTMedium(20)];
    [lblSuccess setText:@"报名成功"];
    [lblSuccess setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lblSuccess];

    UIButton *btnGoInfo = [[UIButton alloc] initWithFrame:CGRectMake(0, lblSuccess.bottom + k360Width(20), k360Width(188), k360Width(37))];
    btnGoInfo.centerX = self.view.centerX;
    [btnGoInfo rounded:k360Width(44/8) width:1 color:HEXCOLOR(0x979797)];
    [btnGoInfo setTitle:@"查看详情" forState:UIControlStateNormal];
    [btnGoInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnGoInfo addTarget:self action:@selector(btnGoInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGoInfo];

    
}
- (void)btnGoInfoAction {
    NSLog(@"跳转至-详情页");
    WY_SignUpDetailsViewController *tempController = [WY_SignUpDetailsViewController new];
    tempController.dicSignUpSuccess = self.dicSignUpSuccess;
    tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
    tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
    tempController.paymethod = self.paymethod;
     [self jumpVC:tempController];
}

/// 跳转下一页此页消失
/// @param vc 下一页
-(void)jumpVC:(UIViewController *)vc{
    NSArray *vcs = self.navigationController.viewControllers;
    NSMutableArray *newVCS = [NSMutableArray array];
    if ([vcs count] > 0) {

        for (int i=0; i < [vcs count]-1; i++) {

            [newVCS addObject:[vcs objectAtIndex:i]];

        }

    }
    [newVCS addObject:vc];
    [self.navigationController setViewControllers:newVCS animated:YES];

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
