//
//  WY_AddressManageViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AddressManageViewController.h"
#import "WY_AddressManageTableViewCell.h"
#import "WY_EditAddressViewController.h"

@interface WY_AddressManageViewController () {
    float lastY;
    UIImageView * imgLine;
}
@property (nonatomic ,strong) UIScrollView *mScrollView;
@property (nonatomic ,strong) UIView *viewBody;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSMutableArray *arrSelUser;

@end

@implementation WY_AddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
   
}
- (void) viewDidAppear:(BOOL)animated {
     [self bindView];
}
- (void)makeUI {
    self.title = @"地址管理";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    self.viewBody = [UIView new];
    [self.mScrollView addSubview:self.viewBody];
    [self.view addSubview:self.mScrollView];
    [self.viewBody setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(50))];
    [self.viewBody rounded:k360Width(44/6)];
    [self.viewBody setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(10), 0, k360Width(200), k360Width(44))];
    [lblTitle setFont:WY_FONTMedium(16)];
    [lblTitle setText:@"配送地址"];
    [self.viewBody addSubview:lblTitle];
    
    UIButton *btnAddAddress = [[UIButton alloc] initWithFrame:CGRectMake(self.viewBody.width - k360Width(216), 0, k360Width(200), k360Width(44))];
    [btnAddAddress setTitle:@"新增配送地址" forState:UIControlStateNormal];
    [btnAddAddress setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [btnAddAddress.titleLabel setFont:WY_FONTRegular(14)];
    [btnAddAddress setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.viewBody addSubview:btnAddAddress];
    [btnAddAddress addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        WY_EditAddressViewController *tempController  = [WY_EditAddressViewController new];
        tempController.title = @"新增地址";
        tempController.isEdit = NO;
        [self.navigationController pushViewController:tempController animated:YES];
    }];
    
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),btnAddAddress.bottom,self.viewBody.width - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.viewBody addSubview:imgLine];
    
    
}
- (void)bindView {
     
    [[MS_BasicDataController sharedInstance] getWithReturnCode:[NSString stringWithFormat:@"%@?CGRUserGuid=%@",getUserAddressList,self.mUser.UserGuid] params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                if ([code integerValue] == 0 && res) {

            self.arrSelUser = [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_AddressManageModel class] json:res[@"data"]]];
            [self showTables];
                    
        }else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}
- (void)showTables{
    for (UIView *viewI in self.viewBody.subviews) {
        if (viewI.tag == 374) {
            [viewI removeFromSuperview];
        }
    }
    lastY = imgLine.bottom;
    for (WY_AddressManageModel *tempModel in self.arrSelUser) {
        WY_AddressManageTableViewCell *tempCell = [[WY_AddressManageTableViewCell alloc] initWithFrame:CGRectMake(0, lastY, self.viewBody.width, k360Width(84))];
        tempCell.tag = 374;
        [tempCell showCellByItem:tempModel];
        [tempCell.colSender addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            NSLog(@"tempModel.Address:%@",tempModel.Address);
            if (self.isSel && self.selAddressBlock) {
                self.selAddressBlock(tempModel);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [tempCell.btnEdit addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            NSLog(@"点击了编辑按钮");
            WY_EditAddressViewController *tempController = [WY_EditAddressViewController new];
            tempController.isEdit = YES;
            tempController.mEditModel = tempModel;
            tempController.title = @"修改地址";
            [self.navigationController pushViewController:tempController animated:YES];
        }];
        [self.viewBody addSubview:tempCell];
        lastY = tempCell.bottom;
    }
    self.viewBody.height = lastY + k360Width(16);
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, self.viewBody.bottom + k360Width(16))];

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
