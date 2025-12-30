//
//  WY_NewEvaluationAgencyViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/12/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_NewEvaluationAgencyViewController.h"
#import "LEEStarRating.h"
#import "WY_selPicView.h"
#import "WY_ProfessionModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageNewsDetailViewController.h"
#import "WY_EvaluateModel.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_AddNewAppealViewController.h"
#import "WY_GrievanceDetailViewController.h"

@interface WY_NewEvaluationAgencyViewController ()
{
    int lastY;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lbl1;
@property (nonatomic, strong) UILabel *lbl2;
@property (nonatomic, strong) UILabel *lbl3;
@property (nonatomic, strong) UILabel *lbl4;

@property (nonatomic, strong) LEEStarRating *starRating1;
@property (nonatomic, strong) LEEStarRating *starRating2;
@property (nonatomic, strong) LEEStarRating *starRating3;
@property (nonatomic, strong) LEEStarRating *starRating4;
@property (nonatomic, strong) LEEStarRating *starRating5;
@property (nonatomic, strong) LEEStarRating *starRating6;
@property (nonatomic, strong) IQTextView *txtContent;
@property (nonatomic ,strong) NSMutableArray *arrZgzs;
@property (nonatomic ,strong) NSString * qualificationEleId;
@property (nonatomic, strong) UIScrollView *scrollViewZgzs;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) NSMutableArray *arrList;
@end

@implementation WY_NewEvaluationAgencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    
    
    [self dataBindSource];
}
- (void)dataBindSource {
    //修改标题名；
    self.title = @"查看我的评价";
    //隐藏发布按钮
    [self.cancleButton setHidden:YES];
    
    [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_bidevaluationGetExpertEvaluate_HTTP params:@{@"drawExpertCode":self.mWY_ExpertModel.drawExportCode} jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        //        WY_EvaluateModel *paramModel = [WY_EvaluateModel modelWithJSON:res[@"data"]];
        self.arrList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[WY_EvaluateModel class] json:res[@"data"]]];
        [self dataBind];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
    
    
}

