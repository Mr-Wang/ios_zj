//
//  WY_TrainModel.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/10.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_TrainModel.h"

@implementation WY_TrainModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"nsnewTraCourseList"        : [WY_TrainItemModel class],
             @"bestTraCourseList"    : [WY_TrainItemModel class],
             @"askTraCourseList"    : [WY_TrainItemModel class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    NSDictionary *dic=@{@"nsnewTraCourseList" :@"newTraCourseList"};
    return dic;
}


@end
