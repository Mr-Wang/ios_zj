//
//  WY_AgentToMeEvaViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/12/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AgentToMeEvaViewController.h"
#import "LEEStarRating.h"
#import "WY_selPicView.h"
#import "WY_ProfessionModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageNewsDetailViewController.h"
#import "WY_EvaluateModel.h"
#import "WY_AddAppealViewController.h"

@interface WY_AgentToMeEvaViewController ()
{
    int lastY;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) NSArray *arrDataSource;
@property (nonatomic, strong) NSDictionary *dicQualityEvaluation;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic, strong) LEEStarRating *starRating1;
@property (nonatomic, strong) LEEStarRating *starRating2;
@property (nonatomic, strong) LEEStarRating *starRating3;
@property (nonatomic, strong) LEEStarRating *starRating4;
@property (nonatomic, strong) LEEStarRating *starRating5;

@end

@implementation WY_AgentToMeEvaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self dataSource];
}

- (void) makeUI {
    self.title =@"代理对我的评价";
 
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) -  JC_TabbarSafeBottomMargin)];
     [self.view addSubview:self.mScrollView];
     
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    
    if ([self.mWY_ExpertModel.isReconsider isEqualToString:@"0"]) {
        [self.btnSubmit setTitle:@"申  诉" forState:UIControlStateNormal];

    } else if ([self.mWY_ExpertModel.isReconsider isEqualToString:@"1"]|| [self.mWY_ExpertModel.isReconsider isEqualToString:@"2"]) {
        [self.btnSubmit setTitle:@"查看申诉" forState:UIControlStateNormal];
    }
    
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(16)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    [self.btnSubmit setHidden:YES];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0,0,kScreenWidth,k360Width(40));
    label.numberOfLines = 0;
    [label setBackgroundColor:HEXCOLOR(0xECF3FD)];
    [self.view addSubview:label];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"温馨提示 : 如您对评价扣分有疑异, 可以发起申诉进行处理" attributes:@{NSFontAttributeName: WY_FONTRegular(14),NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];

    label.attributedText = string;
    
    self.lblName = [UILabel new];
     [self.mScrollView addSubview:self.lblName];

    self.starRating1 =  [[LEEStarRating alloc] initWithFrame:CGRectMake(k360Width(188), 0, kScreenWidth - k360Width(188 + 16), k360Width(44)) Count:5];
    self.starRating2 =  [[LEEStarRating alloc] initWithFrame:CGRectMake(k360Width(188), 0, kScreenWidth - k360Width(188 + 16), k360Width(44)) Count:5];
    self.starRating3 =  [[LEEStarRating alloc] initWithFrame:CGRectMake(k360Width(188), 0, kScreenWidth - k360Width(188 + 16), k360Width(44)) Count:5];
    self.starRating4 =  [[LEEStarRating alloc] initWithFrame:CGRectMake(k360Width(188), 0, kScreenWidth - k360Width(188 + 16), k360Width(44)) Count:5];
    self.starRating5 =  [[LEEStarRating alloc] initWithFrame:CGRectMake(k360Width(188), 0, kScreenWidth - k360Width(188 + 16), k360Width(44)) Count:5];

}

- (void)btnSubmitAction{
    //点击了申诉按钮；
    if ([self.mWY_ExpertModel.isReconsider isEqualToString:@"0"]) {
        NSLog(@"新增申诉");
        WY_ExpertModel *tempModel = self.mWY_ExpertModel;
        WY_AddAppealViewController *tempController = [WY_AddAppealViewController new];
         tempController.mWY_ExpertModel = tempModel;
        [self.navigationController pushViewController:tempController animated:YES];

    } else if ([self.mWY_ExpertModel.isReconsider isEqualToString:@"1"]|| [self.mWY_ExpertModel.isReconsider isEqualToString:@"2"]) {
        WY_ExpertModel *tempModel = self.mWY_ExpertModel;
        WY_AddAppealViewController *tempController = [WY_AddAppealViewController new];
        tempController.nsType = @"1";
        tempController.mWY_ExpertModel = tempModel;
        [self.navigationController pushViewController:tempController animated:YES];
        NSLog(@"查看申诉");
    }
}