- (void) makeUI {
    self.title =@"发表评价";
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    self.cancleButton = [[UIButton alloc] init];
    self.cancleButton.frame = CGRectMake(0, 0, 50, 30);
    [self.cancleButton setTitle:@" 发布评价 " forState:UIControlStateNormal];
    [self.cancleButton.titleLabel setFont:WY_FONT375Medium(12)];
    [self.cancleButton setBackgroundColor:[UIColor whiteColor]];
    [self.cancleButton setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [self.cancleButton rounded:8];
    [self.cancleButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    
    
}

- (void)viewReadInit:(UIView *)vrView withTitleStr:(NSString *)titleStr{
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [vrView addSubview:viewBlue1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(viewBlue1.right + k360Width(8), k360Width(0), k360Width(264), k360Width(44));
    label.text = titleStr;
    label.font = WY_FONTMedium(16);
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8/1.0];
    [vrView addSubview:label];
}
- (void)dataBind {
    UIView *viewTzgg = [[UIView alloc] initWithFrame:CGRectMake(0, k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg];
    [self viewReadInit:viewTzgg withTitleStr:@"项目信息："];
    lastY = viewTzgg.bottom;
    
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY, kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    
    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:self.mWY_ExpertModel.name isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"标段名称：" byLabelStr:self.mWY_ExpertModel.bidSectionName isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"评标时间：" byLabelStr:self.mWY_ExpertModel.pbTime isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"评标地点：" byLabelStr:self.mWY_ExpertModel.pbAddress isAcc:NO withBlcok:nil];
    
    int kfCount = 0;
    for (WY_EvaluateModel *eModel in self.arrList) {
        //申诉成功的 - 不统计扣分
        if ([eModel.appealStatus intValue] != 3) {
            kfCount += [eModel.deductPoints intValue];
        }
    }
    
    [self  byReturnColCellTitle:@"评价扣分：" byLabelStr:[NSString stringWithFormat:@"%d分",kfCount] isAcc:NO withBlcok:nil];
    
    
    UIView *viewTzgg1 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg1];
    [self viewReadInit:viewTzgg1 withTitleStr:@"评价扣分信息："];
    lastY = viewTzgg1.bottom;
    
    UIButton *btnJfbz = [UIButton new];
    [btnJfbz setTitle:@"考评记录表" forState:UIControlStateNormal];
    [btnJfbz setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnJfbz setFrame:CGRectMake(kScreenWidth -  k360Width(116), 0, k360Width(100), k360Width(44))];
    [btnJfbz.titleLabel setFont:WY_FONTMedium(14)];
    [btnJfbz setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [btnJfbz setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"考评记录表");
        [self appraisalRecordForm];
        
    }];
    [viewTzgg1 addSubview:btnJfbz];
    
    int indexI = 1;
    //评价扣分信息
    for (WY_EvaluateModel *eModel in self.arrList) {
        [self.mScrollView addSubview:[self kfViewShow:eModel wihtIndex:indexI]];
        indexI ++;
    }
    //评价扣分信息
    [self.mScrollView setContentSize:CGSizeMake(0, lastY + k360Width(16))];
}
-  (void)appraisalRecordForm {
    WY_EvaluateModel *eModel = self.arrList[0];
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mWY_ExpertModel.drawExportCode forKey:@"drawExpertCode"];
    [dicPost setObject:eModel.projectId forKey:@"projectId"];
    
    
    [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_getExpertEvaluateTable_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        NSLog(@"获取数据成功");
        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
        wk.titleStr = @"考评记录表";
        wk.webviewURL = res[@"data"];
        wk.isShare = @"1";
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
        navi.navigationBarHidden = NO;
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navi animated:NO completion:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
    
    
}
- (UIView *)kfViewShow:(WY_EvaluateModel *)eModel wihtIndex:(int) index {
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    int tempLastY = k360Width(5);
    UIControl * colAKF = nil;
    UIControl * colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:[NSString stringWithFormat:@"扣  分  项  %d ：",index] byLabelStr:eModel.deductionName isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    colAKF = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"扣            分：" byLabelStr:[NSString stringWithFormat:@"%@分",eModel.deductPoints] isAcc:NO withBlcok:nil];
    tempLastY = colAKF.bottom;
    
    //appealStatus: Int,//0未读  1已读  2申诉中 3申诉成功 4申诉失败 5二次申诉 6二次申诉成功 7二次申诉失败
    
    NSString *appealStatusStr = @"";
    switch ([eModel.appealStatus intValue]) {
        case 2:
        {
            appealStatusStr = @"申诉中";
        }
            break;
        case 3:
        {
            appealStatusStr = @"申诉成功";
        }
            break;
        case 4:
        {
            appealStatusStr = @"申诉失败";
        }
            break;
        case 5:
        {
            appealStatusStr = @"二次申诉中";
        }
            break;
        case 6:
        {
            appealStatusStr = @"二次申诉成功";
        }
            break;
        case 7:
        {
            appealStatusStr = @"二次申诉失败";
        }
            break;
            
        default:
            break;
    }
    
    if ([eModel.deductionId intValue] <= 3) {
        //迟到
        colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"集  合  时  间：" byLabelStr:eModel.collectedTime isAcc:NO withBlcok:nil];
        tempLastY = colA.bottom;
        colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"签  到  时  间：" byLabelStr:eModel.signTime isAcc:NO withBlcok:nil];
        tempLastY = colA.bottom;
        //- substitute 备选的迟到- 显示评价内容
        if (!eModel.substitute) {
            colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"迟  到  时  长：" byLabelStr:[NSString stringWithFormat:@"%@分",eModel.lateTime] isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
        } else {
            
            colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"评  价  时  间：" byLabelStr:eModel.evaluateTime isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
            if (eModel.appealable) {
                colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉截止时间：" byLabelStr:eModel.appealEndTime isAcc:NO withBlcok:nil];
                tempLastY = colA.bottom;
            }
            
            
            colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"情  况  说  明：" byLabelStr:eModel.deductionReason isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
            
            //appealStatus: Int,//0未读  1已读  2申诉中 3申诉成功 4申诉失败 5二次申诉 6二次申诉成功 7二次申诉失败
            
            if ([eModel.appealStatus intValue] > 1) {
                colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申  诉  状  态：" byLabelStr:appealStatusStr isAcc:NO withBlcok:nil];
                tempLastY = colA.bottom;
            }
        }
        
        
        
    } else {
        colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"评  价  时  间：" byLabelStr:eModel.evaluateTime isAcc:NO withBlcok:nil];
        tempLastY = colA.bottom;
        if (eModel.appealable) {
            colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉截止时间：" byLabelStr:eModel.appealEndTime isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
        }
        colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"情  况  说  明：" byLabelStr:eModel.deductionReason isAcc:NO withBlcok:nil];
        tempLastY = colA.bottom;
        
        //appealStatus: Int,//0未读  1已读  2申诉中 3申诉成功 4申诉失败 5二次申诉 6二次申诉成功 7二次申诉失败
        if ([eModel.appealStatus intValue] > 1) {
            colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申  诉  状  态：" byLabelStr:appealStatusStr isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
        }
    }
    
    
    
    if (eModel.deductionAppendixList.count > 0) {
        int picW = (kfView.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, tempLastY + k360Width(5), kfView.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in eModel.deductionAppendixList) {
            UIButton *btnPic = [UIButton new];
            [btnPic setFrame:CGRectMake(btnPicX, 0, picW, picW )];
            if ([picUrl rangeOfString:@".pdf"].length > 0) {
                //                pdf
                [btnPic setBackgroundImage:[UIImage imageNamed:@"pdf"] forState:UIControlStateNormal];
                //是pdf
                [btnPic addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
                    wk.titleStr = @"查看附件";
                    wk.webviewURL = picUrl;
                    wk.isShare = @"1";
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
                    navi.navigationBarHidden = NO;
                    navi.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:navi animated:NO completion:nil];
                }];
            } else {
                [btnPic sd_setBackgroundImageWithURL:[NSURL URLWithString:picUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1107load"]];
                //是图片
                [btnPic addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    IWPictureModel* picModel  = [IWPictureModel new];
                    picModel.nsbmiddle_pic = picUrl;
                    picModel.nsoriginal_pic = picUrl;
                    
                    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
                    indvController.mIWPictureModel = picModel;
                    indvController.picArr = @[picModel];
                    [self.navigationController pushViewController:indvController animated:YES];
                }];
            }
            [viewPic addSubview:btnPic];
            btnPicX = btnPic.right+k360Width(5);
        }
        [kfView addSubview:viewPic];
        tempLastY = viewPic.bottom;
    }
    //    appealStatus  0未读  1已读  2申诉中 3申诉成功 4申诉失败 - deductionId<3 是迟到 不可以申诉
    UIButton *btnWySs = nil;
    if (eModel.appealable) {
        //显示申诉按钮  --
        btnWySs = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(265), colAKF.top, k360Width(65), k360Width(26))];
        [btnWySs rounded:k360Width(30/8)];
        [btnWySs.titleLabel setFont:WY_FONTMedium(12)];
        [btnWySs setBackgroundColor:MSTHEMEColor];
        if ([eModel.appealStatus intValue] == 4) {
            //如果是申诉失败 - 显示二次申诉；
            [btnWySs setTitle:@"二次申诉" forState:UIControlStateNormal];
        } else {
            [btnWySs setTitle:@"我要申诉" forState:UIControlStateNormal];
        }
        
        [btnWySs addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            //进入我要申诉页
            WY_AddNewAppealViewController *tempController = [WY_AddNewAppealViewController new];
            tempController.mWY_ExpertModel = eModel;
            [self.navigationController pushViewController:tempController animated:YES];
        }];
        [kfView addSubview:btnWySs];
    }
    
    if ([eModel.appealStatus intValue] > 1) {
        //如果有申诉过- 显示申诉详情按钮；
        UIButton *btnSs = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(265), colAKF.top, k360Width(65), k360Width(26))];
        [btnSs rounded:k360Width(30/8)];
        [btnSs.titleLabel setFont:WY_FONTMedium(12)];
        [btnSs setBackgroundColor:MSTHEMEColor];
        [btnSs setTitle:@"申诉详情" forState:UIControlStateNormal];
        [btnSs addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            //进入我要申诉页
            WY_GrievanceDetailViewController *tempController = [WY_GrievanceDetailViewController new];
            tempController.eID = eModel.id;
            [self.navigationController pushViewController:tempController animated:YES];
        }];
        [kfView addSubview:btnSs];
        if (btnWySs) {
            btnWySs.right = btnSs.left - k360Width(10);
        }
    }
    
    kfView.height = tempLastY + k360Width(5);
    [kfView setBackgroundColor:[UIColor whiteColor]];
    [kfView rounded:5];
    lastY = kfView.bottom + k360Width(10);
    return kfView;
}

