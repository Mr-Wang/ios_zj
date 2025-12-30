//
//  WY_RankModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_RankModel : MHObject
@property (nonatomic , strong) NSString *  answertime;
@property (nonatomic , strong) NSString *  score;
@property (nonatomic , strong) NSString *  createtime;
@property (nonatomic , strong) NSString *  userGuid;
@property (nonatomic , strong) NSString *  bestscore;
@property (nonatomic , strong) NSString *  count;
@property (nonatomic , strong) NSString *  rank;
@property (nonatomic , strong) NSString *  username;
@end

NS_ASSUME_NONNULL_END
