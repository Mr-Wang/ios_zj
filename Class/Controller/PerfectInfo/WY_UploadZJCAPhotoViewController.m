//
//  WY_UploadZJCAPhotoViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/8/31.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_UploadZJCAPhotoViewController.h"
#import "WY_selPicView.h"
#import "ImageNewsDetailViewController.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MS_WKwebviewsViewController.h"
@interface WY_UploadZJCAPhotoViewController ()
{
    
    NSString *picType;
}
@property (nonatomic , strong) UIView *viewTop2;
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop2;
@property (nonatomic , strong) NSMutableArray *arrImgUrls;
@property (nonatomic , strong) NSMutableDictionary * caDic;
@property (nonatomic) BOOL isSBFirst;
@end

@implementation WY_UploadZJCAPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    self.arrImgUrls = [[NSMutableArray alloc] init];
    [self initSheBaoImgs];
    
    [self initDataSource];
    
}
- (void)initDataSource{
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mWY_ExpertMessageModel.zjIdCard forKey:@"idcard"];
    [dicPost setObject:self.source forKey:@"source"];
 
    [[MS_BasicDataController sharedInstance] getWithReturnCode:zj_getCertificates_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code intValue] == 0) {
            
            if (![res[@"data"] isEqual:[NSNull null]] && res[@"data"] != nil) {
                                
                self.caDic = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                self.arrImgUrls = [[NSMutableArray alloc] initWithArray:[self.caDic[@"url"] componentsSeparatedByString:@","]];
                [self initSheBaoImgs];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    } ];

    
}
- (void)makeUI {
    self.title = @"完善专家资格证书";
    [self.view setBackgroundColor:HEXCOLOR(0xF4F5F9)];

    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  - JCNew64 - k360Width(58) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];

    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(15), self.mScrollView.bottom +  k375Width(7), (kScreenWidth - k375Width(15*2)), k360Width(44))];
    [self.btnSubmit setTitle:@"保  存" forState:UIControlStateNormal];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    self.viewTop2 = [[UIView alloc] initWithFrame:CGRectMake(0,  k375Width(10), kScreenWidth, k375Width(150))];
    [self.viewTop2 setBackgroundColor:[UIColor whiteColor]];
    [self.mScrollView addSubview:self.viewTop2];

    
    
    UILabel *lblTop2Ts = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop2Ts setNumberOfLines:2];
    [lblTop2Ts setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop2Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attTop2Str setYy_font:WY_FONTMedium(14)];
    [attTop2Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop2Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传辽宁省评标专家资格证书"];
    [attTop2Str1 setYy_font:WY_FONTMedium(14)];
    [attTop2Str1 setYy_color:[UIColor blackColor]];
    
    [attTop2Str appendAttributedString:attTop2Str1];
    
    lblTop2Ts.attributedText = attTop2Str;
    
    UIButton *btnShowDoc = [UIButton new];
    [btnShowDoc setTitle:@"查看示例" forState:UIControlStateNormal];
    [btnShowDoc rounded:k360Width(30/8)];
    [btnShowDoc setFrame:CGRectMake(kScreenWidth - k360Width(76), 0, k360Width(60), k360Width(30))];
    [btnShowDoc setBackgroundColor:MSTHEMEColor];
    [btnShowDoc.titleLabel setFont:WY_FONTRegular(12)];
    [btnShowDoc setCenterY:lblTop2Ts.centerY];
    [btnShowDoc addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
       
        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
       wk.titleStr = @"辽宁省评标专家资格证书(示例)";
        wk.webviewURL = @"https://www.capass.cn/Avatar/zzzssl.pdf";
       UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
       navi.navigationBarHidden = NO;
       navi.modalPresentationStyle = UIModalPresentationFullScreen;
       [self presentViewController:navi animated:YES completion:nil];

    }];
    [self.viewTop2 addSubview:btnShowDoc];
    
    [self.viewTop2 addSubview:lblTop2Ts];
    
    self.scrollViewImgsTop2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop2 addSubview:self.scrollViewImgsTop2];
    
    
    UILabel *lblTop2TsA = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), self.scrollViewImgsTop2.bottom, kScreenWidth - k375Width(24), k375Width(55))];
    [lblTop2TsA setNumberOfLines:4];
    [lblTop2TsA setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop2StrA = [[NSMutableAttributedString alloc] initWithString:@"此处上传原“辽宁省评标专家资格证书”（如有），请勿上传《辽宁省综合评标专家库评标专家资格证书》，单独维护资格证书时保存即可，不必提交专家信息审核，以免给您造成不必要的麻烦。"];
    [attTop2StrA setYy_font:WY_FONTMedium(14)];
    [attTop2StrA setYy_color:[UIColor redColor]];
//    NSMutableAttributedString *attTop2Str1A = [[NSMutableAttributedString alloc] initWithString:@"请上传辽宁省评标专家资格证书"];
//    [attTop2Str1A setYy_font:WY_FONTMedium(14)];
//    [attTop2Str1A setYy_color:[UIColor blackColor]];
//
//    [attTop2StrA appendAttributedString:attTop2Str1A];
    
    lblTop2TsA.attributedText = attTop2StrA;
    [lblTop2TsA setTextAlignment:NSTextAlignmentCenter];
    [lblTop2TsA sizeToFit];
    lblTop2TsA.height += 10;
    [self.viewTop2 addSubview:lblTop2TsA];

    
    
}
/// 初始化设备Imgs
- (void)initSheBaoImgs {
    [self.scrollViewImgsTop2 removeAllSubviews];
    
    float lastX = k375Width(12);
    int i = 0;
    for (NSString *imgUrl in self.arrImgUrls) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop2 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnDelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        i ++;
    }
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addSheBaoPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewImgsTop2 addSubview:tempBtnAdd];
    
    [self.scrollViewImgsTop2 setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
}

