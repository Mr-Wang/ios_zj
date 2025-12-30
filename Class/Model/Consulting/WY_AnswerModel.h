//
//  WY_AnswerModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/27.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_AnswerModel : MHObject
/*    "id": 3,
 "anContent": "哦敏敏",
 "anTime": "2021-04-27 15:32:29",
 "anUser": null,
 "qaId": 4,
 "anRate": null*/
@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *anContent;
@property (nonatomic ,strong) NSString *anTime;
@property (nonatomic ,strong) NSString *qaId;
///评分 1-5
@property (nonatomic ,strong) NSString *anRate;

@end

NS_ASSUME_NONNULL_END
