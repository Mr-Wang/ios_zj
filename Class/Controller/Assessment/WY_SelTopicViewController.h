//
//  WY_SelTopicViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_QuizModel.h"
#import <HWPanModal/HWPanModal.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_SelTopicViewController : UIViewController<HWPanModalPresentable>
@property (nonatomic, strong) WY_QuizModel *mWY_QuizModel;
@property (nonatomic) NSInteger currentSelIndex;
@property (nonatomic,copy) void(^selTopicBlock)(NSInteger withIndex);

@end

NS_ASSUME_NONNULL_END
