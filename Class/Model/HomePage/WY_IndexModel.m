//
//  WY_IndexModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_IndexModel.h"

@implementation WY_IndexModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"webdbInformationTztgList"        : [WY_InfomationModel class],
             @"webdbInformationVideoList"    : [WY_InfomationModel class],
             @"reShousList"    : [WY_ReShousListModel class],
             @"lawsList"    : [WY_InfomationModel class],
             @"policysList"    : [WY_InfomationModel class],
             @"onLineTraCourseList"    : [WY_TrainItemModel class],
             @"bestTraCourseList"    : [WY_TrainItemModel class]
             
             };
}
@end
