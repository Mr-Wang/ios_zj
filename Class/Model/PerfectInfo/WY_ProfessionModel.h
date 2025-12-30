//
//  WY_ProfessionModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/17.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ProfessionModel : MHObject
/*"id": null,
"code": "A040101",
"name": "建筑总平面规划",
"pcode": "A0401",
"level": "3",
"fenlei": null,
"description": null*/

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pcode;
@property (nonatomic, strong) NSString *level;

@end

NS_ASSUME_NONNULL_END
