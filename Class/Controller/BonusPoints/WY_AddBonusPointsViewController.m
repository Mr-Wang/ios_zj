//
//  WY_AddBonusPointsViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/12/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AddBonusPointsViewController.h"
#import "LEEStarRating.h"
#import "WY_selPicView.h"
#import "WY_ProfessionModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageNewsDetailViewController.h"
#import "WY_EvaluateModel.h"
#import "SLCustomActivity.h"
#import "MSAlertController.h"

@interface WY_AddBonusPointsViewController ()
{
    int lastY;
    int picIndex;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblMatterType;
@property (nonatomic) int selTypeIndex;
@property (nonatomic, strong) IQTextView *txtContent;
@property (nonatomic ,strong) NSMutableArray *arrZgzs;
@property (nonatomic ,strong) NSMutableArray *arrZgzs2;
@property (nonatomic ,strong) NSMutableArray *arrTypes;
@property (nonatomic ,strong) NSString * qualificationEleId;
@property (nonatomic ,strong) NSString * qualificationEleId2;
@property (nonatomic, strong) UIScrollView *scrollViewZgzs;
@property (nonatomic, strong) UIScrollView *scrollViewZgzs2;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_AddBonusPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    self.selTypeIndex = -1;
    [self makeUI];
    
    
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_rewardCode_HTTP params:nil jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"aaa");
        self.arrTypes = successCallBack;
        [self dataBind];
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
    
//    if ([self.nsType isEqualToString:@"1"]) {
//        // 1是查看 我已评价的内容；zj_getExpertRateDetail_HTTP
//        [self dataBindSource];
//    }
}
- (void)dataBindSource {
    //修改标题名；
    self.title = @"查看我的申诉";
    //隐藏发布按钮
    [self.cancleButton setHidden:YES];
    
    self.txtContent.text = self.mWY_ExpertModel.appeal;
    self.qualificationEleId = self.mWY_ExpertModel.appealAppendix;
    self.qualificationEleId2 = self.mWY_ExpertModel.appealAppendix2;
    [self.txtContent setUserInteractionEnabled:NO];
    self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId componentsSeparatedByString:@","]];
    self.arrZgzs2 = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId2 componentsSeparatedByString:@","]];
    
    [self initZgzsImgsShow];
    
    

}

