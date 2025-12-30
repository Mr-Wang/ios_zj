//
//  WY_BiddingProjectListViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/23.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_BiddingProjectListViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
//1待评、2历史
@property (nonatomic , strong) NSString *nstype;
@property (nonatomic , strong) NSString *keyword;
@end

NS_ASSUME_NONNULL_END
