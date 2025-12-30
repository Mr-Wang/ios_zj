//
//  WY_AddressManageModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_AddressManageModel : MHObject
@property (nonatomic , strong) NSString * RowGuid;
@property (nonatomic , strong) NSString * CGRUserGuid;
@property (nonatomic , strong) NSString * UserName;
@property (nonatomic , strong) NSString * province;
@property (nonatomic , strong) NSString * ProvinceCode;
@property (nonatomic , strong) NSString * CityCode;
@property (nonatomic , strong) NSString * CountryCode;
@property (nonatomic , strong) NSString * TownCode;
@property (nonatomic , strong) NSString * city;
@property (nonatomic , strong) NSString * district;
@property (nonatomic , strong) NSString * Address;
@property (nonatomic , strong) NSString * postCode;
@property (nonatomic , strong) NSString * Mobile;
@property (nonatomic , strong) NSString * IsDefault;
@property (nonatomic , strong) NSString * addressStr;

@end

NS_ASSUME_NONNULL_END
