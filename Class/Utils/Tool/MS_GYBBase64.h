//
//  MS_GYBBase64.h
//  TestDes
//
//  Created by 古玉彬 on 16/4/20.
//  Copyright © 2016年 ms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MS_GYBBase64 : NSObject

+(NSString *)encode:(NSData *)data;
+(NSData *)decode:(NSString *)dataString;

/**
 *  字符串转16进制字符
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSData *)hexDataFromStr:(NSString *)str;

/**
 *  二进制转16进制字符串
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)ToHexStrWithBinData:(NSData *)data;
@end
