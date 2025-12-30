//
//  WY_CheckModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CheckModel : MHObject
@property (nonatomic , strong) NSString * rowGuid;
@property (nonatomic , strong) NSString * auditStatus;
@property (nonatomic , strong) NSString * questionType;
@end

NS_ASSUME_NONNULL_END
