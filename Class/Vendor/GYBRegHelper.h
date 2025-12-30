//
//  GYBRegHelper.h
//  homework09_19
//
//  Created by 古玉彬 on 15/9/19.
//  Copyright (c) 2015年 guyubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYBRegHelper : NSString

/**
 *  返回符合条件的字符串数组
 *
 *  @param str     需要匹配的字符串
 *  @param pattern 正则表达式
 *
 *  @return 符合条件字符串数组
 */
+ (NSArray *)regHelper:(NSString *)str andPattern:(NSString *)pattern;

/**
 *  替换符合条件的字符串
 *
 *  @param givenStr     当前字符串
 *  @param newStr  需要替换的字符串
 *  @param pattern 正则表达式
 *
 *  @return 替换为newstr的字符串
 */
+ (NSString *)replaceGivenStr:(NSString *)givenStr withStr:(NSString *)newStr withPattern:(NSString *)pattern;

/**
 *  是否匹配成功
 *
 *  @param pattern <#pattern description#>
 *  @param string  <#string description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)stringIsMatchPattern:(NSString * )pattern string:(NSString *)string;
@end
