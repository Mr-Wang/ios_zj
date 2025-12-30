//
//  WY_AddTestQuestionsViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AddTestQuestionsViewController.h"
#import "IQTextView.h"
#import "WY_ParamAddQuestionModel.h"
#import "WY_CheckModel.h"

@interface WY_AddTestQuestionsViewController () {
    NSInteger selZSFLIndex; //知识分类
    NSInteger selNYCDIndex; //难易程度
    
    
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIControl *view1;    //题目类型
@property (nonatomic, strong) UIView *view2;    //输入题目
@property (nonatomic, strong) UIView *view3;    //添加括号
@property (nonatomic, strong) UIView *viewA;    //题目A
@property (nonatomic, strong) UIView *viewB;    //题目B
@property (nonatomic, strong) UIView *viewC;    //题目C
@property (nonatomic, strong) UIView *viewD;    //题目D
@property (nonatomic, strong) UIView *viewE;    //多选题目E
@property (nonatomic, strong) UIControl *view8;    //知识分类
@property (nonatomic, strong) UIControl *view9;    //难易程度
@property (nonatomic, strong) UIView *view10;    //答案依据
@property (nonatomic, strong) IQTextView *txtTitle;
@property (nonatomic, strong) IQTextView *txtQuestionA;
@property (nonatomic, strong) IQTextView *txtQuestionB;
@property (nonatomic, strong) IQTextView *txtQuestionC;
@property (nonatomic, strong) IQTextView *txtQuestionD;
@property (nonatomic, strong) IQTextView *txtQuestionE;
@property (nonatomic, strong) IQTextView *txtDaAn;
@property (nonatomic, strong) UILabel *lblType1;
@property (nonatomic, strong) UILabel *lblType2;
@property (nonatomic, strong) UIButton *btnAddKh;
@property (nonatomic, strong) UIButton *btnSelA;
@property (nonatomic, strong) UIButton *btnSelB;
@property (nonatomic, strong) UIButton *btnSelC;
@property (nonatomic, strong) UIButton *btnSelD;
@property (nonatomic, strong) UIButton *btnSelE;
@property (nonatomic, strong) WY_UserModel *mUser;

@end

@implementation WY_AddTestQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
    //如果是 -编辑、查看、审核 ，绑定数据
    if (![self.isAddType isEqualToString:@"1"] && self.mWY_QuestionModel) {
        [self bindView];
    }
}
- (void)makeUI {
    
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.mScrollView];
    
    //显示
    if ([self.isAddType isEqualToString:@"3"]) {
        self.title = @"查看题目";

        [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    } else {
        //添加或编辑；
        [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
        UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), kScreenHeight - k360Width(50) - JCNew64 - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(30), k360Width(40))];
        [btnLeft rounded:k360Width(40/8)];
        [btnLeft setBackgroundColor:MSTHEMEColor];
        [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];

        if ([self.isAddType isEqualToString:@"1"]) {
            self.title = @"新增题目";
            [btnLeft setTitle:@"提 交" forState:UIControlStateNormal];

         } else  if ([self.isAddType isEqualToString:@"2"]) {
             self.title = @"编辑题目";
             [btnLeft setTitle:@"提 交" forState:UIControlStateNormal];
         } else {
             self.title = @"审核题目";
             [btnLeft setTitle:@"审 核" forState:UIControlStateNormal];
         }
         [self.view addSubview:btnLeft];
    }
    
    [self initAllView];
    [self updateFrame];
}

