//
//  WY_AddPjViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/12/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AddPjViewController.h"
#import "LEEStarRating.h"
#import "WY_selPicView.h"
#import "WY_ProfessionModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageNewsDetailViewController.h"
#import "WY_EvaluateModel.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_AddNewAppealViewController.h"
#import "WY_GuestBookModel.h"

@interface WY_AddPjViewController ()
{
    int lastY;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic ,strong) NSString * qualificationEleId;
@property (nonatomic, strong) NSMutableArray *arrList;

@property (nonatomic, strong) IQTextView *txtContent;
@property (nonatomic ,strong) NSMutableArray *arrTypes;
@property (nonatomic, strong) UILabel *lblMatterType;
@property (nonatomic) int selTypeIndex;
@property (nonatomic ,strong) UIButton *btnSubmit;
@property (nonatomic ,strong) UIButton *btnUp;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_AddPjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mUser  = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    [self makeUI];
    if ([self.nsType isEqualToString:@"1"]) {
        [self dataBindSource];
    } else {
        [self makeAddView];
    }
    
}
- (void)dataBindSource {
    //修改标题名；
    self.title = @"评价详情";

    [[MS_BasicDataController sharedInstance] getWithReturnCode:getTrainmessagenew_HTTP params:@{@"classGuid":self.mWY_TrainItemModel.ClassGuid,@"pxbs":@"1",@"pageItemNum":@"10",@"currentPage":@"1",@"idcardnum":self.mUser.idcardnum} jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            self.mpjModel = [WY_TrainItemModel modelWithJSON:res[@"data"][@"data"][0]];
            [self dataBind];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
        }];
    
    
}
- (void)makeAddView {
    //修改标题名；
    self.title = @"添加评价";
    self.selTypeIndex = -1;
    
    lastY = 0;//k360Width(44);
     
    self.lblMatterType = [UILabel new];
    self.lblMatterType.text = @"请选择评价选项";
     
    [self byReturnColCellTitle:@"评价选项：" byLabel:self.lblMatterType isAcc:YES withBlcok:^{
        NSLog(@"选择推荐来源");
        NSMutableArray *cityStrArr = [NSMutableArray new];
        [cityStrArr addObject:@"非常满意"];
        [cityStrArr addObject:@"满意"];
        [cityStrArr addObject:@"一般"];
//        for (NSDictionary *dicItem in self.arrTypes) {
//            
//        }
        [ActionSheetStringPicker showPickerWithTitle:@"请选择评价选项" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.lblMatterType.text = selectedValue;
            self.selTypeIndex = selectedIndex;
        } cancelBlock:^(ActionSheetStringPicker *picker) {

        } origin:self.view];
 
//        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择评价选项" preferredStyle:UIAlertControllerStyleAlert];
//
//        [[UILabel appearanceWhenContainedIn:[UIAlertController class], nil] setNumberOfLines:2];
//        [[UILabel appearanceWhenContainedIn:[UIAlertController class], nil] setFont:[UIFont systemFontOfSize:9.0]];
//
//
//        for (NSDictionary *dicItem in self.arrTypes) {
////            [cityStrArr addObject:dicItem[@"name"]];
//            [alertControl addAction:[UIAlertAction actionWithTitle:dicItem[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                self.lblMatterType.text = dicItem[@"name"];
//                self.selTypeIndex = [self.arrTypes indexOfObject:dicItem];
//            }]];
//        }
//        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:alertControl animated:YES completion:nil];

//        MSAlertController *mAlert = [MSAlertController alertControllerWithArray:self.arrTypes];
//        [mAlert showViewController:self sender:self];
     }];
    
    

    UILabel *lblJT = [UILabel new];
    [lblJT setFrame:CGRectMake(k360Width(15), lastY, kScreenWidth, k360Width(20))];
    [lblJT setFont: WY_FONTMedium(14)];
    [lblJT setText:@"建议意见："];
    [self.mScrollView addSubview:lblJT];
    lastY = lblJT.bottom;
 
    UIView *viewPjBg = [UIView new];
    [viewPjBg setFrame:CGRectMake(k360Width(16), lastY + k360Width(16), kScreenWidth - k360Width(32), k360Width(280))];
    [viewPjBg setBackgroundColor:HEXCOLOR(0xfafafa)];
    [viewPjBg rounded:8 width:1 color:APPLineColor];
    [self.mScrollView addSubview:viewPjBg];
    
    UIImageView *imgEdit = [UIImageView new];
    [imgEdit setFrame:CGRectMake(k360Width(32), lastY + k360Width(32), k360Width(17), k360Width(17))];
    [imgEdit setImage:[UIImage imageNamed:@"1211_edit"]];
    [self.mScrollView addSubview:imgEdit];
    
    UILabel *lblEdit = [UILabel new];
    [lblEdit setFrame:CGRectMake(imgEdit.right + k360Width(5), imgEdit.top, k360Width(230), k360Width(17))];
    [lblEdit setText:@"课程结束，请对本次课程进行评价！"];
    [lblEdit setFont:WY_FONT375Regular(14)];
    [lblEdit setTextColor:HEXCOLOR(0xC9C9C9)];
    [self.mScrollView addSubview:lblEdit];
    
    self.txtContent = [IQTextView new];
    [self.txtContent setFrame:CGRectMake(k360Width(32), lblEdit.bottom + k360Width(16), kScreenWidth -k360Width(64) , k360Width(210))];
    [self.txtContent setPlaceholder:@"请输入建议意见"];
    [self.txtContent setBackgroundColor:HEXCOLOR(0xfafafa)];
    [self.txtContent setFont:WY_FONTRegular(14)];
    [self.mScrollView addSubview:self.txtContent];
    lastY = viewPjBg.bottom + k360Width(10);
