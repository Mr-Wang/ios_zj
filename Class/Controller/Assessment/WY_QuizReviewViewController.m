//
//  WY_QuizReviewViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/27.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuizReviewViewController.h"
#import "WY_QuestionReviewModel.h"
#import "WY_QuizReviewItemView.h"
#import "WY_QuizViewController.h"
#import "EmptyView.h"

@interface WY_QuizReviewViewController () {
    UILabel *lblScore;
    UILabel *lblStartTime;
    UILabel *lblExamTime;
    UIScrollView *mScrollView;
}
@property (nonatomic , strong) WY_QuestionReviewModel *mWY_QuestionReviewModel;
@property (nonatomic,strong) EmptyView *emptyView;
@end

@implementation WY_QuizReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self dataSourceBind];
}
- (void)makeUI {
    self.title = @"试题回顾";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    lblScore = [UILabel new];
    lblStartTime = [UILabel new];
    lblExamTime = [UILabel new];
    mScrollView = [UIScrollView new];
    [self.view addSubview:lblScore];
    [self.view addSubview:lblStartTime];
    [self.view addSubview:lblExamTime];
    [self.view addSubview:mScrollView];
    
    [lblScore setFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(300), k360Width(30))];
    [lblScore setFont:WY_FONTMedium(24)];
    
    [lblStartTime setFrame:CGRectMake(k360Width(16), lblScore.bottom + k360Width(5), k360Width(250), k360Width(22))];
    [lblStartTime setFont:WY_FONTRegular(14)];
    
    [lblExamTime setFrame:CGRectMake(kScreenWidth - k360Width(166), lblScore.bottom + k360Width(5), k360Width(150), k360Width(22))];
    [lblExamTime setTextAlignment:NSTextAlignmentRight];
    [lblExamTime setFont:WY_FONTRegular(14)];
    
    [mScrollView setFrame:CGRectMake(0, lblStartTime.bottom + k360Width(10), kScreenWidth, kScreenHeight - JCNew64 - lblStartTime.bottom - k360Width(10)  - JC_TabbarSafeBottomMargin)];
    
    
    self.emptyView = [[EmptyView alloc]initWithFrame:self.view.bounds];
    self.emptyView.hidden = YES;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    
    [self.emptyView.contentLabel setText:@"暂无数据"];
    [self.view addSubview:self.emptyView];
    
}

- (void)dataSourceBind {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.nsType forKey:@"type"];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getEaxmMX_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 1 && res) {
            self.mWY_QuestionReviewModel = [WY_QuestionReviewModel modelWithJSON:res[@"data"]];
            if (self.mWY_QuestionReviewModel == nil) {
                [self.emptyView.contentLabel setText:@"暂无数据"];
                [self.emptyView setHidden:NO];
            } else {
                [self.emptyView setHidden:YES];
                [self bindView];
            }
        } else {
            [self.emptyView.contentLabel setText:res[@"msg"]];
            self.emptyView.hidden = NO;
            
        }
    } failure:^(NSError *error) {
        [self.emptyView.contentLabel setText:@"网络不给力"];
        self.emptyView.hidden = NO;
        
    }];
    
}

- (void)bindView {
    lblScore.text = [NSString stringWithFormat:@"%.1f分",[self.mWY_QuestionReviewModel.score floatValue]];
    if (self.mWY_QuestionReviewModel.createtime.length > 10) {
        lblStartTime.text = [NSString stringWithFormat:@"开始时间：%@",[self.mWY_QuestionReviewModel.createtime  substringToIndex:10]];
    } else {
        lblStartTime.text = [NSString stringWithFormat:@"开始时间：%@",self.mWY_QuestionReviewModel.createtime] ;
    }
    lblExamTime.text = [NSString stringWithFormat:@"考试用时：%@",self.mWY_QuestionReviewModel.examTime];
    
    int lastY = 0;
    for (WY_QuestionTypeModel *tempModel in  self.mWY_QuestionReviewModel.examQuestionBeanList) {
        WY_QuizReviewItemView *tempView = [[WY_QuizReviewItemView alloc] initWithFrame:CGRectMake(k360Width(16), lastY, kScreenWidth - k360Width(32), k360Width(44))];
        [tempView showCellByItem:tempModel];
        WS(weakSelf)
        [tempView.colTitle addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            UIControl *colSender = (UIControl *)sender;
            colSender.selected = !colSender.selected;
            [weakSelf sortQRItemView];
        }];
        
        tempView.selTopicModelBlock = ^(WY_QuestionModel * _Nonnull withModel) {
            NSLog(@"点击了：item");
            WY_QuizViewController *tempController = [WY_QuizViewController new];
            tempController.mQmIdenxModel = withModel;
            tempController.isReview = YES;
            tempController.nsType = self.nsType;
            [weakSelf.navigationController pushViewController:tempController animated:YES];
        };
        [mScrollView addSubview:tempView];
        lastY = tempView.bottom + k360Width(16);
    }
    [mScrollView setContentSize:CGSizeMake(kScreenWidth, lastY)];
}

- (void)sortQRItemView{
    int lastY = 0;
    for (WY_QuizReviewItemView *tempView in mScrollView.subviews) {
        if ([tempView isKindOfClass:[WY_QuizReviewItemView class]]) {
            tempView.top = lastY;
            if (tempView.colTitle.selected) {
                [tempView.viewContent setHidden:YES];
                tempView.height = k360Width(44);
                [tempView.imgAcc setImage:[UIImage imageNamed:@"accup"]];
            } else {
                [tempView.viewContent setHidden:NO];
                tempView.height = tempView.viewContent.bottom;
                [tempView.imgAcc setImage:[UIImage imageNamed:@"accdown"]];
            }
            lastY = tempView.bottom + k360Width(16);
        }
    }
    [mScrollView setContentSize:CGSizeMake(kScreenWidth, lastY)];
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
