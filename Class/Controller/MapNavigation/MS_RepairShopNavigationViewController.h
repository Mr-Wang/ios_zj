//
//  MS_RepairShopNavigationViewController.h
//  MigratoryBirds
//
//  Created by 许春娜 on 2018/8/7.
//  Copyright © 2018年 Doj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface MS_RepairShopNavigationViewController : UIViewController
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *titleStr;
@end
