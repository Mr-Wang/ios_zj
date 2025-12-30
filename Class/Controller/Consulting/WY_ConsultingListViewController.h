//
//  WY_ConsultingListViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/6.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ConsultingListViewController : UIViewController
@property (nonatomic , strong)WY_MessageModel *mWY_MessageModel;
//1是自己 -  2是 管理员
@property (nonatomic , strong) NSString *nsType;
@end

NS_ASSUME_NONNULL_END
