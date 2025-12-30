//
//  WY_PrivacyWindowView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/6/17.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_PrivacyWindowView : UIView
@property (nonatomic, strong) UILabel *lblTitle;
//初始内容
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIButton *btnStart;
@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic , assign) BOOL isSelected;/* 是否同意用户协议 */
/// 用户协议View
@property (nonatomic, strong) UIView *viewUserAgr;
/// 选中未选中用户协议图片
@property (nonatomic, strong) UIImageView *selectedImg;

/// 注册协议选中按钮
@property (nonatomic, strong) UIButton *selectedBtn;

/// 用户协议
@property (nonatomic, strong) UILabel *userAgrLab;

/// 用户协议按钮
@property (nonatomic, strong) UIButton *userAgrBtn;

//点击了同意按钮
@property (nonatomic,copy) void(^didStartBtnAction)(void);
//点击了不同意按钮
@property (nonatomic,copy) void(^didCloseBtnAction)(void);

//点击了隐私协议按钮
@property (nonatomic,copy) void(^didPrivacyAgreementBtnAction)(void);
//点击了用户协议按钮
@property (nonatomic,copy) void(^didUserAgreementBtnAction)(void);



@end

NS_ASSUME_NONNULL_END
