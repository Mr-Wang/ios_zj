//
//  WY_ExamSignupViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ExamSignupViewController.h"
#import "WY_ExamCertificationViewController.h"

@interface WY_ExamSignupViewController ()

@end

@implementation WY_ExamSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self makeUI];
    
}

    - (void)makeUI {
        self.title = @"考试详情";
        [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
        UIImageView *imgHead = [UIImageView new];
        [imgHead setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(202))];
        [imgHead setImage:[UIImage imageNamed:@"0228_ksTopImg"]];
        [self.view addSubview:imgHead];
        
        UIView *viewContnet = [UIView new];
        [viewContnet setFrame:CGRectMake(0, imgHead.bottom, kScreenWidth, k360Width(200))];
        [viewContnet setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewContnet];
        
        UILabel *lblTitle = [UILabel new];
        UIImageView *imgLine = [UIImageView new];
        UILabel *lblContent = [UILabel new];
        
        [viewContnet addSubview:lblTitle];
        [viewContnet addSubview:imgLine];
        [viewContnet addSubview:lblContent];
        
        [lblTitle setFrame:CGRectMake(k360Width(16), k360Width(10), kScreenWidth - k360Width(32), k360Width(22))];
        lblTitle.text = self.mWY_ExamListModel.title;
        [lblTitle setNumberOfLines:0];
        [lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [lblTitle setFont:WY_FONTMedium(14)];

        [lblTitle sizeToFit];
        
        [imgLine setFrame:CGRectMake(0, lblTitle.bottom + k360Width(10), kScreenWidth, k360Width(16))];
        [imgLine setBackgroundColor:HEXCOLOR(0xFAFAFA)];
        [lblContent setFrame:CGRectMake(k360Width(16), imgLine.bottom, kScreenWidth, k360Width(80))];
        
        [lblContent setFont:WY_FONTRegular(14)];
        [lblContent setNumberOfLines:0];
        lblContent.text = [NSString stringWithFormat:@"考试时间：%@\n结束时间：%@\n考试地址：%@",self.mWY_ExamListModel.examStartTime,self.mWY_ExamListModel.examEndTime,self.mWY_ExamListModel.examAddress];
        
        viewContnet.height = lblContent.bottom;
        
        UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), kScreenHeight - k360Width(50) - JCNew64  - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(30), k360Width(40))];
        [btnLeft rounded:k360Width(40/8)];
        [btnLeft setBackgroundColor:MSTHEMEColor];
        [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
        if ([self.mWY_ExamListModel.rzbs isEqualToString:@"1"]) {
            [btnLeft setTitle:@"已确认" forState:UIControlStateNormal];
            [btnLeft setUserInteractionEnabled:NO];
        } else {
            [btnLeft setTitle:@"立即确认" forState:UIControlStateNormal];
            [btnLeft setUserInteractionEnabled:YES];
        }
        [self.view addSubview:btnLeft];
    }
- (void)btnLeftAction {
    NSLog(@"点击了立即认证");
     WY_ExamCertificationViewController *tempController = [WY_ExamCertificationViewController new];
    tempController.mWY_ExamListModel = self.mWY_ExamListModel;
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
