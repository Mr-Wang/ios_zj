//
//  WY_SignViewController.m
//  MigratoryBirds
//
//  Created by 王杨 on 2019/8/27.
//  Copyright © 2019 Doj. All rights reserved.
//

#import "WY_SignViewController.h"
#import "LJsignView.h"
#import "WDOpenCVHelper.h"
//#import "AliyunOSSiOS.h"
#import "UIImage+ColorImage.h"

@interface WY_SignViewController ()<LJsignViewDelegate>
@property (strong, nonatomic) UIImageView *imageShow;

@property (nonatomic,strong)LJsignView *signView;
@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_SignViewController
{
    NSString *PicFilePath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mUser = [MS_BasicDataController sharedInstance].user;

    [self craeteNav];
    [self makeUI];
//    [self bindView];
}
#pragma mark --调用接口-如果已经签名过-显示签名的图片
- (void)bindView {
//    if (self.mUser.grqm != nil) {
//        [self.imageShow sd_setImageWithURL:[NSURL URLWithString:self.mUser.grqm]];
//    }
}


- (void)craeteNav {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, JCNew64)];
//    [navView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgNavBg = [[UIImageView alloc] initWithFrame:navView.bounds];
//    [imgNavBg setImage:[UIImage imageNamed:@"navbg"]];
    [imgNavBg setBackgroundColor:MSTHEMEColor];
    [navView addSubview:imgNavBg];
    
    [self.view addSubview:navView];
    UIView *navViewLine = [[UIView alloc] initWithFrame:CGRectMake(0,navView.height - 1, kScreenWidth, 1)];
    [navViewLine setBackgroundColor:[UIColor lightGrayColor]];
    [navView addSubview:navViewLine];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, JCNew64 - 44, 60, 44)];
    [backBtn setImage:[UIImage imageNamed:@"白返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, backBtn.top, MSScreenW - 60 * 2, backBtn.height)];
    titleLabel.text = @"签名";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont  boldSystemFontOfSize:kHeight(18 * 2)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MSScreenW - 93, JCNew64 - 44, 88, 44)];
//    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [rightBtn setContentMode:UIViewContentModeCenter];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rightBtn];
}

- (void)makeUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _signView = [[LJsignView alloc]initWithFrame:CGRectMake(0, JCNew64, self.view.bounds.size.width, k360Width(300))];
    [self.view addSubview:_signView];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:_signView.frame];
    labelName.text = self.mUser.realname;
    [labelName setFont:WY_FONTMedium(288)];
    labelName.textAlignment = NSTextAlignmentCenter;
