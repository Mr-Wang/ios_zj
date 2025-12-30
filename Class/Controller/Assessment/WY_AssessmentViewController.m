//
//  WY_AssessmentViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AssessmentViewController.h"
#import "SDCycleScrollView.h"
#import "WY_HomeItemView.h"
#import "WY_LoginViewController.h"
#import "WY_AnnouncementView.h"
#import "WY_ExamHomeModel.h"
#import "WY_QuizViewController.h"
#import "WY_QuizRecordMainViewController.h"
#import "WY_QuizReviewViewController.h"
#import "WY_SubmitSuccessViewController.h"
#import "WY_ExamListModel.h"
#import "EmptyView.h"
#import "WY_KsNoticeTableViewCell.h"
#import "WY_ExamSignupViewController.h"
#import "WY_ExamCertificationViewController.h"
#import "WY_QRPersonalListViewController.h"
#import "WY_ZJPushMsgViewController.h"
#import "WY_ReShousListModel.h"
#import "WY_OnlineTrainDetailsViewController.h"
#import "WY_QRPersonalListViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_InfoConfirmViewController.h"

@interface WY_AssessmentViewController ()
{
    CGFloat topHeight;
    CGFloat bottomHeight;
    CGFloat beginContentY;          //开始滑动的位置
    
    UIImageView *imgTopBg;  //顶部曲线图片
    UIView *viewItemLeft;   //顶部ItemsLeft
    UIView *viewItemRight;  //顶部ItemsRight
    UIView *viewLeft;
    UIView *viewRight;
    
    UIView *viewVideo;
    UIView *viewVideoContent;
    UIView *viewRead;
    UIView *viewReadContent;
    UIView *viewWntj;
    UIView *viewWntjContent;
    
    UIButton *btnLeft;
    UIButton *btnRight;
    
    UIButton *btnStartZc;
    UILabel *lblNum1;
    UILabel *lblNum2;
    UILabel *lblNum3;
 }
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) SDCycleScrollView *headerView;
@property (nonatomic, strong) NSMutableArray *arrIcons;
@property (nonatomic, strong) NSMutableArray *arrRightIcons;
@property (nonatomic, strong) NSMutableArray *arrExamList;
@property (nonatomic) NSInteger pageItemNum;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) WY_ExamHomeModel *mWY_ExamHomeModel;

@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSArray* reShousList;

@end

