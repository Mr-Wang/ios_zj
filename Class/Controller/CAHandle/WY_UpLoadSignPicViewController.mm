//
//  WY_UpLoadSignPicViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/9/14.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_UpLoadSignPicViewController.h"
#import "MS_WKwebviewsViewController.h"

#import "ImageNewsDetailViewController.h"
#import "OP_CameraViewController.h"
#import "OP_ImageShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WDOpenCVHelper.h"
#import "UIImage+ColorImage.h"

@interface WY_UpLoadSignPicViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) UIImageView * imgPic;
@property (nonatomic, strong) UIView *viewBottom;
@property (nonatomic, strong) NSMutableArray *arrImageUrl;
@property (nonatomic, strong) NSMutableArray *arrImgSel;
@property (nonatomic, strong) UIImage *selImgUrl;
@property (nonatomic, strong) NSString *pdfUrl;
@property (nonatomic) BOOL isSBFirst;
@end

@implementation WY_UpLoadSignPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];

}

- (void)makeUI {
    self.title = @"签字采集";
     
    
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
    
    [self initScrollView];
    
}
- (void)initSelPicView {
    [self.viewBottom removeAllSubviews];
//    self.arrImageUrl = [[NSMutableArray alloc] initWithArray:@[@"https://img0.baidu.com/it/u=1514002029,2035215441&fm=26&fmt=auto&gp=0.jpg",@"https://img2.baidu.com/it/u=2108319215,1494231136&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=690",@"https://img2.baidu.com/it/u=2510891666,2454567058&fm=26&fmt=auto&gp=0.jpg"]];
    
    UILabel *lblT1 = [UILabel new];
    [lblT1 setFrame:CGRectMake(0, k360Width(5), self.viewBottom.width, k360Width(30))];
     [lblT1 setText: @"选择签名"];
    [self.viewBottom addSubview:lblT1];
    int lastX = 0;
    int i = 0;
    self.arrImgSel = [NSMutableArray new];
    
    for (UIImage *urlStr in self.arrImageUrl) {
        UIControl *col1 = [UIControl new];
        [col1 setFrame:CGRectMake(lastX, lblT1.bottom + k360Width(10), k360Width(100), k360Width(100))];
         [self.viewBottom addSubview:col1];
        UIImageView *imgS = [[UIImageView alloc] initWithFrame:col1.bounds];
        [imgS setImage:urlStr];
        [imgS setContentMode:UIViewContentModeScaleAspectFit];
        [col1 addSubview:imgS];
        lastX = col1.right + k360Width(16);
        UIImageView *imgSel = [UIImageView new];
        
        [imgSel setFrame:CGRectMake(imgS.width - k360Width(20), k360Width(5), k360Width(20), k360Width(20))];
        [imgSel setImage:[UIImage imageNamed:@"1012_椭圆形"]];
        [self.arrImgSel addObject:imgSel];
        [col1 addSubview:imgSel];
        col1.tag = i;
        [col1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIControl * sender) {
            [self updateImgSel:sender.tag];
        }];
        i ++;
    }
    
