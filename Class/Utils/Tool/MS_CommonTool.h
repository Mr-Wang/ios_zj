//
//  MS_CommonTool.h
//  WanZhu
//
//  Created by 古玉彬 on 16/7/13.
//  Copyright © 2016年 ms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYText/YYText.h>

@interface MS_CommonTool : NSObject
/**
 *  带点击事件的文本
 *
 *  @param conentStr       内容
 *  @param highLightString 可点击内容
 *  @param font            字体大小
 *
 *  @return <#return value description#>
 */
+ (NSMutableAttributedString *)invitationString:(NSString *)conentStr highLightString:(NSString *)highLightString font:(UIFont *)font hightLightColor:(UIColor *)highLightColor;


/**
 *  带IP的图片地址
 *
 *  @param url <#url description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)containIpImageStr:(NSString *)url;

/**
 *  带IP的图片数组
 *
 *  @param imageArr <#imageArr description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)containIpImageArr:(NSString *)url;

/**
 *  时间戳转换为时间
 *
 *  @param stamp        <#stamp description#>
 *  @param formatString 若为nil 默认 @"yyyy-MM-dd  HH:mm"
 *
 *  @return <#return value description#>
 */
+ (NSString *)formatTimestamp:(NSTimeInterval)stamp formatString:(NSString *)formatString;


/**
 *  返回今日日期
 *
 *  @return <#return value description#>
 */
+ (NSString *)todayStr;

/**
 *  获取现在到明天凌晨的时间差
 *
 *  @return <#return value description#>
 */
+ (NSTimeInterval)nowDateToNextDate;

/**
 *  过滤html标签
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)clearHtmlStr:(NSString *)str;
/**
 *  获取文本高度
 *
 *  @param font  <#font description#>
 *  @param text  <#text description#>
 *  @param width <#width description#>
 *
 *  @return <#return value description#>
 */
+ (CGFloat)heightForLabel:(UIFont *)font text:(NSString *)text width:(CGFloat)width;

//控件截图
+ (UIImage *)snapshot:(UIView *)view;
//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*) filePath;
//遍历文件夹获得文件夹大小，返回多少M
+ (float )folderSizeAtPath:(NSString*) folderPath;
//删除文件
+ (void)removeFileByPath:(NSString *)filePath;

/**
 *  加密字典
 *
 *  @param dic <#dic description#>
 *
 *  @return 加密和的字符串
 */
+ (NSDictionary *)decodeByDic:(NSDictionary *)dic;



/**
 图片拼接IP地址
 
 @param url <#url description#>
 @return <#return value description#>
 */
+ (NSString *)componentUrl:(NSString *)url;


/**
 判断地址是否包含http
 @param url <#url description#>
 @return <#return value description#>
 */
+ (BOOL)compareIsHttp:(NSString *)url;

//字典根据key排序
+(NSString *)getNeedSignStrFrom:(id)obj;

@end
