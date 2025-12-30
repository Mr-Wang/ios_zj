//
//  WY_TrainDetailsViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/12.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_TrainDetailsViewController.h"
#import "EmptyView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#import "ZBWKWebView.h"
#import "WKWebView+CheckImage.h"
#import "WY_TraCourseDetailModel.h"
#import "ImageNewsDetailViewController.h"
#import "NSDate+Extension.h"
#import "WY_SignUpViewController.h"
#import "WY_LoginViewController.h"
#import "WY_UserInfoViewController.h"


#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>

@interface WY_TrainDetailsViewController ()<WKUIDelegate,WKScriptMessageHandler,WKScriptMessageHandler,WKNavigationDelegate>{
    
    //    导航条高度
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    
    UIButton *btnFootZan;
    UIButton *btnFootZhuan;
    UIImageView *imgNoBg;
    UILabel *lblNoBg;
    UIButton *btnLeft;
}

@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) ZBWKWebView *webView;
@property (nonatomic,strong) EmptyView *emptyView;
@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic,strong) UIView *webHeaderView;
@property (nonatomic,strong)WY_TraCourseDetailModel *mWY_TraCourseDetailModel;
@end

@implementation WY_TrainDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    //默认是全部
    [self makeUI];
    [self bindView];
}


- (void)viewWillAppear:(BOOL)animated {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
}

