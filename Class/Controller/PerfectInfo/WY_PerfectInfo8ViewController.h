//
//  WY_PerfectInfo8ViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExpertMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_PerfectInfo8ViewController : UIViewController
@property (nonatomic , strong) WY_ExpertMessageModel *mWY_ExpertMessageModel;
//暂存数据
@property (nonatomic , strong) WY_ExpertMessageModel *mStorageWY_ExpertMessageModel;
@property (nonatomic) int approvalStatusNum;
@property (nonatomic , strong) NSString *jujueContent;
//1是新入库专家 0 是其他
@property (nonatomic, strong) NSString * isNewExpert;
//1是续聘专家 0 是其他
@property (nonatomic, strong) NSString * isRenewalFlag;
/*
 source
 0 内部/测试人员
 1 综合库专家
 2 铁路库专家
 3 地铁库专家
 */
@property (nonatomic,strong) NSString*source;

//1是原来的 2是新的 9是只能添加5个新专业
@property (nonatomic,strong) NSString* jumpToWhere;
//1是新入库专家
@property (nonatomic) int isFormal;
@end

NS_ASSUME_NONNULL_END