- (void)bindView {
    //绑定rowGuid;
    self.mWY_ParamAddQuestionModel = [WY_ParamAddQuestionModel new];
    self.mWY_ParamAddQuestionModel.rowGuid = self.mWY_QuestionModel.rowGuid;
    
    self.txtTitle.text = self.mWY_QuestionModel.questionContent;
    self.txtQuestionA.text = self.mWY_QuestionModel.optionList[0].optionContent;
    self.txtQuestionB.text = self.mWY_QuestionModel.optionList[1].optionContent;
    self.txtQuestionC.text = self.mWY_QuestionModel.optionList[2].optionContent;
    self.txtQuestionD.text = self.mWY_QuestionModel.optionList[3].optionContent;
    
    for (int i = 0 ; i < self.mWY_QuestionModel.solution.length; i ++) {
        NSString *strItem = [self.mWY_QuestionModel.solution substringWithRange:NSMakeRange(i, 1)];
        if ([strItem isEqualToString:@"A"]) {
            self.btnSelA.selected = YES;
        } else if ([strItem isEqualToString:@"B"]) {
            self.btnSelB.selected = YES;
            } else if ([strItem isEqualToString:@"C"]) {
                self.btnSelC.selected = YES;
            } else if ([strItem isEqualToString:@"D"]) {
                self.btnSelD.selected = YES;
            } else if ([strItem isEqualToString:@"E"]) {
                self.btnSelE.selected = YES;
            }
    }
     
    selZSFLIndex = [self.mWY_QuestionModel.contentType intValue] - 1;
    selNYCDIndex = [self.mWY_QuestionModel.questionLevel intValue] - 1;
    self.lblType1.text = self.mWY_QuestionModel.contentTypeText;
    self.lblType2.text = self.mWY_QuestionModel.questionLevelText;
     self.txtDaAn.text = self.mWY_QuestionModel.nsDescription;

}

