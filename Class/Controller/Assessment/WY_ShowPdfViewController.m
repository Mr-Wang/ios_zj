//
//  WY_ShowPdfViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/19.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ShowPdfViewController.h"
#import "EmptyView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#import "SLCustomActivity.h"

@interface WY_ShowPdfViewController ()<WKUIDelegate,WKScriptMessageHandler,WKScriptMessageHandler,WKNavigationDelegate>
{
    //    导航条高度
    CGFloat _statusHeight;
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    UIButton *cancleButton;
}

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,strong) EmptyView *emptyView;
@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) NSString *pdfUrl;
@property (nonatomic, strong) UIButton *btnDel;
@property (nonatomic, strong) UIButton *btnConfirm;

@end

@implementation WY_ShowPdfViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
 }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    //计算状态栏高度，iphoneX是44  其他是20。
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    _statusHeight =statusBarFrame.size.height+44;
    
    self.navigationItem.title = self.titleStr;
    //分享
        cancleButton = [[UIButton alloc] init];
    cancleButton.frame = CGRectMake(0, 0, 44, 44);
    [cancleButton setTitle:@"分享" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [cancleButton setHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    


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
    if (self.mWY_PersonalScoreModel) {
        [self bindView];
    } else {
        self.pdfUrl = self.webviewURL;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webviewURL]]];
    }
    
    if ([self.isYuLan isEqualToString:@"1"]) {
//        隐藏分享
        self.title = @"预览资格证书";
        [cancleButton setHidden:YES];
        self.btnDel = [UIButton new];
        self.btnConfirm = [UIButton new];
        self.webView.frame = CGRectMake(0, 0, MSScreenW, MSScreenH-_statusHeight - k360Width(44));
        [self.btnDel setFrame:CGRectMake(0, self.webView.bottom, kScreenWidth / 2, k360Width(44))];
 
        [self.btnDel setBackgroundColor:HEXCOLOR(0xFE5238)];
 
        [self.btnDel.titleLabel setFont:WY_FONTMedium(16)];

        
        [self.btnDel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnDel setTitle:@"取消" forState:UIControlStateNormal];
        [self.view addSubview:self.btnDel];
        [self.view addSubview:self.btnConfirm];
        
        [self.btnConfirm setFrame:CGRectMake(self.btnDel.right, self.webView.bottom, kScreenWidth / 2, k360Width(44))];
        [self.btnConfirm.titleLabel setFont:WY_FONTMedium(16)];
        [self.btnConfirm setBackgroundColor:MSTHEMEColor];
        [self.btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnConfirm setTitle:@"确定生成证书" forState:UIControlStateNormal];
        
        [self.btnDel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
           //删除pdf;
            NSMutableDictionary *dicPost = [NSMutableDictionary new];
            [dicPost setObject:self.yuanWebviewURL forKey:@"url"];
            [[MS_BasicDataController sharedInstance] postWithReturnCode:deletePDF_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                  [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        
        [self.btnConfirm addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请仔细查阅证书预览,是否立即生成证书？" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
                NSMutableDictionary *dicPost = [NSMutableDictionary new];
                [dicPost setObject:self.yuanWebviewURL forKey:@"url"];
                [[MS_BasicDataController sharedInstance] postWithReturnCode:xx_InsertZJCert params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                    self.title = @"资格证书";
                    self.webView.frame = CGRectMake(0, 0, MSScreenW, MSScreenH-_statusHeight);
                    [self.btnConfirm setHidden:YES];
                    [self.btnDel setHidden:YES];
                    [cancleButton setHidden:NO];
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"添加错误"];
                 }];
            }])];
            [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil])];
            [self presentViewController:alertController animated:YES completion:nil];

        }];
        
    }
    
}
- (void)bindView {
 
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.mWY_PersonalScoreModel.examrowguid forKey:@"examrowguid"];
     [postDic setObject:self.mUser.orgnum forKey:@"orgguid"];
    [postDic setObject:self.mWY_PersonalScoreModel.examinfoid forKey:@"examinfoid"];
    [postDic setObject:self.mUser.realname forKey:@"username"];
    [postDic setObject:self.mUser.DanWeiName forKey:@"danweiname"];
    [postDic setObject:@"2" forKey:@"type"];

    [[MS_BasicDataController sharedInstance] postWithReturnCode:getpdf_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 1 ) {
             self.emptyView.hidden = YES;
            self.pdfUrl = res[@"data"];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",res[@"data"]]]]];
        } else {
            self.emptyView.hidden = NO;
            [self.emptyView.contentLabel setText:res[@"msg"]];
        }
     } failure:^(NSError *error) {
         self.emptyView.hidden = NO;
       [self.emptyView.contentLabel setText:@"网络不给力"];
    }];

    
}
- (void)navRightAction {
    NSLog(@"分享");
    NSLog(@"分享");
    
    NSURL *shareUrl = [NSURL URLWithString:self.pdfUrl];
    NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
    NSArray*activityItems =@[shareUrl,@"pdf文件",dateImg];
    
    SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:@"使用浏览器打开" withActivityImage:dateImg withUrl:shareUrl withType:@"CustomActivity" withShareContext:activityItems];
    NSArray *activities = @[customActivit];
    UIActivityViewController *activityVC = nil;
    if  (MH_iOS13_VERSTION_LATER) {
        activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
    } else {
        activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    }
    activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
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

//#pragma mark - UIDocumentInteractionController 代理方法
////从哪个控制器打开
//- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
//    return self;
//}
//
//- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
//    return self.view;
//}
//
//- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
//    return self.view.bounds;
//}

-(void)closeClick
{
    if (self.webView.canGoBack==YES) {
          [self.webView goBack];
      }else{
          [self.navigationController popViewControllerAnimated:YES];
//          [self dismissViewControllerAnimated:YES completion:nil];
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
    [cancleButton setHidden:NO];
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


@end
