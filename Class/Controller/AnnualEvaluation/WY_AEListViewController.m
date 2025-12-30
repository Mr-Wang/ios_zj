//
//  WY_AEListViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2023/1/11.
//  Copyright © 2023 王杨. All rights reserved.
//

#import "WY_AEListViewController.h"
#import "WY_BonusPointsListViewController.h"
#import "WY_OtherPointsDeductedListViewController.h"
#import "WY_IllegalListViewController.h"
#import "WY_AddBonusPointsViewController.h"
#import "WY_OverallParticipationViewController.h"
#import "WY_LearningTrackMainViewController.h"
#import "WY_HistoryProjMainViewController.h"

@interface WY_AEListViewController ()
{
    int SV_LastY;
}
@property (nonatomic, strong) UILabel *lblCount;    //年度评价总分
@property (nonatomic, strong) UILabel *lblJG;   //考评结果
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) NSMutableDictionary *dicSource;

@end

@implementation WY_AEListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self dataSource];
    
}
- (void)makeUI {
    self.title = @"年度评价";
    self.viewTop = [UIView new];
    [self.viewTop setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(100))];
    [self.view addSubview:self.viewTop];

    self.mScrollView = [UIScrollView new];
//    [self.mScrollView setFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) -  self.viewTop.bottom)];
    //tab隐藏  少- 50
    [self.mScrollView setFrame:CGRectMake(0, self.viewTop.bottom, kScreenWidth, kScreenHeight - JCNew64  -  self.viewTop.bottom)];

    [self.view addSubview:self.mScrollView];
    
}
- (void)dataSource {
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_evaluate_HTTP params:nil jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            self.dicSource = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
            [self bindView];
        } else {
         
        } 
    } failure:^(NSError *error) {
    }];

}
- (void)bindView {
    [self initTopView];
    [self initMiddleView];
}

- (void)initTopView {
    self.lblCount = [UILabel new];
    self.lblJG = [UILabel new];
    [self.view addSubview:self.lblCount];
    [self.view addSubview:self.lblJG];
    [self.lblCount setFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), k360Width(50))];
    [self.lblJG setFrame:CGRectMake(k360Width(16), k360Width(50), kScreenWidth - k360Width(32), k360Width(50))];
    NSMutableAttributedString *attS1 = [[NSMutableAttributedString alloc] initWithString:@"年度评价总分："];
    NSMutableAttributedString *attS2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f分",[self.dicSource[@"totalScore"] floatValue]]];
    NSMutableAttributedString *attK1 = [[NSMutableAttributedString alloc] initWithString:@"年度考评结果："];
    NSMutableAttributedString *attK2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.dicSource[@"result"]]];
    
    
    [attS1 setYy_font:WY_FONTMedium(14)];
    [attS2 setYy_font:WY_FONTMedium(24)];
    
    [attK1 setYy_font:WY_FONTMedium(14)];
    [attK2 setYy_font:WY_FONTMedium(24)];
    //优秀 良好 合格  不合格；
    [attK2 setYy_color:MSHexColor(self.dicSource[@"color"])];
//    int status = 0;
//    switch (status) {
//        case 0:
//        {
//            [attK2 setYy_color:HEXCOLOR(0x8500FE)];
//        }
//            break;
//        case 1:
//        {
//            [attK2 setYy_color:HEXCOLOR(0x5147FF)];
//        }
//            break;
//        case 2:
//        {
//            [attK2 setYy_color:HEXCOLOR(0x005B00)];
//        }
//            break;
//        case 3:
//        {
//            [attK2 setYy_color:HEXCOLOR(0xFC0006)];
//        }
//            break;
//        default:
//            break;
//    }
    
    [attS1 appendAttributedString:attS2];
    [attK1 appendAttributedString:attK2];
    
    [self.lblCount setAttributedText:attS1];
    [self.lblJG setAttributedText:attK1];
}

