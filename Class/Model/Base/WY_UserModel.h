//
//  WY_UserModel.h
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHObject.h"
#import "WY_MStudentModel.h"
#import "WY_CityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_UserModel : MHObject
@property (nonatomic, readwrite, copy) NSArray <WY_MStudentModel *> *list;

//网联学习
@property (nonatomic, readwrite, copy) NSString * id;
@property (nonatomic, readwrite, copy) NSString * loginTime;
@property (nonatomic, readwrite, copy) NSString * loginNum;
@property (nonatomic, readwrite, copy) NSString * sbrUnitguid;
@property (nonatomic, readwrite, copy) NSString * sbrName;
@property (nonatomic, readwrite, copy) NSString * sbrCode;
@property (nonatomic, readwrite, copy) NSString * sbrUnitname;
@property (nonatomic, readwrite, copy) NSString * sbrDate;
@property (nonatomic, readwrite, copy) NSString * sbrTel;
@property (nonatomic, readwrite, copy) NSString * sbrMoblie;
@property (nonatomic, readwrite, copy) NSString * shrCode;
@property (nonatomic, readwrite, copy) NSString * shrName;
@property (nonatomic, readwrite, copy) NSString * shrDate;
@property (nonatomic, readwrite, copy) NSString * dogsenderCode;
@property (nonatomic, readwrite, copy) NSString * dogsenderName;
@property (nonatomic, readwrite, copy) NSString * dogsenderDate;
@property (nonatomic, readwrite, copy) NSString * createrName;
@property (nonatomic, readwrite, copy) NSString * createrCode;
@property (nonatomic, readwrite, copy) NSString * yxq;
@property (nonatomic, readwrite, copy) NSString * orgDanWeiGuid;
@property (nonatomic, readwrite, copy) NSString * createrDate;
@property (nonatomic, readwrite, copy) NSString * rowId;
@property (nonatomic, readwrite, copy) NSString * orgnum;
@property (nonatomic, readwrite, copy) NSString * faren;
@property (nonatomic, readwrite, copy) NSString * zhuceziben;
@property (nonatomic, readwrite, copy) NSString * lianxiren;
@property (nonatomic, readwrite, copy) NSString * lianxiphone;
@property (nonatomic, readwrite, copy) NSString * fax;
@property (nonatomic, readwrite, copy) NSString * address;
@property (nonatomic, readwrite, copy) NSString * baomingidcard;
@property (nonatomic, readwrite, copy) NSString * authorizationLetterUrl;
@property (nonatomic, readwrite, copy) NSString * commitmentLetterUrl;
@property (nonatomic, readwrite, copy) NSString * idcardAUrl;
@property (nonatomic, readwrite, copy) NSString * idcardBUrl;
@property (nonatomic, readwrite, copy) NSString * danweizhengUrl;
@property (nonatomic, readwrite, copy) NSString * postalcode;
@property (nonatomic, readwrite, copy) NSString * processcode;
@property (nonatomic, readwrite, copy) NSString * processguid;
@property (nonatomic, readwrite, copy) NSString * isaudit;
@property (nonatomic, readwrite, copy) NSString * idcardnum;
@property (nonatomic, readwrite, copy) NSString * unitbankname;
@property (nonatomic, readwrite, copy) NSString * unitbankcode;
@property (nonatomic, readwrite, copy) NSString * token;
@property (nonatomic, readwrite, copy) NSString * oldPassword;
@property (nonatomic, readwrite, copy) NSString * nsnewPassword;
@property (nonatomic, readwrite, copy) NSString * yzm;
@property (nonatomic, readwrite, copy) NSString * yhdh;
@property (nonatomic, readwrite, copy) NSString * weixin;
@property (nonatomic, readwrite, copy) NSString * catype;
@property (nonatomic, readwrite, copy) NSString * cadueDate;
@property (nonatomic, readwrite, copy) NSString * caapplyDate;
@property (nonatomic, readwrite, copy) NSString * epapplyDate;
@property (nonatomic, readwrite, copy) NSString * epdueDate;
@property (nonatomic, readwrite, copy) NSString * adduration;
@property (nonatomic, readwrite, copy) NSString * adapplyDate;
@property (nonatomic, readwrite, copy) NSString * addueDate;
@property (nonatomic, readwrite, copy) NSString * vipapplyDate;
@property (nonatomic, readwrite, copy) NSString * vipdueDate;
@property (nonatomic, readwrite, copy) NSString * viptype;
@property (nonatomic, readwrite, copy) NSString * viplevel;
@property (nonatomic, readwrite, copy) NSString * avatarPath;
@property (nonatomic, readwrite, copy) NSString * type_name;
@property (nonatomic, readwrite, copy) NSString * lsh;
@property (nonatomic, readwrite, copy) NSString * adposition;
@property (nonatomic, readwrite, copy) NSString * loginType;
@property (nonatomic, readwrite, copy) NSString * enterpriseKeyID;
@property (nonatomic, readwrite, copy) NSString * spAddress;
@property (nonatomic, readwrite, copy) NSString * title;
@property (nonatomic, readwrite, copy) NSString * content;
@property (nonatomic, readwrite, copy) NSString * bxContent;
@property (nonatomic, readwrite, copy) NSString * createtime;
@property (nonatomic, readwrite, copy) NSString * zanType;
@property (nonatomic, readwrite, copy) NSString * bxZanType;
@property (nonatomic, readwrite, copy) NSString * scType;
@property (nonatomic, readwrite, copy) NSString * nicheng;
@property (nonatomic, readwrite, copy) NSString * zanNum;
@property (nonatomic, readwrite, copy) NSString * dzUserGuid;
@property (nonatomic, readwrite, copy) NSString * pllsh;
@property (nonatomic, readwrite, copy) NSString * chatid;
@property (nonatomic, readwrite, copy) NSString * uuid;
@property (nonatomic, readwrite, copy) NSString * type;
@property (nonatomic, readwrite, copy) NSString * adminName;
@property (nonatomic, readwrite, copy) NSString * adminPhone;
@property (nonatomic, readwrite, copy) NSString * realname;
@property (nonatomic, readwrite, copy) NSString * realPwd;
@property (nonatomic, readwrite, copy) NSString * DisplayName;
@property (nonatomic, readwrite, copy) NSString * UserGuid;
@property (nonatomic, readwrite, copy) NSString * UserName;
@property (nonatomic, readwrite, copy) NSString * CAName;
@property (nonatomic, readwrite, copy) NSString * StatusCode;
@property (nonatomic, readwrite, copy) NSString * DanWeiGuid;
@property (nonatomic, readwrite, copy) NSString * DanWeiName;
@property (nonatomic, readwrite, copy) NSString * UserType;
@property (nonatomic, readwrite, copy) NSString * RowGuid;
@property (nonatomic, readwrite, copy) NSString * AuditStatus;
@property (nonatomic, readwrite, copy) NSString * MobilePhone;
@property (nonatomic, readwrite, copy) NSString * EMail;
@property (nonatomic, readwrite, copy) NSString * Sex;
@property (nonatomic, readwrite, copy) NSString * DeviceNum;
@property (nonatomic, readwrite, copy) NSString * Mobile;
@property (nonatomic, readwrite, copy) NSString * ClassGuid;
@property (nonatomic, readwrite, copy) NSString * LoginID;
@property (nonatomic, readwrite, copy) NSString * PassWD;
@property (nonatomic, readwrite, copy) NSString * Major;
@property (nonatomic, readwrite, copy) NSString * DeviceNum1;
@property (nonatomic, readwrite, copy) NSString * DogNum;
@property (nonatomic, readwrite, copy) NSString * IsAgaIn;
@property (nonatomic, readwrite, copy) NSString * ComZip;
@property (nonatomic, readwrite, copy) NSString * VisiteNo;
@property (nonatomic, readwrite, copy) NSString * OtherWay;
@property (nonatomic, readwrite, copy) NSString * ComAddress;
@property (nonatomic, readwrite, copy) NSString * CompanyPhone;
@property (nonatomic, readwrite, copy) NSString * WebRights;
@property (nonatomic, readwrite, copy) NSString * SignCertCN;
@property (nonatomic, readwrite, copy) NSString * OperateDate;
@property (nonatomic, readwrite, copy) NSString * UserCode;
@property (nonatomic, readwrite, copy) NSString * GraduateDate;
@property (nonatomic, readwrite, copy) NSString * ZiGeZhengNum;
@property (nonatomic, readwrite, copy) NSString * CreateType;
@property (nonatomic, readwrite, copy) NSString * BirthDay;
@property (nonatomic, readwrite, copy) NSString * JiaoNaMoney;
@property (nonatomic, readwrite, copy) NSString * ReMark;
@property (nonatomic, readwrite, copy) NSString * DogType;
@property (nonatomic, readwrite, copy) NSString * ShowAnswer;
@property (nonatomic, readwrite, copy) NSString * IsInfoAdmin;
@property (nonatomic, readwrite, copy) NSString * IDCard;
@property (nonatomic, readwrite, copy) NSString * XiaQuName;
@property (nonatomic, readwrite, copy) NSString * SignCert;
@property (nonatomic, readwrite, copy) NSString * EncCert;
@property (nonatomic, readwrite, copy) NSString * WorkTime;
@property (nonatomic, readwrite, copy) NSString * ShowQuestion;
@property (nonatomic, readwrite, copy) NSString * XueZhi;
@property (nonatomic, readwrite, copy) NSString * ZhiCheng;
@property (nonatomic, readwrite, copy) NSString * IsMessageUser;
@property (nonatomic, readwrite, copy) NSString * YearFlag;
@property (nonatomic, readwrite, copy) NSString * XiaQuCode;
@property (nonatomic, readwrite, copy) NSString * JiaoYanNo;
@property (nonatomic, readwrite, copy) NSString * OUGuid;
@property (nonatomic, readwrite, copy) NSString * CertYouXiaoQi;
@property (nonatomic, readwrite, copy) NSString * PayNoGuid;
@property (nonatomic, readwrite, copy) NSString * IsFreeChange;
@property (nonatomic, readwrite, copy) NSString * IsMainAccount;
@property (nonatomic, readwrite, copy) NSString * BiaoShuDogNum;
@property (nonatomic, readwrite, copy) NSString * ZhengShuType;
@property (nonatomic, readwrite, copy) NSString * BelongXiaQuCode;
@property (nonatomic, readwrite, copy) NSString * EncryptionDogNum;
@property (nonatomic, readwrite, copy) NSString * ParentUserGuid;
@property (nonatomic, readwrite, copy) NSString * GraduateSchool;
@property (nonatomic, readwrite, copy) NSString * ZiGeZhengZhuanYe;
@property (nonatomic, readwrite, copy) NSString * OperateUserName;
@property (nonatomic, readwrite, copy) NSString * CertSubjectKeyID;
@property (nonatomic, readwrite, copy) NSString * name;
@property (nonatomic, readwrite, copy) NSString * idcard;
@property (nonatomic, readwrite, copy) NSString * orgtype;
@property (nonatomic, readwrite, copy) NSString * yzStatus;

@property (nonatomic, readwrite, copy) NSString *ischeck;//1已认证成功，0未认证



@property (nonatomic, readwrite, copy) NSString *yhname;
@property (nonatomic, readwrite, copy) NSString *key;
@property (nonatomic, readwrite, copy) NSString *userid;
@property (nonatomic, readwrite, copy) NSString *sfzzm;
@property (nonatomic, readwrite, copy) NSString *sfzfm;

@property (nonatomic, readwrite, copy) NSString *partyMember;   //是否是党员 0不是 1是
@property (nonatomic, readwrite, copy) NSString *userSignature;     //签字地址
@property (nonatomic, readwrite, copy) NSString *city;
@property (nonatomic, readwrite, copy) NSString *cityCode;
//城市列表
@property (nonatomic, readwrite, copy) NSArray <WY_CityModel *> *cityList;


 @end
NS_ASSUME_NONNULL_END