- (void)btnImgAction:(UIButton *)btnSender {
    //打开图片；
    NSMutableArray *picModels = [NSMutableArray new];
    for (NSString *imgUrl in self.arrImgUrls) {
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
- (void)btnDelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrImgUrls removeObjectAtIndex:btnSender.tag];
    [self initSheBaoImgs];
}
- (void)addSheBaoPicAction {
     //添加社保-图片；
    picType = @"3";
    [self navRightAddPhotoAction];
}



- (void) firstAlert {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请把所要拍摄的材料放置在与拍摄背景有明显区别的环境下，如果识别不准确可点击手动拍照" preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"开始识别" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}
- (void)navRightAddPhotoAction {
    //上传照片
    NSLog(@"上传照片");
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"扫描拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
        //读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [SVProgressHUD showInfoWithStatus:@"应用相机权限受限,请在设置中启用"];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        
        if (self.isSBFirst) {
            [self firstAlert];
            self.isSBFirst = NO;
        } else  {
            [self takePhoto];
        }
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
    
    OP_CameraViewController *tempController = [OP_CameraViewController new];
    tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
        [self uploadImage:imgEdit];
    };
    [self.navigationController pushViewController:tempController animated:YES];
    
    //    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    //    {
    //
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //        picker.delegate = self;
    //        //设置拍照后的图片可被编辑
    //        picker.allowsEditing = YES;
    //        picker.sourceType = sourceType;
    //        picker.modalPresentationStyle = UIModalPresentationFullScreen;
    //        [self presentViewController:picker animated:YES completion:nil];
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
        if ([picType isEqualToString:@"3"]) {
            //设备添加图片成功；
            [self.arrImgUrls addObject:picUrl];
            [self initSheBaoImgs];
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
 
- (void)btnSubmitAction{
    //验证 社保；
    if (self.arrImgUrls.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传您的专家资格证书"];
        return;
    }
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mWY_ExpertMessageModel.zjIdCard forKey:@"expertIdCard"];
    [dicPost setObject:self.mWY_ExpertMessageModel.zjName forKey:@"expertIdName"];
    [dicPost setObject:self.source forKey:@"source"];
    [dicPost setObject:[self.arrImgUrls componentsJoinedByString:@","] forKey:@"url"];
    
    if (self.caDic != nil) {
        [dicPost setObject:self.caDic[@"id"] forKey:@"id"];
    }
    
    [[MS_BasicDataController sharedInstance] postWithURL:zj_perfectCertificates_HTTP params:nil jsonData:[dicPost mj_JSONData] showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];

    
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
