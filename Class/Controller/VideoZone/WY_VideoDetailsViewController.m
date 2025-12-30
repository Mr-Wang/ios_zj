//
//  WY_VideoDetailsViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/6.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_VideoDetailsViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <SJUIKit/NSAttributedString+SJMake.h>
#import "ZJScrollPageView.h"//选择控制器]
#import "WY_VDListViewController.h"
#import "WY_VDInfoViewController.h"


@interface WY_VideoDetailsViewController () {
    UIButton *btnBack;
    UIImageView *imgNoBg;
    UILabel *lblNoBg;
    UIButton *btnEnterYqm;
}
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic, strong) WY_InfomationModel *mDetailMode;
@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) UIImageView *imgPlaceholderImage;
@property (nonatomic, strong) WY_InfomationModel *addIntegralModel;
@property (nonatomic, strong) SJVideoPlayer *player;
 
@property (nonatomic)NSInteger selZJIndex;
@property (nonatomic, weak) ZJScrollPageView *scrollPageView;//选择控制器
@property (nonatomic , strong)  NSArray *titleArr;/* 选择控制器title*/
@end

@implementation WY_VideoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [self makeUI];
 }

- (void)makeUI {
    self.title = self.mWY_InfomationModel.title;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.playerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, MH_APPLICATION_STATUS_BAR_HEIGHT, kScreenWidth, k360Width(200))];
    [self.view addSubview:self.playerContainerView];
    self.imgPlaceholderImage = [UIImageView new];
    self.imgPlaceholderImage.frame = self.playerContainerView.bounds;
    [self.playerContainerView addSubview:self.imgPlaceholderImage];
    btnBack = [UIButton new];
    [btnBack setFrame:CGRectMake(k360Width(0), 0, k360Width(44), k360Width(44))];
    [btnBack setImage:[UIImage imageNamed:@"0225_quizback"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.playerContainerView addSubview:btnBack];

        btnEnterYqm = [[UIButton alloc] initWithFrame:CGRectMake(0, k360Width(110), k360Width(90), k360Width(30))];
        [btnEnterYqm.titleLabel setFont:WY_FONTMedium(14)];
        [btnEnterYqm rounded:k360Width(30/2)];
//        [btnEnterYqm setBackgroundColor:MSTHEMEColor];
    [btnEnterYqm setBackgroundColor:MSColorA(0, 0, 0, 0.5)];
        [btnEnterYqm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnEnterYqm setTitle:@"点击开通" forState:UIControlStateNormal];
    [btnEnterYqm addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if ([self.mWY_InfomationModel.price isEqualToString:@"未定价"]) {
            [SVProgressHUD showErrorWithStatus:@"此视频暂时无法观看，感谢您的支持"];
            return ;
        } else {
            [SVProgressHUD showErrorWithStatus:@"此视频暂时无法观看，请联系客服"];
            [GlobalConfig makeCall:@"024-86082777"];
        }
    }];
        btnEnterYqm.centerX = self.playerContainerView.centerX;
    //    [self.playerContainerView addSubview:lblYqmTitle];
        [self.playerContainerView addSubview:btnEnterYqm];

    
    _player = [SJVideoPlayer player];
    _player.autoplayWhenSetNewAsset = YES;
//    _player.defaultEdgeControlLayer.showResidentBackButton = YES;
    _player.pausedToKeepAppearState = YES;
    _player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
    //禁用-画中画功能；
    _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    
    //隐藏- 更多里的-调速功能；
    [_player.defaultMoreSettingControlLayer.rightAdapter itemForTag:SJMoreSettingControlLayerItem_Rate].hidden = YES;
    
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:[self.mWY_InfomationModel.videourl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(self.mWY_InfomationModel.title);
        make.textColor(UIColor.whiteColor);
    }];
    //列表里搜索的条件是免费视频，但是现在接口返回isfree=1的， 专家没有收费视频概念， 去掉收费视频限制内容
    /*
     2021-11-18 10:06:46
     列表里搜索的条件是原来是免费视频，
     后来接口改了 把收费视频内容也放出来了，
     代码里有收费视频限制，
     现在把代码里的限制去掉， 打一版， 明天能上线*/
