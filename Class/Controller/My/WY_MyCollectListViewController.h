//
//  WY_MyCollectListViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/4.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
#import "WY_FilterTreeMain.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_MyCollectListViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic, strong) NSString *selCategorynum;
@property (nonatomic , assign) NSInteger idx;/* 第几个 */
@property (nonatomic, strong) NSString *isItemClicked;
@property (nonatomic, strong) NSString *isFlfg;
 
@end

NS_ASSUME_NONNULL_END
