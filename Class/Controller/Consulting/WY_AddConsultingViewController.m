//
//  WY_AddConsultingViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/25.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_AddConsultingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageNewsDetailViewController.h"
#import "WY_selPicView.h"
#import "WY_AExpertQuestionModel.h"

@interface WY_AddConsultingViewController ()
{
    int lastY;
    int selStyleId;
    NSString *selCityCode;
    NSString *selCityName;
}
@property (nonatomic ,strong) UILabel *lblConsultType;
@property (nonatomic ,strong) UILabel *lblCitySel;
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic , strong) IQTextView *txtTitle;
@property (nonatomic , strong) IQTextView *txtContent;

@property (nonatomic ,strong) NSMutableArray *arrZgzs;
@property (nonatomic ,strong) NSString * qualificationEleId;
@property (nonatomic, strong) UIScrollView *scrollViewZgzs;
@property (nonatomic, strong) WY_UserModel * mUser;
@property (nonatomic ,strong) NSMutableArray *arrCityByLN;
#define MAX_LIMIT_NUMS 30
#define MAX_LIMIT_NUMSA 100
@end

@implementation WY_AddConsultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self initData];
    if ([self.nsType isEqualToString:@"1"]) {
        // 1是查看 我已评价的内容；zj_getExpertRateDetail_HTTP
        [self dataBindSource];
    }
}
- (void)initData {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
 
        [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_sysGetInfo_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            if (([code integerValue] == 0 || [code integerValue] == 1) && res) {
                WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
                self.mUser = currentUserModel;
             } else {
                [self.view makeToast:res[@"msg"]];
                 NSLog(@"没有登录, 跳转登录页");
                 NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
                 [notifyCenter postNotificationName:NOTIFY_RELOGIN object:nil];

            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"请求失败，请稍后再试"];
            NSLog(@"没有登录, 跳转登录页");
            NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
            [notifyCenter postNotificationName:NOTIFY_RELOGIN object:nil];

        }];
    
    
    [[MS_BasicDataController sharedInstance] getWithReturnCode:jg_regionCityByLN_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 200 && res) {
            self.arrCityByLN =res[@"data"];
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
}
- (void)dataBindSource {
    //修改标题名；
    self.title = @"查看我的咨询";
    //隐藏发布按钮
    [self.btnSubmit setHidden:YES];
    //    [[MS_BasicDataController sharedInstance] postWithURL:zj_getExpertRateDetail_HTTP params:@{@"id":self.mWY_ExpertModel.id} jsonData:nil showProgressView:YES success:^(id successCallBack) {
    //        NSLog(@"aaa");
    //        WY_EvaluateModel *paramModel = [WY_EvaluateModel modelWithJSON:successCallBack];
    //
    //        //    公司形象打分
    //        self.starRating1.currentScore = [paramModel.companyImage floatValue];
    //         //    评标现场组织能力打分
    //        self.starRating2.currentScore = [paramModel.organizationalSkills floatValue];
    //        //    所评项目业务掌握能力打分
    //        self.starRating3.currentScore = [paramModel.operationalCapacity floatValue];
    //        //    服务态度打分
    //        self.starRating4.currentScore = [paramModel.serviceAttitude floatValue];
    //        //    工作效率打分
    //        self.starRating5.currentScore = [paramModel.workEfficiency floatValue];
    //      //    综合分
    //        self.starRating6.currentScore = [paramModel.averageScore floatValue];
    //             //评价文字
    //        self.txtContent.text = paramModel.rateText;
    //        self.qualificationEleId = paramModel.images;
    //
    //        [self.starRating1 setUserInteractionEnabled:NO];
    //        [self.starRating2 setUserInteractionEnabled:NO];
    //        [self.starRating3 setUserInteractionEnabled:NO];
    //        [self.starRating4 setUserInteractionEnabled:NO];
    //        [self.starRating5 setUserInteractionEnabled:NO];
    //        [self.starRating6 setUserInteractionEnabled:NO];
    //        [self.txtContent setUserInteractionEnabled:NO];
    self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId componentsSeparatedByString:@","]];
    [self initZgzsImgsShow];
    
    //    } failure:^(NSString *failureCallBack) {
    //        [SVProgressHUD showErrorWithStatus:failureCallBack];
    //    } ErrorInfo:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    //    }];
    
}

- (void)makeUI {
    self.title = @"咨询投诉";
    
    selStyleId = -1;
    
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
    
    self.lblConsultType = [UILabel new];
    self.lblConsultType.text = @"请选择问题类型";
    self.lblCitySel = [UILabel new];
    self.lblCitySel.text = @"请选择咨询地区";
    WS(weakSelf);
    [self initCellTitle:@"问题类型" byLabel:self.lblConsultType isAcc:YES withBlcok:^{
        NSLog(@"选择推荐来源");
        NSMutableArray *cityStrArr = [NSMutableArray new];
        [cityStrArr addObject:@"咨询"];
        [cityStrArr addObject:@"投诉"];
        [cityStrArr addObject:@"建议"];
        [ActionSheetStringPicker showPickerWithTitle:@"请选择问题类型" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.lblConsultType.text = selectedValue;
            selStyleId = selectedIndex;
            //            weakSelf.mWY_ExpertMessageModel.selStyleId = selectedValue;
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
    }];
    
    [self initCellTitle:@"咨询地区" byLabel:self.lblCitySel isAcc:YES withBlcok:^{
        NSLog(@"选择推荐来源");
        NSMutableArray *cityStrArr = [NSMutableArray new];
     
        for (NSDictionary *cityDic in self.arrCityByLN) {
            [cityStrArr addObject:[cityDic objectForKey:@"name"]];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"请选择咨询地区" rows:cityStrArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.lblCitySel.text = selectedValue;
            selCityCode = self.arrCityByLN[selectedIndex][@"code"];
            selCityName = self.arrCityByLN[selectedIndex][@"name"];
         } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
    }];
    self.txtTitle = [IQTextView new];
    self.txtContent = [IQTextView new];
//    [self.txtTitle setDelegate:self];
//    [self.txtContent setDelegate:self];
//    [self.txtTitle setPlaceholder:@"请输入标题，不得超过30字"];
//    [self.txtContent setPlaceholder:@"请输入问题描述，不得超过100字"];
//
    
    [self.txtTitle setPlaceholder:@"请输入标题"];
    [self.txtContent setPlaceholder:@"请输入问题描述"];
    
    
    [self initCellTitle:@"问题标题" byTextView:self.txtTitle withTextH:k360Width(80)];
    [self initCellTitle:@"问题描述" byTextView:self.txtContent withTextH:k360Width(130)];
    
    
    self.scrollViewZgzs = [UIScrollView new];
    [self.scrollViewZgzs setBackgroundColor:[UIColor whiteColor]];
    [self.scrollViewZgzs setFrame:CGRectMake(0, lastY, kScreenWidth, k375Width(110))];
    self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId componentsSeparatedByString:@","]];
    
    [self initZgzsImgs];
    [self.mScrollView addSubview:self.scrollViewZgzs];
    [self.mScrollView setContentSize:CGSizeMake(0, self.scrollViewZgzs.bottom)];
}

