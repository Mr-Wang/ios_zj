//
//  WY_ExpenseObjectionViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/6.
//  Copyright © 2022 王杨. All rights reserved.
//

#import "WY_ExpenseObjectionViewController.h"
#import "WY_SettlementRecordViewController.h"
#import "WY_ExpenseObjectionViewController.h"
#import "MS_WKwebviewsViewController.h"
#import "WY_selPicView.h"
 
#import "WY_SelMajorView.h"
#import "ImageNewsDetailViewController.h"
#import "WY_ParamExpertModel.h"
#import "SLCustomActivity.h"
#import <AVFoundation/AVFoundation.h>
#import "OP_ImageShowViewController.h"

@interface WY_ExpenseObjectionViewController () {
    int lastY;
    int zk1;
    int zk2;
    NSString *picType;
}
@property (nonatomic ,strong) UIScrollView *mScrollView;
@property (nonatomic ,strong) UILabel *lblState;
@property (nonatomic ,strong) UIButton *btnSubmit;
@property (nonatomic , strong) IQTextView *txtContent;
@property (nonatomic , strong) UIView *viewTop1;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop1;
@property (nonatomic , strong) NSMutableArray *arrEttachmentUrl;
@property (nonatomic , strong) NSString * strtxtContent;
@end

@implementation WY_ExpenseObjectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self dataSource];
}
- (void)makeUI {
    self.title = @"费用异议";
    [self.view setBackgroundColor:[UIColor whiteColor]];
     
    
    self.mScrollView = [UIScrollView new];
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.mScrollView];
    
    self.lblState = [UILabel new];
    [self.lblState setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(33))];
    [self.lblState setBackgroundColor:HEXCOLOR(0xfef2e7)];
    [self.lblState setTextColor:HEXCOLOR(0xfdad41)];
    [self.lblState setFont:WY_FONTMedium(14)];
    [self.view addSubview:self.lblState];
    
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"提交异议" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    
}

