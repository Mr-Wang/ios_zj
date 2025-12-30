//
//  WY_GuestBookModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_GuestBookModel : MHObject
@property (nonatomic , strong) NSString *id;
@property (nonatomic , strong) NSString *classGuid;
@property (nonatomic , strong) NSString *title;
@property (nonatomic , strong) NSString *content;
@property (nonatomic , strong) NSString *pxxx;
@property (nonatomic , strong) NSString *idcardnum;
@property (nonatomic , strong) NSString *createtime;
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *danWeiName;
@property (nonatomic , strong) NSString *phone;
@property (nonatomic , strong) NSString *userCreateTime;
@property (nonatomic , strong) NSString *pxbs;
@end

NS_ASSUME_NONNULL_END
