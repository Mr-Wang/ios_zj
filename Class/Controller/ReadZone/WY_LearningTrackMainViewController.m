//
//  WY_LearningTrackMainViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/7.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_LearningTrackMainViewController.h"
#import "ZJScrollPageView.h"//选择控制器]
#import "WY_ReadZoneItemViewController.h"

@interface WY_LearningTrackMainViewController ()

@property (nonatomic)NSInteger selZJIndex;

@property (nonatomic, weak) ZJScrollPageView *scrollPageView;//选择控制器
@property (nonatomic , strong)  NSArray *titleArr;/* 选择控制器title*/
@property (nonatomic , strong)UIButton *cancleButton;
@end

@implementation WY_LearningTrackMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self bindView];
    
}

#pragma mark --绘制页面
- (void)makeUI {
    self.title = @"学习轨迹";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self ZJScorollPageUI];//轮播选择控制器
     
}
- (void)viewDidAppear:(BOOL)animated{
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_evaluate_HTTP params:nil jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            NSMutableDictionary *dicSource = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
//            self.cancleButton = [[UIButton alloc] init];
//            self.cancleButton.frame = CGRectMake(0, 0, 80, 55);
//            //[self.cancleButton setTitle:@"学习轨迹" forState:UIControlStateNormal];
//            self.cancleButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            [self.cancleButton.titleLabel setFont:WY_FONTMedium(10)];
//            // you probably want to center it
//            self.cancleButton.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
//            [self.cancleButton setTitle: [NSString stringWithFormat:@"学习得分：%.1f分\n转换得分：%.1f分",[dicSource[@"studyScore"][@"points"] floatValue],[dicSource[@"studyScore"][@"studyScore"] floatValue]] forState: UIControlStateNormal];
//            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancleButton];
//            self.navigationItem.rightBarButtonItem = rightItem;
            
        } else {
            
        }
    } failure:^(NSError *error) {
    }];
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
    self.titleArr =@[@"未学习",@"已学习"];
    
    
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
//    if (index == 0) {
//        [self.navigationItem.rightBarButtonItem.customView setHidden:NO];
//    } else {
//        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
//    }
    //    return nil;
    self.selZJIndex = index;
    WY_ReadZoneItemViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_ReadZoneItemViewController *)reuseViewController;
    if (!fourview) {
        fourview = [[WY_ReadZoneItemViewController alloc] init];
        fourview.isTrack = @"1";
    }
    //     fourview.selDate = self.selDate;
    return fourview;
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