- (void) makeUI {
    self.title =@"申请奖励加分";
    
    self.cancleButton = [[UIButton alloc] init];
    self.cancleButton.frame = CGRectMake(0, 0, 50, 30);
    [self.cancleButton setTitle:@" 提交申请 " forState:UIControlStateNormal];
    [self.cancleButton.titleLabel setFont:WY_FONT375Medium(12)];
    [self.cancleButton setBackgroundColor:[UIColor whiteColor]];
    [self.cancleButton setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [self.cancleButton rounded:8];
    [self.cancleButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.mScrollView = [UIScrollView new];
    [self.mScrollView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
     [self.view addSubview:self.mScrollView];
//
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0,0,kScreenWidth,k360Width(40));
//    label.numberOfLines = 0;
//    [label setBackgroundColor:HEXCOLOR(0xECF3FD)];
//    [self.mScrollView addSubview:label];
//
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"  温馨提示 : 如您对评价扣分有疑异, 可以发起申诉进行处理" attributes:@{NSFontAttributeName: WY_FONTRegular(12),NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
//
//    label.attributedText = string;

    
    self.lblName = [UILabel new];
    
    self.txtContent = [IQTextView new];
    self.scrollViewZgzs = [UIScrollView new];
    self.scrollViewZgzs2 = [UIScrollView new];
     
    [self.mScrollView addSubview:self.lblName];
     
    
    
}
- (void)dataBind {
//    [self.lblName setFrame:CGRectMake(k360Width(16), k360Width(20), kScreenWidth - k360Width(32), k360Width(44))];
//
//    [self.lblName setText:self.mWY_ExpertModel.name];
//    [self.lblName setFont:WY_FONTMedium(14)];
//    [self.lblName setNumberOfLines:0];
//    [self.lblName sizeToFit];
//
//    if (self.lblName.height < k360Width(44)) {
//        self.lblName.height = k360Width(44);
//    }
//    lastY = self.lblName.bottom + k360Width(16);
////    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:self.mWY_ExpertModel.name isAcc:NO withBlcok:nil];
////    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:@"项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称项目名称" isAcc:NO withBlcok:nil];
//
//    [self  byReturnColCellTitle:@"代理机构：" byLabelStr:self.mWY_ExpertModel.daili isAcc:NO withBlcok:nil];
//
//    if (self.mWY_ExpertModel.time.length > 19) {
//        [self  byReturnColCellTitle:@"集合时间：" byLabelStr:[self.mWY_ExpertModel.time substringToIndex:19] isAcc:NO withBlcok:nil];
//    } else {
//        [self  byReturnColCellTitle:@"集合时间：" byLabelStr:self.mWY_ExpertModel.time isAcc:NO withBlcok:nil];
//    }
//    [self  byReturnColCellTitle:@"集合地点：" byLabelStr:self.mWY_ExpertModel.place isAcc:NO withBlcok:nil];
 
    lastY = 0;//k360Width(44);
    
//    UIImageView *imgLine = [UIImageView new];
//    [imgLine setBackgroundColor:APPLineColor];
//    [imgLine setFrame:CGRectMake(0, lastY + k360Width(16), kScreenWidth, k360Width(3))];
//    [self.mScrollView addSubview:imgLine];
    
//    lastY = imgLine.bottom + k360Width(16);
    self.lblMatterType = [UILabel new];
    self.lblMatterType.text = @"请选择事项类型";
     
    [self byReturnColCellTitle:@"事项类型：" byLabel:self.lblMatterType isAcc:YES withBlcok:^{
        NSLog(@"选择推荐来源");
        NSMutableArray *cityStrArr = [NSMutableArray new];
        for (NSDictionary *dicItem in self.arrTypes) {
            [cityStrArr addObject:dicItem[@"name"]];
        }
        [ActionSheetStringPicker showPickerWithTitle:@"请选择申请加分事项类型" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.lblMatterType.text = selectedValue;
            self.selTypeIndex = selectedIndex;
        } cancelBlock:^(ActionSheetStringPicker *picker) {

        } origin:self.view];
 
//        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择申请加分事项类型" preferredStyle:UIAlertControllerStyleAlert];
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
    [lblJT setText:@"具体内容："];
    [self.mScrollView addSubview:lblJT];
    lastY = lblJT.bottom;
 
    UIView *viewPjBg = [UIView new];
    [viewPjBg setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(280))];
    [viewPjBg setBackgroundColor:HEXCOLOR(0xffffff)];
//    [viewPjBg rounded:8 width:1 color:APPLineColor];
    [self.mScrollView addSubview:viewPjBg];
     
    [self.txtContent setFrame:CGRectMake(k360Width(16), lastY + k360Width(16), kScreenWidth -k360Width(32) , k360Width(80))];
    [self.txtContent setPlaceholder:@"请输入具体内容"];
    [self.txtContent setBackgroundColor:HEXCOLOR(0xfafafa)];
    [self.txtContent setFont:WY_FONTRegular(14)];
    lastY = self.txtContent.bottom;
    
    UILabel *lblZMCL = [UILabel new];
    [lblZMCL setFrame:CGRectMake(k360Width(15), lastY + k360Width(5), kScreenWidth, k360Width(20))];
    [lblZMCL setFont: WY_FONTMedium(14)];
    [lblZMCL setText:@"请上传证明材料（最多3张）："];
    [self.mScrollView addSubview:lblZMCL];
    lastY = lblZMCL.bottom;
    
    [self.scrollViewZgzs setFrame:CGRectMake(k360Width(0), lblZMCL.bottom  + k360Width(5), kScreenWidth - k360Width(0), k375Width(120))];
    self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId componentsSeparatedByString:@","]];

    [self initZgzsImgs];
    [self.mScrollView addSubview:self.txtContent];
    [self.mScrollView addSubview:self.scrollViewZgzs];
    
    UILabel *lblZMCL2 = [UILabel new];
    [lblZMCL2 setFrame:CGRectMake(k360Width(15), self.scrollViewZgzs.bottom, kScreenWidth - k360Width(60+ 30 + 10), k360Width(50))];
    [lblZMCL2 setFont: WY_FONTMedium(14)];
    [lblZMCL2 setText:@"请上传辽宁省综合评标专家库评标专家奖励加分申请表（最多1张）："];
    [lblZMCL2 setNumberOfLines:2];
    [self.mScrollView addSubview:lblZMCL2];
    lastY = lblZMCL2.bottom;
    
    UIButton *btnDownMuBan = [UIButton new];
    [btnDownMuBan setFrame:CGRectMake(lblZMCL2.right + k360Width(10), lblZMCL2.top + k360Width(12), k360Width(60), k360Width(26))];
    [btnDownMuBan rounded:k360Width(40/8)];
    [btnDownMuBan setBackgroundColor:MSTHEMEColor];
    [btnDownMuBan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDownMuBan.titleLabel setFont:WY_FONTMedium(12)];
    [btnDownMuBan setTitle:@"下载模板" forState:UIControlStateNormal];
    [btnDownMuBan addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"分享");
        
        NSURL *shareUrl = [NSURL URLWithString:@"https://www.capass.cn/Avatar/expert_award_apply.pdf"];
        NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
        NSArray*activityItems =@[shareUrl,@"辽宁省综合评标专家库评标专家奖励加分申请表.pdf",dateImg];
        
        SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:@"使用浏览器打开" withActivityImage:dateImg withUrl:shareUrl withType:@"CustomActivity" withShareContext:activityItems];
        NSArray *activities = @[customActivit];
        
        UIActivityViewController *activityVC = nil;
        if  (MH_iOS13_VERSTION_LATER) {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
        } else {
            activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        }
        //        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
        //         activityVC.excludedActivityTypes = @[];
        activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
        //弹出分享的页面
        [self presentViewController:activityVC animated:YES completion:nil];
        // 分享后回调
        
        activityVC.completionWithItemsHandler= ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray*_Nullable returnedItems,NSError*_Nullable activityError) {
            
            if(completed) {
                
                NSLog(@"completed");
                
                //分享成功
                
            }else {
                
                NSLog(@"cancled");
                
                //分享取消
                
            }
            
        };
        
    }];
    [self.mScrollView addSubview:btnDownMuBan];


    
    [self.scrollViewZgzs2 setFrame:CGRectMake(k360Width(0), lblZMCL2.bottom  + k360Width(5), kScreenWidth - k360Width(0), k375Width(120))];
    self.arrZgzs2 = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId2 componentsSeparatedByString:@","]];
    [self initZgzs2Imgs];
    [self.mScrollView addSubview:self.scrollViewZgzs2];
    lastY = self.scrollViewZgzs2.bottom;