//    for (NSString *urlStr in self.arrImageUrl) {
//        UIControl *col1 = [UIControl new];
//        [col1 setFrame:CGRectMake(lastX, lblT1.bottom + k360Width(10), k360Width(100), k360Width(100))];
//         [self.viewBottom addSubview:col1];
//        UIImageView *imgS = [[UIImageView alloc] initWithFrame:col1.bounds];
//        [imgS sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//        [col1 addSubview:imgS];
//        lastX = col1.right + k360Width(16);
//        UIImageView *imgSel = [UIImageView new];
//        [imgSel setFrame:CGRectMake(imgS.width - k360Width(20), k360Width(5), k360Width(20), k360Width(20))];
//        [imgSel setImage:[UIImage imageNamed:@"1012_椭圆形"]];
//        [self.arrImgSel addObject:imgSel];
//        [col1 addSubview:imgSel];
//        col1.tag = i;
//        [col1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIControl * sender) {
//            [self updateImgSel:sender.tag];
//        }];
//        i ++;
//    }
}
- (void)updateImgSel :(int )index {
    self.selImgUrl = self.arrImageUrl[index];
    
    for (int i = 0; i < self.arrImgSel.count; i ++) {
        UIImageView *imgSel = self.arrImgSel[i];
        if (i == index) {
            [imgSel setImage:[UIImage imageNamed:@"1012_用户协议选中"]];
            
        } else {
            [imgSel setImage:[UIImage imageNamed:@"1012_椭圆形"]];
        }
        
    }
    
}
- (void) initScrollView {
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(50))];
    [viewTop setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblT = [UILabel new];
    [lblT setFrame:viewTop.bounds];
    lblT.left = k360Width(16);
    [lblT setText: @"电子签章印模采集表模板"];
    [viewTop addSubview:lblT];
    [self.mScrollView addSubview:viewTop];
    
    UIButton *btnDownPdf = [UIButton new];
    [btnDownPdf setFrame:CGRectMake(viewTop.width - k360Width(70), k360Width(5), k360Width(60), k360Width(40))];
    [btnDownPdf setBackgroundColor:MSTHEMEColor];
    [btnDownPdf rounded:k360Width(34/4)];
    [btnDownPdf setTitle:@"下载" forState:UIControlStateNormal];
    [btnDownPdf addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了下载");
        MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
       wk.titleStr = @"电子签章印模采集表";
       wk.webviewURL = @"https://www.capass.cn/Avatar/zjymcjb.pdf";
        wk.isShare = @"1";
       UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
       navi.navigationBarHidden = NO;
       navi.modalPresentationStyle = UIModalPresentationFullScreen;
       [self presentViewController:navi animated:NO completion:nil];
    }];
    [viewTop addSubview:btnDownPdf];
    

    
    UIButton *btnUpLoad = [UIButton new];
    [btnUpLoad setFrame:CGRectMake(k360Width(16), viewTop.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(40))];
    [btnUpLoad setTitle:@"拍照上传" forState:UIControlStateNormal];
    [btnUpLoad setBackgroundColor:MSTHEMEColor];
    [btnUpLoad rounded:k360Width(40/4)];
    [btnUpLoad addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"点击了拍照上传");
        [self navRightAddPhotoAction];
    }];
    [self.mScrollView addSubview:btnUpLoad];
    
    UILabel *lblUpTitle = [UILabel new];
    [lblUpTitle setFrame:CGRectMake(0, btnUpLoad.bottom + k360Width(5), viewTop.width, k360Width(60))];

    [lblUpTitle setText:@"请垂直水平拍摄电子签章印模采集表，避免阴影部分遮挡。"];
    [lblUpTitle setFont:WY_FONT375Medium(14)];
    [lblUpTitle setTextColor:[UIColor redColor]];
    [lblUpTitle setNumberOfLines:2];
    [viewTop addSubview:lblUpTitle];
    
    self.viewBottom = [UIView new];
    [self.viewBottom setFrame:CGRectMake(k360Width(16), lblUpTitle.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(150))];
    [self.mScrollView addSubview:self.viewBottom];

    
 
//    [self initSelPicView];

}
- (void)btnSubmitAction {
    NSLog(@"点击了确认按钮");
//    zj_ca_signGot_HTTP
    
    if (self.selImgUrl == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择签名"];
        return;
    }
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请确保您选择的签名准确、清晰，提交后，该签名将作为您CA数字证书中的电子签名" preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSData *data = [WY_WLTools compressImage:self.selImgUrl toByte:1000*1024];
        
        //压缩PNG图片
           NSData *data = UIImagePNGRepresentation([WDOpenCVHelper UIImageBgTransparent:[self.selImgUrl imageByScalingAndCroppingForSize:CGSizeMake(300, 300)]]);
        
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
           
            NSString *picUrl = json[@"data"];
           NSLog(@"signPicUrl:%@",picUrl);
           self.popVCBlock(picUrl,self.pdfUrl);
           [self.navigationController popViewControllerAnimated:YES];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
           [SVProgressHUD ms_dismiss];
           [SVProgressHUD showErrorWithStatus:@"上传失败"];
       }];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertControl animated:YES completion:nil];
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
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {

    }
    
