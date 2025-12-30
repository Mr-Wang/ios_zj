//
//  WY_QuestionOptionView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_QuestionOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuestionOptionView : UIControl
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) WY_QuestionOptionModel *mWY_QuestionOptionModel;
- (void)showCellByItem:(WY_QuestionOptionModel*)withWY_QuestionOptionModel;
- (void)showReViewCellByStr :(NSString *)withStr;
- (void)showPDTCellByItem:(WY_QuestionOptionModel*)withWY_QuestionOptionModel;
@end

NS_ASSUME_NONNULL_END
