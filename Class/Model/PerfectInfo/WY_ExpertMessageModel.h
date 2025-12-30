//
//  WY_ExpertMessageModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_MajorPhotoModel.h"
#import "WY_ZJCompanyModel.h"
#import "WY_CityModel.h"
#import "WY_CityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ExpertMessageModel : MHObject
/*"zjBankNum": null,
"voidCompany": [],
"expert": null,
"zjBankType": null,
"currentCompany": [],
"expertProfessions"
 "originalCompany": [],
        "zjPhone": "18698898846",
        "zjIdCard": "211222196901040429",
        "zjOriginalCompany": "开原市水利局",
        "idCardEle": "d:/upload/ccfec29b207f4af9925061c468aaa698.jpg,d:/upload/4e761bf6dc7c4ad6aaefa5a25e149bba.jpg",
        "zjName": "赵晓红",
        "socialSecurityEle": "d:/upload/02c85f39c8494be6980b9e096efcb5fa.jpg,d:/upload/e709f6ecf8cc45f4a7945691e6ccce1f.jpg",
        "zjOldProfession": "A027|C043|C007",
        "zjSex": "女"
 */

@property (nonatomic, strong) NSString *zjBankNum;
@property (nonatomic, strong) NSString *expert;
@property (nonatomic, strong) NSString *zjBankType;
@property (nonatomic, strong) NSString *zjBankName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *cityCode;
 @property (nonatomic, strong) NSString *zjPhone;
@property (nonatomic, strong) NSString *zjIdCard;
@property (nonatomic, strong) NSString *zjOriginalCompany;
//身份证照照片组
@property (nonatomic, strong) NSString *idCardEle;
@property (nonatomic, strong) NSString *zjName;
//社保照片组
@property (nonatomic, strong) NSString *socialSecurityEle;
@property (nonatomic, strong) NSString *commitmentEle;
@property (nonatomic, strong) NSString *commitmentEleNew;
@property (nonatomic, strong) NSString *inDoor;
@property (nonatomic, strong) NSString *pendingmentEleNew;
@property (nonatomic, strong) NSString *alterZy;
@property (nonatomic, strong) NSString *zjOldProfession;
@property (nonatomic, strong) NSString *zjSex;
@property (nonatomic, strong) NSString *styleId;
@property (nonatomic, strong) NSString *selStyleId;
@property (nonatomic, strong) NSString *secre;

@property (nonatomic, strong) NSString *professionState;
@property (nonatomic, strong) NSString *aexpertId;

/**
 * 是否可以添加
 * 0 全部不可以添加 1 可以全部添加 2 只能添加新专业 3 只能添加老专业
 */
@property (nonatomic, strong) NSString *letAdd;

//回避单位
@property (nonatomic, readwrite, copy) NSArray <WY_ZJCompanyModel *> *voidCompany;

//专业职称
@property (nonatomic, readwrite, copy) NSArray <WY_ZJCompanyModel *> *jobTitleList;
//原单位
 @property (nonatomic, readwrite, copy) NSArray <WY_ZJCompanyModel *> *originalCompany;

@property (nonatomic, readwrite, copy) NSArray <WY_MajorPhotoModel *> *expertProfessions;

//现单位
@property (nonatomic, readwrite, copy) NSArray <WY_ZJCompanyModel *> *currentCompany;

//城市列表
@property (nonatomic, readwrite, copy) NSArray <WY_CityModel *> *cityList;

@end

NS_ASSUME_NONNULL_END