//    [labelName setBackgroundColor:[UIColor yellowColor]];
    labelName.adjustsFontSizeToFitWidth = YES;
    [labelName setTextColor:APPTextGayColor];
    [labelName setAlpha:0.2];
    labelName.minimumScaleFactor = 0.1; // 最小字体是原来字体的50%
    labelName.numberOfLines = 1; // 确保文本只显示一行
    [labelName setUserInteractionEnabled:NO];
    [self.view addSubview:labelName];
    
    UIView *navViewLine = [[UIView alloc] initWithFrame:CGRectMake(0,_signView.bottom - 1, kScreenWidth, 1)];
    [navViewLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:navViewLine];
    //    _signView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    _signView.backgroundColor = [UIColor whiteColor];
    _signView.delegate = self;
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, _signView.bottom + k360Width(10), 100, k360Width(33))];
    [lblTitle setTextColor: [UIColor blackColor]];
    lblTitle.text = @"签名预览：";
    [self.view addSubview:lblTitle];
    
    UILabel *lblTitleA = [[UILabel alloc] initWithFrame:CGRectMake(12, _signView.bottom - 34, kScreenWidth - 24, 33)];
    [lblTitleA setTextColor: [UIColor redColor]];
    if ([self.isSaveSign isEqualToString:@"1"]) {
        lblTitleA.text =    @"此签名将用于专家协议签署，请准确工整签写。";
    } else {
        lblTitleA.text = @"此签名将放入数字证书CA中，请准确工整签写。";
    }
    
    [lblTitleA setTextAlignment:NSTextAlignmentCenter];
    [lblTitleA setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lblTitleA];

     self.imageShow = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - k360Width(200) ) / 2, lblTitle.bottom + k360Width(10), k360Width(200), k360Width(200))];
    self.imageShow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageShow.layer.borderWidth = 1;
    [self.view addSubview:self.imageShow];
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), kScreenHeight - JC_TabbarSafeBottomMargin - k360Width(44 + 10), (MSScreenW - k360Width(16) *3) / 2, k360Width(44))];
    [btnSubmit setTitle:@"重签" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(clickResignBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.layer.masksToBounds = YES;
    btnSubmit.layer.cornerRadius = 6.0f;
     btnSubmit.titleLabel.font = [UIFont systemFontOfSize:kHeight(17*2)];
    btnSubmit.backgroundColor = MSTHEMEColor;
    
    [self.view addSubview:btnSubmit];
    
    UIButton *btnSubmit1 = [[UIButton alloc] initWithFrame:CGRectMake(btnSubmit.right + k360Width(16), kScreenHeight -  JC_TabbarSafeBottomMargin - k360Width(44 + 10), btnSubmit.width, k360Width(44))];
    [btnSubmit1 setTitle:@"确定" forState:UIControlStateNormal];
    [btnSubmit1 addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit1.layer.masksToBounds = YES;
    btnSubmit1.layer.cornerRadius = 6.0f;
    btnSubmit1.titleLabel.font = [UIFont systemFontOfSize:kHeight(17*2)];
    btnSubmit1.backgroundColor = MSTHEMEColor;
    
    [self.view addSubview:btnSubmit1];

    float showImageW = btnSubmit1.top - (lblTitle.bottom + k360Width(20));
    [self.imageShow setFrame:CGRectMake((kScreenWidth - showImageW ) / 2, lblTitle.bottom + k360Width(10), showImageW, showImageW)];
    
}

-(void)backButtonClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//去除图片的白色背景

- (UIImage*) imageToTransparent:(UIImage*) image

{

    // 分配内存

    const int imageWidth = image.size.width;

    const int imageHeight = image.size.height;

    size_t bytesPerRow = imageWidth * 4;

    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);

    

    // 创建context

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,

                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);

    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);

    

    // 遍历像素

    int pixelNum = imageWidth * imageHeight;

    uint32_t* pCurPtr = rgbImageBuf;

    for (int i = 0; i < pixelNum; i++, pCurPtr++)

    {

//        //去除白色...将0xFFFFFF00换成其它颜色也可以替换其他颜色。

//        if ((*pCurPtr & 0xFFFFFF00) >= 0xffffff00) {

//

//            uint8_t* ptr = (uint8_t*)pCurPtr;

//            ptr[0] = 0;

//        }

        //接近白色

        //将像素点转成子节数组来表示---第一个表示透明度即ARGB这种表示方式。ptr[0]:透明度,ptr[1]:R,ptr[2]:G,ptr[3]:B

        //分别取出RGB值后。进行判断需不需要设成透明。

        uint8_t* ptr = (uint8_t*)pCurPtr;

        if (ptr[1] > 240 && ptr[2] > 240 && ptr[3] > 240) {

            //当RGB值都大于240则比较接近白色的都将透明度设为0.-----即接近白色的都设置为透明。某些白色背景具有杂质就会去不干净，用这个方法可以去干净

            ptr[0] = 0;

        }

    }

     // 将内存转成image

    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, nil);

    

    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,

                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,

                                        NULL, true,kCGRenderingIntentDefault);

    CGDataProviderRelease(dataProvider);

    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];

    // 释放

    CGImageRelease(imageRef);

    CGContextRelease(context);

    CGColorSpaceRelease(colorSpace);

    return resultUIImage;

}


