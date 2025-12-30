//
//  WY_HistoryProjListViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/12/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_HistoryProjListViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic, strong) NSString *selCategorynum;
@property (nonatomic , assign) NSInteger idx;/* 第几个 */
@property (nonatomic, strong) NSString *isItemClicked;
@property (nonatomic, strong) NSString *isFlfg;
@property (nonatomic, strong) NSString *keyword;

@property (nonatomic , strong) NSString *nstype;

@end

NS_ASSUME_NONNULL_END
