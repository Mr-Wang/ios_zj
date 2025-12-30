//
//  WY_PerfectInfoViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_PerfectInfoViewController : UIViewController
@property (nonatomic) int approvalStatusNum;
//1是原来的 2是新的 9是只能添加5个新专业，10是有老专业的专家-只能增加新专业，不可修改老专业； 8是最新的-可以通过接口字段控制增删改新老专业- 单个专业增加审核是否通过字段，
@property (nonatomic,strong) NSString* jumpToWhere;
@property (nonatomic,strong) NSString*source;
@property (nonatomic , strong) NSString *jujueContent;
@property (nonatomic) int isFormal;
//1是续聘专家 0 是其他
@property (nonatomic, strong) NSString * isRenewalFlag;


@end

NS_ASSUME_NONNULL_END
