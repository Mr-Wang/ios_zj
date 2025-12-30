//
//  WY_ExpertFeeListViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/6.
//  Copyright © 2022 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ExpertFeeListViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic, strong) NSString *selCategorynum;
@property (nonatomic , assign) NSInteger idx;/* 第几个 */
@property (nonatomic, strong) NSString *isItemClicked;
@property (nonatomic, strong) NSString *isFlfg;
@property (nonatomic, strong) NSString *keyword;

@end

NS_ASSUME_NONNULL_END
