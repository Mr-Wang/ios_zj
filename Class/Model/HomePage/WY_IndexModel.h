//
//  WY_IndexModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"
#import "WY_InfomationModel.h"
#import "WY_ReShousListModel.h"
#import "WY_TrainItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_IndexModel : MHObject
@property (nonatomic, readwrite, copy) NSArray <WY_InfomationModel *> *webdbInformationTztgList;
@property (nonatomic, readwrite, copy) NSArray <WY_InfomationModel *> *webdbInformationVideoList;
@property (nonatomic, readwrite, copy) NSArray <WY_ReShousListModel *> *reShousList;

//法律法规
@property (nonatomic, readwrite, copy) NSArray <WY_InfomationModel *> *lawsList;
//政策发布
@property (nonatomic, readwrite, copy) NSArray <WY_InfomationModel *> *policysList;
//在线课程
@property (nonatomic, readwrite, copy) NSArray <WY_TrainItemModel *> *onLineTraCourseList;
//热门课程
@property (nonatomic, readwrite, copy) NSArray <WY_TrainItemModel *> *bestTraCourseList;
@property (nonatomic, readwrite, copy) NSString *isAlert; // = 1的时候 弹出首页提示框
@property (nonatomic, readwrite, copy) NSString *isAutoScroll;   //isAutoScroll=2的时候 停止自动滚动-  其他（为null、0、1）开启自动滚动
@end

NS_ASSUME_NONNULL_END
