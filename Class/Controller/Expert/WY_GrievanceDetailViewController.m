//
//  WY_GrievanceDetailViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/12/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_GrievanceDetailViewController.h"
#import "LEEStarRating.h"
#import "WY_selPicView.h"
#import "WY_ProfessionModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageNewsDetailViewController.h"
#import "WY_EvaluateModel.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_AddNewAppealViewController.h"

@interface WY_GrievanceDetailViewController ()
{
    int lastY;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic ,strong) NSString * qualificationEleId;
@property (nonatomic, strong) NSMutableArray *arrList;
@end

@implementation WY_GrievanceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self dataBindSource];
}
- (void)dataBindSource {
    //修改标题名；
    self.title = @"申诉详情";
    
        [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_getExpertEvaluateById_HTTP params:@{@"id":self.eID} jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            self.mWY_ExpertModel = [WY_ExpertModel modelWithJSON:res[@"data"]];
            [self dataBind];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
        }];
    
    
}

- (void) makeUI {
    self.title =@"发表评价";
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
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
    
    [self kfTopViewShow:self.mWY_ExpertModel];
    
    UIView *viewTzgg1 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg1];
    [self viewReadInit:viewTzgg1 withTitleStr:@"申诉附件："];
    lastY = viewTzgg1.bottom;
    int indexI = 1;
    //评价扣分信息
    [self kfViewShow:self.mWY_ExpertModel wihtIndex:indexI];
    //评价扣分信息
    
    UIView *viewTzgg2 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg2];
    [self viewReadInit:viewTzgg2 withTitleStr:@"申诉回复："];
    lastY = viewTzgg2.bottom;
    
    
    [self kfBottomViewShow:self.mWY_ExpertModel];
    
    //有二次申诉的内容
    if ([self.mWY_ExpertModel.appealStatus intValue] > 4) {
        [self onceMoreKFBottomViewShow:self.mWY_ExpertModel];
    }
    
    [self.mScrollView setContentSize:CGSizeMake(0, lastY + k360Width(16))];
}
- (UIView *)kfTopViewShow:(WY_ExpertModel *)eModel {
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    int tempLastY = k360Width(5);
    
    UIControl * colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"项目名称：" byLabelStr:self.mWY_ExpertModel.projectName isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"标段名称：" byLabelStr:self.mWY_ExpertModel.bidSectionName isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"评标时间：" byLabelStr:self.mWY_ExpertModel.bidEvaluatedTime isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"评标地点：" byLabelStr:self.mWY_ExpertModel.bidEvaluatedAddress isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    kfView.height = tempLastY + k360Width(5);
    [kfView setBackgroundColor:[UIColor whiteColor]];
    [kfView rounded:5];
    lastY = kfView.bottom + k360Width(10);
    return kfView;
}


- (void)onceMoreKFBottomViewShow:(WY_ExpertModel *)eModel {
    
    UIView *viewTzgg1 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg1];
    [self viewReadInit:viewTzgg1 withTitleStr:@"二次申诉附件："];
    lastY = viewTzgg1.bottom;
    int indexI = 1;
    //评价扣分信息
    [self onceMorekfViewShow:self.mWY_ExpertModel wihtIndex:indexI];
    //评价扣分信息
    
    UIView *viewTzgg2 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg2];
    [self viewReadInit:viewTzgg2 withTitleStr:@"二次申诉回复："];
    lastY = viewTzgg2.bottom;
    
    [self ECkfBottomViewShow:self.mWY_ExpertModel];
}

