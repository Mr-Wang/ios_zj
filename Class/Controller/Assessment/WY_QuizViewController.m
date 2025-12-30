//
//  WY_QuizViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuizViewController.h"
#import "WY_QuestionOptionView.h"
#import "WY_SelTopicViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "WY_SubmitAlertView.h"
#import "WY_QuizSubmitParamModel.h"
#import "DetectionViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "WY_YNTextField.h"
#import "iflyMSC/IFlyMSC.h"

@interface WY_QuizViewController ()<WY_YNTextFieldDelegate,UITextFieldDelegate>
{
    UILabel *lblTime;   //倒计时
    UIButton *btnUp;    //上一题
    UIButton *btnDown;  //下一题
    UIButton *btnSave;  //交卷
    UIButton *btnQbst;  //花
    UIView *viewBottom;
    UIScrollView *mScrollView;
    
    UIView *viewQuizContent;
    UILabel *lblTypeStr;
    UILabel *lblScore;
    UILabel *lblQuizTitle;
    UIView *tianKongView;
    UIView *viewSelContent;
    IQTextView *txtAnswer;
    //语音识别转换按钮
    UIButton *btnAnswerSR;
    int examNum;
    double limitTimeStamp;
    NSTimer *mNSTimer;
    WY_SubmitAlertView *mWY_SubmitAlertView;
    WY_YNTextField *txtTkt;    //填空题
    int indexTag;
}

@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSMutableArray *arrFace;
@end

@implementation WY_QuizViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    // Do any additional setup after loading the view.
    self.currentSelIndex = 0;
    [self makeUI];
    if (self.isReview) {
        [self initReviewQmView];
    } else {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        if ([self.nsType isEqualToString:@"1"] && [userDef boolForKey:[NSString stringWithFormat:@"isDuringExam+%@",self.mUser.UserGuid]]) {
            self.mWY_QuizModel = [WY_QuizModel modelWithJSON:[userDef objectForKey:[NSString stringWithFormat:@"mWY_QuizModelJson+%@",self.mUser.UserGuid]]];
            
            if(self.mWY_QuizModel.tQuestionList == nil || self.mWY_QuizModel.tQuestionList.count <= 0) {
                self.mWY_QuizModel = nil;
                [userDef removeObjectForKey:[NSString stringWithFormat:@"mWY_QuizModelJson+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"limitTimeStamp+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"isDuringExam+%@",self.mUser.UserGuid]];
                 [userDef synchronize];
                [self bindData];
                return;
            } else {
                  limitTimeStamp = [userDef doubleForKey:[NSString stringWithFormat:@"limitTimeStamp+%@",self.mUser.UserGuid]];
                [self startCountDown];
                [self updateQmIdenxModel];
                [self.view makeToast:@"您的试卷上次答题记录已经恢复，请抓紧时间进行答题。" duration:1 position:CSToastPositionCenter];
            }
        } else if ([self.nsType isEqualToString:@"2"] && [userDef boolForKey:[NSString stringWithFormat:@"isDuringExam2+%@",self.mUser.UserGuid]]) {
            if (self.examInfoId != nil && [self.examInfoId isEqualToString:[userDef objectForKey:[NSString stringWithFormat:@"examInfoId2+%@",self.mUser.UserGuid]]]) {

                self.mWY_QuizModel = [WY_QuizModel modelWithJSON:[userDef objectForKey:[NSString stringWithFormat:@"mWY_QuizModelJson2+%@",self.mUser.UserGuid]]];
                //如果缓存题目获取失败 - 重新请求接口获取考试题目；
                if(self.mWY_QuizModel.tQuestionList == nil || self.mWY_QuizModel.tQuestionList.count <= 0) {
                    self.mWY_QuizModel = nil;
                    [userDef removeObjectForKey:[NSString stringWithFormat:@"mWY_QuizModelJson2+%@",self.mUser.UserGuid]];
                    [userDef removeObjectForKey:[NSString stringWithFormat:@"limitTimeStamp2+%@",self.mUser.UserGuid]];
                    [userDef removeObjectForKey:[NSString stringWithFormat:@"isDuringExam2+%@",self.mUser.UserGuid]];
                    
                    [userDef removeObjectForKey:[NSString stringWithFormat:@"examInfoId2+%@",self.mUser.UserGuid]];
                    [userDef removeObjectForKey:[NSString stringWithFormat:@"faceList+%@",self.mUser.UserGuid]];
                    [userDef synchronize];
                    [self bindData];
                    return;
                } else {
                    //人脸去掉了 - 这里取不到
                    self.arrFace = [NSMutableArray new];
//                    self.arrFace = [[NSMutableArray alloc] initWithArray:[self convert2DictionaryWithJSONString:[userDef objectForKey:[NSString stringWithFormat:@"faceList+%@",self.mUser.UserGuid]]]];
                    limitTimeStamp = [userDef doubleForKey:[NSString stringWithFormat:@"limitTimeStamp2+%@",self.mUser.UserGuid]];
                    
                    [self startCountDown];
                    [self updateQmIdenxModel];
                    [self.view makeToast:@"您的试卷上次答题记录已经恢复，请抓紧时间进行答题。" duration:1 position:CSToastPositionCenter];
                }
                
            } else {
                [userDef removeObjectForKey:[NSString stringWithFormat:@"mWY_QuizModelJson2+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"limitTimeStamp2+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"isDuringExam2+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"examInfoId2+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"faceList+%@",self.mUser.UserGuid]];
                [userDef synchronize];
                [self bindData];
            }
        } else {
            [self bindData];
        }
    }
}
- (NSDictionary *)convert2DictionaryWithJSONString:(NSString *)jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"%@",err);
        return nil;
    }
    return dic;
}

- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    
    UIImageView *imgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, MH_APPLICATION_STATUS_BAR_HEIGHT, kScreenWidth, k360Width(200))];
    [imgTop setImage:[UIImage imageNamed:@"0225_ktbj"]];
    [self.view addSubview:imgTop];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), JCNew64, k360Width(44), k360Width(44))];
    [btnBack setImage:[UIImage imageNamed:@"0225_quizback"] forState:UIControlStateNormal];
    
    [self.view addSubview:btnBack];
    
    lblTime = [[UILabel alloc] initWithFrame:CGRectMake(0, btnBack.top, k360Width(100), k360Width(35))];
    lblTime.centerX = self.view.centerX;
    [lblTime setFont:WY_FONTMedium(16)];
    [lblTime setTextColor:[UIColor blackColor]];
    [lblTime setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lblTime];
    
    btnSave = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(16 + 65), JCNew64, k360Width(65), k360Width(35))];
    [btnSave setTitle:@"交卷" forState:UIControlStateNormal];
    [btnSave setBackgroundColor:MSTHEMEColor];
    [btnSave rounded:k360Width(44 / 8)];
    [btnSave.titleLabel setFont:WY_FONTRegular(14)];
    [self.view addSubview:btnSave];
    
    viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - k360Width(64), kScreenWidth, k360Width(64))];
    [viewBottom setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView * imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,viewBottom.width, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [viewBottom addSubview:imgLine];
    
    
    btnUp = [UIButton new];
    btnDown = [UIButton new];
    [btnUp setFrame:CGRectMake(k360Width(16), k360Width(10), k360Width(80), k360Width(44))];
    [btnUp setTitle:@"上一题" forState:UIControlStateNormal];
    [btnUp setBackgroundColor:MSTHEMEColor];
    [btnUp rounded:k360Width(44 / 8)];
    [btnUp.titleLabel setFont:WY_FONTRegular(14)];
    
    [btnDown setFrame:CGRectMake(btnUp.right + k360Width(16), k360Width(10), k360Width(80), k360Width(44))];
    [btnDown setTitle:@"下一题" forState:UIControlStateNormal];
    [btnDown setBackgroundColor:MSTHEMEColor];
    [btnDown rounded:k360Width(44 / 8)];
    [btnDown.titleLabel setFont:WY_FONTRegular(14)];
    [viewBottom addSubview:btnUp];
    [viewBottom addSubview:btnDown];
    
    btnQbst = [UIButton new];
    [btnQbst setFrame:CGRectMake(kScreenWidth - k360Width(16 + 80), k360Width(5), k360Width(80), k360Width(54))];
    [btnQbst setImage:[UIImage imageNamed:@"0225_qbst"] forState:UIControlStateNormal];
    [btnQbst.titleLabel setFont:WY_FONTRegular(12)];
    [btnQbst setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    [btnQbst setTitleEdgeInsets:UIEdgeInsetsMake(0, k360Width(15), 0, 0)];
    [viewBottom addSubview:btnQbst];
    
    [self.view addSubview:viewBottom];
    
    mScrollView = [UIScrollView new];
    [mScrollView setFrame:CGRectMake(0, btnSave.bottom + k360Width(30), kScreenWidth, viewBottom.top - btnSave.bottom - k360Width(30))];
    [mScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mScrollView];
    
    
    
    [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
    [btnSave addTarget:self action:@selector(btnSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [btnUp addTarget:self action:@selector(btnUpAction) forControlEvents:UIControlEventTouchUpInside];
    [btnDown addTarget:self action:@selector(btnDownAction) forControlEvents:UIControlEventTouchUpInside];
    [btnQbst addTarget:self action:@selector(btnQbstAction) forControlEvents:UIControlEventTouchUpInside];
    
    //加载题目模块
    [self initQuizContent];
    // 加载交卷Alert;
    mWY_SubmitAlertView = [[WY_SubmitAlertView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mWY_SubmitAlertView];
}
//加载题目模块
- (void)initQuizContent {
    viewQuizContent = [UIView new];
    [viewQuizContent setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(100))];
    [self viewShadowCorner:viewQuizContent];
    [viewQuizContent setBackgroundColor:[UIColor whiteColor]];
    [mScrollView addSubview:viewQuizContent];
    
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(15) , k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [viewQuizContent addSubview:viewBlue1];
    
    lblTypeStr = [UILabel new];
    [lblTypeStr setFrame:CGRectMake(viewBlue1.right + k360Width(5), 0, k360Width(250), k360Width(44))];
    [lblTypeStr setFont:WY_FONTMedium(16)];
    [lblTypeStr setTextColor:[UIColor blackColor]];
    [viewQuizContent addSubview:lblTypeStr];
    
    UILabel *lblFen = [UILabel new];
    [lblFen setFrame:CGRectMake(viewQuizContent.width - k360Width(45), k360Width(12), k360Width(24), k360Width(24))];
    [lblFen setTextColor:APPTextGayColor];
    [lblFen setFont:WY_FONTRegular(14)];
    [lblFen setText:@"分"];
    [lblFen setTextAlignment:NSTextAlignmentRight];
    [viewQuizContent addSubview:lblFen];
    
    lblScore = [UILabel new];
    [lblScore setFrame:CGRectMake(viewQuizContent.width - k360Width(140), 0, k360Width(100), k360Width(44))];
    [lblScore setTextColor:[UIColor blackColor]];
    [lblScore setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:k360Width(20)]];
    [lblScore setTextAlignment:NSTextAlignmentRight];
    [viewQuizContent addSubview:lblScore];
    
    UIImageView * imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(44),viewQuizContent.width, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [viewQuizContent addSubview:imgLine];
    lblQuizTitle = [UILabel new];
    [lblQuizTitle setFont:WY_FONTMedium(16)];
    [lblQuizTitle setTextColor:[UIColor blackColor]];
    [lblQuizTitle setLineBreakMode:NSLineBreakByCharWrapping];
    [lblQuizTitle setNumberOfLines:0];
    tianKongView = [UIView new];
    [viewQuizContent addSubview:tianKongView];
    [viewQuizContent addSubview: lblQuizTitle];
    viewSelContent = [UIView new];
    [viewQuizContent addSubview:viewSelContent];
    
    txtAnswer = [IQTextView new];
    btnAnswerSR = [UIButton new];
    [viewQuizContent addSubview:txtAnswer];
    [viewQuizContent addSubview:btnAnswerSR];
    
}
- (void)bindData {
    
    NSString *urlStr = @"";
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    if ([self.nsType isEqualToString:@"1"]) {
        //模拟考试-获取试题
        urlStr = getQuestionList_HTTP;
    }else {
        //真实考试-获取试题
        urlStr = getRealQuestionList_HTTP;
        [dicPost setObject:self.examInfoId forKey:@"examInfoId"];
    }
    [[MS_BasicDataController sharedInstance] postWithReturnCode:urlStr params:dicPost jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 1 && res) {
            
            if (((NSArray *)res[@"data"][@"tQuestionList"]).count > 0) {
                self.mWY_QuizModel = [WY_QuizModel modelWithJSON:res[@"data"]];
    //            //测试模拟考试 15 秒
    //            self.mWY_QuizModel.limitTime = @"15";
                limitTimeStamp =  [NSDate serverCurrentTimeStamp];
                [self startCountDown];
                [self updateQmIdenxModel];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"错误（1）您的考试题目获取失败，请重新进入考试，若一直不成功请截图本页，并联系客服人员。" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"确定");
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];

            }
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:res[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定");
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];

        }
    } failure:^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"错误（2）您的考试题目获取失败，请重新进入考试，若一直不成功请截图本页，并联系客服人员。%@",[error localizedDescription]] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];

    }];
}
- (void)startCountDown {
    mNSTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer 不走了？");
        double currentTimeStamp = [NSDate serverCurrentTimeStamp];
        examNum = [self.mWY_QuizModel.limitTime intValue] - (currentTimeStamp * 1000 - limitTimeStamp * 1000) / 1000;
 
        if (examNum <= 0) {
            lblTime.text = @"00:00";
            [timer invalidate];
            [self alertJiaoJuan];
            return ;
        } else {
            NSString *str_minute = [NSString stringWithFormat:@"%02d", (examNum % 3600) / 60];
            NSString *str_second = [NSString stringWithFormat:@"%02d", examNum % 60];
            lblTime.text = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        }
    } repeats:YES];
    
}

