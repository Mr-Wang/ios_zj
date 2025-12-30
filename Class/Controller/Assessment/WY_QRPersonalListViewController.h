//
//  WY_QRPersonalListViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QRPersonalListViewController : UIViewController<ZJScrollPageViewChildVcDelegate> 
@property (nonatomic , assign) NSInteger idx;/* 第几个 */
@property (nonatomic, strong) NSString *nsType;
@end

NS_ASSUME_NONNULL_END