@implementation WY_AssessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageItemNum = 10;
    self.currentPage = 1;
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserver:self selector:@selector(updateFontSizeNotify:) name:@"UPDATEFONTSIZENOTIFY" object:nil];
    [self makeUI];
}
//修改了字体
- (void)updateFontSizeNotify:(NSNotification *)notifySender {
    [self.view removeAllSubviews];
    [self makeUI];
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [self dataSourceIndex];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark --绘制页面
- (void)makeUI {
    //顶部曲面图片
    imgTopBg = [[UIImageView alloc] init];
    [imgTopBg setFrame:CGRectMake(0, JCNew64, kScreenWidth + 2, 128)];
    //    [imgTopBg setImage:[UIImage imageNamed:@"1010_syTop"]];
    [self.view addSubview:imgTopBg];
    //顶部导航栏View；
    UIView *navView = [[UIView alloc] init];
    [navView setFrame:CGRectMake(0, 0, kScreenWidth, JCNew64)];
    [navView setBackgroundColor:HEXCOLOR(0x448EEE)];

//    UIImageView *imgNavBg = [[UIImageView alloc] init];
//    [imgNavBg setFrame:CGRectMake(0, 0, kScreenWidth, k375Width(50))];
//    [imgNavBg setImage:[UIImage imageNamed:@"1127_dingbubujing"]];
//    [navView addSubview:imgNavBg];
    
    //搜索功能
    UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0521_ss"]];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
    loginImgV.center = lv.center;
    [lv addSubview:loginImgV];
    
    UITextField *txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(k375Width(16), MH_APPLICATION_STATUS_BAR_HEIGHT + k360Width(10), k375Width(305), k375Width(25))];
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    txtSearch.leftView = lv;
    [txtSearch setFont:WY_FONTRegular(14)];
     [txtSearch rounded:k375Width(25 / 8)];
    [txtSearch setBackgroundColor:MSColorA(255, 255, 255, 0.22)];
    [txtSearch setUserInteractionEnabled:NO];
    UIControl *colSearch = [[UIControl alloc] initWithFrame:txtSearch.frame];
    [colSearch setBackgroundColor:[UIColor clearColor]];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"查看历史记录"];
    [attStr setYy_color:[UIColor whiteColor]];
    txtSearch.attributedPlaceholder = attStr;
 
    [colSearch addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //历史记录
//        WY_QuizRecordMainViewController *tempController = [WY_QuizRecordMainViewController new];
//        tempController.nsType = @"1";
//        [self.navigationController pushViewController:tempController animated:YES];
        
        WY_QRPersonalListViewController *tempController = [WY_QRPersonalListViewController new];
        tempController.title = @"历史记录";
        tempController.nsType = @"1";
        [self.navigationController pushViewController:tempController animated:YES];

        
    }];
    [navView addSubview:txtSearch];
    [navView addSubview:colSearch];
    
    
    //消息功能；
    UIButton *btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(txtSearch.right + k375Width(16), txtSearch.top + k375Width(4), k375Width(22), k375Width(22))];
    [btnMessage setBackgroundImage:[UIImage imageNamed:@"0521消息"] forState:UIControlStateNormal];    
    [btnMessage addTarget:self action:@selector(btnMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btnMessage];
    
    
    navView.height = txtSearch.bottom + k360Width(10);
    
    self.mScrollView = [[UIScrollView alloc] init];
    [self.mScrollView setFrame:CGRectMake(0, navView.bottom, kScreenWidth, kScreenHeight - MH_APPLICATION_TAB_BAR_HEIGHT - navView.bottom)];
    [self.mScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.mScrollView];
    [self.mScrollView setDelegate:self];
    self.mScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataSourceIndex)];
    [self.view addSubview:navView];
    
    
    
    // 头视图 banner
    self.headerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(k360Width(16),  k360Width(5), (int)(kScreenWidth - k360Width(32)), k360Width(150))];
        self.headerView.autoScrollTimeInterval = 5.0f;
    //    self.headerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.headerView.placeholderImage = [UIImage imageNamed:@"0211_CourseTop"];
    [self.headerView rounded:k360Width(40/8)];
    [self.mScrollView addSubview:self.headerView];
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, kScreenWidth / 2, k360Width(44))];
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2, self.headerView.bottom, kScreenWidth / 2, k360Width(44))];
    [btnLeft setTitle:@"模拟考试" forState:UIControlStateNormal];
    [btnRight setTitle:@"考试考核" forState:UIControlStateNormal];
    
    [btnLeft.titleLabel setFont:WY_FONTMedium(16)];
    [btnRight.titleLabel setFont:WY_FONTMedium(16)];
    
    [btnLeft setTitleColor:MSTHEMEColor forState:UIControlStateSelected];
    [btnRight setTitleColor:MSTHEMEColor forState:UIControlStateSelected];
    
    [btnLeft setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    [btnRight setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    
    [btnLeft setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [btnRight setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    
    [self.mScrollView addSubview:btnLeft];
    [self.mScrollView addSubview:btnRight];
    [btnLeft setSelected:YES];
    UIView *imgLineLeft = [[UIView alloc] initWithFrame:CGRectMake(0, btnLeft.bottom + k360Width(3), k360Width(20), k360Width(2))];
    UIView *imgLineRight = [[UIView alloc] initWithFrame:CGRectMake(0, btnLeft.bottom + k360Width(3), k360Width(20), k360Width(2))];
    [imgLineLeft setBackgroundColor:MSTHEMEColor];
    [imgLineRight setBackgroundColor:MSTHEMEColor];
    [imgLineRight setHidden:YES];
    imgLineLeft.centerX = btnLeft.centerX;
    imgLineRight.centerX = btnRight.centerX;
    
    [self.mScrollView addSubview:imgLineLeft];
    [self.mScrollView addSubview:imgLineRight];
    
    
    
    viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, btnLeft.bottom + k360Width(5), kScreenWidth, k360Width(90))];
    
    viewRight = [[UIView alloc] initWithFrame:CGRectMake(0, btnLeft.bottom+ k360Width(5), kScreenWidth, k360Width(90))];
    [self.mScrollView addSubview:viewLeft];
    [self.mScrollView addSubview:viewRight];
    [viewRight setHidden:YES];
    
    viewItemLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(110))];
    [viewLeft addSubview:viewItemLeft];
    
    viewItemRight = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(110))];
    [viewRight addSubview:viewItemRight];
    
    UIView *viewNums = [[UIView alloc] initWithFrame:CGRectMake(0, viewItemLeft.bottom + k360Width(10), k360Width(88 * 3), k360Width(88))];
    UIImageView *imgNumsBg = [[UIImageView alloc] initWithFrame:CGRectMake(k375Width(9), 0, k375Width(358), k375Width(84))];
    [imgNumsBg setImage:[UIImage imageNamed:@"imgNumsBg"]];
    [viewNums addSubview:imgNumsBg];
    imgNumsBg.centerX = viewNums.centerX;
    lblNum1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k360Width(88), k360Width(88))];
    lblNum2 = [[UILabel alloc] initWithFrame:CGRectMake(lblNum1.right, 0, k360Width(88), k360Width(88))];
    lblNum3 = [[UILabel alloc] initWithFrame:CGRectMake(lblNum2.right, 0, k360Width(88), k360Width(88))];
    //    [lblNum1 setBackgroundColor:[UIColor redColor]];
    //    [lblNum2 setBackgroundColor:[UIColor yellowColor]];
    //    [lblNum3 setBackgroundColor:[UIColor greenColor]];
    [viewNums addSubview:lblNum1];
    [viewNums addSubview:lblNum2];
    [viewNums addSubview:lblNum3];
    [lblNum1 setNumberOfLines:0];
    [lblNum2 setNumberOfLines:0];
    [lblNum3 setNumberOfLines:0];
    [lblNum1 setTextAlignment:NSTextAlignmentCenter];
    [lblNum2 setTextAlignment:NSTextAlignmentCenter];
    [lblNum3 setTextAlignment:NSTextAlignmentCenter];
    
    viewNums.centerX = viewLeft.centerX;
    [viewLeft addSubview:viewNums];
    
    
    btnStartZc = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(14), viewNums.bottom + k375Width(14), k375Width(346), k375Width(77))];
    [btnStartZc setBackgroundImage:[UIImage imageNamed:@"0225_Khkscy"] forState:UIControlStateNormal];
    [btnStartZc setBackgroundImage:[UIImage imageNamed:@"0225_Khkscy"] forState:UIControlStateHighlighted];
    [btnStartZc setBackgroundImage:[UIImage imageNamed:@"0225_Khkscyhui"] forState:UIControlStateSelected];
    WS(weakSelf)
    [btnStartZc addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了开始自测");
        if (![weakSelf verificationIsOrgUser]) {
             return;
         }
        WY_QuizViewController *tempController = [WY_QuizViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
        tempController.isReview = NO;
        tempController.nsType = @"1";
        tempController.submitQuizBlock = ^{
            [self performSelector:@selector(GotoSuccessPage:) withObject:@"1" afterDelay:0.5];
        };
        [weakSelf presentViewController:tempController animated:YES completion:nil];
    }];
    [viewLeft addSubview:btnStartZc];
    viewLeft.height = btnStartZc.bottom;
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, viewLeft.bottom)];
    
    
    
    viewVideo = [[UIView alloc] initWithFrame:CGRectMake(0, viewItemRight.bottom + 5, kScreenWidth, k360Width(44))];
    viewVideoContent =[[UIView alloc] initWithFrame:CGRectMake(0, viewVideo.bottom, kScreenWidth, k360Width(200))];
    
    
    [viewRight addSubview:viewVideo];
    [viewRight addSubview:viewVideoContent];
    
    
    [self viewReadInit:viewVideo withTitleStr:@"考试通知"];
    
    [btnLeft addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [btnLeft setSelected:YES];
        [btnRight setSelected:NO];
        [viewLeft setHidden:NO];
        [viewRight setHidden:YES];
        [imgLineLeft setHidden:NO];
        [imgLineRight setHidden:YES];
        
        [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, viewLeft.bottom)];
    }];
    [btnRight addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [btnLeft setSelected:NO];
        [viewRight setHidden:NO];
        [imgLineRight setHidden:NO];
        [btnRight setSelected:YES];
        [viewLeft setHidden:YES];
        [imgLineLeft setHidden:YES];
        
        [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, viewRight.bottom)];
    }];
}
//跳转值交卷成功页；
- (void)GotoSuccessPage:(NSString *)nsType{
    WY_SubmitSuccessViewController *tempController = [WY_SubmitSuccessViewController new];
    tempController.nsType = nsType;
    tempController.title = @"交卷成功";
    tempController.btnGoInfoTitle = @"查看成绩";
    [self.navigationController pushViewController:tempController animated:YES];
}