- (void)cacheQuiz {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if ([self.nsType isEqualToString:@"1"]) {
        [userDef setObject:self.mWY_QuizModel.toJSONString forKey:[NSString stringWithFormat:@"mWY_QuizModelJson+%@",self.mUser.UserGuid]];
        [userDef setFloat:limitTimeStamp forKey:[NSString stringWithFormat:@"limitTimeStamp+%@",self.mUser.UserGuid]];
        [userDef setBool:YES forKey:[NSString stringWithFormat:@"isDuringExam+%@",self.mUser.UserGuid]];
    } else if ([self.nsType isEqualToString:@"2"]) {
        
        [userDef setObject:self.mWY_QuizModel.toJSONString forKey:[NSString stringWithFormat:@"mWY_QuizModelJson2+%@",self.mUser.UserGuid]];
        [userDef setFloat:limitTimeStamp forKey:[NSString stringWithFormat:@"limitTimeStamp2+%@",self.mUser.UserGuid]];
        [userDef setBool:YES forKey:[NSString stringWithFormat:@"isDuringExam2+%@",self.mUser.UserGuid]];
        [userDef setObject:self.examInfoId forKey:[NSString stringWithFormat:@"examInfoId2+%@",self.mUser.UserGuid]];
//        [userDef setObject:[self.arrFace yy_modelToJSONString] forKey:[NSString stringWithFormat:@"faceList+%@",self.mUser.UserGuid]];
    }
     
    [userDef synchronize];
}

//提示交卷
- (void)alertJiaoJuan {
    NSLog(@"提示交卷");
    //先弹出交卷；Alert
    
    int AnsweredNum = 0;
    for (WY_QuestionModel *tempModel in self.mWY_QuizModel.tQuestionList) {
        if (tempModel.select) {
            AnsweredNum ++;
        }
    }
    
    [mWY_SubmitAlertView showViewByExamTime:examNum byCountNum:self.mWY_QuizModel.tQuestionList.count withAnsweredNum:AnsweredNum];
    mWY_SubmitAlertView.submitBlock = ^{
        [self submitQuiz];
    };
}
- (void)submitQuiz {
    WY_QuizSubmitParamModel *tempModel = [WY_QuizSubmitParamModel new];
    tempModel.userguid = self.mUser.UserGuid;
    tempModel.orgnum = self.mUser.orgnum;
    tempModel.examid = self.mWY_QuizModel.examid;
    tempModel.idCard = self.mUser.idcardnum;
    int postExamNum = [self.mWY_QuizModel.limitTime intValue] - examNum;
    
    NSString *str_minute = [NSString stringWithFormat:@"%02d", (postExamNum % 3600) / 60];
    NSString *str_second = [NSString stringWithFormat:@"%02d", postExamNum % 60];
    tempModel.examTime = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
   
    if([tempModel.examTime isEqualToString:@"00:00"]) {
        tempModel.examTime = @"59:59";
    }
    
    tempModel.mixSelectScore = self.mWY_QuizModel.mixSelectScore;
    tempModel.questionBeanList = self.mWY_QuizModel.tQuestionList;
    
    NSString *urlStr = @"";
    if ([self.nsType isEqualToString:@"1"]) {
        urlStr = commitEaxm_HTTP;
    } else {
        urlStr = commitRealEaxm_HTTP;
    }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:urlStr params:nil jsonData:[tempModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 1 && res) {
            
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            if ([self.nsType isEqualToString:@"1"]) {
                [userDef removeObjectForKey:[NSString stringWithFormat:@"mWY_QuizModelJson+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"limitTimeStamp+%@",self.mUser.UserGuid]];
                
                [userDef removeObjectForKey:[NSString stringWithFormat:@"isDuringExam+%@",self.mUser.UserGuid]];
             } else {
                [userDef removeObjectForKey:[NSString stringWithFormat:@"mWY_QuizModelJson2+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"limitTimeStamp2+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"isDuringExam2+%@",self.mUser.UserGuid]];
                [userDef removeObjectForKey:[NSString stringWithFormat:@"examInfoId2+%@",self.mUser.UserGuid]];
//                [userDef removeObjectForKey:[NSString stringWithFormat:@"faceList+%@",self.mUser.UserGuid]];
            }
            
            [userDef synchronize];
            //工信部要求去掉人脸
//            [self submitFaceArr];
            if (self.submitQuizBlock) {
                self.submitQuizBlock();
            }
            [mNSTimer invalidate];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [mNSTimer invalidate];
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"您的考试数据提交失败，请再次提交或联系客服人员。"];
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    
}
///提交验证人脸数据
- (void)submitFaceArr {
      if (!self.isReview && [self.nsType isEqualToString:@"2"]) {
          NSMutableDictionary *dicFaceJson = [NSMutableDictionary new];
          [dicFaceJson setObject:self.arrFace forKey:[NSString stringWithFormat:@"faceList+%@",self.mUser.UserGuid]];
          [dicFaceJson setObject:self.mWY_QuizModel.examid forKey:@"examid"];
          [[MS_BasicDataController sharedInstance] postWithReturnCode:checkface_HTTP params:nil jsonData:[dicFaceJson yy_modelToJSONData] showProgressView:YES success:^(id res, NSString *code) {
             } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"人脸数据-提交失败"];
            }];
      }
    
}
- (void)dealloc {
    [mNSTimer invalidate];
}
- (void)initReviewQmView {
    // 把其他控件隐藏掉；
    [lblTime setHidden:YES];
    [btnSave setHidden:YES];
    [viewBottom setHidden:YES];
    mScrollView.height = viewBottom.bottom - btnSave.bottom - k360Width(30);
    [self questionShow];
    [self questionReviewShow];
}

