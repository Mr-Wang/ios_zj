//
//  WY_QuizReviewItemView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/27.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_QuestionTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuizReviewItemView : UIView
@property (nonatomic, strong) WY_QuestionTypeModel *mWY_QuestionTypeModel;
@property (nonatomic, strong) UIControl *colTitle;
@property (nonatomic, strong) UILabel *lblTypeStr;
@property (nonatomic, strong) UIImageView *imgAcc;
@property (nonatomic, strong) UIView *viewContent;
- (void)showCellByItem:(WY_QuestionTypeModel *)withModel;

@property (nonatomic,copy) void(^selTopicModelBlock)(WY_QuestionModel * withModel);


@end

NS_ASSUME_NONNULL_END
