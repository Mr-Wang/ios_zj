//
//  WY_ReadZoneDetailsViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/16.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ReadZoneDetailsViewController.h"
#import "EmptyView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#import "ZBWKWebView.h"
#import "WY_LoginViewController.h"
#import "WY_TestQuestionsMainViewController.h"
#import "iflyMSC/IFlyMSC.h"
#import "WY_ExpertRegistrationViewController.h"
   
#import <AipOcrSdk/AipOcrSdk.h>
#import "LivenessViewController.h"
#import "LivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "WY_OnlineTrainDetailsViewController.h"
#import "WY_UserInfoViewController.h"

@interface WY_ReadZoneDetailsViewController ()<WKUIDelegate,WKScriptMessageHandler,WKScriptMessageHandler,WKNavigationDelegate,IFlySpeechSynthesizerDelegate>
{
    //    导航条高度
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    UIView *viewBottom;
    UITextField *txtComment;
    UIButton *btnSend;
    UIButton *btnZan;
    UIButton *btnZhuan;
    UIButton *btnChuTi;
    
    UIButton *btnFootZan;
    UIButton *btnFootZhuan;
    UIView *viewFootContent;
    UIImageView *imgNoBg;
    UILabel *lblNoBg;
    float angle;
    
    
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}
@property (nonatomic, strong) WY_UserModel *mUser;

@property (nonatomic, strong) ZBWKWebView *webView;
@property (nonatomic,strong) EmptyView *emptyView;
//@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic, strong) WY_InfomationModel *mDetailMode;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@property (nonatomic, strong) NSString * mVoiceStr;
@property (nonatomic, strong) NSMutableArray *arrMVoiceStr;
@property (nonatomic) int mSelectNum;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UIButton *btnPlay;
@property (nonatomic, strong) UIButton *btnZhengJi;


///身份证OCR结果
@property (nonatomic, strong) NSMutableDictionary *dicIDCard;
@property (nonatomic, strong) NSString *isIdCardSuccess;
#define maxlength 2048
@end