- (void)updateQmIdenxModel {
    //工信部要求去掉人脸
//    [self verifyFace];
    self.mQmIdenxModel =  [self.mWY_QuizModel.tQuestionList objectAtIndex:self.currentSelIndex];
    [btnQbst setTitle:[NSString stringWithFormat:@"%zd/%zd",self.currentSelIndex + 1,self.mWY_QuizModel.tQuestionList.count] forState:UIControlStateNormal];
    
    [self questionShow];
}

- (void)questionShow{
    
    switch ([self.mQmIdenxModel.questionType intValue]) {
        case 1:
        {
            lblTypeStr.text = @"单选题";
        }
            break;
        case 2:
        {
            if (self.isReview) {
                lblTypeStr.text = @"多选题";
                break;
            }
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"多选题"];
            NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  （漏选得%.1f分）",[self.mWY_QuizModel.mixSelectScore floatValue]]];
            [attStr1 setYy_color:APPTextGayColor];
            [attStr1 setYy_font:WY_FONTRegular(12)];
            [attStr appendAttributedString:attStr1];
            lblTypeStr.attributedText = attStr;
        }
            break;
        case 3:
        {
            lblTypeStr.text = @"判断题";
            
        }
            break;
        case 4:
        {
            lblTypeStr.text = @"简答题";
            
        }
            break;
        case 5 :
        {
            lblTypeStr.text = @"案例分析题";
        }
            break;
        case 6 :
        {
            lblTypeStr.text = @"填空题";
        }
            break;
       
        default:
            break;
    }
    [lblScore setText:[NSString stringWithFormat:@"%.1f",[self.mQmIdenxModel.score floatValue]]];
    
    
    
    if  ([self.mQmIdenxModel.questionType intValue] == 6) {
        //填空题
        
        [tianKongView setFrame:CGRectMake(k360Width(16), k360Width(45 + 16), viewQuizContent.width - k360Width(32), k360Width(100))];
        [tianKongView setHidden:NO];
        [lblQuizTitle setHidden:YES];
//        [tianKongView setBackgroundColor:[UIColor redColor]];
         
        
        [lblQuizTitle setHidden:NO];
        [lblQuizTitle setFrame:CGRectMake(k360Width(16), k360Width(45), viewQuizContent.width - k360Width(32), k360Width(100))];
//        lblQuizTitle.text = self.mQmIdenxModel.questionContent;
//        self.mQmIdenxModel.questionContent = [NSString stringWithFormat:@"%@ <br /> <img src ='https://profile.csdnimg.cn/6/2/4/3_iteye_8877'/>",self.mQmIdenxModel.questionContent];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[self.mQmIdenxModel.questionContent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [attrStr setYy_font:WY_FONTMedium(16)];
        lblQuizTitle.attributedText = attrStr;
        
        [lblQuizTitle sizeToFit];
        lblQuizTitle.height += k360Width(32);
        
        [tianKongView setFrame:CGRectMake(k360Width(16), lblQuizTitle.bottom, viewQuizContent.width - k360Width(32), k360Width(100))];
        [tianKongView setHidden:NO];
//        [tianKongView setBackgroundColor:[UIColor redColor]];
        [tianKongView removeAllSubviews];
        
        UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(0), k360Width(15) , k360Width(4), k360Width(15))];
        [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
        [tianKongView addSubview:viewBlue1];
        
        UILabel * lblReTypeStr = [UILabel new];
        [lblReTypeStr setFrame:CGRectMake(viewBlue1.right + k360Width(5), 0, k360Width(250), k360Width(44))];
        [lblReTypeStr setFont:WY_FONTMedium(16)];
        [lblReTypeStr setTextColor:[UIColor blackColor]];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"请输入题目中"];
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:@"□"];
        NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc] initWithString:@"处的答案："];
        [attStr2 setYy_color:[UIColor redColor]];
        [attStr1 appendAttributedString:attStr2];
        [attStr1 appendAttributedString:attStr3];
        
        
        [lblReTypeStr setAttributedText:attStr1];
        [tianKongView addSubview:lblReTypeStr];
        
         NSRange range;
        double lastX = 0;
        double lastXSp = k360Width(3);
        double lastY = lblReTypeStr.bottom + k360Width(10);
        double txtW = k360Width(36);
        double maxW = tianKongView.width;
        indexTag = 200;
        for (int i = 0; i < self.mQmIdenxModel.questionContent.length ; i += range.length ) {
            unichar chara = [self.mQmIdenxModel.questionContent characterAtIndex:i];
            range = [self.mQmIdenxModel.questionContent rangeOfComposedCharacterSequenceAtIndex:i];
            NSString *subStr = [self.mQmIdenxModel.questionContent substringWithRange:range];
            NSLog(@"%@ %@",subStr,NSStringFromRange(range));
            if ([subStr isEqualToString:@"□"]) {
                UIButton *txtTkItem = [UIButton new];
                 [txtTkItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//                [txtTkItem setTextAlignment:NSTextAlignmentCenter];
                [txtTkItem.titleLabel setFont:WY_FONTMedium(16)];
                [txtTkItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [txtTkItem rounded:8 width:2 color:HEXCOLOR(0x666666)];
//                 txtTkItem.tintColor = [UIColor clearColor];
                txtTkItem.tag = indexTag;
                [txtTkItem addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    UIButton *btnSender = (UIButton *)sender;
                    NSLog(@"选中了 - %d",btnSender.tag);
                    [txtTkt becomeFirstResponder];
                    
                    for (UIButton *btn in [tianKongView subviews]) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            [btn rounded:8 width:2 color:MSTHEMEColor];
                        }
                    }
                    
                    [btnSender rounded:8 width:2 color:APPRedColor];
                    if (txtTkt.text.length <= (btnSender.tag - 200)) {
                        [txtTkt setSelectedRange:NSMakeRange((btnSender.tag - 200), 0)];
                    } else {
                        [txtTkt setSelectedRange:NSMakeRange((btnSender.tag - 200), 1)];
                    }
                    
                }];
                 indexTag ++;
                 [txtTkItem setFrame:CGRectMake(lastX + lastXSp, lastY-4, txtW+8, txtW+8)];
                 
                [tianKongView addSubview:txtTkItem];
                lastX = txtTkItem.right + lastXSp;
                if (lastX + txtW + 8 > maxW) {
                    lastX = 0;
                    lastY = txtTkItem.bottom + k360Width(10);
                }
                
                tianKongView.height = txtTkItem.bottom + k360Width(5);
            }
