//
//  MS_WKwebviewsViewController.m
//  MigratoryBirds
//
//  Created by Doj on 2018/7/13.
//  Copyright © 2018年 Doj. All rights reserved.
//

#import "MS_WKwebviewsViewController.h"
#import "EmptyView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#import "SLCustomActivity.h"
#import "WY_ExpertRegistrationViewController.h"

#import <AipOcrSdk/AipOcrSdk.h>
#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "WY_UserInfoViewController.h"


@interface MS_WKwebviewsViewController ()<WKUIDelegate,WKScriptMessageHandler,WKScriptMessageHandler,WKNavigationDelegate>
{
    //    导航条高度
    CGFloat _statusHeight;
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    
    
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,strong) EmptyView *emptyView;
@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) UIButton *btnZhengJi;

///身份证OCR结果
@property (nonatomic, strong) NSMutableDictionary *dicIDCard;
@property (nonatomic, strong) NSString *isIdCardSuccess;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation MS_WKwebviewsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
 }

- (void)clearWebCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = MSTHEMEColor;
UIImage *navImg =[UIImage imageNamed:@"navbg"];
navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
 
[self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;


if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance setBackgroundColor:MSTHEMEColor];
    // 隐藏分割线 设置一个透明或者纯色的图片 设置nil 或者 [UIImage new]无效
    [appearance setBackgroundImage:navImg];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    appearance.titleTextAttributes = attrs;
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
     }

[[UINavigationBar appearance] setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];

    
    [self clearWebCache];
    //计算状态栏高度，iphoneX是44  其他是20。
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    _statusHeight =statusBarFrame.size.height+44;
    
    self.navigationItem.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    

    if ([self.isShare isEqualToString:@"1"]) {
        //添加分享按钮；
        UIButton *cancleButton = [[UIButton alloc] init];
        cancleButton.frame = CGRectMake(0, 0, 44, 44);
        [cancleButton setTitle:@"分享" forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
        self.navigationItem.rightBarButtonItem = rightItem;

    }
    if ([self.isLxy isEqualToString:@"1"]) {
        //添加分享按钮；
        UIImage * imgFK = [[UIImage imageNamed:@"yjfk"] imageByResizeToSize:CGSizeMake(34, 34)];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:imgFK style:UIBarButtonItemStyleDone target:self action:@selector(navRight1Action)];
        self.navigationItem.rightBarButtonItem = rightItem;

    }
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.preferences = [[WKPreferences alloc] init];
    
//    config.userContentController = [[WKUserContentController alloc] init];
    
    config.processPool = [[WKProcessPool alloc] init];
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
     config.userContentController = wkUController;

    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH-_statusHeight)
                    
                                      configuration:config];
    
    
    //记得实现对应协议,不然方法不会实现.
    
    self.webView.UIDelegate = self;
    
    self.webView.navigationDelegate =self;
    
//              WKWebView *contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
          
    
    [self.view addSubview:self.webView];
 

    
    if ([self.type isEqualToString:@"html"]) {
        [self.webView loadHTMLString:self.webHTML baseURL:[NSURL URLWithString:BASE_IP]];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webviewURL]]];
    }
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH-_statusHeight)];
    if ([self.type isEqualToString:@"暂无轮播图"]) {
        [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
        self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];

    }else{
        [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
        self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];

    }
    self.emptyView.hidden = YES;
    [self.emptyView.contentLabel setText:self.type];
    [self.view addSubview:self.emptyView];

    //设置状态栏字体颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"白返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
    self.navigationItem.leftBarButtonItem = right;
    
    
    [config.userContentController addScriptMessageHandler:self name:@"vipUpdate"];
    [config.userContentController addScriptMessageHandler:self name:@"callPhone"];
    
    self.btnZhengJi = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), kScreenHeight - JCNew64 - k360Width(54) - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(32), k360Width(44))];
    self.btnZhengJi.centerX = self.view.centerX;
    [self.btnZhengJi rounded:k360Width(44/8)];
    [self.btnZhengJi setTitle:@"申请专家资格" forState:UIControlStateNormal];
    [self.btnZhengJi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnZhengJi setBackgroundColor:MSTHEMEColor];
    [self.btnZhengJi addTarget:self action:@selector(btnZhengJiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnZhengJi];

    [self.btnZhengJi setHidden:YES];
    
    [self showZhengJiButton];
}

- (void)btnZhengJiAction {
    NSLog(@"点击了报名按钮");
    if (self.mUser.idcardnum.length <= 0 || self.mUser.realname.length <= 0) {
        [self buquanIDCard];
    } else {
        WY_UserModel *tempUser = [WY_UserModel new];
        tempUser.idcardnum = self.mUser.idcardnum;
        tempUser.yhname = self.mUser.realname;
        tempUser.key = self.mUser.idcardnum;
        tempUser.userid = self.mUser.UserGuid;
        [self zhuanJiaLaQuByPost:tempUser];
    }
    
}

- (void)showZhengJiButton {
    //显示征集按钮；
    if ([self.ishy isEqualToString:@"101"]) {
        [self.btnZhengJi setHidden:NO];
        self.webView.height = self.btnZhengJi.top - k360Width(10);
    } else {
        [self.btnZhengJi setHidden:YES];
    }
    
}
- (void)navRightAction{
    NSURL *shareUrl = [NSURL URLWithString:self.webviewURL];
    NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
    NSArray*activityItems =@[shareUrl,self.titleStr,dateImg];
    
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[[UIImage imageWithData:dateImg],@"内容NSString",shareUrl] applicationActivities:nil];
//        activityVC.definesPresentationContext = YES;
//        //不出现在活动项目
//        //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
//        [self presentViewController:activityVC animated:YES completion:nil];
//        //分享之后的回调
//        __weak typeof(activityVC) weekActivity = activityVC;
//        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
//            
////            if (completionBlock) {
////                completionBlock(completed, activityError);
////                
////                [weekActivity dismissViewControllerAnimated:YES completion:nil];
////            }
//            
//            if (completed) {
//                NSLog(@"completed");
//                //分享 成功
//            } else {
//                NSLog(@"失败");
//                //分享 取消
//            }
//        };
    
    SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:@"使用浏览器打开" withActivityImage:dateImg withUrl:shareUrl withType:@"CustomActivity" withShareContext:activityItems];
    NSArray *activities = @[customActivit];

    UIActivityViewController *activityVC = nil;
