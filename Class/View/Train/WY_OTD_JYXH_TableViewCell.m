//
//  WY_OTD_JYXH_TableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OTD_JYXH_TableViewCell.h"
#import "WY_selPicView.h"
 
#import "WY_SelMajorView.h"
#import "ImageNewsDetailViewController.h"
#import "WY_ParamExpertModel.h"
#import "SLCustomActivity.h"
#import <AVFoundation/AVFoundation.h>
#import "OP_ImageShowViewController.h"

@interface WY_OTD_JYXH_TableViewCell(){
    UIImageView *imgLine;
    int lastY;
    NSString *picType;
}
@end

@implementation WY_OTD_JYXH_TableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self makeUI];
     }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        self.userInteractionEnabled = YES;
        [self makeUI];
     }
    return self;
}

- (void)makeUI {
    [self.contentView setBackgroundColor:HEXCOLOR(0xF4F5F9)];
    self.viewTop1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k375Width(150))];
    self.viewTop2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewTop1.bottom + k375Width(10), kScreenWidth, k375Width(150))];
    
    
    self.viewTop3A = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewTop2.bottom + k375Width(10), kScreenWidth, k375Width(150))];
      
        self.viewTop3 = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewTop3A.bottom + k375Width(10), kScreenWidth, k375Width(150))];
    

    
    [self.viewTop1 setBackgroundColor:[UIColor whiteColor]];
    [self.viewTop2 setBackgroundColor:[UIColor whiteColor]];
    [self.viewTop3 setBackgroundColor:[UIColor whiteColor]];
    [self.viewTop3A setBackgroundColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:self.viewTop1];
    [self.contentView addSubview:self.viewTop2];
    [self.contentView addSubview:self.viewTop3];
    [self.contentView addSubview:self.viewTop3A];
    
    
    
    UILabel *lblTop1 = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop1 setNumberOfLines:2];
    [lblTop1 setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop1Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attTop1Str setYy_font:WY_FONTMedium(14)];
    [attTop1Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop1Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传报名表附件"];
    [attTop1Str1 setYy_font:WY_FONTMedium(14)];
    [attTop1Str1 setYy_color:[UIColor blackColor]];
    
    [attTop1Str appendAttributedString:attTop1Str1];
    
    lblTop1.attributedText = attTop1Str;
    
    
    UIButton *btnDownMuBan = [UIButton new];
    [btnDownMuBan setFrame:CGRectMake(kScreenWidth - k360Width(76), 10, k360Width(60), k360Width(22))];
    [btnDownMuBan setCenterY:lblTop1.centerY];
    [btnDownMuBan rounded:k360Width(40/8)];
    [btnDownMuBan setBackgroundColor:MSTHEMEColor];
    [btnDownMuBan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDownMuBan setTitle:@"下载模板" forState:UIControlStateNormal];
    [btnDownMuBan.titleLabel setFont:WY_FONTRegular(12)];
    [btnDownMuBan addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"分享");
        if (self.selShareBlock) {
            self.selShareBlock(@"辽宁省工程建设项目招标投标领域公平竞争审查专家报名表.pdf", @"https://www.capass.cn/Avatar/gpjz.pdf");
        }
    }];
    
    [self.viewTop1 addSubview:lblTop1];
    [self.viewTop1 addSubview:btnDownMuBan];
    
    
    
    //---
    self.scrollViewImgsTop1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop1 addSubview:self.scrollViewImgsTop1];
    
    
    UILabel *lblTop2Ts = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop2Ts setNumberOfLines:2];
    [lblTop2Ts setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop2Str = [[NSMutableAttributedString alloc] initWithString:@""];
    [attTop2Str setYy_font:WY_FONTMedium(14)];
    [attTop2Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop2Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传获得职称情况"];
    [attTop2Str1 setYy_font:WY_FONTMedium(14)];
    [attTop2Str1 setYy_color:[UIColor blackColor]];
    
    [attTop2Str appendAttributedString:attTop2Str1];
    
    lblTop2Ts.attributedText = attTop2Str;
    
    
    [self.viewTop2 addSubview:lblTop2Ts];
    
    self.scrollViewImgsTop2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop2 addSubview:self.scrollViewImgsTop2];
    
    
    UILabel *lblTop3ATs = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop3ATs setNumberOfLines:2];
    [lblTop3ATs setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop3AStr = [[NSMutableAttributedString alloc] initWithString:@""];
    [attTop3AStr setYy_font:WY_FONTMedium(14)];
    [attTop3AStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop3AStr1 = [[NSMutableAttributedString alloc] initWithString:@"请上传代表性案例、著作、论文情况"];
    [attTop3AStr1 setYy_font:WY_FONTMedium(14)];
    [attTop3AStr1 setYy_color:[UIColor blackColor]];
    [attTop3AStr appendAttributedString:attTop3AStr1];
    lblTop3ATs.attributedText = attTop3AStr;
    [self.viewTop3A addSubview:lblTop3ATs];
    self.scrollViewImgsTop3A = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop3A addSubview:self.scrollViewImgsTop3A];

    
    UILabel *lblTop3Ts = [[UILabel alloc] initWithFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(24), k375Width(54))];
    [lblTop3Ts setNumberOfLines:2];
    [lblTop3Ts setFont:[UIFont fontWithName:@"Source Han Sans SC" size: k375Width(16)]];
    NSMutableAttributedString *attTop3Str = [[NSMutableAttributedString alloc] initWithString:@""];
    [attTop3Str setYy_font:WY_FONTMedium(14)];
    [attTop3Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop3Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传奖惩情况"];
    [attTop3Str1 setYy_font:WY_FONTMedium(14)];
    [attTop3Str1 setYy_color:[UIColor blackColor]];
    
    [attTop3Str appendAttributedString:attTop3Str1];
    
    lblTop3Ts.attributedText = attTop3Str;
    
    
    [self.viewTop3 addSubview:lblTop3Ts];
     
    self.scrollViewImgsTop3 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k375Width(44), kScreenWidth, k375Width(120))];
    
    [self.viewTop3 addSubview:self.scrollViewImgsTop3];

    
 
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16),self.viewTop3.bottom + k360Width(16),kScreenWidth - k360Width(32), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];

    
  }

