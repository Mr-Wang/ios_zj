//
//  WY_MesDelViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/9.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_MesDelViewController.h"
#import "WY_MessageTableViewCell.h"

@interface WY_MesDelViewController ()

@end

@implementation WY_MesDelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self bindView];
}
- (void)makeUI {
    self.title = @"消息详情";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    WY_MessageTableViewCell *tempCell = [[WY_MessageTableViewCell alloc] initWithFrame:CGRectMake(0, k360Width(16), kScreenWidth, k360Width(80))];
    [tempCell showCellByItem:self.mWY_MessageModel];
    [self.view addSubview:tempCell];
}

- (void)bindView {
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mWY_MessageModel.id forKey:@"id"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:updateTslb_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
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

@end
