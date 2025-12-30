//
//  WY_PersonalScoreModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_PersonalScoreModel : MHObject

@property (nonatomic , strong) NSString *  answertime;
@property (nonatomic , strong) NSString *  score;
@property (nonatomic , strong) NSString *  createtime;
@property (nonatomic , strong) NSString *  userGuid;
@property (nonatomic , strong) NSString *  bestscore;
@property (nonatomic , strong) NSString *  count;
@property (nonatomic , strong) NSString *  pass;
@property (nonatomic , strong) NSString *  title;
@property (nonatomic , strong) NSString *  examTime;
@property (nonatomic , strong) NSString *  Realname;
@property (nonatomic , strong) NSString * khmcStr;
@property (nonatomic , strong) NSString * examinfoid;
@property (nonatomic , strong) NSString * examrowguid;
@property (nonatomic , strong) NSString * isface;
@property (nonatomic , strong) NSString * nsDescription;


@end

NS_ASSUME_NONNULL_END
