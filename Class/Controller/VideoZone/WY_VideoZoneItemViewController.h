//
//  WY_VideoZoneItemViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_VideoZoneItemViewController : UIViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) NSString *keyword;
@end

NS_ASSUME_NONNULL_END