//    UIImageView *imgLineA = [[UIImageView alloc] initWithFrame:CGRectMake(0, viewPjBg.bottom + k360Width(16), kScreenWidth, 1)];
//    [self.mScrollView addSubview:imgLineA];
//    [imgLineA setBackgroundColor:APPLineColor];
//    lastY = imgLineA.bottom + k360Width(16);
      
    [self.mScrollView setContentSize:CGSizeMake(0, lastY + k360Width(16))];
}

- (void)addZgzsPicAction {
    //添加资格证书图片；
    picIndex = 1;
    if (self.arrZgzs.count >=3) {
        UIAlertView *alertAction = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加三张申诉图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertAction show];
        return;
    }
//    if (self.addZgzsPicItemBlock) {
//        self.addZgzsPicItemBlock(self);
//    }
    
    NSLog(@"上传照片");
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
        //读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [SVProgressHUD showInfoWithStatus:@"应用相机权限受限,请在设置中启用"];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        [self takePhoto];
    }];
    
    UIAlertAction *alertAct3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *alertAct4 = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LocalPhoto];
    }];
    
    UIAlertControllerStyle alertStyle = UIAlertControllerStyleAlert;
    if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        alertStyle = UIAlertControllerStyleAlert;
    } else {
        alertStyle = UIAlertControllerStyleActionSheet;
    }
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:alertStyle];
    
    [alertControl addAction:alertAct];
    
    [alertControl addAction:alertAct4];
    
    [alertControl addAction:alertAct3];
    
    [self presentViewController:alertControl animated:YES completion:nil];
    
}
- (void)addZgzs2PicAction {
    //添加资格证书图片；
    picIndex = 2;
    if (self.arrZgzs2.count >=1) {
        UIAlertView *alertAction = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加一张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertAction show];
        return;
    }
