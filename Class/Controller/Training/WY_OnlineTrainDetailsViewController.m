//
//  WY_OnlineTrainDetailsViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/24.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OnlineTrainDetailsViewController.h"
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
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <SJUIKit/NSAttributedString+SJMake.h>
#import "ZJScrollPageView.h"//选择控制器]

#import "WY_OTDInfoViewController.h"
#import "WY_OTDMessageBoardViewController.h"
#import "WY_GuestBookModel.h"
#import "WY_AddPjViewController.h"

@interface WY_OnlineTrainDetailsViewController ()<WKUIDelegate,WKScriptMessageHandler,WKScriptMessageHandler,WKNavigationDelegate>{
    
    //    导航条高度
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    
    UIButton *btnFootZan;
    UIButton *btnFootZhuan;
    UIImageView *imgNoBg;
    UILabel *lblNoBg;
    UIButton *btnLeft;
}
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) ZBWKWebView *webView;
@property (nonatomic,strong) EmptyView *emptyView;
@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic,strong) UIView *webHeaderView;
@property (nonatomic,strong)WY_TraCourseDetailModel *mWY_TraCourseDetailModel;

@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) UIImageView *imgPlaceholderImage;
@property (nonatomic, strong) SJVideoPlayer *player;


@property (nonatomic, weak) ZJScrollPageView *scrollPageView;//选择控制器
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic , strong)  NSArray *titleArr;/* 选择控制器title*/

@end

@implementation WY_OnlineTrainDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    [self bindView];
 
    if (self.selZJIndex != 0) {
                  [self.scrollPageView setSelectedIndex:self.selZJIndex animated:YES];
                  
              }
}

- (void)bindView {
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mWY_TrainItemModel.rowGuid forKey:@"id"];
    [postDic setObject:self.mUser.idcardnum forKey:@"baomingidcard"];
 
       [[MS_BasicDataController sharedInstance] postWithReturnCode:getTraCourseDetail_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
           if ([code integerValue] == 0 ) {
               self.mWY_TraCourseDetailModel = [WY_TraCourseDetailModel modelWithJSON:res[@"data"]];
               if ([self.mWY_TraCourseDetailModel.CategoryCode isEqualToString:@"A06"]) {
                   self.title =@"录播课程";
               } else if ([self.mWY_TraCourseDetailModel.CategoryCode isEqualToString:@"A07"]) {
                   self.title =@"在线直播课程";
               }
               [self makeUI];
           }
       } failure:^(NSError *error) {
 [SVProgressHUD showErrorWithStatus:@"网络不给力"];
       }];
}
- (void)makeUI {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
     self.edgesForExtendedLayout = UIRectEdgeNone;
     
      
    self.playerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(200))];
    [self.view addSubview:self.playerContainerView];
    [self.playerContainerView setBackgroundColor:[UIColor blackColor]];
    self.imgPlaceholderImage = [UIImageView new];
    self.imgPlaceholderImage.frame = self.playerContainerView.bounds;
    
    [self.imgPlaceholderImage sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TraCourseDetailModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];


    [self.playerContainerView addSubview:self.imgPlaceholderImage];
 
    UIButton *btnEnterYqm = [[UIButton alloc] initWithFrame:CGRectMake(0, k360Width(70), k360Width(154), k360Width(30))];
    [btnEnterYqm.titleLabel setFont:WY_FONTMedium(14)];
    [btnEnterYqm rounded:k360Width(30/2)];
//    [btnEnterYqm setBackgroundColor:MSTHEMEColor];
    [btnEnterYqm setBackgroundColor:MSColorA(0, 0, 0, 0.5)];

    [btnEnterYqm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEnterYqm setTitle:@"点击输入邀请码" forState:UIControlStateNormal];
    btnEnterYqm.centerX = self.playerContainerView.centerX;
//    [self.playerContainerView addSubview:lblYqmTitle];
    [self.playerContainerView addSubview:btnEnterYqm];