//            else {
//                UILabel *lblItem = [UILabel new];
//                [lblItem setTextAlignment:NSTextAlignmentCenter];
//                [lblItem setFont:WY_FONTMedium(16)];
//                [lblItem setTextColor:[UIColor blackColor]];
//                [lblItem setText:subStr];
//                [lblItem setFrame:CGRectMake(lastX, lastY, txtW, txtW)];
//                [tianKongView addSubview:lblItem];
//                lastX = lblItem.right;
//                if (lastX + txtW > maxW) {
//                    lastX = 0;
//                    lastY = lblItem.bottom + k360Width(5);
//                }
//            }
            
        }
        
        txtTkt = [WY_YNTextField new];
        [txtTkt setFrame:CGRectMake(0, lastY, 320, 120)];
        txtTkt.delegate = self;
        [txtTkt addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        [txtTkt setTextColor:[UIColor clearColor]];
        [txtTkt setTintColor:[UIColor clearColor]];
        [txtTkt setAlpha:0];
        [txtTkt setHidden:YES];
        [tianKongView addSubview:txtTkt];
        txtTkt.text = self.mQmIdenxModel.userSolution;
        [self updateButton];
        
        if (self.isReview) {
            txtTkt. userInteractionEnabled = NO;
        }
        
        [viewSelContent setFrame:CGRectMake(k360Width(16), tianKongView.bottom + k360Width(16),viewQuizContent.width - k360Width(32), k360Width(100))];

        
    } else {
        [tianKongView setHidden:YES];
        [lblQuizTitle setHidden:NO];
        [lblQuizTitle setFrame:CGRectMake(k360Width(16), k360Width(45), viewQuizContent.width - k360Width(32), k360Width(100))];
//        lblQuizTitle.text = self.mQmIdenxModel.questionContent;
         NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[self.mQmIdenxModel.questionContent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [attrStr setYy_font:WY_FONTMedium(16)];
        lblQuizTitle.attributedText = attrStr;
        
        [lblQuizTitle sizeToFit];
        lblQuizTitle.height += k360Width(32);
        [viewSelContent setFrame:CGRectMake(k360Width(16), lblQuizTitle.bottom ,viewQuizContent.width - k360Width(32), k360Width(100))];

    }
    
    
    [viewSelContent removeAllSubviews];
    float lastY = 0;
    if  ([self.mQmIdenxModel.questionType intValue] == 3) {
        //判断题
        WY_QuestionOptionModel *pdt0 = [WY_QuestionOptionModel new];
        pdt0.optionContent = @"错误";
        pdt0.optionType = @"0";
        
        WY_QuestionOptionModel *pdt1 = [WY_QuestionOptionModel new];
        pdt1.optionContent = @"正确";
        pdt1.optionType = @"1";
        NSMutableArray *arrPdt = [NSMutableArray new];
        [arrPdt addObject:pdt1];
        [arrPdt addObject:pdt0];
        if ([self.mQmIdenxModel.userSolution isEqualToString:@"1"]) {
            pdt1.selected = YES;
        } else if ([self.mQmIdenxModel.userSolution isEqualToString:@"0"])  {
            pdt0.selected = YES;
        }
        self.mQmIdenxModel.optionList = arrPdt;
        [txtAnswer setHidden:YES];
        [btnAnswerSR setHidden:YES];
        
        for (WY_QuestionOptionModel *qoModel in self.mQmIdenxModel.optionList) {
            WY_QuestionOptionView *tempQoView = [[WY_QuestionOptionView alloc] initWithFrame:CGRectMake(0, lastY, viewSelContent.width, 0)];
            //如果是回顾-禁止点击
            [tempQoView showPDTCellByItem:qoModel];
            if (self.isReview) {
                [tempQoView setUserInteractionEnabled:NO];
                if ([qoModel.optionType isEqualToString:self.mQmIdenxModel.userSolution]) {
                    if ([self.mQmIdenxModel.answerIsRight isEqualToString:@"1"]) {
                        //选中的-错误 -不让用户看到正确答案了；
//                        [tempQoView.lblTitle setTextColor:[UIColor redColor]];
                    }
                }
                if ([qoModel.optionType isEqualToString:self.mQmIdenxModel.solution]) {
                    //正确答案   -不让用户看到正确答案了；
//                    [tempQoView.lblTitle setTextColor:HEXCOLOR(0x0DA42E)];
                }
            }
            [viewSelContent addSubview:tempQoView];
            lastY = tempQoView.bottom + k360Width(16);
            WS(weakSelf)
            [tempQoView addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                //单选= 判断
                for (WY_QuestionOptionModel *tenpQoModel in weakSelf.mQmIdenxModel.optionList) {
                    tenpQoModel.selected = NO;
                }
                //选中后- 赋值
                WY_QuestionOptionView *qoView = (WY_QuestionOptionView *)sender;
                qoView.mWY_QuestionOptionModel.selected = YES;
                    weakSelf.mQmIdenxModel.select = YES;
                    weakSelf.mQmIdenxModel.userSolution = qoView.mWY_QuestionOptionModel.optionType;
                [weakSelf updateQmIdenxModel];
            }];
        }
        
        
    }
     else if ([self.mQmIdenxModel.questionType intValue] == 4 || [self.mQmIdenxModel.questionType intValue] == 5) {
        [txtAnswer setHidden:NO];
//         [btnAnswerSR setHidden:NO];
         [btnAnswerSR setHidden:YES];
        txtAnswer.delegate = self;
        [txtAnswer setFrame:CGRectMake(k360Width(16), lblQuizTitle.bottom + k360Width(16),viewQuizContent.width - k360Width(32), k360Width(200))];
        [txtAnswer setBackgroundColor:HEXCOLOR(0xFAFAFA)];
        [txtAnswer rounded:k360Width(44/8) width:1 color:HEXCOLOR(0xEEEEEE)];
        txtAnswer.placeholder = @"请输入答案";
        [txtAnswer setFont:WY_FONTMedium(14)];
        txtAnswer.textContainerInset = UIEdgeInsetsMake(k360Width(15), k360Width(15), k360Width(15), k360Width(15));
        txtAnswer.text = self.mQmIdenxModel.userSolution;
         
         [btnAnswerSR setBackgroundColor:[UIColor redColor]];
         [btnAnswerSR setFrame:CGRectMake(txtAnswer.right - k360Width(35), txtAnswer.bottom - k360Width(35), k360Width(30), k360Width(30))];
         [btnAnswerSR setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
             NSLog(@"开始语音转换");
             
             
         }];
        lastY = txtAnswer.height + k360Width(32);
        
        if (self.isReview) {
            txtAnswer. userInteractionEnabled = NO;
        }
        
    } else {
        [txtAnswer setHidden:YES];
        for (WY_QuestionOptionModel *qoModel in self.mQmIdenxModel.optionList) {
            WY_QuestionOptionView *tempQoView = [[WY_QuestionOptionView alloc] initWithFrame:CGRectMake(0, lastY, viewSelContent.width, 0)];
            //如果是回顾-禁止点击
            [tempQoView showCellByItem:qoModel];
            if (self.isReview) {
                [tempQoView setUserInteractionEnabled:NO];
                if ([qoModel.optionType isEqualToString:self.mQmIdenxModel.userSolution]) {
                    if ([self.mQmIdenxModel.answerIsRight isEqualToString:@"1"]) {
                        //选中的-错误 -不让用户看到正确答案了；
//                        [tempQoView.lblTitle setTextColor:[UIColor redColor]];
                    }
                }
                if ([qoModel.optionType isEqualToString:self.mQmIdenxModel.solution]) {
                    //正确答案 -不让用户看到正确答案了；
//                    [tempQoView.lblTitle setTextColor:HEXCOLOR(0x0DA42E)];
                }
            }
            [viewSelContent addSubview:tempQoView];
            lastY = tempQoView.bottom + k360Width(16);
            WS(weakSelf)
            [tempQoView addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                
                if ([weakSelf.mQmIdenxModel.questionType intValue] == 1) {
                    //单选
                    for (WY_QuestionOptionModel *tenpQoModel in weakSelf.mQmIdenxModel.optionList) {
                        tenpQoModel.selected = NO;
                    }
                }
                //选中后- 赋值
                WY_QuestionOptionView *qoView = (WY_QuestionOptionView *)sender;
                
                if ([weakSelf.mQmIdenxModel.questionType intValue] == 2) {
                    //多选
                    qoView.mWY_QuestionOptionModel.selected = !qoView.mWY_QuestionOptionModel.selected;
                    BOOL isDuoSel = NO;
                    NSMutableArray *optionTypeArr = [NSMutableArray new];
                    for (WY_QuestionOptionModel *tenpQoModel in weakSelf.mQmIdenxModel.optionList) {
                        if (tenpQoModel.selected) {
                            isDuoSel = YES;
                            [optionTypeArr addObject:tenpQoModel.optionType];
                        }
                    }
                    weakSelf.mQmIdenxModel.select = isDuoSel;
                    weakSelf.mQmIdenxModel.userSolution = [optionTypeArr componentsJoinedByString:@""];
                } else {
                    qoView.mWY_QuestionOptionModel.selected = YES;
                    weakSelf.mQmIdenxModel.select = YES;
                    weakSelf.mQmIdenxModel.userSolution = qoView.mWY_QuestionOptionModel.optionType;
                }
                [weakSelf updateQmIdenxModel];
            }];
        }
        
    }
    viewSelContent.height = lastY;
    viewQuizContent.height = viewSelContent.bottom + k360Width(16);
    [mScrollView setContentSize:CGSizeMake(kScreenWidth, viewQuizContent.bottom + k360Width(16))];
    
}
 