- (void)initMiddleView {
    
    if (![self.dicSource[@"examScore"][@"haveTrained"] boolValue]) {
        [self.viewTop setHidden:YES];
        [self.lblCount setHidden:YES];
        [self.lblJG setHidden:YES];
        //tab隐藏 少-50
        [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64)];
//        [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50))];
    }
    /*{
     "code": 0,
     "msg": "操作成功！",
     "data": {
         "participation": {
             "refuse": 0,
             "refuseDeductPoints": 0.0,
             "unansweredDeductPoints": 0.0,
             "unanswered": 0,
             "participationScore": 10.0
         },
         "otherScore": {
             "otherScore": 0,
             "otherScoreSize": 0
         },
         "result": "合格",
         "projectEvaluation": {
             "evaluationCount": 0,
             "evaluationScore": 50,
             "evaluationDeductPoints": 0
         },
         "color": "#0000ff",
         "studyScore": {
             "studyScore": 0.20,
             "points": 2
         },
         "examScore": {
             "examScore": 0,
             "points": 0
         },
         "rewardScore": {
             "rewardScore": 0
         },
         "totalScore": 60.20,
         "illegalMatters": {
             "illegalMatters": 0
         }
     }
 }*/
    
    NSMutableDictionary *dicModel1 = [NSMutableDictionary new];
    [dicModel1 setObject:[NSString stringWithFormat:@"总体参评得分:%.1f分",[self.dicSource[@"participation"][@"participationScore"] floatValue]] forKey:@"titleA"];
    [dicModel1 setObject:@"年度语音电话未接听数" forKey:@"titleB1"];
    [dicModel1 setObject:@"转换扣分" forKey:@"titleB2"];
    [dicModel1 setObject:@"年度主动拒绝参评数" forKey:@"titleC1"];
    [dicModel1 setObject:@"转换扣分" forKey:@"titleC2"];
    
    NSString *valueB1Str = [NSString stringWithFormat:@"%@次",self.dicSource[@"participation"][@"unanswered"]];
    NSString *valueB2Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"participation"][@"unansweredDeductPoints"] floatValue]];
    NSString *valueC1Str = [NSString stringWithFormat:@"%@次",self.dicSource[@"participation"][@"refuse"]];
    NSString *valueC2Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"participation"][@"refuseDeductPoints"] floatValue]];
    
    [dicModel1 setObject:valueB1Str forKey:@"valueB1"];
    [dicModel1 setObject:valueB2Str forKey:@"valueB2"];
    [dicModel1 setObject:valueC1Str forKey:@"valueC1"];
    [dicModel1 setObject:valueC2Str forKey:@"valueC2"];
    
    //type = 1得分、2扣分、3违法
    [dicModel1 setObject:@"2" forKey:@"type"];
    //是否两行 - 0  一行， 1 两行
    [dicModel1 setObject:@"1" forKey:@"isTwoLines"];
    //是否有按钮
    [dicModel1 setObject:@"0" forKey:@"isButton"];
    
    
    [self initDFItemByItemModel:dicModel1 withBtnBlock:nil withBlock:^{
            NSLog(@"点击了行");
        WY_OverallParticipationViewController *tempController = [WY_OverallParticipationViewController new];
        tempController.bonusPoints = self.dicSource[@"participation"][@"participationScore"];
        tempController.unansweredDeductPoints = self.dicSource[@"participation"][@"unansweredDeductPoints"];//年度语音电话未接听数
        tempController.refuseDeductPoints = self.dicSource[@"participation"][@"refuseDeductPoints"];//年度主动拒绝参评数
        [self.navigationController pushViewController:tempController animated:YES];
        }];
    //2-项目评价得分
    [dicModel1 setObject:[NSString stringWithFormat:@"项目评价得分:%.1f分",[self.dicSource[@"projectEvaluation"][@"evaluationScore"] floatValue]] forKey:@"titleA"];
    [dicModel1 setObject:@"被评项目总数" forKey:@"titleB1"];
    [dicModel1 setObject:@"转换扣分" forKey:@"titleB2"];
    //type = 1得分、2扣分、3违法
    [dicModel1 setObject:@"2" forKey:@"type"];
    valueB1Str = [NSString stringWithFormat:@"%@次",self.dicSource[@"projectEvaluation"][@"evaluationCount"]];
    valueB2Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"projectEvaluation"][@"evaluationDeductPoints"] floatValue]];
    [dicModel1 setObject:valueB1Str forKey:@"valueB1"];
    [dicModel1 setObject:valueB2Str forKey:@"valueB2"];
    [dicModel1 setObject:@"0" forKey:@"isTwoLines"];
    [dicModel1 setObject:@"0" forKey:@"isButton"];
    
