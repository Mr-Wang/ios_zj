//
//  WY_ParamExpertModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_ZJCompanyModel.h"
#import "WY_MajorPhotoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_ParamExpertModel : MHObject
/**
* userGuid : 0120
* zjBankNum : 1234567890
* zjBankType : 人民银行
* idCardPhotos : dizhi1,dizhi2,dizhi3
* sbTxCardPhotos : http1,http2,http3
* zjName : 专家姓名
* zjPhone : 15902490120
* zjCardNum : 211022199712221212
* zjSex : 女孩
* zjCompanyList : [{"zjCompanyName":"专家单位","zjCompanyType":1},{"zjCompanyName":"专家单位2","zjCompanyType":2}]
* majorPhotoBeanList : [{"professionId":"A010101","professionName":"小瑶子","hyPhotos":"lianjie1,lianjie2","zmPhotos":"lianjie1,lianjie2","majorType":0},{"professionId":"b020202","professionName":"小瑶子","hyPhotos":"hhh1","zmPhotos":"ggg2","majorType":1}]
*/
@property (nonatomic, strong) NSString * userGuid;
@property (nonatomic, strong) NSString * zjBankNum;
@property (nonatomic, strong) NSString * zjBankType;
@property (nonatomic, strong) NSString * idCardPhotos;
@property (nonatomic, strong) NSString * sbTxCardPhotos;
@property (nonatomic, strong) NSString * commitmentEle;
@property (nonatomic, strong) NSString * commitmentEleNew;
@property (nonatomic, strong) NSString * zjName;
@property (nonatomic, strong) NSString * zjPhone;
@property (nonatomic, strong) NSString * zjCardNum;
@property (nonatomic, strong) NSString * zjSex;
@property (nonatomic, strong) NSString * source;
@property (nonatomic, strong) NSString *isFormal;
@property (nonatomic, strong) NSString * styleId;
@property (nonatomic, strong) NSString * inDoor;
@property (nonatomic, strong) NSString * pendingmentEleNew; //续聘附件
@property (nonatomic, strong) NSString * alterZy;
@property (nonatomic, strong) NSString * secre;

@property (nonatomic, strong) NSString *professionState;
//


@property (nonatomic, readwrite, copy) NSArray <WY_ZJCompanyModel *> *zjCompanyList;
@property (nonatomic, readwrite, copy) NSArray <WY_ZJCompanyModel *> *jobTitleList;
//专家专业
@property (nonatomic, readwrite, copy) NSArray <WY_MajorPhotoModel *> *majorPhotoBeanList;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *cityCode;
 @end

NS_ASSUME_NONNULL_END
