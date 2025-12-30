//
//  WY_QuizViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_QuizModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuizViewController : UIViewController
@property (nonatomic) NSInteger currentSelIndex;
@property (nonatomic, strong) WY_QuizModel *mWY_QuizModel;
@property (nonatomic, strong) WY_QuestionModel *mQmIdenxModel;
@property (nonatomic) BOOL isReview;
@property (nonatomic, strong) NSString * examInfoId;
@property (nonatomic, strong) NSString *nsType;//1自测、2正式；
@property (nonatomic,copy) void(^submitQuizBlock)(void);
@end

NS_ASSUME_NONNULL_END
