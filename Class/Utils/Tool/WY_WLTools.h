//
//  WY_WLTools.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_WLTools : NSObject
+ (NSString *)categoryStringByNum:(NSString *)numStr;
+ (NSString *)categoryImgStringByNum:(NSString *)numStr;
+ (NSString *)categorySyImgStringByNum:(NSString *)numStr;
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;
+ (NSDictionary *)zjDicGetById:(int)dicID;
@end

NS_ASSUME_NONNULL_END