//    SV_LastY += k360Width(5);
    
    [self initDFItemByItemModel:dicModel1 withBtnBlock:^{
        NSLog(@"点击了按钮");
        } withBlock:^{
            NSLog(@"点击了行");
            WY_HistoryProjMainViewController *tempController = [WY_HistoryProjMainViewController new];
            tempController.title = @"项目评价";
            [self.navigationController pushViewController:tempController animated:YES];

        }];
    
    //3 ---自主学习得分
    [dicModel1 setObject:[NSString stringWithFormat:@"自主学习得分:%.1f分",[self.dicSource[@"studyScore"][@"studyScore"] floatValue]] forKey:@"titleA"];
    [dicModel1 setObject:@"年度自主学习得分" forKey:@"titleB1"];
    [dicModel1 setObject:@"转换得分" forKey:@"titleB2"];
    //type = 1得分、2扣分、3违法
    [dicModel1 setObject:@"1" forKey:@"type"];
    valueB1Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"studyScore"][@"points"] floatValue]];
    valueB2Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"studyScore"][@"studyScore"] floatValue]];
    [dicModel1 setObject:valueB1Str forKey:@"valueB1"];
    [dicModel1 setObject:valueB2Str forKey:@"valueB2"];
    [dicModel1 setObject:@"0" forKey:@"isTwoLines"];
    [dicModel1 setObject:@"0" forKey:@"isButton"];
    
//    SV_LastY += k360Width(5);
    
    [self initDFItemByItemModel:dicModel1 withBtnBlock:^{
        NSLog(@"点击了按钮");
        } withBlock:^{
            NSLog(@"点击了行");
            WY_LearningTrackMainViewController *tempController = [WY_LearningTrackMainViewController new];
            [self.navigationController pushViewController:tempController animated:YES];

        }];
    //4 ---培训考核得分
    [dicModel1 setObject:[NSString stringWithFormat:@"培训考核得分:%.1f分",[self.dicSource[@"examScore"][@"examScore"] floatValue]] forKey:@"titleA"];
    [dicModel1 setObject:@"年度考试得分" forKey:@"titleB1"];
    [dicModel1 setObject:@"转换得分" forKey:@"titleB2"];
    //type = 1得分、2扣分、3违法
    [dicModel1 setObject:@"1" forKey:@"type"];
    valueB1Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"examScore"][@"points"] floatValue]];
    valueB2Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"examScore"][@"examScore"] floatValue]];
    [dicModel1 setObject:valueB1Str forKey:@"valueB1"];
    [dicModel1 setObject:valueB2Str forKey:@"valueB2"];
    [dicModel1 setObject:@"0" forKey:@"isTwoLines"];
    [dicModel1 setObject:@"0" forKey:@"isButton"];
    
    if ([self.dicSource[@"examScore"][@"haveTrained"] boolValue]) {
        
//        SV_LastY += k360Width(5);
        
        [self initDFItemByItemModel:dicModel1 withBtnBlock:^{
            NSLog(@"点击了按钮");
            } withBlock:^{
                NSLog(@"点击了行");
            }];
        
    }
    
    //5 ---奖励加分
    [dicModel1 setObject:[NSString stringWithFormat:@"奖  励  加  分:%.1f分",[self.dicSource[@"rewardScore"][@"rewardScore"] floatValue]] forKey:@"titleA"];
    [dicModel1 setObject:@"申请奖励加分事项" forKey:@"titleB1"];
    [dicModel1 setObject:@"转换得分" forKey:@"titleB2"];
    //type = 1得分、2扣分、3违法
    [dicModel1 setObject:@"1" forKey:@"type"];
    valueB1Str = [NSString stringWithFormat:@"%@个",self.dicSource[@"rewardScore"][@"rewardSize"]];
    valueB2Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"rewardScore"][@"rewardScore"] floatValue]];
    [dicModel1 setObject:valueB1Str forKey:@"valueB1"];
    [dicModel1 setObject:valueB2Str forKey:@"valueB2"];
    [dicModel1 setObject:@"0" forKey:@"isTwoLines"];
    [dicModel1 setObject:@"0" forKey:@"isButton"];
    //按钮
    [dicModel1 setObject:@"申请奖励加分" forKey:@"buttonStr"];
    [dicModel1 setObject:@"1" forKey:@"isButton"];
    
