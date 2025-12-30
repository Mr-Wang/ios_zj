//
//  WY_InfoConsuItingViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/25.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_InfoConsuItingViewController.h"
#import "ImageNewsDetailViewController.h"
#import "LEEStarRating.h"

@interface WY_InfoConsuItingViewController () {
    int lastY;
}
@property (nonatomic ,strong) UILabel *lblName;
@property (nonatomic ,strong) UILabel *lblContent;
@property (nonatomic ,strong) UIImageView *imgHead;
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic , strong) UIView *viewTop;
@property (nonatomic , strong) UIView *viewMiddle;
@property (nonatomic , strong) UIView *viewImages;
@property (nonatomic , strong) IQTextView *txtContent;
@property (nonatomic, strong) LEEStarRating *starRating6;
@end

@implementation WY_InfoConsuItingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self bindView];
}

- (void)makeUI {
    if ([self.nsType isEqualToString:@"2"]) {
        self.title = @"咨询投诉管理";
    } else {
        self.title = @"咨询投诉";
    }
    [self.view setBackgroundColor:HEXCOLOR(0xf0f0f0)];
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:HEXCOLOR(0xf0f0f0)];
    [self.view addSubview:self.mScrollView];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    self.viewTop = [UIView new];
    self.viewImages = [UIView new];
    self.viewMiddle = [UIView new];
    
    [self.viewTop setFrame:CGRectMake(k360Width(0), 0, kScreenWidth, k360Width(44))];

    [self.viewMiddle setFrame:CGRectMake(k360Width(0), 0, kScreenWidth, k360Width(44))];
     
    [self.viewTop setBackgroundColor:[UIColor whiteColor]];
    [self.viewMiddle setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.mScrollView addSubview:self.viewTop];
    [self.mScrollView addSubview:self.viewMiddle];
    
    self.imgHead = [UIImageView new];
    [self.viewTop addSubview:self.imgHead];
    [self.viewTop addSubview:self.viewImages];
    
    self.viewZhuanYe = [UIView new];
    [self.viewTop addSubview:self.viewZhuanYe];

    
    self.lblName = [UILabel new];
    [self.viewTop addSubview:self.lblName];
    
    self.lblContent = [UILabel new];
    [self.viewTop addSubview:self.lblContent];
    
    [self.imgHead setFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(35), k360Width(35))];
    [self.imgHead rounded:k360Width(35/2)];
    [self.lblName setFrame:CGRectMake(self.imgHead.right + k360Width(10), k360Width(16), k360Width(300), k360Width(50))];
    [self.lblName setTextColor:HEXCOLOR(0x7a7a7a)];
    
    self.txtContent = [IQTextView new];
     
    [self.txtContent setPlaceholder:@"请输入问题回复内容"];
    
    if ([self.nsType isEqualToString:@"1"]) {
        if ([self.eqModel.isAnswer isEqualToString:@"1"]) {
            [self.btnSubmit setTitle:@"提交评分" forState:UIControlStateNormal];
            [self.btnSubmit setHidden:NO];
            self.mScrollView.height = kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin - k360Width(50);
        }  else {
            [self.btnSubmit setHidden:YES];
            self.mScrollView.height = kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin;
        }
        [self.txtContent setUserInteractionEnabled:NO];
    } else {
        [self.btnSubmit setTitle:@"提交回复" forState:UIControlStateNormal];
        [self.txtContent setUserInteractionEnabled:YES];
        [self.btnSubmit setHidden:NO];
        self.mScrollView.height = kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin - k360Width(50);
    }

    
}