//    UIView *viewPjBg = [UIView new];
//    [viewPjBg setFrame:CGRectMake(k360Width(16), lastY+k360Width(8), kScreenWidth - k360Width(32), k360Width(280))];
//    [viewPjBg setBackgroundColor:HEXCOLOR(0xfafafa)];
//    [viewPjBg rounded:8 width:1 color:APPLineColor];
//    [self.mScrollView addSubview:viewPjBg];
//     
//    [self.txtContent setFrame:CGRectMake(k360Width(16), lastY + k360Width(16), kScreenWidth -k360Width(32) , k360Width(80))];
//    [self.txtContent setPlaceholder:@"请输入建议意见"];
//    [self.txtContent setBackgroundColor:HEXCOLOR(0xfafafa)];
//    [self.txtContent setFont:WY_FONTRegular(14)];
//    lastY = self.txtContent.bottom;
//    [self.mScrollView addSubview:self.txtContent];
    
    self.btnUp = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(15), lastY + k375Width(44), (kScreenWidth - k375Width(15*3)) / 2, k360Width(44))];
    [self.btnUp setTitle:@"取 消" forState:UIControlStateNormal];
    [self.btnUp setBackgroundColor:MSTHEMEColor];
    [self.btnUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnUp rounded:k360Width(44)/8];
    [self.btnUp.titleLabel setFont:WY_FONTMedium(14)];

    [self.btnUp addTarget:self action:@selector(btnUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mScrollView addSubview:self.btnUp];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(self.btnUp.right + k375Width(15), lastY + k375Width(44), (kScreenWidth - k375Width(15*3)) / 2, k360Width(44))];
    [self.btnSubmit setTitle:@"提 交" forState:UIControlStateNormal];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mScrollView addSubview:self.btnSubmit];
    
    
}
- (void)btnUpAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnSubmitAction {
    NSLog(@"点击了提交");
    
    if (self.selTypeIndex == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择评价选项"];
        return;
    }
    
    NSMutableArray *cityStrArr = [NSMutableArray new];
    [cityStrArr addObject:@"非常满意"];
    [cityStrArr addObject:@"满意"];
    [cityStrArr addObject:@"一般"];
    
    WY_GuestBookModel *mesModel = [WY_GuestBookModel new];
    mesModel.classGuid = self.mWY_TrainItemModel.ClassGuid;
    mesModel.content = self.txtContent.text;
    mesModel.pxxx = cityStrArr[self.selTypeIndex];
    mesModel.idcardnum = self.mUser.idcardnum;
    mesModel.danWeiName = self.mUser.DanWeiName;
    mesModel.phone = self.mUser.LoginID;
    mesModel.name = self.mUser.realname;
    mesModel.pxbs = @"1";
     
    [[MS_BasicDataController sharedInstance] postWithURL:insetTTrainmessage_HTTP params:nil jsonData:[mesModel toJSONData] showProgressView:YES success:^(id successCallBack) {
        MSLog(@"添加评价成功");
        
        [SVProgressHUD showSuccessWithStatus:@"添加评价成功"];
        [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
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
    [self viewReadInit:viewTzgg withTitleStr:@"课程信息："];
    lastY = viewTzgg.bottom;
    
    [self kfTopViewShow:self.mWY_TrainItemModel];
    
    UIView *viewTzgg1 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg1];
    [self viewReadInit:viewTzgg1 withTitleStr:@"评价信息："];
    lastY = viewTzgg1.bottom;
    
    int indexI = 1;
    //评价扣分信息
    [self kfViewShow:self.mpjModel wihtIndex:indexI];
//    //评价扣分信息
//    
//    UIView *viewTzgg2 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
//    [self.mScrollView addSubview:viewTzgg2];
//    [self viewReadInit:viewTzgg2 withTitleStr:@"申诉回复："];
//    lastY = viewTzgg2.bottom;
//    
//    
//    [self kfBottomViewShow:self.mWY_TrainItemModel];
    
 
    
    [self.mScrollView setContentSize:CGSizeMake(0, lastY + k360Width(16))];
}
- (UIView *)kfTopViewShow:(WY_TrainItemModel *)eModel {
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    int tempLastY = k360Width(5);
    
    UIControl * colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"课程名称：" byLabelStr:self.mWY_TrainItemModel.Title isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
  
    kfView.height = tempLastY + k360Width(5);
    [kfView setBackgroundColor:[UIColor whiteColor]];
    [kfView rounded:5];
    lastY = kfView.bottom + k360Width(10);
    return kfView;
}

- (UIView *)kfViewShow:(WY_TrainItemModel *)eModel wihtIndex:(int) index {
    UIView *kfView = [UIView new];
    [kfView setFrame:CGRectMake(k360Width(10), lastY + k360Width(5), kScreenWidth - k360Width(20), 0)];
    [self.mScrollView addSubview:kfView];
    int tempLastY = k360Width(5);
    UIControl * colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"评价选项：" byLabelStr:eModel.pxxx isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
  
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"意见建议：" byLabelStr:eModel.content isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    colA = [self byReturnColCellByView:kfView ByLastY:tempLastY Title:@"评价时间：" byLabelStr:eModel.userCreateTime isAcc:NO withBlcok:nil];
    tempLastY = colA.bottom;
    
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

- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel isAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor clearColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, self.mScrollView.width, k360Width(80))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(120), k360Width(80))];
    lblTitle.text = titleStr;
     [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
 
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
    
 
    [withLabel setFrame:CGRectMake(k360Width(120), 0,viewTemp.width - k360Width(120 + 5) - accLeft, k360Width(80))];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextAlignment:NSTextAlignmentRight];
    [withLabel setFont:WY_FONTRegular(14)];
    
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
