//
//  MS_WindowTool.h
//  MET
//
//  Created by Mrxiaowu on 16/4/5.
//  Copyright © 2016年 zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MS_WindowTool : NSObject
/**
 *  选择窗口的根控制器为新特性控制器或主页控制器
 */
+ (void)chooseRootViewControllerWithWindow:(UIWindow *)window;
@end
