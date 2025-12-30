//
//  LicensePlateAkeyView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/9/3.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LicensePlateAkeyView : UIView
//定义枚举类型
typedef enum _LicensePlatekeyType {
    lpkProvince  = 0,
    lpkNumber,
} LicensePlatekeyType;

//指明枚举类型
//-------in parameters---------------
@property (nonatomic,assign) LicensePlatekeyType lpkType; //操作类型
/** btnSubmit */
@property (nonatomic, strong)  UIButton *btnSubmit;
/** arr */
@property (nonatomic, strong)  NSMutableArray *arrStr;/* 产品名称 */

- (void)initViewKeysBy:(LicensePlatekeyType)keysType;
@property (nonatomic,copy) void(^selectedKeyBlock)(NSString *keyStr);
@property (nonatomic,copy) void(^clearBlock)(void);
@property (nonatomic,copy) void(^btnSubmitBlock)(void);



@end

NS_ASSUME_NONNULL_END
