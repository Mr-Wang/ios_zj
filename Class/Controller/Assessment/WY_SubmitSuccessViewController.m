//
//  WY_SubmitSuccessViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SubmitSuccessViewController.h"
#import "WY_QuizReviewViewController.h"
#import "WY_QRPersonalListViewController.h"

@interface WY_SubmitSuccessViewController ()

@end

@implementation WY_SubmitSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}
- (void)makeUI {
 
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgSuccess = [[UIImageView alloc] initWithFrame:CGRectMake(0, k360Width(60), k360Width(68), k360Width(68))];
    imgSuccess.centerX = self.view.centerX;
    [imgSuccess setImage:[UIImage imageNamed:@"chenggong"]];
    [self.view addSubview:imgSuccess];
    
    UILabel *lblSuccess = [[UILabel alloc] initWithFrame:CGRectMake(0, imgSuccess.bottom + k360Width(20), kScreenWidth, k360Width(30))];
    [lblSuccess setFont:WY_FONTMedium(20)];
    [lblSuccess setText:self.title];
    [lblSuccess setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lblSuccess];

    UIButton *btnGoInfo = [[UIButton alloc] initWithFrame:CGRectMake(0, lblSuccess.bottom + k360Width(20), k360Width(188), k360Width(37))];
    btnGoInfo.centerX = self.view.centerX;
    [btnGoInfo rounded:k360Width(44/8) width:1 color:HEXCOLOR(0x979797)];
    [btnGoInfo setTitle:self.btnGoInfoTitle forState:UIControlStateNormal];
    [btnGoInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnGoInfo addTarget:self action:@selector(btnGoInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGoInfo];

    
}
- (void)btnGoInfoAction {
    NSLog(@"跳转至-详情页");
    if ([self.nsType isEqualToString:@"1"] ) {
        //查看自测成绩
        //试题回顾
        WY_QuizReviewViewController *tempController = [WY_QuizReviewViewController new];
        tempController.nsType = self.nsType;
        [self.navigationController pushViewController:tempController animated:YES];
      
    } else if ([self.nsType isEqualToString:@"2"]) {
        WY_QRPersonalListViewController *tempController = [WY_QRPersonalListViewController new];
        tempController.title = @"历史记录";
        tempController.nsType = self.nsType;
        [self.navigationController pushViewController:tempController animated:YES];
    }
//    WY_SignUpDetailsViewController *tempController = [WY_SignUpDetailsViewController new];
//    tempController.dicSignUpSuccess = self.dicSignUpSuccess;
//    tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
//    tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
//    [self.navigationController pushViewController:tempController animated:YES];
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