//    NSString *coursestarttimeStr = self.mWY_TraCourseDetailModel.coursestarttime;
//    // 指定的时间
//    NSDate *coursestartDate = [NSDate dateWithString:coursestarttimeStr format:@"yyyy-MM-dd HH:mm:ss"];
//    // 判断是否超过一天，想判断超过多少天可以自己设置 60 * 60 * 24 是一天的秒数，这里是拿当前时间和指定的时间判断
//    BOOL isAday = [NSDate date].timeIntervalSince1970 - coursestartDate.timeIntervalSince1970 > 60 * 60 * 24;
    
    // 加入判断 培训开播时间结束 1天后 -隐藏输入邀请码按钮；
    //改为判断isend == 1 结束后 隐藏 输入邀请码按钮
    if ([self.mWY_TraCourseDetailModel.isend isEqualToString:@"1"]) {
        [btnEnterYqm setHidden:YES];
    }
    [btnEnterYqm addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //如果没有身份证-去设置页填写身份证号码；
        if (self.mUser.idcardnum.length <= 0) {
            [SVProgressHUD showErrorWithStatus:@"请去个人信息中设置身份证"];
            return;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入邀请码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入邀请码";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
         
         [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *alertTxt = alertController.textFields[0].text;
            NSLog(@"邀请码：%@",alertTxt);
             if (alertTxt.length > 0) {
                 [self sendYqm:alertTxt];
             }
         }])];

        [self presentViewController:alertController animated:YES completion:nil];
     }];
    
    [self ZJScorollPageUI];

}

- (void)sendYqm :(NSString *)txtYqm {    
    self.authCode = txtYqm;
     NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        [postDic setObject:self.mWY_TrainItemModel.rowGuid forKey:@"infoid"];
     [postDic setObject:txtYqm forKey:@"authCode"];
    if ([self.mWY_TrainItemModel.ishy isEqualToString:@"3"]) {
        [postDic setObject:self.mWY_TrainItemModel.ishy forKey:@"ishy"];
    } else {
        [postDic setObject:@"0" forKey:@"ishy"];
        [postDic setObject:self.mUser.idcardnum forKey:@"baomingidcard"];
    }
           [[MS_BasicDataController sharedInstance] postWithReturnCode:checkauthCode_HTTP params:postDic jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
               if ([code integerValue] == 0 ) {
                   [self showVideoByUrl:res[@"data"]];
//                   [self showVideoByUrl:@"https://218.60.153.237:8088/files/2024122615304600019494591.1一、建设工程质量相关法律与验收规范（一）建设工程质量管理法规、规定.mp4"];
                   
                   https://fgwstudy.lnwlzb.com/study/20240422-1.mp4
//                   [self showVideoByUrl:@"https://lnwl-cloudroom.lnwlzb.com:2726/output/output.m3u8"];
//                   [self showVideoByUrl:@"https://fgwstudy.lnwlzb.com/study/nyncpbxtzjspcz.mp4"];
                   
                   //看视频轮询 - 每5分钟传一次
                   [self watchVideoPolling];
                   
                    self.timer = nil;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:5*60 block:^(NSTimer * _Nonnull timer) {
                        [self watchVideoPolling];
                    } repeats:YES];
                   
                }else {
                   [SVProgressHUD showErrorWithStatus:res[@"msg"]];
               }
           } failure:^(NSError *error) {
               [SVProgressHUD showErrorWithStatus:@"网络不给力"];
           }];

}

 
- (void)watchVideoPolling {
   NSLog(@"执行了");
   NSMutableDictionary *dicJson = [NSMutableDictionary new];
    [dicJson setObject:self.mUser.idcardnum forKey:@"baomingidcard"];
    [dicJson setObject:self.authCode  forKey:@"authCode"];
    [dicJson setObject:self.mWY_TrainItemModel.rowGuid  forKey:@"classGuid"];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:addVideoDetail_HTTP params:dicJson jsonData:nil showProgressView:NO success:^(id res, NSString *code) {
        NSLog(@"轮询了watchVideoPolling")
       
    } failure:^(NSError *error) {
   }];

}

