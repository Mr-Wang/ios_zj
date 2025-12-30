//
//  WY_FilterTreeItemView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_FilterTreeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_FilterTreeItemView : UIView
@property (nonatomic, strong) UIButton *btnItem;
@property (nonatomic, strong) UIButton *btnZhanKai;
@property (nonatomic, strong) WY_FilterTreeModel *mWY_FilterTreeModel;

@property (nonatomic,copy) void(^selItemBlock)(WY_FilterTreeModel *ftModel);
@property (nonatomic,copy) void(^selOpenOrCloseBlock)(WY_FilterTreeModel *ftModel);

- (void)showCellByItem:(WY_FilterTreeModel *)itemModel;
@end

NS_ASSUME_NONNULL_END