@implementation WY_ReadZoneDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
    [self dataBind];
    
    //右侧上角按钮- 添加语音播放按钮；
    [self initRightBtn];
}
#pragma mark --语音播报部分 - Start
- (void)initRightBtn {
    self.cancleButton = [[UIButton alloc] init];
    self.cancleButton.frame = CGRectMake(0, 0, 50, 30);
    [self.cancleButton setImage:[UIImage imageNamed:@"0118_right"] forState:UIControlStateNormal];
    [self.cancleButton setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 5, 10)];
      [self.cancleButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
     forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
    forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
     forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:nil
     forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];

    self.rightView = [[UIView alloc] init];
    [self.rightView setFrame:CGRectMake(kScreenWidth - k360Width(110), MH_APPLICATION_STATUS_BAR_HEIGHT + k360Width(5), k360Width(130), k360Width(30))];
    [self.rightView rounded:k360Width(30/2)];
    [self.rightView setBackgroundColor:[UIColor whiteColor]];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.rightView];
    [self.rightView setHidden:YES];
    
    
    
    
    
    self.imgIcon = [UIImageView new];
    [self.imgIcon setFrame:CGRectMake(k360Width(5), k360Width(5), k360Width(22), k360Width(22))];
    [self.imgIcon setImage:[UIImage imageNamed:@"1AppIcon"]];
    [self.imgIcon rounded:k360Width(20/2)];
    [self.rightView addSubview:self.imgIcon];
     
    self.btnPlay = [UIButton new];
    [self.btnPlay setFrame:CGRectMake(self.imgIcon.right + k360Width(5), self.imgIcon.top, k360Width(20), k360Width(20))];

    [self.btnPlay setImage:[UIImage imageNamed:@"0118_zt"] forState:UIControlStateNormal];
    [self.btnPlay setImage:[UIImage imageNamed:@"0118_bf"] forState:UIControlStateSelected];
    [self.btnPlay setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [self.btnPlay.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.btnPlay addTarget:self action:@selector(btnPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:self.btnPlay];
    
    
    
    UIButton *btnRePlay = [UIButton new];
    [btnRePlay setFrame:CGRectMake(self.btnPlay.right + k360Width(5), self.imgIcon.top, k360Width(20), k360Width(20))];

    [btnRePlay setImage:[UIImage imageNamed:@"0118_cb"] forState:UIControlStateNormal];
    [btnRePlay setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [btnRePlay.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnRePlay addTarget:self action:@selector(btnRePlayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:btnRePlay];
    
    UIButton *btnStop = [UIButton new];
    [btnStop setFrame:CGRectMake(btnRePlay.right + k360Width(5), self.imgIcon.top, k360Width(20), k360Width(20))];

    [btnStop setImage:[UIImage imageNamed:@"0118_gb"] forState:UIControlStateNormal];
    [btnStop setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [btnStop.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnStop addTarget:self action:@selector(btnStopAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.rightView addSubview:btnStop];
}

- (void)btnPlayAction:(UIButton *)btnSender {
     btnSender.selected = !btnSender.selected;
    if (btnSender.selected) {
        [_iFlySpeechSynthesizer pauseSpeaking];
         
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.imgIcon.layer removeAllAnimations];
            });
    } else {
        [_iFlySpeechSynthesizer resumeSpeaking];
        [self stopLoppAnimation1];
    }
}

- (void)btnRePlayAction:(UIButton *)btnSender {
    self.mSelectNum = 0;
    [_iFlySpeechSynthesizer startSpeaking: self.arrMVoiceStr[self.mSelectNum]];
    self.btnPlay.selected = NO;
    [self stopLoppAnimation1];
}

- (void)btnStopAction:(UIButton *)btnSender {
    
    [_iFlySpeechSynthesizer stopSpeaking];
    
    //结束
    angle = 0;
    
    [self.rightView setHidden:YES];

}
 
- (void)rightBtnAction {
    self.mSelectNum = 0;
    [_iFlySpeechSynthesizer startSpeaking: self.arrMVoiceStr[self.mSelectNum]];
    [self.rightView setHidden:NO];
    [self stopLoppAnimation1];
    self.btnPlay.selected = NO;
}

//合成结束
- (void) onCompleted:(IFlySpeechError *) error {}
//合成开始
- (void) onSpeakBegin {}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {}
//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    NSLog(@"progress=======%d",progress);
    
//    播放完第一段 、自动播放第二段
    if (progress == 100) {
        self.mSelectNum++;
        if (self.mSelectNum >= self.arrMVoiceStr.count) {
            self.mSelectNum = 0;
            [self btnStopAction:nil];
        } else {
            [_iFlySpeechSynthesizer startSpeaking: self.arrMVoiceStr[self.mSelectNum]];
        }
    }
    
}

- (NSMutableArray *)splitPargraph:(NSString *)withStr {
    NSMutableArray *resultList = [NSMutableArray new];
    if(withStr.length >= maxlength) {
        NSString *mStr = withStr;
        while (mStr.length >= maxlength) {
            NSString *AStr = [mStr substringToIndex:maxlength];
            [resultList addObject:AStr];
            mStr = [mStr substringFromIndex:maxlength];
         }
        [resultList addObject:mStr];
    } else {
        [resultList addObject:withStr];
    }
    return resultList;
}

- (void)stopLoppAnimation1{
     //动画
    
        CABasicAnimation* rotationAnimation;

        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];

        rotationAnimation.duration = 1.4;

        rotationAnimation.cumulative = YES;

        rotationAnimation.repeatCount = ULLONG_MAX;
    rotationAnimation.delegate = self;

        [self.imgIcon.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}


- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animation start , aniView =");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animation stop : flag = %d , aniView = %@", flag, self.imgIcon);

}


- (void)voiceConversion:(NSString *)voiceStr {
    
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
    options:0
    error:nil];
    self.mVoiceStr =[regularExpretion stringByReplacingMatchesInString:voiceStr options:NSMatchingReportProgress range:NSMakeRange(0, voiceStr.length) withTemplate:@""];
    NSLog(@"mVoiceStr:%@",self.mVoiceStr);
}
#pragma mark --语音播报部分 - END


