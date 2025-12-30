//
//  MS_CommonTools.m
//  MET
//
//  Created by Mrxiaowu on 16/4/5.
//  Copyright © 2016年 zheng. All rights reserved.
//

#import "MS_CommonTools.h"
#import "NSDate+Info.h"
@implementation MS_CommonTools
//计算朋友圈时间显示样式
+ (NSString *)timeWithCreattime:(NSString *)createtime{
    
    
    NSDate *send = [NSDate dateWithTimeIntervalSince1970:[createtime doubleValue]];
   
    return [self timeWithDate:send];
}


+ (NSString *)timeWithDate:(NSDate *)currentDate {
    // 1.获得发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
    // 2.当前时间
    NSDate *now = [NSDate date];
    // 3.获得当前时间和发送时间 的 间隔  (now - send)
    NSString *timeStr = nil;
    NSTimeInterval delta = [now timeIntervalSinceDate:currentDate];
    if ([currentDate isThisYear]) {
        if (delta < 60) { // 一分钟内
            timeStr = @"刚刚";
        } else if (delta < 60 * 60) { // 一个小时内
            timeStr = [NSString stringWithFormat:@"%.f分钟前", delta/60];
        } else if (delta < 60 * 60 * 24) { // 一天内
            timeStr = [NSString stringWithFormat:@"%.f小时前", delta/60/60];
        }else if ((60 * 60 * 48 > delta) && (delta > 60 * 60 * 24)) { //  48h>昨天>24h
            fmt.dateFormat = @"HH:mm";
            timeStr = [NSString stringWithFormat:@"昨天 %@", [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:delta]]];
        }else { //  今年
            fmt.dateFormat = @"MM月dd日 HH:mm";
            timeStr = [fmt stringFromDate:currentDate];
        }
        return timeStr;
    }else{
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        timeStr = [fmt stringFromDate:currentDate];
        return timeStr;
    }

}


+ (NSString *)timeWithTimeInterval:(NSTimeInterval)timestamp {
    
    NSDate *send = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
    return [self timeWithDate:send];

    
}


+ (NSString *)timeWithDateStr:(NSString *)dateStr {
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [self timeWithDate:[fmt dateFromString:dateStr]];
    
}

//字符串拆分成数组
+(NSArray *)componentsSeparatedByString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@","];
    return array;
}


+ (NSString *)creatTime:(NSString *)time{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString  *date = [formatter stringFromDate:detaildate];
    
    NSLog(@"date1:%@",date);
    
    return date;
}


+ (NSString *)creatTimeTwo:(NSString *)time{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString  *date = [formatter stringFromDate:detaildate];
    
    NSLog(@"date1:%@",date);
    
    return date;
}


+ (NSString *)timeCreatTimeTwo:(NSString *)time{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    NSString  *date = [formatter stringFromDate:detaildate];
    
    NSLog(@"date1:%@",date);
    
    return date;
}


+ (NSString *)timeStrTwotime:(NSString *)str{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
     [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    NSDate *date =[dateFormat dateFromString:str];
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
//    return [NSString stringWithFormat:@"%ld",(long)timeSp];
    return [MS_CommonTools creatTime:[NSString stringWithFormat:@"%ld",(long)timeSp]];
    
}

@end