- (UIView *)onceMorekfViewShow:(WY_ExpertModel *)eModel wihtIndex:(int) index {
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    int tempLastY = k360Width(5);
    UIControl * colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉条目：" byLabelStr:eModel.deductionName isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"扣      分：" byLabelStr:[NSString stringWithFormat:@"%@分",eModel.deductPoints] isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉时间：" byLabelStr:eModel.appealTime2 isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉内容：" byLabelStr:eModel.appeal2 isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    
    NSMutableArray *appealAppendixs = [[NSMutableArray alloc] initWithArray:[eModel.appealAppendix2 componentsSeparatedByString:@","]];
    
    if (appealAppendixs.count > 0) {
        int picW = (kfView.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, tempLastY + k360Width(5), kfView.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in appealAppendixs) {
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
    kfView.height = tempLastY + k360Width(5);
    [kfView setBackgroundColor:[UIColor whiteColor]];
    [kfView rounded:5];
    lastY = kfView.bottom + k360Width(10);
    return kfView;
}


- (UIView *)kfViewShow:(WY_ExpertModel *)eModel wihtIndex:(int) index {
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    int tempLastY = k360Width(5);
    UIControl * colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉条目：" byLabelStr:eModel.deductionName isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"扣      分：" byLabelStr:[NSString stringWithFormat:@"%@分",eModel.deductPoints] isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉时间：" byLabelStr:eModel.appealTime isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉内容：" byLabelStr:eModel.appeal isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    
    NSMutableArray *appealAppendixs = [[NSMutableArray alloc] initWithArray:[eModel.appealAppendix componentsSeparatedByString:@","]];
    
    if (appealAppendixs.count > 0) {
        int picW = (kfView.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, tempLastY + k360Width(5), kfView.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in appealAppendixs) {
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
    kfView.height = tempLastY + k360Width(5);
    [kfView setBackgroundColor:[UIColor whiteColor]];
    [kfView rounded:5];
    lastY = kfView.bottom + k360Width(10);
    return kfView;
}



- (UIView *)ECkfBottomViewShow:(WY_ExpertModel *)eModel {
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    int tempLastY = k360Width(5);
    
    
    
    NSString *statusStr = @"";
    switch ([self.mWY_ExpertModel.appealStatus intValue]) {
        case 0:
        {
            statusStr = @"未读";
        }
            break;
        case 1:
        {
            statusStr = @"已读";
        }
            break;
        case 2:
        {
            statusStr = @"申诉中";
        }
            break;
        case 3:
        {
            statusStr = @"申诉成功";
        }
            break;
        case 4:
        {
            statusStr = @"申诉失败";
        }
            break;
        case 5:
        {
            statusStr = @"二次申诉中";
        }
            break;
        case 6:
        {
            statusStr = @"二次申诉成功";
        }
            break;
        case 7:
        {
            statusStr = @"二次申诉失败";
        }
            break;
        default:
        {
            statusStr = @"未知状态";
        }
            break;
    }
    UIControl * colA = nil;
    if ([self.mWY_ExpertModel.appealStatus intValue] > 2) {
        if ([self.mWY_ExpertModel.appealReplyTime2 isNotBlank]) {
            colA =[self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"回复时间：" byLabelStr:self.mWY_ExpertModel.appealReplyTime2 isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
        }
        if ([self.mWY_ExpertModel.appealReply2 isNotBlank]) {
            colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"回复内容：" byLabelStr:self.mWY_ExpertModel.appealReply2 isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
        }
    }
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉状态：" byLabelStr:statusStr isAcc:NO withBlcok:nil];
    
    tempLastY = colA.bottom;
    
    NSMutableArray *appealAppendixs = [[NSMutableArray alloc] initWithArray:[eModel.appealAppendJgUrl2 componentsSeparatedByString:@","]];
    
    if (appealAppendixs.count > 0) {
        
        colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"意见材料：" byLabelStr:@"" isAcc:NO withBlcok:nil];
        tempLastY = colA.bottom;

        int picW = (kfView.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, tempLastY + k360Width(5), kfView.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in appealAppendixs) {
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
    
    
    
    
    kfView.height = tempLastY + k360Width(5);
    [kfView setBackgroundColor:[UIColor whiteColor]];
    [kfView rounded:5];
    lastY = kfView.bottom + k360Width(10);
    return kfView;
}
- (UIView *)kfBottomViewShow:(WY_ExpertModel *)eModel {
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    int tempLastY = k360Width(5);
    
    
    
    NSString *statusStr = @"";
    switch ([self.mWY_ExpertModel.appealStatus intValue]) {
        case 0:
        {
            statusStr = @"未读";
        }
            break;
        case 1:
        {
            statusStr = @"已读";
        }
            break;
        case 2:
        {
            statusStr = @"申诉中";
        }
            break;
        case 3:
        {
            statusStr = @"申诉成功";
        }
            break;
        case 4:
        {
            statusStr = @"申诉失败";
        }
            break;
        default:
        {
            statusStr = @"申诉失败";
        }
            break;
    }
    UIControl * colA = nil;
    if ([self.mWY_ExpertModel.appealStatus intValue] > 2) {
        if ([self.mWY_ExpertModel.appealReplyTime isNotBlank]) {
            colA =[self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"回复时间：" byLabelStr:self.mWY_ExpertModel.appealReplyTime isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
        }
        if (![self.mWY_ExpertModel.appealReply isEqual:[NSNull null]] &&  [self.mWY_ExpertModel.appealReply isNotBlank]) {
            colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"回复内容：" byLabelStr:self.mWY_ExpertModel.appealReply isAcc:NO withBlcok:nil];
            tempLastY = colA.bottom;
        }
    }
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"申诉状态：" byLabelStr:statusStr isAcc:NO withBlcok:nil];
     
    tempLastY = colA.bottom;
    
    NSMutableArray *appealAppendixs = [[NSMutableArray alloc] initWithArray:[eModel.appealAppendJgUrl componentsSeparatedByString:@","]];
    
    if (appealAppendixs.count > 0) {
        
        colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"意见材料：" byLabelStr:@"" isAcc:NO withBlcok:nil];
        tempLastY = colA.bottom;

        int picW = (kfView.width - k360Width(20*4)) / 4;
        UIView *viewPic = [UIView new];
        [viewPic setFrame:CGRectMake(0, tempLastY + k360Width(5), kfView.width , picW)];
        int btnPicX = k360Width(17);
        for (NSString *picUrl in appealAppendixs) {
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
    
    
    
    
    //显示二次申诉按钮
    if ([self.mWY_ExpertModel.appealStatus intValue] == 4) {
        WS(weakSelf);
        UIButton *btnSs = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(265), tempLastY - k360Width(26), k360Width(65), k360Width(26))];
        [btnSs rounded:k360Width(30/8)];
        [btnSs.titleLabel setFont:WY_FONTMedium(12)];
        [btnSs setBackgroundColor:MSTHEMEColor];
        [btnSs setTitle:@"二次申诉" forState:UIControlStateNormal];
        [btnSs addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            //进入我要申诉页
            WY_AddNewAppealViewController *tempController = [WY_AddNewAppealViewController new];
            tempController.mWY_ExpertModel = self.mWY_ExpertModel;
            [weakSelf.navigationController pushViewController:tempController animated:YES];
        }];
        [kfView addSubview:btnSs];
        tempLastY = btnSs.bottom;
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
    [viewTemp setFrame:CGRectMake(0, withY, withView.width, k360Width(44))];
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

@end