//    if (self.addZgzsPicItemBlock) {
//        self.addZgzsPicItemBlock(self);
//    }
    
    NSLog(@"上传照片");
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
        //读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [SVProgressHUD showInfoWithStatus:@"应用相机权限受限,请在设置中启用"];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        [self takePhoto];
    }];
    
    UIAlertAction *alertAct3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *alertAct4 = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LocalPhoto];
    }];
    
    UIAlertControllerStyle alertStyle = UIAlertControllerStyleAlert;
    if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        alertStyle = UIAlertControllerStyleAlert;
    } else {
        alertStyle = UIAlertControllerStyleActionSheet;
    }
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:alertStyle];
    
    [alertControl addAction:alertAct];
    
    [alertControl addAction:alertAct4];
    
    [alertControl addAction:alertAct3];
    
    [self presentViewController:alertControl animated:YES completion:nil];
    
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

- (void)btnZgzs2ImgAction:(UIButton *)btnSender {
    //打开图片；
//    if (self.selPicItemBlock) {
//        self.selPicItemBlock(btnSender.tag, self.arrZgzs);
//    }
    
    NSMutableArray *picModels = [NSMutableArray new];
    for (NSString *imgUrl in self.arrZgzs2) {
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
- (void)btnZgzsDelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrZgzs removeObjectAtIndex:btnSender.tag];
    self.qualificationEleId = [self.arrZgzs componentsJoinedByString:@","];

    [self initZgzsImgs];
}
- (void)btnZgzs2DelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrZgzs2 removeObjectAtIndex:btnSender.tag];
    self.qualificationEleId2 = [self.arrZgzs2 componentsJoinedByString:@","];

    [self initZgzs2Imgs];
}
/// 初始化资格证书Imgs
- (void)initZgzsImgs {
    [self.scrollViewZgzs removeAllSubviews];
    
    float lastX = k375Width(12);
     int i = 0;
    for (NSString *imgUrl in self.arrZgzs) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewZgzs addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnZgzsImgAction:) forControlEvents:UIControlEventTouchUpInside];

        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnZgzsDelAction:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
    
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addZgzsPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewZgzs addSubview:tempBtnAdd];
    
    [self.scrollViewZgzs setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
}
- (void)initZgzs2Imgs {
    [self.scrollViewZgzs2 removeAllSubviews];
    
    float lastX = k375Width(12);
     int i = 0;
    for (NSString *imgUrl in self.arrZgzs2) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewZgzs2 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnZgzs2ImgAction:) forControlEvents:UIControlEventTouchUpInside];

        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnZgzs2DelAction:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
    
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addZgzs2PicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewZgzs2 addSubview:tempBtnAdd];
    
    [self.scrollViewZgzs2 setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
}



/// 初始化资格证书Imgs
- (void)initZgzsImgsShow {
    [self.scrollViewZgzs removeAllSubviews];
    
    float lastX = k375Width(12);
     int i = 0;
    for (NSString *imgUrl in self.arrZgzs) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewZgzs addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnZgzsImgAction:) forControlEvents:UIControlEventTouchUpInside];

        [tempBtn.btnDel setHidden:YES];
        i++;
    }
     
    [self.scrollViewZgzs setContentSize:CGSizeMake(lastX + k375Width(20), 0)];
}

