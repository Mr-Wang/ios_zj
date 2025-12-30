//
//  WY_HomeArticleView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/8/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_IndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_HomeArticleView : UIView
@property (nonatomic, strong) UIView *viewItems;

@property (nonatomic, strong ) UIButton *btnMore;
@property (nonatomic, strong) WY_IndexModel *mWY_IndexModel;
@property (nonatomic,copy) void(^didItemBlock)(WY_InfomationModel *withModel);
@property (nonatomic,copy) void(^didMoreBlock)(void);
- (void)showBindView:(WY_IndexModel *)withModel;

@end

NS_ASSUME_NONNULL_END