- (void)makeUI {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.preferences = [[WKPreferences alloc] init];
    
    //    config.userContentController = [[WKUserContentController alloc] init];
    
    config.processPool = [[WKProcessPool alloc] init];
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    config.userContentController = wkUController;
    
    
    self.webView = [[ZBWKWebView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH-JCNew64 - JC_TabbarSafeBottomMargin)
                    
                                        configuration:config];
    
    
    //记得实现对应协议,不然方法不会实现.
    
    self.webView.UIDelegate = self;
    
    self.webView.navigationDelegate =self;
    
    //              WKWebView *contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    
    
    [self.view addSubview:self.webView];
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH-JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    self.emptyView.hidden = YES;
    [self.emptyView.contentLabel setText:@"暂无"];
    [self.view addSubview:self.emptyView];
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(15), kScreenHeight - k360Width(50) - JCNew64 - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(30), k360Width(40))];
    [btnLeft.titleLabel setFont:WY_FONTMedium(14)];
    [btnLeft setTitle:@"立即报名" forState:UIControlStateNormal];
    [btnLeft rounded:k360Width(40/8)];
    [btnLeft setBackgroundColor:MSTHEMEColor];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLeft];
    [btnLeft setHidden:YES];
    
}
- (void)bindView {
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mWY_TrainItemModel.rowGuid forKey:@"id"];
    [postDic setObject:self.mUser.idcardnum forKey:@"baomingidcard"];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getTraCourseDetail_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            self.mWY_TraCourseDetailModel = [WY_TraCourseDetailModel modelWithJSON:res[@"data"]];
            NSString *lessonDetail = [self.mWY_TraCourseDetailModel.LessonDetail stringByReplacingOccurrencesOfString:@"<table width=\"544\"" withString:@"<table width=\"300\""];
            lessonDetail = [self.mWY_TraCourseDetailModel.LessonDetail stringByReplacingOccurrencesOfString:@"408.15pt" withString:@"300pt"];
            
            [self.webView loadHTMLString:lessonDetail baseURL:[NSURL URLWithString:BASE_IP]];
            [self makeHeaderView];
            //
            self.webView.height = kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin;
            
            if ([[NSDate date] minutesBeforeDate:[NSDate dateWithString:self.mWY_TraCourseDetailModel.LiveEndTime format:@"yyyy-MM-dd HH:mm:ss" timeZone:nil locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]]] >= 0) {
                self.webView.height = kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin;
                [btnLeft setHidden:NO];
                if ([self.mWY_TraCourseDetailModel.alreadybaomingnum intValue] >= [self.mWY_TraCourseDetailModel.baomingnum intValue]) {
                    [btnLeft setTitle:@"报名已满" forState:UIControlStateNormal];
                }
            } else {
                self.webView.height = kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin;
                [btnLeft setHidden:YES];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

///验证是否企业用户
- (BOOL) verificationIsOrgUser {
    //    if (self.mUser.orgnum !=nil && self.mUser.orgnum.length > 0) {
    if (EXPERTISMIND == 1 || EXPERTISMIND ==2) {
        [SVProgressHUD showInfoWithStatus:@"此功能仅对正式专家用户开放，感谢您的使用和支持。"];
        return NO;
    }
    if ([self.mUser.UserType isEqualToString:@"1"]) {
             return  YES;
    } else {
        [SVProgressHUD showInfoWithStatus:@"该培训只有专家可以报名参加。"];
        return NO;
    }
}
-(void)makeHeaderView{
    self.webHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,300)];
    
    _webView.isSameColorWithHeaderView = NO;
    _webView.headerView = self.webHeaderView;
    
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(200))];
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), imgHead.bottom + k360Width(16), k360Width(150), k360Width(36))];
    [lblPrice setFont: WY_FONTMedium(22)];
    
    UIImageView *iconCount = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(230), lblPrice.bottom - k360Width(12), k360Width(12), k360Width(12))];
    [iconCount setImage:[UIImage imageNamed:@"icon_bamrs"]];
    UILabel *lblCount = [[UILabel alloc] initWithFrame:CGRectMake(iconCount.right + k360Width(5), iconCount.top, k360Width(108), k360Width(12))];
    [lblCount setFont: WY_FONTRegular(12)];
    
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(lblPrice.left, lblPrice.bottom + k360Width(5), kScreenWidth - k360Width(32), k360Width(54))];
    [lblTitle setNumberOfLines:2];
    [lblTitle setFont: WY_FONTMedium(16)];
    
    UIImageView *imgLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblTitle.bottom + k360Width(10), kScreenWidth, k360Width(10))];
    [imgLine1 setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), imgLine1.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(120))];
    [lblContent setFont: WY_FONTMedium(14)];
    [lblContent setNumberOfLines:0];
    [lblContent setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIImageView *imgLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, lblContent.bottom + k360Width(10), kScreenWidth, k360Width(10))];
    [imgLine2 setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    UILabel *lblKcjs = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), imgLine2.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(24))];
    [lblKcjs setFont: WY_FONTMedium(16)];
    
    
    
    [self.webHeaderView addSubview:lblTitle];
    [self.webHeaderView addSubview:lblPrice];
    [self.webHeaderView addSubview:lblCount];
    [self.webHeaderView addSubview:imgHead];
    [self.webHeaderView addSubview:iconCount];
    [self.webHeaderView addSubview:imgLine1];
    [self.webHeaderView addSubview:imgLine2];
    [self.webHeaderView addSubview:lblKcjs];
    [self.webHeaderView addSubview:lblContent];
    
    
    
    if ([self.mWY_TrainItemModel.Photo rangeOfString:@"https://"].length <= 0 && [self.mWY_TrainItemModel.Photo rangeOfString:@"http://"].length <= 0) {
        [imgHead sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://www.lnwlzb.com:8086/EpointFrame/%@",self.mWY_TrainItemModel.Photo]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];
    } else {
        [imgHead sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TrainItemModel.Photo]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];
        
    }
    
    lblTitle.text = self.mWY_TraCourseDetailModel.Title;
    
    NSString *baomingNumStr = self.mWY_TraCourseDetailModel.alreadybaomingnum;
    if ([self.mWY_TraCourseDetailModel.alreadybaomingnum intValue] >= [self.mWY_TraCourseDetailModel.baomingnum intValue]) {
        baomingNumStr = self.mWY_TraCourseDetailModel.baomingnum;
    }
    lblCount.text = [NSString stringWithFormat:@"%@/%@人报名",baomingNumStr,self.mWY_TraCourseDetailModel.baomingnum];
    
    lblPrice.text = [NSString stringWithFormat:@"￥%@",self.mWY_TrainItemModel.Price];
    [lblPrice setTextColor:HEXCOLOR(0xD94C5A)];
    //隐藏掉付费内容；
    [lblPrice setHidden:YES];
    
    lblKcjs.text = @"课程介绍";
    NSMutableAttributedString *attContent = nil;
    if  ([self.mWY_TraCourseDetailModel.isNeedAttachment intValue] == 1) {
        attContent = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"报名开始时间：%@\n报名结束时间：%@",self.mWY_TraCourseDetailModel.LiveStartTime,self.mWY_TraCourseDetailModel.LiveEndTime]];
    } else {
        attContent = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"报名开始时间：%@\n报名结束时间：%@\n开  课  时  间：%@\n上  课  地  址：%@\n",self.mWY_TraCourseDetailModel.LiveStartTime,self.mWY_TraCourseDetailModel.LiveEndTime,self.mWY_TraCourseDetailModel.coursestarttime,self.mWY_TraCourseDetailModel.courseaddress]];
    }
    if (self.mWY_TraCourseDetailModel.authCode.length > 0) {
        [attContent yy_appendString:[NSString stringWithFormat:@"邀  请  码 ：%@\n",self.mWY_TraCourseDetailModel.authCode]];
    }
    [attContent setYy_lineSpacing:5];
    lblContent.attributedText = attContent;
    
    [lblContent sizeToFit];
    lblContent.height += 10;
    
    imgLine2.top = lblContent.bottom + k360Width(10);
    
    lblKcjs.top = imgLine2.bottom + k360Width(16);
    self.webHeaderView.height = lblKcjs.bottom + k360Width(16);
    
}