//    SV_LastY += k360Width(5);
    
    [self initDFItemByItemModel:dicModel1 withBtnBlock:^{
        NSLog(@"点击了按钮");
        //奖励加分
        WY_AddBonusPointsViewController *tempController = [WY_AddBonusPointsViewController new];
         [self.navigationController pushViewController:tempController animated:YES];
        } withBlock:^{
            NSLog(@"点击了行");
            WY_BonusPointsListViewController *tempController = [WY_BonusPointsListViewController new];
            tempController.bonusPoints = self.dicSource[@"rewardScore"][@"rewardScore"];
            [self.navigationController pushViewController:tempController animated:YES];

        }];
    //6 ---其他（基本信息）扣分：
    [dicModel1 setObject:[NSString stringWithFormat:@"其  他  扣  分:%.1f分",[self.dicSource[@"otherScore"][@"otherScore"] floatValue]] forKey:@"titleA"];
    [dicModel1 setObject:@"其他扣分事项" forKey:@"titleB1"];
    [dicModel1 setObject:@"转换扣分" forKey:@"titleB2"];
    //type = 1得分、2扣分、3违法
    [dicModel1 setObject:@"2" forKey:@"type"];
    valueB1Str = [NSString stringWithFormat:@"%@个",self.dicSource[@"otherScore"][@"otherScoreSize"]];
    valueB2Str = [NSString stringWithFormat:@"%.1f分",[self.dicSource[@"otherScore"][@"otherScore"] floatValue]];
    [dicModel1 setObject:valueB1Str forKey:@"valueB1"];
    [dicModel1 setObject:valueB2Str forKey:@"valueB2"];
    [dicModel1 setObject:@"0" forKey:@"isTwoLines"];
    [dicModel1 setObject:@"0" forKey:@"isButton"];
    
//    SV_LastY += k360Width(5);
    
    [self initDFItemByItemModel:dicModel1 withBtnBlock:^{
        NSLog(@"点击了按钮");
        } withBlock:^{
            NSLog(@"点击了行");
            WY_OtherPointsDeductedListViewController *tempController = [WY_OtherPointsDeductedListViewController new];
            tempController.bonusPoints = self.dicSource[@"otherScore"][@"otherScore"];
            [self.navigationController pushViewController:tempController animated:YES];
        }];
    
    //7 ---专家违法行为
    [dicModel1 setObject:@"专家违法行为:" forKey:@"titleA"];
    [dicModel1 setObject:@"专家违法事项" forKey:@"titleB1"];
    if ([self.dicSource[@"illegalMatters"][@"illegalMatters"] intValue] > 0) {
        [dicModel1 setObject:@"" forKey:@"titleB2"];
        [dicModel1 setObject:@"清退专家库" forKey:@"valueB2"];
    } else {
        [dicModel1 setObject:@"" forKey:@"titleB2"];
        [dicModel1 setObject:@"" forKey:@"valueB2"];
    }
    //type = 1得分、2扣分、3违法
    [dicModel1 setObject:@"3" forKey:@"type"];
    valueB1Str = [NSString stringWithFormat:@"%@个",self.dicSource[@"illegalMatters"][@"illegalMatters"]];
     [dicModel1 setObject:valueB1Str forKey:@"valueB1"];
    
    [dicModel1 setObject:@"0" forKey:@"isTwoLines"];
    [dicModel1 setObject:@"0" forKey:@"isButton"];
    
