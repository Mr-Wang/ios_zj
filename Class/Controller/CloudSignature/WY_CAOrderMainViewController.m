//
//  WY_CAOrderMainViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_CAOrderMainViewController.h"
#import "ZJScrollPageView.h"//选择控制器]
#import "WY_CAOrderListViewController.h"
#import "WY_CloudSignatureOrderListViewController.h"

@interface WY_CAOrderMainViewController ()

 
@property (nonatomic, weak) ZJScrollPageView *scrollPageView;//选择控制器
@property (nonatomic , strong)  NSArray *titleArr;/* 选择控制器title*/
@end

@implementation WY_CAOrderMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
        [self makeUI];
        [self bindView];
    if (self.selZJIndex != 0) {
              [self.scrollPageView setSelectedIndex:self.selZJIndex animated:YES];
              
          }
}

#pragma mark --绘制页面
- (void)makeUI {
    self.title = @"订单管理";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
 
    [self ZJScorollPageUI];//轮播选择控制器
       
}
#pragma mark --绑定数据
- (void)bindView {
    
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
    self.titleArr =@[@"云签章订单",@"实体锁订单"];
    
     
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin) segmentStyle:style titles:self.titleArr parentViewController:self delegate:self];
    
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
    if (index == 0) {
        [self.navigationItem.rightBarButtonItem.customView setHidden:NO];
    } else {
        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
    }
    self.selZJIndex = index;
      if (index == 0) {
          WY_CloudSignatureOrderListViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_CloudSignatureOrderListViewController *)reuseViewController;
          if (!fourview) {
              fourview = [[WY_CloudSignatureOrderListViewController alloc] init];
          }
           return fourview;
          
      } else  {
          WY_CAOrderListViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_CAOrderListViewController *)reuseViewController;
          if (!fourview) {
              fourview = [[WY_CAOrderListViewController alloc] init];
          }
           return fourview;
      }
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
