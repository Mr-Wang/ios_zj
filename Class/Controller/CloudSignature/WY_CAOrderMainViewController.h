//
//  WY_CAOrderMainViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_FilterTreeMain.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CAOrderMainViewController : UIViewController

@property (nonatomic, strong) WY_FilterTreeMain *mWY_FilterTreeMain;
@property (nonatomic)NSInteger selZJIndex;

@end

NS_ASSUME_NONNULL_END
