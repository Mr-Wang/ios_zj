//
//  WY_FilterTreeMain.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_FilterTreeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_FilterTreeMain : UIView
@property (nonatomic, strong) UIControl *bgView;
@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) WY_FilterTreeModel *selModel;
@property (nonatomic, strong) NSMutableArray *arrDataSource;

@property (nonatomic, strong) UIScrollView *mScrollView;

@property (nonatomic,copy) void(^selFilterModelBlock)(WY_FilterTreeModel *ftModel);

- (void)bindView;
- (void)showView;
-(void)hideView;
@end

NS_ASSUME_NONNULL_END
