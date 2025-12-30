//
//  MyTabBar.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/11/20.
//  Copyright © 2019 王杨. All rights reserved.
//
#import <UIKit/UIKit.h>

@class MyTabBar;

//MyTabBar的代理必须实现addButtonClick，以响应中间“+”按钮的点击事件
@protocol MyTabBarDelegate <NSObject>

-(void)addButtonClick:(MyTabBar *)tabBar;

@end

@interface MyTabBar : UITabBar

//指向MyTabBar的代理
@property (nonatomic,weak) id<MyTabBarDelegate> myTabBarDelegate;

@end