- (void)showCell
{
    
    self.arrEttachmentUrl = [NSMutableArray new];
    [self initSBImgs];

    
    self.arrEttachmentZhiCUrl = [NSMutableArray new];
    [self initSheBaoImgs];
    
    //绑定保证书照片；
    self.arrEttachmentWorkUrl = [NSMutableArray new];
    [self initBaoZhengImgs];
    
    self.arrEttachmentAwardUrl = [NSMutableArray new];
    [self initBaoZhengAImgs];
    
    [imgLine setFrame:CGRectMake(k360Width(16),self.viewTop3.bottom,kScreenWidth - k360Width(32), 1)];

    self.height = imgLine.bottom;
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



/// 初始化设备Imgs
- (void)initSheBaoImgs {
    [self.scrollViewImgsTop2 removeAllSubviews];
    
    float lastX = k375Width(12);
    int i = 0;
    for (NSString *imgUrl in self.arrEttachmentZhiCUrl) {
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
    for (NSString *imgUrl in self.arrEttachmentZhiCUrl) {
        IWPictureModel* picModel  = [IWPictureModel new];
        picModel.nsbmiddle_pic = imgUrl;
        picModel.nsoriginal_pic = imgUrl;
        [picModels addObject:picModel];
    }
    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
    indvController.mIWPictureModel = [picModels objectAtIndex:btnSender.tag];
    indvController.picArr = picModels;
    [self.vcSender.navigationController pushViewController:indvController animated:YES];
    
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
    [self.vcSender.navigationController pushViewController:indvController animated:YES];
    
}
- (void)btnBaoZhengImgAction:(UIButton *)btnSender {
    //打开图片；
    NSMutableArray *picModels = [NSMutableArray new];
    for (NSString *imgUrl in self.arrEttachmentWorkUrl) {
        IWPictureModel* picModel  = [IWPictureModel new];
        picModel.nsbmiddle_pic = imgUrl;
        picModel.nsoriginal_pic = imgUrl;
        [picModels addObject:picModel];
    }
    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
    indvController.mIWPictureModel = [picModels objectAtIndex:btnSender.tag];
    indvController.picArr = picModels;
    [self.vcSender.navigationController pushViewController:indvController animated:YES];
    
}




- (void)btnBaoZhengAImgAction:(UIButton *)btnSender {
    //打开图片；
    NSMutableArray *picModels = [NSMutableArray new];
    for (NSString *imgUrl in self.arrEttachmentAwardUrl) {
        IWPictureModel* picModel  = [IWPictureModel new];
        picModel.nsbmiddle_pic = imgUrl;
        picModel.nsoriginal_pic = imgUrl;
        [picModels addObject:picModel];
    }
    ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
    indvController.mIWPictureModel = [picModels objectAtIndex:btnSender.tag];
    indvController.picArr = picModels;
    [self.vcSender.navigationController pushViewController:indvController animated:YES];
    
}


- (void)btnSBDelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrEttachmentUrl removeObjectAtIndex:btnSender.tag];
    [self initSBImgs];
}
- (void)btnDelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrEttachmentZhiCUrl removeObjectAtIndex:btnSender.tag];
    [self initSheBaoImgs];
}
- (void)btnBaoZhengDelAction:(UIButton *)btnSender {
    //删除图片
    [self.arrEttachmentWorkUrl removeObjectAtIndex:btnSender.tag];
    [self initBaoZhengImgs];
}
- (void)btnBaoZhengADelAction:(UIButton *)btnSender {
     //删除图片
    [self.arrEttachmentAwardUrl removeObjectAtIndex:btnSender.tag];
    [self initBaoZhengAImgs];
}
/// 初始化保证书Imgs
- (void)initBaoZhengImgs {
    [self.scrollViewImgsTop3 removeAllSubviews];
    float lastX = k375Width(12);
    int i = 0;
    for (NSString *imgUrl in self.arrEttachmentWorkUrl) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop3 addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnBaoZhengImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnBaoZhengDelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        i ++;
    }
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addBaoZhengPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewImgsTop3 addSubview:tempBtnAdd];
    
    [self.scrollViewImgsTop3 setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
 }