- (void)showVideoByUrl:(NSString *)videoUrl {
        _player = [SJVideoPlayer player];
        _player.autoplayWhenSetNewAsset = YES;
        _player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
        _player.pausedToKeepAppearState = YES;
        _player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
    //禁用-画中画功能；
    _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    
    //隐藏- 更多里的-调速功能；
    [_player.defaultMoreSettingControlLayer.rightAdapter itemForTag:SJMoreSettingControlLayerItem_Rate].hidden = YES;
    
    WS(weakSelf)
    //当前播放进度
    int startPosition = 0;
    
    // 不可滑动-Start
     //如果这组视频是自主学习视频 - 不可以前进后退
    if([self.mWY_TraCourseDetailModel.iszz isEqualToString:@"1"])
    {
        //当前播放进度 = 当前时间-视频开始时间 的秒数
    // 定义日期格式
           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        
            //开课时间
           NSDate *specifiedDate = [dateFormatter dateFromString:self.mWY_TraCourseDetailModel.coursestarttime];
//    NSDate *specifiedDate = [dateFormatter dateFromString:@"2025-01-03 20:44:54"];
    NSDate *endDate = [dateFormatter dateFromString:self.mWY_TraCourseDetailModel.courseendtime];

           // 获取当前日期
           NSDate *currentDate = [NSDate date];
           // 计算两个日期之间的差值
           NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:specifiedDate];
    
        //计算截止两个日期之间的差值
        NSTimeInterval timeIntervalEnd = [currentDate timeIntervalSinceDate:endDate];
        // 输出相差的秒数
           NSLog(@"相差的秒数: %f", timeInterval);
            startPosition = timeInterval;
    if (timeIntervalEnd >= 0) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"该课程已经结束，课程截止时间：%@",self.mWY_TraCourseDetailModel.courseendtime] preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
        
        
        NSLog(@"自主学习视频 ");
        //禁止前进后退
        SJEdgeControlButtonItem *progressItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_Progress];
 
    //时间分隔符-隐藏
    SJEdgeControlButtonItem *separatorItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_Separator];
    [separatorItem setHidden:YES];
   
    // 全部时长-隐藏
    SJEdgeControlButtonItem *durationTimeItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_DurationTime];
     [durationTimeItem setHidden:YES];
     
    
        //让进度条可以看到- 但是不能操作
        [progressItem.customView setUserInteractionEnabled:NO];
        [_player.defaultEdgeControlLayer.bottomAdapter reload];
        
        //这个可以禁止滑动、禁用前进后退
        _player.gestureRecognizerShouldTrigger = ^BOOL(__kindof SJBaseVideoPlayer * _Nonnull player, SJPlayerGestureType type, CGPoint location) {
            if (type == SJPlayerGestureType_Pan || type == SJPlayerGestureType_LongPress) {
                NSLog(@"禁止滑动、禁用前进后退");
                return NO;
            } else {
                return YES;
            }
        };
 
        _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
            NSLog(@"播放完毕");
            //播放完成后-弹出对话框 强制填写 对本次培训课程内容的评价及建议。
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"课程结束，请对本次课程进行评价！" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.placeholder = @"请输入对本次培训课程内容的评价及建议";
//                textField.keyboardType = UIKeyboardTypeDefault;
//            }];
             [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSString *alertTxt = alertController.textFields[0].text;
//                NSLog(@"评价及建议：%@",alertTxt);
//                 if (alertTxt.length > 0) {
//                     [weakSelf sendMessageByStr:alertTxt];
//                 }else {
//                     [weakSelf.view makeToast:alertController.textFields[0].placeholder duration:1 position:CSToastPositionCenter];
//                     [weakSelf presentViewController:alertController animated:YES completion:nil];
//                     return ;
//                 }
                 
                 WY_AddPjViewController *tempViewControl = [WY_AddPjViewController new];
                 tempViewControl.mWY_TrainItemModel = self.mWY_TrainItemModel;
                 tempViewControl.nsType = @"0";//tempModel.ispl;
                 [self.navigationController pushViewController:tempViewControl animated:YES];
                 
             }])];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

            [weakSelf presentViewController:alertController animated:YES completion:nil];

        };
        
    }
    // 不可滑动-End
    
    NSLog(@"当前开始播放时间的秒数：%d",startPosition);
    [self.imgPlaceholderImage setHidden:YES];
    
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:[videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] startPosition:startPosition];
        asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
            make.append(self.title);
            make.textColor(UIColor.whiteColor);
        }];
        
        _player.URLAsset = asset;
        [_playerContainerView addSubview:_player.view];
        [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    
    [_player.presentView.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",self.mWY_TraCourseDetailModel.tpurl]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]  placeholderImage:[UIImage imageNamed:@"0211_CourseDef"]];

    
//        _player.hiddenPlaceholderImageViewWhenPlayerIsReadyForDisplay = YES;

//        __weak typeof(self) _self = self;
//        _player.rotationObserver.rotationDidStartExeBlock = ^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
//            __strong typeof(_self) self = _self;
//            if ( !self ) return ;
//    #ifdef DEBUG
//            NSLog(@"%d \t %s", (int)__LINE__, __func__);
//    #endif
//        };

}



-(void)ZJScorollPageUI{
    //必要的设置, 如果没有设置可能导致内容显示不正常
       self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    style.titleFont =  WY_FONTRegular(14);
    style.scrollContentView = YES;
 
    // 颜色渐变
//    style.gradualChangeTitleColor = YES;
//    style.scaleTitle = YES;
    style.autoAdjustTitlesWidth = YES;
    style.titleMargin = k360Width(20);
    style.normalTitleColor = MSColor(153, 153, 153);
    style.selectedTitleColor = MSTHEMEColor;
    style.scrollLineColor =MSTHEMEColor;//MSColor(1, 187, 112);
//    style.titleFont = WY_FONTRegular(16);
    style.segmentViewBounces = NO;
    style.contentViewBounces = NO;
    style.segmentHeight = k360Width(44);
    self.titleArr =@[@"详情",@"留言板"];
    
     
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, k360Width(200), kScreenWidth, kScreenHeight - k360Width(200) - JCNew64 - JC_TabbarSafeBottomMargin) segmentStyle:style titles:self.titleArr parentViewController:self delegate:self];
    
    self.scrollPageView = scrollPageView;
    [self.view addSubview:scrollPageView];
    