- (void)dataSource {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mWY_ExpertModel.id forKey:@"id"];
    [postDic setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
 
    [[MS_BasicDataController sharedInstance] postWithURL:zj_getExpertEvaluate_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        
        self.dicQualityEvaluation = successCallBack[@"qualityEvaluation"];
        if (((NSArray *)successCallBack).count > 0) {
            self.arrDataSource = [NSArray yy_modelArrayWithClass:[WY_ExpertModel class] json:successCallBack[@"evaluateList"]]; 
        } else {
            self.arrDataSource = [NSArray array];
         }
        [self dataBind];
     } failure:^(NSString *failureCallBack) {
         [SVProgressHUD showErrorWithStatus:failureCallBack];
     } ErrorInfo:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
     }];
}
- (void)dataBind {
    [self.lblName setFrame:CGRectMake(k360Width(16), k360Width(50), kScreenWidth - k360Width(32), k360Width(44))];
    
    [self.lblName setText:self.mWY_ExpertModel.name];
    [self.lblName setFont:WY_FONTMedium(16)];
    [self.lblName setNumberOfLines:0];
    [self.lblName sizeToFit];
    
    if (self.lblName.height < k360Width(30)) {
        self.lblName.height = k360Width(30);
    }
    lastY = self.lblName.bottom;
//    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:self.mWY_ExpertModel.name isAcc:NO withBlcok:nil];
//    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:@"项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称" isAcc:NO withBlcok:nil];

    [self  byReturnColCellTitle:@"代理机构：" byLabelStr:self.mWY_ExpertModel.daili isAcc:NO withBlcok:nil];
    
    if (self.mWY_ExpertModel.time.length > 16) {
        [self  byReturnColCellTitle:@"集合时间：" byLabelStr:[self.mWY_ExpertModel.time substringToIndex:16] isAcc:NO withBlcok:nil];
    } else {
        [self  byReturnColCellTitle:@"集合时间：" byLabelStr:self.mWY_ExpertModel.time isAcc:NO withBlcok:nil];
    }
    [self  byReturnColCellTitle:@"集合地点：" byLabelStr:self.mWY_ExpertModel.place isAcc:NO withBlcok:nil];
 
    lastY += k360Width(16);
    
//    self.arrDataSource
    int sumCount = 0;
    for (WY_ExpertModel *tempModel in self.arrDataSource) {
        sumCount+= [tempModel.evaluateMark intValue];
    }
    [self bydeductPointsReturnColCellTitle:@"专家综合评价" byLabelStr:@"" isSum:YES];
 
    [self byReturnColCellTitle:@"职业操守" byStar:self.starRating1 isAcc:NO withBlcok:nil];
   
     [self byReturnColCellTitle:@"评标态度" byStar:self.starRating2 isAcc:NO withBlcok:nil];
    
     [self byReturnColCellTitle:@"评标遵循招标文件要求" byStar:self.starRating3 isAcc:NO withBlcok:nil];

     [self byReturnColCellTitle:@"评标专业水平" byStar:self.starRating4 isAcc:NO withBlcok:nil];
 
    [self byReturnColCellTitle:@"电子辅助评标系统操作熟练度" byStar:self.starRating5 isAcc:NO withBlcok:nil];
    
    self.starRating1.currentScore =  [self.dicQualityEvaluation[@"zydd"] intValue];
    self.starRating2.currentScore = [self.dicQualityEvaluation[@"pbtd"] intValue];
    self.starRating3.currentScore = [self.dicQualityEvaluation[@"zxyq"] intValue];
    self.starRating4.currentScore = [self.dicQualityEvaluation[@"zysp"] intValue];
    self.starRating5.currentScore = [self.dicQualityEvaluation[@"dzfz"] intValue];
    [self.starRating1 setUserInteractionEnabled:NO];
    [self.starRating2 setUserInteractionEnabled:NO];
    [self.starRating3 setUserInteractionEnabled:NO];
    [self.starRating4 setUserInteractionEnabled:NO];
    [self.starRating5 setUserInteractionEnabled:NO];
    
    
    NSString *ispbtt = @"否";
    if ([self.dicQualityEvaluation[@"pbtt"] intValue] == 1) {
        ispbtt = @"是";
    }
    [self byReturnColRightCellTitle:@"评标过程是否拖沓，影响评标效率" byLabelStr:ispbtt isAcc:NO withBlcok:nil];
    
    NSString *issfgd = @"否";
    if ([self.dicQualityEvaluation[@"sfgd"] intValue] == 1) {
        issfgd = @"是";
    }
    [self byReturnColRightCellTitle:@"是否有鼓动其他评标专家影响正常评标" byLabelStr:issfgd isAcc:NO withBlcok:nil];

    
    NSString *ispbqxx = @"否";
    if ([self.dicQualityEvaluation[@"pbqxx"] intValue] == 1) {
        ispbqxx = @"是";
    }
    [self byReturnColRightCellTitle:@"评标打分是否具有倾向性" byLabelStr:ispbqxx isAcc:NO withBlcok:nil];
    if ([self.dicQualityEvaluation[@"pbqxx"] intValue] == 1) {
//        [self byReturnColRightCellTitle:self.dicQualityEvaluation[@"pbqxxText"] byLabelStr:@"" isAcc:NO withBlcok:nil];
        if (![self.dicQualityEvaluation[@"pbqxxText"] isEqual:[NSNull null]]) {
            [self  byReturnColCellTitle:@"评标倾向内容：" byLabelStr:self.dicQualityEvaluation[@"pbqxxText"] isAcc:NO withBlcok:nil];
        } else {
            [self  byReturnColCellTitle:@"评标倾向内容：" byLabelStr:@"" isAcc:NO withBlcok:nil];
        }
        
        
    }
    
    lastY += k360Width(10);
    
    if (self.arrDataSource.count > 0) {
        [self.btnSubmit setHidden:NO];
        [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) -  JC_TabbarSafeBottomMargin)];
        [self bydeductPointsReturnColCellTitle:@"专家行为评价" byLabelStr:[NSString stringWithFormat:@"-%d分",sumCount] isSum:YES];
         
        for (WY_ExpertModel *tempModel in self.arrDataSource) {
            [self bydeductPointsReturnColCellTitle:tempModel.evaluateContent    byLabelStr:[NSString stringWithFormat:@"-%@分",tempModel.evaluateMark] isSum:NO];
        }

        
    } else {
        [self.btnSubmit setHidden:YES];
        [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 -   JC_TabbarSafeBottomMargin)];

    }
    
     
     [self.mScrollView setContentSize:CGSizeMake(0, lastY + k360Width(16))];
}
 
- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:HEXCOLOR(0x666666)];
    [lblTitle setFont:WY_FONTRegular(14)];
    [viewTemp addSubview:lblTitle];
    [lblTitle sizeToFit];
    if (lblTitle.height < k360Width(22)) {
        lblTitle.height = k360Width(22);
    }
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
    
    UILabel *withLabel = [UILabel new];

    [withLabel setFrame:CGRectMake(lblTitle.right, 0, viewTemp.width - lblTitle.right - k360Width(16), k360Width(22))];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextColor:HEXCOLOR(0x666666)];
    [withLabel setFont:WY_FONTRegular(14)];
    withLabel.text = withLabelStr;
    [withLabel sizeToFit];
     if (withLabel.height < k360Width(22)) {
        withLabel.height = k360Width(22);
    }
    
    viewTemp.height = withLabel.bottom;
    [viewTemp addSubview:withLabel];
    
     if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    lastY = viewTemp.bottom;
     return viewTemp;
}

- (UIControl *)byReturnColRightCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    [lblTitle sizeToFit];
    if (lblTitle.height < k360Width(22)) {
        lblTitle.height = k360Width(22);
    }
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
    
    UILabel *withLabel = [UILabel new];

    [withLabel setFrame:CGRectMake(0, 0, kScreenWidth - k360Width(32), k360Width(22))];
    [withLabel setTextAlignment:NSTextAlignmentRight];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setFont:WY_FONTMedium(14)];

    withLabel.text = withLabelStr;