- (void)viewReadInit:(UIView *)vrView withTitleStr:(NSString *)titleStr{
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [vrView addSubview:viewBlue1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(viewBlue1.right + k360Width(8), k360Width(0), k360Width(264), k360Width(44));
    label.text = titleStr;
    label.font = WY_FONTMedium(16);
    label.textColor = HEXCOLOR(0x448EEE);
    [vrView addSubview:label];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    imgTopBg.alpha = (100 - scrollView.contentOffset.y) / 100;
}

- (void)dataSourceIndex {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:@"3" forKey:@"type"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getTpUrl_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
           if ([code integerValue] == 0 && res) {
               self.reShousList = [NSArray yy_modelArrayWithClass:[WY_ReShousListModel class] json:res[@"data"]];
               [self initTopHead];
            } else {
               [SVProgressHUD showErrorWithStatus:res[@"msg"]];
           }
           [self.mScrollView.mj_header endRefreshing];

       } failure:^(NSError *error) {
           [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
           [self.mScrollView.mj_header endRefreshing];

       }];

    [[MS_BasicDataController sharedInstance] postWithReturnCode:getExamHome_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 1 && res) {
            self.mWY_ExamHomeModel = [WY_ExamHomeModel modelWithJSON:res[@"data"]];
            [self bindView];
            
            
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
        [self.mScrollView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
        [self.mScrollView.mj_header endRefreshing];
        
    }];

    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"baomingidcard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getExamList_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            self.arrExamList = [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_ExamListModel class] json:res[@"data"]]];
              [self bindRightListViewByIsKs:YES withStr:@""];
        } else {
            [self bindRightListViewByIsKs:NO withStr:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
   
}


- (void)bindRightListViewByIsKs:(BOOL)  withisKs withStr:(NSString *)msgStr {
    //清空- 视频专区模块内容；
    [viewVideoContent removeAllSubviews];
    if (withisKs) {
            if (self.arrExamList.count > 0) {
                UIButton *imgKs = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(132))];
                [imgKs setBackgroundImage:[UIImage imageNamed:@"0228_ksBanner"] forState:UIControlStateNormal];
                [imgKs setBackgroundImage:[UIImage imageNamed:@"0228_ksBanner"] forState:UIControlStateHighlighted];
                [imgKs addTarget:self action:@selector(signUpPage) forControlEvents:UIControlEventTouchUpInside];
                [viewVideoContent addSubview:imgKs];
                int lastY = imgKs.bottom;
                for (WY_ExamListModel *examItem in self.arrExamList) {
                    WY_KsNoticeTableViewCell *tempCell = [[WY_KsNoticeTableViewCell alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(60))];
                    [tempCell showCellByItem:examItem];
                    
                    [tempCell.btnRight addTarget:self action:@selector(gotoCertificationPage) forControlEvents:UIControlEventTouchUpInside];

                    [tempCell.colSender addTarget:self action:@selector(signUpPage) forControlEvents:UIControlEventTouchUpInside];

                    [viewVideoContent addSubview:tempCell];
                    lastY = tempCell.bottom;
                }
                
                viewVideoContent.height = lastY + k360Width(16);
            }
    } else {
        EmptyView *emView = [[EmptyView alloc] initWithFrame:viewVideoContent.bounds];
        [emView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
        emView.picImgSize = [UIImage imageNamed:@"0116nobg"];
        emView.contentLabel.text = msgStr;
        [viewVideoContent addSubview:emView];
     }
    viewRight.height = viewVideoContent.bottom;
}