- (void)initViewAcc {
    UILabel *lbl1 = [UILabel new];
    if ([self.questionType isEqualToString:@"1"]) {
        lbl1.text = @"单选题";
    } else {
        lbl1.text = @"多选题";
    }
    self.lblType1 = [UILabel new];
    self.lblType2 = [UILabel new];
    selZSFLIndex = 0 ;
    self.lblType1.text = @"专业实务";
    selNYCDIndex = 0;
    self.lblType2.text = @"简单";
    self.view1 = [self byReturnColCellTitle:@"题目类型" byLabel:lbl1 isAcc:NO withBlcok:nil];
    self.view8 = [self byReturnColCellTitle:@"知识分类" byLabel:self.lblType1 isAcc:YES withBlcok:^{
        NSLog(@"点击了知识分类");
        [self showActionSheetZSFL];
    }];
    self.view9 = [self byReturnColCellTitle:@"难易程度" byLabel:self.lblType2 isAcc:YES withBlcok:^{
        NSLog(@"点击了难易程度");
        [self showActionSheetNYCD];
    }];
   
}
///知识分类选择
- (void)showActionSheetZSFL {
    [ActionSheetStringPicker showPickerWithTitle:@"请选择知识分类" rows:@[@"专业实务",@"法律法规",@"合同管理",@"实时政策",@"项目管理",@"造价管理",@"其他"] initialSelection:selZSFLIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selZSFLIndex = selectedIndex;
        self.lblType1.text = selectedValue;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}
///难易程度选择
- (void)showActionSheetNYCD {
    [ActionSheetStringPicker showPickerWithTitle:@"请选择难易程度" rows:@[@"简单",@"一般",@"困难"] initialSelection:selNYCDIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selNYCDIndex = selectedIndex;
        self.lblType2.text = selectedValue;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}
- (void)initAllView {
    [self initViewAcc];
    [self initViewTitile];
    [self initViewTiMuS];
    [self initViewDaAn];
}

//输入题目加载；
- (void)initViewTitile {
    self.view2 = [UIView new];
    [self.view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view2 setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(44))];
    self.txtTitle = [IQTextView new];
    [self.txtTitle setFrame:CGRectMake(k360Width(16), k360Width(10), kScreenWidth - k360Width(32), k360Width(34))];
    [self.view2 addSubview:self.txtTitle];
    self.txtTitle.placeholder = @"请输入题目";
    [self.txtTitle setFont:WY_FONTMedium(14)];
    self.txtTitle.delegate = self;
    [self.mScrollView addSubview:self.view2];
     
    
    self.view3 = [UIView new];
    [self.view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view3 setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(44))];
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [self.view3 addSubview:imgLine];
    
    self.btnAddKh = [UIButton new];
    [self.btnAddKh setFrame:CGRectMake(k360Width(16), k360Width(9), k360Width(98), k360Width(26))];
    [self.btnAddKh setBackgroundImage:[UIImage imageNamed:@"0414_crkh"] forState:UIControlStateNormal];
    [self.view3 addSubview:self.btnAddKh];
    [self.btnAddKh addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.txtTitle.text = [NSString stringWithFormat:@"%@（ ）",self.txtTitle.text];
    }];
    [self.mScrollView addSubview:self.view3];
}
///加载题目模块
- (void)initViewTiMuS {
    self.txtQuestionA = [IQTextView new];
    self.btnSelA = [UIButton new];
    
    self.txtQuestionB = [IQTextView new];
    self.btnSelB = [UIButton new];
    
    self.txtQuestionB = [IQTextView new];
    self.btnSelB = [UIButton new];
    
    self.txtQuestionC = [IQTextView new];
    self.btnSelC = [UIButton new];
    
    self.txtQuestionD = [IQTextView new];
    self.btnSelD = [UIButton new];
    
    self.txtQuestionE = [IQTextView new];
    self.btnSelE = [UIButton new];
    
    
    self.viewA = [self byReturnQueViewBYTextView:self.txtQuestionA bySelBtn:self.btnSelA];
    self.viewB = [self byReturnQueViewBYTextView:self.txtQuestionB bySelBtn:self.btnSelB];
    self.viewC = [self byReturnQueViewBYTextView:self.txtQuestionC bySelBtn:self.btnSelC];
    self.viewD = [self byReturnQueViewBYTextView:self.txtQuestionD bySelBtn:self.btnSelD];
    self.viewE = [self byReturnQueViewBYTextView:self.txtQuestionE bySelBtn:self.btnSelE];
    self.txtQuestionE.placeholder = @"选填";
    
    [self.btnSelA addTarget:self action:@selector(selBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSelB addTarget:self action:@selector(selBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSelC addTarget:self action:@selector(selBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSelD addTarget:self action:@selector(selBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSelE addTarget:self action:@selector(selBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)initViewDaAn {
    self.view10 = [UIView new];
    [self.view10 setBackgroundColor:[UIColor whiteColor]];
    [self.view10 setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(88))];
    UILabel *lblDaAnTitle = [UILabel new];
    [lblDaAnTitle setFrame:CGRectMake(k360Width(16), 0, kScreenWidth, k360Width(44))];
    [lblDaAnTitle setFont:WY_FONTRegular(14)];
    [lblDaAnTitle setTextColor:[UIColor blackColor]];
    lblDaAnTitle.text = @"答案依据说明";
    [self.view10 addSubview:lblDaAnTitle];
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, lblDaAnTitle.height - 1, kScreenWidth, 1)];
    [self.view10 addSubview:imgLine];
 
    self.txtDaAn = [IQTextView new];
    [self.txtDaAn setFrame:CGRectMake(k360Width(16), imgLine.bottom + k360Width(10), kScreenWidth - k360Width(88), k360Width(34))];
    self.txtDaAn.placeholder = @"请输入答案依据说明";
    [self.txtDaAn setFont:WY_FONTMedium(14)];
    self.txtDaAn.delegate = self;
    [self.view10 addSubview:self.txtDaAn];
    [self.mScrollView addSubview:self.view10];
}

- (UIView *)byReturnQueViewBYTextView:(IQTextView *)withTextView bySelBtn:(UIButton *)withSelBtn {
    UIView *viewContent = [UIView new];
    [viewContent setBackgroundColor:[UIColor whiteColor]];
    [viewContent setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewContent];
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [viewContent addSubview:imgLine];
    
    [viewContent addSubview:withTextView];
    [withTextView setFrame:CGRectMake(k360Width(16), k360Width(5), kScreenWidth - k360Width(64), k360Width(34))];
    withTextView.placeholder = @"必填";
    [withTextView setFont:WY_FONTMedium(14)];
    
    [withSelBtn setFrame:CGRectMake(withTextView.right + k360Width(10), 0, k360Width(22), k360Width(22))];
    [withSelBtn setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_s"] forState:UIControlStateNormal];
    [withSelBtn setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_lxx"] forState:UIControlStateSelected];
    withTextView.delegate  = self;
    [viewContent addSubview:withSelBtn];

    withSelBtn.centerY = withTextView.centerY;
    return viewContent;
}
-(void)textViewDidChange:(UITextView *)textView

{//根据字长度判断是否隐藏占位符Label
    CGSize contentSize = textView.contentSize;
    textView.height = contentSize.height;
    if (contentSize.height < k360Width(34)) {
        textView.height = k360Width(34);
    }
    [self updateFrame];
}
- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(88))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:[UIColor blackColor]];
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
    
    
    [withLabel setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(16), k360Width(250) - accLeft, k360Width(88))];
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
    return viewTemp;
}


- (void)btnLeftAction {
    
    if ([self.isAddType isEqualToString:@"4"]) {
        //审核
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否审核通过？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         }]];
        [alertController addAction:([UIAlertAction actionWithTitle:@"同 意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self auditQuestion:@"4"];
         }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"拒 绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self auditQuestion:@"6"];
        }])];
        [self presentViewController:alertController animated:YES completion:nil];

        return;
    }
    
    if ([self isVerification]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提交后将不能修改，是否确认提交" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         }]];
        [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self submitPost];
         }])];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

