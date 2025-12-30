//
//  LGCheckVersion.m
//  Zhongdou
//
//  Created by lingo on 2017/3/8.
//  Copyright © 2017年 zhongdoukeji. All rights reserved.
//

#import "LGCheckVersion.h"
#import "LGAppInfo.h"
#import "AFNetworking.h"
//#import <AFNetworking.h>
/** weakSelf */
#define LGWeakObj(o) autoreleasepool{} __weak typeof(o) weak##o = o
#define LGStrongObj(o) autoreleasepool{} __strong typeof(o) o = weak##o
/** 偏好设置 */
#define LGUserDefaults [NSUserDefaults standardUserDefaults]
/** keyWindow */
#define LGKeyWindow [UIApplication sharedApplication].keyWindow
/** shareApplication */
#define LGApplication [UIApplication sharedApplication]
/* * * * * * * * * * * LGLog（控制输出） * * * * * * * * * * * */
#ifdef DEBUG
#define LGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#define LGLog(...)
#endif

static NSString * const skipVersionKey = @"skipVersionKey";

@interface LGCheckVersion ()<UIAlertViewDelegate>
/** appstore上的版本号 */
@property (nonatomic ,copy) NSString *storeVersion;
/** 更新的地址 */
@property (nonatomic ,copy) NSString *trackViewUrl;
/** 必须更新的弹出框 */
@property (nonatomic ,weak) UIAlertView *requiredAlert;
/** 可选更新的弹出框 */
@property (nonatomic ,weak) UIAlertView *optionalAlert;


@property (nonatomic, strong) UIView *viewGG;
@property (nonatomic, strong) UIImageView *imgGG;
@property (nonatomic, strong) UIButton *btnGGClose;
@property (nonatomic, strong) UIButton *btnGGOpen;
@property (nonatomic, strong) UILabel *lbl1;
@property (nonatomic, strong) UILabel *lbl2;
@property (nonatomic, strong) UILabel *lbl3;
@property (nonatomic, strong) UILabel *lbl4;
@end

@implementation LGCheckVersion

static LGCheckVersion *_checkVersion = nil;
+ (instancetype)shareCheckVersion{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _checkVersion = [LGCheckVersion alloc];
    });
    return _checkVersion;
}

- (void)checkVersion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[LGAppInfo appUrlInItunes]  parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        LGLog(@"%@",responseObject);
        //1.是否请求成功
        if (((NSArray *)responseObject[@"results"]).count<=0) return;
        //2.获取appstore版本号和提示信息
        self.storeVersion = [(NSArray *)responseObject[@"results"] firstObject][@"version"];
         self.trackViewUrl = [(NSArray *)responseObject[@"results"] firstObject][@"trackViewUrl"];
        
        NSString *releaseNotes = [(NSArray *)responseObject[@"results"] firstObject][@"releaseNotes"];
        //3.获取跳过的版本号
        NSString *skipVersion = [[NSUserDefaults standardUserDefaults] valueForKey:skipVersionKey];
        //4.比较版本号
        LGLog(@"%@--%@",self.storeVersion,skipVersion);
        if ([self.storeVersion isEqualToString:skipVersion]) {//如果store和跳过的版本相同
            return;
        }else{
            [self compareCurrentVersion:[LGAppInfo appVersion] withAppStoreVersion:self.storeVersion updateMsg:releaseNotes];
        }
        
    } failure:nil];
}
/**
 当前版本号和appstore比较
 
 @param currentVersion 当前版本
 @param appStoreVersion appstore上的版本
 @param updateMsg 更新内容
 */
- (void)compareCurrentVersion:(NSString *)currentVersion withAppStoreVersion:(NSString *)appStoreVersion updateMsg:(NSString *)updateMsg{
    NSMutableArray *currentVersionArray = [[currentVersion componentsSeparatedByString:@"."] mutableCopy];
    NSMutableArray *appStoreVersionArray = [[appStoreVersion componentsSeparatedByString:@"."] mutableCopy];
    if (!currentVersionArray.count ||!appStoreVersionArray.count) return;
    //修订版本号
    int modifyCount = abs((int)(currentVersionArray.count - appStoreVersionArray.count));
    if (currentVersionArray.count > appStoreVersionArray.count) {
        for (int index = 0; index < modifyCount; index ++) {
            [appStoreVersionArray addObject:@"0"];
        }
    } else if (currentVersionArray.count < appStoreVersionArray.count) {
        for (int index = 0; index < modifyCount; index ++) {
            [currentVersionArray addObject:@"0"];
        }
    }
    //大版本必须强制更新<及 第一位表示大版本>
    if ([currentVersionArray.firstObject integerValue] < [appStoreVersionArray.firstObject integerValue]) {
        //强制更新---
        [self showUpdateAlertMust:YES withStoreVersion:appStoreVersion message:updateMsg];
    }else if ([currentVersionArray.firstObject integerValue] == [appStoreVersionArray.firstObject integerValue]) {//不需要强制更新 检查后面的版本号,如果比appstore大  则更新
        //判断第二位版本号
        if ([currentVersionArray[1] integerValue] == [appStoreVersionArray[1] integerValue]) {
            //判断第三位版本号
            if ([currentVersionArray[2] integerValue] < [appStoreVersionArray[2] integerValue]) {
                [self showUpdateAlertMust:NO withStoreVersion:appStoreVersion message:updateMsg];
                return;
            }
        } else  if ([currentVersionArray[1] integerValue] < [appStoreVersionArray[1] integerValue]) {
            //版本号 - 第二位大则 强制更新
            [self showUpdateAlertMust:YES withStoreVersion:appStoreVersion message:updateMsg];
            return;
            
        } else {
            return;
        }
    }
}
/**
 弹出提示框  是否更新
 
 @param must 是否强制更新  YES ->是的:NO -> 不是
 @param storeVersion 需要更新版本(store版本)
 @param message 提示信息
 */