- (void)viewWillAppear:(BOOL)animated {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
}
- (void)dataBind {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mWY_InfomationModel.infoid forKey:@"infoid"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getXqbyInfoid_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
          if ([code integerValue] == 0 ) {
              self.mDetailMode = [WY_InfomationModel yy_modelWithJSON:res[@"data"]];
              [self voiceConversion:self.mDetailMode.infocontent];
              self.arrMVoiceStr = [self splitPargraph:self.mVoiceStr];
          
              
              if ([self.mDetailMode.type isEqualToString:@"1"]) {
                  [btnZan setSelected:YES];
                [btnFootZan setSelected:YES];
              } else {
                    [btnZan setSelected:NO];
                  [btnFootZan setSelected:NO];
              }
              [self showZhengJiButton];
              [self readGetIntegral];
           } else {
              [SVProgressHUD showErrorWithStatus:res[@"msg"]];
          }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];

}
- (void)showZhengJiButton {
    //显示征集按钮；
    if ([self.mWY_InfomationModel.price isEqualToString:@"101"]) {
        [self.btnZhengJi setHidden:NO];
        self.webView.height = self.btnZhengJi.top - k360Width(10);
    } else {
        [self.btnZhengJi setHidden:YES];
    }
    
}
/// 阅读得积分
- (void)readGetIntegral {
    NSLog(@"阅读得积分");
    //收藏
    self.mWY_InfomationModel.infocontent = self.mDetailMode.infocontent;
    self.mWY_InfomationModel.scType = @"1";
    /*
     -10秒之后执行 + 积分操作
     private String orgnum;
     private String title;
     private String projectGuid; //文章传1  视频传2 ；
     private String infoid;
    private String type; 传1
     */
    
    //只有企业用户才加积分
//    if (self.mUser.orgnum !=nil && self.mUser.orgnum.length > 0) {
        [self performSelector:@selector(httpAddIntegral) afterDelay:10];
//       }
}
 - (void)httpAddIntegral {
//     //专家不加积分
//     return;
    NSLog(@"执行了");
    NSMutableDictionary *dicJson = [NSMutableDictionary new];
    [dicJson setObject:self.mUser.orgnum forKey:@"orgnum"];
    [dicJson setObject:self.mWY_InfomationModel.title forKey:@"title"];
    [dicJson setObject:@"1" forKey:@"projectGuid"];
    [dicJson setObject:self.mWY_InfomationModel.infoid forKey:@"infoid"];
    [dicJson setObject:@"1" forKey:@"type"];
     [[MS_BasicDataController sharedInstance] postWithReturnCode:insetIntegral_HTTP params:nil jsonData:[dicJson yy_modelToJSONData] showProgressView:NO success:^(id res, NSString *code) {
     } failure:^(NSError *error) {
    }];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_iFlySpeechSynthesizer stopSpeaking];
    [self.rightView setHidden:YES];
    [self.rightView removeAllSubviews];
     //取消执行添加积分线程
       NSLog(@"取消执行添加积分线程");
       [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(httpAddIntegral) object:nil];
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
    
    
    self.webView = [[ZBWKWebView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH-JCNew64  - JC_TabbarSafeBottomMargin )
                    
                                        configuration:config];
    
    
    //记得实现对应协议,不然方法不会实现.
    
    self.webView.UIDelegate = self;
    
    self.webView.navigationDelegate =self;
    
    //              WKWebView *contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    
    
    [self.view addSubview:self.webView];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@webdbInformation/getCbyInfoid?infoid=%@",BASE_IP,self.mWY_InfomationModel.infoid]]]];
    