- (void)auditQuestion:(NSString *)strType {
 
    
    WY_CheckModel *tempModel = [WY_CheckModel new];
    tempModel.auditStatus = strType;
    tempModel.questionType = self.mWY_QuestionModel.questionType;
    tempModel.rowGuid = self.mWY_QuestionModel.rowGuid;
    
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:checkQuestion_HTTP params:nil jsonData:[tempModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
          if ([code integerValue] == 0 ) {
              [SVProgressHUD showSuccessWithStatus:res[@"msg"]];
              [self.navigationController popViewControllerAnimated:YES];
            } else {
              [SVProgressHUD showErrorWithStatus:res[@"msg"]];
          }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

//
//
//    [[MS_BasicDataController sharedInstance] postWithURL:checkQuestion_HTTP params:nil jsonData:[tempModel toJSONData] showProgressView:YES success:^(id successCallBack) {
//        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//     } failure:^(NSString *failureCallBack) {
//        [SVProgressHUD showErrorWithStatus:failureCallBack];
//    } ErrorInfo:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
//    }];
}

- (void)submitPost {
    NSLog(@"添加题目");
    NSString *urlStr = @"";
    if ([self.isAddType isEqualToString:@"1"]) {
        urlStr = addQuestion_HTTP;
    } else {
        urlStr = updateQuestion_HTTP;
    }
    if (!self.mWY_ParamAddQuestionModel) {
        self.mWY_ParamAddQuestionModel = [WY_ParamAddQuestionModel new];
    }
    self.mWY_ParamAddQuestionModel.questionType = self.questionType;
    self.mWY_ParamAddQuestionModel.questionContent = self.txtTitle.text;
    
    self.mWY_ParamAddQuestionModel.contentType = [NSString stringWithFormat:@"%d",selZSFLIndex + 1];
    
    self.mWY_ParamAddQuestionModel.questionLevel = [NSString stringWithFormat:@"%d",selNYCDIndex + 1];
    NSMutableArray *optionTypeArr = [NSMutableArray new];
    if (self.btnSelA.selected) {
        [optionTypeArr addObject:@"A"];
    }
    if (self.btnSelB.selected) {
        [optionTypeArr addObject:@"B"];
    }
    if (self.btnSelC.selected) {
        [optionTypeArr addObject:@"C"];
    }
    if (self.btnSelD.selected) {
        [optionTypeArr addObject:@"D"];
    }
    if (self.btnSelE.selected) {
        [optionTypeArr addObject:@"E"];
    }
    
    self.mWY_ParamAddQuestionModel.solution = [optionTypeArr componentsJoinedByString:@""];
    
    self.mWY_ParamAddQuestionModel.nsDescription = self.txtDaAn.text;
    
    self.mWY_ParamAddQuestionModel.questionScore = @"10";
    
    //个人传2 - 企业主传4
    if ([self.mUser.UserType isEqualToString:@"2"]) {
        //这是企业主
            self.mWY_ParamAddQuestionModel.auditStatus = @"4";
    } else {
        self.mWY_ParamAddQuestionModel.auditStatus = @"2";
    }
    
    self.mWY_ParamAddQuestionModel.userGuid = self.mUser.UserGuid;
    self.mWY_ParamAddQuestionModel.orgGuid = self.mUser.orgnum;
    
    NSMutableArray *arrModels = [NSMutableArray new];
    
    
    WY_QuestionOptionModel *tempModelA = [WY_QuestionOptionModel new];
    WY_QuestionOptionModel *tempModelB = [WY_QuestionOptionModel new];
    WY_QuestionOptionModel *tempModelC = [WY_QuestionOptionModel new];
    WY_QuestionOptionModel *tempModelD = [WY_QuestionOptionModel new];
    WY_QuestionOptionModel *tempModelE = [WY_QuestionOptionModel new];
    
    tempModelA.optionContent = self.txtQuestionA.text;
    tempModelA.optionType = @"A";
    
    tempModelB.optionContent = self.txtQuestionB.text;
    tempModelB.optionType = @"B";
    
    tempModelC.optionContent = self.txtQuestionC.text;
    tempModelC.optionType = @"C";
    
    tempModelD.optionContent = self.txtQuestionD.text;
    tempModelD.optionType = @"D";
    
    tempModelE.optionContent = self.txtQuestionE.text;
    tempModelE.optionType = @"E";
    
    
    [arrModels addObject:tempModelA];
    [arrModels addObject:tempModelB];
    [arrModels addObject:tempModelC];
    [arrModels addObject:tempModelD];
    //如果是多选 -传E
    if ([self.questionType isEqualToString:@"2"] && self.txtQuestionE.text.length > 0) {
        [arrModels addObject:tempModelE];
    }
    
    self.mWY_ParamAddQuestionModel.optionList = arrModels;
    NSLog(@"%@",[self.mWY_ParamAddQuestionModel toJSONString])
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:urlStr params:nil jsonData:[self.mWY_ParamAddQuestionModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
          if ([code integerValue] == 0 ) {
              [SVProgressHUD showSuccessWithStatus:res[@"msg"]];
              [self.navigationController popViewControllerAnimated:YES];
            } else {
              [SVProgressHUD showErrorWithStatus:res[@"msg"]];
          }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
     
    
}
///验证表单
- (BOOL)isVerification {
    if (self.txtTitle.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtTitle.placeholder];
        [self.txtTitle becomeFirstResponder];
        return NO;
    }
    if (self.txtDaAn.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.txtDaAn.placeholder];
         [self.txtDaAn becomeFirstResponder];
        return NO;
    }
    if (self.txtQuestionA.text.length <= 0) {
         [SVProgressHUD showErrorWithStatus:@"请完善选项信息"];
          [self.txtQuestionA becomeFirstResponder];
          return NO;
      }
    if (self.txtQuestionB.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请完善选项信息"];
        [self.txtQuestionB becomeFirstResponder];
        return NO;
    }
    if (self.txtQuestionC.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请完善选项信息"];
        [self.txtQuestionC becomeFirstResponder];
        return NO;
    }
    if (self.txtQuestionD.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请完善选项信息"];
        [self.txtQuestionD becomeFirstResponder];
        return NO;
    }
    //如果是多选 - 验证E
    if ([self.questionType isEqualToString:@"2"]) {
        if (self.btnSelE.selected) {
             if (self.txtQuestionE.text.length <= 0) {
                       [SVProgressHUD showErrorWithStatus:@"选项没有内容不能勾选为正确答案"];
                        return NO;
                   }
        }
           
        if (self.btnSelA.selected || self.btnSelB.selected || self.btnSelC.selected || self.btnSelD.selected || self.btnSelE.selected) {
            NSLog(@"有一个选择");
        } else {
             [SVProgressHUD showErrorWithStatus:@"请勾选正确答案"];
             return NO;
        }
        int countSel = 0;
        if (self.btnSelA.selected) {
            countSel ++;
        }
        if (self.btnSelB.selected) {
            countSel ++;
        }
        if (self.btnSelC.selected) {
            countSel ++;
        }
        if (self.btnSelD.selected) {
            countSel ++;
        }
        if (self.btnSelE.selected) {
            countSel ++;
        }
        if (countSel < 2) {
            [SVProgressHUD showErrorWithStatus:@"多选题应至少有两个正确答案"];
            return NO;
        }
    } else {
        //单选 -
        if (self.btnSelA.selected || self.btnSelB.selected || self.btnSelC.selected || self.btnSelD.selected) {
            NSLog(@"有一个选择");
        } else {
              [SVProgressHUD showErrorWithStatus:@"请勾选正确答案"];
             return NO;
        }
    } 
    
    return YES;
}
- (void)updateFrame {
    self.view2.top = self.view1.bottom + k360Width(16);
    self.view2.height = self.txtTitle.bottom + k360Width(10);
    
    //如果是查看或者是审核 - 去掉插入括号行
    if ([self.isAddType isEqualToString:@"3"] || [self.isAddType isEqualToString:@"4"]) {
        [self.view3 setHidden:YES];
        self.viewA.top = self.view2.bottom + k360Width(16);
        //不可操作
        [self.view1 setUserInteractionEnabled:NO];
        [self.view2 setUserInteractionEnabled:NO];
        [self.view3 setUserInteractionEnabled:NO];
        [self.viewA setUserInteractionEnabled:NO];
        [self.viewB setUserInteractionEnabled:NO];
        [self.viewC setUserInteractionEnabled:NO];
        [self.viewD setUserInteractionEnabled:NO];
        [self.viewE setUserInteractionEnabled:NO];
        [self.view8 setUserInteractionEnabled:NO];
        [self.view9 setUserInteractionEnabled:NO];
        [self.view10 setUserInteractionEnabled:NO];
    } else {
        self.view3.top = self.view2.bottom;
        self.viewA.top = self.view3.bottom + k360Width(16);
    }
    
    self.viewA.height = self.txtQuestionA.bottom + k360Width(5);
    self.btnSelA.centerY = self.txtQuestionA.centerY;
    
    self.viewB.top = self.viewA.bottom;
    self.viewB.height = self.txtQuestionB.bottom + k360Width(5);
    self.btnSelB.centerY = self.txtQuestionB.centerY;
    
    self.viewC.top = self.viewB.bottom;
    self.viewC.height = self.txtQuestionC.bottom + k360Width(5);
    self.btnSelC.centerY = self.txtQuestionC.centerY;
    
    self.viewD.top = self.viewC.bottom;
    self.viewD.height = self.txtQuestionD.bottom + k360Width(5);
    self.btnSelD.centerY = self.txtQuestionD.centerY;
    //多选有E
    if ([self.questionType isEqualToString:@"2"]) {
        self.viewE.top = self.viewD.bottom;
        self.viewE.height = self.txtQuestionE.bottom + k360Width(5);
        self.btnSelE.centerY = self.txtQuestionE.centerY;
        [self.viewE setHidden:NO];
        self.view8.top = self.viewE.bottom + k360Width(16);
    } else {
        [self.viewE setHidden:YES];
        self.view8.top = self.viewD.bottom + k360Width(16);
    }
    self.view9.top = self.view8.bottom;
    self.view10.top = self.view9.bottom + k360Width(16);
    self.view10.height = self.txtDaAn.bottom + k360Width(10);
    
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, self.view10.bottom + k360Width(16))];
    
}
- (void)selBtnAction:(UIButton *)btnSender {
    //单选
    if ([self.questionType isEqualToString:@"1"]) {
        [self.btnSelA setSelected:NO];
        [self.btnSelB setSelected:NO];
        [self.btnSelC setSelected:NO];
        [self.btnSelD setSelected:NO];
        [self.btnSelE setSelected:NO];
        [btnSender setSelected:YES];
    } else {
        [btnSender setSelected:!btnSender.selected];
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
