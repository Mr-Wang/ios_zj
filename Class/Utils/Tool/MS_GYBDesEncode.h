//
//  MS_GYBDesEncode.h
//  chetizi
//
//  Created by 古玉彬 on 16/4/20.
//  Copyright © 2016年 msl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MS_GYBDesEncode : NSObject

/**
 *  加密
 *
 *  @param dataString <#dataString description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)encodeStr:(NSString *)dataString;

/**
 *  解密
 *
 *  @param dataString <#dataString description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)decodeStr:(NSString *)dataString;
@end