- (void)signUpPage {
    if (![self verificationIsOrgUser]) {
         return;
     }
    //考试报名- 详情页；
    NSLog(@"考试报名- 详情页");
    WY_ExamSignupViewController *tempController = [WY_ExamSignupViewController new];
    tempController.mWY_ExamListModel = [self.arrExamList firstObject];
    [self.navigationController pushViewController:tempController animated:YES];
}

- (void)startFormalExam {
    NSLog(@"点击了开始正式考试");
    if (![self verificationIsOrgUser]) {
         return;
     }
    
    WY_ExamListModel *tempModel =  [self.arrExamList firstObject];

    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"baomingidcard"];
    [postDic setObject:tempModel.ClassGuid forKey:@"ClassGuid"];
    [postDic setObject:tempModel.examInfoId forKey:@"examInfoId"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getIsexam_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
             WY_QuizViewController *tempController = [WY_QuizViewController new];
             tempController.modalPresentationStyle = UIModalPresentationFullScreen;
             tempController.isReview = NO;
             tempController.nsType = @"2";
             tempController.examInfoId = tempModel.examInfoId;
             tempController.submitQuizBlock = ^{
                 [self performSelector:@selector(GotoSuccessPage:) withObject:@"2" afterDelay:0.5];
             };
             [self presentViewController:tempController animated:YES completion:nil];
        } else if ([code integerValue] == 2) {
            //进入报名认证
            [self gotoCertificationPage];
            [self.view makeToast:res[@"msg"]];
        }else {
            [self.view makeToast:res[@"msg"]];
         }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
 }


