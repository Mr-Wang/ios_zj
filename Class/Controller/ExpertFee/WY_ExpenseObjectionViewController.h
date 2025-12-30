//
//  WY_ExpenseObjectionViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/8.
//  Copyright © 2022 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_ExpenseObjectionViewController : UIViewController
@property (nonatomic, strong) NSString *infoID;
@property (nonatomic ,strong) NSMutableDictionary *dicDataSource;
@end

NS_ASSUME_NONNULL_END