- (void)showUpdateAlertMust:(BOOL)must withStoreVersion:(NSString *)storeVersion message:(NSString *)message{
    if (self.viewGG) {
         [self.viewGG removeFromSuperview];
    }
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.viewGG = [UIView new];
        [window addSubview: self.viewGG];
         [self.viewGG setFrame:window.bounds];
        
        [self.viewGG setBackgroundColor:MHColorFromRGBAlpha(0x000000, 0.5)];
        
        self.imgGG = [UIImageView new];
        [self.imgGG setFrame:CGRectMake(k360Width(41), k360Width(120), k360Width(278), k360Width(354))];
        [self.imgGG setImage:[UIImage imageNamed:@"0729_upVersion"]];
    //    [self.imgGG setBackgroundColor:MSTHEMEColor];
        [self.viewGG addSubview:self.imgGG];
        
        self.lbl1 = [UILabel new];
        self.lbl2 = [UILabel new];
        self.lbl3= [UILabel new];
        self.lbl4 = [UILabel new];
        [self.viewGG addSubview:self.lbl1];
        [self.viewGG addSubview:self.lbl2];
        [self.viewGG addSubview:self.lbl3];
        [self.viewGG addSubview:self.lbl4];
        
        [self.lbl1 setFrame:CGRectMake(self.imgGG.left + k360Width(30), self.imgGG.top + k360Width(30), self.imgGG.width - k360Width(60), k360Width(35))];
        [self.lbl1 setText:@"发现新版本！"];
        [self.lbl1 setTextColor:[UIColor whiteColor]];
        [self.lbl1 setFont:WY_FONTMedium(24)];
        
        [self.lbl2 setFrame:CGRectMake(self.imgGG.left + k360Width(30), self.lbl1.bottom + k360Width(8), self.imgGG.width - k360Width(60), k360Width(35))];
        [self.lbl2 setText:[NSString stringWithFormat:@"V.%@",storeVersion]];
        [self.lbl2 setTextColor:[UIColor whiteColor]];
        [self.lbl2 setFont:WY_FONTMedium(20)];
        
        [self.lbl3 setFrame:CGRectMake(self.imgGG.left + k360Width(30), self.lbl2.bottom + k360Width(60), self.imgGG.width - k360Width(60), k360Width(22))];
        [self.lbl3 setText:@"更新内容"];
        [self.lbl3 setTextColor:HEXCOLOR(0x555555)];
        [self.lbl3 setFont:WY_FONTMedium(16)];
        
        [self.lbl4 setFrame:CGRectMake(self.imgGG.left + k360Width(30), self.lbl3.bottom + k360Width(5), self.imgGG.width - k360Width(60), k360Width(100))];
        [self.lbl4 setText:message];
        [self.lbl4 setNumberOfLines:4];
        [self.lbl4 setTextColor:HEXCOLOR(0x555555)];
        [self.lbl4 setFont:WY_FONTRegular(16)];
     
        self.btnGGOpen = [UIButton new];
        [self.btnGGOpen setFrame:CGRectMake(self.imgGG.left + k360Width(30), self.imgGG.bottom - k360Width(60), self.imgGG.width - k360Width(60), k360Width(35))];
        
    //    [self.btnGGOpen setBackgroundColor:MSTHEMEColor];
    //    [self.btnGGOpen setTitle:@"立即更新" forState:UIControlStateNormal];
    //    [self.btnGGOpen rounded:k360Width(35 / 2)];
        
        [self.btnGGOpen addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
             NSLog(@"跳转到Appstore");
            [self openAppStoreToUpdate];
        }];
        [self.viewGG addSubview:self.btnGGOpen];
        
        self.btnGGClose = [UIButton new];
        [self.btnGGClose setFrame:CGRectMake(0, self.imgGG.bottom + k360Width(10), k360Width(33), k360Width(33))];
        self.btnGGClose.centerX = self.imgGG.centerX;
        [self.btnGGClose setBackgroundImage:[UIImage imageNamed:@"0623_vipColse"] forState:UIControlStateNormal];
        [self.viewGG addSubview:self.btnGGClose];
    WS(weakSelf)
        [self.btnGGClose addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakSelf.viewGG setHidden:YES];
        }];
        if (must) {
            [self.btnGGClose setHidden:YES];
        } else {
            [self.btnGGClose setHidden:NO];
        }
    }


 


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    LGLog(@"%zd",buttonIndex);
    if (self.requiredAlert == alertView) {//必须更新
        [self openAppStoreToUpdate];
    }else{//可选更新
        if (0 == buttonIndex) {//立即更新
            [self openAppStoreToUpdate];
        }else if (1 == buttonIndex){//下次再说
            LGLog(@"下次再说");
        }else{//跳过此版本
            [LGUserDefaults setObject:self.storeVersion forKey:skipVersionKey];
            [LGUserDefaults synchronize];
            LGLog(@"跳过此版本");
        }
    }
}

/**
 打开appstore 执行更新操作
 */
- (void)openAppStoreToUpdate{
    LGLog(@"打开到appstore");
    NSURL *trackUrl = [NSURL URLWithString:self.trackViewUrl];
    if ([LGApplication canOpenURL:trackUrl]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:trackUrl options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL: trackUrl];
        }
        
    }
}

@end