- (void)textFieldChanged:(UITextField *)textField {
 
    NSString *toBeString = textField.text;
        NSString *lastString;
        if(toBeString.length>0)
            lastString=[toBeString substringFromIndex:toBeString.length-1];
        
        if ([self hasEmoji:lastString]) {
            textField.text = [self disable_emoji:toBeString];
             return;
        }
        NSString *lang = [[textField textInputMode] primaryLanguage];
        if([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if(!position) {
                NSString *getStr =  [self getZYSubString:toBeString];
                if(getStr && getStr.length > 0) {
                    textField.text = getStr;
                }
            } else {
                return;
            }
        } else{
            NSString *getStr =  [self getZYSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text= getStr;
            }
        }
    
    [self updateButton];
}

- (void)updateButton {
    NSString *string = txtTkt.text;
    self.mQmIdenxModel.userSolution = txtTkt.text;
    if (string.length > 0) {
        self.mQmIdenxModel.select = YES;
    } else {
        self.mQmIdenxModel.select = NO;
    }
    NSRange rangeA;
    int n = 0;
    for (int i = 0; i < indexTag - 200; i ++) {
        UIButton *ynTxt = [tianKongView viewWithTag:200+i];
        if (string.length > i) {
            unichar chara = [string characterAtIndex:n];
            rangeA = [string rangeOfComposedCharacterSequenceAtIndex:n];
            NSString *subStr = [string substringWithRange:rangeA];
            [ynTxt setTitle:subStr forState:UIControlStateNormal];
            [ynTxt rounded:8 width:2 color:MSTHEMEColor];
            n +=  rangeA.length;
        } else {
            [ynTxt setTitle:@"" forState:UIControlStateNormal];
            [ynTxt rounded:8 width:2 color:HEXCOLOR(0x666666)];
        }
    }
    NSRange aa = [txtTkt selectedRange];
 
    UIButton *selTxt = [tianKongView viewWithTag:200+aa.location];
   if ([selTxt isKindOfClass:[UIButton class]]) {
       [selTxt rounded:8 width:2 color:APPRedColor];
   } else {
       [txtTkt resignFirstResponder];
   }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
 }


-(NSString *)getZYSubString:(NSString*)string
{
    if (string.length >  indexTag - 200) {
        return [string substringToIndex:indexTag - 200];
    }
    return nil;
}

- (NSString *)disable_emoji:(NSString *)text{ NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil]; NSString *modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""]; return modifiedString; }