- (UIControl *)byReturnColCellByView:(UIView *)withView ByLastY:(int )withY Title:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, withY, self.mScrollView.width, k360Width(50))];
    [withView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:HEXCOLOR(0x000000)];
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
    withY = viewTemp.bottom;
    return viewTemp;
}


- (void)btnZgzsImgAction:(UIButton *)btnSender {
    //打开图片；
    //    if (self.selPicItemBlock) {
    //        self.selPicItemBlock(btnSender.tag, self.arrZgzs);
    //    }
    
    NSMutableArray *picModels = [NSMutableArray new];
    for (NSString *imgUrl in self.arrZgzs) {
        IWPictureModel* picModel  = [IWPictureModel new];
        picModel.nsbmiddle_pic = imgUrl;
        picModel.nsoriginal_pic = imgUrl;
        [picModels addObject:picModel];
    }
    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
    indvController.mIWPictureModel = [picModels objectAtIndex:btnSender.tag];
    indvController.picArr = picModels;
    [self.navigationController pushViewController:indvController animated:YES];
    
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

- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(16), k360Width(22))];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:HEXCOLOR(0x000000)];
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


- (void)rightBtnAction {
    if (self.starRating1.currentScore <= 0 ||
        self.starRating2.currentScore <= 0 ||
        self.starRating3.currentScore <= 0 ||
        self.starRating4.currentScore <= 0 ||
        self.starRating5.currentScore <= 0 ||
        self.starRating6.currentScore <= 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请选择评分"];
        return;
    }
    if (self.txtContent.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入评价内容"];
        return;
    }
    
    //    zj_insertRate_HTTP
    
    
    WY_EvaluateModel *paramModel = [WY_EvaluateModel new];
    paramModel.id = self.mWY_ExpertModel.id;
    paramModel.expertIdCard = self.mWY_ExpertModel.zjidcard;
    //     项目编号
    paramModel.tenderProjectCode = self.mWY_ExpertModel.tenderProjectCode;
    paramModel.tenderProjectName = self.mWY_ExpertModel.name;
    paramModel.agencyName = self.mWY_ExpertModel.daili;
    //    代理机构代码
    paramModel.agencyCode = self.mWY_ExpertModel.agencyCode;
    paramModel.bidSectionName = self.mWY_ExpertModel.bidSectionName;
    paramModel.bidSectionCode = self.mWY_ExpertModel.bidSectionCodes;
    paramModel.bidEvaluationAddress = self.mWY_ExpertModel.place;
    paramModel.bidEvaluationTime = self.mWY_ExpertModel.time;
    
    //    公司形象打分
    paramModel.companyImage = [NSString stringWithFormat:@"%.f",self.starRating1.currentScore];
    //    评标现场组织能力打分
    paramModel.organizationalSkills = [NSString stringWithFormat:@"%.f",self.starRating2.currentScore];
    //    所评项目业务掌握能力打分
    paramModel.operationalCapacity = [NSString stringWithFormat:@"%.f",self.starRating3.currentScore];
    //    服务态度打分
    paramModel.serviceAttitude = [NSString stringWithFormat:@"%.f",self.starRating4.currentScore];
    //    工作效率打分
    paramModel.workEfficiency = [NSString stringWithFormat:@"%.f",self.starRating5.currentScore];
    //    综合分
    paramModel.averageScore = [NSString stringWithFormat:@"%.f",self.starRating6.currentScore];
    //评价文字
    paramModel.rateText = self.txtContent.text;
    
    
    paramModel.images  = self.qualificationEleId;
    
    
    NSLog(@"JSON:%@",[paramModel toJSONString]);
    [[MS_BasicDataController sharedInstance] postWithURL:zj_insertRate_HTTP params:nil jsonData:[paramModel toJSONData] showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
    
    
}
@end
