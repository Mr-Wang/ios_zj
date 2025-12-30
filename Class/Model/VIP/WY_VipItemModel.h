//
//  WY_VipItemModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/21.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_VipItemModel : MHObject
@property (nonatomic, readwrite, copy) NSString *id;
@property (nonatomic, readwrite, copy) NSString *isca;
@property (nonatomic, readwrite, copy) NSString *gmlx;
@property (nonatomic, readwrite, copy) NSString *price;
@property (nonatomic, readwrite, copy) NSString *newprice;
@property (nonatomic, readwrite, copy) NSString *dz;
@property (nonatomic, readwrite, copy) NSString *applicationINnm;
@end

NS_ASSUME_NONNULL_END