- (BOOL)hasEmoji:(NSString*)str{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

- (void)questionReviewShow {
    NSLog(@"正确答案");
    UIView *viewReviewQuizContent = [UIView new];
    [viewReviewQuizContent setFrame:CGRectMake(k360Width(16), viewQuizContent.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(100))];
    [self viewShadowCorner:viewReviewQuizContent];
    [viewReviewQuizContent setBackgroundColor:[UIColor whiteColor]];
    [mScrollView addSubview:viewReviewQuizContent];
    
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(15) , k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [viewReviewQuizContent addSubview:viewBlue1];
    
    UILabel * lblReTypeStr = [UILabel new];
    [lblReTypeStr setFrame:CGRectMake(viewBlue1.right + k360Width(5), 0, k360Width(250), k360Width(44))];
    [lblReTypeStr setFont:WY_FONTMedium(16)];
    [lblReTypeStr setTextColor:[UIColor blackColor]];
    [viewReviewQuizContent addSubview:lblReTypeStr];
    
    
    UIImageView * imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(44),viewReviewQuizContent.width, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [viewReviewQuizContent addSubview:imgLine];
    
    NSString *answerStr = @"";
    switch ([self.mQmIdenxModel.questionType intValue]) {
        case 1:
        case 2:
        case 3:
        case 6:
        {
            NSString *userSolution = @"";
            if (self.mQmIdenxModel.userSolution.length == 0) {
                userSolution = @"无";
            } else {
                userSolution = self.mQmIdenxModel.userSolution;
            }
            //如果是正式考试2 - 不显示答案
            if ([self.nsType isEqualToString:@"2"]) {
                lblReTypeStr.text = @"答题状态";
                NSString *answerIsRight = @"";
                
                if ([self.mQmIdenxModel.answerIsRight isEqualToString:@"0"]) {
                    answerIsRight = @"正确";
                }else if ([self.mQmIdenxModel.answerIsRight isEqualToString:@"1"]) {
                    answerIsRight = @"错误";
                }else if ([self.mQmIdenxModel.answerIsRight isEqualToString:@"2"]) {
                    answerIsRight = @"漏选";
                }
                
                
                if  ([self.mQmIdenxModel.questionType intValue] == 3) {
                    //判断题
                    answerStr = [NSString stringWithFormat:@"答题状态：%@",answerIsRight];
                } else {
                    answerStr = [NSString stringWithFormat:@"您的答案：%@\n答题状态：%@",userSolution,answerIsRight];
                }

            } else {
                lblReTypeStr.text = @"正确答案";
                answerStr = [NSString stringWithFormat:@"您的答案：%@\n正确答案：%@",userSolution,self.mQmIdenxModel.solution];
                
                NSString *answerIsRight = @"";
                
                if ([self.mQmIdenxModel.answerIsRight isEqualToString:@"0"]) {
                    answerIsRight = @"正确";
                }else if ([self.mQmIdenxModel.answerIsRight isEqualToString:@"1"]) {
                    answerIsRight = @"错误";
                }else if ([self.mQmIdenxModel.answerIsRight isEqualToString:@"2"]) {
                    answerIsRight = @"漏选";
                }
                if  ([self.mQmIdenxModel.questionType intValue] == 3) {
                    //判断题
                    answerStr = [NSString stringWithFormat:@"答题状态：%@",answerIsRight];
                } else {
//                    answerStr = [NSString stringWithFormat:@"您的答案：%@\n答题状态：%@",userSolution,answerIsRight];
                }
            }
        }
            break;
        case 4:
        case 5 : {
            lblReTypeStr.text = @"答案解析";
            answerStr = self.mQmIdenxModel.solution;
        }
            break;
        default:
            break;
    }
    
    WY_QuestionOptionView *tempQoView = [[WY_QuestionOptionView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(44 + 16), viewSelContent.width, 0)];
    //如果是回顾-禁止点击
    [tempQoView showReViewCellByStr:answerStr];
    [viewReviewQuizContent addSubview:tempQoView];
    viewReviewQuizContent.height = tempQoView.bottom + k360Width(16);
    [mScrollView setContentSize:CGSizeMake(kScreenWidth, viewReviewQuizContent.bottom + k360Width(16))];
}

/// 验证人脸
- (void)verifyFace {
    //如果不是回顾- 并且是正式考试- 验证人脸；
        if (!self.isReview && [self.nsType isEqualToString:@"2"]) {
    if(!self.arrFace) {
        self.arrFace = [NSMutableArray new];
    }
    //已验证人脸次数
    int vFaceCount =  self.arrFace.count;
    
    //已达题数；
    int answeredNum = 0;
    
    for (WY_QuestionModel *qmModel in self.mWY_QuizModel.tQuestionList) {
        if (qmModel.select) {
            answeredNum ++;
        }
    }
    //总题数
    double quizNum = self.mWY_QuizModel.tQuestionList.count;
    
    double v1Num = quizNum * 0.2;
    double v2Num = quizNum * 0.4;
    double v3Num = quizNum * 0.6;
    double v4Num = quizNum * 0.8;
    double v5Num = quizNum * 0.9;
    
    if (answeredNum == (int)v1Num-1) {
        //第一次验证
        if (vFaceCount < 1) {
            [self gotoVerifyFace];
        }
    } else if (answeredNum == (int)v2Num - 1) {
        if (vFaceCount < 2) {
            [self gotoVerifyFace];
        }
    } else if (answeredNum == (int)v3Num - 1) {
        if (vFaceCount < 3) {
            [self gotoVerifyFace];
        }
    } else if (answeredNum == (int)v4Num - 1) {
        if (vFaceCount < 4) {
            [self gotoVerifyFace];
        }
    } else if (answeredNum == (int)v5Num - 1) {
        if (vFaceCount < 5) {
            [self gotoVerifyFace];
        }
    }
    
    NSLog(@"验证了%d次",self.arrFace.count);
        }
}

- (void)gotoVerifyFace {
    
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    //设置超时时间 10秒
    [[FaceSDKManager sharedInstance] setConditionTimeout:10];
    
    
    DetectionViewController* lvc = [[DetectionViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:NO completion:nil];
    WS(weakSelf);
    lvc.faceSuceessBlock = ^(UIImage *imgFace) {
        //人脸 识别成功后- 调用接口
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view makeToast:@"采集成功"];
            [weakSelf.arrFace addObject:[self UIImageToBase64Str:imgFace]];
            NSLog(@"成功添加了一次人脸数据");
        });
    };
    lvc.timeoutBlock = ^{
        //验证超时
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view makeToast:@"采集超时"];
            [weakSelf.arrFace addObject:@"TIME_OUT"];
            NSLog(@"添加人脸超时数据");
        });
    };
    
}

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    self.mQmIdenxModel.userSolution =textView.text;
    if (textView.text.length > 0) {
        self.mQmIdenxModel.select = YES;
    } else {
        self.mQmIdenxModel.select = NO;
    }
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