/// 初始化资格证书Imgs
- (void)initZgzs2ImgsShow {
    [self.scrollViewZgzs2 removeAllSubviews];
    
    float lastX = k375Width(12);
     int i = 0;
    for (NSString *imgUrl in self.arrZgzs2) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewZgzs2 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnZgzs2ImgAction:) forControlEvents:UIControlEventTouchUpInside];

        [tempBtn.btnDel setHidden:YES];
        i++;
    }
     
    [self.scrollViewZgzs2 setContentSize:CGSizeMake(lastX + k375Width(20), 0)];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {

    }
}
//打开本地相册
-(void)LocalPhoto

{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    //设置右侧取消按钮的字体颜色
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
    
}


- (void)uploadImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    //上传图片
    NSString * str = [GlobalConfig getAbsoluteUrl:EuploadFile_HTTP];
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
    [dicPost setObject:@"" forKey:@"description"];
    
    
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr POST:str parameters:dicPost headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
        [SVProgressHUD ms_dismiss];
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        NSString *picUrl = json[@"data"];
        if (picIndex == 1) {
            [self.arrZgzs addObject:picUrl];
            self.qualificationEleId = [self.arrZgzs componentsJoinedByString:@","];
            [self initZgzsImgs];
            
        } else {
            [self.arrZgzs2 addObject:picUrl];
            self.qualificationEleId2 = [self.arrZgzs2 componentsJoinedByString:@","];
            [self initZgzs2Imgs];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD ms_dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
}


//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [picker dismissViewControllerAnimated:YES completion:nil];
         [self uploadImage:image];
        //关闭相册界面
    }
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBtnAction {
    
    if (self.selTypeIndex == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择事项类型"];
        return;
    }
    
     if (self.txtContent.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入申诉内容"];
        return;
    }
    if (self.arrZgzs.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请至少上传一张证明材料"];
        return;
    }
    if (self.arrZgzs2.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传辽宁省综合评标专家库评标专家奖励加分申请表"];
        return;
    }
    /*
     {
      "rewardTerms": "参加行政监管部门或省级行业协会组织的专项业务知识、岗位技能等培训",
      "sysAttachList": [{
       "sysAttachcol": "1",
       "url": "http://101.200.38.45/lnwlzj/9fca899a65ec44148fa177de8f0e647b.jpg"
      }, {
       "sysAttachcol": "2",
       "url": "http://101.200.38.45/lnwlzj/25c74c3a5cfd487e9cadb5a3373c21ee.jpg"
      }],
      "rewardContent": "ggyy",
      "scoreStandard": "1",
      "rewardTermsCode": "1"
     }
     */
    NSDictionary *dicType = self.arrTypes[self.selTypeIndex];
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.lblMatterType.text forKey:@"rewardTerms"];
    [dicPost setObject:self.txtContent.text forKey:@"rewardContent"];
    [dicPost setObject:dicType[@"code"] forKey:@"rewardTermsCode"];
    [dicPost setObject:dicType[@"scoreStandard"] forKey:@"scoreStandard"];
    NSMutableArray *fileList = [NSMutableArray new];
    for (NSString *imgUrl  in self.arrZgzs) {
        NSMutableDictionary *dicFile = [NSMutableDictionary new];
        [dicFile setObject:@"1" forKey:@"sysAttachcol"];
        [dicFile setObject:imgUrl forKey:@"url"];
        [fileList addObject:dicFile];
    }
    
    for (NSString *imgUrl  in self.arrZgzs2) {
        NSMutableDictionary *dicFile = [NSMutableDictionary new];
        [dicFile setObject:@"2" forKey:@"sysAttachcol"];
        [dicFile setObject:imgUrl forKey:@"url"];
        [fileList addObject:dicFile];
    }
    
    [dicPost setObject:fileList forKey:@"sysAttachList"];
     
    [[MS_BasicDataController sharedInstance] postWithURL:zj_rewardApply_HTTP params:nil jsonData:[dicPost mj_JSONData] showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        
        NSArray *pushVCAry=[self.navigationController viewControllers];
        UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-3];
        [self.navigationController popToViewController:popVC animated:YES];

    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];

    
}


@end
