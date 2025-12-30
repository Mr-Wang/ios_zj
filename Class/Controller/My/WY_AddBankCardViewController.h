//
//  WY_AddBankCardViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/30.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_AddBankCardViewController : UIViewController
//
@property (nonatomic,copy) void(^selBankResuleBlock)(NSString *strResule);
@end

NS_ASSUME_NONNULL_END
