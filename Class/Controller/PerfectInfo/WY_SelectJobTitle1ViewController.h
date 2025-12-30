//
//  WY_SelectJobTitle1ViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/11/7.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ZJCompanyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_SelectJobTitle1ViewController : UIViewController
@property (nonatomic,copy) void(^selJobTitleBlock)(WY_ZJCompanyModel *selModel);
@end

NS_ASSUME_NONNULL_END