//    if  (MH_iOS13_VERSTION_LATER) {
//        activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
//    } else {
        activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
//    }
    activityVC.definesPresentationContext = YES;
//    activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
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
}
- (void)navRight1Action {
    MS_WKwebviewsViewController *wk = [[MS_WKwebviewsViewController alloc] init];
    wk.titleStr = @"意见反馈";
//    @"http://192.168.0.30:8080/#/opinion"
//    @"https://218.60.153.214:8888/ai/#/opinion";
    wk.webviewURL = @"https://218.60.153.214:8888/ai/#/opinion";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:wk];
    navi.navigationBarHidden = NO;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)closeClick
{
    if (self.webView.canGoBack==YES) {
          [self.webView goBack];
      }else{
//          [self.navigationController popViewControllerAnimated:YES];
//          if (self.navigationController) {
//              [self.navigationController popViewControllerAnimated:YES];
//          } else {
              [self dismissViewControllerAnimated:YES completion:nil];
//          }
          
      }
    
}

 
#pragma mark WKUIDelegate,WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
 
    [_progressLayer finishedLoad];
    self.emptyView.hidden = YES;
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


- (void)buquanIDCard {
    //    要去掉百度身份证扫描识别OCR 功能，  改用公司自身 OCR 产品
    [SVProgressHUD showErrorWithStatus:@"请到个人信息页面完善身份证号和姓名"];
    WY_UserInfoViewController *tempController = [WY_UserInfoViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
    return;
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    if (self.mUser.idcardnum.length <= 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前用户没有身份证信息，是否现在进行完善身份证信息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:([UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goIDCarSettingPage];
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)goIDCarSettingPage {
    
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont
                                 andImageHandler:^(UIImage *image) {
        
        [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id result){
            _successHandler(result);
         }
                                                     failHandler:_failHandler];
    }];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        self.isIdCardSuccess = @"1";
        self.dicIDCard = result;
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别成功" message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        self.isIdCardSuccess = @"2";
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}

- (void)ocrSuccess {
         __block    NSString *idCardNum = @"";
        __block    NSString *pName = @"";
        NSDictionary *result =  self.dicIDCard;
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        if ([key isEqualToString:@"姓名"]) {
                            pName = [NSString stringWithFormat:@"%@",obj[@"words"]];
                        }
                        if ([key isEqualToString:@"公民身份号码"]) {
                            idCardNum = [NSString stringWithFormat:@"%@",obj[@"words"]];
                        }
                    }
                    
                }];
            }
        }
        
        if (idCardNum.length <= 0 || pName.length <= 0 ) {
            [SVProgressHUD showErrorWithStatus:@"身份证信息识别错误"];
            return;
        }
        WY_UserModel *tempUser = [WY_UserModel new];
        tempUser.idcardnum = idCardNum;
        tempUser.yhname = pName;
        tempUser.key = idCardNum;
        tempUser.userid = self.mUser.UserGuid;
        [self zhuanJiaLaQuByPost:tempUser];
    
}
- (void)zhuanJiaLaQuByPost:(WY_UserModel *)tempUser {
    //    成功后 - 进行人脸识别；
    WS(weakSelf);
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:checkinjianguan_HTTP params:nil jsonData:[tempUser toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if (([code integerValue] == 0) && res) {
            WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
            currentUserModel.token = self.mUser.token;
            //如果是专家- 跳转扫脸
            if  (![currentUserModel.UserType isEqualToString:@"1"]) {
                [MS_BasicDataController sharedInstance].user = currentUserModel;
                           self.mUser = currentUserModel;
//                     [self smrzxxIsBelow];
                //工信部要求去掉人脸
                NSLog(@"进入功能");
                 WY_ExpertRegistrationViewController *tempController = [WY_ExpertRegistrationViewController new];
                 [self.navigationController pushViewController:tempController animated:YES];

            } else {
                [MS_BasicDataController sharedInstance].user = currentUserModel;
                           self.mUser = currentUserModel;
                [SVProgressHUD showErrorWithStatus:@"您已经是专家无法查看此功能"];
            }
        } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
    
    
}

///判断今天是否进行过人脸识别
- (void)smrzxxIsBelow {
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
     [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];

    [[MS_BasicDataController sharedInstance] postWithReturnCode:bidevaluationSmrzxxIsBelow_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            WY_ExpertRegistrationViewController *tempController = [WY_ExpertRegistrationViewController new];
            [self.navigationController pushViewController:tempController animated:YES];
        } else {
            //需要人脸识别
            [self VFace];
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
        //            [weakSelf submitData:imgFace];
        
        [weakSelf performSelectorOnMainThread:@selector(submitData:) withObject:imgFace waitUntilDone:YES];
    };
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.isIdCardSuccess isEqualToString:@"1"]) {
        [self ocrSuccess];
    }
}

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
             WY_ExpertRegistrationViewController *tempController = [WY_ExpertRegistrationViewController new];
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
            //            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
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
 

@end