//    OP_CameraViewController *tempController = [OP_CameraViewController new];
//    tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
//        [self uploadImage:imgEdit];
//    };
//    [self.navigationController pushViewController:tempController animated:YES];
     
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

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
- (void)baiduOcr:(NSString  *)picUrl withImage:(UIImage *)withImage{
    NSString * str = @"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=UXxOSwzbdGf6kHaP6Gk4Tbks&client_secret=1DKVFi9evvLbGdaAa6AXivZYXIs00HoB";
    
     AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr POST:str parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *access_token = responseObject[@"access_token"];
        NSString *urlStr = [NSString stringWithFormat:@"https://aip.baidubce.com/rest/2.0/solution/v1/iocr/recognise?access_token=%@",access_token];
        AFHTTPSessionManager *mgr1 = [AFHTTPSessionManager manager];
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        NSString *picUrlPost =  [picUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        [dicPost setObject:picUrlPost forKey:@"url"];
        [dicPost setObject:@"c2cc955fd618a2975c981df79f23aed0" forKey:@"templateSign"];
        NSMutableDictionary *dicHead = [NSMutableDictionary new];
        [dicHead setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
        AFHTTPResponseSerializer * responceSerializer = [AFHTTPResponseSerializer serializer];
        responceSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
        [mgr1 setResponseSerializer:responceSerializer];

        [mgr1 POST:urlStr parameters:dicPost headers:dicHead progress:nil success:^(NSURLSessionDataTask * _Nonnull task1, id  _Nullable responseObject1) {
            [SVProgressHUD ms_dismiss];
            NSDictionary *responseJson =   [NSJSONSerialization JSONObjectWithData:responseObject1 options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"error_code:%@",responseJson[@"error_code"]);
            if ([responseJson[@"error_code"] intValue] == 0) {
                NSMutableArray *arrRet = [[NSMutableArray alloc]initWithArray:responseJson[@"data"][@"ret"]];
                self.arrImageUrl = [NSMutableArray new];
                for (NSDictionary *retItem in arrRet) {
                    NSLog(@"word:%@",retItem[@"word"]);
                    int lTop = [retItem[@"location"][@"top"] intValue];
                    int lLeft = [retItem[@"location"][@"left"] intValue];
                    int lWidth = [retItem[@"location"][@"width"] intValue];
                    int lHeight = [retItem[@"location"][@"height"] intValue];
                    
                    CGRect rect = CGRectMake(floor(lLeft), floor(lTop), round(lWidth), round(lHeight));//创建矩形框
                    
                    UIImage * rectImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([withImage CGImage], rect)];
                    //判断如果 宽<高 -向右旋转
                    if (rectImage.size.width < rectImage.size.height) {
                        NSLog(@"执行了-向右旋转");
                        rectImage = [self image:rectImage rotation:UIImageOrientationRight];
                    }
                    UIImage * tranImg = rectImage;//[WDOpenCVHelper UIImageBgTransparent:rectImage];
                    [self.arrImageUrl addObject:tranImg];
                }
                self.pdfUrl = picUrl;
                [self initSelPicView];
            } else {
                NSLog(@"错误")
                NSLog(@"error_msg :%@",responseJson[@"error_msg"]);
                [SVProgressHUD showErrorWithStatus:@"采集失败 请重新上传印模采集表"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task2, NSError * _Nonnull error2) {
            [SVProgressHUD ms_dismiss];
            NSLog(@"失败")
            [SVProgressHUD showErrorWithStatus:@"采集失败 请重新上传印模采集表"];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD ms_dismiss];
    }];
}



- (void)uploadImage:(UIImage *)image {

//    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    NSData *data = [WY_WLTools compressImage:image toByte:1000*1024];
 
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
       
        
        [SVProgressHUD showSuccessWithStatus:@"上传成功,正在进行识别..."];
        NSString *picUrl = json[@"data"];
        NSLog(@"picUrl:%@",picUrl);
        [self baiduOcr:picUrl withImage:[UIImage imageWithData:data]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD ms_dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
    
    
    
//    [mgr POST:str parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
//        [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
//        [SVProgressHUD ms_dismiss];
//        if ([json[@"code"] intValue] == 0) {
//            self.arrImageUrl = [[NSMutableArray alloc] initWithArray:json[@"data"]];
//            if (self.arrImageUrl.count == 3) {
//                self.selImgUrl = self.arrImageUrl[0];
//                [self initSelPicView];
//                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
//            } else {
//                [SVProgressHUD showErrorWithStatus:@"识别图片失败，请垂直拍摄电子签章印模采集表"];
//            }
//        } else {
//            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        [SVProgressHUD ms_dismiss];
//        [SVProgressHUD showErrorWithStatus:@"识别图片失败，请垂直拍摄电子签章印模采集表"];
//    }];
    
    
    
//    UIImage *image=[UIImage imageNamed:@"1.jpg"];
//
//       CGRect rect = CGRectMake(60, 80, 331, 353);//创建矩形框
//       UIImageView *contentView = [[UIImageView alloc] initWithFrame:rect];
//       contentView.image=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
       
}
//- (void)uploadImage:(UIImage *)image {
//    @"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=UXxOSwzbdGf6kHaP6Gk4Tbks&client_secret=1DKVFi9evvLbGdaAa6AXivZYXIs00HoB"
//
//    NSData *data = UIImageJPEGRepresentation(image, 0.1);
//    //上传图片
//    NSString * str = [GlobalConfig getAbsoluteUrl:zj_ca_signGot_HTTP];
//    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
//    [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
//    [dicPost setObject:@"" forKey:@"description"];
//
//    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//
//    [mgr POST:str parameters:dicPost headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
//        [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
//        [SVProgressHUD ms_dismiss];
//        if ([json[@"code"] intValue] == 0) {
//            self.arrImageUrl = [[NSMutableArray alloc] initWithArray:json[@"data"]];
//            if (self.arrImageUrl.count == 3) {
//                self.selImgUrl = self.arrImageUrl[0];
//                [self initSelPicView];
//                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
//            } else {
//                [SVProgressHUD showErrorWithStatus:@"识别图片失败，请垂直拍摄电子签章印模采集表"];
//            }
//        } else {
//            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        [SVProgressHUD ms_dismiss];
//        [SVProgressHUD showErrorWithStatus:@"识别图片失败，请垂直拍摄电子签章印模采集表"];
//    }];
//}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self uploadImage:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
//        OP_ImageShowViewController *tempController = [OP_ImageShowViewController new];
//        tempController.imgA = image;
//        tempController.imgB = image;
//        tempController.nsType = @"1";
//        tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
//            [self uploadImage:imgEdit];
//        };
//        [self.navigationController pushViewController:tempController animated:NO];
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
 

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

@end