//    [withLabel sizeToFit];
     if (withLabel.height < k360Width(22)) {
        withLabel.height = k360Width(22);
    }
    withLabel.height += k360Width(5);
    viewTemp.height = withLabel.bottom;
    [viewTemp addSubview:withLabel];
    
     if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    lastY = viewTemp.bottom;
     return viewTemp;
}


- (UIControl *)bydeductPointsReturnColCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isSum:(BOOL)isSum {
    
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(60+32), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setNumberOfLines:0];
    [lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [lblTitle setTextColor:[UIColor blackColor]];
//     if (isSum) {
//        [lblTitle setFont:WY_FONTMedium(18)];
//    } else {
        [lblTitle setFont:WY_FONTMedium(16)];
//    }
    [viewTemp addSubview:lblTitle];
    [lblTitle sizeToFit];
    if (lblTitle.height < k360Width(22)) {
        lblTitle.height = k360Width(22);
    }
    
     lblTitle.height += k360Width(22);
    
    
 
    UILabel *withLabel = [UILabel new];
    [withLabel setFrame:CGRectMake(kScreenWidth - k360Width(90 + 16), 0, k360Width(90), k360Width(22))];
    [withLabel setTextColor:HEXCOLOR(0xFDAD23)];
    [withLabel setTextAlignment:NSTextAlignmentRight];
    [withLabel setFont:WY_FONTMedium(16)];
    withLabel.text = withLabelStr;
    
    withLabel.top = (lblTitle.bottom - k360Width(22)) / 2;
    
    if (isSum) {
        [viewTemp setBackgroundColor:HEXCOLOR(0xF0F0F0)];
    } else {
        [viewTemp setBackgroundColor:HEXCOLOR(0xFFFFFF)];
    }
    viewTemp.height = lblTitle.bottom;
    [viewTemp addSubview:withLabel];
    
    UILabel *imgLine = [UILabel new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, lblTitle.bottom - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    
    
    lastY = viewTemp.bottom;
     return viewTemp;
}

- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byStar:(LEEStarRating *)withStar isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, viewTemp.width - k360Width(32), k360Width(44))];
    lblTitle.text = titleStr;
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(50 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
//    withStar = [[LEEStarRating alloc] initWithFrame:CGRectMake(k360Width(188), 0, viewTemp.width - k360Width(188 + 16), k360Width(44)) Count:5];
    [withStar setFrame:CGRectMake(k360Width(188), 0, viewTemp.width - k360Width(188 + 16), k360Width(44))];
    withStar.spacing = 10;
//    [withStar setFrame:CGRectMake(k360Width(201), 0, viewTemp.width - k360Width(201 + 16), k360Width(22))];
    withStar.checkedImage = [UIImage imageNamed:@"1211_starA"];
    withStar.uncheckedImage = [UIImage imageNamed:@"1211_starB"];
    withStar.touchEnabled = YES;
    [withStar setSlideEnabled:YES];
//    viewTemp.height = withStar.bottom;
    [viewTemp addSubview:withStar];
    withStar.top = (viewTemp.height -withStar.height) / 2;

     if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    lastY = viewTemp.bottom;
     return viewTemp;
}



@end