//    [scrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//        }];
 }


#pragma mark - ZJScrollPageViewChildVcDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titleArr.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    if (index > self.titleArr.count-1) {
        index = self.titleArr.count - 1;
    }
    if (index == 0) {
        [self.navigationItem.rightBarButtonItem.customView setHidden:NO];
    } else {
        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
    }
    self.selZJIndex = index;
      if (index == 0) {
          WY_OTDInfoViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_OTDInfoViewController *)reuseViewController;
          if (!fourview) {
              fourview = [[WY_OTDInfoViewController alloc] init];
              fourview.mWY_TrainItemModel = self.mWY_TrainItemModel;
              fourview.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
          }
           return fourview;
      } else  {
          WY_OTDMessageBoardViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_OTDMessageBoardViewController *)reuseViewController;
          if (!fourview) {
              fourview = [[WY_OTDMessageBoardViewController alloc] init];
               fourview.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;

          }
           return fourview;
      }
}
 

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_player vc_viewDidAppear];
#ifdef DEBUG
    NSLog(@"AA: %d - %s", (int)__LINE__, __func__);
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_player stop];
    [_player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [_player vc_viewDidDisappear];
#ifdef DEBUG
    NSLog(@"AA: %d - %s", (int)__LINE__, __func__);
#endif
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
#ifdef DEBUG
    NSLog(@"%d - -[%@ %s]", (int)__LINE__, NSStringFromClass([self class]), sel_getName(_cmd));
#endif
}


- (void)sendMessageByStr :(NSString *)messageStr {
    WY_GuestBookModel *mesModel = [WY_GuestBookModel new];
    mesModel.classGuid = self.mWY_TraCourseDetailModel.ClassGuid;
    mesModel.content = messageStr;
    mesModel.idcardnum = self.mUser.idcardnum;
    mesModel.danWeiName = self.mUser.DanWeiName;
    mesModel.phone = self.mUser.LoginID;
    mesModel.name = self.mUser.realname;
    mesModel.pxbs = @"1";
     
    [[MS_BasicDataController sharedInstance] postWithURL:insetTTrainmessage_HTTP params:nil jsonData:[mesModel toJSONData] showProgressView:YES success:^(id successCallBack) {
        MSLog(@"添加评价成功");
        
        [SVProgressHUD showSuccessWithStatus:@"添加评价成功"];
//        [self dataSourceIndex];
     } failure:^(NSString *failureCallBack) {
        [SVProgressHUD showErrorWithStatus:failureCallBack];
    } ErrorInfo:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];

}
@end