- (void)rightButtonClick:(UIButton *)sender {
    NSLog(@"点击了确定");
    if (self.imageShow.image !=nil) {
        //图片上传至OSS
     //压缩PNG图片
        NSData *data = UIImagePNGRepresentation([WDOpenCVHelper UIImageBgTransparent:[self.imageShow.image imageByScalingAndCroppingForSize:CGSizeMake(300, 300)]]);
        
        

        NSLog(@"上传图片大小：%ld",data.length);
        //上传图片
        NSString * str = [GlobalConfig getAbsoluteUrl:EuploadFile_HTTP];
        NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
        [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
        [dicPost setObject:@"" forKey:@"description"];
        
        
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        [mgr POST:str parameters:dicPost headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *imageName = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
            [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"MultipartFile"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
            [SVProgressHUD ms_dismiss];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            NSString *picUrl = json[@"data"];
            NSLog(@"生成地址：%@",picUrl);
            [self saveGrqm:picUrl];
 
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD ms_dismiss];
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }];

        /*
        //图片保存的路径
        
        //这里将图片放在沙盒的documents文件夹中
        
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        
        
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        
        
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingFormat:@"/%@",imageName] contents:data attributes:nil];
        
        
        //得到选择后沙盒中图片的完整路径
        PicFilePath = [[NSString alloc]initWithFormat:@"%@/%@",DocumentsPath, imageName];
        
        NSLog(@"%@",PicFilePath);
        //   背景图
        
        
        NSArray* PicPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* PicDocumentsDirectory = [PicPaths objectAtIndex:0];
        NSString* PicFullPathToFile = [PicDocumentsDirectory stringByAppendingPathComponent:imageName];
        
        NSString *str=[NSString stringWithFormat:@"%@%@",BASE_IP,UPLOADPIC_HTTP];
               
       NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
               
      [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
               
               [dicPost setObject:@"" forKey:@"description"];
                     
        NSMutableURLRequest *PicRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:str parameters:dicPost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
#pragma mark   //添加转圈
            [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
            
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:PicFullPathToFile] name:@"file" fileName:PicFullPathToFile mimeType:@"image/png" error:nil];
        } error:nil];
        [PicRequest setValue:[MS_BasicDataController sharedInstance].user.token forHTTPHeaderField:@"token"];
        [PicRequest setValue:[MS_BasicDataController sharedInstance].user.UserGuid forHTTPHeaderField:@"UserGuid"];
        AFURLSessionManager *PicManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        //        NSProgress *PicProgress = nil;
        
        NSURLSessionUploadTask *PicUploadTask = [PicManager uploadTaskWithStreamedRequest:PicRequest progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [SVProgressHUD ms_dismiss];
            if (error) {
                //                [MBProgressHUD showError:@"上传失败"];
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                
            } else {
//                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                NSDictionary *dic=responseObject;
                
                NSString *fileurl=[NSString stringWithFormat:@"%@",dic[@"data"]];
                
                NSMutableDictionary *dicImage = [NSMutableDictionary dictionary];
                [dicImage setValue:fileurl forKey:@"fileurl"];
                [dicImage setValue:image forKey:@"image"];
                NSLog(@"上传图片路径：%@",fileurl);
                //签名图片保存-提交接口并保存到本地；
                [self saveGrqm:fileurl];
            }
        }];
        
        [PicUploadTask resume];
        //*/
    }
}
- (void)saveGrqm:(NSString *)grqmImgName {
    if (self.popVCBlock) {
        self.popVCBlock(grqmImgName);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
//    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
//    [dicPost setObject:grqmImgName forKey:@"grqm"];
//    [dicPost setObject:self.mUser.username forKey:@"username"];
//    [[MS_BasicDataController sharedInstance] postWithURL:UPDATESYSUSER_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id successCallBack) {
//        if (successCallBack) {
//            [SVProgressHUD showSuccessWithStatus:@"签名录入成功"];
//            self.mUser.grqm = grqmImgName;
//            [MS_BasicDataController sharedInstance].user = self.mUser;
//             [self dismissViewControllerAnimated:YES completion:nil];
//
//        } else {
//         }
//    } failure:^(NSString *failureCallBack) {
//        [SVProgressHUD showErrorWithStatus:failureCallBack];
//    } ErrorInfo:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
//    }];
}

- (void)LJsignViewDelegateWithImage:(UIImage *)image{
    
    self.imageShow.image = image;//[WDOpenCVHelper UIImageBgTransparent:image];
}
- (void)clickResignBtn:(UIButton *)sender {
    [_signView clearSignature];
    
    self.imageShow.image = nil;
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
