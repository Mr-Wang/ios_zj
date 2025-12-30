//
//  WY_HomeHotCourseView.h
//  DormitoryManagementPro
//
//  热门课程View
//  Created by 王杨 on 2020/8/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_IndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_HomeHotCourseView : UIView
@property (nonatomic, strong ) UIButton *btnLeft;
@property (nonatomic, strong ) UIButton *btnRight;
@property (nonatomic, strong ) UIView *viewLeft;
@property (nonatomic, strong ) UIView *viewRight;
@property (nonatomic, strong ) UILabel *lblSM;
@property (nonatomic, strong ) UIButton *btnMore;
@property (nonatomic, strong) WY_IndexModel *mWY_IndexModel;
@property (nonatomic,copy) void(^didItemBlock)(WY_TrainItemModel *withModel);
@property (nonatomic,copy) void(^didMoreBlock)(void);

@property (nonatomic,copy) void(^didUpdateHeightBlock)(void);
- (void)showBindView:(WY_IndexModel *)withModel;

@end

NS_ASSUME_NONNULL_END
