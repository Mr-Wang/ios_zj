//
//  WY_QuestionOptionModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_QuestionOptionModel : MHObject

/**
 * 选项（A、B、C....）
 */
@property (nonatomic , strong) NSString * optionType;

/**
 * 选项内容
 */
@property (nonatomic , strong) NSString * optionContent;

@property (nonatomic ) BOOL selected;//是否选中
@end

NS_ASSUME_NONNULL_END
