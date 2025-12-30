//
//  UIView+WY_Badge.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2023/1/4.
//  Copyright © 2023 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WY_Badge)

/**
 *  通过创建label，显示小红点；
 */
@property (nonatomic, strong) UILabel *badge;

/**
 *  显示小红点
 *  @magin 小红点距离控件上方距离
 */
- (void)showBadgeWithTopMagin:(CGFloat)magin;


/**
 *  隐藏小红点
 */
- (void)hidenBadge;

 
@end

NS_ASSUME_NONNULL_END
