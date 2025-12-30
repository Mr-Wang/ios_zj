//
//  WY_PickerCity.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "STPickerView.h"

NS_ASSUME_NONNULL_BEGIN
@class WY_PickerCity;
@protocol  WYPickerCityDelegate<NSObject>

- (void)pickerArea:(WY_PickerCity *)pickerArea province:(NSDictionary *)province city:(NSDictionary *)city;

@end
@interface WY_PickerCity : STPickerView
/** 1.中间选择框的高度，default is 32*/
@property(nonatomic, assign)CGFloat heightPickerComponent;
/** 2.保存之前的选择地址，default is NO */
@property(nonatomic, assign, getter=isSaveHistory)BOOL saveHistory;

@property(nonatomic, weak)id <WYPickerCityDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
