//
//  LicensePlateTextField.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/9/3.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LicensePlateTextField : UIView
/** 省'辽' */
@property (nonatomic, strong)  UIButton *btnS;
/** 市'A' */
@property (nonatomic, strong)  UIButton *btnA;
/** 1 */
@property (nonatomic, strong)  UIButton *btn1;
/** 1 */
@property (nonatomic, strong)  UIButton *btn2;
/** 1 */
@property (nonatomic, strong)  UIButton *btn3;
/** 1 */
@property (nonatomic, strong)  UIButton *btn4;
/** 1 */
@property (nonatomic, strong)  UIButton *btn5;
/** 新能源 */
@property (nonatomic, strong)  UIButton *btnXin;

//添加
- (void)addKeysStr:(NSString *)keyStr;
//清除
- (void)clearKeys;
- (NSString *)extractLicensePlate;

@property (nonatomic,copy) void(^selectedButtonAndVerificationBlock)(NSInteger buttonIndex,BOOL isVerification);
@end

NS_ASSUME_NONNULL_END