#pragma mark-  WKNavigationDelegate
//页面开始加载时调用
- (void)webView:(WKWebView * _Nonnull)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
    [_webView setupHeaderViewForWebView:(ZBWKWebView *)webView];
}

//页面完成加载时调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_webView setupFooterViewForWebView:(ZBWKWebView *)webView];
    
    [_progressLayer finishedLoad];
    self.emptyView.hidden = YES;
    //通过js获取htlm中图片ur
    //        [webView getImageUrlByJS:webView];
    
    [self.webView addTapImageGesture];
    self.webView.block = ^(NSString * _Nonnull imgUrl) {
        NSLog(@"imgUrl:%@",imgUrl);
        IWPictureModel* picModel  = [IWPictureModel new];
        picModel.nsbmiddle_pic = imgUrl;
        picModel.nsoriginal_pic = imgUrl;
        ImageNewsDetailViewController *indvController = [ImageNewsDetailViewController new];
        indvController.mIWPictureModel = picModel;
        indvController.picArr = @[picModel];
        [self.navigationController pushViewController:indvController animated:YES];
    };
}

// 类似  的 -webView: shouldStartLoadWithRequest: navigationType:

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark WKUIDelegate,WKNavigationDelegate

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    
    
}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [_progressLayer finishedLoad];
    self.emptyView.hidden = NO;
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"blank_pic_02"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"blank_pic_02"];
    
    [self.emptyView.contentLabel setText:@"加载失败"];
}



- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message?:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message?:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)btnLeftAction {
    NSLog(@"点击了立即报名");
    //判断登录状态
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
        return;
    }
    //如果是指允许企业用户报名的课程 - 当前人不是企业用户-return；
    if ([self.mWY_TraCourseDetailModel.alreadybaomingnum intValue] >= [self.mWY_TraCourseDetailModel.baomingnum intValue]) {
        [SVProgressHUD showErrorWithStatus:@"本期培训报名人数已满，下次还有机会学习，感谢您的支持和理解！"];
        return;
    }
    if (self.mUser.idcardnum.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请到个人信息页面完善身份证号和姓名"];
        WY_UserInfoViewController *tempController = [WY_UserInfoViewController new];
        [self.navigationController pushViewController:tempController animated:YES];
        
        return;
    }
    //如果接口返回全部可以报名 - 或者当前角色是”监管=3“ 可以报名
    if ([self.mWY_TraCourseDetailModel.isallowqy isEqualToString:@"1"] || [self.mUser.orgtype isEqualToString:@"3"]) {
        WY_SignUpViewController *tempController = [WY_SignUpViewController new];
        tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
        tempController.canGovNum = [self.mWY_TraCourseDetailModel.alreadybaomingnum intValue] - [self.mWY_TraCourseDetailModel.baomingnum intValue];
        [self.navigationController pushViewController:tempController animated:YES];
    } else {
        if  ([self.mWY_TraCourseDetailModel.isNeedAttachment intValue] == 1) {
            WS(weakSelf);
            NSMutableDictionary *postDic = [NSMutableDictionary new];
            [postDic setObject:self.mUser.UserGuid forKey:@"userGuid"];
            [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
            [[MS_BasicDataController sharedInstance] postWithReturnCode:expert_getExpertIdentity_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                if ([code integerValue] == 0 ) {
                    if (((NSArray *)res[@"data"]).count > 0) {
                        NSMutableArray *objectArr = [[NSMutableArray alloc] initWithArray:res[@"data"]];
                        BOOL isFormal = NO;
                        for (NSDictionary *dicItem in objectArr) {
                            if  ([dicItem[@"isFormal"] intValue] == 1 || [dicItem[@"isFormal"] intValue] == 2) {
                                isFormal = YES;
                                break;
                            }
                        }
                        if (isFormal) {
                            WY_SignUpViewController *tempController = [WY_SignUpViewController new];
                            tempController.mWY_TraCourseDetailModel = weakSelf.mWY_TraCourseDetailModel;
                            tempController.canGovNum = [weakSelf.mWY_TraCourseDetailModel.alreadybaomingnum intValue] - [self.mWY_TraCourseDetailModel.baomingnum intValue];
                            [weakSelf.navigationController pushViewController:tempController animated:weakSelf];
                        } else {
                            //这里加判断isFormal
                            [SVProgressHUD showInfoWithStatus:@"该活动只有正式专家可以报名参加。"];
                            
                        }
                    } else {
                        //这里加判断isFormal
                        [SVProgressHUD showInfoWithStatus:@"该活动只有正式专家可以报名参加。"];
                    }
                }else {
                    //这里加判断isFormal
                    [SVProgressHUD showInfoWithStatus:@"该活动只有正式专家可以报名参加。"];
                }
            } failure:^(NSError *error) {
                //这里加判断isFormal
                [SVProgressHUD showInfoWithStatus:@"该活动只有正式专家可以报名参加。"];
            }];
        } else {
            if ([self verificationIsOrgUser]) {
                //报名前验证人脸
                //如果当前培训 不需要考试- 不人脸
                if ([self.mWY_TraCourseDetailModel.examType isEqualToString:@"0"]) {
                    WY_SignUpViewController *tempController = [WY_SignUpViewController new];
                    tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
                    tempController.canGovNum = 1;
                    [self.navigationController pushViewController:tempController animated:YES];
                } else {
                    //                [self smrzxxIsBelow];
                    //                [self VFace];
                    //工信部要求去掉人脸
                    NSLog(@"进入功能");
                    WY_SignUpViewController *tempController = [WY_SignUpViewController new];
                    tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
                    tempController.canGovNum = 1;
                    [self.navigationController pushViewController:tempController animated:YES];
                    
                }
                
            }
        }
        
    }
}


///判断今天是否进行过人脸识别
- (void)smrzxxIsBelow {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:bidevaluationSmrzxxIsBelow_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            //不需要人脸识别
            WY_SignUpViewController *tempController = [WY_SignUpViewController new];
            tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
            tempController.canGovNum = 1;
            [self.navigationController pushViewController:tempController animated:YES];
        } else {
            //需要人脸识别
            //            [self VFace];
            //工信部要求去掉人脸
            NSLog(@"进入功能");
            WY_SignUpViewController *tempController = [WY_SignUpViewController new];
            tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
            tempController.canGovNum = 1;
            [self.navigationController pushViewController:tempController animated:YES];
            
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
    }];
    
}
///验证人脸
- (void) VFace {
    //开始人脸识别；
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    LivingConfigModel* model = [LivingConfigModel sharedInstance];
    [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:NO completion:nil];
    WS(weakSelf);
    lvc.faceSuceessBlock = ^(UIImage *imgFace) {
        //人脸 识别成功后- 调用接口
        [weakSelf performSelectorOnMainThread:@selector(submitData:) withObject:imgFace waitUntilDone:YES];
    };
}
//人脸 识别成功后- 调用接口
- (void)submitData:(UIImage *)imgFace {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.realname forKey:@"name"];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [dicPost setObject:self.mUser.LoginID forKey:@"loginId"];
    [dicPost setObject:[self UIImageToBase64Str:imgFace] forKey:@"base64Str"];
    
    WS(weakSelf);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:ZJsmrzxx_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 && res) {
            //            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            [self.view makeToast:res[@"msg"]];
            NSLog(@"进入功能");
            WY_SignUpViewController *tempController = [WY_SignUpViewController new];
            tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
            tempController.canGovNum = 1;
            [self.navigationController pushViewController:tempController animated:YES];
        } else {
            if ([code integerValue] == 2)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"比对不一致，请准备以下资料发至lnwlzb@163.com邮箱\n（1、身份证正反面；\n2、近期照片；\n3、超时截图；\n4、姓名及联系方式）。" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"我已了解" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
}
//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
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
