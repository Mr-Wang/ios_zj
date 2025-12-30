//
//  WY_InfoConsuItingViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/25.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_AExpertQuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_InfoConsuItingViewController : UIViewController
@property (nonatomic, strong) WY_AExpertQuestionModel *eqModel;
@property (nonatomic, strong) NSString * nsType; //1是查看我的， 2是管理查看别人的；

@property (nonatomic, strong)NSMutableArray *zhuanYeArr;
@property (nonatomic, strong) UIView *viewZhuanYe;
@end

NS_ASSUME_NONNULL_END
