//
//  WY_WLTools.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_WLTools.h"

@implementation WY_WLTools
+ (NSString *)categoryStringByNum:(NSString *)numStr {
    if (numStr.length > 4) {
           numStr = [numStr substringToIndex:4];
       }
    NSString *typeStr = @"";
    if ([numStr rangeOfString:@"5001"].length > 0) {
            typeStr = @"法律法规";
       }else if ([numStr rangeOfString:@"5002"].length > 0) {
             typeStr = @"政策发布";

       }else if ([numStr rangeOfString:@"5003"].length > 0) {
           typeStr = @"理论务实";

       }else if ([numStr rangeOfString:@"5004"].length > 0) {
            typeStr = @"案例分析";

       }else if ([numStr rangeOfString:@"5005"].length > 0) {
            typeStr = @"电子招投标";
       } else if ([numStr rangeOfString:@"002"].length > 0) {
            typeStr = @"通知公告";
       } else {
            typeStr = @"法律法规";
       }
    
    return typeStr;
}

+ (NSString *)categoryImgStringByNum:(NSString *)numStr {
    NSString *typeStr = @"";
    if (numStr.length > 4) {
        numStr = [numStr substringToIndex:4];
    }
    if ([numStr rangeOfString:@"5001"].length > 0) {
        typeStr = @"1220_falv";

    }else if ([numStr rangeOfString:@"5002"].length > 0) {
        typeStr = @"1220_articles";

    }else if ([numStr rangeOfString:@"5003"].length > 0) {
        typeStr = @"1220_caozuo";

    }else if ([numStr rangeOfString:@"5004"].length > 0) {
        typeStr = @"1220_anli";

    }else if ([numStr rangeOfString:@"5005"].length > 0) {
        typeStr = @"1220_fanben";
    } else if ([numStr rangeOfString:@"002"].length > 0) {
        typeStr = @"lb";
   } else {
        typeStr = @"1220_falv";
    }
    
    return typeStr;
}

+ (NSString *)categorySyImgStringByNum:(NSString *)numStr {
    NSString *typeStr = @"";
    if (numStr.length > 4) {
        numStr = [numStr substringToIndex:4];
    }
    if ([numStr rangeOfString:@"5001"].length > 0) {
        typeStr = @"sy_5001";

    }else if ([numStr rangeOfString:@"5002"].length > 0) {
        typeStr = @"sy_5002";

    }else if ([numStr rangeOfString:@"5003"].length > 0) {
        typeStr = @"sy_5003";

    }else if ([numStr rangeOfString:@"5004"].length > 0) {
        typeStr = @"sy_5004";

    }else if ([numStr rangeOfString:@"5005"].length > 0) {
        typeStr = @"sy_5005";
    }  else {
        typeStr = @"1220_falv";
    }
    
    return typeStr;
}

//压缩图片到指定大小
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
        NSLog(@"1-maxLength:%ld----%ld",maxLength,data.length);
        return data;
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) {
        NSLog(@"2-maxLength:%ld----%ld",maxLength,data.length);
         return data;
        
    }
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    NSLog(@"3-maxLength:%ld----%ld",maxLength,data.length);
    return data;
}

+ (NSDictionary *)zjDicGetById:(int)dicID {
    NSUserDefaults *userdefA = [NSUserDefaults standardUserDefaults];
    NSString *dicStr = [userdefA objectForKey:@"ZJ_DIC"];
    NSMutableArray *arrDicZj = [dicStr mj_JSONObject];
    
    if (arrDicZj != nil) {
        for (NSDictionary *dicZjTemp in arrDicZj) {
            if ([dicZjTemp[@"id"] intValue] == dicID  ) {
                return dicZjTemp;
            }
        }
    }
    return nil;
}
@end
