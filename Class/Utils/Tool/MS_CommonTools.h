//
//  MS_CommonTools.h
//  MET
//
//  Created by Mrxiaowu on 16/4/5.
//  Copyright © 2016年 zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MS_CommonTools : NSObject
+ (NSString *)timeWithCreattime:(NSString *)createtime;


+ (NSString *)timeWithTimeInterval:(NSTimeInterval)timestamp;


+ (NSString *)timeWithDateStr:(NSString *)dateStr;

+(NSArray *)componentsSeparatedByString:(NSString *)string;

//年月日
+ (NSString *)creatTime:(NSString *)time;

+ (NSString *)creatTimeTwo:(NSString *)time;

+ (NSString *)timeCreatTimeTwo:(NSString *)time;

//时间 转时间戳  @“2017-04-20 16:06:31” -->23443535
+ (NSString *)timeStrTwotime:(NSString *)str;

@end
