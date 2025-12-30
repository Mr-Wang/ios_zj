//
//  WY_CAPaySuccessViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/17.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_CAPaySuccessViewController : UIViewController
@property (nonatomic , strong) NSMutableDictionary *dicSignUpSuccess;
@property (nonatomic , strong) NSString * bodyStr;
@property (nonatomic , strong) NSString * caType;//1是实体CA、2是云签章
@end

NS_ASSUME_NONNULL_END