- (void)bindView {
    [self.viewImages removeAllSubviews];
    
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:self.eqModel.expertPic] placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSString *expertCityStr = @"";
    if (self.eqModel.expertCity !=NULL && ![self.eqModel.expertCity isEqual:[NSNull null]] && ![self.eqModel.expertCity isEqualToString:@""]) {
        expertCityStr = [NSString stringWithFormat:@"\n%@",self.eqModel.expertCity];
    }
    [self.lblName setNumberOfLines:2];
    [self.lblName setText:[NSString stringWithFormat:@"%@   %@%@",self.eqModel.expertName,self.eqModel.expertPhone,expertCityStr]];
     [self.lblName setCenterY:self.imgHead.centerY];

    
    
    
    
    int zyLeft = 0;
    if (self.eqModel.tags.count > 0) {
        [self.viewZhuanYe setFrame:CGRectMake(self.imgHead.right + k360Width(180), 0, k360Width(150), k360Width(44))];
        self.viewZhuanYe.centerY = self.imgHead.centerY;
         [self.viewZhuanYe removeAllSubviews];
        
        for (NSDictionary *dicItem in self.eqModel.tags) {
            UIImageView *imgZy = [UIImageView new];
            [imgZy setFrame:CGRectMake(zyLeft, k360Width(4.5), k360Width(35), k360Width(35))];
             [imgZy sd_setImageWithURL:[NSURL URLWithString:dicItem[@"imgUrl"]]];
            [self.viewZhuanYe addSubview:imgZy];
//            NSArray *arrBuffs = dicItem[@"labels"];
//            if (arrBuffs != nil || arrBuffs.count > 0) {
                UIButton *imgZyBuff = [UIButton new];
                [imgZyBuff setFrame:CGRectMake(zyLeft, k360Width(4.5), k360Width(35), k360Width(35))];
                
                [imgZyBuff sd_setBackgroundImageWithURL:[NSURL URLWithString:dicItem[@"label"][@"imgUrl"]] forState:UIControlStateNormal];
                [self.viewZhuanYe addSubview:imgZyBuff];
//            }
            zyLeft = imgZy.right + k360Width(10);
        }
    }
    
    
    
    [self.lblContent setFrame:CGRectMake(k360Width(16), self.imgHead.bottom + k360Width(10), kScreenWidth - k360Width(32), k360Width(44))];
    NSString *typeStr = @"";
    //类型 1 咨询 2 投诉 3 建议
    switch ([self.eqModel.qaType intValue]) {
        case 1:
        {
            typeStr = @"咨询";
        }
            break;
        case 2:
        {
            typeStr = @"投诉";
        }
            break;
        case 3:
        {
            typeStr = @"建议";
        }
            break;
        default
            :
            break;
    }
    if (self.eqModel.qaCityName == nil || [self.eqModel.qaCityName isEqual:[NSNull null]]) {
        self.eqModel.qaCityName = @"";
    }
    
    
    NSMutableAttributedString *attStrA1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@] [%@] ",typeStr,self.eqModel.qaCityName]];
    [attStrA1 setYy_font:WY_FONTRegular(16)];
    [attStrA1 setYy_color:MSTHEMEColor];
    
    NSMutableAttributedString *attStrA2 = [[NSMutableAttributedString alloc] initWithString:self.eqModel.qaTitle];
    [attStrA2 setYy_font:WY_FONTMedium(16)];
    [attStrA2 setYy_color:HEXCOLOR(0x434343)];
    [attStrA1 appendAttributedString:attStrA2];
    
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@] [%@] %@",typeStr,self.eqModel.qaCityName,self.eqModel.qaTitle]];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",self.eqModel.qaContent]];

    
    NSString *str3 = @"";
    
    if ([self.eqModel.isAnswer isEqualToString:@"1"]) {
        str3 = [NSString stringWithFormat:@"\n提交时间：%@\n回复时间：%@",self.eqModel.qaTime,self.eqModel.answer.anTime];
    } else {
        str3 = [NSString stringWithFormat:@"\n提交时间：%@",self.eqModel.qaTime];
    }
//    self.txtContent.attributedText
    
    NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc] initWithString:str3];
     [attStr3 setYy_font:WY_FONTRegular(14)];
    
     [attStr3 setYy_color:HEXCOLOR(0xB7b7b7)];
    

    
    
    [str2 setYy_color:HEXCOLOR(0x7a7a7a)];