/// 初始化保证书Imgs
- (void)initBaoZhengAImgs {
    [self.scrollViewImgsTop3A removeAllSubviews];
    float lastX = k375Width(12);
    int i = 0;
    for (NSString *imgUrl in self.arrEttachmentAwardUrl) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewImgsTop3A addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnBaoZhengImgAction:) forControlEvents:UIControlEventTouchUpInside];
        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnBaoZhengADelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        i ++;
    }
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addBaoZhengAPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewImgsTop3A addSubview:tempBtnAdd];
    
    [self.scrollViewImgsTop3A setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
 }

- (void)addSBPicAction {
    picType = @"2";
    [self navRightAddPhotoAction];
}
- (void)addSheBaoPicAction {
    //添加社保-图片；
    picType = @"3";
    [self navRightAddPhotoAction];
}
- (void)addBaoZhengPicAction {
    //添加社保-图片；
    picType = @"baozheng";
    [self navRightAddPhotoAction];
}
- (void)addBaoZhengAPicAction {
    //添加社保-图片；
    picType = @"baozhengA";
    [self navRightAddPhotoAction];
}



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
    
    [self.vcSender presentViewController:alertControl animated:YES completion:nil];
}



//开始拍照
-(void)takePhoto
{
    
//    OP_CameraViewController *tempController = [OP_CameraViewController new];
//    tempController.selEditEndImageBlock = ^(UIImage * _Nonnull imgEdit) {
//        [self uploadImage:imgEdit];
//    };
//    [self.vcSender.navigationController pushViewController:tempController animated:YES];
    
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
        [self.vcSender presentViewController:picker animated:YES completion:nil];
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
    [self.vcSender presentViewController:picker animated:YES completion:nil];
    
    
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
            [self.arrEttachmentZhiCUrl addObject:picUrl];
            [self initSheBaoImgs];
        } else if ([picType isEqualToString:@"2"]) {
            //设备添加图片成功；
            [self.arrEttachmentUrl addObject:picUrl];
            [self initSBImgs];
        } else if ([picType isEqualToString:@"baozheng"]) {
            //设备添加图片成功；
            [self.arrEttachmentWorkUrl addObject:picUrl];
            [self initBaoZhengImgs];
        } else if ([picType isEqualToString:@"baozhengA"]) {
            //设备添加图片成功；
            [self.arrEttachmentAwardUrl addObject:picUrl];
            [self initBaoZhengAImgs];
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
        [self.vcSender.navigationController pushViewController:tempController animated:NO];
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