- (void)btnSaveAction{
    NSLog(@"交卷");
    [self alertJiaoJuan];
}
- (void)btnUpAction{
    if (self.currentSelIndex != 0) {
        self.currentSelIndex --;
        [self updateQmIdenxModel];
        //缓存试卷
        [self cacheQuiz];
    } else {
        [SVProgressHUD showErrorWithStatus:@"上面没有题了，已经是第一题"];
    }
}
- (void)btnDownAction{
    if (self.currentSelIndex != self.mWY_QuizModel.tQuestionList.count - 1) {
        self.currentSelIndex ++;
        [self updateQmIdenxModel];
        
        //缓存试卷
        [self cacheQuiz];
    } else {
        [SVProgressHUD showErrorWithStatus:@"下面没有题了，已经是最后一道题。"];
    }
}
- (void)btnQbstAction{
    WY_SelTopicViewController *tempController = [WY_SelTopicViewController new];
    tempController.mWY_QuizModel = self.mWY_QuizModel;
    tempController.currentSelIndex = self.currentSelIndex;
    tempController.selTopicBlock = ^(NSInteger withIndex) {
        self.currentSelIndex = withIndex;
        [self updateQmIdenxModel];
    };
    [self presentPanModal:tempController];
    
    //    [self presentViewController:tempController animated:YES completion:nil];
    
}

- (void)btnBackAction{
    
   
    if (self.isReview) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //返回时 - 如果 没有题目的情况下， 直接返回 ，不缓存；
        if (self.mWY_QuizModel.tQuestionList == nil ||  self.mWY_QuizModel.tQuestionList.count <= 0 ) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        //缓存试卷
        [self cacheQuiz];
        UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"确定退出本次答题?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [tempAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [tempAlert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [mNSTimer invalidate];
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:tempAlert animated:YES completion:nil];
        
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
