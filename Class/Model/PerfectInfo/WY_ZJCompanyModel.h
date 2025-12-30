//
//  WY_ZJCompanyModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ZJCompanyModel : MHObject
/*private String id;
private String expertIdCard;
private String companyName;
private String companytype;*/
@property (nonatomic, strong) NSString *expertIdCard;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companytype;//0原单位1现单位2回避单位
@property (nonatomic, strong) NSString *isDel;


/// 提交数据：
/*     * zjCompanyList : [{"zjCompanyName":"专家单位","zjCompanyType":1},{"zjCompanyName":"专家单位2","zjCompanyType":2}]
*/
@property (nonatomic, strong) NSString *zjCompanyType;//0原单位1现单位2回避单位
@property (nonatomic, strong) NSString *zjCompanyName;


@property (nonatomic, strong) NSString *jobTitleName;
@property (nonatomic, strong) NSString *jobTitleCode;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *id;

@end

NS_ASSUME_NONNULL_END