//    [str1 setYy_font:WY_FONTMedium(16)];
    [str2 setYy_font:WY_FONTRegular(14)];
    [attStrA1 appendAttributedString:str2];
    [attStrA1 appendAttributedString:attStr3];

    [attStrA1 setYy_lineSpacing:5];
    [self.lblContent setAttributedText:attStrA1];
    [self.lblContent setNumberOfLines:0];
    [self.lblContent sizeToFit];
    self.lblContent.height += 10;
    if (self.eqModel.qaFile != nil && ![self.eqModel.qaFile isEqual:[NSNull null]] && ![self.eqModel.qaFile isEqualToString:@""]) {
        [self.viewImages setFrame:CGRectMake(0, self.lblContent.bottom + k360Width(10), kScreenWidth, (kScreenWidth - k360Width(16*4)) / 3)];
        int lastX = k360Width(16);
        
        
        NSMutableArray *arrFile = [[NSMutableArray alloc] initWithArray:[self.eqModel.qaFile componentsSeparatedByString:@","]];

        
        for (int i = 0; i < arrFile.count; i ++) {
            UIButton *btnImage = [UIButton new];
             [btnImage setFrame:CGRectMake(lastX, 0, self.viewImages.height, self.viewImages.height)];
            [self.viewImages addSubview:btnImage];
            [btnImage setBackgroundColor:[UIColor systemGrayColor]];
            [btnImage sd_setBackgroundImageWithURL:[NSURL URLWithString:arrFile[i]] forState:UIControlStateNormal];
            [btnImage addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                NSLog(@"点击了图片打开按钮");
                
                NSMutableArray *picModels = [NSMutableArray new];
                for (NSString *imgUrl in arrFile) {
                    IWPictureModel* picModel  = [IWPictureModel new];
                    picModel.nsbmiddle_pic = imgUrl;
                    picModel.nsoriginal_pic = imgUrl;
                    [picModels addObject:picModel];
                }
                ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
                indvController.mIWPictureModel = [picModels objectAtIndex:i];
                indvController.picArr = picModels;
                [self.navigationController pushViewController:indvController animated:YES];
            }];
            lastX = btnImage.right + k360Width(16);
        }
        
        self.viewTop.height = self.viewImages.bottom + k360Width(16);
        
    } else {
        self.viewTop.height = self.lblContent.bottom + k360Width(10);
    }
  
    [self.viewMiddle setFrame:CGRectMake(0, self.viewTop.bottom + k360Width(16), kScreenWidth, k360Width(44))];
    
    lastY = 0 ;
    float textH = k360Width(130);
    if(self.eqModel.answer.anContent.length > 0) {
        self.txtContent.text = self.eqModel.answer.anContent;
        
        textH = [self.eqModel.answer.anContent heightForFont:WY_FONTRegular(14) width:kScreenWidth - k360Width(32)];
        textH += k360Width(10);
    }
    [self initCellTitle:@"问题回复" byTextView:self.txtContent withTextH:textH];
    
    //当前用户 ；
    
    if ([self.nsType isEqualToString:@"1"]) {
        
        //已评论过
        if ([self.eqModel.isAnswer isEqualToString:@"1"]) {
            self.txtContent.text = self.eqModel.answer.anContent;
            //评论过- 不让再评论
            [self.txtContent setUserInteractionEnabled:NO];
            self.starRating6 = [[LEEStarRating alloc] initWithFrame:CGRectMake(k360Width(188), 0, kScreenWidth - k360Width(188 + 16), k360Width(44)) Count:5];
            //已添加评分
            if ([self.eqModel.answer.anRate intValue] > 0) {
                [self byReturnColCellTitle:@"已评分" byStar:self.starRating6 isAcc:NO withBlcok:nil];
                self.starRating6.currentScore = [self.eqModel.answer.anRate intValue];
                [self.starRating6 setUserInteractionEnabled:NO];
                [self.btnSubmit setHidden:YES];
            }else {
                [self byReturnColCellTitle:@"请选择评分" byStar:self.starRating6 isAcc:NO withBlcok:nil];
                //未添加评分
                [self.starRating6 setUserInteractionEnabled:YES];
                //默认5星；
                self.starRating6.currentScore = 5;
            }
        } else {
            //未评论过
            [self.viewMiddle setHidden:YES];

        }
    } else {
        //管理员用户
        //已评论过
        if ([self.eqModel.isAnswer isEqualToString:@"1"]) {
            self.txtContent.text = self.eqModel.answer.anContent;
            //评论过- 不让再评论
            [self.txtContent setUserInteractionEnabled:NO];
            //已添加评分
            if ([self.eqModel.answer.anRate intValue] > 0) {
                self.starRating6 = [[LEEStarRating alloc] initWithFrame:CGRectMake(k360Width(188), 0, kScreenWidth - k360Width(188 + 16), k360Width(44)) Count:5];
                [self byReturnColCellTitle:@"用户评分" byStar:self.starRating6 isAcc:NO withBlcok:nil];
                self.starRating6.currentScore = [self.eqModel.answer.anRate intValue];
                [self.starRating6 setUserInteractionEnabled:NO];
            }else {
                //未添加评分
             }
            [self.btnSubmit setHidden:YES];
        } else {
            //未评论过
        }
    }
     
    if (self.btnSubmit.isHidden) {
        self.mScrollView.height = kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin;

    } else {
        self.mScrollView.height = kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin - k360Width(50);

    }
    self.viewMiddle.height = lastY;
    [self.mScrollView setContentSize:CGSizeMake(kScreenWidth, self.viewMiddle.bottom)];
    
    
}

