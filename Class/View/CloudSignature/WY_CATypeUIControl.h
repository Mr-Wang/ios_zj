//
//  WY_CATypeUIControl.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/20.
//  Copyright © 2022 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_CATypeUIControl : UIControl
//CA状态
@property (nonatomic ,strong) UIImageView *imgStatus;
//选中状态
@property (nonatomic ,strong) UIImageView *imgSel;
//显示图片
@property (nonatomic ,strong) UIImageView *imgInfo;
//显示图片
@property (nonatomic ,strong) UILabel *lblInfo;

//CA状态  0 无 1已办理 2 已过期
@property (nonatomic ) int caStatus;
//图片地址
@property (nonatomic ,strong) NSString *imgUrl;
//图片地址选中状态
@property (nonatomic ,strong) NSString *imgUrl_Sel;
//文字
@property (nonatomic ,strong) NSString *caTitle;

- (void)updateViewStatus;

@end

NS_ASSUME_NONNULL_END