//    if ([self.mWY_InfomationModel.isfree isEqualToString:@"0"] || [self.mWY_InfomationModel.isBuy isEqualToString:@"1"]) {
        _player.URLAsset = asset;
        [_playerContainerView addSubview:_player.view];
        [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        [_player.presentView.placeholderImageView setContentMode:UIViewContentModeScaleToFill];
         [_player.presentView.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:[self.mWY_InfomationModel.imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        _player.hiddenPlaceholderImageViewWhenPlayerIsReadyForDisplay = YES;
        _player.delayInSecondsForHiddenPlaceholderImageView = 0.1;

        [self.imgPlaceholderImage setHidden:YES];
        [btnEnterYqm setHidden:YES];
        [btnBack setHidden:YES];
        
        //只有企业用户才加积分
//        if (self.mUser.orgnum !=nil && self.mUser.orgnum.length > 0) {
            self.addIntegralModel = self.mWY_InfomationModel;
            [self performSelector:@selector(httpAddIntegral) afterDelay:10];
//           }
        
//    } else {
//
//        [self.imgPlaceholderImage sd_setImageWithURL:[NSURL URLWithString:[self.mWY_InfomationModel.imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        [self.imgPlaceholderImage setHidden:NO];
//        [btnEnterYqm setHidden:NO];
//        [btnBack setHidden:NO];
//    }

    
//    __weak typeof(self) _self = self;
//    _player.rotationObserver.rotationDidStartExeBlock = ^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
//        __strong typeof(_self) self = _self;
//        if ( !self ) return ;
//#ifdef DEBUG
//        NSLog(@"%d \t %s", (int)__LINE__, __func__);
//#endif
//    };
    
    
    
    [self ZJScorollPageUI];
    
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
    self.titleArr =@[@"播放列表",@"详情"];
    
     
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, self.playerContainerView.bottom, kScreenWidth, kScreenHeight - self.playerContainerView.bottom) segmentStyle:style titles:self.titleArr parentViewController:self delegate:self];
    
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
          WY_VDListViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_VDListViewController *)reuseViewController;
          if (!fourview) {
              fourview = [[WY_VDListViewController alloc] init];
              fourview.mWY_InfomationModel = self.mWY_InfomationModel;
          }
          fourview.selPlayVideoBlock = ^(WY_InfomationModel * _Nonnull withSelModel) {
              [self rePlayVideo:withSelModel];
          };
           return fourview;
      } else  {
          WY_VDInfoViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_VDInfoViewController *)reuseViewController;
          if (!fourview) {
              fourview = [[WY_VDInfoViewController alloc] init];
              fourview.mWY_InfomationModel = self.mWY_InfomationModel;
          }
           return fourview;
      }
}
///播放视频
- (void)rePlayVideo:(WY_InfomationModel *)withModel
{
    if (withModel.id) {
        withModel.infoid =withModel.id;
        //先取消上次的线程
           NSLog(@"取消执行添加积分线程");
           [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(httpAddIntegral) object:nil];
        NSLog(@"这里添加积分");
        self.addIntegralModel = withModel;
        [self performSelector:@selector(httpAddIntegral) afterDelay:10];
    }
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:[withModel.videourl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(withModel.title);
        make.textColor(UIColor.whiteColor);
    }];
//    if ([self.mWY_InfomationModel.isfree isEqualToString:@"0"] || [self.mWY_InfomationModel.isBuy isEqualToString:@"1"]) {
        _player.URLAsset = asset;
        _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
            NSLog(@"播放完毕");
            //播放完成后-自动播放下一条
             [[NSNotificationCenter defaultCenter] postNotificationName:@"kAutoPlayNext" object:nil];
        };
//        [_playerContainerView addSubview:_player.view];
        [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        [_player.presentView.placeholderImageView setContentMode:UIViewContentModeScaleToFill];
         [_player.presentView.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:[self.mWY_InfomationModel.imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        _player.hiddenPlaceholderImageViewWhenPlayerIsReadyForDisplay = YES;
        _player.delayInSecondsForHiddenPlaceholderImageView = 0.1;
        [self.imgPlaceholderImage setHidden:YES];
        [btnEnterYqm setHidden:YES];
        [btnBack setHidden:YES];
//    } else {
//        [self.imgPlaceholderImage sd_setImageWithURL:[NSURL URLWithString:[self.mWY_InfomationModel.imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        [self.imgPlaceholderImage setHidden:NO];
//        [btnEnterYqm setHidden:NO];
//        [btnBack setHidden:NO];
//    }
}


 - (void)httpAddIntegral {
//     //专家不加积分
//     return;
    NSLog(@"执行了");
    NSMutableDictionary *dicJson = [NSMutableDictionary new];
    [dicJson setObject:self.mUser.orgnum forKey:@"orgnum"];
    [dicJson setObject:self.addIntegralModel.title forKey:@"title"];
    [dicJson setObject:@"2" forKey:@"projectGuid"];
    [dicJson setObject:self.addIntegralModel.infoid forKey:@"infoid"];
    [dicJson setObject:@"1" forKey:@"type"];
     [[MS_BasicDataController sharedInstance] postWithReturnCode:insetIntegral_HTTP params:nil jsonData:[dicJson yy_modelToJSONData] showProgressView:NO success:^(id res, NSString *code) {
     } failure:^(NSError *error) {
    }];

}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
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
    [_player vc_viewWillDisappear];
    //取消执行添加积分线程
       NSLog(@"取消执行添加积分线程");
       [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(httpAddIntegral) object:nil];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
#ifdef DEBUG
    NSLog(@"%d - -[%@ %s]", (int)__LINE__, NSStringFromClass([self class]), sel_getName(_cmd));
#endif
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)btnBackAction {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

