//
//  WY_AddOnlineLeaveViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/12/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_AddOnlineLeaveViewController.h"
#import "LEEStarRating.h"
#import "WY_selPicView.h"
#import "WY_ProfessionModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageNewsDetailViewController.h"
#import "WY_EvaluateModel.h"

@interface WY_AddOnlineLeaveViewController ()
{
    int lastY;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UILabel *lblName;

@property (nonatomic, strong) IQTextView *txtContent;
@property (nonatomic ,strong) NSMutableArray *arrZgzs;
@property (nonatomic ,strong) NSString * qualificationEleId;
@property (nonatomic, strong) UIScrollView *scrollViewZgzs;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_AddOnlineLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
    [self dataBind];
    
    if ([self.nsType isEqualToString:@"1"]) {
        // 1是查看 我已评价的内容；zj_getExpertRateDetail_HTTP
        [self dataBindSource];
    }
}
- (void)dataBindSource {
    //修改标题名；
    self.title = @"查看我的请假";
    //隐藏发布按钮
    [self.cancleButton setHidden:YES];
    
    //请假文字
self.txtContent.text = self.mWY_ExpertModel.leaveReason;
self.qualificationEleId = self.mWY_ExpertModel.leaveAttach;
[self.txtContent setUserInteractionEnabled:NO];
self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId componentsSeparatedByString:@","]];
[self initZgzsImgsShow];
    
//    [[MS_BasicDataController sharedInstance] postWithURL:zj_getReconsiderDetail_HTTP params:@{@"id":self.mWY_ExpertModel.id} jsonData:nil showProgressView:YES success:^(id successCallBack) {
//        NSLog(@"aaa");
//        WY_EvaluateModel *paramModel = [WY_EvaluateModel modelWithJSON:successCallBack];
//         
//             //请假文字
//        self.txtContent.text = paramModel.leaveReason;
//        self.qualificationEleId = paramModel.leaveAttach;
//        [self.txtContent setUserInteractionEnabled:NO];
//        self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId componentsSeparatedByString:@","]];
//        [self initZgzsImgsShow];
// 
//    } failure:^(NSString *failureCallBack) {
//        [SVProgressHUD showErrorWithStatus:failureCallBack];
//    } ErrorInfo:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
//    }];

}

- (void) makeUI {
    self.title =@"发表请假";
    
    self.cancleButton = [[UIButton alloc] init];
    self.cancleButton.frame = CGRectMake(0, 0, 50, 30);
    [self.cancleButton setTitle:@"提交" forState:UIControlStateNormal];
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

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(k360Width(16),k360Width(16),kScreenWidth,k360Width(40));
    label.numberOfLines = 0;
    [self.mScrollView addSubview:label];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [string setYy_color:[UIColor redColor]];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"请假原因"];
    [string1 setYy_color:[UIColor blackColor]];
    [string appendAttributedString:string1];
    label.attributedText = string;

    
    self.lblName = [UILabel new];
    
    self.txtContent = [IQTextView new];
    self.scrollViewZgzs = [UIScrollView new];
    
    [self.mScrollView addSubview:self.lblName];
     
    
    
}
- (void)dataBind {
//    [self.lblName setFrame:CGRectMake(k360Width(16), k360Width(20), kScreenWidth - k360Width(32), k360Width(44))];
//
//    [self.lblName setText:self.mWY_ExpertModel.name];
//    [self.lblName setFont:WY_FONTMedium(16)];
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
 
    lastY = k360Width(44);
    
//    UIImageView *imgLine = [UIImageView new];
//    [imgLine setBackgroundColor:APPLineColor];
//    [imgLine setFrame:CGRectMake(0, lastY + k360Width(16), kScreenWidth, k360Width(3))];
//    [self.mScrollView addSubview:imgLine];
    
//    lastY = imgLine.bottom + k360Width(16);
    
 
    UIView *viewPjBg = [UIView new];
    [viewPjBg setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(280))];
    [viewPjBg setBackgroundColor:HEXCOLOR(0xffffff)];