- (void)dataSource {
    zk1 = 1;
    zk2= 1;
    self.arrEttachmentUrl = [NSMutableArray new];
    self.strtxtContent = @"";
    [self bindView];
}
- (void)bindView {
    self.lblState.text = @"  当前状态：待结算";
    
    [self.mScrollView removeAllSubviews];
    UIView *viewTzgg = [[UIView alloc] initWithFrame:CGRectMake(0, self.lblState.bottom + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzgg];
    [self viewReadInit:viewTzgg withTitleStr:@"项目信息："];
    
    lastY = viewTzgg.bottom;
    [self  byReturnColCellTitle:@"评标类型：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"项目名称：" byLabelStr:@"国家卫健委医政医管局局长焦雅辉：目前全国15个省份已经派出了医务人员38000多人，另外还调集了核酸检测力量238万管来支." isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"标段信息：" byLabelStr:@"aaa" isAcc:YES withBlcok:^{
        NSLog(@"标段信息：");
        self.strtxtContent = self.txtContent.text;
        zk1 = zk1==1?2:1;
        [self bindView];
    }];
    
    if (zk1 == 2) {
        [self  byReturnColCellTitle:@"    标段名称1：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
        [self  byReturnColCellTitle:@"    标段名称2：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    }
    [self  byReturnColCellTitle:@"代理机构：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"联  系  人：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"联系电话：" byLabelStr:@"13940104171" isCallAcc:YES withBlcok:^{
        NSLog(@"拨打电话");
        [GlobalConfig makeCall:@"13940104171"];

        
    }];
    [self  byReturnColCellTitle:@"评标开始时间：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"评标结束时间：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    
    UIView *viewTzggA = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzggA];
    [self viewReadInit:viewTzggA withTitleStr:@"费用明细："];
    UIButton *btnJfbz = [UIButton new];
    [btnJfbz setTitle:@"计费标准" forState:UIControlStateNormal];
    [btnJfbz setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnJfbz setFrame:CGRectMake(kScreenWidth -  k360Width(116), 0, k360Width(100), k360Width(44))];
    [btnJfbz.titleLabel setFont:WY_FONTMedium(14)];
    [btnJfbz setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [btnJfbz setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"计费标准");
        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
        wk.titleStr = @"计费标准";
        wk.webviewURL = @"https://www.capass.cn/Avatar/expert_fee_rule.pdf";
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
        navi.navigationBarHidden = NO;
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navi animated:NO completion:nil];
    }];
    [viewTzggA addSubview:btnJfbz];
    
    lastY = viewTzggA.bottom;
    [self  byReturnColCellTitle:@"评标实际时长：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"评标费用：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    [self  byReturnColCellTitle:@"补助费用：" byLabelStr:@"aaa" isAcc:YES withBlcok:^{
        NSLog(@"补助费用");
        zk2 = zk2==1?2:1;
        self.strtxtContent = self.txtContent.text;
        [self bindView];
    }];
    if (zk2 == 2) {
        [self  byReturnColCellTitle:@"    补助费用名称1：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
        [self  byReturnColCellTitle:@"    补助费用名称2：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    }
    [self  byReturnColCellTitle:@"个税扣除：" byLabelStr:@"aaa" isAcc:NO withBlcok:nil];
    
    UIView *viewTzggB = [[UIView alloc] initWithFrame:CGRectMake(0, lastY + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzggB];
    [self viewReadInit:viewTzggB withTitleStr:@"总计："];
    
    UIButton *btnPrice = [UIButton new];
    [btnPrice setTitle:@"￥0" forState:UIControlStateNormal];
    [btnPrice setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnPrice setFrame:CGRectMake(kScreenWidth -  k360Width(116), 0, k360Width(100), k360Width(44))];
    [btnPrice.titleLabel setFont:WY_FONTMedium(14)];
    [btnPrice setTitleColor:HEXCOLOR(0xfb363e) forState:UIControlStateNormal];
     
    [viewTzggB addSubview:btnPrice];
    
    
    UIView *viewTzggC = [[UIView alloc] initWithFrame:CGRectMake(0, viewTzggB.bottom + k360Width(5), kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTzggC];
    [self viewReadInit:viewTzggC withTitleStr:@"费用异议："];
    lastY = viewTzggC.bottom;
    
    self.txtContent = [IQTextView new];
    
    [self.mScrollView addSubview:self.txtContent];
    [self.txtContent setPlaceholder:@"请输入异议内容"];

    [self initCellTitle:@"异议内容" byTextView:self.txtContent withTextH:k360Width(130)];

    self.txtContent.text = self.strtxtContent;
    
    self.viewTop1 = [[UIView alloc] initWithFrame:CGRectMake(0, lastY , kScreenWidth, k375Width(150))];
    [self.viewTop1 setBackgroundColor:[UIColor whiteColor]];

    UILabel *lblTop1 = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop1 setNumberOfLines:2];
    [lblTop1 setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop1Str = [[NSMutableAttributedString alloc] initWithString:@""];
    [attTop1Str setYy_font:WY_FONTMedium(14)];
    [attTop1Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop1Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传费用异议图片附件(5张）"];
    [attTop1Str1 setYy_font:WY_FONTMedium(14)];
    [attTop1Str1 setYy_color:[UIColor blackColor]];
    
    [attTop1Str appendAttributedString:attTop1Str1];
    
    lblTop1.attributedText = attTop1Str;

    [self.viewTop1 addSubview:lblTop1];

    self.scrollViewImgsTop1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop1 addSubview:self.scrollViewImgsTop1];
    [self.mScrollView addSubview:self.viewTop1];
     
    [self initSBImgs];

    
    [self.mScrollView setContentSize:CGSizeMake(0, self.viewTop1.bottom + k360Width(16))];
}



- (void)initCellTitle:(NSString *)titleStr byTextView:(IQTextView *)withTextView withTextH:(float)withTextH{
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setTextColor:[UIColor grayColor]];
    
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), k360Width(44))];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attStr appendAttributedString:attStr1];
    lblTitle.attributedText = attStr;
    
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    
    
//    [withTextView setFrame:CGRectMake(k360Width(16), lblTitle.bottom, kScreenWidth - k360Width(32), withTextH)];
    [lblTitle setHidden:YES];
    [withTextView setFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), withTextH)];

    [withTextView setFont:WY_FONTRegular(14)];
    [withTextView rounded:withTextH/16 width:2 color:APPLineColor];
    
    viewTemp.height = withTextView.bottom + k360Width(16);
    [viewTemp addSubview:withTextView];
     
    lastY = viewTemp.bottom;
}

- (UIControl *)byReturnColCellTitle:(NSString *)titleStr byLabelStr:(NSString *)withLabelStr isCallAcc:(BOOL)isAcc withBlcok:(void (^)(void))withBlcok {
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
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(self.mScrollView.width - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"0317phone"]];
        [viewTemp addSubview:imgAcc];
 
        accLeft = imgAcc.width + k360Width(5);
    }
    
    UILabel *withLabel = [UILabel new];
    
    [withLabel setFrame:CGRectMake(lblTitle.right, 0, viewTemp.width - lblTitle.right - k360Width(16) - accLeft, k360Width(22))];
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
    UILabel *lblCk;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(self.mScrollView.width - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        lblCk = [UILabel new];
        [lblCk setFrame:CGRectMake(imgAcc.left - k360Width(25), k360Width(44 - 10) / 2, k360Width(30), k360Width(22))];
        [lblCk setText:@"查看"];
        [lblCk setTextAlignment:NSTextAlignmentRight];
        [lblCk setFont:WY_FONTRegular(12)];
        [lblCk setTextColor:APPTextGayColor];
        [viewTemp addSubview:lblCk];
        
        accLeft = imgAcc.width + lblCk.width + k360Width(5);
    }
    
    UILabel *withLabel = [UILabel new];
    
    [withLabel setFrame:CGRectMake(lblTitle.right, 0, viewTemp.width - lblTitle.right - k360Width(16) - accLeft, k360Width(22))];
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
        lblCk.centerY = imgAcc.centerY;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    lastY = viewTemp.bottom;
    return viewTemp;
}

