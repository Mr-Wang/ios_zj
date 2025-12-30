//
//  WY_TrainModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/10.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_TrainItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_TrainModel : MHObject

@property (nonatomic, readwrite, copy) NSArray <WY_TrainItemModel *> *nsnewTraCourseList;
@property (nonatomic, readwrite, copy) NSArray <WY_TrainItemModel *> *bestTraCourseList;
@property (nonatomic, readwrite, copy) NSArray <WY_TrainItemModel *> *askTraCourseList;

@end

NS_ASSUME_NONNULL_END