- (void)initCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel isAcc:(BOOL)isAcc   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setTextColor:[UIColor grayColor]];
    
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attStr appendAttributedString:attStr1];
    lblTitle.attributedText = attStr;
    
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
    
    
    [withLabel setFrame:CGRectMake(viewTemp.width - k360Width(350 + 16), 0, k360Width(350) - accLeft, k360Width(44))];
//    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextAlignment:NSTextAlignmentRight];
    [withLabel setFont:WY_FONTRegular(14)];
//    [withLabel sizeToFit];
//    withLabel.left = kScreenWidth - withLabel.width - k360Width(16) - accLeft;
//    if (withLabel.height < k360Width(12)) {
//        withLabel.height = k360Width(12);
//    }
    
//    viewTemp.height = withLabel.bottom + k360Width(16);
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
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 5)];
    [viewTemp addSubview:imgLine];
    viewTemp.height = imgLine.bottom;
    lastY = viewTemp.bottom;
    
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


- (void)addZgzsPicAction {
    //添加资格证书图片；
    
    if (self.arrZgzs.count >=3) {
        UIAlertView *alertAction = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加三张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertAction show];
        return;
    }
    //    if (self.addZgzsPicItemBlock) {
    //        self.addZgzsPicItemBlock(self);
    //    }
    
    NSLog(@"上传照片");
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"扫描拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
- (void)btnZgzsDelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrZgzs removeObjectAtIndex:btnSender.tag];
    self.qualificationEleId = [self.arrZgzs componentsJoinedByString:@","];
    
    [self initZgzsImgs];
}
/// 初始化资格证书Imgs
- (void)initZgzsImgs {
    [self.scrollViewZgzs removeAllSubviews];
    
    float lastX = k375Width(18.75);
    int i = 0;
    for (NSString *imgUrl in self.arrZgzs) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(18.75);
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
    NSString * str = [GlobalConfig getAbsoluteUrl:jg_expertQuestionUpload_HTTP];
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
        
        [self.arrZgzs addObject:picUrl];
        self.qualificationEleId = [self.arrZgzs componentsJoinedByString:@","];
        [self initZgzsImgs];
        
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

- (void)btnSubmitAction {
    NSLog(@"点击了提交订单");
    
    if (self.mUser.idcardnum.length <= 0 ) {
        [SVProgressHUD showErrorWithStatus:@"没有获取到用户信息"];
        return;
    }
    
    if (selStyleId == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择问题类型"];
        return;
    }
    if (self.txtTitle.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    if (self.txtContent.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入问题描述"];
        return;
    }
    if (selCityCode.length <=0) {
        [SVProgressHUD showErrorWithStatus:@"请选择咨询地区"];
        return;
    }
    NSLog(@"self.qualificationEleId:%@",self.qualificationEleId)
    
    
    WY_AExpertQuestionModel *tempModel = [WY_AExpertQuestionModel new];
    
    tempModel.expertDanweiname = self.mUser.DanWeiName;
    tempModel.expertIdCard = self.mUser.idcardnum;
    tempModel.expertName = self.mUser.realname;
    tempModel.expertPhone = self.mUser.LoginID;
    tempModel.qaCityCode = selCityCode;
    tempModel.qaCityName = selCityName;
    
    tempModel.qaContent = self.txtContent.text;
    tempModel.qaFile = self.qualificationEleId;
    tempModel.qaTitle = self.txtTitle.text;
    tempModel.qaType = [NSString stringWithFormat:@"%d",selStyleId + 1];
    tempModel.expertPic = self.mUser.avatarPath;
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:jg_expertQuestionCreateQuestion_HTTP params:nil jsonData:[tempModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
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


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int maxNums = 0;
    if ([textView isEqual:self.txtTitle]) {
        maxNums = MAX_LIMIT_NUMS;
    } else {
        maxNums = MAX_LIMIT_NUMSA;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < maxNums) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = maxNums - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                           NSInteger steplen = substring.length;
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx = idx + steplen;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
//            self.lbNums.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    int maxNums = 0;
    if ([textView isEqual:self.txtTitle]) {
        maxNums = MAX_LIMIT_NUMS;
    } else {
        maxNums = MAX_LIMIT_NUMSA;
    }
    if (existTextNum > maxNums)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:maxNums];
        
        [textView setText:s];
    }
}
@end