//    SV_LastY += k360Width(5);
    
    [self initDFItemByItemModel:dicModel1 withBtnBlock:^{
        NSLog(@"点击了按钮");
        } withBlock:^{
            NSLog(@"点击了行");
            
            WY_IllegalListViewController *tempController = [WY_IllegalListViewController new];
            [self.navigationController pushViewController:tempController animated:YES];

        }];
//    SV_LastY += k360Width(5);
    [self.mScrollView setContentSize: CGSizeMake(kScreenWidth, SV_LastY)];
}

/// 加载列表View
/// @param itemModel 列表内容实体
/// @param withBtnBlock 按钮block
/// @param withBlock 列表Block
- (void)initDFItemByItemModel:(NSMutableDictionary *)itemModel withBtnBlock:(void (^)(void))withBtnBlock withBlock:(void (^)(void))withBlock {
    UIView *viewCell = [UIView new];
    [self.mScrollView addSubview:viewCell];
    [viewCell setFrame:CGRectMake(0, SV_LastY, kScreenWidth, k360Width(40))];
    
    UILabel *lblTitleA = [UILabel new];
    UIControl *colView = [UIControl new];
    [viewCell addSubview:lblTitleA];
    [viewCell addSubview:colView];
    [colView addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (withBlock) {
            withBlock();
        }
    }];
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [viewCell addSubview:viewBlue1];
    
    
    [lblTitleA setFrame:CGRectMake(viewBlue1.right + 8, 0, viewCell.width - k360Width(32), k360Width(44))];
    [lblTitleA setFont:WY_FONTMedium(14)];
    [lblTitleA setText:itemModel[@"titleA"]];
    if ([itemModel[@"isButton"] intValue] == 1) {
        UIButton *btnGT = [[UIButton alloc] initWithFrame:CGRectMake(viewCell.width - k360Width(80 + 16), k360Width(8), k360Width(80), k360Width(28))];
        [btnGT setBackgroundColor:MSTHEMEColor];
        [btnGT.titleLabel setFont:WY_FONTMedium(12)];
        [btnGT rounded:k360Width(28/12)];
        [btnGT setTitle:itemModel[@"buttonStr"] forState:UIControlStateNormal];
        [viewCell addSubview:btnGT];
        [btnGT addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBtnBlock) {
                withBtnBlock();
            }
        }];
        
    }
    [colView setFrame:CGRectMake(k360Width(16), lblTitleA.bottom + k360Width(5), kScreenWidth - k360Width(32), k360Width(44))];
    
    UILabel *lblTitleB1 = [UILabel new];
    UILabel *lblValueB1 = [UILabel new];
    UILabel *lblTitleB2 = [UILabel new];
    
    [lblTitleB1 setFont:WY_FONTMedium(12)];
    [lblValueB1 setFont:WY_FONTMedium(12)];
    [lblTitleB2 setFont:WY_FONTMedium(12)];
    
    [colView addSubview:lblTitleB1];
    [colView addSubview:lblValueB1];
    [colView addSubview:lblTitleB2];
 
    UIImageView *imgAcc;
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(colView.width - k360Width(22 + 5), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [colView addSubview:imgAcc];
 
    
    [lblTitleB1 setFrame:CGRectMake(k360Width(10), 0, k360Width(188), k360Width(32))];
    [lblValueB1 setFrame:CGRectMake(lblTitleB1.right - k360Width(36), 0, k360Width(144), k360Width(32))];
    [lblTitleB2 setFrame:CGRectMake(0, 0, colView.width - k360Width(5 + 22), k360Width(32))];
    [lblTitleB2 setTextAlignment:NSTextAlignmentRight];
    
      
    
    [lblTitleB1 setText: itemModel[@"titleB1"]];
    [lblValueB1 setText: itemModel[@"valueB1"]];
    [lblValueB1 setTextColor:MSTHEMEColor];
    NSMutableAttributedString *attTitleB2 = [[NSMutableAttributedString alloc] initWithString:itemModel[@"titleB2"]];
    NSMutableAttributedString *attTitleB2A = [[NSMutableAttributedString alloc] initWithString:itemModel[@"valueB2"]];
    [attTitleB2 appendAttributedString:attTitleB2A];
    if ([itemModel[@"type"] intValue] == 1) {
            //得分
        [attTitleB2 setYy_color:HEXCOLOR(0x00CC66)];
    } else if ([itemModel[@"type"] intValue] == 2) {
        //扣分
        [attTitleB2 setYy_color:HEXCOLOR(0xc23431)];
    } else if ([itemModel[@"type"] intValue] == 3) {
        //违法
        [attTitleB2 setYy_color:HEXCOLOR(0xc23431)];
        [lblValueB1 setTextColor:HEXCOLOR(0xc23431)];
    }
    [lblTitleB2 setAttributedText:attTitleB2];
     
     
    colView.height = lblTitleB2.bottom;
    
    if ([itemModel[@"isTwoLines"] intValue] == 1) {
        
        UILabel *lblTitleC1 = [UILabel new];
        UILabel *lblValueC1 = [UILabel new];
        UILabel *lblTitleC2 = [UILabel new];
        
        [lblTitleC1 setFont:WY_FONTMedium(12)];
        [lblValueC1 setFont:WY_FONTMedium(12)];
        [lblTitleC2 setFont:WY_FONTMedium(12)];
        
        [colView addSubview:lblTitleC1];
        [colView addSubview:lblValueC1];
        [colView addSubview:lblTitleC2];
        
        [lblTitleC1 setFrame:lblTitleB1.frame];
        [lblValueC1 setFrame:lblValueB1.frame];
        [lblTitleC2 setFrame:lblTitleB2.frame];
         
        [lblTitleC2 setTextAlignment:NSTextAlignmentRight];
        
        lblTitleC1.top = lblTitleB1.bottom;
        lblValueC1.top = lblTitleB1.bottom;
        lblTitleC2.top = lblTitleB1.bottom;
        
        
        [lblTitleC1 setText: itemModel[@"titleC1"]];
        [lblValueC1 setText: itemModel[@"valueC1"]];
        
        [lblValueC1 setTextColor:MSTHEMEColor];
        NSMutableAttributedString *attTitleC2 = [[NSMutableAttributedString alloc] initWithString:itemModel[@"titleC2"]];
        NSMutableAttributedString *attTitleC2A = [[NSMutableAttributedString alloc] initWithString:itemModel[@"valueC2"]];
        [attTitleC2 appendAttributedString:attTitleC2A];
        if ([itemModel[@"type"] intValue] == 1) {
                //得分
            [attTitleC2 setYy_color:HEXCOLOR(0x00CC66)];
        } else if ([itemModel[@"type"] intValue] == 2) {
            //扣分
            [attTitleC2 setYy_color:HEXCOLOR(0xc23431)];
        } else if ([itemModel[@"type"] intValue] == 3) {
            //违法
            [attTitleC2 setYy_color:HEXCOLOR(0xc23431)];
            [lblValueC1 setTextColor:HEXCOLOR(0xc23431)];
        }
        //
        
        [lblTitleC2 setAttributedText:attTitleC2];
        
        colView.height = lblTitleC2.bottom;
    }
    
//    [colView rounded: colView.height/12 width:1 color:[UIColor blackColor]];
    [colView setBackgroundColor:[UIColor whiteColor]];
   
    [self viewShadowCorner:colView];
    
    viewCell.height = colView.bottom + k360Width(10);
    
    imgAcc.top = (colView.height - imgAcc.height)/2;
    SV_LastY = viewCell.bottom;
    
}

///给View设置阴影和圆角
- (void)viewShadowCorner:(UIView *)viewInfoTemp {
    viewInfoTemp.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
    viewInfoTemp.layer.shadowOffset = CGSizeMake(5, 5);
    viewInfoTemp.layer.shadowOpacity = 1;
    viewInfoTemp.layer.shadowRadius = 9.0;
    viewInfoTemp.layer.cornerRadius = k360Width(44) / 8;
    [viewInfoTemp setBackgroundColor:[UIColor whiteColor]];
    viewInfoTemp.clipsToBounds = NO;
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