//    [WKWebViewJavascriptBridge enableLogging];
//    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//    [_bridge setWebViewDelegate:self];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH-JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    self.emptyView.hidden = YES;
    [self.emptyView.contentLabel setText:@"暂无"];
    [self.view addSubview:self.emptyView];
    
    //设置状态栏字体颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"白返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
    self.navigationItem.leftBarButtonItem = right;
    
    
    [config.userContentController addScriptMessageHandler:self name:@"vipUpdate"];
    [config.userContentController addScriptMessageHandler:self name:@"callPhone"];
    
    if (![self.mWY_InfomationModel.categorynum isEqualToString:@"002"]) {
        [self makeFooterView];
    }
    
    //如果是通知公告 并且是引导报名的 - 留下报名按钮- 点击跳转值报名页
    if ([self.mWY_InfomationModel.categorynum isEqualToString:@"002"] && [self.mWY_InfomationModel.videourl isNotBlank]) {
        UIButton *btnBaoMing = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), kScreenHeight - JCNew64 - k360Width(54) - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(32), k360Width(44))];
        btnBaoMing.centerX = self.view.centerX;
        [btnBaoMing rounded:k360Width(44/8)];
        [btnBaoMing setTitle:@"立即报名" forState:UIControlStateNormal];
        [btnBaoMing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnBaoMing setBackgroundColor:MSTHEMEColor];
        WS(weakSelf);
        [btnBaoMing addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            //进入在线视频培训
            WY_OnlineTrainDetailsViewController *tempController = [WY_OnlineTrainDetailsViewController new];
            WY_TrainItemModel *tempModel = [WY_TrainItemModel new];
            tempModel.rowGuid = weakSelf.mWY_InfomationModel.videourl;
            tempModel.ishy = @"0";
            tempController.mWY_TrainItemModel = tempModel;
            tempController.title = @"在线视频培训";
            [weakSelf.navigationController pushViewController:tempController animated:YES];
        }];
        [self.view addSubview:btnBaoMing];
        self.webView.height = btnBaoMing.top - k360Width(10);
        return;
    }
    
    viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.webView.bottom, kScreenWidth, k360Width(44))];
    [viewBottom setBackgroundColor:[UIColor whiteColor]];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    [viewBottom setHidden:YES];
    txtComment = [[UITextField alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(5), k360Width(210), k360Width(44 - 10))];
    [txtComment setBackgroundColor:HEXCOLOR(0xF2F3F5)];
    [txtComment setPlaceholder:@"欢迎发表你的观点"];
    [txtComment setFont:WY_FONTRegular(14)];
    txtComment.leftViewMode = UITextFieldViewModeAlways;
    txtComment.leftView = lv;
    [txtComment rounded:k360Width(44 / 8)];
    
    [viewBottom addSubview:txtComment];
    btnSend = [[UIButton alloc] initWithFrame:CGRectMake(txtComment.right, 0, k360Width(50), k360Width(44))];
    btnZan = [[UIButton alloc] initWithFrame:CGRectMake(btnSend.right, 0, k360Width(36), k360Width(44))];
    btnZhuan = [[UIButton alloc] initWithFrame:CGRectMake(btnZan.right, 0, k360Width(36), k360Width(44))];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend setTitleColor:HEXCOLOR(0xF45A17) forState:UIControlStateNormal];
    [btnSend.titleLabel setFont:WY_FONTMedium(14)];
    [btnZan setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [btnZan setImage:[UIImage imageNamed:@"shoucangxuan"] forState:UIControlStateSelected];
    [btnZan addTarget:self action:@selector(btnZanAction) forControlEvents:UIControlEventTouchUpInside];
    [btnZhuan setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [btnZhuan addTarget:self action:@selector(btnShareAction) forControlEvents:UIControlEventTouchUpInside];
    
 
    [viewBottom addSubview:btnSend];
    [viewBottom addSubview:btnZan];
    [viewBottom addSubview:btnZhuan];
 
    [btnSend addTarget:self action:@selector(btnSendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewBottom];
     
    self.btnZhengJi = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), kScreenHeight - JCNew64 - k360Width(54) - JC_TabbarSafeBottomMargin, kScreenWidth - k360Width(32), k360Width(44))];
    self.btnZhengJi.centerX = self.view.centerX;
    [self.btnZhengJi rounded:k360Width(44/8)];
    [self.btnZhengJi setTitle:@"申请专家资格" forState:UIControlStateNormal];
    [self.btnZhengJi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnZhengJi setBackgroundColor:MSTHEMEColor];
    [self.btnZhengJi addTarget:self action:@selector(btnZhengJiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnZhengJi];

    [self.btnZhengJi setHidden:YES];
}

- (void)btnZhengJiAction {
//    WY_ExpertRegistrationViewController *tempController = [WY_ExpertRegistrationViewController new];
//    [self.navigationController pushViewController:tempController animated:YES];
//    return;
    NSLog(@"点击了报名按钮");
    if (self.mUser.idcardnum.length <= 0 || self.mUser.realname.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请到个人信息页面完善身份证号和姓名"];
        WY_UserInfoViewController *tempController = [WY_UserInfoViewController new];
        [self.navigationController pushViewController:tempController animated:YES];
//        [self buquanIDCard];
    } else {
        WY_UserModel *tempUser = [WY_UserModel new];
        tempUser.idcardnum = self.mUser.idcardnum;
        tempUser.yhname = self.mUser.realname;
        tempUser.key = self.mUser.idcardnum;
        tempUser.userid = self.mUser.UserGuid;
        [self zhuanJiaLaQuByPost:tempUser];
    }
}

- (void)btnSendAction:(UIButton *)btnSender {
    NSLog(@"点击了发送按钮");
    //判断登录状态
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
        return;
    }