- (void)viewReadInit:(UIView *)vrView withTitleStr:(NSString *)titleStr{
    [vrView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), k360Width(44-15) / 2, k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    [vrView addSubview:viewBlue1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(viewBlue1.right + k360Width(8), k360Width(0), k360Width(264), k360Width(44));
    label.text = titleStr;
    label.font = WY_FONTMedium(14);
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8/1.0];
    [vrView addSubview:label];
    
}

- (void)btnSubmitAction {
    NSLog(@"点击了提交按钮");
    if (![self.txtContent.text isNotBlank]) {
        [SVProgressHUD showErrorWithStatus:@"请驶入异议内容"];
        return;
    }
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.txtContent.text forKey:@"content"];
    [postDic setObject:[self.arrEttachmentUrl componentsJoinedByString:@","] forKey:@"contentUrl"];
    [postDic setObject:self.infoID forKey:@"expertId"];

    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getExpertDetailed_HTTP params:nil jsonData:[postDic mj_JSONData] showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"新增异议失败"];
        }
     } failure:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"新增异议失败"];
         
     }];

}


/// 初始化设备Imgs
- (void)initSBImgs {
    [self.scrollViewImgsTop1 removeAllSubviews];
    
    float lastX = k375Width(12);
    int i = 0;
    for (NSString *imgUrl in self.arrEttachmentUrl) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop1 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnSBImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnSBDelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        i ++;
    }
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addSBPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewImgsTop1 addSubview:tempBtnAdd];
    
    [self.scrollViewImgsTop1 setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];


    
     
}

- (void)btnSBImgAction:(UIButton *)btnSender {
    //打开图片；
    NSMutableArray *picModels = [NSMutableArray new];
    for (NSString *imgUrl in self.arrEttachmentUrl) {
        IWPictureModel* picModel  = [IWPictureModel new];
        picModel.nsbmiddle_pic = imgUrl;
        picModel.nsoriginal_pic = imgUrl;
        [picModels addObject:picModel];
    }
    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
    indvController.mIWPictureModel = [picModels objectAtIndex:btnSender.tag];
    indvController.picArr = picModels;
    [self.navigationController   pushViewController:indvController animated:YES];
    
}

- (void)btnSBDelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrEttachmentUrl removeObjectAtIndex:btnSender.tag];
    [self initSBImgs];
}

- (void)addSBPicAction {
    
    if  (self.arrEttachmentUrl.count >= 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5张图片"];
        return;
    }
    
    picType = @"2";
    [self navRightAddPhotoAction];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)navRightAddPhotoAction {
     //上传照片
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
    
    UIAlertAction *alertAct4 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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



//开始拍照
-(void)takePhoto
{
    
//    OP_CameraViewController *tempController = [OP_CameraViewController new];
//    tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
//        [self uploadImage:imgEdit];
//    };
//    [self.navigationController pushViewController:tempController animated:YES];
    
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
//    {
//
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:nil];
//    }else
//    {
//
//    }
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
        if ([picType isEqualToString:@"2"]) {
            //设备添加图片成功；
            [self.arrEttachmentUrl addObject:picUrl];
            [self initSBImgs];
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
        OP_ImageShowViewController *tempController = [OP_ImageShowViewController new];
        tempController.imgA = image;
        tempController.imgB = image;
        tempController.nsType = @"1";
        tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
            [self uploadImage:imgEdit];
        };
        [self.navigationController pushViewController:tempController animated:NO];
        return;
        
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

@end
