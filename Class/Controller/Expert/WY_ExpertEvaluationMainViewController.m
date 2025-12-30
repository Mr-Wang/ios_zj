//
//  WY_ExpertEvaluationMainViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ExpertEvaluationMainViewController.h"
#import "WY_CompanyModel.h"

#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import <AVFoundation/AVFoundation.h>
#import "WY_AvoidanceUnitViewController.h"
#import "WY_ConsultingListViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_HistoryProjMainViewController.h"
#import "WY_AnnualEvaluationMainViewController.h"
#import "M13BadgeView.h"

@interface WY_ExpertEvaluationMainViewController ()
{
    float lastY;
}
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UILabel *lblEnterprise;
@property (nonatomic, strong) WY_UserModel *mUser;

@end

@implementation WY_ExpertEvaluationMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    [self makeUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self bindView];
}

- (void)makeUI {
    self.title = @"专家评价";
    
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.mScrollView];
    
    self.lblEnterprise = [UILabel new];
    
    
}


- (void)bindView {
    lastY = 0 ;
    
    [self.mScrollView removeAllSubviews];
    //管理权限  - 1-全部权限、2-仅查看咨询投诉、3-仅查看抽取状态
    //    if (self.administrativePermissions == 1 || self.administrativePermissions == 3) {
    UIImageView *imgview1 = [UIImageView new];
    [imgview1 setImage:[UIImage imageNamed:@"xmpj"]];
    [self initCellImage:imgview1 withBlcok:^{
        WY_HistoryProjMainViewController *tempController = [WY_HistoryProjMainViewController new];
        tempController.title = @"项目评价";
        [self.navigationController pushViewController:tempController animated:YES];
        
    }];
    
   
//    UIView * badgeSuperView = [[UIView alloc] initWithFrame:imgview1.frame];
//    [badgeSuperView setUserInteractionEnabled:NO];
//    [imgview1 addSubview:badgeSuperView];
//    [badgeSuperView setBackgroundColor:[UIColor clearColor]];
//    M13BadgeView *badgeView = [[M13BadgeView alloc] init];
//    badgeSuperView.left = imgview1.right - k360Width(20);
//    badgeSuperView.top = imgview1.top - k360Width(15);
//    badgeView.text = [NSString stringWithFormat:@"%@",res[@"data"]];
//    [badgeSuperView addSubview:badgeView];
    
    [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_getExpertEvaluateUnReadCount_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            if (![res[@"data"] isEqual:[NSNull null]]) {
                if ([res[@"data"] intValue] > 0) {
                    UIView * badgeSuperView = [[UIView alloc] initWithFrame:imgview1.frame];
                    [badgeSuperView setUserInteractionEnabled:NO];
                    [imgview1 addSubview:badgeSuperView];
                    [badgeSuperView setBackgroundColor:[UIColor clearColor]];

                    M13BadgeView *badgeView = [[M13BadgeView alloc] init];
                    badgeSuperView.left = imgview1.right - k360Width(20);
                    badgeSuperView.top = imgview1.top - k360Width(15);
                    badgeView.text = [NSString stringWithFormat:@"%@",res[@"data"]];
                    [badgeSuperView addSubview:badgeView];

                }

            }
        }
    } failure:^(NSError *error) {

    }];

    
    
    //    }
    //    if (self.administrativePermissions == 1 || self.administrativePermissions == 2) {
    //这版本暂时不上
    UIImageView *imgview2 = [UIImageView new];
    [imgview2 setImage:[UIImage imageNamed:@"ndpj"]];
    [self initCellImage:imgview2 withBlcok:^{
        NSLog(@"年度评价");
        WY_AnnualEvaluationMainViewController *tempController = [WY_AnnualEvaluationMainViewController new];
        tempController.title = @"年度评价";
        [self.navigationController pushViewController:tempController animated:YES];
        
    }];
    
    //    }
    //    UILabel *lblhbdw =  [UILabel new];
    //    lblhbdw.text = @"";
    //    [self initCellTitle:@"抽取状态" byLabel:lblhbdw isAcc:YES withBlcok:^{
    //        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
    //       wk.titleStr = @"专家抽取状态";
    //       wk.webviewURL = @"http://wlzb.lnwlzb.com:8040/Avatar/expert.html";
    //       UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
    //       navi.navigationBarHidden = NO;
    //       navi.modalPresentationStyle = UIModalPresentationFullScreen;
    //       [self presentViewController:navi animated:NO completion:nil];
    //
    //    }];
    //    UILabel *lblhbdwA =  [UILabel new];
    //    lblhbdwA.text = @"";
    //    [self initCellTitle:@"咨询投诉管理" byLabel:lblhbdwA isAcc:YES withBlcok:^{
    //        NSLog(@"咨询投诉");
    //        WY_ConsultingListViewController *tempController = [WY_ConsultingListViewController new];
    //        tempController.nsType = @"2";
    //        [self.navigationController pushViewController:tempController animated:YES];
    //
    //    }];
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, lastY)];
}


- (void)initCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel isAcc:(BOOL)isAcc   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
    
    
    [withLabel setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(16), k360Width(250) - accLeft, k360Width(44))];
    [withLabel setFont:WY_FONTRegular(14)];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextAlignment:NSTextAlignmentRight];
    [withLabel sizeToFit];
    withLabel.left = kScreenWidth - withLabel.width - k360Width(16) - accLeft;
    if (withLabel.height < k360Width(12)) {
        withLabel.height = k360Width(12);
    }
    
    viewTemp.height = withLabel.bottom + k360Width(16);
    [viewTemp addSubview:withLabel];
    
    lblTitle.height = viewTemp.height;
    if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    
}


- (void)initCellImage:(UIImageView *)withImageView   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    [withImageView setFrame:CGRectMake(k375Width(18), k375Width(18), kScreenWidth - k375Width(36), k375Width(153))];
    viewTemp.height = withImageView.bottom + k375Width(18);
    [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (withBlcok) {
            withBlcok();
        }
    }];
    [viewTemp addSubview:withImageView];
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
}

@end
