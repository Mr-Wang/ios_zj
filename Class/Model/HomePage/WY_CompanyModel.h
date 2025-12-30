//
//  WY_CompanyModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/3.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CompanyModel : MHObject
@property (nonatomic, readwrite, copy) NSString *companyId;//公司id
@property (nonatomic, readwrite, copy) NSString *companyName;//公司名称
@property (nonatomic, readwrite, copy) NSString *companyAddress;//公司地址
@property (nonatomic, readwrite, copy) NSString *zbNum;//中标个数
@property (nonatomic, readwrite, copy) NSString *zzNum;//资质个数
@property (nonatomic, readwrite, copy) NSString *cxNum;//诚信个数
@property (nonatomic, readwrite, copy) NSString *constructorNum;//建造师个数
@property (nonatomic, readwrite, copy) NSString *honourNum;//荣誉个数
@property (nonatomic, readwrite, copy) NSString *unitorgnum;//企业组织代码
@property (nonatomic) BOOL * isSelect;
@end

NS_ASSUME_NONNULL_END
