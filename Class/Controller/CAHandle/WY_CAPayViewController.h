//
//  WY_CAPayViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/17.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_CAPayViewController : UIViewController
@property (nonatomic, strong) NSMutableDictionary *dicPostCAInfo;


@property (nonatomic , strong) NSString *isEdit; //1是已付款后编辑，2是未付款编辑- 可以付款
@property (nonatomic , strong) NSMutableDictionary *dicEditInfo;
@end

NS_ASSUME_NONNULL_END
