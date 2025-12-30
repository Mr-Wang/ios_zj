//
//  WY_YNTextField.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/11/19.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WY_YNTextField;
@protocol WY_YNTextFieldDelegate <NSObject>
- (void)WY_YNTextFieldDeleteBackward:(WY_YNTextField *)textField;
@end


@interface WY_YNTextField : UITextField
@property (nonatomic, assign) id <WY_YNTextFieldDelegate> yn_delegate;
- (NSRange) selectedRange;
@end

NS_ASSUME_NONNULL_END