- (void)initTopHead {
    //填充滚动条图片url 模拟
       
       NSMutableArray *arrImageUrl = [[NSMutableArray alloc] init];
       for (WY_ReShousListModel *rslModel in self.reShousList) {
           [arrImageUrl addObject:rslModel.url];
       }
       
       self.headerView.imageURLStringsGroup = arrImageUrl;
   
       WS(weakSelf)
       [self.headerView setClickItemOperationBlock:^(NSInteger currentIndex) {
           WY_ReShousListModel *rslModel = weakSelf.reShousList[currentIndex];
           NSLog(@"点击了ishy：%@",rslModel.ishy);
           if (rslModel.infoid.length > 0 && ([rslModel.ishy isEqualToString:@"0"] || [rslModel.ishy isEqualToString:@"3"])) {
               WY_OnlineTrainDetailsViewController *tempController = [WY_OnlineTrainDetailsViewController new];
               WY_TrainItemModel *tempModel = [WY_TrainItemModel new];
               tempModel.rowGuid = rslModel.infoid;
               tempModel.ishy = rslModel.ishy;
               tempController.mWY_TrainItemModel = tempModel;
               tempController.title = @"在线视频培训";
               [weakSelf.navigationController pushViewController:tempController animated:YES];
               return;
           }
           if ([rslModel.ishy isEqualToString:@"100"] || [rslModel.ishy isEqualToString:@"101"]) {
               MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
              wk.titleStr = rslModel.title;
               wk.ishy = rslModel.ishy;
              wk.webviewURL = rslModel.infoid;
              UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
              navi.navigationBarHidden = NO;
              navi.modalPresentationStyle = UIModalPresentationFullScreen;
              [weakSelf presentViewController:navi animated:NO completion:nil];
               return;
           }
           if ([rslModel.ishy isEqualToString:@"cns"]) {
               WY_InfoConfirmViewController *tempController = [WY_InfoConfirmViewController new];
               [self.navigationController pushViewController:tempController animated:YES];
               return;
           }
       }];
}


