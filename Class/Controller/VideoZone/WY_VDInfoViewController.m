//
//  WY_VDInfoViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/8.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_VDInfoViewController.h"
#import "EmptyView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#import "ZBWKWebView.h"
#import "WKWebView+CheckImage.h"
#import "ImageNewsDetailViewController.h"
#import "WY_LoginViewController.h"

@interface WY_VDInfoViewController ()<WKUIDelegate,WKScriptMessageHandler,WKScriptMessageHandler,WKNavigationDelegate>{
    //    导航条高度
       WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
       UIButton *btnFootZan;
       UIButton *btnFootZhuan;
       
}

@property (nonatomic, strong) WY_InfomationModel *mDetailMode;
@property (nonatomic, strong) UIImageView *imgPlaceholderImage;

@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) ZBWKWebView *webView;
@property (nonatomic,strong) EmptyView *emptyView;
@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic,strong) UIView *footView;

@end

@implementation WY_VDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self makeUI];
    
}
- (void)makeUI {
    // tabbar
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.preferences = [[WKPreferences alloc] init];
       //    config.userContentController = [[WKUserContentController alloc] init];
    
    config.processPool = [[WKProcessPool alloc] init];
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    config.userContentController = wkUController;
    
    
    self.webView = [[ZBWKWebView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, self.view.height)
                    
                                        configuration:config];
    
    
    //记得实现对应协议,不然方法不会实现.
    
    self.webView.UIDelegate = self;
    
    self.webView.navigationDelegate =self;
    
    //              WKWebView *contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    
    
    [self.view addSubview:self.webView];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@webdbInformation/getCbyInfoid?infoid=%@",BASE_IP,self.mWY_InfomationModel.infoid]]]];
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    self.emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH-JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.emptyView.picImgV setImage:[UIImage imageNamed:@"0116nobg"]];
    self.emptyView.picImgSize = [UIImage imageNamed:@"0116nobg"];
    self.emptyView.hidden = YES;
    [self.emptyView.contentLabel setText:@"暂无"];
    [self.view addSubview:self.emptyView];
    
    [self makeFooterView];
}

-(void)makeFooterView{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,300)];
    
    UIView *viewFootContentView =[[UIView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), k360Width(335), k360Width(100))];
    [self.footView addSubview:viewFootContentView];
    [self viewShadowCorner:viewFootContentView];
    
    UILabel *lblWebTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(10), k360Width(10), viewFootContentView.width - k360Width(20), viewFootContentView.height - k360Width(20))];
    lblWebTitle.numberOfLines = 0 ;
    lblWebTitle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableAttributedString *lblkhfsString5 = [[NSMutableAttributedString alloc] initWithString:self.mWY_InfomationModel.title];
          [lblkhfsString5 setYy_color:[UIColor blackColor]];
          [lblkhfsString5 setYy_font:WY_FONTMedium(14)];
    
    NSMutableAttributedString *attArr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",self.mWY_InfomationModel.infodate]];
       [attArr2 setYy_font:WY_FONTRegular(14)];
      [attArr2 setYy_color:HEXCOLOR(0x8A8A8A)];
      [lblkhfsString5 appendAttributedString:attArr2];
    [lblkhfsString5 setYy_lineSpacing:6];

    lblWebTitle.attributedText = lblkhfsString5;
    [viewFootContentView addSubview:lblWebTitle];
    //收藏按钮
    btnFootZan = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(250), k360Width(58), k360Width(34), k360Width(34))];
    [btnFootZan setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [btnFootZan setImage:[UIImage imageNamed:@"shoucangxuan"] forState:UIControlStateSelected];
    [btnFootZan addTarget:self action:@selector(btnZanAction) forControlEvents:UIControlEventTouchUpInside];
    
    [viewFootContentView addSubview:btnFootZan];
    
    //分享按钮
    btnFootZhuan = [[UIButton alloc] initWithFrame:CGRectMake(btnFootZan.right + k360Width(12), k360Width(58), k360Width(34), k360Width(34))];
    [btnFootZhuan setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [btnFootZhuan addTarget:self action:@selector(btnShareAction) forControlEvents:UIControlEventTouchUpInside];
    [viewFootContentView addSubview:btnFootZhuan];
    
    UIImageView *viewBlue1 = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(15), viewFootContentView.bottom + k360Width(15) , k360Width(4), k360Width(15))];
    [viewBlue1 setImage:[UIImage imageNamed:@"1127_shutiao"]];
    
    UILabel *lblGD = [[UILabel alloc] initWithFrame:CGRectMake(viewBlue1.right + k360Width(10), viewFootContentView.bottom + k360Width(10), k360Width(300), k360Width(25))];
    [lblGD setText:@"简介"];
    [lblGD setFont: WY_FONTMedium(18)];
    
    [self.footView addSubview:viewBlue1];
    [self.footView addSubview:lblGD];
    self.footView.height = lblGD.bottom + k360Width(10);
    _webView.isSameColorWithHeaderView = NO;
    _webView.headerView = self.footView;
    
    
}


///给View设置阴影和圆角
- (void)viewShadowCorner:(UIView *)viewInfoTemp {
    viewInfoTemp.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
    viewInfoTemp.layer.shadowOffset = CGSizeMake(5, 5);
    viewInfoTemp.layer.shadowOpacity = 1;
    viewInfoTemp.layer.shadowRadius = 9.0;
    viewInfoTemp.layer.cornerRadius = k360Width(44) / 8;
    [viewInfoTemp setBackgroundColor:[UIColor whiteColor]];
    viewInfoTemp.clipsToBounds = NO;
}
- (void)dataBind {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mWY_InfomationModel.infoid forKey:@"infoid"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getXqbyInfoid_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
          if ([code integerValue] == 0 ) {
              self.mDetailMode = [WY_InfomationModel yy_modelWithJSON:res[@"data"]];
              if ([self.mDetailMode.type isEqualToString:@"1"]) {
                 [btnFootZan setSelected:YES];
              } else {
                   [btnFootZan setSelected:NO];
              }
              [self readGetIntegral];
           } else {
              [SVProgressHUD showErrorWithStatus:res[@"msg"]];
          }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];

}

/// 阅读得积分
- (void)readGetIntegral {
    NSLog(@"阅读得积分");
    //收藏
    self.mWY_InfomationModel.infocontent = self.mDetailMode.infocontent;
    self.mWY_InfomationModel.scType = @"1";
    
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
    [btnFootZan setSelected:!btnFootZan.selected];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
