//
//  WY_MyTQListViewController.h
//  我的题目-列表页
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MyTQListViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic , assign) NSInteger idx;/* 第几个 */

@end

NS_ASSUME_NONNULL_END
