//
//  WY_SubmitAlertView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/27.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCircleProgress.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_SubmitAlertView : UIView
@property (nonatomic) int examTime;
@property (nonatomic) int answeredNum;
@property (nonatomic) int countNum;

@property (nonatomic ,strong) UIView *viewAlert;
@property (nonatomic ,strong) UILabel *lblTitle;
@property (nonatomic ,strong) UILabel *lblExamTime;
@property (nonatomic ,strong) UIButton *btnCancel;
@property (nonatomic ,strong) UIButton *btnNow;
@property (nonatomic ,strong) ZZCircleProgress *progressView;
@property (nonatomic ,strong)  NSTimer *mNSTimer;

@property (nonatomic,copy) void(^submitBlock)(void);

/// 显示alert
/// @param withExamTime 剩余时间
/// @param withCountNum 总题数
/// @param withAnsweredNum 已答题数
- (void)showViewByExamTime:(int)withExamTime byCountNum:(int)withCountNum withAnsweredNum:(int)withAnsweredNum;
@end

NS_ASSUME_NONNULL_END
