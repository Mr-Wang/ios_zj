//
//  WY_UpdateZjAddressViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/7/23.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_CityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_UpdateZjAddressViewController : UIViewController
@property (nonatomic, strong) NSString *cityStr;
@property (nonatomic, strong) NSString *aexpertId;
//城市列表
@property (nonatomic, readwrite, copy) NSArray <WY_CityModel *> *cityList;

@property (nonatomic, strong) WY_CityModel *selCityModel;
@property (nonatomic,copy) void(^updateSuccessBlock)(WY_CityModel *cityModel);
@end

NS_ASSUME_NONNULL_END