#pragma mark --绑定视图数据
- (void)bindView {
    //清空viewItem显示
    [viewItemLeft removeAllSubviews];
    [viewItemRight removeAllSubviews];
    //填充滚动条图片url 模拟
//
//    NSMutableArray *arrImageUrl = [[NSMutableArray alloc] init];
//    [arrImageUrl addObject:[UIImage imageNamed:@"0211_khTop"]];
//    self.headerView.localizationImageNamesGroup = arrImageUrl;
//    WS(weakSelf)
//    [self.headerView setClickItemOperationBlock:^(NSInteger currentIndex) {
//    }];
    
    //填充ViewLeftItem数据
    [self initLeftItems];
    
    [self initRightItems];
    
    //数字绑定
    NSMutableAttributedString *attNum1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.mWY_ExamHomeModel.examCount]];
    [attNum1 setYy_font:WY_FONTMedium(16)];
    [attNum1 setYy_color:[UIColor blackColor]];
    
    NSMutableAttributedString *attNum1A = [[NSMutableAttributedString alloc] initWithString:@"\n测试次数"];
    [attNum1A setYy_font:WY_FONTRegular(12)];
    [attNum1A setYy_color:APPTextGayColor];
    [attNum1 appendAttributedString:attNum1A];
    lblNum1.attributedText = attNum1;
    
    NSMutableAttributedString *attNum2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.mWY_ExamHomeModel.questionCount]];
    [attNum2 setYy_font:WY_FONTMedium(16)];
    [attNum2 setYy_color:[UIColor blackColor]];
    
    NSMutableAttributedString *attNum2A = [[NSMutableAttributedString alloc] initWithString:@"\n测试题数"];
    [attNum2A setYy_font:WY_FONTRegular(12)];
    [attNum2A setYy_color:APPTextGayColor];
    [attNum2 appendAttributedString:attNum2A];
    lblNum2.attributedText = attNum2;
    
    NSMutableAttributedString *attNum3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.mWY_ExamHomeModel.averageScore]];
    [attNum3 setYy_font:WY_FONTMedium(16)];
    [attNum3 setYy_color:[UIColor blackColor]];
    
    NSMutableAttributedString *attNum3A = [[NSMutableAttributedString alloc] initWithString:@"\n平均成绩"];
    [attNum3A setYy_font:WY_FONTRegular(12)];
    [attNum3A setYy_color:APPTextGayColor];
    [attNum3 appendAttributedString:attNum3A];
    lblNum3.attributedText = attNum3;
    
    if (btnLeft.selected) {
        [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, viewLeft.bottom)];
    }  else {
        [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, viewRight.bottom)];
    }
}
- (void)initLeftItems {
    self.arrIcons = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    
//    [self.arrIcons addObject:dic1];
    [self.arrIcons addObject:dic2];
    [self.arrIcons addObject:dic3];
    [self.arrIcons addObject:dic4];
    
//    [dic1 setObject:[UIImage imageNamed:@"0225_Khhyzq"] forKey:@"img"];
    if ([self.mWY_ExamHomeModel.result boolValue]) {
        [dic2 setObject:[UIImage imageNamed:@"0225_Khcxce"] forKey:@"img"];
        [dic3 setObject:[UIImage imageNamed:@"0225_Khsthg"] forKey:@"img"];
        [btnStartZc setSelected:YES];
        [btnStartZc setUserInteractionEnabled:NO];
    } else {
        [dic2 setObject:[UIImage imageNamed:@"0225_Khcxcehui"] forKey:@"img"];
        [dic3 setObject:[UIImage imageNamed:@"0225_Khsthghui"] forKey:@"img"];
        [btnStartZc setSelected:NO];
        [btnStartZc setUserInteractionEnabled:YES];
    }
    [dic4 setObject:[UIImage imageNamed:@"0225_Khlscj"] forKey:@"img"];
    
//    [dic1 setObject:@"会员专享" forKey:@"title"];
    [dic2 setObject:@"重新测试" forKey:@"title"];
    [dic3 setObject:@"试题回顾" forKey:@"title"];
    [dic4 setObject:@"历史记录" forKey:@"title"];
    
    float Start_X  = k360Width(5);           // 第一个按钮的X坐标
    float Start_Y = k360Width(16);       // 第一个按钮的Y坐标
    float  Width_Space = 0;//k360Width(5);     // 2个按钮之间的横间距
    float  Height_Space = k360Width(8);// 竖间距
    float  Button_Height = k360Width(66);// 高
    float  Button_Width = (kScreenWidth - k360Width(10)) / 3; //k360Width(44);// 宽
    
    for (int i =0; i < self.arrIcons.count; i ++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        // 圆角按钮
        WY_HomeItemView *aBt = [[WY_HomeItemView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
        NSMutableDictionary *dic = self.arrIcons[i];
        [aBt bindViewWith:dic[@"img"] titleStr:dic[@"title"]];
        aBt.tag = i;
        [aBt addTarget:self action:@selector(itemBtnLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewItemLeft addSubview:aBt];
    }
}

- (void)initRightItems {
    self.arrRightIcons = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    
    [self.arrRightIcons addObject:dic1];
    [self.arrRightIcons addObject:dic2];
    [self.arrRightIcons addObject:dic3];
    
    [dic1 setObject:[UIImage imageNamed:@"0225_Khksks"] forKey:@"img"];
    [dic2 setObject:[UIImage imageNamed:@"0225_Khsthg"] forKey:@"img"];
    [dic3 setObject:[UIImage imageNamed:@"0225_Khlscj"] forKey:@"img"];
    
    [dic1 setObject:@"开始考试" forKey:@"title"];
    [dic2 setObject:@"试题回顾" forKey:@"title"];
    [dic3 setObject:@"历史记录" forKey:@"title"];
    
    float Start_X  = k360Width(5);           // 第一个按钮的X坐标
    float Start_Y = k360Width(16);       // 第一个按钮的Y坐标
    float  Width_Space = 0;//k360Width(5);     // 2个按钮之间的横间距
    float  Height_Space = k360Width(8);// 竖间距
    float  Button_Height = k360Width(66);// 高
    float  Button_Width = (kScreenWidth - k360Width(10)) / 3; //k360Width(44);// 宽
    
    for (int i =0; i < self.arrRightIcons.count; i ++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        // 圆角按钮
        WY_HomeItemView *aBt = [[WY_HomeItemView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
        NSMutableDictionary *dic = self.arrRightIcons[i];
        [aBt bindViewWith:dic[@"img"] titleStr:dic[@"title"]];
        aBt.tag = i;
        [aBt addTarget:self action:@selector(itemBtnRightAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewItemRight addSubview:aBt];
    }
}


- (void)gotoCertificationPage {
    if (![self verificationIsOrgUser]) {
         return;
     }
    NSLog(@"去认证");
    WY_ExamListModel *tempModel =  [self.arrExamList firstObject];
    WY_ExamCertificationViewController *tempController = [WY_ExamCertificationViewController new];
    tempController.mWY_ExamListModel = tempModel;
    [self.navigationController pushViewController:tempController animated:YES];
}

#pragma mark --消息按钮点击事件
- (void)btnMessageAction {
    NSLog(@"点击了消息按钮");
    WY_ZJPushMsgViewController *tempController = [WY_ZJPushMsgViewController new];
    [self.navigationController pushViewController:tempController animated:YES];

}

#pragma mark --icon按钮点击事件；
-(void)itemBtnLeftAction:(WY_HomeItemView *)sender {
    if (![self verificationIsOrgUser]) {
         return;
     }
    //判断是否登录
    if (![self.mWY_ExamHomeModel.result boolValue]) {
        if (sender.tag == 0 || sender.tag == 1) {
            return;
        }
    }
    NSLog(@"%@",self.arrIcons[sender.tag][@"title"]);
    
    switch (sender.tag) {
//        case 0:
//        {
//            [self.view makeToast:@"此功能即将上线，敬请期待"];
//        }
//            break;
        case 0:
        {
            //重置试题；
//
            [[MS_BasicDataController sharedInstance] postWithReturnCode:resetExam_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                if ([code integerValue] == 1 && res) {
                    [self dataSourceIndex];
                } else {
                    [SVProgressHUD showErrorWithStatus:res[@"msg"]];
                }
                [self.mScrollView.mj_header endRefreshing];
                
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
                [self.mScrollView.mj_header endRefreshing];
            }];

        }
            break;
        case 1:
        {
            //试题回顾
            WY_QuizReviewViewController *tempController = [WY_QuizReviewViewController new];
            tempController.nsType = @"1";
            [self.navigationController pushViewController:tempController animated:YES];

        }
            break;
        case 2:
        {
            WY_QRPersonalListViewController *tempController = [WY_QRPersonalListViewController new];
            tempController.title = @"历史记录";
            tempController.nsType = @"1";
            [self.navigationController pushViewController:tempController animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}
///验证是否企业用户
- (BOOL) verificationIsOrgUser {
    //先限制是否登录。再限制是否是专家 -
    //判断是否登录
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
        return NO;
    }
    if (EXPERTISMIND == 1 || EXPERTISMIND ==2) {
        [SVProgressHUD showInfoWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
        return NO;
    }
     if ([self.mUser.UserType isEqualToString:@"1"]) {
        return  YES;
    } else {
        [SVProgressHUD showInfoWithStatus:@"此功能仅对专家用户开放，感谢您的使用和支持。"];
        return NO;
    }
}

-(void)itemBtnRightAction:(WY_HomeItemView *)sender {
    if (![self verificationIsOrgUser]) {
        return;
    }
    //判断是否登录
    NSLog(@"%@",self.arrRightIcons[sender.tag][@"title"]);
    switch (sender.tag) {
        case 0:
        {
            if (self.arrExamList.count <= 0) {
                  [self.view makeToast:@"当前没有正在进行的考试"];
            } else {
                [self startFormalExam];
            }
        }
            break;
            case 1:
        {
            //试题回顾
            WY_QuizReviewViewController *tempController = [WY_QuizReviewViewController new];
            tempController.nsType = @"2";
            [self.navigationController pushViewController:tempController animated:YES];

        }
            break;
            case 2:
            {
                WY_QRPersonalListViewController *tempController = [WY_QRPersonalListViewController new];
                tempController.title = @"历史记录";
                tempController.nsType = @"2";
                [self.navigationController pushViewController:tempController animated:YES];

            }
                break;
                
        default:
            break;
    }
  
}



@end