- (void)initCellTitle:(NSString *)titleStr byTextView:(IQTextView *)withTextView withTextH:(float)withTextH{
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.viewMiddle addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setTextColor:[UIColor grayColor]];
    
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), k360Width(44))];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attStr appendAttributedString:attStr1];
    lblTitle.attributedText = attStr;
    
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    
    
    if ([self.nsType isEqualToString:@"2"]) {
        //管理的 - 加复制功能
        if ([self.eqModel.isAnswer isEqualToString:@"1"]) {
            UIButton *lblFuzhi = [UIButton new];
            [lblFuzhi setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
            [lblFuzhi setFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), k360Width(44))];
            [lblFuzhi setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [lblFuzhi setTitle:@"复制" forState:UIControlStateNormal];
            [lblFuzhi.titleLabel setFont:WY_FONTMedium(12)];
            [lblFuzhi addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                [GlobalConfig paste:withTextView.text];
                [SVProgressHUD showSuccessWithStatus:@"复制成功"];
            }];

            [viewTemp addSubview:lblFuzhi];
        }
    }
    
    [withTextView setFrame:CGRectMake(k360Width(16), lblTitle.bottom, kScreenWidth - k360Width(32), withTextH)];
    [withTextView setFont:WY_FONTRegular(14)];
    
    viewTemp.height = withTextView.bottom + k360Width(16);
    [viewTemp addSubview:withTextView];
    
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 5)];
    [viewTemp addSubview:imgLine];
    viewTemp.height = imgLine.bottom;
    lastY = viewTemp.bottom;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)btnSubmitAction {
    NSLog(@"管理- 回复按钮点击");
    
    if ([self.nsType isEqualToString:@"1"]) {
        //提交评分
        [self submitScore];
    } else {
        //提交回复
        [self submitReply];
    }
     
}
- (void)submitScore {
    
    if (self.starRating6.currentScore <= 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请选择评分"];
        return;
    }
    
    WY_AnswerModel *tempModel = [WY_AnswerModel new];
    tempModel.id = self.eqModel.answer.id;
    tempModel.anRate = [NSString stringWithFormat:@"%.f",self.starRating6.currentScore];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:jg_expertQuestionAnswerRate_HTTP params:nil jsonData:[tempModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 200) {
            [self.view makeToast:res[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];

}
- (void)submitReply {
    if (self.txtContent.text.length <= 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入回复内容"];
        return;
    }
    
    WY_AnswerModel *tempModel = [WY_AnswerModel new];
    tempModel.qaId = self.eqModel.id;
    tempModel.anContent = self.txtContent.text;
    
     
    [[MS_BasicDataController sharedInstance] postWithReturnCode:jg_expertQuestionAnswerQuestion_HTTP params:nil jsonData:[tempModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 200) {
            [self.view makeToast:res[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
}
- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byStar:(LEEStarRating *)withStar isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(44))];
    [self.viewMiddle addSubview:viewTemp];
    
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
