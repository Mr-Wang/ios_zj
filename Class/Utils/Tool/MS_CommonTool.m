//
//  MS_CommonTool.m
//  WanZhu
//
//  Created by 古玉彬 on 16/7/13.
//  Copyright © 2016年 ms. All rights reserved.
//

#import "MS_CommonTool.h"
#import "MS_CommonTools.h"
#import "GYBRegHelper.h"
#import "MS_GYBDesEncode.h"



@implementation MS_CommonTool

+ (NSMutableAttributedString *)invitationString:(NSString *)conentStr highLightString:(NSString *)highLightString font:(UIFont *)font hightLightColor:(UIColor *)highLightColor {
    
    if (!highLightString) {
        highLightString = @"";
    }
    else{
        highLightString = [NSString stringWithFormat:@"#%@#",highLightString];
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",highLightString,conentStr]];

    YYTextHighlight *highlight = [YYTextHighlight new];
    
    if (highLightString.length) {
        
        [attributedText yy_setTextHighlight:highlight range:NSMakeRange(0, highLightString.length)];
        
        [attributedText yy_setColor:highLightColor range:NSMakeRange(0, highLightString.length)];
    }
    
    [attributedText yy_setFont:font range:NSMakeRange(0, attributedText.length)];
    
    
    return attributedText;
}

+ (NSString *)containIpImageStr:(NSString *)url {
    
    return [[[NSString stringWithFormat:@"%@",[[url componentsSeparatedByString:@","] firstObject]] componentsSeparatedByString:@"*"] firstObject];
}


+ (NSArray *)containIpImageArr:(NSString *)url {
    
    NSMutableArray * picArr = [@[] mutableCopy];
    for (NSString * picStr in [url componentsSeparatedByString:@","]) {
        
        [picArr addObject:[[[NSString stringWithFormat:@"%@",picStr] componentsSeparatedByString:@"*"] firstObject]];
    }
    
    return [picArr copy];

}

+ (NSString *)formatTimestamp:(NSTimeInterval)stamp formatString:(NSString *)formatString {
    
    

    if (!formatString) {
        
        return [MS_CommonTools timeWithTimeInterval:stamp];
        
    }
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:stamp / 1000];
    NSDateFormatter * formatter = [NSDateFormatter new];
    
    if (!formatString) {
        formatString = @"yyyy-MM-dd HH:mm";
    } 
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    [formatter setDateFormat:formatString];
    
    
    return  [formatter stringFromDate:confromTimesp];
}

+ (NSString *)todayStr {
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    return [formatter stringFromDate:date];
    
    
}


+ (NSString *)clearHtmlStr:(NSString *)str {
    
    NSString * resultStr = [GYBRegHelper replaceGivenStr:str withStr:@"\n\r" withPattern:@"<br/>"];
    resultStr = [GYBRegHelper replaceGivenStr:resultStr withStr:@" " withPattern:@"&nbsp;"];
    resultStr = [GYBRegHelper replaceGivenStr:resultStr withStr:@"" withPattern:@"<.*?>"];
    
    return resultStr;
}

+ (NSTimeInterval)nowDateToNextDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    return [endDate timeIntervalSinceDate:[NSDate date]];
}


+ (CGFloat)heightForLabel:(UIFont *)font text:(NSString *)text width:(CGFloat)width {
    
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return titleSize.height;
}

//控件截图
+ (UIImage *)snapshot:(UIView *)view
{

    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
    
}
//遍历文件夹获得文件夹大小，返回多少M
+ (float) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


+ (void)removeFileByPath:(NSString *)filePath {
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) return ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:filePath] objectEnumerator];
    NSString* fileName;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [filePath stringByAppendingPathComponent:fileName];
        [manager removeItemAtPath:fileAbsolutePath error:nil];
    }

    
}

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


+(NSDictionary *)decodeByDic:(NSDictionary *)dic {
    
    if (!dic) {
        dic = @{};
    }
    
    NSMutableDictionary * mudic = [dic mutableCopy];
    NSMutableDictionary * resultDic = [dic mutableCopy];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%lf", time];
    
    
    [mudic setObject:timeString forKey:@"timestamp"];
    
    NSArray<NSString *> * keyarr = [[mudic allKeys] mutableCopy];
    //value统一转成字符串
    for (NSString *  keys in keyarr) {
        
        id value = [mudic objectForKey:keys];
        if (![value isKindOfClass:[NSString class]]) {
            [mudic setObject:[NSString stringWithFormat:@"%@",value] forKey:keys];
        }
    }
    
    
    NSArray * tempArr = [keyarr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSString * key1 = obj1;
        
        NSString * key2 = obj2;
        
        NSInteger minLength = MIN(key1.length, key2.length);
        
        for (int i = 0; i < minLength; i++) {
            
            char char1 = [key1 characterAtIndex:i];
            char char2 = [key2 characterAtIndex:i];
            
            if (char1 > char2) {
                
                return NSOrderedDescending;
            }
            else if(char1 == char2){
                
                continue;
            }
            else{
                
                return NSOrderedAscending;
            }
            
        }
        
        if (key1.length > key2.length) {
            return NSOrderedDescending;
        }
        else if (key1.length == key2.length) {
            return NSOrderedSame;
        }
        else{
            return NSOrderedAscending;
        }
        
        
        
    }];
    
    NSMutableString * muStr = [@"" mutableCopy];
    
    for (NSString * key in tempArr) {
        
        [muStr appendFormat:@"%@=%@",key,[mudic objectForKey:key]];
        
        if (![key isEqualToString:[tempArr lastObject]]) {
            [muStr appendString:@","];
        }
        
        
    }
    
    
    NSString * encodeStr = [MS_GYBDesEncode encodeStr:muStr];

    
    if (!encodeStr.length) {
        encodeStr = @"";
    }
    
    [resultDic setObject:encodeStr forKey:@"sign"];
    [resultDic setObject:timeString forKey:@"timestamp"];
    
    
    return resultDic;
    
}

+ (NSString *)componentUrl:(NSString *)url{
    
    MSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"imgBasePath"]);
    
    
    return [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"imgBasePath"],url];
    
}

+ (BOOL)compareIsHttp:(NSString *)url {

    BOOL isCompare = NO;
    if([url rangeOfString:@"http"].location !=NSNotFound)//_roaldSearchText
    {
        isCompare = YES;
    }
    else {
        
        isCompare = NO;
    }

    return isCompare;
}

//字典根据key排序
+(NSString *)getNeedSignStrFrom:(id)obj{
    NSDictionary *dict = obj;
    NSArray *arrPrimary = dict.allKeys;
    
    NSArray *arrKey = [arrPrimary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;//NSOrderedAscending 倒序
    }];
    
    NSString*str =@"";
    
    for (NSString *s in arrKey) {
        id value = dict[s];
        if([value isKindOfClass:[NSDictionary class]]) {
            value = [self getNeedSignStrFrom:value];
        }
        if([str length] !=0) {
            
            str = [str stringByAppendingString:@","];
            
        }
        
        str = [str stringByAppendingFormat:@"%@=%@",s,value];
        
    }
    NSLog(@"str:%@",str);
    
    return str;
}
@end



