//
//  WY_HomeArticleItemView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/8/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_InfomationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_HomeArticleItemView : UIControl
@property (nonatomic, strong) UIImageView *imgBg;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UILabel *lblDate;
@property (nonatomic, strong) WY_InfomationModel *mWY_InfomationModel;
- (void)showCellByItem:(WY_InfomationModel *)withModel;
@end

NS_ASSUME_NONNULL_END