//    if (![self verificationIsOrgUser]) {
//        return;
//    }
//    self.footView.height += 10;
//    _webView.isSameColorWithFooterView = NO;
//    _webView.footerView = self.footView;
//    [_webView setupFooterViewForWebView:_webView];
    if (txtComment.text.length <=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入评论内容"];
        return;
    }
    txtComment.text = @"";
    [txtComment resignFirstResponder];
    [SVProgressHUD showSuccessWithStatus:@"评论正在审核中"];
    
}
///验证是否企业用户
- (BOOL) verificationIsOrgUser {
//    if (self.mUser.orgnum !=nil && self.mUser.orgnum.length > 0) {
    if ([self.mUser.UserType isEqualToString:@"1"]) {
        return  YES;
    } else {
        [SVProgressHUD showInfoWithStatus:@"此功能专为专家用户开放，您如需使用此功能，请先在我的-个人信息中完善，特别是填写准确的企业单位名称，感谢您的使用和支持。"];
        return NO;
    }
}

-(void)makeFooterView{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,300)];
    
    //收藏按钮
    btnFootZan = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), (kScreenWidth - k360Width(48)) /2, k360Width(34))];
    [btnFootZan setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [btnFootZan setImage:[UIImage imageNamed:@"shoucangxuan"] forState:UIControlStateSelected];
    [btnFootZan rounded:k360Width(44)/8];
    [btnFootZan setTitle:@"收藏" forState:UIControlStateNormal];
    [btnFootZan setTitleEdgeInsets:UIEdgeInsetsMake(0, k360Width(16), 0, 0)];
    [btnFootZan setContentEdgeInsets:UIEdgeInsetsMake(0, -k360Width(8), 0, 0)];
    [btnFootZan setTitleColor:HEXCOLOR(0x80868b) forState:UIControlStateNormal];
    [btnFootZan setBackgroundColor:HEXCOLOR(0xF2F3F5)];
    [btnFootZan addTarget:self action:@selector(btnZanAction) forControlEvents:UIControlEventTouchUpInside];

    [self.footView addSubview:btnFootZan];
    
    //分享按钮
    btnFootZhuan = [[UIButton alloc] initWithFrame:CGRectMake(btnFootZan.right + k360Width(16), k360Width(16), (kScreenWidth - k360Width(48)) /2, k360Width(34))];
    [btnFootZhuan setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [btnFootZhuan rounded:k360Width(44)/8];
    [btnFootZhuan setTitle:@"分享" forState:UIControlStateNormal];
    [btnFootZhuan setTitleEdgeInsets:UIEdgeInsetsMake(0, k360Width(16), 0, 0)];
    [btnFootZhuan setContentEdgeInsets:UIEdgeInsetsMake(0, -k360Width(8), 0, 0)];
    [btnFootZhuan setTitleColor:HEXCOLOR(0x80868b) forState:UIControlStateNormal];
    [btnFootZhuan addTarget:self action:@selector(btnShareAction) forControlEvents:UIControlEventTouchUpInside];
    [btnFootZhuan setBackgroundColor:HEXCOLOR(0xF2F3F5)];
    [self.footView addSubview:btnFootZhuan];
    
//    btnChuTi = [[UIButton alloc] initWithFrame:CGRectMake(btnFootZhuan.right + k360Width(16), k360Width(16), (kScreenWidth - k360Width(64)) /3, k360Width(34))];
//    [btnChuTi setTitle:@"我要出题" forState:UIControlStateNormal];
//    [btnChuTi rounded:k360Width(44)/8];
//    [btnChuTi setBackgroundColor:HEXCOLOR(0xF2F3F5)];
//    [btnChuTi setTitleColor:HEXCOLOR(0x80868b) forState:UIControlStateNormal];
//    [btnChuTi addTarget:self action:@selector(goChuTi) forControlEvents:UIControlEventTouchUpInside];
//    [self.footView addSubview:btnChuTi];

//    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), btnFootZhuan.bottom + k360Width(15) , k360Width(4), k360Width(15))];
//    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    
//    UILabel *lblGD = [[UILabel alloc] initWithFrame:CGRectMake(viewBlue1.right + k360Width(10), btnFootZhuan.bottom + k360Width(10), k360Width(300), k360Width(25))];
//    [lblGD setText:@"观点"];
//    [lblGD setFont: WY_FONTMedium(18)];
//
//    [self.footView addSubview:viewBlue1];
//    [self.footView addSubview:lblGD];
    
    
//    viewFootContent = [[UIView alloc] initWithFrame:CGRectMake(0, lblGD.bottom, kScreenWidth, k360Width(300))];
//    [self.footView addSubview:viewFootContent];
//    [self initNoData];
    self.footView.height = btnFootZhuan.bottom + k360Width(16);
    _webView.isSameColorWithFooterView = NO;
    _webView.footerView = self.footView;
    [_webView setupFooterViewForWebView:_webView];

//    _webView.isSameColorWithFooterView = NO;
//    _webView.footerView = self.footView;

}
//点赞功能；
- (void)btnZanAction{
    //判断登录状态
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
        return;
    }
    [btnZan setSelected:!btnZan.selected];
    [btnFootZan setSelected:btnZan.selected];
    //收藏
    self.mWY_InfomationModel.infocontent = self.mDetailMode.infocontent;
    self.mWY_InfomationModel.scType = @"1";
     [[MS_BasicDataController sharedInstance] postWithReturnCode:insertCollect_HTTP params:nil jsonData:[self.mWY_InfomationModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
     } failure:^(NSError *error) {
    }];
}