//    [viewPjBg rounded:8 width:1 color:APPLineColor];
    [self.mScrollView addSubview:viewPjBg];
     
    [self.txtContent setFrame:CGRectMake(k360Width(16), lastY + k360Width(16), kScreenWidth -k360Width(32) , k360Width(80))];
    [self.txtContent setPlaceholder:@"请输入您的请假原因"];
    [self.txtContent setBackgroundColor:HEXCOLOR(0xfafafa)];
    [self.txtContent setFont:WY_FONTRegular(14)];

    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(k360Width(16),self.txtContent.bottom + k360Width(5),kScreenWidth,k360Width(24));
    label.numberOfLines = 0;
    [self.mScrollView addSubview:label];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];
    [string setYy_color:[UIColor redColor]];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"其他材料"];
    [string1 setYy_color:[UIColor blackColor]];
    [string appendAttributedString:string1];
    label.attributedText = string;
    
    [self.scrollViewZgzs setFrame:CGRectMake(k360Width(0), label.bottom  , kScreenWidth - k360Width(0), k375Width(120))];
    self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.qualificationEleId componentsSeparatedByString:@","]];

    [self initZgzsImgs];
    [self.mScrollView addSubview:self.txtContent];
    [self.mScrollView addSubview:self.scrollViewZgzs];
    
    
    UIImageView *imgLineA = [[UIImageView alloc] initWithFrame:CGRectMake(0, viewPjBg.bottom + k360Width(16), kScreenWidth, 1)];
    [self.mScrollView addSubview:imgLineA];
    [imgLineA setBackgroundColor:APPLineColor];
    lastY = imgLineA.bottom + k360Width(16);
      
    [self.mScrollView setContentSize:CGSizeMake(0, lastY + k360Width(16))];
}

- (void)addZgzsPicAction {
    //添加资格证书图片；

    if (self.arrZgzs.count >=2) {
        UIAlertView *alertAction = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加两张请假图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
- (void)rightBtnAction {
     if (self.txtContent.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入请假内容"];
        return;
    }
    if (self.qualificationEleId  == nil || self.qualificationEleId.length <= 0) {
        //TODO：2025-10-29 14:29:39 修改需求-这里不再验证请假图片必填，如果没传图片，赋值默认值防止接口报错；
        self.qualificationEleId = @"";
//       [SVProgressHUD showErrorWithStatus:@"请上传请假图片"];
//       return;
   }
    WY_EvaluateModel *paramModel = [WY_EvaluateModel new];
    paramModel.id = self.mWY_ExpertModel.id;
    paramModel.expertIdCard = self.mWY_ExpertModel.zjidcard;
//     项目编号
    paramModel.tenderProjectCode = self.mWY_ExpertModel.tenderProjectCode;
    paramModel.tenderProjectName = self.mWY_ExpertModel.name;
    paramModel.agencyName = self.mWY_ExpertModel.daili;
//    代理机构代码
    paramModel.agencyCode = self.mWY_ExpertModel.agencyCode;
    paramModel.bidSectionNames = self.mWY_ExpertModel.bidSectionName;
    paramModel.bidSectionCodes = self.mWY_ExpertModel.bidSectionCodes;
    paramModel.bidEvaluationAddress = self.mWY_ExpertModel.place;
    paramModel.bidEvaluationTime = self.mWY_ExpertModel.time;
     
    paramModel.expertName = self.mUser.realname;
        //评价文字
    paramModel.leaveReason = self.txtContent.text;
    
    
    paramModel.leaveAttach  = self.qualificationEleId;
    
    
     NSLog(@"JSON:%@",[paramModel toJSONString]);
    [[MS_BasicDataController sharedInstance] postWithURL:zj_expertLeaveResponse_HTTP params:nil jsonData:[paramModel toJSONData] showProgressView:YES success:^(id successCallBack) {
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
