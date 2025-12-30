//
//  WY_VipInfoModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/20.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_VipInfoModel : MHObject
@property (nonatomic , strong) NSString *dateStr;
@property (nonatomic , strong) NSString *vipType;
@property (nonatomic , strong) NSString *isOpen;
@end

NS_ASSUME_NONNULL_END