//分享功能按钮
- (void)btnShareAction {
    //判断登录状态
    if([MS_BasicDataController sharedInstance].user == nil) {
        WY_LoginViewController *tempController = [WY_LoginViewController new];
        tempController.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.tabBarController.selectedViewController presentViewController:tempController animated:YES completion:nil];
        return;
    }
    NSArray*activityItems =@[[NSURL URLWithString:[NSString stringWithFormat:@"%@webdbInformation/getCbyInfoid?infoid=%@",BASE_IP,self.mWY_InfomationModel.infoid]] ,self.mWY_InfomationModel.title,[UIImage imageNamed:@"AppIcon"]];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
     activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];

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


/// 出题
- (void)goChuTi {
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.mUser.orgnum forKey:@"orgnum"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:dlPerson_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
          if ([code integerValue] == 0 ) {
              WY_TestQuestionsMainViewController *tempController = [WY_TestQuestionsMainViewController new];
              [self.navigationController pushViewController:tempController animated:YES];
             } else {
              [SVProgressHUD showErrorWithStatus:res[@"data"]];
          }
    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"接口请求失败"];
        WY_TestQuestionsMainViewController *tempController = [WY_TestQuestionsMainViewController new];
        [self.navigationController pushViewController:tempController animated:YES];
    }];
}

- (void)initNoData {
    [viewFootContent removeAllSubviews];
    imgNoBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, k360Width(16), k360Width(246), k360Width(190))];
    imgNoBg.tag = 1001;
    imgNoBg.centerX = viewFootContent.centerX;
    [viewFootContent addSubview:imgNoBg];
    [imgNoBg setImage:[UIImage imageNamed:@"0116nobg"]];
    
    lblNoBg = [[UILabel alloc] initWithFrame:CGRectMake(0, imgNoBg.bottom - k360Width(44) , kScreenWidth, k360Width(44))];
    lblNoBg.tag = 1001;
    [lblNoBg setText:@"暂无评论"];
    [lblNoBg setTextColor:HEXCOLOR(0x8A8B8C)];
    [lblNoBg setFont: WY_FONTMedium(16)];
    [lblNoBg setTextAlignment:NSTextAlignmentCenter];
    [viewFootContent addSubview:lblNoBg];
    
    viewFootContent.height = imgNoBg.bottom;
    self.footView.height = viewFootContent.bottom + k360Width(16);
    _webView.isSameColorWithFooterView = NO;
    _webView.footerView = self.footView;
    [_webView setupFooterViewForWebView:_webView];

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
}


-(void)closeClick
{
    if (self.webView.canGoBack==YES) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (void)buquanIDCard {
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
        if (([code integerValue] == 0 ) && res) {
            WY_UserModel *currentUserModel = [WY_UserModel modelWithJSON:res[@"data"]];
            currentUserModel.token = self.mUser.token;
            //如果是专家- 跳转扫脸
            if  (![currentUserModel.UserType isEqualToString:@"1"]) {
                [MS_BasicDataController sharedInstance].user = currentUserModel;
                           self.mUser = currentUserModel;
                     [self smrzxxIsBelow];
              
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
//            [self VFace];
            //工信部要求去掉人脸
            NSLog(@"进入功能");
             WY_ExpertRegistrationViewController *tempController = [WY_ExpertRegistrationViewController new];
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
