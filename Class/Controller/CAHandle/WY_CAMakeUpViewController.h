//
//  WY_CAMakeUpViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/24.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_CAMakeUpViewController : UIViewController
@property (nonatomic , strong) NSString *isEdit; //1是编辑
@property (nonatomic , strong) NSMutableDictionary *dicEditInfo;

@end

NS_ASSUME_NONNULL_END
