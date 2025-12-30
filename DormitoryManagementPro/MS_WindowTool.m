//
//  MS_WindowTool.m
//  MET
//
//  Created by Mrxiaowu on 16/4/5.
//  Copyright © 2016年 zheng. All rights reserved.
//

#import "MS_WindowTool.h"
#import "MS_GuideViewController.h"
#import "MS_TabBarController.h"


#define Key @"CFBundleShortVersionString"
@implementation MS_WindowTool
+ (void)chooseRootViewControllerWithWindow:(UIWindow *)window {
//    // 取出保存在沙盒中的版本号
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *sandboxVersion = [defaults objectForKey:Key];
//    // 获得当前软件版本号
//    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
//    NSString *currentVersion = infoDict[Key];
//
//    // 比较沙盒中版本号和当前版本号是否一致
//    if (![sandboxVersion isEqualToString:currentVersion]) {// 沙盒中版本号不存在或沙盒中版本号较小
////        app.statusBarHidden = YES;// 隐藏状态栏
//        window.rootViewController = [[MS_GuideViewController alloc] init];
//        // 将最新的版本号保存到沙盒
//        [defaults setObject:currentVersion forKey:Key];
//        [defaults synchronize];
//
//
//
//    } else {// 版本号一致

            //已登录            
            MS_TabBarController *mainTabVC = [[MS_TabBarController alloc] init];
            window.rootViewController = mainTabVC;
//        }
    
    [window makeKeyAndVisible];
    
}


@end


